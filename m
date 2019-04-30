Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5C3FC66
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 17:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfD3PIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 11:08:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbfD3PIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 11:08:20 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 24F8599C1D;
        Tue, 30 Apr 2019 15:08:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-61.rdu2.redhat.com [10.10.120.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF8962BE74;
        Tue, 30 Apr 2019 15:08:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 11/11] keys: Pass the network namespace into request_key
 mechanism [ver #2]
From:   David Howells <dhowells@redhat.com>
To:     ebiederm@xmission.com
Cc:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        keyrings@vger.kernel.org, dhowells@redhat.com,
        linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwalsh@redhat.com, vgoyal@redhat.com
Date:   Tue, 30 Apr 2019 16:08:13 +0100
Message-ID: <155663689291.31331.12547059668009374278.stgit@warthog.procyon.org.uk>
In-Reply-To: <155663679069.31331.3777091898004242996.stgit@warthog.procyon.org.uk>
References: <155663679069.31331.3777091898004242996.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 30 Apr 2019 15:08:18 +0000 (UTC)
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

 fs/afs/addr_list.c           |    4 +--
 fs/afs/dynroot.c             |    7 +++--
 fs/cifs/dns_resolve.c        |    3 +-
 fs/nfs/dns_resolve.c         |    2 +
 include/linux/dns_resolver.h |    3 +-
 include/linux/key.h          |    6 ++++
 net/ceph/messenger.c         |    3 +-
 net/dns_resolver/dns_query.c |    6 +++-
 net/rxrpc/key.c              |    4 +--
 security/keys/internal.h     |    1 +
 security/keys/keyctl.c       |    2 +
 security/keys/keyring.c      |   11 +++++---
 security/keys/request_key.c  |   58 ++++++++++++++++++++++++++++++++++++++----
 13 files changed, 86 insertions(+), 24 deletions(-)

diff --git a/fs/afs/addr_list.c b/fs/afs/addr_list.c
index 967db336d11a..bf8ddac5f402 100644
--- a/fs/afs/addr_list.c
+++ b/fs/afs/addr_list.c
@@ -250,8 +250,8 @@ struct afs_vlserver_list *afs_dns_query(struct afs_cell *cell, time64_t *_expiry
 
 	_enter("%s", cell->name);
 
-	ret = dns_query("afsdb", cell->name, cell->name_len, "srv=1",
-			&result, _expiry);
+	ret = dns_query(cell->net->net, "afsdb", cell->name, cell->name_len,
+			"srv=1", &result, _expiry);
 	if (ret < 0) {
 		_leave(" = %d [dns]", ret);
 		return ERR_PTR(ret);
diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index a9ba81ddf154..07d010cd28e2 100644
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
@@ -40,13 +41,13 @@ static int afs_probe_cell_name(struct dentry *dentry)
 		len--;
 	}
 
-	cell = afs_lookup_cell_rcu(afs_d2net(dentry), name, len);
+	cell = afs_lookup_cell_rcu(net, name, len);
 	if (!IS_ERR(cell)) {
-		afs_put_cell(afs_d2net(dentry), cell);
+		afs_put_cell(net, cell);
 		return 0;
 	}
 
-	ret = dns_query("afsdb", name, len, "srv=1", NULL, NULL);
+	ret = dns_query(net->net, "afsdb", name, len, "srv=1", NULL, NULL);
 	if (ret == -ENODATA)
 		ret = -EDESTADDRREQ;
 	return ret;
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 7ede7306599f..1239aa1b5d27 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -77,7 +77,8 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 		goto name_is_IP_address;
 
 	/* Perform the upcall */
-	rc = dns_query(NULL, hostname, len, NULL, ip_addr, NULL);
+	rc = dns_query(current->nsproxy->net_ns, NULL, hostname, len,
+		       NULL, ip_addr, NULL);
 	if (rc < 0)
 		cifs_dbg(FYI, "%s: unable to resolve: %*.*s\n",
 			 __func__, len, len, hostname);
diff --git a/fs/nfs/dns_resolve.c b/fs/nfs/dns_resolve.c
index a7d3df85736d..8611d4b81b0e 100644
--- a/fs/nfs/dns_resolve.c
+++ b/fs/nfs/dns_resolve.c
@@ -22,7 +22,7 @@ ssize_t nfs_dns_resolve_name(struct net *net, char *name, size_t namelen,
 	char *ip_addr = NULL;
 	int ip_len;
 
-	ip_len = dns_query(NULL, name, namelen, NULL, &ip_addr, NULL);
+	ip_len = dns_query(net, NULL, name, namelen, NULL, &ip_addr, NULL);
 	if (ip_len > 0)
 		ret = rpc_pton(net, ip_addr, ip_len, sa, salen);
 	else
diff --git a/include/linux/dns_resolver.h b/include/linux/dns_resolver.h
index 34a744a1bafc..3855395fa3c0 100644
--- a/include/linux/dns_resolver.h
+++ b/include/linux/dns_resolver.h
@@ -26,7 +26,8 @@
 
 #include <uapi/linux/dns_resolver.h>
 
-extern int dns_query(const char *type, const char *name, size_t namelen,
+struct net;
+extern int dns_query(struct net *net, const char *type, const char *name, size_t namelen,
 		     const char *options, char **_result, time64_t *_expiry);
 
 #endif /* _LINUX_DNS_RESOLVER_H */
diff --git a/include/linux/key.h b/include/linux/key.h
index 24db72f3839e..b72db0409801 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -36,6 +36,7 @@ typedef int32_t key_serial_t;
 typedef uint32_t key_perm_t;
 
 struct key;
+struct net;
 
 #ifdef CONFIG_KEYS
 
@@ -306,6 +307,11 @@ extern struct key *request_key_with_auxdata(struct key_type *type,
 					    size_t callout_len,
 					    void *aux);
 
+extern struct key *request_key_net(struct key_type *type,
+				   const char *description,
+				   struct net *net,
+				   const char *callout_info);
+
 extern int wait_for_key_construction(struct key *key, bool intr);
 
 extern int key_validate(const struct key *key);
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 7e71b0df1fbc..d4549d42675b 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1885,7 +1885,8 @@ static int ceph_dns_resolve_name(const char *name, size_t namelen,
 		return -EINVAL;
 
 	/* do dns_resolve upcall */
-	ip_len = dns_query(NULL, name, end - name, NULL, &ip_addr, NULL);
+	ip_len = dns_query(current->nsproxy->net_ns,
+			   NULL, name, end - name, NULL, &ip_addr, NULL);
 	if (ip_len > 0)
 		ret = ceph_pton(ip_addr, ip_len, ss, -1, NULL);
 	else
diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index 76338c38738a..d88ea98da63e 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -48,6 +48,7 @@
 
 /**
  * dns_query - Query the DNS
+ * @net: The network namespace to operate in.
  * @type: Query type (or NULL for straight host->IP lookup)
  * @name: Name to look up
  * @namelen: Length of name
@@ -68,7 +69,8 @@
  *
  * Returns the size of the result on success, -ve error code otherwise.
  */
-int dns_query(const char *type, const char *name, size_t namelen,
+int dns_query(struct net *net,
+	      const char *type, const char *name, size_t namelen,
 	      const char *options, char **_result, time64_t *_expiry)
 {
 	struct key *rkey;
@@ -122,7 +124,7 @@ int dns_query(const char *type, const char *name, size_t namelen,
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
index c07fcc756fdd..1fc8c283bdf4 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -152,6 +152,7 @@ extern int install_session_keyring_to_cred(struct cred *, struct key *);
 
 extern struct key *request_key_and_link(struct key_type *type,
 					const char *description,
+					struct key_tag *domain_tag,
 					const void *callout_info,
 					size_t callout_len,
 					void *aux,
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index d2023d550bd6..29c4fa71616b 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -210,7 +210,7 @@ SYSCALL_DEFINE4(request_key, const char __user *, _type,
 	}
 
 	/* do the search */
-	key = request_key_and_link(ktype, description, callout_info,
+	key = request_key_and_link(ktype, description, NULL, callout_info,
 				   callout_len, NULL, key_ref_to_ptr(dest_ref),
 				   KEY_ALLOC_IN_QUOTA);
 	if (IS_ERR(key)) {
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index ffa368594a03..2597ae756191 100644
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
index eed975e57749..2bf00fa37f51 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/keyctl.h>
 #include <linux/slab.h>
+#include <net/net_namespace.h>
 #include "internal.h"
 #include <keys/request_key_auth-type.h>
 
@@ -501,16 +502,18 @@ static struct key *construct_key_and_link(struct keyring_search_context *ctx,
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
@@ -526,6 +529,7 @@ static struct key *construct_key_and_link(struct keyring_search_context *ctx,
  */
 struct key *request_key_and_link(struct key_type *type,
 				 const char *description,
+				 struct key_tag *domain_tag,
 				 const void *callout_info,
 				 size_t callout_len,
 				 void *aux,
@@ -644,7 +648,8 @@ struct key *request_key(struct key_type *type,
 
 	if (callout_info)
 		callout_len = strlen(callout_info);
-	key = request_key_and_link(type, description, callout_info, callout_len,
+	key = request_key_and_link(type, description, NULL,
+				   callout_info, callout_len,
 				   NULL, NULL, KEY_ALLOC_IN_QUOTA);
 	if (!IS_ERR(key)) {
 		ret = wait_for_key_construction(key, false);
@@ -680,7 +685,8 @@ struct key *request_key_with_auxdata(struct key_type *type,
 	struct key *key;
 	int ret;
 
-	key = request_key_and_link(type, description, callout_info, callout_len,
+	key = request_key_and_link(type, description, NULL,
+				   callout_info, callout_len,
 				   aux, NULL, KEY_ALLOC_IN_QUOTA);
 	if (!IS_ERR(key)) {
 		ret = wait_for_key_construction(key, false);
@@ -692,3 +698,43 @@ struct key *request_key_with_auxdata(struct key_type *type,
 	return key;
 }
 EXPORT_SYMBOL(request_key_with_auxdata);
+
+/**
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
+struct key *request_key_net(struct key_type *type,
+			    const char *description,
+			    struct net *net,
+			    const char *callout_info)
+{
+	struct key *key;
+	size_t callout_len = 0;
+	int ret;
+
+	if (callout_info)
+		callout_len = strlen(callout_info);
+	key = request_key_and_link(type, description, net->key_domain,
+				   callout_info, callout_len,
+				   NULL, NULL, KEY_ALLOC_IN_QUOTA);
+	if (!IS_ERR(key)) {
+		ret = wait_for_key_construction(key, false);
+		if (ret < 0) {
+			key_put(key);
+			return ERR_PTR(ret);
+		}
+	}
+	return key;
+}
+EXPORT_SYMBOL(request_key_net);

