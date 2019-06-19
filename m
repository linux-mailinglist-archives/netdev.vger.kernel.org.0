Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C55A4BEBE
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730538AbfFSQr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:47:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45032 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730120AbfFSQr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 12:47:27 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 226B47CBA0;
        Wed, 19 Jun 2019 16:47:27 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-57.rdu2.redhat.com [10.10.120.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E98D60BE0;
        Wed, 19 Jun 2019 16:47:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 5/9] keys: Move the user and user-session keyrings to the
 user_namespace [ver #4]
From:   David Howells <dhowells@redhat.com>
To:     ebiederm@xmission.com, keyrings@vger.kernel.org
Cc:     linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        dhowells@redhat.com, dwalsh@redhat.com, vgoyal@redhat.com,
        linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 19 Jun 2019 17:47:20 +0100
Message-ID: <156096284077.28733.1128809354777879305.stgit@warthog.procyon.org.uk>
In-Reply-To: <156096279115.28733.8761881995303698232.stgit@warthog.procyon.org.uk>
References: <156096279115.28733.8761881995303698232.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 19 Jun 2019 16:47:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the user and user-session keyrings to the user_namespace struct rather
than pinning them from the user_struct struct.  This prevents these
keyrings from propagating across user-namespaces boundaries with regard to
the KEY_SPEC_* flags, thereby making them more useful in a containerised
environment.

The issue is that a single user_struct may be represent UIDs in several
different namespaces.

The way the patch does this is by attaching a 'register keyring' in each
user_namespace and then sticking the user and user-session keyrings into
that.  It can then be searched to retrieve them.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jann Horn <jannh@google.com>
---

 include/linux/sched/user.h     |   14 --
 include/linux/user_namespace.h |    9 +
 kernel/user.c                  |    7 -
 kernel/user_namespace.c        |    4 -
 security/keys/internal.h       |    3 
 security/keys/keyring.c        |    1 
 security/keys/persistent.c     |    8 +
 security/keys/process_keys.c   |  259 ++++++++++++++++++++++++++--------------
 security/keys/request_key.c    |   20 ++-
 9 files changed, 196 insertions(+), 129 deletions(-)

diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index 468d2565a9fe..917d88edb7b9 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -7,8 +7,6 @@
 #include <linux/refcount.h>
 #include <linux/ratelimit.h>
 
-struct key;
-
 /*
  * Some day this will be a full-fledged user tracking system..
  */
@@ -30,18 +28,6 @@ struct user_struct {
 	unsigned long unix_inflight;	/* How many files in flight in unix sockets */
 	atomic_long_t pipe_bufs;  /* how many pages are allocated in pipe buffers */
 
-#ifdef CONFIG_KEYS
-	/*
-	 * These pointers can only change from NULL to a non-NULL value once.
-	 * Writes are protected by key_user_keyring_mutex.
-	 * Unlocked readers should use READ_ONCE() unless they know that
-	 * install_user_keyrings() has been called successfully (which sets
-	 * these members to non-NULL values, preventing further modifications).
-	 */
-	struct key *uid_keyring;	/* UID specific keyring */
-	struct key *session_keyring;	/* UID's default session keyring */
-#endif
-
 	/* Hash table maintenance information */
 	struct hlist_node uidhash_node;
 	kuid_t uid;
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 90457015fa3f..fb9f4f799554 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -65,14 +65,19 @@ struct user_namespace {
 	unsigned long		flags;
 
 #ifdef CONFIG_KEYS
-	/* List of joinable keyrings in this namespace */
+	/* List of joinable keyrings in this namespace.  Modification access of
+	 * these pointers is controlled by keyring_sem.  Once
+	 * user_keyring_register is set, it won't be changed, so it can be
+	 * accessed directly with READ_ONCE().
+	 */
 	struct list_head	keyring_name_list;
+	struct key		*user_keyring_register;
+	struct rw_semaphore	keyring_sem;
 #endif
 
 	/* Register of per-UID persistent keyrings for this namespace */
 #ifdef CONFIG_PERSISTENT_KEYRINGS
 	struct key		*persistent_keyring_register;
-	struct rw_semaphore	persistent_keyring_register_sem;
 #endif
 	struct work_struct	work;
 #ifdef CONFIG_SYSCTL
diff --git a/kernel/user.c b/kernel/user.c
index 50979fd1b7aa..f8519b62cf9a 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -64,10 +64,7 @@ struct user_namespace init_user_ns = {
 	.flags = USERNS_INIT_FLAGS,
 #ifdef CONFIG_KEYS
 	.keyring_name_list = LIST_HEAD_INIT(init_user_ns.keyring_name_list),
-#endif
-#ifdef CONFIG_PERSISTENT_KEYRINGS
-	.persistent_keyring_register_sem =
-	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),
+	.keyring_sem = __RWSEM_INITIALIZER(init_user_ns.keyring_sem),
 #endif
 };
 EXPORT_SYMBOL_GPL(init_user_ns);
@@ -143,8 +140,6 @@ static void free_user(struct user_struct *up, unsigned long flags)
 {
 	uid_hash_remove(up);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
-	key_put(up->uid_keyring);
-	key_put(up->session_keyring);
 	kmem_cache_free(uid_cachep, up);
 }
 
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index bda6e890ad88..c87c2ecc7085 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -135,9 +135,7 @@ int create_user_ns(struct cred *new)
 
 #ifdef CONFIG_KEYS
 	INIT_LIST_HEAD(&ns->keyring_name_list);
-#endif
-#ifdef CONFIG_PERSISTENT_KEYRINGS
-	init_rwsem(&ns->persistent_keyring_register_sem);
+	init_rwsem(&ns->keyring_sem);
 #endif
 	ret = -ENOMEM;
 	if (!setup_userns_sysctls(ns))
diff --git a/security/keys/internal.h b/security/keys/internal.h
index aa361299a3ec..d3a9439e2386 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -148,7 +148,8 @@ extern key_ref_t search_process_keyrings_rcu(struct keyring_search_context *ctx)
 
 extern struct key *find_keyring_by_name(const char *name, bool uid_keyring);
 
-extern int install_user_keyrings(void);
+extern int look_up_user_keyrings(struct key **, struct key **);
+extern struct key *get_user_session_keyring_rcu(const struct cred *);
 extern int install_thread_keyring_to_cred(struct cred *);
 extern int install_process_keyring_to_cred(struct cred *);
 extern int install_session_keyring_to_cred(struct cred *, struct key *);
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index fe851292509e..3663e5168583 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -62,6 +62,7 @@ void key_free_user_ns(struct user_namespace *ns)
 	list_del_init(&ns->keyring_name_list);
 	write_unlock(&keyring_name_lock);
 
+	key_put(ns->user_keyring_register);
 #ifdef CONFIG_PERSISTENT_KEYRINGS
 	key_put(ns->persistent_keyring_register);
 #endif
diff --git a/security/keys/persistent.c b/security/keys/persistent.c
index fc29ec59efa7..90303fe4a394 100644
--- a/security/keys/persistent.c
+++ b/security/keys/persistent.c
@@ -91,9 +91,9 @@ static long key_get_persistent(struct user_namespace *ns, kuid_t uid,
 
 	if (ns->persistent_keyring_register) {
 		reg_ref = make_key_ref(ns->persistent_keyring_register, true);
-		down_read(&ns->persistent_keyring_register_sem);
+		down_read(&ns->keyring_sem);
 		persistent_ref = find_key_to_update(reg_ref, &index_key);
-		up_read(&ns->persistent_keyring_register_sem);
+		up_read(&ns->keyring_sem);
 
 		if (persistent_ref)
 			goto found;
@@ -102,9 +102,9 @@ static long key_get_persistent(struct user_namespace *ns, kuid_t uid,
 	/* It wasn't in the register, so we'll need to create it.  We might
 	 * also need to create the register.
 	 */
-	down_write(&ns->persistent_keyring_register_sem);
+	down_write(&ns->keyring_sem);
 	persistent_ref = key_create_persistent(ns, uid, &index_key);
-	up_write(&ns->persistent_keyring_register_sem);
+	up_write(&ns->keyring_sem);
 	if (!IS_ERR(persistent_ref))
 		goto found;
 
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index b07f768d23dc..f74d64215942 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -19,15 +19,13 @@
 #include <linux/security.h>
 #include <linux/user_namespace.h>
 #include <linux/uaccess.h>
+#include <linux/init_task.h>
 #include <keys/request_key_auth-type.h>
 #include "internal.h"
 
 /* Session keyring create vs join semaphore */
 static DEFINE_MUTEX(key_session_mutex);
 
-/* User keyring creation semaphore */
-static DEFINE_MUTEX(key_user_keyring_mutex);
-
 /* The root user's tracking struct */
 struct key_user root_key_user = {
 	.usage		= REFCOUNT_INIT(3),
@@ -39,98 +37,185 @@ struct key_user root_key_user = {
 };
 
 /*
- * Install the user and user session keyrings for the current process's UID.
+ * Get or create a user register keyring.
+ */
+static struct key *get_user_register(struct user_namespace *user_ns)
+{
+	struct key *reg_keyring = READ_ONCE(user_ns->user_keyring_register);
+
+	if (reg_keyring)
+		return reg_keyring;
+
+	down_write(&user_ns->keyring_sem);
+
+	/* Make sure there's a register keyring.  It gets owned by the
+	 * user_namespace's owner.
+	 */
+	reg_keyring = user_ns->user_keyring_register;
+	if (!reg_keyring) {
+		reg_keyring = keyring_alloc(".user_reg",
+					    user_ns->owner, INVALID_GID,
+					    &init_cred,
+					    KEY_POS_WRITE | KEY_POS_SEARCH |
+					    KEY_USR_VIEW | KEY_USR_READ,
+					    0,
+					    NULL, NULL);
+		if (!IS_ERR(reg_keyring))
+			smp_store_release(&user_ns->user_keyring_register,
+					  reg_keyring);
+	}
+
+	up_write(&user_ns->keyring_sem);
+
+	/* We don't return a ref since the keyring is pinned by the user_ns */
+	return reg_keyring;
+}
+
+/*
+ * Look up the user and user session keyrings for the current process's UID,
+ * creating them if they don't exist.
  */
-int install_user_keyrings(void)
+int look_up_user_keyrings(struct key **_user_keyring,
+			  struct key **_user_session_keyring)
 {
-	struct user_struct *user;
-	const struct cred *cred;
-	struct key *uid_keyring, *session_keyring;
+	const struct cred *cred = current_cred();
+	struct user_namespace *user_ns = current_user_ns();
+	struct key *reg_keyring, *uid_keyring, *session_keyring;
 	key_perm_t user_keyring_perm;
+	key_ref_t uid_keyring_r, session_keyring_r;
+	uid_t uid = from_kuid(user_ns, cred->user->uid);
 	char buf[20];
 	int ret;
-	uid_t uid;
 
 	user_keyring_perm = (KEY_POS_ALL & ~KEY_POS_SETATTR) | KEY_USR_ALL;
-	cred = current_cred();
-	user = cred->user;
-	uid = from_kuid(cred->user_ns, user->uid);
 
-	kenter("%p{%u}", user, uid);
+	kenter("%u", uid);
 
-	if (READ_ONCE(user->uid_keyring) && READ_ONCE(user->session_keyring)) {
-		kleave(" = 0 [exist]");
-		return 0;
-	}
+	reg_keyring = get_user_register(user_ns);
+	if (IS_ERR(reg_keyring))
+		return PTR_ERR(reg_keyring);
 
-	mutex_lock(&key_user_keyring_mutex);
+	down_write(&user_ns->keyring_sem);
 	ret = 0;
 
-	if (!user->uid_keyring) {
-		/* get the UID-specific keyring
-		 * - there may be one in existence already as it may have been
-		 *   pinned by a session, but the user_struct pointing to it
-		 *   may have been destroyed by setuid */
-		sprintf(buf, "_uid.%u", uid);
-
-		uid_keyring = find_keyring_by_name(buf, true);
+	/* Get the user keyring.  Note that there may be one in existence
+	 * already as it may have been pinned by a session, but the user_struct
+	 * pointing to it may have been destroyed by setuid.
+	 */
+	snprintf(buf, sizeof(buf), "_uid.%u", uid);
+	uid_keyring_r = keyring_search(make_key_ref(reg_keyring, true),
+				       &key_type_keyring, buf, false);
+	kdebug("_uid %p", uid_keyring_r);
+	if (uid_keyring_r == ERR_PTR(-EAGAIN)) {
+		uid_keyring = keyring_alloc(buf, cred->user->uid, INVALID_GID,
+					    cred, user_keyring_perm,
+					    KEY_ALLOC_UID_KEYRING |
+					    KEY_ALLOC_IN_QUOTA,
+					    NULL, reg_keyring);
 		if (IS_ERR(uid_keyring)) {
-			uid_keyring = keyring_alloc(buf, user->uid, INVALID_GID,
-						    cred, user_keyring_perm,
-						    KEY_ALLOC_UID_KEYRING |
-							KEY_ALLOC_IN_QUOTA,
-						    NULL, NULL);
-			if (IS_ERR(uid_keyring)) {
-				ret = PTR_ERR(uid_keyring);
-				goto error;
-			}
+			ret = PTR_ERR(uid_keyring);
+			goto error;
 		}
+	} else if (IS_ERR(uid_keyring_r)) {
+		ret = PTR_ERR(uid_keyring_r);
+		goto error;
+	} else {
+		uid_keyring = key_ref_to_ptr(uid_keyring_r);
+	}
 
-		/* get a default session keyring (which might also exist
-		 * already) */
-		sprintf(buf, "_uid_ses.%u", uid);
-
-		session_keyring = find_keyring_by_name(buf, true);
+	/* Get a default session keyring (which might also exist already) */
+	snprintf(buf, sizeof(buf), "_uid_ses.%u", uid);
+	session_keyring_r = keyring_search(make_key_ref(reg_keyring, true),
+					   &key_type_keyring, buf, false);
+	kdebug("_uid_ses %p", session_keyring_r);
+	if (session_keyring_r == ERR_PTR(-EAGAIN)) {
+		session_keyring = keyring_alloc(buf, cred->user->uid, INVALID_GID,
+						cred, user_keyring_perm,
+						KEY_ALLOC_UID_KEYRING |
+						KEY_ALLOC_IN_QUOTA,
+						NULL, NULL);
 		if (IS_ERR(session_keyring)) {
-			session_keyring =
-				keyring_alloc(buf, user->uid, INVALID_GID,
-					      cred, user_keyring_perm,
-					      KEY_ALLOC_UID_KEYRING |
-						  KEY_ALLOC_IN_QUOTA,
-					      NULL, NULL);
-			if (IS_ERR(session_keyring)) {
-				ret = PTR_ERR(session_keyring);
-				goto error_release;
-			}
-
-			/* we install a link from the user session keyring to
-			 * the user keyring */
-			ret = key_link(session_keyring, uid_keyring);
-			if (ret < 0)
-				goto error_release_both;
+			ret = PTR_ERR(session_keyring);
+			goto error_release;
 		}
 
-		/* install the keyrings */
-		/* paired with READ_ONCE() */
-		smp_store_release(&user->uid_keyring, uid_keyring);
-		/* paired with READ_ONCE() */
-		smp_store_release(&user->session_keyring, session_keyring);
+		/* We install a link from the user session keyring to
+		 * the user keyring.
+		 */
+		ret = key_link(session_keyring, uid_keyring);
+		if (ret < 0)
+			goto error_release_session;
+
+		/* And only then link the user-session keyring to the
+		 * register.
+		 */
+		ret = key_link(reg_keyring, session_keyring);
+		if (ret < 0)
+			goto error_release_session;
+	} else if (IS_ERR(session_keyring_r)) {
+		ret = PTR_ERR(session_keyring_r);
+		goto error_release;
+	} else {
+		session_keyring = key_ref_to_ptr(session_keyring_r);
 	}
 
-	mutex_unlock(&key_user_keyring_mutex);
+	up_write(&user_ns->keyring_sem);
+
+	if (_user_session_keyring)
+		*_user_session_keyring = session_keyring;
+	else
+		key_put(session_keyring);
+	if (_user_keyring)
+		*_user_keyring = uid_keyring;
+	else
+		key_put(uid_keyring);
 	kleave(" = 0");
 	return 0;
 
-error_release_both:
+error_release_session:
 	key_put(session_keyring);
 error_release:
 	key_put(uid_keyring);
 error:
-	mutex_unlock(&key_user_keyring_mutex);
+	up_write(&user_ns->keyring_sem);
 	kleave(" = %d", ret);
 	return ret;
 }
 
+/*
+ * Get the user session keyring if it exists, but don't create it if it
+ * doesn't.
+ */
+struct key *get_user_session_keyring_rcu(const struct cred *cred)
+{
+	struct key *reg_keyring = READ_ONCE(cred->user_ns->user_keyring_register);
+	key_ref_t session_keyring_r;
+	char buf[20];
+
+	struct keyring_search_context ctx = {
+		.index_key.type		= &key_type_keyring,
+		.index_key.description	= buf,
+		.cred			= cred,
+		.match_data.cmp		= key_default_cmp,
+		.match_data.raw_data	= buf,
+		.match_data.lookup_type	= KEYRING_SEARCH_LOOKUP_DIRECT,
+		.flags			= KEYRING_SEARCH_DO_STATE_CHECK,
+	};
+
+	if (!reg_keyring)
+		return NULL;
+
+	ctx.index_key.desc_len = snprintf(buf, sizeof(buf), "_uid_ses.%u",
+					  from_kuid(cred->user_ns,
+						    cred->user->uid));
+
+	session_keyring_r = keyring_search_rcu(make_key_ref(reg_keyring, true),
+					       &ctx);
+	if (IS_ERR(session_keyring_r))
+		return NULL;
+	return key_ref_to_ptr(session_keyring_r);
+}
+
 /*
  * Install a thread keyring to the given credentials struct if it didn't have
  * one already.  This is allowed to overrun the quota.
@@ -340,6 +425,7 @@ void key_fsgid_changed(struct cred *new_cred)
  */
 key_ref_t search_cred_keyrings_rcu(struct keyring_search_context *ctx)
 {
+	struct key *user_session;
 	key_ref_t key_ref, ret, err;
 	const struct cred *cred = ctx->cred;
 
@@ -415,10 +501,11 @@ key_ref_t search_cred_keyrings_rcu(struct keyring_search_context *ctx)
 		}
 	}
 	/* or search the user-session keyring */
-	else if (READ_ONCE(cred->user->session_keyring)) {
-		key_ref = keyring_search_rcu(
-			make_key_ref(READ_ONCE(cred->user->session_keyring), 1),
-			ctx);
+	else if ((user_session = get_user_session_keyring_rcu(cred))) {
+		key_ref = keyring_search_rcu(make_key_ref(user_session, 1),
+					     ctx);
+		key_put(user_session);
+
 		if (!IS_ERR(key_ref))
 			goto found;
 
@@ -535,7 +622,7 @@ key_ref_t lookup_user_key(key_serial_t id, unsigned long lflags,
 					   KEYRING_SEARCH_RECURSE),
 	};
 	struct request_key_auth *rka;
-	struct key *key;
+	struct key *key, *user_session;
 	key_ref_t key_ref, skey_ref;
 	int ret;
 
@@ -584,20 +671,20 @@ key_ref_t lookup_user_key(key_serial_t id, unsigned long lflags,
 		if (!ctx.cred->session_keyring) {
 			/* always install a session keyring upon access if one
 			 * doesn't exist yet */
-			ret = install_user_keyrings();
+			ret = look_up_user_keyrings(NULL, &user_session);
 			if (ret < 0)
 				goto error;
 			if (lflags & KEY_LOOKUP_CREATE)
 				ret = join_session_keyring(NULL);
 			else
-				ret = install_session_keyring(
-					ctx.cred->user->session_keyring);
+				ret = install_session_keyring(user_session);
 
+			key_put(user_session);
 			if (ret < 0)
 				goto error;
 			goto reget_creds;
-		} else if (ctx.cred->session_keyring ==
-			   READ_ONCE(ctx.cred->user->session_keyring) &&
+		} else if (test_bit(KEY_FLAG_UID_KEYRING,
+				    &ctx.cred->session_keyring->flags) &&
 			   lflags & KEY_LOOKUP_CREATE) {
 			ret = join_session_keyring(NULL);
 			if (ret < 0)
@@ -611,26 +698,16 @@ key_ref_t lookup_user_key(key_serial_t id, unsigned long lflags,
 		break;
 
 	case KEY_SPEC_USER_KEYRING:
-		if (!READ_ONCE(ctx.cred->user->uid_keyring)) {
-			ret = install_user_keyrings();
-			if (ret < 0)
-				goto error;
-		}
-
-		key = ctx.cred->user->uid_keyring;
-		__key_get(key);
+		ret = look_up_user_keyrings(&key, NULL);
+		if (ret < 0)
+			goto error;
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_USER_SESSION_KEYRING:
-		if (!READ_ONCE(ctx.cred->user->session_keyring)) {
-			ret = install_user_keyrings();
-			if (ret < 0)
-				goto error;
-		}
-
-		key = ctx.cred->user->session_keyring;
-		__key_get(key);
+		ret = look_up_user_keyrings(NULL, &key);
+		if (ret < 0)
+			goto error;
 		key_ref = make_key_ref(key, 1);
 		break;
 
@@ -879,7 +956,7 @@ void key_change_session_keyring(struct callback_head *twork)
  */
 static int __init init_root_keyring(void)
 {
-	return install_user_keyrings();
+	return look_up_user_keyrings(NULL, NULL);
 }
 
 late_initcall(init_root_keyring);
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 1ffd3803ce29..9201ca96c4df 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -121,7 +121,7 @@ static int call_sbin_request_key(struct key *authkey, void *aux)
 	struct request_key_auth *rka = get_request_key_auth(authkey);
 	const struct cred *cred = current_cred();
 	key_serial_t prkey, sskey;
-	struct key *key = rka->target_key, *keyring, *session;
+	struct key *key = rka->target_key, *keyring, *session, *user_session;
 	char *argv[9], *envp[3], uid_str[12], gid_str[12];
 	char key_str[12], keyring_str[3][12];
 	char desc[20];
@@ -129,9 +129,9 @@ static int call_sbin_request_key(struct key *authkey, void *aux)
 
 	kenter("{%d},{%d},%s", key->serial, authkey->serial, rka->op);
 
-	ret = install_user_keyrings();
+	ret = look_up_user_keyrings(NULL, &user_session);
 	if (ret < 0)
-		goto error_alloc;
+		goto error_us;
 
 	/* allocate a new session keyring */
 	sprintf(desc, "_req.%u", key->serial);
@@ -169,7 +169,7 @@ static int call_sbin_request_key(struct key *authkey, void *aux)
 
 	session = cred->session_keyring;
 	if (!session)
-		session = cred->user->session_keyring;
+		session = user_session;
 	sskey = session->serial;
 
 	sprintf(keyring_str[2], "%d", sskey);
@@ -211,6 +211,8 @@ static int call_sbin_request_key(struct key *authkey, void *aux)
 	key_put(keyring);
 
 error_alloc:
+	key_put(user_session);
+error_us:
 	complete_request_key(authkey, ret);
 	kleave(" = %d", ret);
 	return ret;
@@ -317,13 +319,15 @@ static int construct_get_dest_keyring(struct key **_dest_keyring)
 
 			/* fall through */
 		case KEY_REQKEY_DEFL_USER_SESSION_KEYRING:
-			dest_keyring =
-				key_get(READ_ONCE(cred->user->session_keyring));
+			ret = look_up_user_keyrings(NULL, &dest_keyring);
+			if (ret < 0)
+				return ret;
 			break;
 
 		case KEY_REQKEY_DEFL_USER_KEYRING:
-			dest_keyring =
-				key_get(READ_ONCE(cred->user->uid_keyring));
+			ret = look_up_user_keyrings(&dest_keyring, NULL);
+			if (ret < 0)
+				return ret;
 			break;
 
 		case KEY_REQKEY_DEFL_GROUP_KEYRING:

