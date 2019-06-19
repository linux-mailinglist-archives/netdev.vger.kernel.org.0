Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E25774BEB5
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730504AbfFSQrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:47:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbfFSQrQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 12:47:16 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88A4530BB551;
        Wed, 19 Jun 2019 16:47:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-57.rdu2.redhat.com [10.10.120.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B0BF5B683;
        Wed, 19 Jun 2019 16:47:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 4/9] keys: Namespace keyring names [ver #4]
From:   David Howells <dhowells@redhat.com>
To:     ebiederm@xmission.com, keyrings@vger.kernel.org
Cc:     linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        dhowells@redhat.com, dwalsh@redhat.com, vgoyal@redhat.com,
        linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 19 Jun 2019 17:47:12 +0100
Message-ID: <156096283248.28733.3232554427821180571.stgit@warthog.procyon.org.uk>
In-Reply-To: <156096279115.28733.8761881995303698232.stgit@warthog.procyon.org.uk>
References: <156096279115.28733.8761881995303698232.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 19 Jun 2019 16:47:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keyring names are held in a single global list that any process can pick
from by means of keyctl_join_session_keyring (provided the keyring grants
Search permission).  This isn't very container friendly, however.

Make the following changes:

 (1) Make default session, process and thread keyring names begin with a
     '.' instead of '_'.

 (2) Keyrings whose names begin with a '.' aren't added to the list.  Such
     keyrings are system specials.

 (3) Replace the global list with per-user_namespace lists.  A keyring adds
     its name to the list for the user_namespace that it is currently in.

 (4) When a user_namespace is deleted, it just removes itself from the
     keyring name list.

The global keyring_name_lock is retained for accessing the name lists.
This allows (4) to work.

This can be tested by:

	# keyctl newring foo @s
	995906392
	# unshare -U
	$ keyctl show
	...
	 995906392 --alswrv  65534 65534   \_ keyring: foo
	...
	$ keyctl session foo
	Joined session keyring: 935622349

As can be seen, a new session keyring was created.

The capability bit KEYCTL_CAPS1_NS_KEYRING_NAME is set if the kernel is
employing this feature.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Eric W. Biederman <ebiederm@xmission.com>
---

 include/linux/key.h            |    2 +
 include/linux/user_namespace.h |    5 ++
 include/uapi/linux/keyctl.h    |    1 
 kernel/user.c                  |    3 +
 kernel/user_namespace.c        |    7 ++-
 security/keys/keyctl.c         |    3 +
 security/keys/keyring.c        |   99 +++++++++++++++++-----------------------
 7 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index ff102731b3db..ae1177302d70 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -361,6 +361,7 @@ extern void key_set_timeout(struct key *, unsigned);
 
 extern key_ref_t lookup_user_key(key_serial_t id, unsigned long flags,
 				 key_perm_t perm);
+extern void key_free_user_ns(struct user_namespace *);
 
 /*
  * The permissions required on a key that we're looking up.
@@ -434,6 +435,7 @@ extern void key_init(void);
 #define key_fsuid_changed(c)		do { } while(0)
 #define key_fsgid_changed(c)		do { } while(0)
 #define key_init()			do { } while(0)
+#define key_free_user_ns(ns)		do { } while(0)
 
 #endif /* CONFIG_KEYS */
 #endif /* __KERNEL__ */
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index d6b74b91096b..90457015fa3f 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -64,6 +64,11 @@ struct user_namespace {
 	struct ns_common	ns;
 	unsigned long		flags;
 
+#ifdef CONFIG_KEYS
+	/* List of joinable keyrings in this namespace */
+	struct list_head	keyring_name_list;
+#endif
+
 	/* Register of per-UID persistent keyrings for this namespace */
 #ifdef CONFIG_PERSISTENT_KEYRINGS
 	struct key		*persistent_keyring_register;
diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
index 551b5814f53e..35b405034674 100644
--- a/include/uapi/linux/keyctl.h
+++ b/include/uapi/linux/keyctl.h
@@ -128,5 +128,6 @@ struct keyctl_pkey_params {
 #define KEYCTL_CAPS0_INVALIDATE		0x20 /* KEYCTL_INVALIDATE supported */
 #define KEYCTL_CAPS0_RESTRICT_KEYRING	0x40 /* KEYCTL_RESTRICT_KEYRING supported */
 #define KEYCTL_CAPS0_MOVE		0x80 /* KEYCTL_MOVE supported */
+#define KEYCTL_CAPS1_NS_KEYRING_NAME	0x01 /* Keyring names are per-user_namespace */
 
 #endif /*  _LINUX_KEYCTL_H */
diff --git a/kernel/user.c b/kernel/user.c
index 88b834f0eebc..50979fd1b7aa 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -62,6 +62,9 @@ struct user_namespace init_user_ns = {
 	.ns.ops = &userns_operations,
 #endif
 	.flags = USERNS_INIT_FLAGS,
+#ifdef CONFIG_KEYS
+	.keyring_name_list = LIST_HEAD_INIT(init_user_ns.keyring_name_list),
+#endif
 #ifdef CONFIG_PERSISTENT_KEYRINGS
 	.persistent_keyring_register_sem =
 	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 923414a246e9..bda6e890ad88 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -133,6 +133,9 @@ int create_user_ns(struct cred *new)
 	ns->flags = parent_ns->flags;
 	mutex_unlock(&userns_state_mutex);
 
+#ifdef CONFIG_KEYS
+	INIT_LIST_HEAD(&ns->keyring_name_list);
+#endif
 #ifdef CONFIG_PERSISTENT_KEYRINGS
 	init_rwsem(&ns->persistent_keyring_register_sem);
 #endif
@@ -196,9 +199,7 @@ static void free_user_ns(struct work_struct *work)
 			kfree(ns->projid_map.reverse);
 		}
 		retire_userns_sysctls(ns);
-#ifdef CONFIG_PERSISTENT_KEYRINGS
-		key_put(ns->persistent_keyring_register);
-#endif
+		key_free_user_ns(ns);
 		ns_free_inum(&ns->ns);
 		kmem_cache_free(user_ns_cachep, ns);
 		dec_user_namespaces(ucounts);
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 169409b611b0..8a813220f269 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -30,7 +30,7 @@
 
 #define KEY_MAX_DESC_SIZE 4096
 
-static const unsigned char keyrings_capabilities[1] = {
+static const unsigned char keyrings_capabilities[2] = {
 	[0] = (KEYCTL_CAPS0_CAPABILITIES |
 	       (IS_ENABLED(CONFIG_PERSISTENT_KEYRINGS)	? KEYCTL_CAPS0_PERSISTENT_KEYRINGS : 0) |
 	       (IS_ENABLED(CONFIG_KEY_DH_OPERATIONS)	? KEYCTL_CAPS0_DIFFIE_HELLMAN : 0) |
@@ -40,6 +40,7 @@ static const unsigned char keyrings_capabilities[1] = {
 	       KEYCTL_CAPS0_RESTRICT_KEYRING |
 	       KEYCTL_CAPS0_MOVE
 	       ),
+	[1] = (KEYCTL_CAPS1_NS_KEYRING_NAME),
 };
 
 static int key_get_type_from_user(char *type,
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 20891cd198f0..fe851292509e 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -16,6 +16,7 @@
 #include <linux/security.h>
 #include <linux/seq_file.h>
 #include <linux/err.h>
+#include <linux/user_namespace.h>
 #include <keys/keyring-type.h>
 #include <keys/user-type.h>
 #include <linux/assoc_array_priv.h>
@@ -28,11 +29,6 @@
  */
 #define KEYRING_SEARCH_MAX_DEPTH 6
 
-/*
- * We keep all named keyrings in a hash to speed looking them up.
- */
-#define KEYRING_NAME_HASH_SIZE	(1 << 5)
-
 /*
  * We mark pointers we pass to the associative array with bit 1 set if
  * they're keyrings and clear otherwise.
@@ -55,17 +51,20 @@ static inline void *keyring_key_to_ptr(struct key *key)
 	return key;
 }
 
-static struct list_head	keyring_name_hash[KEYRING_NAME_HASH_SIZE];
 static DEFINE_RWLOCK(keyring_name_lock);
 
-static inline unsigned keyring_hash(const char *desc)
+/*
+ * Clean up the bits of user_namespace that belong to us.
+ */
+void key_free_user_ns(struct user_namespace *ns)
 {
-	unsigned bucket = 0;
-
-	for (; *desc; desc++)
-		bucket += (unsigned char)*desc;
+	write_lock(&keyring_name_lock);
+	list_del_init(&ns->keyring_name_list);
+	write_unlock(&keyring_name_lock);
 
-	return bucket & (KEYRING_NAME_HASH_SIZE - 1);
+#ifdef CONFIG_PERSISTENT_KEYRINGS
+	key_put(ns->persistent_keyring_register);
+#endif
 }
 
 /*
@@ -104,23 +103,17 @@ static DEFINE_MUTEX(keyring_serialise_link_lock);
 
 /*
  * Publish the name of a keyring so that it can be found by name (if it has
- * one).
+ * one and it doesn't begin with a dot).
  */
 static void keyring_publish_name(struct key *keyring)
 {
-	int bucket;
-
-	if (keyring->description) {
-		bucket = keyring_hash(keyring->description);
+	struct user_namespace *ns = current_user_ns();
 
+	if (keyring->description &&
+	    keyring->description[0] &&
+	    keyring->description[0] != '.') {
 		write_lock(&keyring_name_lock);
-
-		if (!keyring_name_hash[bucket].next)
-			INIT_LIST_HEAD(&keyring_name_hash[bucket]);
-
-		list_add_tail(&keyring->name_link,
-			      &keyring_name_hash[bucket]);
-
+		list_add_tail(&keyring->name_link, &ns->keyring_name_list);
 		write_unlock(&keyring_name_lock);
 	}
 }
@@ -1097,50 +1090,44 @@ key_ref_t find_key_to_update(key_ref_t keyring_ref,
  */
 struct key *find_keyring_by_name(const char *name, bool uid_keyring)
 {
+	struct user_namespace *ns = current_user_ns();
 	struct key *keyring;
-	int bucket;
 
 	if (!name)
 		return ERR_PTR(-EINVAL);
 
-	bucket = keyring_hash(name);
-
 	read_lock(&keyring_name_lock);
 
-	if (keyring_name_hash[bucket].next) {
-		/* search this hash bucket for a keyring with a matching name
-		 * that's readable and that hasn't been revoked */
-		list_for_each_entry(keyring,
-				    &keyring_name_hash[bucket],
-				    name_link
-				    ) {
-			if (!kuid_has_mapping(current_user_ns(), keyring->user->uid))
-				continue;
-
-			if (test_bit(KEY_FLAG_REVOKED, &keyring->flags))
-				continue;
+	/* Search this hash bucket for a keyring with a matching name that
+	 * grants Search permission and that hasn't been revoked
+	 */
+	list_for_each_entry(keyring, &ns->keyring_name_list, name_link) {
+		if (!kuid_has_mapping(ns, keyring->user->uid))
+			continue;
 
-			if (strcmp(keyring->description, name) != 0)
-				continue;
+		if (test_bit(KEY_FLAG_REVOKED, &keyring->flags))
+			continue;
 
-			if (uid_keyring) {
-				if (!test_bit(KEY_FLAG_UID_KEYRING,
-					      &keyring->flags))
-					continue;
-			} else {
-				if (key_permission(make_key_ref(keyring, 0),
-						   KEY_NEED_SEARCH) < 0)
-					continue;
-			}
+		if (strcmp(keyring->description, name) != 0)
+			continue;
 
-			/* we've got a match but we might end up racing with
-			 * key_cleanup() if the keyring is currently 'dead'
-			 * (ie. it has a zero usage count) */
-			if (!refcount_inc_not_zero(&keyring->usage))
+		if (uid_keyring) {
+			if (!test_bit(KEY_FLAG_UID_KEYRING,
+				      &keyring->flags))
+				continue;
+		} else {
+			if (key_permission(make_key_ref(keyring, 0),
+					   KEY_NEED_SEARCH) < 0)
 				continue;
-			keyring->last_used_at = ktime_get_real_seconds();
-			goto out;
 		}
+
+		/* we've got a match but we might end up racing with
+		 * key_cleanup() if the keyring is currently 'dead'
+		 * (ie. it has a zero usage count) */
+		if (!refcount_inc_not_zero(&keyring->usage))
+			continue;
+		keyring->last_used_at = ktime_get_real_seconds();
+		goto out;
 	}
 
 	keyring = ERR_PTR(-ENOKEY);

