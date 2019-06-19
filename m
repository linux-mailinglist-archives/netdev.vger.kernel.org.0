Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F8F4BEA1
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbfFSQqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:46:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbfFSQqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 12:46:52 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DB173308A963;
        Wed, 19 Jun 2019 16:46:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-57.rdu2.redhat.com [10.10.120.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 929375D72E;
        Wed, 19 Jun 2019 16:46:42 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/9] keys: Simplify key description management [ver #4]
From:   David Howells <dhowells@redhat.com>
To:     ebiederm@xmission.com, keyrings@vger.kernel.org
Cc:     linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        dhowells@redhat.com, dwalsh@redhat.com, vgoyal@redhat.com,
        linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 19 Jun 2019 17:46:41 +0100
Message-ID: <156096280179.28733.8720269910775473378.stgit@warthog.procyon.org.uk>
In-Reply-To: <156096279115.28733.8761881995303698232.stgit@warthog.procyon.org.uk>
References: <156096279115.28733.8761881995303698232.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 19 Jun 2019 16:46:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify key description management by cramming the word containing the
length with the first few chars of the description also.  This simplifies
the code that generates the index-key used by assoc_array.  It should speed
up key searching a bit too.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/key.h        |   14 ++++++++-
 security/keys/internal.h   |    6 ++++
 security/keys/key.c        |    2 +
 security/keys/keyring.c    |   70 +++++++++++++-------------------------------
 security/keys/persistent.c |    1 +
 5 files changed, 43 insertions(+), 50 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index 4cd5669184f3..86ccc2d010f6 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -86,9 +86,20 @@ struct keyring_list;
 struct keyring_name;
 
 struct keyring_index_key {
+	union {
+		struct {
+#ifdef __LITTLE_ENDIAN /* Put desc_len at the LSB of x */
+			u8	desc_len;
+			char	desc[sizeof(long) - 1];	/* First few chars of description */
+#else
+			char	desc[sizeof(long) - 1];	/* First few chars of description */
+			u8	desc_len;
+#endif
+		};
+		unsigned long x;
+	};
 	struct key_type		*type;
 	const char		*description;
-	size_t			desc_len;
 };
 
 union key_payload {
@@ -202,6 +213,7 @@ struct key {
 	union {
 		struct keyring_index_key index_key;
 		struct {
+			unsigned long	len_desc;
 			struct key_type	*type;		/* type of key */
 			char		*description;
 		};
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 3d5c08db74d2..ee71c72fc5f0 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -90,6 +90,12 @@ extern struct mutex key_construction_mutex;
 extern wait_queue_head_t request_key_conswq;
 
 
+static inline void key_set_index_key(struct keyring_index_key *index_key)
+{
+	size_t n = min_t(size_t, index_key->desc_len, sizeof(index_key->desc));
+	memcpy(index_key->desc, index_key->description, n);
+}
+
 extern struct key_type *key_type_lookup(const char *type);
 extern void key_type_put(struct key_type *ktype);
 
diff --git a/security/keys/key.c b/security/keys/key.c
index e792d65c0af8..0a3828f15f57 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -285,6 +285,7 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 	key->index_key.description = kmemdup(desc, desclen + 1, GFP_KERNEL);
 	if (!key->index_key.description)
 		goto no_memory_3;
+	key_set_index_key(&key->index_key);
 
 	refcount_set(&key->usage, 1);
 	init_rwsem(&key->sem);
@@ -868,6 +869,7 @@ key_ref_t key_create_or_update(key_ref_t keyring_ref,
 			goto error_free_prep;
 	}
 	index_key.desc_len = strlen(index_key.description);
+	key_set_index_key(&index_key);
 
 	ret = __key_link_lock(keyring, &index_key);
 	if (ret < 0) {
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index afa6d4024c67..ebf52077598f 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -179,9 +179,9 @@ static unsigned long hash_key_type_and_desc(const struct keyring_index_key *inde
 	int n, desc_len = index_key->desc_len;
 
 	type = (unsigned long)index_key->type;
-
 	acc = mult_64x32_and_fold(type, desc_len + 13);
 	acc = mult_64x32_and_fold(acc, 9207);
+
 	for (;;) {
 		n = desc_len;
 		if (n <= 0)
@@ -215,23 +215,13 @@ static unsigned long hash_key_type_and_desc(const struct keyring_index_key *inde
 /*
  * Build the next index key chunk.
  *
- * On 32-bit systems the index key is laid out as:
- *
- *	0	4	5	9...
- *	hash	desclen	typeptr	desc[]
- *
- * On 64-bit systems:
- *
- *	0	8	9	17...
- *	hash	desclen	typeptr	desc[]
- *
  * We return it one word-sized chunk at a time.
  */
 static unsigned long keyring_get_key_chunk(const void *data, int level)
 {
 	const struct keyring_index_key *index_key = data;
 	unsigned long chunk = 0;
-	long offset = 0;
+	const u8 *d;
 	int desc_len = index_key->desc_len, n = sizeof(chunk);
 
 	level /= ASSOC_ARRAY_KEY_CHUNK_SIZE;
@@ -239,33 +229,23 @@ static unsigned long keyring_get_key_chunk(const void *data, int level)
 	case 0:
 		return hash_key_type_and_desc(index_key);
 	case 1:
-		return ((unsigned long)index_key->type << 8) | desc_len;
+		return index_key->x;
 	case 2:
-		if (desc_len == 0)
-			return (u8)((unsigned long)index_key->type >>
-				    (ASSOC_ARRAY_KEY_CHUNK_SIZE - 8));
-		n--;
-		offset = 1;
-		/* fall through */
+		return (unsigned long)index_key->type;
 	default:
-		offset += sizeof(chunk) - 1;
-		offset += (level - 3) * sizeof(chunk);
-		if (offset >= desc_len)
+		level -= 3;
+		if (desc_len <= sizeof(index_key->desc))
 			return 0;
-		desc_len -= offset;
+
+		d = index_key->description + sizeof(index_key->desc);
+		d += level * sizeof(long);
+		desc_len -= sizeof(index_key->desc);
 		if (desc_len > n)
 			desc_len = n;
-		offset += desc_len;
 		do {
 			chunk <<= 8;
-			chunk |= ((u8*)index_key->description)[--offset];
+			chunk |= *d++;
 		} while (--desc_len > 0);
-
-		if (level == 2) {
-			chunk <<= 8;
-			chunk |= (u8)((unsigned long)index_key->type >>
-				      (ASSOC_ARRAY_KEY_CHUNK_SIZE - 8));
-		}
 		return chunk;
 	}
 }
@@ -304,39 +284,28 @@ static int keyring_diff_objects(const void *object, const void *data)
 	seg_b = hash_key_type_and_desc(b);
 	if ((seg_a ^ seg_b) != 0)
 		goto differ;
+	level += ASSOC_ARRAY_KEY_CHUNK_SIZE / 8;
 
 	/* The number of bits contributed by the hash is controlled by a
 	 * constant in the assoc_array headers.  Everything else thereafter we
 	 * can deal with as being machine word-size dependent.
 	 */
-	level += ASSOC_ARRAY_KEY_CHUNK_SIZE / 8;
-	seg_a = a->desc_len;
-	seg_b = b->desc_len;
+	seg_a = a->x;
+	seg_b = b->x;
 	if ((seg_a ^ seg_b) != 0)
 		goto differ;
+	level += sizeof(unsigned long);
 
 	/* The next bit may not work on big endian */
-	level++;
 	seg_a = (unsigned long)a->type;
 	seg_b = (unsigned long)b->type;
 	if ((seg_a ^ seg_b) != 0)
 		goto differ;
-
 	level += sizeof(unsigned long);
-	if (a->desc_len == 0)
-		goto same;
 
-	i = 0;
-	if (((unsigned long)a->description | (unsigned long)b->description) &
-	    (sizeof(unsigned long) - 1)) {
-		do {
-			seg_a = *(unsigned long *)(a->description + i);
-			seg_b = *(unsigned long *)(b->description + i);
-			if ((seg_a ^ seg_b) != 0)
-				goto differ_plus_i;
-			i += sizeof(unsigned long);
-		} while (i < (a->desc_len & (sizeof(unsigned long) - 1)));
-	}
+	i = sizeof(a->desc);
+	if (a->desc_len <= i)
+		goto same;
 
 	for (; i < a->desc_len; i++) {
 		seg_a = *(unsigned char *)(a->description + i);
@@ -662,6 +631,9 @@ static bool search_nested_keyrings(struct key *keyring,
 	BUG_ON((ctx->flags & STATE_CHECKS) == 0 ||
 	       (ctx->flags & STATE_CHECKS) == STATE_CHECKS);
 
+	if (ctx->index_key.description)
+		key_set_index_key(&ctx->index_key);
+
 	/* Check to see if this top-level keyring is what we are looking for
 	 * and whether it is valid or not.
 	 */
diff --git a/security/keys/persistent.c b/security/keys/persistent.c
index d0cb5b32eff7..fc29ec59efa7 100644
--- a/security/keys/persistent.c
+++ b/security/keys/persistent.c
@@ -87,6 +87,7 @@ static long key_get_persistent(struct user_namespace *ns, kuid_t uid,
 	index_key.type = &key_type_keyring;
 	index_key.description = buf;
 	index_key.desc_len = sprintf(buf, "_persistent.%u", from_kuid(ns, uid));
+	key_set_index_key(&index_key);
 
 	if (ns->persistent_keyring_register) {
 		reg_ref = make_key_ref(ns->persistent_keyring_register, true);

