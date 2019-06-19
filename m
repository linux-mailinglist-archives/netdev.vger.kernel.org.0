Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDC14BEDE
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbfFSQsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:48:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729681AbfFSQsG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 12:48:06 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 38C27316291E;
        Wed, 19 Jun 2019 16:48:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-57.rdu2.redhat.com [10.10.120.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CFA06134A;
        Wed, 19 Jun 2019 16:48:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 9/9] keys: Pass the network namespace into request_key
 mechanism [ver #4]
From:   David Howells <dhowells@redhat.com>
To:     ebiederm@xmission.com, keyrings@vger.kernel.org
Cc:     linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        dhowells@redhat.com, dwalsh@redhat.com, vgoyal@redhat.com,
        linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 19 Jun 2019 17:48:00 +0100
Message-ID: <156096288035.28733.13935803852854902245.stgit@warthog.procyon.org.uk>
In-Reply-To: <156096279115.28733.8761881995303698232.stgit@warthog.procyon.org.uk>
References: <156096279115.28733.8761881995303698232.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 19 Jun 2019 16:48:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a request_key_net() function and use it to pass the network
namespace domain tag into DNS revolver keys and rxrpc/AFS keys so that keys
for different domains can coexist in the same keyring.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: netdev@vger.kernel.org
cc: linux-nfs@vger.kernel.org
cc: linux-cifs@vger.kernel.org
cc: linux-afs@lists.infradead.org
---

 Documentation/security/keys/core.rst        |   28 +++++++++++++---
 Documentation/security/keys/request-key.rst |   29 ++++++++++++-----
 fs/afs/addr_list.c                          |    4 +-
 fs/afs/dynroot.c                            |    8 +++--
 fs/cifs/dns_resolve.c                       |    3 +-
 fs/nfs/dns_resolve.c                        |    3 +-
 fs/nfs/nfs4idmap.c                          |    2 +
 include/linux/dns_resolver.h                |    3 +-
 include/linux/key.h                         |   47 +++++++++++++++++++++++++--
 net/ceph/messenger.c                        |    3 +-
 net/dns_resolver/dns_query.c                |    7 +++-
 net/rxrpc/key.c                             |    4 +-
 security/keys/internal.h                    |    1 +
 security/keys/keyctl.c                      |    2 +
 security/keys/keyring.c                     |   11 ++++--
 security/keys/request_key.c                 |   39 ++++++++++++++++------
 16 files changed, 145 insertions(+), 49 deletions(-)

diff --git a/Documentation/security/keys/core.rst b/Documentation/security/keys/core.rst
index ae930ae9d590..0e74f372e58c 100644
--- a/Documentation/security/keys/core.rst
+++ b/Documentation/security/keys/core.rst
@@ -1102,26 +1102,42 @@ payload contents" for more information.
     See also Documentation/security/keys/request-key.rst.
 
 
+ *  To search for a key in a specific domain, call:
+
+	struct key *request_key_tag(const struct key_type *type,
+				    const char *description,
+				    struct key_tag *domain_tag,
+				    const char *callout_info);
+
+    This is identical to request_key(), except that a domain tag may be
+    specifies that causes search algorithm to only match keys matching that
+    tag.  The domain_tag may be NULL, specifying a global domain that is
+    separate from any nominated domain.
+
+
  *  To search for a key, passing auxiliary data to the upcaller, call::
 
 	struct key *request_key_with_auxdata(const struct key_type *type,
 					     const char *description,
+					     struct key_tag *domain_tag,
 					     const void *callout_info,
 					     size_t callout_len,
 					     void *aux);
 
-    This is identical to request_key(), except that the auxiliary data is
-    passed to the key_type->request_key() op if it exists, and the callout_info
-    is a blob of length callout_len, if given (the length may be 0).
+    This is identical to request_key_tag(), except that the auxiliary data is
+    passed to the key_type->request_key() op if it exists, and the
+    callout_info is a blob of length callout_len, if given (the length may be
+    0).
 
 
  *  To search for a key under RCU conditions, call::
 
 	struct key *request_key_rcu(const struct key_type *type,
-				    const char *description);
+				    const char *description,
+				    struct key_tag *domain_tag);
 
-    which is similar to request_key() except that it does not check for keys
-    that are under construction and it will not call out to userspace to
+    which is similar to request_key_tag() except that it does not check for
+    keys that are under construction and it will not call out to userspace to
     construct a key if it can't find a match.
 
 
diff --git a/Documentation/security/keys/request-key.rst b/Documentation/security/keys/request-key.rst
index 5a210baa583a..35f2296b704a 100644
--- a/Documentation/security/keys/request-key.rst
+++ b/Documentation/security/keys/request-key.rst
@@ -13,10 +13,18 @@ The process starts by either the kernel requesting a service by calling
 				const char *description,
 				const char *callout_info);
 
+or::
+
+	struct key *request_key_tag(const struct key_type *type,
+				    const char *description,
+				    const struct key_tag *domain_tag,
+				    const char *callout_info);
+
 or::
 
 	struct key *request_key_with_auxdata(const struct key_type *type,
 					     const char *description,
+					     const struct key_tag *domain_tag,
 					     const char *callout_info,
 					     size_t callout_len,
 					     void *aux);
@@ -24,7 +32,8 @@ or::
 or::
 
 	struct key *request_key_rcu(const struct key_type *type,
-				    const char *description);
+				    const char *description,
+				    const struct key_tag *domain_tag);
 
 Or by userspace invoking the request_key system call::
 
@@ -38,14 +47,18 @@ does not need to link the key to a keyring to prevent it from being immediately
 destroyed.  The kernel interface returns a pointer directly to the key, and
 it's up to the caller to destroy the key.
 
-The request_key_with_auxdata() calls is like the in-kernel request_key() call,
-except that they permit auxiliary data to be passed to the upcaller (the
-default is NULL).  This is only useful for those key types that define their
-own upcall mechanism rather than using /sbin/request-key.
+The request_key_tag() call is like the in-kernel request_key(), except that it
+also takes a domain tag that allows keys to be separated by namespace and
+killed off as a group.
+
+The request_key_with_auxdata() calls is like the request_key_tag() call, except
+that they permit auxiliary data to be passed to the upcaller (the default is
+NULL).  This is only useful for those key types that define their own upcall
+mechanism rather than using /sbin/request-key.
 
-The request_key_rcu() call is like the in-kernel request_key() call, except
-that it doesn't check for keys that are under construction and doesn't attempt
-to construct missing keys.
+The request_key_rcu() call is like the request_key_tag() call, except that it
+doesn't check for keys that are under construction and doesn't attempt to
+construct missing keys.
 
 The userspace interface links the key to a keyring associated with the process
 to prevent the key from going away, and returns the serial number of the key to
diff --git a/fs/afs/addr_list.c b/fs/afs/addr_list.c
index 9eaff55df7b4..6b1e8fc6c954 100644
--- a/fs/afs/addr_list.c
+++ b/fs/afs/addr_list.c
@@ -250,8 +250,8 @@ struct afs_vlserver_list *afs_dns_query(struct afs_cell *cell, time64_t *_expiry
 
 	_enter("%s", cell->name);
 
-	ret = dns_query("afsdb", cell->name, cell->name_len, "srv=1",
-			&result, _expiry, true);
+	ret = dns_query(cell->net->net, "afsdb", cell->name, cell->name_len,
+			"srv=1", &result, _expiry, true);
 	if (ret < 0) {
 		_leave(" = %d [dns]", ret);
 		return ERR_PTR(ret);
diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index af1689d1f32e..b075605b0c45 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -28,6 +28,7 @@ const struct file_operations afs_dynroot_file_operations = {
 static int afs_probe_cell_name(struct dentry *dentry)
 {
 	struct afs_cell *cell;
+	struct afs_net *net = afs_d2net(dentry);
 	const char *name = dentry->d_name.name;
 	size_t len = dentry->d_name.len;
 	int ret;
@@ -40,13 +41,14 @@ static int afs_probe_cell_name(struct dentry *dentry)
 		len--;
 	}
 
-	cell = afs_lookup_cell_rcu(afs_d2net(dentry), name, len);
+	cell = afs_lookup_cell_rcu(net, name, len);
 	if (!IS_ERR(cell)) {
-		afs_put_cell(afs_d2net(dentry), cell);
+		afs_put_cell(net, cell);
 		return 0;
 	}
 
-	ret = dns_query("afsdb", name, len, "srv=1", NULL, NULL, false);
+	ret = dns_query(net->net, "afsdb", name, len, "srv=1",
+			NULL, NULL, false);
 	if (ret == -ENODATA)
 		ret = -EDESTADDRREQ;
 	return ret;
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 1e21b2528cfb..534cbba72789 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -77,7 +77,8 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 		goto name_is_IP_address;
 
 	/* Perform the upcall */
-	rc = dns_query(NULL, hostname, len, NULL, ip_addr, NULL, false);
+	rc = dns_query(current->nsproxy->net_ns, NULL, hostname, len,
+		       NULL, ip_addr, NULL, false);
 	if (rc < 0)
 		cifs_dbg(FYI, "%s: unable to resolve: %*.*s\n",
 			 __func__, len, len, hostname);
diff --git a/fs/nfs/dns_resolve.c b/fs/nfs/dns_resolve.c
index e6a700f01452..aec769a500a1 100644
--- a/fs/nfs/dns_resolve.c
+++ b/fs/nfs/dns_resolve.c
@@ -22,7 +22,8 @@ ssize_t nfs_dns_resolve_name(struct net *net, char *name, size_t namelen,
 	char *ip_addr = NULL;
 	int ip_len;
 
-	ip_len = dns_query(NULL, name, namelen, NULL, &ip_addr, NULL, false);
+	ip_len = dns_query(net, NULL, name, namelen, NULL, &ip_addr, NULL,
+			   false);
 	if (ip_len > 0)
 		ret = rpc_pton(net, ip_addr, ip_len, sa, salen);
 	else
diff --git a/fs/nfs/nfs4idmap.c b/fs/nfs/nfs4idmap.c
index 4884fdae28fb..1e7296395d71 100644
--- a/fs/nfs/nfs4idmap.c
+++ b/fs/nfs/nfs4idmap.c
@@ -291,7 +291,7 @@ static struct key *nfs_idmap_request_key(const char *name, size_t namelen,
 	if (IS_ERR(rkey)) {
 		mutex_lock(&idmap->idmap_mutex);
 		rkey = request_key_with_auxdata(&key_type_id_resolver_legacy,
-						desc, "", 0, idmap);
+						desc, NULL, "", 0, idmap);
 		mutex_unlock(&idmap->idmap_mutex);
 	}
 	if (!IS_ERR(rkey))
diff --git a/include/linux/dns_resolver.h b/include/linux/dns_resolver.h
index f2b3ae22e6b7..976cbbdb2832 100644
--- a/include/linux/dns_resolver.h
+++ b/include/linux/dns_resolver.h
@@ -26,7 +26,8 @@
 
 #include <uapi/linux/dns_resolver.h>
 
-extern int dns_query(const char *type, const char *name, size_t namelen,
+struct net;
+extern int dns_query(struct net *net, const char *type, const char *name, size_t namelen,
 		     const char *options, char **_result, time64_t *_expiry,
 		     bool invalidate);
 
diff --git a/include/linux/key.h b/include/linux/key.h
index 60c076c6e47f..18d7f62ab6b0 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -36,6 +36,7 @@ typedef int32_t key_serial_t;
 typedef uint32_t key_perm_t;
 
 struct key;
+struct net;
 
 #ifdef CONFIG_KEYS
 
@@ -296,19 +297,57 @@ static inline void key_ref_put(key_ref_t key_ref)
 	key_put(key_ref_to_ptr(key_ref));
 }
 
-extern struct key *request_key(struct key_type *type,
-			       const char *description,
-			       const char *callout_info);
+extern struct key *request_key_tag(struct key_type *type,
+				   const char *description,
+				   struct key_tag *domain_tag,
+				   const char *callout_info);
 
 extern struct key *request_key_rcu(struct key_type *type,
-				   const char *description);
+				   const char *description,
+				   struct key_tag *domain_tag);
 
 extern struct key *request_key_with_auxdata(struct key_type *type,
 					    const char *description,
+					    struct key_tag *domain_tag,
 					    const void *callout_info,
 					    size_t callout_len,
 					    void *aux);
 
+/**
+ * request_key - Request a key and wait for construction
+ * @type: Type of key.
+ * @description: The searchable description of the key.
+ * @callout_info: The data to pass to the instantiation upcall (or NULL).
+ *
+ * As for request_key_tag(), but with the default global domain tag.
+ */
+static inline struct key *request_key(struct key_type *type,
+				      const char *description,
+				      const char *callout_info)
+{
+	return request_key_tag(type, description, NULL, callout_info);
+}
+
+#ifdef CONFIG_NET
+/*
+ * request_key_net - Request a key for a net namespace and wait for construction
+ * @type: Type of key.
+ * @description: The searchable description of the key.
+ * @net: The network namespace that is the key's domain of operation.
+ * @callout_info: The data to pass to the instantiation upcall (or NULL).
+ *
+ * As for request_key() except that it does not add the returned key to a
+ * keyring if found, new keys are always allocated in the user's quota, the
+ * callout_info must be a NUL-terminated string and no auxiliary data can be
+ * passed.  Only keys that operate the specified network namespace are used.
+ *
+ * Furthermore, it then works as wait_for_key_construction() to wait for the
+ * completion of keys undergoing construction with a non-interruptible wait.
+ */
+#define request_key_net(type, description, net, callout_info) \
+	request_key_tag(type, description, net->key_domain, callout_info);
+#endif /* CONFIG_NET */
+
 extern int wait_for_key_construction(struct key *key, bool intr);
 
 extern int key_validate(const struct key *key);
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index cd0b094468b6..a33402c99321 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1887,7 +1887,8 @@ static int ceph_dns_resolve_name(const char *name, size_t namelen,
 		return -EINVAL;
 
 	/* do dns_resolve upcall */
-	ip_len = dns_query(NULL, name, end - name, NULL, &ip_addr, NULL, false);
+	ip_len = dns_query(current->nsproxy->net_ns,
+			   NULL, name, end - name, NULL, &ip_addr, NULL, false);
 	if (ip_len > 0)
 		ret = ceph_pton(ip_addr, ip_len, addr, -1, NULL);
 	else
diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index 2d260432b3be..cab4e0df924f 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -40,6 +40,7 @@
 #include <linux/cred.h>
 #include <linux/dns_resolver.h>
 #include <linux/err.h>
+#include <net/net_namespace.h>
 
 #include <keys/dns_resolver-type.h>
 #include <keys/user-type.h>
@@ -48,6 +49,7 @@
 
 /**
  * dns_query - Query the DNS
+ * @net: The network namespace to operate in.
  * @type: Query type (or NULL for straight host->IP lookup)
  * @name: Name to look up
  * @namelen: Length of name
@@ -69,7 +71,8 @@
  *
  * Returns the size of the result on success, -ve error code otherwise.
  */
-int dns_query(const char *type, const char *name, size_t namelen,
+int dns_query(struct net *net,
+	      const char *type, const char *name, size_t namelen,
 	      const char *options, char **_result, time64_t *_expiry,
 	      bool invalidate)
 {
@@ -122,7 +125,7 @@ int dns_query(const char *type, const char *name, size_t namelen,
 	 * add_key() to preinstall malicious redirections
 	 */
 	saved_cred = override_creds(dns_resolver_cache);
-	rkey = request_key(&key_type_dns_resolver, desc, options);
+	rkey = request_key_net(&key_type_dns_resolver, desc, net, options);
 	revert_creds(saved_cred);
 	kfree(desc);
 	if (IS_ERR(rkey)) {
diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 2722189ec273..1cc6b0c6cc42 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -914,7 +914,7 @@ int rxrpc_request_key(struct rxrpc_sock *rx, char __user *optval, int optlen)
 	if (IS_ERR(description))
 		return PTR_ERR(description);
 
-	key = request_key(&key_type_rxrpc, description, NULL);
+	key = request_key_net(&key_type_rxrpc, description, sock_net(&rx->sk), NULL);
 	if (IS_ERR(key)) {
 		kfree(description);
 		_leave(" = %ld", PTR_ERR(key));
@@ -945,7 +945,7 @@ int rxrpc_server_keyring(struct rxrpc_sock *rx, char __user *optval,
 	if (IS_ERR(description))
 		return PTR_ERR(description);
 
-	key = request_key(&key_type_keyring, description, NULL);
+	key = request_key_net(&key_type_keyring, description, sock_net(&rx->sk), NULL);
 	if (IS_ERR(key)) {
 		kfree(description);
 		_leave(" = %ld", PTR_ERR(key));
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 5a561f5f199e..f1f2b076f3a1 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -156,6 +156,7 @@ extern int install_session_keyring_to_cred(struct cred *, struct key *);
 
 extern struct key *request_key_and_link(struct key_type *type,
 					const char *description,
+					struct key_tag *domain_tag,
 					const void *callout_info,
 					size_t callout_len,
 					void *aux,
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index aa9be531e5f5..8d115825198c 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -224,7 +224,7 @@ SYSCALL_DEFINE4(request_key, const char __user *, _type,
 	}
 
 	/* do the search */
-	key = request_key_and_link(ktype, description, callout_info,
+	key = request_key_and_link(ktype, description, NULL, callout_info,
 				   callout_len, NULL, key_ref_to_ptr(dest_ref),
 				   KEY_ALLOC_IN_QUOTA);
 	if (IS_ERR(key)) {
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index bca070f6ab46..29c31585ed61 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -222,10 +222,13 @@ void key_set_index_key(struct keyring_index_key *index_key)
 
 	memcpy(index_key->desc, index_key->description, n);
 
-	if (index_key->type->flags & KEY_TYPE_NET_DOMAIN)
-		index_key->domain_tag = current->nsproxy->net_ns->key_domain;
-	else
-		index_key->domain_tag = &default_domain_tag;
+	if (!index_key->domain_tag) {
+		if (index_key->type->flags & KEY_TYPE_NET_DOMAIN)
+			index_key->domain_tag = current->nsproxy->net_ns->key_domain;
+		else
+			index_key->domain_tag = &default_domain_tag;
+	}
+
 	hash_key_type_and_desc(index_key);
 }
 
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 9201ca96c4df..aa589d3c90e2 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/keyctl.h>
 #include <linux/slab.h>
+#include <net/net_namespace.h>
 #include "internal.h"
 #include <keys/request_key_auth-type.h>
 
@@ -533,16 +534,18 @@ static struct key *construct_key_and_link(struct keyring_search_context *ctx,
  * request_key_and_link - Request a key and cache it in a keyring.
  * @type: The type of key we want.
  * @description: The searchable description of the key.
+ * @domain_tag: The domain in which the key operates.
  * @callout_info: The data to pass to the instantiation upcall (or NULL).
  * @callout_len: The length of callout_info.
  * @aux: Auxiliary data for the upcall.
  * @dest_keyring: Where to cache the key.
  * @flags: Flags to key_alloc().
  *
- * A key matching the specified criteria is searched for in the process's
- * keyrings and returned with its usage count incremented if found.  Otherwise,
- * if callout_info is not NULL, a key will be allocated and some service
- * (probably in userspace) will be asked to instantiate it.
+ * A key matching the specified criteria (type, description, domain_tag) is
+ * searched for in the process's keyrings and returned with its usage count
+ * incremented if found.  Otherwise, if callout_info is not NULL, a key will be
+ * allocated and some service (probably in userspace) will be asked to
+ * instantiate it.
  *
  * If successfully found or created, the key will be linked to the destination
  * keyring if one is provided.
@@ -558,6 +561,7 @@ static struct key *construct_key_and_link(struct keyring_search_context *ctx,
  */
 struct key *request_key_and_link(struct key_type *type,
 				 const char *description,
+				 struct key_tag *domain_tag,
 				 const void *callout_info,
 				 size_t callout_len,
 				 void *aux,
@@ -566,6 +570,7 @@ struct key *request_key_and_link(struct key_type *type,
 {
 	struct keyring_search_context ctx = {
 		.index_key.type		= type,
+		.index_key.domain_tag	= domain_tag,
 		.index_key.description	= description,
 		.index_key.desc_len	= strlen(description),
 		.cred			= current_cred(),
@@ -672,9 +677,10 @@ int wait_for_key_construction(struct key *key, bool intr)
 EXPORT_SYMBOL(wait_for_key_construction);
 
 /**
- * request_key - Request a key and wait for construction
+ * request_key_tag - Request a key and wait for construction
  * @type: Type of key.
  * @description: The searchable description of the key.
+ * @domain_tag: The domain in which the key operates.
  * @callout_info: The data to pass to the instantiation upcall (or NULL).
  *
  * As for request_key_and_link() except that it does not add the returned key
@@ -685,9 +691,10 @@ EXPORT_SYMBOL(wait_for_key_construction);
  * Furthermore, it then works as wait_for_key_construction() to wait for the
  * completion of keys undergoing construction with a non-interruptible wait.
  */
-struct key *request_key(struct key_type *type,
-			const char *description,
-			const char *callout_info)
+struct key *request_key_tag(struct key_type *type,
+			    const char *description,
+			    struct key_tag *domain_tag,
+			    const char *callout_info)
 {
 	struct key *key;
 	size_t callout_len = 0;
@@ -695,7 +702,8 @@ struct key *request_key(struct key_type *type,
 
 	if (callout_info)
 		callout_len = strlen(callout_info);
-	key = request_key_and_link(type, description, callout_info, callout_len,
+	key = request_key_and_link(type, description, domain_tag,
+				   callout_info, callout_len,
 				   NULL, NULL, KEY_ALLOC_IN_QUOTA);
 	if (!IS_ERR(key)) {
 		ret = wait_for_key_construction(key, false);
@@ -706,12 +714,13 @@ struct key *request_key(struct key_type *type,
 	}
 	return key;
 }
-EXPORT_SYMBOL(request_key);
+EXPORT_SYMBOL(request_key_tag);
 
 /**
  * request_key_with_auxdata - Request a key with auxiliary data for the upcaller
  * @type: The type of key we want.
  * @description: The searchable description of the key.
+ * @domain_tag: The domain in which the key operates.
  * @callout_info: The data to pass to the instantiation upcall (or NULL).
  * @callout_len: The length of callout_info.
  * @aux: Auxiliary data for the upcall.
@@ -724,6 +733,7 @@ EXPORT_SYMBOL(request_key);
  */
 struct key *request_key_with_auxdata(struct key_type *type,
 				     const char *description,
+				     struct key_tag *domain_tag,
 				     const void *callout_info,
 				     size_t callout_len,
 				     void *aux)
@@ -731,7 +741,8 @@ struct key *request_key_with_auxdata(struct key_type *type,
 	struct key *key;
 	int ret;
 
-	key = request_key_and_link(type, description, callout_info, callout_len,
+	key = request_key_and_link(type, description, domain_tag,
+				   callout_info, callout_len,
 				   aux, NULL, KEY_ALLOC_IN_QUOTA);
 	if (!IS_ERR(key)) {
 		ret = wait_for_key_construction(key, false);
@@ -748,6 +759,7 @@ EXPORT_SYMBOL(request_key_with_auxdata);
  * request_key_rcu - Request key from RCU-read-locked context
  * @type: The type of key we want.
  * @description: The name of the key we want.
+ * @domain_tag: The domain in which the key operates.
  *
  * Request a key from a context that we may not sleep in (such as RCU-mode
  * pathwalk).  Keys under construction are ignored.
@@ -755,10 +767,13 @@ EXPORT_SYMBOL(request_key_with_auxdata);
  * Return a pointer to the found key if successful, -ENOKEY if we couldn't find
  * a key or some other error if the key found was unsuitable or inaccessible.
  */
-struct key *request_key_rcu(struct key_type *type, const char *description)
+struct key *request_key_rcu(struct key_type *type,
+			    const char *description,
+			    struct key_tag *domain_tag)
 {
 	struct keyring_search_context ctx = {
 		.index_key.type		= type,
+		.index_key.domain_tag	= domain_tag,
 		.index_key.description	= description,
 		.index_key.desc_len	= strlen(description),
 		.cred			= current_cred(),

