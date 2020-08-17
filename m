Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC4F245A79
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 03:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgHQBfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 21:35:18 -0400
Received: from smtprelay0128.hostedemail.com ([216.40.44.128]:34212 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726698AbgHQBev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 21:34:51 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id D582C182CED2A;
        Mon, 17 Aug 2020 01:34:39 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:69:355:379:541:960:966:968:973:982:988:989:1028:1260:1311:1314:1345:1359:1437:1461:1515:1605:1730:1747:1777:1792:1978:1981:2194:2196:2198:2199:2200:2201:2393:2538:2559:2562:2689:2693:2898:2899:2900:2915:3138:3139:3140:3141:3142:3608:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4384:4385:4395:4605:5007:6248:6261:6691:7875:7903:7904:7974:8603:9036:9038:10004:10226:11026:11914:12043:12294:12296:12297:12438:12555:12679:12683:12895:12986:13161:13229:13894:13972:14394:21080:21324:21325:21433:21451:21611:21626:21740:21795:21810:21987:21990:30004:30029:30030:30045:30046:30051:30054:30056:30062:30069:30070:30075:30080:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: wheel71_2b021d327012
X-Filterd-Recvd-Size: 133218
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Mon, 17 Aug 2020 01:34:37 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ceph-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 3/6] net: ceph:  Use generic debugging facility
Date:   Sun, 16 Aug 2020 18:34:06 -0700
Message-Id: <d0f013ba14840abfa8a5ff857fd228c4568551c8.1597626802.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1597626802.git.joe@perches.com>
References: <cover.1597626802.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dout macro duplicates the generic features of pr_debug with
__FILE__ and __func__ output capability when using dynamic_debug.

Convert dout to pr_debug and remove the "pretty" print feature
of dout.

Miscellanea:

o Realign arguments

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/ceph/auth.c            |  21 +-
 net/ceph/auth_none.c       |   4 +-
 net/ceph/auth_x.c          |  85 ++++----
 net/ceph/buffer.c          |   6 +-
 net/ceph/ceph_common.c     |  18 +-
 net/ceph/cls_lock_client.c |  32 +--
 net/ceph/crypto.c          |   8 +-
 net/ceph/debugfs.c         |   4 +-
 net/ceph/messenger.c       | 329 +++++++++++++++----------------
 net/ceph/mon_client.c      |  99 +++++-----
 net/ceph/msgpool.c         |  14 +-
 net/ceph/osd_client.c      | 393 +++++++++++++++++++------------------
 net/ceph/osdmap.c          | 101 +++++-----
 net/ceph/pagevec.c         |  10 +-
 14 files changed, 575 insertions(+), 549 deletions(-)

diff --git a/net/ceph/auth.c b/net/ceph/auth.c
index fbeee068ea14..326fc907428a 100644
--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -41,7 +41,7 @@ struct ceph_auth_client *ceph_auth_init(const char *name, const struct ceph_cryp
 	struct ceph_auth_client *ac;
 	int ret;
 
-	dout("auth_init name '%s'\n", name);
+	pr_debug("auth_init name '%s'\n", name);
 
 	ret = -ENOMEM;
 	ac = kzalloc(sizeof(*ac), GFP_NOFS);
@@ -54,7 +54,7 @@ struct ceph_auth_client *ceph_auth_init(const char *name, const struct ceph_cryp
 		ac->name = name;
 	else
 		ac->name = CEPH_AUTH_NAME_DEFAULT;
-	dout("auth_init name %s\n", ac->name);
+	pr_debug("auth_init name %s\n", ac->name);
 	ac->key = key;
 	return ac;
 
@@ -64,7 +64,7 @@ struct ceph_auth_client *ceph_auth_init(const char *name, const struct ceph_cryp
 
 void ceph_auth_destroy(struct ceph_auth_client *ac)
 {
-	dout("auth_destroy %p\n", ac);
+	pr_debug("auth_destroy %p\n", ac);
 	if (ac->ops)
 		ac->ops->destroy(ac);
 	kfree(ac);
@@ -76,7 +76,7 @@ void ceph_auth_destroy(struct ceph_auth_client *ac)
 void ceph_auth_reset(struct ceph_auth_client *ac)
 {
 	mutex_lock(&ac->mutex);
-	dout("auth_reset %p\n", ac);
+	pr_debug("auth_reset %p\n", ac);
 	if (ac->ops && !ac->negotiating)
 		ac->ops->reset(ac);
 	ac->negotiating = true;
@@ -110,7 +110,7 @@ int ceph_auth_build_hello(struct ceph_auth_client *ac, void *buf, size_t len)
 	int ret;
 
 	mutex_lock(&ac->mutex);
-	dout("auth_build_hello\n");
+	pr_debug("auth_build_hello\n");
 	monhdr->have_version = 0;
 	monhdr->session_mon = cpu_to_le16(-1);
 	monhdr->session_mon_tid = 0;
@@ -165,7 +165,7 @@ static int ceph_build_auth_request(struct ceph_auth_client *ac,
 		       ac->ops->name);
 		goto out;
 	}
-	dout(" built request %d bytes\n", ret);
+	pr_debug("built request %d bytes\n", ret);
 	ceph_encode_32(&p, ret);
 	ret = p + ret - msg_buf;
 out:
@@ -191,7 +191,7 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 	int ret = -EINVAL;
 
 	mutex_lock(&ac->mutex);
-	dout("handle_auth_reply %p %p\n", p, end);
+	pr_debug("handle_auth_reply %p %p\n", p, end);
 	ceph_decode_need(&p, end, sizeof(u32) * 3 + sizeof(u64), bad);
 	protocol = ceph_decode_32(&p);
 	result = ceph_decode_32(&p);
@@ -206,13 +206,14 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
 	if (p != end)
 		goto bad;
 
-	dout(" result %d '%.*s' gid %llu len %d\n", result, result_msg_len,
-	     result_msg, global_id, payload_len);
+	pr_debug("result %d '%.*s' gid %llu len %d\n",
+		 result, result_msg_len, result_msg, global_id, payload_len);
 
 	payload_end = payload + payload_len;
 
 	if (global_id && ac->global_id != global_id) {
-		dout(" set global_id %lld -> %lld\n", ac->global_id, global_id);
+		pr_debug("set global_id %lld -> %lld\n",
+			 ac->global_id, global_id);
 		ac->global_id = global_id;
 	}
 
diff --git a/net/ceph/auth_none.c b/net/ceph/auth_none.c
index edb7042479ed..f4be840c5961 100644
--- a/net/ceph/auth_none.c
+++ b/net/ceph/auth_none.c
@@ -53,7 +53,7 @@ static int ceph_auth_none_build_authorizer(struct ceph_auth_client *ac,
 
 	ceph_encode_64_safe(&p, end, ac->global_id, e_range);
 	au->buf_len = p - (void *)au->buf;
-	dout("%s built authorizer len %d\n", __func__, au->buf_len);
+	pr_debug("%s built authorizer len %d\n", __func__, au->buf_len);
 	return 0;
 
 e_range:
@@ -130,7 +130,7 @@ int ceph_auth_none_init(struct ceph_auth_client *ac)
 {
 	struct ceph_auth_none_info *xi;
 
-	dout("ceph_auth_none_init %p\n", ac);
+	pr_debug("ceph_auth_none_init %p\n", ac);
 	xi = kzalloc(sizeof(*xi), GFP_NOFS);
 	if (!xi)
 		return -ENOMEM;
diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index b52732337ca6..f83944ec10c3 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -25,8 +25,8 @@ static int ceph_x_is_authenticated(struct ceph_auth_client *ac)
 	int need;
 
 	ceph_x_validate_tickets(ac, &need);
-	dout("ceph_x_is_authenticated want=%d need=%d have=%d\n",
-	     ac->want_keys, need, xi->have_keys);
+	pr_debug("ceph_x_is_authenticated want=%d need=%d have=%d\n",
+		 ac->want_keys, need, xi->have_keys);
 	return (ac->want_keys & xi->have_keys) == ac->want_keys;
 }
 
@@ -36,8 +36,8 @@ static int ceph_x_should_authenticate(struct ceph_auth_client *ac)
 	int need;
 
 	ceph_x_validate_tickets(ac, &need);
-	dout("ceph_x_should_authenticate want=%d need=%d have=%d\n",
-	     ac->want_keys, need, xi->have_keys);
+	pr_debug("ceph_x_should_authenticate want=%d need=%d have=%d\n",
+		 ac->want_keys, need, xi->have_keys);
 	return need != 0;
 }
 
@@ -146,7 +146,7 @@ static void remove_ticket_handler(struct ceph_auth_client *ac,
 {
 	struct ceph_x_info *xi = ac->private;
 
-	dout("remove_ticket_handler %p %d\n", th, th->service);
+	pr_debug("remove_ticket_handler %p %d\n", th, th->service);
 	rb_erase(&th->node, &xi->ticket_handlers);
 	ceph_crypto_key_destroy(&th->session_key);
 	if (th->ticket_blob)
@@ -177,7 +177,7 @@ static int process_one_ticket(struct ceph_auth_client *ac,
 	ceph_decode_need(p, end, sizeof(u32) + 1, bad);
 
 	type = ceph_decode_32(p);
-	dout(" ticket type %d %s\n", type, ceph_entity_type_name(type));
+	pr_debug("ticket type %d %s\n", type, ceph_entity_type_name(type));
 
 	tkt_struct_v = ceph_decode_8(p);
 	if (tkt_struct_v != 1)
@@ -194,7 +194,7 @@ static int process_one_ticket(struct ceph_auth_client *ac,
 	ret = ceph_x_decrypt(secret, p, end);
 	if (ret < 0)
 		goto out;
-	dout(" decrypted %d bytes\n", ret);
+	pr_debug("decrypted %d bytes\n", ret);
 	dend = dp + ret;
 
 	tkt_struct_v = ceph_decode_8(&dp);
@@ -209,8 +209,8 @@ static int process_one_ticket(struct ceph_auth_client *ac,
 	dp += sizeof(struct ceph_timespec);
 	new_expires = ktime_get_real_seconds() + validity.tv_sec;
 	new_renew_after = new_expires - (validity.tv_sec / 4);
-	dout(" expires=%llu renew_after=%llu\n", new_expires,
-	     new_renew_after);
+	pr_debug("expires=%llu renew_after=%llu\n",
+		 new_expires, new_renew_after);
 
 	/* ticket blob for service */
 	ceph_decode_8_safe(p, end, is_enc, bad);
@@ -220,7 +220,7 @@ static int process_one_ticket(struct ceph_auth_client *ac,
 		ret = ceph_x_decrypt(&th->session_key, p, end);
 		if (ret < 0)
 			goto out;
-		dout(" encrypted ticket, decrypted %d bytes\n", ret);
+		pr_debug("encrypted ticket, decrypted %d bytes\n", ret);
 		ptp = &tp;
 		tpend = tp + ret;
 	} else {
@@ -229,7 +229,7 @@ static int process_one_ticket(struct ceph_auth_client *ac,
 		tpend = end;
 	}
 	ceph_decode_32_safe(ptp, tpend, dlen, bad);
-	dout(" ticket blob is %d bytes\n", dlen);
+	pr_debug("ticket blob is %d bytes\n", dlen);
 	ceph_decode_need(ptp, tpend, 1 + sizeof(u64), bad);
 	blob_struct_v = ceph_decode_8(ptp);
 	if (blob_struct_v != 1)
@@ -250,9 +250,9 @@ static int process_one_ticket(struct ceph_auth_client *ac,
 	th->expires = new_expires;
 	th->renew_after = new_renew_after;
 	th->have_key = true;
-	dout(" got ticket service %d (%s) secret_id %lld len %d\n",
-	     type, ceph_entity_type_name(type), th->secret_id,
-	     (int)th->ticket_blob->vec.iov_len);
+	pr_debug("got ticket service %d (%s) secret_id %lld len %d\n",
+		 type, ceph_entity_type_name(type), th->secret_id,
+		 (int)th->ticket_blob->vec.iov_len);
 	xi->have_keys |= th->service;
 	return 0;
 
@@ -277,7 +277,7 @@ static int ceph_x_proc_ticket_reply(struct ceph_auth_client *ac,
 		return -EINVAL;
 
 	ceph_decode_32_safe(&p, end, num, bad);
-	dout("%d tickets\n", num);
+	pr_debug("%d tickets\n", num);
 
 	while (num--) {
 		ret = process_one_ticket(ac, secret, &p, end);
@@ -356,8 +356,8 @@ static int ceph_x_build_authorizer(struct ceph_auth_client *ac,
 	int ticket_blob_len =
 		(th->ticket_blob ? th->ticket_blob->vec.iov_len : 0);
 
-	dout("build_authorizer for %s %p\n",
-	     ceph_entity_type_name(th->service), au);
+	pr_debug("build_authorizer for %s %p\n",
+		 ceph_entity_type_name(th->service), au);
 
 	ceph_crypto_key_destroy(&au->session_key);
 	ret = ceph_crypto_key_clone(&au->session_key, &th->session_key);
@@ -366,7 +366,7 @@ static int ceph_x_build_authorizer(struct ceph_auth_client *ac,
 
 	maxlen = sizeof(*msg_a) + ticket_blob_len +
 		ceph_x_encrypt_buflen(sizeof(*msg_b));
-	dout("  need len %d\n", maxlen);
+	pr_debug("need len %d\n", maxlen);
 	if (au->buf && au->buf->alloc_len < maxlen) {
 		ceph_buffer_put(au->buf);
 		au->buf = NULL;
@@ -392,8 +392,8 @@ static int ceph_x_build_authorizer(struct ceph_auth_client *ac,
 		memcpy(msg_a->ticket_blob.blob, th->ticket_blob->vec.iov_base,
 		       th->ticket_blob->vec.iov_len);
 	}
-	dout(" th %p secret_id %lld %lld\n", th, th->secret_id,
-	     le64_to_cpu(msg_a->ticket_blob.secret_id));
+	pr_debug("th %p secret_id %lld %lld\n",
+		 th, th->secret_id, le64_to_cpu(msg_a->ticket_blob.secret_id));
 
 	get_random_bytes(&au->nonce, sizeof(au->nonce));
 	ret = encrypt_authorizer(au, NULL);
@@ -402,8 +402,8 @@ static int ceph_x_build_authorizer(struct ceph_auth_client *ac,
 		goto out_au;
 	}
 
-	dout(" built authorizer nonce %llx len %d\n", au->nonce,
-	     (int)au->buf->vec.iov_len);
+	pr_debug("built authorizer nonce %llx len %d\n",
+		 au->nonce, (int)au->buf->vec.iov_len);
 	return 0;
 
 out_au:
@@ -495,8 +495,8 @@ static int ceph_x_build_request(struct ceph_auth_client *ac,
 
 	ceph_x_validate_tickets(ac, &need);
 
-	dout("build_request want %x have %x need %x\n",
-	     ac->want_keys, xi->have_keys, need);
+	pr_debug("build_request want %x have %x need %x\n",
+		 ac->want_keys, xi->have_keys, need);
 
 	if (need & CEPH_ENTITY_TYPE_AUTH) {
 		struct ceph_x_authenticate *auth = (void *)(head + 1);
@@ -509,7 +509,7 @@ static int ceph_x_build_request(struct ceph_auth_client *ac,
 		if (p > end)
 			return -ERANGE;
 
-		dout(" get_auth_session_key\n");
+		pr_debug("get_auth_session_key\n");
 		head->op = cpu_to_le16(CEPHX_GET_AUTH_SESSION_KEY);
 
 		/* encrypt and hash */
@@ -525,9 +525,10 @@ static int ceph_x_build_request(struct ceph_auth_client *ac,
 		auth->key = 0;
 		for (u = (u64 *)enc_buf; u + 1 <= (u64 *)(enc_buf + ret); u++)
 			auth->key ^= *(__le64 *)u;
-		dout(" server_challenge %llx client_challenge %llx key %llx\n",
-		     xi->server_challenge, le64_to_cpu(auth->client_challenge),
-		     le64_to_cpu(auth->key));
+		pr_debug("server_challenge %llx client_challenge %llx key %llx\n",
+			 xi->server_challenge,
+			 le64_to_cpu(auth->client_challenge),
+			 le64_to_cpu(auth->key));
 
 		/* now encode the old ticket if exists */
 		ret = ceph_x_encode_ticket(th, &p, end);
@@ -580,8 +581,8 @@ static int ceph_x_handle_reply(struct ceph_auth_client *ac, int result,
 		if (len != sizeof(*sc))
 			return -EINVAL;
 		xi->server_challenge = le64_to_cpu(sc->server_challenge);
-		dout("handle_reply got server challenge %llx\n",
-		     xi->server_challenge);
+		pr_debug("handle_reply got server challenge %llx\n",
+			 xi->server_challenge);
 		xi->starting = false;
 		xi->have_keys &= ~CEPH_ENTITY_TYPE_AUTH;
 		return -EAGAIN;
@@ -589,7 +590,7 @@ static int ceph_x_handle_reply(struct ceph_auth_client *ac, int result,
 
 	op = le16_to_cpu(head->op);
 	result = le32_to_cpu(head->result);
-	dout("handle_reply op %d result %d\n", op, result);
+	pr_debug("handle_reply op %d result %d\n", op, result);
 	switch (op) {
 	case CEPHX_GET_AUTH_SESSION_KEY:
 		/* verify auth key */
@@ -671,8 +672,8 @@ static int ceph_x_update_authorizer(
 
 	au = (struct ceph_x_authorizer *)auth->authorizer;
 	if (au->secret_id < th->secret_id) {
-		dout("ceph_x_update_authorizer service %u secret %llu < %llu\n",
-		     au->service, au->secret_id, th->secret_id);
+		pr_debug("ceph_x_update_authorizer service %u secret %llu < %llu\n",
+			 au->service, au->secret_id, th->secret_id);
 		return ceph_x_build_authorizer(ac, th, au);
 	}
 	return 0;
@@ -746,8 +747,8 @@ static int ceph_x_verify_authorizer_reply(struct ceph_auth_client *ac,
 		ret = -EPERM;
 	else
 		ret = 0;
-	dout("verify_authorizer_reply nonce %llx got %llx ret %d\n",
-	     au->nonce, le64_to_cpu(reply->nonce_plus_one), ret);
+	pr_debug("verify_authorizer_reply nonce %llx got %llx ret %d\n",
+		 au->nonce, le64_to_cpu(reply->nonce_plus_one), ret);
 	return ret;
 }
 
@@ -755,7 +756,7 @@ static void ceph_x_reset(struct ceph_auth_client *ac)
 {
 	struct ceph_x_info *xi = ac->private;
 
-	dout("reset\n");
+	pr_debug("reset\n");
 	xi->starting = true;
 	xi->server_challenge = 0;
 }
@@ -765,7 +766,7 @@ static void ceph_x_destroy(struct ceph_auth_client *ac)
 	struct ceph_x_info *xi = ac->private;
 	struct rb_node *p;
 
-	dout("ceph_x_destroy %p\n", ac);
+	pr_debug("ceph_x_destroy %p\n", ac);
 	ceph_crypto_key_destroy(&xi->secret);
 
 	while ((p = rb_first(&xi->ticket_handlers)) != NULL) {
@@ -902,11 +903,11 @@ static int ceph_x_check_message_signature(struct ceph_auth_handshake *auth,
 	if (sig_check == msg->footer.sig)
 		return 0;
 	if (msg->footer.flags & CEPH_MSG_FOOTER_SIGNED)
-		dout("ceph_x_check_message_signature %p has signature %llx "
-		     "expect %llx\n", msg, msg->footer.sig, sig_check);
+		pr_debug("ceph_x_check_message_signature %p has signature %llx expect %llx\n",
+			 msg, msg->footer.sig, sig_check);
 	else
-		dout("ceph_x_check_message_signature %p sender did not set "
-		     "CEPH_MSG_FOOTER_SIGNED\n", msg);
+		pr_debug("ceph_x_check_message_signature %p sender did not set CEPH_MSG_FOOTER_SIGNED\n",
+			 msg);
 	return -EBADMSG;
 }
 
@@ -933,7 +934,7 @@ int ceph_x_init(struct ceph_auth_client *ac)
 	struct ceph_x_info *xi;
 	int ret;
 
-	dout("ceph_x_init %p\n", ac);
+	pr_debug("ceph_x_init %p\n", ac);
 	ret = -ENOMEM;
 	xi = kzalloc(sizeof(*xi), GFP_NOFS);
 	if (!xi)
diff --git a/net/ceph/buffer.c b/net/ceph/buffer.c
index 5622763ad402..772288c725eb 100644
--- a/net/ceph/buffer.c
+++ b/net/ceph/buffer.c
@@ -26,7 +26,7 @@ struct ceph_buffer *ceph_buffer_new(size_t len, gfp_t gfp)
 	kref_init(&b->kref);
 	b->alloc_len = len;
 	b->vec.iov_len = len;
-	dout("buffer_new %p\n", b);
+	pr_debug("buffer_new %p\n", b);
 	return b;
 }
 EXPORT_SYMBOL(ceph_buffer_new);
@@ -35,7 +35,7 @@ void ceph_buffer_release(struct kref *kref)
 {
 	struct ceph_buffer *b = container_of(kref, struct ceph_buffer, kref);
 
-	dout("buffer_release %p\n", b);
+	pr_debug("buffer_release %p\n", b);
 	kvfree(b->vec.iov_base);
 	kfree(b);
 }
@@ -47,7 +47,7 @@ int ceph_decode_buffer(struct ceph_buffer **b, void **p, void *end)
 
 	ceph_decode_need(p, end, sizeof(u32), bad);
 	len = ceph_decode_32(p);
-	dout("decode_buffer len %d\n", (int)len);
+	pr_debug("decode_buffer len %d\n", (int)len);
 	ceph_decode_need(p, end, len, bad);
 	*b = ceph_buffer_new(len, GFP_NOFS);
 	if (!*b)
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 4e7edd707a14..1750e14115e6 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -224,7 +224,7 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
 	int err = -EINVAL;
 	int d;
 
-	dout("parse_fsid '%s'\n", str);
+	pr_debug("parse_fsid '%s'\n", str);
 	tmp[2] = 0;
 	while (*str && i < 16) {
 		if (ispunct(*str)) {
@@ -244,7 +244,7 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
 
 	if (i == 16)
 		err = 0;
-	dout("parse_fsid ret %d got fsid %pU\n", err, fsid);
+	pr_debug("parse_fsid ret %d got fsid %pU\n", err, fsid);
 	return err;
 }
 
@@ -339,7 +339,7 @@ EXPORT_SYMBOL(ceph_alloc_options);
 
 void ceph_destroy_options(struct ceph_options *opt)
 {
-	dout("destroy_options %p\n", opt);
+	pr_debug("destroy_options %p\n", opt);
 	if (!opt)
 		return;
 
@@ -427,7 +427,7 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
 	struct p_log log = {.prefix = "libceph", .log = l};
 
 	token = __fs_parse(&log, ceph_parameters, param, &result);
-	dout("%s fs_parse '%s' token %d\n", __func__, param->key, token);
+	pr_debug("%s fs_parse '%s' token %d\n", __func__, param->key, token);
 	if (token < 0)
 		return token;
 
@@ -723,7 +723,7 @@ EXPORT_SYMBOL(ceph_create_client);
 
 void ceph_destroy_client(struct ceph_client *client)
 {
-	dout("destroy_client %p\n", client);
+	pr_debug("destroy_client %p\n", client);
 
 	atomic_set(&client->msgr.stopping, 1);
 
@@ -737,7 +737,7 @@ void ceph_destroy_client(struct ceph_client *client)
 	ceph_destroy_options(client->options);
 
 	kfree(client);
-	dout("destroy_client %p done\n", client);
+	pr_debug("destroy_client %p done\n", client);
 }
 EXPORT_SYMBOL(ceph_destroy_client);
 
@@ -776,7 +776,7 @@ int __ceph_open_session(struct ceph_client *client, unsigned long started)
 			return -ETIMEDOUT;
 
 		/* wait */
-		dout("mount waiting for mon_map\n");
+		pr_debug("mount waiting for mon_map\n");
 		err = wait_event_interruptible_timeout(client->auth_wq,
 			have_mon_and_osd_map(client) || (client->auth_err < 0),
 			ceph_timeout_jiffies(timeout));
@@ -799,7 +799,7 @@ int ceph_open_session(struct ceph_client *client)
 	int ret;
 	unsigned long started = jiffies;  /* note the start time */
 
-	dout("open_session start\n");
+	pr_debug("open_session start\n");
 	mutex_lock(&client->mount_mutex);
 
 	ret = __ceph_open_session(client, started);
@@ -861,7 +861,7 @@ static int __init init_ceph_lib(void)
 
 static void __exit exit_ceph_lib(void)
 {
-	dout("exit_ceph_lib\n");
+	pr_debug("exit_ceph_lib\n");
 	WARN_ON(!ceph_strings_empty());
 
 	ceph_osdc_cleanup();
diff --git a/net/ceph/cls_lock_client.c b/net/ceph/cls_lock_client.c
index 17447c19d937..6e6cfa1f32f1 100644
--- a/net/ceph/cls_lock_client.c
+++ b/net/ceph/cls_lock_client.c
@@ -68,13 +68,13 @@ int ceph_cls_lock(struct ceph_osd_client *osdc,
 	p += sizeof(struct ceph_timespec);
 	ceph_encode_8(&p, flags);
 
-	dout("%s lock_name %s type %d cookie %s tag %s desc %s flags 0x%x\n",
-	     __func__, lock_name, type, cookie, tag, desc, flags);
+	pr_debug("%s lock_name %s type %d cookie %s tag %s desc %s flags 0x%x\n",
+		 __func__, lock_name, type, cookie, tag, desc, flags);
 	ret = ceph_osdc_call(osdc, oid, oloc, "lock", "lock",
 			     CEPH_OSD_FLAG_WRITE, lock_op_page,
 			     lock_op_buf_size, NULL, NULL);
 
-	dout("%s: status %d\n", __func__, ret);
+	pr_debug("%s: status %d\n", __func__, ret);
 	__free_page(lock_op_page);
 	return ret;
 }
@@ -117,12 +117,12 @@ int ceph_cls_unlock(struct ceph_osd_client *osdc,
 	ceph_encode_string(&p, end, lock_name, name_len);
 	ceph_encode_string(&p, end, cookie, cookie_len);
 
-	dout("%s lock_name %s cookie %s\n", __func__, lock_name, cookie);
+	pr_debug("%s lock_name %s cookie %s\n", __func__, lock_name, cookie);
 	ret = ceph_osdc_call(osdc, oid, oloc, "lock", "unlock",
 			     CEPH_OSD_FLAG_WRITE, unlock_op_page,
 			     unlock_op_buf_size, NULL, NULL);
 
-	dout("%s: status %d\n", __func__, ret);
+	pr_debug("%s: status %d\n", __func__, ret);
 	__free_page(unlock_op_page);
 	return ret;
 }
@@ -169,13 +169,13 @@ int ceph_cls_break_lock(struct ceph_osd_client *osdc,
 	ceph_encode_copy(&p, locker, sizeof(*locker));
 	ceph_encode_string(&p, end, cookie, cookie_len);
 
-	dout("%s lock_name %s cookie %s locker %s%llu\n", __func__, lock_name,
-	     cookie, ENTITY_NAME(*locker));
+	pr_debug("%s lock_name %s cookie %s locker %s%llu\n",
+		 __func__, lock_name, cookie, ENTITY_NAME(*locker));
 	ret = ceph_osdc_call(osdc, oid, oloc, "lock", "break_lock",
 			     CEPH_OSD_FLAG_WRITE, break_op_page,
 			     break_op_buf_size, NULL, NULL);
 
-	dout("%s: status %d\n", __func__, ret);
+	pr_debug("%s: status %d\n", __func__, ret);
 	__free_page(break_op_page);
 	return ret;
 }
@@ -220,13 +220,13 @@ int ceph_cls_set_cookie(struct ceph_osd_client *osdc,
 	ceph_encode_string(&p, end, tag, tag_len);
 	ceph_encode_string(&p, end, new_cookie, new_cookie_len);
 
-	dout("%s lock_name %s type %d old_cookie %s tag %s new_cookie %s\n",
-	     __func__, lock_name, type, old_cookie, tag, new_cookie);
+	pr_debug("%s lock_name %s type %d old_cookie %s tag %s new_cookie %s\n",
+		 __func__, lock_name, type, old_cookie, tag, new_cookie);
 	ret = ceph_osdc_call(osdc, oid, oloc, "lock", "set_cookie",
 			     CEPH_OSD_FLAG_WRITE, cookie_op_page,
 			     cookie_op_buf_size, NULL, NULL);
 
-	dout("%s: status %d\n", __func__, ret);
+	pr_debug("%s: status %d\n", __func__, ret);
 	__free_page(cookie_op_page);
 	return ret;
 }
@@ -273,9 +273,9 @@ static int decode_locker(void **p, void *end, struct ceph_locker *locker)
 	len = ceph_decode_32(p);
 	*p += len; /* skip description */
 
-	dout("%s %s%llu cookie %s addr %s\n", __func__,
-	     ENTITY_NAME(locker->id.name), locker->id.cookie,
-	     ceph_pr_addr(&locker->info.addr));
+	pr_debug("%s %s%llu cookie %s addr %s\n",
+		 __func__, ENTITY_NAME(locker->id.name), locker->id.cookie,
+		 ceph_pr_addr(&locker->info.addr));
 	return 0;
 }
 
@@ -361,12 +361,12 @@ int ceph_cls_lock_info(struct ceph_osd_client *osdc,
 			    get_info_op_buf_size - CEPH_ENCODING_START_BLK_LEN);
 	ceph_encode_string(&p, end, lock_name, name_len);
 
-	dout("%s lock_name %s\n", __func__, lock_name);
+	pr_debug("%s lock_name %s\n", __func__, lock_name);
 	ret = ceph_osdc_call(osdc, oid, oloc, "lock", "get_info",
 			     CEPH_OSD_FLAG_READ, get_info_op_page,
 			     get_info_op_buf_size, &reply_page, &reply_len);
 
-	dout("%s: status %d\n", __func__, ret);
+	pr_debug("%s: status %d\n", __func__, ret);
 	if (ret >= 0) {
 		p = page_address(reply_page);
 		end = p + reply_len;
diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 4f75df40fb12..c375023f8f71 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -100,7 +100,7 @@ int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end)
 	return ret;
 
 bad:
-	dout("failed to decode crypto key\n");
+	pr_debug("failed to decode crypto key\n");
 	return -EINVAL;
 }
 
@@ -111,7 +111,7 @@ int ceph_crypto_key_unarmor(struct ceph_crypto_key *key, const char *inkey)
 	void *buf, *p;
 	int ret;
 
-	dout("crypto_key_unarmor %s\n", inkey);
+	pr_debug("crypto_key_unarmor %s\n", inkey);
 	buf = kmalloc(blen, GFP_NOFS);
 	if (!buf)
 		return -ENOMEM;
@@ -126,8 +126,8 @@ int ceph_crypto_key_unarmor(struct ceph_crypto_key *key, const char *inkey)
 	kfree(buf);
 	if (ret)
 		return ret;
-	dout("crypto_key_unarmor key %p type %d len %d\n", key,
-	     key->type, key->len);
+	pr_debug("crypto_key_unarmor key %p type %d len %d\n",
+		 key, key->type, key->len);
 	return 0;
 }
 
diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index 2110439f8a24..f07cfb595a1c 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -411,7 +411,7 @@ void ceph_debugfs_client_init(struct ceph_client *client)
 	snprintf(name, sizeof(name), "%pU.client%lld", &client->fsid,
 		 client->monc.auth->global_id);
 
-	dout("ceph_debugfs_client_init %p %s\n", client, name);
+	pr_debug("ceph_debugfs_client_init %p %s\n", client, name);
 
 	client->debugfs_dir = debugfs_create_dir(name, ceph_debugfs_dir);
 
@@ -448,7 +448,7 @@ void ceph_debugfs_client_init(struct ceph_client *client)
 
 void ceph_debugfs_client_cleanup(struct ceph_client *client)
 {
-	dout("ceph_debugfs_client_cleanup %p\n", client);
+	pr_debug("ceph_debugfs_client_cleanup %p\n", client);
 	debugfs_remove(client->debugfs_options);
 	debugfs_remove(client->debugfs_osdmap);
 	debugfs_remove(client->debugfs_monmap);
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 27d6ab11f9ee..652b7cf2812a 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -306,8 +306,8 @@ static void con_sock_state_init(struct ceph_connection *con)
 	old_state = atomic_xchg(&con->sock_state, CON_SOCK_STATE_CLOSED);
 	if (WARN_ON(old_state != CON_SOCK_STATE_NEW))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
-	dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
-	     CON_SOCK_STATE_CLOSED);
+	pr_debug("%s con %p sock %d -> %d\n", __func__, con, old_state,
+		 CON_SOCK_STATE_CLOSED);
 }
 
 static void con_sock_state_connecting(struct ceph_connection *con)
@@ -317,8 +317,8 @@ static void con_sock_state_connecting(struct ceph_connection *con)
 	old_state = atomic_xchg(&con->sock_state, CON_SOCK_STATE_CONNECTING);
 	if (WARN_ON(old_state != CON_SOCK_STATE_CLOSED))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
-	dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
-	     CON_SOCK_STATE_CONNECTING);
+	pr_debug("%s con %p sock %d -> %d\n",
+		 __func__, con, old_state, CON_SOCK_STATE_CONNECTING);
 }
 
 static void con_sock_state_connected(struct ceph_connection *con)
@@ -328,8 +328,8 @@ static void con_sock_state_connected(struct ceph_connection *con)
 	old_state = atomic_xchg(&con->sock_state, CON_SOCK_STATE_CONNECTED);
 	if (WARN_ON(old_state != CON_SOCK_STATE_CONNECTING))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
-	dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
-	     CON_SOCK_STATE_CONNECTED);
+	pr_debug("%s con %p sock %d -> %d\n",
+		 __func__, con, old_state, CON_SOCK_STATE_CONNECTED);
 }
 
 static void con_sock_state_closing(struct ceph_connection *con)
@@ -341,8 +341,8 @@ static void con_sock_state_closing(struct ceph_connection *con)
 			old_state != CON_SOCK_STATE_CONNECTED &&
 			old_state != CON_SOCK_STATE_CLOSING))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
-	dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
-	     CON_SOCK_STATE_CLOSING);
+	pr_debug("%s con %p sock %d -> %d\n",
+		 __func__, con, old_state, CON_SOCK_STATE_CLOSING);
 }
 
 static void con_sock_state_closed(struct ceph_connection *con)
@@ -355,8 +355,8 @@ static void con_sock_state_closed(struct ceph_connection *con)
 		    old_state != CON_SOCK_STATE_CONNECTING &&
 		    old_state != CON_SOCK_STATE_CLOSED))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
-	dout("%s con %p sock %d -> %d\n", __func__, con, old_state,
-	     CON_SOCK_STATE_CLOSED);
+	pr_debug("%s con %p sock %d -> %d\n",
+		 __func__, con, old_state, CON_SOCK_STATE_CLOSED);
 }
 
 /*
@@ -372,8 +372,8 @@ static void ceph_sock_data_ready(struct sock *sk)
 	}
 
 	if (sk->sk_state != TCP_CLOSE_WAIT) {
-		dout("%s on %p state = %lu, queueing work\n", __func__,
-		     con, con->state);
+		pr_debug("%s on %p state = %lu, queueing work\n",
+			 __func__, con, con->state);
 		queue_con(con);
 	}
 }
@@ -392,12 +392,12 @@ static void ceph_sock_write_space(struct sock *sk)
 	 */
 	if (con_flag_test(con, CON_FLAG_WRITE_PENDING)) {
 		if (sk_stream_is_writeable(sk)) {
-			dout("%s %p queueing write work\n", __func__, con);
+			pr_debug("%s %p queueing write work\n", __func__, con);
 			clear_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 			queue_con(con);
 		}
 	} else {
-		dout("%s %p nothing to write\n", __func__, con);
+		pr_debug("%s %p nothing to write\n", __func__, con);
 	}
 }
 
@@ -406,21 +406,21 @@ static void ceph_sock_state_change(struct sock *sk)
 {
 	struct ceph_connection *con = sk->sk_user_data;
 
-	dout("%s %p state = %lu sk_state = %u\n", __func__,
-	     con, con->state, sk->sk_state);
+	pr_debug("%s %p state = %lu sk_state = %u\n",
+		 __func__, con, con->state, sk->sk_state);
 
 	switch (sk->sk_state) {
 	case TCP_CLOSE:
-		dout("%s TCP_CLOSE\n", __func__);
+		pr_debug("%s TCP_CLOSE\n", __func__);
 		/* fall through */
 	case TCP_CLOSE_WAIT:
-		dout("%s TCP_CLOSE_WAIT\n", __func__);
+		pr_debug("%s TCP_CLOSE_WAIT\n", __func__);
 		con_sock_state_closing(con);
 		con_flag_set(con, CON_FLAG_SOCK_CLOSED);
 		queue_con(con);
 		break;
 	case TCP_ESTABLISHED:
-		dout("%s TCP_ESTABLISHED\n", __func__);
+		pr_debug("%s TCP_ESTABLISHED\n", __func__);
 		con_sock_state_connected(con);
 		queue_con(con);
 		break;
@@ -474,15 +474,15 @@ static int ceph_tcp_connect(struct ceph_connection *con)
 
 	set_sock_callbacks(sock, con);
 
-	dout("connect %s\n", ceph_pr_addr(&con->peer_addr));
+	pr_debug("connect %s\n", ceph_pr_addr(&con->peer_addr));
 
 	con_sock_state_connecting(con);
 	ret = sock->ops->connect(sock, (struct sockaddr *)&ss, sizeof(ss),
 				 O_NONBLOCK);
 	if (ret == -EINPROGRESS) {
-		dout("connect %s EINPROGRESS sk_state = %u\n",
-		     ceph_pr_addr(&con->peer_addr),
-		     sock->sk->sk_state);
+		pr_debug("connect %s EINPROGRESS sk_state = %u\n",
+			 ceph_pr_addr(&con->peer_addr),
+			 sock->sk->sk_state);
 	} else if (ret < 0) {
 		pr_err("connect %s error %d\n",
 		       ceph_pr_addr(&con->peer_addr), ret);
@@ -594,7 +594,7 @@ static int con_close_socket(struct ceph_connection *con)
 {
 	int rc = 0;
 
-	dout("con_close_socket on %p sock %p\n", con, con->sock);
+	pr_debug("con_close_socket on %p sock %p\n", con, con->sock);
 	if (con->sock) {
 		rc = con->sock->ops->shutdown(con->sock, SHUT_RDWR);
 		sock_release(con->sock);
@@ -636,7 +636,7 @@ static void reset_connection(struct ceph_connection *con)
 {
 	/* reset connection, out_queue, msg_ and connect_seq */
 	/* discard existing out_queue and msg_seq */
-	dout("reset_connection %p\n", con);
+	pr_debug("reset_connection %p\n", con);
 	ceph_msg_remove_list(&con->out_queue);
 	ceph_msg_remove_list(&con->out_sent);
 
@@ -665,7 +665,7 @@ static void reset_connection(struct ceph_connection *con)
 void ceph_con_close(struct ceph_connection *con)
 {
 	mutex_lock(&con->mutex);
-	dout("con_close %p peer %s\n", con, ceph_pr_addr(&con->peer_addr));
+	pr_debug("con_close %p peer %s\n", con, ceph_pr_addr(&con->peer_addr));
 	con->state = CON_STATE_CLOSED;
 
 	con_flag_clear(con, CON_FLAG_LOSSYTX);	/* so we retry next connect */
@@ -689,7 +689,7 @@ void ceph_con_open(struct ceph_connection *con,
 		   struct ceph_entity_addr *addr)
 {
 	mutex_lock(&con->mutex);
-	dout("con_open %p %s\n", con, ceph_pr_addr(addr));
+	pr_debug("con_open %p %s\n", con, ceph_pr_addr(addr));
 
 	WARN_ON(con->state != CON_STATE_CLOSED);
 	con->state = CON_STATE_PREOPEN;
@@ -719,7 +719,7 @@ void ceph_con_init(struct ceph_connection *con, void *private,
 	const struct ceph_connection_operations *ops,
 	struct ceph_messenger *msgr)
 {
-	dout("con_init %p\n", con);
+	pr_debug("con_init %p\n", con);
 	memset(con, 0, sizeof(*con));
 	con->private = private;
 	con->ops = ops;
@@ -1234,7 +1234,7 @@ static void prepare_write_message_footer(struct ceph_connection *con)
 
 	m->footer.flags |= CEPH_MSG_FOOTER_COMPLETE;
 
-	dout("prepare_write_message_footer %p\n", con);
+	pr_debug("prepare_write_message_footer %p\n", con);
 	con_out_kvec_add(con, sizeof_footer(con), &m->footer);
 	if (con->peer_features & CEPH_FEATURE_MSG_AUTH) {
 		if (con->ops->sign_message)
@@ -1290,10 +1290,10 @@ static void prepare_write_message(struct ceph_connection *con)
 			con->ops->reencode_message(m);
 	}
 
-	dout("prepare_write_message %p seq %lld type %d len %d+%d+%zd\n",
-	     m, con->out_seq, le16_to_cpu(m->hdr.type),
-	     le32_to_cpu(m->hdr.front_len), le32_to_cpu(m->hdr.middle_len),
-	     m->data_length);
+	pr_debug("prepare_write_message %p seq %lld type %d len %d+%d+%zd\n",
+		 m, con->out_seq, le16_to_cpu(m->hdr.type),
+		 le32_to_cpu(m->hdr.front_len), le32_to_cpu(m->hdr.middle_len),
+		 m->data_length);
 	WARN_ON(m->front.iov_len != le32_to_cpu(m->hdr.front_len));
 	WARN_ON(m->data_length != le32_to_cpu(m->hdr.data_len));
 
@@ -1320,9 +1320,10 @@ static void prepare_write_message(struct ceph_connection *con)
 		con->out_msg->footer.middle_crc = cpu_to_le32(crc);
 	} else
 		con->out_msg->footer.middle_crc = 0;
-	dout("%s front_crc %u middle_crc %u\n", __func__,
-	     le32_to_cpu(con->out_msg->footer.front_crc),
-	     le32_to_cpu(con->out_msg->footer.middle_crc));
+	pr_debug("%s front_crc %u middle_crc %u\n",
+		 __func__,
+		 le32_to_cpu(con->out_msg->footer.front_crc),
+		 le32_to_cpu(con->out_msg->footer.middle_crc));
 	con->out_msg->footer.flags = 0;
 
 	/* is there a data payload? */
@@ -1343,8 +1344,8 @@ static void prepare_write_message(struct ceph_connection *con)
  */
 static void prepare_write_ack(struct ceph_connection *con)
 {
-	dout("prepare_write_ack %p %llu -> %llu\n", con,
-	     con->in_seq_acked, con->in_seq);
+	pr_debug("prepare_write_ack %p %llu -> %llu\n",
+		 con, con->in_seq_acked, con->in_seq);
 	con->in_seq_acked = con->in_seq;
 
 	con_out_kvec_reset(con);
@@ -1364,8 +1365,8 @@ static void prepare_write_ack(struct ceph_connection *con)
  */
 static void prepare_write_seq(struct ceph_connection *con)
 {
-	dout("prepare_write_seq %p %llu -> %llu\n", con,
-	     con->in_seq_acked, con->in_seq);
+	pr_debug("prepare_write_seq %p %llu -> %llu\n",
+		 con, con->in_seq_acked, con->in_seq);
 	con->in_seq_acked = con->in_seq;
 
 	con_out_kvec_reset(con);
@@ -1382,7 +1383,7 @@ static void prepare_write_seq(struct ceph_connection *con)
  */
 static void prepare_write_keepalive(struct ceph_connection *con)
 {
-	dout("prepare_write_keepalive %p\n", con);
+	pr_debug("prepare_write_keepalive %p\n", con);
 	con_out_kvec_reset(con);
 	if (con->peer_features & CEPH_FEATURE_MSGR_KEEPALIVE2) {
 		struct timespec64 now;
@@ -1468,8 +1469,8 @@ static int prepare_write_connect(struct ceph_connection *con)
 		BUG();
 	}
 
-	dout("prepare_write_connect %p cseq=%d gseq=%d proto=%d\n", con,
-	     con->connect_seq, global_seq, proto);
+	pr_debug("prepare_write_connect %p cseq=%d gseq=%d proto=%d\n",
+		 con, con->connect_seq, global_seq, proto);
 
 	con->out_connect.features =
 	    cpu_to_le64(from_msgr(con->msgr)->supported_features);
@@ -1497,7 +1498,7 @@ static int write_partial_kvec(struct ceph_connection *con)
 {
 	int ret;
 
-	dout("write_partial_kvec %p %d left\n", con, con->out_kvec_bytes);
+	pr_debug("write_partial_kvec %p %d left\n", con, con->out_kvec_bytes);
 	while (con->out_kvec_bytes > 0) {
 		ret = ceph_tcp_sendmsg(con->sock, con->out_kvec_cur,
 				       con->out_kvec_left, con->out_kvec_bytes,
@@ -1524,8 +1525,8 @@ static int write_partial_kvec(struct ceph_connection *con)
 	con->out_kvec_left = 0;
 	ret = 1;
 out:
-	dout("write_partial_kvec %p %d left in %d kvecs ret = %d\n", con,
-	     con->out_kvec_bytes, con->out_kvec_left, ret);
+	pr_debug("write_partial_kvec %p %d left in %d kvecs ret = %d\n",
+		 con, con->out_kvec_bytes, con->out_kvec_left, ret);
 	return ret;  /* done! */
 }
 
@@ -1557,7 +1558,7 @@ static int write_partial_message_data(struct ceph_connection *con)
 	int more = MSG_MORE | MSG_SENDPAGE_NOTLAST;
 	u32 crc;
 
-	dout("%s %p msg %p\n", __func__, con, msg);
+	pr_debug("%s %p msg %p\n", __func__, con, msg);
 
 	if (!msg->num_data_items)
 		return -EINVAL;
@@ -1598,7 +1599,7 @@ static int write_partial_message_data(struct ceph_connection *con)
 		ceph_msg_data_advance(cursor, (size_t)ret);
 	}
 
-	dout("%s %p msg %p done\n", __func__, con, msg);
+	pr_debug("%s %p msg %p done\n", __func__, con, msg);
 
 	/* prepare and queue up footer, too */
 	if (do_datacrc)
@@ -1619,7 +1620,7 @@ static int write_partial_skip(struct ceph_connection *con)
 	int more = MSG_MORE | MSG_SENDPAGE_NOTLAST;
 	int ret;
 
-	dout("%s %p %d left\n", __func__, con, con->out_skip);
+	pr_debug("%s %p %d left\n", __func__, con, con->out_skip);
 	while (con->out_skip > 0) {
 		size_t size = min(con->out_skip, (int) PAGE_SIZE);
 
@@ -1640,39 +1641,39 @@ static int write_partial_skip(struct ceph_connection *con)
  */
 static void prepare_read_banner(struct ceph_connection *con)
 {
-	dout("prepare_read_banner %p\n", con);
+	pr_debug("prepare_read_banner %p\n", con);
 	con->in_base_pos = 0;
 }
 
 static void prepare_read_connect(struct ceph_connection *con)
 {
-	dout("prepare_read_connect %p\n", con);
+	pr_debug("prepare_read_connect %p\n", con);
 	con->in_base_pos = 0;
 }
 
 static void prepare_read_ack(struct ceph_connection *con)
 {
-	dout("prepare_read_ack %p\n", con);
+	pr_debug("prepare_read_ack %p\n", con);
 	con->in_base_pos = 0;
 }
 
 static void prepare_read_seq(struct ceph_connection *con)
 {
-	dout("prepare_read_seq %p\n", con);
+	pr_debug("prepare_read_seq %p\n", con);
 	con->in_base_pos = 0;
 	con->in_tag = CEPH_MSGR_TAG_SEQ;
 }
 
 static void prepare_read_tag(struct ceph_connection *con)
 {
-	dout("prepare_read_tag %p\n", con);
+	pr_debug("prepare_read_tag %p\n", con);
 	con->in_base_pos = 0;
 	con->in_tag = CEPH_MSGR_TAG_READY;
 }
 
 static void prepare_read_keepalive_ack(struct ceph_connection *con)
 {
-	dout("prepare_read_keepalive_ack %p\n", con);
+	pr_debug("prepare_read_keepalive_ack %p\n", con);
 	con->in_base_pos = 0;
 }
 
@@ -1681,7 +1682,7 @@ static void prepare_read_keepalive_ack(struct ceph_connection *con)
  */
 static int prepare_read_message(struct ceph_connection *con)
 {
-	dout("prepare_read_message %p\n", con);
+	pr_debug("prepare_read_message %p\n", con);
 	BUG_ON(con->in_msg != NULL);
 	con->in_base_pos = 0;
 	con->in_front_crc = con->in_middle_crc = con->in_data_crc = 0;
@@ -1713,7 +1714,7 @@ static int read_partial_banner(struct ceph_connection *con)
 	int end;
 	int ret;
 
-	dout("read_partial_banner %p at %d\n", con, con->in_base_pos);
+	pr_debug("read_partial_banner %p at %d\n", con, con->in_base_pos);
 
 	/* peer's banner */
 	size = strlen(CEPH_BANNER);
@@ -1746,7 +1747,7 @@ static int read_partial_connect(struct ceph_connection *con)
 	int end;
 	int ret;
 
-	dout("read_partial_connect %p at %d\n", con, con->in_base_pos);
+	pr_debug("read_partial_connect %p at %d\n", con, con->in_base_pos);
 
 	size = sizeof (con->in_reply);
 	end = size;
@@ -1770,10 +1771,10 @@ static int read_partial_connect(struct ceph_connection *con)
 			goto out;
 	}
 
-	dout("read_partial_connect %p tag %d, con_seq = %u, g_seq = %u\n",
-	     con, (int)con->in_reply.tag,
-	     le32_to_cpu(con->in_reply.connect_seq),
-	     le32_to_cpu(con->in_reply.global_seq));
+	pr_debug("read_partial_connect %p tag %d, con_seq = %u, g_seq = %u\n",
+		 con, (int)con->in_reply.tag,
+		 le32_to_cpu(con->in_reply.connect_seq),
+		 le32_to_cpu(con->in_reply.global_seq));
 out:
 	return ret;
 }
@@ -1935,7 +1936,7 @@ int ceph_parse_ips(const char *c, const char *end,
 	int i, ret = -EINVAL;
 	const char *p = c;
 
-	dout("parse_ips on '%.*s'\n", (int)(end-c), c);
+	pr_debug("parse_ips on '%.*s'\n", (int)(end - c), c);
 	for (i = 0; i < max_count; i++) {
 		const char *ipend;
 		int port;
@@ -1955,7 +1956,7 @@ int ceph_parse_ips(const char *c, const char *end,
 
 		if (delim == ']') {
 			if (*p != ']') {
-				dout("missing matching ']'\n");
+				pr_debug("missing matching ']'\n");
 				goto bad;
 			}
 			p++;
@@ -1980,7 +1981,7 @@ int ceph_parse_ips(const char *c, const char *end,
 		addr_set_port(&addr[i], port);
 		addr[i].type = CEPH_ENTITY_ADDR_TYPE_LEGACY;
 
-		dout("parse_ips got %s\n", ceph_pr_addr(&addr[i]));
+		pr_debug("parse_ips got %s\n", ceph_pr_addr(&addr[i]));
 
 		if (p == end)
 			break;
@@ -2002,7 +2003,7 @@ int ceph_parse_ips(const char *c, const char *end,
 
 static int process_banner(struct ceph_connection *con)
 {
-	dout("process_banner on %p\n", con);
+	pr_debug("process_banner on %p\n", con);
 
 	if (verify_hello(con) < 0)
 		return -1;
@@ -2036,8 +2037,8 @@ static int process_banner(struct ceph_connection *con)
 		       sizeof(con->peer_addr_for_me.in_addr));
 		addr_set_port(&con->msgr->inst.addr, port);
 		encode_my_addr(con->msgr);
-		dout("process_banner learned my addr is %s\n",
-		     ceph_pr_addr(&con->msgr->inst.addr));
+		pr_debug("process_banner learned my addr is %s\n",
+			 ceph_pr_addr(&con->msgr->inst.addr));
 	}
 
 	return 0;
@@ -2050,7 +2051,7 @@ static int process_connect(struct ceph_connection *con)
 	u64 server_feat = le64_to_cpu(con->in_reply.features);
 	int ret;
 
-	dout("process_connect on %p tag %d\n", con, (int)con->in_tag);
+	pr_debug("process_connect on %p tag %d\n", con, (int)con->in_tag);
 
 	if (con->auth) {
 		int len = le32_to_cpu(con->in_reply.authorizer_len);
@@ -2107,8 +2108,8 @@ static int process_connect(struct ceph_connection *con)
 
 	case CEPH_MSGR_TAG_BADAUTHORIZER:
 		con->auth_retry++;
-		dout("process_connect %p got BADAUTHORIZER attempt %d\n", con,
-		     con->auth_retry);
+		pr_debug("process_connect %p got BADAUTHORIZER attempt %d\n",
+			 con, con->auth_retry);
 		if (con->auth_retry == 2) {
 			con->error_msg = "connect authorization failure";
 			return -1;
@@ -2128,8 +2129,8 @@ static int process_connect(struct ceph_connection *con)
 		 * that they must have reset their session, and may have
 		 * dropped messages.
 		 */
-		dout("process_connect got RESET peer seq %u\n",
-		     le32_to_cpu(con->in_reply.connect_seq));
+		pr_debug("process_connect got RESET peer seq %u\n",
+			 le32_to_cpu(con->in_reply.connect_seq));
 		pr_err("%s%lld %s connection reset\n",
 		       ENTITY_NAME(con->peer_name),
 		       ceph_pr_addr(&con->peer_addr));
@@ -2155,9 +2156,9 @@ static int process_connect(struct ceph_connection *con)
 		 * If we sent a smaller connect_seq than the peer has, try
 		 * again with a larger value.
 		 */
-		dout("process_connect got RETRY_SESSION my seq %u, peer %u\n",
-		     le32_to_cpu(con->out_connect.connect_seq),
-		     le32_to_cpu(con->in_reply.connect_seq));
+		pr_debug("process_connect got RETRY_SESSION my seq %u, peer %u\n",
+			 le32_to_cpu(con->out_connect.connect_seq),
+			 le32_to_cpu(con->in_reply.connect_seq));
 		con->connect_seq = le32_to_cpu(con->in_reply.connect_seq);
 		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
@@ -2171,9 +2172,9 @@ static int process_connect(struct ceph_connection *con)
 		 * If we sent a smaller global_seq than the peer has, try
 		 * again with a larger value.
 		 */
-		dout("process_connect got RETRY_GLOBAL my %u peer_gseq %u\n",
-		     con->peer_global_seq,
-		     le32_to_cpu(con->in_reply.global_seq));
+		pr_debug("process_connect got RETRY_GLOBAL my %u peer_gseq %u\n",
+			 con->peer_global_seq,
+			 le32_to_cpu(con->in_reply.global_seq));
 		get_global_seq(con->msgr,
 			       le32_to_cpu(con->in_reply.global_seq));
 		con_out_kvec_reset(con);
@@ -2202,10 +2203,10 @@ static int process_connect(struct ceph_connection *con)
 		con->peer_global_seq = le32_to_cpu(con->in_reply.global_seq);
 		con->connect_seq++;
 		con->peer_features = server_feat;
-		dout("process_connect got READY gseq %d cseq %d (%d)\n",
-		     con->peer_global_seq,
-		     le32_to_cpu(con->in_reply.connect_seq),
-		     con->connect_seq);
+		pr_debug("process_connect got READY gseq %d cseq %d (%d)\n",
+			 con->peer_global_seq,
+			 le32_to_cpu(con->in_reply.connect_seq),
+			 con->connect_seq);
 		WARN_ON(con->connect_seq !=
 			le32_to_cpu(con->in_reply.connect_seq));
 
@@ -2274,8 +2275,8 @@ static void process_ack(struct ceph_connection *con)
 		seq = le64_to_cpu(m->hdr.seq);
 		if (seq > ack)
 			break;
-		dout("got ack for seq %llu type %d at %p\n", seq,
-		     le16_to_cpu(m->hdr.type), m);
+		pr_debug("got ack for seq %llu type %d at %p\n",
+			 seq, le16_to_cpu(m->hdr.type), m);
 		m->ack_stamp = jiffies;
 		ceph_msg_remove(m);
 	}
@@ -2365,7 +2366,7 @@ static int read_partial_message(struct ceph_connection *con)
 	u64 seq;
 	u32 crc;
 
-	dout("read_partial_message con %p msg %p\n", con, m);
+	pr_debug("read_partial_message con %p msg %p\n", con, m);
 
 	/* header */
 	size = sizeof (con->in_hdr);
@@ -2413,8 +2414,8 @@ static int read_partial_message(struct ceph_connection *con)
 	if (!con->in_msg) {
 		int skip = 0;
 
-		dout("got hdr type %d front %d data %d\n", con->in_hdr.type,
-		     front_len, data_len);
+		pr_debug("got hdr type %d front %d data %d\n",
+			 con->in_hdr.type, front_len, data_len);
 		ret = ceph_con_in_msg_alloc(con, &skip);
 		if (ret < 0)
 			return ret;
@@ -2422,7 +2423,7 @@ static int read_partial_message(struct ceph_connection *con)
 		BUG_ON(!con->in_msg ^ skip);
 		if (skip) {
 			/* skip this message */
-			dout("alloc_msg said skip message\n");
+			pr_debug("alloc_msg said skip message\n");
 			con->in_base_pos = -front_len - middle_len - data_len -
 				sizeof_footer(con);
 			con->in_tag = CEPH_MSGR_TAG_READY;
@@ -2477,9 +2478,9 @@ static int read_partial_message(struct ceph_connection *con)
 		m->footer.sig = 0;
 	}
 
-	dout("read_partial_message got msg %p %d (%u) + %d (%u) + %d (%u)\n",
-	     m, front_len, m->footer.front_crc, middle_len,
-	     m->footer.middle_crc, data_len, m->footer.data_crc);
+	pr_debug("read_partial_message got msg %p %d (%u) + %d (%u) + %d (%u)\n",
+		 m, front_len, m->footer.front_crc, middle_len,
+		 m->footer.middle_crc, data_len, m->footer.data_crc);
 
 	/* crc ok? */
 	if (con->in_front_crc != le32_to_cpu(m->footer.front_crc)) {
@@ -2528,14 +2529,14 @@ static void process_message(struct ceph_connection *con)
 	con->in_seq++;
 	mutex_unlock(&con->mutex);
 
-	dout("===== %p %llu from %s%lld %d=%s len %d+%d (%u %u %u) =====\n",
-	     msg, le64_to_cpu(msg->hdr.seq),
-	     ENTITY_NAME(msg->hdr.src),
-	     le16_to_cpu(msg->hdr.type),
-	     ceph_msg_type_name(le16_to_cpu(msg->hdr.type)),
-	     le32_to_cpu(msg->hdr.front_len),
-	     le32_to_cpu(msg->hdr.data_len),
-	     con->in_front_crc, con->in_middle_crc, con->in_data_crc);
+	pr_debug("===== %p %llu from %s%lld %d=%s len %d+%d (%u %u %u) =====\n",
+		 msg, le64_to_cpu(msg->hdr.seq),
+		 ENTITY_NAME(msg->hdr.src),
+		 le16_to_cpu(msg->hdr.type),
+		 ceph_msg_type_name(le16_to_cpu(msg->hdr.type)),
+		 le32_to_cpu(msg->hdr.front_len),
+		 le32_to_cpu(msg->hdr.data_len),
+		 con->in_front_crc, con->in_middle_crc, con->in_data_crc);
 	con->ops->dispatch(con, msg);
 
 	mutex_lock(&con->mutex);
@@ -2561,7 +2562,7 @@ static int try_write(struct ceph_connection *con)
 {
 	int ret = 1;
 
-	dout("try_write start %p state %lu\n", con, con->state);
+	pr_debug("try_write start %p state %lu\n", con, con->state);
 	if (con->state != CON_STATE_PREOPEN &&
 	    con->state != CON_STATE_CONNECTING &&
 	    con->state != CON_STATE_NEGOTIATING &&
@@ -2579,8 +2580,8 @@ static int try_write(struct ceph_connection *con)
 
 		BUG_ON(con->in_msg);
 		con->in_tag = CEPH_MSGR_TAG_READY;
-		dout("try_write initiating connect on %p new state %lu\n",
-		     con, con->state);
+		pr_debug("try_write initiating connect on %p new state %lu\n",
+			 con, con->state);
 		ret = ceph_tcp_connect(con);
 		if (ret < 0) {
 			con->error_msg = "connect error";
@@ -2589,7 +2590,7 @@ static int try_write(struct ceph_connection *con)
 	}
 
 more:
-	dout("try_write out_kvec_bytes %d\n", con->out_kvec_bytes);
+	pr_debug("try_write out_kvec_bytes %d\n", con->out_kvec_bytes);
 	BUG_ON(!con->sock);
 
 	/* kvec data queued? */
@@ -2618,8 +2619,8 @@ static int try_write(struct ceph_connection *con)
 		if (ret == 0)
 			goto out;
 		if (ret < 0) {
-			dout("try_write write_partial_message_data err %d\n",
-			     ret);
+			pr_debug("try_write write_partial_message_data err %d\n",
+				 ret);
 			goto out;
 		}
 	}
@@ -2643,10 +2644,10 @@ static int try_write(struct ceph_connection *con)
 
 	/* Nothing to do! */
 	con_flag_clear(con, CON_FLAG_WRITE_PENDING);
-	dout("try_write nothing else to write.\n");
+	pr_debug("try_write nothing else to write\n");
 	ret = 0;
 out:
-	dout("try_write done on %p ret %d\n", con, ret);
+	pr_debug("try_write done on %p ret %d\n", con, ret);
 	return ret;
 }
 
@@ -2658,7 +2659,7 @@ static int try_read(struct ceph_connection *con)
 	int ret = -1;
 
 more:
-	dout("try_read start on %p state %lu\n", con, con->state);
+	pr_debug("try_read start on %p state %lu\n", con, con->state);
 	if (con->state != CON_STATE_CONNECTING &&
 	    con->state != CON_STATE_NEGOTIATING &&
 	    con->state != CON_STATE_OPEN)
@@ -2666,11 +2667,11 @@ static int try_read(struct ceph_connection *con)
 
 	BUG_ON(!con->sock);
 
-	dout("try_read tag %d in_base_pos %d\n", (int)con->in_tag,
-	     con->in_base_pos);
+	pr_debug("try_read tag %d in_base_pos %d\n",
+		 (int)con->in_tag, con->in_base_pos);
 
 	if (con->state == CON_STATE_CONNECTING) {
-		dout("try_read connecting\n");
+		pr_debug("try_read connecting\n");
 		ret = read_partial_banner(con);
 		if (ret <= 0)
 			goto out;
@@ -2695,7 +2696,7 @@ static int try_read(struct ceph_connection *con)
 	}
 
 	if (con->state == CON_STATE_NEGOTIATING) {
-		dout("try_read negotiating\n");
+		pr_debug("try_read negotiating\n");
 		ret = read_partial_connect(con);
 		if (ret <= 0)
 			goto out;
@@ -2714,7 +2715,7 @@ static int try_read(struct ceph_connection *con)
 		ret = ceph_tcp_recvmsg(con->sock, NULL, -con->in_base_pos);
 		if (ret <= 0)
 			goto out;
-		dout("skipped %d / %d bytes\n", ret, -con->in_base_pos);
+		pr_debug("skipped %d / %d bytes\n", ret, -con->in_base_pos);
 		con->in_base_pos += ret;
 		if (con->in_base_pos)
 			goto more;
@@ -2726,7 +2727,7 @@ static int try_read(struct ceph_connection *con)
 		ret = ceph_tcp_recvmsg(con->sock, &con->in_tag, 1);
 		if (ret <= 0)
 			goto out;
-		dout("try_read got tag %d\n", (int)con->in_tag);
+		pr_debug("try_read got tag %d\n", (int)con->in_tag);
 		switch (con->in_tag) {
 		case CEPH_MSGR_TAG_MSG:
 			prepare_read_message(con);
@@ -2788,7 +2789,7 @@ static int try_read(struct ceph_connection *con)
 	}
 
 out:
-	dout("try_read done on %p ret %d\n", con, ret);
+	pr_debug("try_read done on %p ret %d\n", con, ret);
 	return ret;
 
 bad_tag:
@@ -2807,17 +2808,17 @@ static int try_read(struct ceph_connection *con)
 static int queue_con_delay(struct ceph_connection *con, unsigned long delay)
 {
 	if (!con->ops->get(con)) {
-		dout("%s %p ref count 0\n", __func__, con);
+		pr_debug("%s %p ref count 0\n", __func__, con);
 		return -ENOENT;
 	}
 
 	if (!queue_delayed_work(ceph_msgr_wq, &con->work, delay)) {
-		dout("%s %p - already queued\n", __func__, con);
+		pr_debug("%s %p - already queued\n", __func__, con);
 		con->ops->put(con);
 		return -EBUSY;
 	}
 
-	dout("%s %p %lu\n", __func__, con, delay);
+	pr_debug("%s %p %lu\n", __func__, con, delay);
 	return 0;
 }
 
@@ -2829,7 +2830,7 @@ static void queue_con(struct ceph_connection *con)
 static void cancel_con(struct ceph_connection *con)
 {
 	if (cancel_delayed_work(&con->work)) {
-		dout("%s %p\n", __func__, con);
+		pr_debug("%s %p\n", __func__, con);
 		con->ops->put(con);
 	}
 }
@@ -2872,8 +2873,8 @@ static bool con_backoff(struct ceph_connection *con)
 
 	ret = queue_con_delay(con, round_jiffies_relative(con->delay));
 	if (ret) {
-		dout("%s: con %p FAILED to back off %lu\n", __func__,
-			con, con->delay);
+		pr_debug("%s: con %p FAILED to back off %lu\n",
+			 __func__, con, con->delay);
 		BUG_ON(ret == -ENOENT);
 		con_flag_set(con, CON_FLAG_BACKOFF);
 	}
@@ -2885,14 +2886,14 @@ static bool con_backoff(struct ceph_connection *con)
 
 static void con_fault_finish(struct ceph_connection *con)
 {
-	dout("%s %p\n", __func__, con);
+	pr_debug("%s %p\n", __func__, con);
 
 	/*
 	 * in case we faulted due to authentication, invalidate our
 	 * current tickets so that we can get new ones.
 	 */
 	if (con->auth_retry) {
-		dout("auth_retry %d, invalidating\n", con->auth_retry);
+		pr_debug("auth_retry %d, invalidating\n", con->auth_retry);
 		if (con->ops->invalidate_authorizer)
 			con->ops->invalidate_authorizer(con);
 		con->auth_retry = 0;
@@ -2916,24 +2917,24 @@ static void ceph_con_workfn(struct work_struct *work)
 		int ret;
 
 		if ((fault = con_sock_closed(con))) {
-			dout("%s: con %p SOCK_CLOSED\n", __func__, con);
+			pr_debug("%s: con %p SOCK_CLOSED\n", __func__, con);
 			break;
 		}
 		if (con_backoff(con)) {
-			dout("%s: con %p BACKOFF\n", __func__, con);
+			pr_debug("%s: con %p BACKOFF\n", __func__, con);
 			break;
 		}
 		if (con->state == CON_STATE_STANDBY) {
-			dout("%s: con %p STANDBY\n", __func__, con);
+			pr_debug("%s: con %p STANDBY\n", __func__, con);
 			break;
 		}
 		if (con->state == CON_STATE_CLOSED) {
-			dout("%s: con %p CLOSED\n", __func__, con);
+			pr_debug("%s: con %p CLOSED\n", __func__, con);
 			BUG_ON(con->sock);
 			break;
 		}
 		if (con->state == CON_STATE_PREOPEN) {
-			dout("%s: con %p PREOPEN\n", __func__, con);
+			pr_debug("%s: con %p PREOPEN\n", __func__, con);
 			BUG_ON(con->sock);
 		}
 
@@ -2974,8 +2975,8 @@ static void ceph_con_workfn(struct work_struct *work)
  */
 static void con_fault(struct ceph_connection *con)
 {
-	dout("fault %p state %lu to peer %s\n",
-	     con, con->state, ceph_pr_addr(&con->peer_addr));
+	pr_debug("fault %p state %lu to peer %s\n",
+		 con, con->state, ceph_pr_addr(&con->peer_addr));
 
 	pr_warn("%s%lld %s %s\n", ENTITY_NAME(con->peer_name),
 		ceph_pr_addr(&con->peer_addr), con->error_msg);
@@ -2988,7 +2989,7 @@ static void con_fault(struct ceph_connection *con)
 	con_close_socket(con);
 
 	if (con_flag_test(con, CON_FLAG_LOSSYTX)) {
-		dout("fault on LOSSYTX channel, marking CLOSED\n");
+		pr_debug("fault on LOSSYTX channel, marking CLOSED\n");
 		con->state = CON_STATE_CLOSED;
 		return;
 	}
@@ -3006,7 +3007,8 @@ static void con_fault(struct ceph_connection *con)
 	 * the connection in a STANDBY state */
 	if (list_empty(&con->out_queue) &&
 	    !con_flag_test(con, CON_FLAG_KEEPALIVE_PENDING)) {
-		dout("fault %p setting STANDBY clearing WRITE_PENDING\n", con);
+		pr_debug("fault %p setting STANDBY clearing WRITE_PENDING\n",
+			 con);
 		con_flag_clear(con, CON_FLAG_WRITE_PENDING);
 		con->state = CON_STATE_STANDBY;
 	} else {
@@ -3048,7 +3050,7 @@ void ceph_messenger_init(struct ceph_messenger *msgr,
 	atomic_set(&msgr->stopping, 0);
 	write_pnet(&msgr->net, get_net(current->nsproxy->net_ns));
 
-	dout("%s %p\n", __func__, msgr);
+	pr_debug("%s %p\n", __func__, msgr);
 }
 EXPORT_SYMBOL(ceph_messenger_init);
 
@@ -3071,7 +3073,7 @@ static void clear_standby(struct ceph_connection *con)
 {
 	/* come back from STANDBY? */
 	if (con->state == CON_STATE_STANDBY) {
-		dout("clear_standby %p and ++connect_seq\n", con);
+		pr_debug("clear_standby %p and ++connect_seq\n", con);
 		con->state = CON_STATE_PREOPEN;
 		con->connect_seq++;
 		WARN_ON(con_flag_test(con, CON_FLAG_WRITE_PENDING));
@@ -3092,7 +3094,7 @@ void ceph_con_send(struct ceph_connection *con, struct ceph_msg *msg)
 	mutex_lock(&con->mutex);
 
 	if (con->state == CON_STATE_CLOSED) {
-		dout("con_send %p closed, dropping %p\n", con, msg);
+		pr_debug("con_send %p closed, dropping %p\n", con, msg);
 		ceph_msg_put(msg);
 		mutex_unlock(&con->mutex);
 		return;
@@ -3102,12 +3104,12 @@ void ceph_con_send(struct ceph_connection *con, struct ceph_msg *msg)
 
 	BUG_ON(!list_empty(&msg->list_head));
 	list_add_tail(&msg->list_head, &con->out_queue);
-	dout("----- %p to %s%lld %d=%s len %d+%d+%d -----\n", msg,
-	     ENTITY_NAME(con->peer_name), le16_to_cpu(msg->hdr.type),
-	     ceph_msg_type_name(le16_to_cpu(msg->hdr.type)),
-	     le32_to_cpu(msg->hdr.front_len),
-	     le32_to_cpu(msg->hdr.middle_len),
-	     le32_to_cpu(msg->hdr.data_len));
+	pr_debug("----- %p to %s%lld %d=%s len %d+%d+%d -----\n",
+		 msg, ENTITY_NAME(con->peer_name), le16_to_cpu(msg->hdr.type),
+		 ceph_msg_type_name(le16_to_cpu(msg->hdr.type)),
+		 le32_to_cpu(msg->hdr.front_len),
+		 le32_to_cpu(msg->hdr.middle_len),
+		 le32_to_cpu(msg->hdr.data_len));
 
 	clear_standby(con);
 	mutex_unlock(&con->mutex);
@@ -3127,13 +3129,13 @@ void ceph_msg_revoke(struct ceph_msg *msg)
 	struct ceph_connection *con = msg->con;
 
 	if (!con) {
-		dout("%s msg %p null con\n", __func__, msg);
+		pr_debug("%s msg %p null con\n", __func__, msg);
 		return;		/* Message not in our possession */
 	}
 
 	mutex_lock(&con->mutex);
 	if (!list_empty(&msg->list_head)) {
-		dout("%s %p msg %p - was on queue\n", __func__, con, msg);
+		pr_debug("%s %p msg %p - was on queue\n", __func__, con, msg);
 		list_del_init(&msg->list_head);
 		msg->hdr.seq = 0;
 
@@ -3155,8 +3157,9 @@ void ceph_msg_revoke(struct ceph_msg *msg)
 			con->out_skip += con_out_kvec_skip(con);
 		con->out_skip += con_out_kvec_skip(con);
 
-		dout("%s %p msg %p - was sending, will write %d skip %d\n",
-		     __func__, con, msg, con->out_kvec_bytes, con->out_skip);
+		pr_debug("%s %p msg %p - was sending, will write %d skip %d\n",
+			 __func__, con, msg,
+			 con->out_kvec_bytes, con->out_skip);
 		msg->hdr.seq = 0;
 		con->out_msg = NULL;
 		ceph_msg_put(msg);
@@ -3173,7 +3176,7 @@ void ceph_msg_revoke_incoming(struct ceph_msg *msg)
 	struct ceph_connection *con = msg->con;
 
 	if (!con) {
-		dout("%s msg %p null con\n", __func__, msg);
+		pr_debug("%s msg %p null con\n", __func__, msg);
 		return;		/* Message not in our possession */
 	}
 
@@ -3184,7 +3187,7 @@ void ceph_msg_revoke_incoming(struct ceph_msg *msg)
 		unsigned int data_len = le32_to_cpu(con->in_hdr.data_len);
 
 		/* skip rest of message */
-		dout("%s %p msg %p revoked\n", __func__, con, msg);
+		pr_debug("%s %p msg %p revoked\n", __func__, con, msg);
 		con->in_base_pos = con->in_base_pos -
 				sizeof(struct ceph_msg_header) -
 				front_len -
@@ -3196,8 +3199,8 @@ void ceph_msg_revoke_incoming(struct ceph_msg *msg)
 		con->in_tag = CEPH_MSGR_TAG_READY;
 		con->in_seq++;
 	} else {
-		dout("%s %p in_msg %p msg %p no-op\n",
-		     __func__, con, con->in_msg, msg);
+		pr_debug("%s %p in_msg %p msg %p no-op\n",
+			 __func__, con, con->in_msg, msg);
 	}
 	mutex_unlock(&con->mutex);
 }
@@ -3207,7 +3210,7 @@ void ceph_msg_revoke_incoming(struct ceph_msg *msg)
  */
 void ceph_con_keepalive(struct ceph_connection *con)
 {
-	dout("con_keepalive %p\n", con);
+	pr_debug("con_keepalive %p\n", con);
 	mutex_lock(&con->mutex);
 	clear_standby(con);
 	con_flag_set(con, CON_FLAG_KEEPALIVE_PENDING);
@@ -3338,8 +3341,8 @@ struct ceph_msg *ceph_msg_new2(int type, int front_len, int max_data_items,
 	if (front_len) {
 		m->front.iov_base = ceph_kvmalloc(front_len, flags);
 		if (m->front.iov_base == NULL) {
-			dout("ceph_msg_new can't allocate %d bytes\n",
-			     front_len);
+			pr_debug("ceph_msg_new can't allocate %d bytes\n",
+				 front_len);
 			goto out2;
 		}
 	} else {
@@ -3356,7 +3359,7 @@ struct ceph_msg *ceph_msg_new2(int type, int front_len, int max_data_items,
 		m->max_data_items = max_data_items;
 	}
 
-	dout("ceph_msg_new %p front %d\n", m, front_len);
+	pr_debug("ceph_msg_new %p front %d\n", m, front_len);
 	return m;
 
 out2:
@@ -3367,8 +3370,8 @@ struct ceph_msg *ceph_msg_new2(int type, int front_len, int max_data_items,
 		       front_len);
 		WARN_ON(1);
 	} else {
-		dout("msg_new can't create type %d front %d\n", type,
-		     front_len);
+		pr_debug("msg_new can't create type %d front %d\n",
+			 type, front_len);
 	}
 	return NULL;
 }
@@ -3393,8 +3396,8 @@ static int ceph_alloc_middle(struct ceph_connection *con, struct ceph_msg *msg)
 	int type = le16_to_cpu(msg->hdr.type);
 	int middle_len = le32_to_cpu(msg->hdr.middle_len);
 
-	dout("alloc_middle %p type %d %s middle_len %d\n", msg, type,
-	     ceph_msg_type_name(type), middle_len);
+	pr_debug("alloc_middle %p type %d %s middle_len %d\n",
+		 msg, type, ceph_msg_type_name(type), middle_len);
 	BUG_ON(!middle_len);
 	BUG_ON(msg->middle);
 
@@ -3472,7 +3475,7 @@ static int ceph_con_in_msg_alloc(struct ceph_connection *con, int *skip)
  */
 static void ceph_msg_free(struct ceph_msg *m)
 {
-	dout("%s %p\n", __func__, m);
+	pr_debug("%s %p\n", __func__, m);
 	kvfree(m->front.iov_base);
 	kfree(m->data);
 	kmem_cache_free(ceph_msg_cache, m);
@@ -3483,7 +3486,7 @@ static void ceph_msg_release(struct kref *kref)
 	struct ceph_msg *m = container_of(kref, struct ceph_msg, kref);
 	int i;
 
-	dout("%s %p\n", __func__, m);
+	pr_debug("%s %p\n", __func__, m);
 	WARN_ON(!list_empty(&m->list_head));
 
 	msg_con_set(m, NULL);
@@ -3505,8 +3508,7 @@ static void ceph_msg_release(struct kref *kref)
 
 struct ceph_msg *ceph_msg_get(struct ceph_msg *msg)
 {
-	dout("%s %p (was %d)\n", __func__, msg,
-	     kref_read(&msg->kref));
+	pr_debug("%s %p (was %d)\n", __func__, msg, kref_read(&msg->kref));
 	kref_get(&msg->kref);
 	return msg;
 }
@@ -3514,8 +3516,7 @@ EXPORT_SYMBOL(ceph_msg_get);
 
 void ceph_msg_put(struct ceph_msg *msg)
 {
-	dout("%s %p (was %d)\n", __func__, msg,
-	     kref_read(&msg->kref));
+	pr_debug("%s %p (was %d)\n", __func__, msg, kref_read(&msg->kref));
 	kref_put(&msg->kref, ceph_msg_release);
 }
 EXPORT_SYMBOL(ceph_msg_put);
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 3d8c8015e976..96aecc142f1c 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -50,7 +50,8 @@ static struct ceph_monmap *ceph_monmap_decode(void *p, void *end)
 	ceph_decode_32_safe(&p, end, len, bad);
 	ceph_decode_need(&p, end, len, bad);
 
-	dout("monmap_decode %p %p len %d (%d)\n", p, end, len, (int)(end-p));
+	pr_debug("monmap_decode %p %p len %d (%d)\n",
+		 p, end, len, (int)(end - p));
 	p += sizeof(u16);  /* skip version */
 
 	ceph_decode_need(&p, end, sizeof(fsid) + 2*sizeof(u32), bad);
@@ -77,14 +78,14 @@ static struct ceph_monmap *ceph_monmap_decode(void *p, void *end)
 		if (err)
 			goto bad;
 	}
-	dout("monmap_decode epoch %d, num_mon %d\n", m->epoch,
-	     m->num_mon);
+	pr_debug("monmap_decode epoch %d, num_mon %d\n",
+		 m->epoch, m->num_mon);
 	for (i = 0; i < m->num_mon; i++)
-		dout("monmap_decode  mon%d is %s\n", i,
-		     ceph_pr_addr(&m->mon_inst[i].addr));
+		pr_debug("monmap_decode  mon%d is %s\n",
+			 i, ceph_pr_addr(&m->mon_inst[i].addr));
 	return m;
 bad:
-	dout("monmap_decode failed with %d\n", err);
+	pr_debug("monmap_decode failed with %d\n", err);
 	kfree(m);
 	return ERR_PTR(err);
 }
@@ -120,7 +121,7 @@ static void __send_prepared_auth_request(struct ceph_mon_client *monc, int len)
  */
 static void __close_session(struct ceph_mon_client *monc)
 {
-	dout("__close_session closing mon%d\n", monc->cur_mon);
+	pr_debug("__close_session closing mon%d\n", monc->cur_mon);
 	ceph_msg_revoke(monc->m_auth);
 	ceph_msg_revoke_incoming(monc->m_auth_reply);
 	ceph_msg_revoke(monc->m_subscribe);
@@ -162,8 +163,8 @@ static void pick_new_mon(struct ceph_mon_client *monc)
 		monc->cur_mon = n;
 	}
 
-	dout("%s mon%d -> mon%d out of %d mons\n", __func__, old_mon,
-	     monc->cur_mon, monc->monmap->num_mon);
+	pr_debug("%s mon%d -> mon%d out of %d mons\n",
+		 __func__, old_mon, monc->cur_mon, monc->monmap->num_mon);
 }
 
 /*
@@ -185,7 +186,7 @@ static void __open_session(struct ceph_mon_client *monc)
 	monc->sub_renew_after = jiffies; /* i.e., expired */
 	monc->sub_renew_sent = 0;
 
-	dout("%s opening mon%d\n", __func__, monc->cur_mon);
+	pr_debug("%s opening mon%d\n", __func__, monc->cur_mon);
 	ceph_con_open(&monc->con, CEPH_ENTITY_TYPE_MON, monc->cur_mon,
 		      &monc->monmap->mon_inst[monc->cur_mon].addr);
 
@@ -225,7 +226,7 @@ static void un_backoff(struct ceph_mon_client *monc)
 	monc->hunt_mult /= 2; /* reduce by 50% */
 	if (monc->hunt_mult < 1)
 		monc->hunt_mult = 1;
-	dout("%s hunt_mult now %d\n", __func__, monc->hunt_mult);
+	pr_debug("%s hunt_mult now %d\n", __func__, monc->hunt_mult);
 }
 
 /*
@@ -240,7 +241,7 @@ static void __schedule_delayed(struct ceph_mon_client *monc)
 	else
 		delay = CEPH_MONC_PING_INTERVAL;
 
-	dout("__schedule_delayed after %lu\n", delay);
+	pr_debug("__schedule_delayed after %lu\n", delay);
 	mod_delayed_work(system_wq, &monc->delayed_work,
 			 round_jiffies_relative(delay));
 }
@@ -264,7 +265,7 @@ static void __send_subscribe(struct ceph_mon_client *monc)
 	int num = 0;
 	int i;
 
-	dout("%s sent %lu\n", __func__, monc->sub_renew_sent);
+	pr_debug("%s sent %lu\n", __func__, monc->sub_renew_sent);
 
 	BUG_ON(monc->cur_mon < 0);
 
@@ -291,9 +292,10 @@ static void __send_subscribe(struct ceph_mon_client *monc)
 		    monc->fs_cluster_id != CEPH_FS_CLUSTER_ID_NONE)
 			len += sprintf(buf + len, ".%d", monc->fs_cluster_id);
 
-		dout("%s %s start %llu flags 0x%x\n", __func__, buf,
-		     le64_to_cpu(monc->subs[i].item.start),
-		     monc->subs[i].item.flags);
+		pr_debug("%s %s start %llu flags 0x%x\n",
+			 __func__, buf,
+			 le64_to_cpu(monc->subs[i].item.start),
+			 monc->subs[i].item.flags);
 		ceph_encode_string(&p, end, buf, len);
 		memcpy(p, &monc->subs[i].item, sizeof(monc->subs[i].item));
 		p += sizeof(monc->subs[i].item);
@@ -324,12 +326,13 @@ static void handle_subscribe_ack(struct ceph_mon_client *monc,
 		 */
 		monc->sub_renew_after = monc->sub_renew_sent +
 					    (seconds >> 1) * HZ - 1;
-		dout("%s sent %lu duration %d renew after %lu\n", __func__,
-		     monc->sub_renew_sent, seconds, monc->sub_renew_after);
+		pr_debug("%s sent %lu duration %d renew after %lu\n",
+			 __func__, monc->sub_renew_sent, seconds,
+			 monc->sub_renew_after);
 		monc->sub_renew_sent = 0;
 	} else {
-		dout("%s sent %lu renew after %lu, ignoring\n", __func__,
-		     monc->sub_renew_sent, monc->sub_renew_after);
+		pr_debug("%s sent %lu renew after %lu, ignoring\n",
+			 __func__, monc->sub_renew_sent, monc->sub_renew_after);
 	}
 	mutex_unlock(&monc->mutex);
 	return;
@@ -350,8 +353,8 @@ static bool __ceph_monc_want_map(struct ceph_mon_client *monc, int sub,
 	__le64 start = cpu_to_le64(epoch);
 	u8 flags = !continuous ? CEPH_SUBSCRIBE_ONETIME : 0;
 
-	dout("%s %s epoch %u continuous %d\n", __func__, ceph_sub_str[sub],
-	     epoch, continuous);
+	pr_debug("%s %s epoch %u continuous %d\n",
+		 __func__, ceph_sub_str[sub], epoch, continuous);
 
 	if (monc->subs[sub].want &&
 	    monc->subs[sub].item.start == start &&
@@ -386,7 +389,7 @@ EXPORT_SYMBOL(ceph_monc_want_map);
 static void __ceph_monc_got_map(struct ceph_mon_client *monc, int sub,
 				u32 epoch)
 {
-	dout("%s %s epoch %u\n", __func__, ceph_sub_str[sub], epoch);
+	pr_debug("%s %s epoch %u\n", __func__, ceph_sub_str[sub], epoch);
 
 	if (monc->subs[sub].want) {
 		if (monc->subs[sub].item.flags & CEPH_SUBSCRIBE_ONETIME)
@@ -472,7 +475,7 @@ static void ceph_monc_handle_map(struct ceph_mon_client *monc,
 
 	mutex_lock(&monc->mutex);
 
-	dout("handle_monmap\n");
+	pr_debug("handle_monmap\n");
 	p = msg->front.iov_base;
 	end = p + msg->front.iov_len;
 
@@ -510,8 +513,8 @@ static void release_generic_request(struct kref *kref)
 	struct ceph_mon_generic_request *req =
 		container_of(kref, struct ceph_mon_generic_request, kref);
 
-	dout("%s greq %p request %p reply %p\n", __func__, req, req->request,
-	     req->reply);
+	pr_debug("%s greq %p request %p reply %p\n",
+		 __func__, req, req->request, req->reply);
 	WARN_ON(!RB_EMPTY_NODE(&req->node));
 
 	if (req->reply)
@@ -547,7 +550,7 @@ alloc_generic_request(struct ceph_mon_client *monc, gfp_t gfp)
 	RB_CLEAR_NODE(&req->node);
 	init_completion(&req->completion);
 
-	dout("%s greq %p\n", __func__, req);
+	pr_debug("%s greq %p\n", __func__, req);
 	return req;
 }
 
@@ -567,7 +570,7 @@ static void send_generic_request(struct ceph_mon_client *monc,
 {
 	WARN_ON(!req->tid);
 
-	dout("%s greq %p tid %llu\n", __func__, req, req->tid);
+	pr_debug("%s greq %p tid %llu\n", __func__, req, req->tid);
 	req->request->hdr.tid = cpu_to_le64(req->tid);
 	ceph_con_send(&monc->con, ceph_msg_get(req->request));
 }
@@ -576,7 +579,7 @@ static void __finish_generic_request(struct ceph_mon_generic_request *req)
 {
 	struct ceph_mon_client *monc = req->monc;
 
-	dout("%s greq %p tid %llu\n", __func__, req, req->tid);
+	pr_debug("%s greq %p tid %llu\n", __func__, req, req->tid);
 	erase_generic_request(&monc->generic_request_tree, req);
 
 	ceph_msg_revoke(req->request);
@@ -603,7 +606,7 @@ static void cancel_generic_request(struct ceph_mon_generic_request *req)
 	struct ceph_mon_client *monc = req->monc;
 	struct ceph_mon_generic_request *lookup_req;
 
-	dout("%s greq %p tid %llu\n", __func__, req, req->tid);
+	pr_debug("%s greq %p tid %llu\n", __func__, req, req->tid);
 
 	mutex_lock(&monc->mutex);
 	lookup_req = lookup_generic_request(&monc->generic_request_tree,
@@ -620,7 +623,7 @@ static int wait_generic_request(struct ceph_mon_generic_request *req)
 {
 	int ret;
 
-	dout("%s greq %p tid %llu\n", __func__, req, req->tid);
+	pr_debug("%s greq %p tid %llu\n", __func__, req, req->tid);
 	ret = wait_for_completion_interruptible(&req->completion);
 	if (ret)
 		cancel_generic_request(req);
@@ -642,11 +645,11 @@ static struct ceph_msg *get_generic_reply(struct ceph_connection *con,
 	mutex_lock(&monc->mutex);
 	req = lookup_generic_request(&monc->generic_request_tree, tid);
 	if (!req) {
-		dout("get_generic_reply %lld dne\n", tid);
+		pr_debug("get_generic_reply %lld dne\n", tid);
 		*skip = 1;
 		m = NULL;
 	} else {
-		dout("get_generic_reply %lld got %p\n", tid, req->reply);
+		pr_debug("get_generic_reply %lld got %p\n", tid, req->reply);
 		*skip = 0;
 		m = ceph_msg_get(req->reply);
 		/*
@@ -669,7 +672,7 @@ static void handle_statfs_reply(struct ceph_mon_client *monc,
 	struct ceph_mon_statfs_reply *reply = msg->front.iov_base;
 	u64 tid = le64_to_cpu(msg->hdr.tid);
 
-	dout("%s msg %p tid %llu\n", __func__, msg, tid);
+	pr_debug("%s msg %p tid %llu\n", __func__, msg, tid);
 
 	if (msg->front.iov_len != sizeof(*reply))
 		goto bad;
@@ -749,7 +752,7 @@ static void handle_get_version_reply(struct ceph_mon_client *monc,
 	void *end = p + msg->front_alloc_len;
 	u64 handle;
 
-	dout("%s msg %p tid %llu\n", __func__, msg, tid);
+	pr_debug("%s msg %p tid %llu\n", __func__, msg, tid);
 
 	ceph_decode_need(&p, end, 2*sizeof(u64), bad);
 	handle = ceph_decode_64(&p);
@@ -871,7 +874,7 @@ static void handle_command_ack(struct ceph_mon_client *monc,
 	void *const end = p + msg->front_alloc_len;
 	u64 tid = le64_to_cpu(msg->hdr.tid);
 
-	dout("%s msg %p tid %llu\n", __func__, msg, tid);
+	pr_debug("%s msg %p tid %llu\n", __func__, msg, tid);
 
 	ceph_decode_need(&p, end, sizeof(struct ceph_mon_request_header) +
 							    sizeof(u32), bad);
@@ -975,16 +978,16 @@ static void delayed_work(struct work_struct *work)
 	struct ceph_mon_client *monc =
 		container_of(work, struct ceph_mon_client, delayed_work.work);
 
-	dout("monc delayed_work\n");
+	pr_debug("monc delayed_work\n");
 	mutex_lock(&monc->mutex);
 	if (monc->hunting) {
-		dout("%s continuing hunt\n", __func__);
+		pr_debug("%s continuing hunt\n", __func__);
 		reopen_session(monc);
 	} else {
 		int is_auth = ceph_auth_is_authenticated(monc->auth);
 		if (ceph_con_keepalive_expired(&monc->con,
 					       CEPH_MONC_PING_TIMEOUT)) {
-			dout("monc keepalive timeout\n");
+			pr_debug("monc keepalive timeout\n");
 			is_auth = 0;
 			reopen_session(monc);
 		}
@@ -999,8 +1002,8 @@ static void delayed_work(struct work_struct *work)
 		    !(monc->con.peer_features & CEPH_FEATURE_MON_STATEFUL_SUB)) {
 			unsigned long now = jiffies;
 
-			dout("%s renew subs? now %lu renew after %lu\n",
-			     __func__, now, monc->sub_renew_after);
+			pr_debug("%s renew subs? now %lu renew after %lu\n",
+				 __func__, now, monc->sub_renew_after);
 			if (time_after_eq(now, monc->sub_renew_after))
 				__send_subscribe(monc);
 		}
@@ -1040,7 +1043,7 @@ int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl)
 {
 	int err = 0;
 
-	dout("init\n");
+	pr_debug("init\n");
 	memset(monc, 0, sizeof(*monc));
 	monc->client = cl;
 	monc->monmap = NULL;
@@ -1117,7 +1120,7 @@ EXPORT_SYMBOL(ceph_monc_init);
 
 void ceph_monc_stop(struct ceph_mon_client *monc)
 {
-	dout("stop\n");
+	pr_debug("stop\n");
 	cancel_delayed_work_sync(&monc->delayed_work);
 
 	mutex_lock(&monc->mutex);
@@ -1149,7 +1152,7 @@ EXPORT_SYMBOL(ceph_monc_stop);
 static void finish_hunting(struct ceph_mon_client *monc)
 {
 	if (monc->hunting) {
-		dout("%s found mon%d\n", __func__, monc->cur_mon);
+		pr_debug("%s found mon%d\n", __func__, monc->cur_mon);
 		monc->hunting = false;
 		monc->had_a_connection = true;
 		un_backoff(monc);
@@ -1180,7 +1183,7 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
 	if (ret < 0) {
 		monc->client->auth_err = ret;
 	} else if (!was_auth && ceph_auth_is_authenticated(monc->auth)) {
-		dout("authenticated, starting session\n");
+		pr_debug("authenticated, starting session\n");
 
 		monc->client->msgr.inst.name.type = CEPH_ENTITY_TYPE_CLIENT;
 		monc->client->msgr.inst.name.num =
@@ -1342,14 +1345,14 @@ static void mon_fault(struct ceph_connection *con)
 	struct ceph_mon_client *monc = con->private;
 
 	mutex_lock(&monc->mutex);
-	dout("%s mon%d\n", __func__, monc->cur_mon);
+	pr_debug("%s mon%d\n", __func__, monc->cur_mon);
 	if (monc->cur_mon >= 0) {
 		if (!monc->hunting) {
-			dout("%s hunting for new mon\n", __func__);
+			pr_debug("%s hunting for new mon\n", __func__);
 			reopen_session(monc);
 			__schedule_delayed(monc);
 		} else {
-			dout("%s already hunting\n", __func__);
+			pr_debug("%s already hunting\n", __func__);
 		}
 	}
 	mutex_unlock(&monc->mutex);
diff --git a/net/ceph/msgpool.c b/net/ceph/msgpool.c
index e3ecb80cd182..4341c941d269 100644
--- a/net/ceph/msgpool.c
+++ b/net/ceph/msgpool.c
@@ -17,9 +17,9 @@ static void *msgpool_alloc(gfp_t gfp_mask, void *arg)
 	msg = ceph_msg_new2(pool->type, pool->front_len, pool->max_data_items,
 			    gfp_mask, true);
 	if (!msg) {
-		dout("msgpool_alloc %s failed\n", pool->name);
+		pr_debug("msgpool_alloc %s failed\n", pool->name);
 	} else {
-		dout("msgpool_alloc %s %p\n", pool->name, msg);
+		pr_debug("msgpool_alloc %s %p\n", pool->name, msg);
 		msg->pool = pool;
 	}
 	return msg;
@@ -30,7 +30,7 @@ static void msgpool_free(void *element, void *arg)
 	struct ceph_msgpool *pool = arg;
 	struct ceph_msg *msg = element;
 
-	dout("msgpool_release %s %p\n", pool->name, msg);
+	pr_debug("msgpool_release %s %p\n", pool->name, msg);
 	msg->pool = NULL;
 	ceph_msg_put(msg);
 }
@@ -39,7 +39,7 @@ int ceph_msgpool_init(struct ceph_msgpool *pool, int type,
 		      int front_len, int max_data_items, int size,
 		      const char *name)
 {
-	dout("msgpool %s init\n", name);
+	pr_debug("msgpool %s init\n", name);
 	pool->type = type;
 	pool->front_len = front_len;
 	pool->max_data_items = max_data_items;
@@ -52,7 +52,7 @@ int ceph_msgpool_init(struct ceph_msgpool *pool, int type,
 
 void ceph_msgpool_destroy(struct ceph_msgpool *pool)
 {
-	dout("msgpool %s destroy\n", pool->name);
+	pr_debug("msgpool %s destroy\n", pool->name);
 	mempool_destroy(pool->pool);
 }
 
@@ -74,13 +74,13 @@ struct ceph_msg *ceph_msgpool_get(struct ceph_msgpool *pool, int front_len,
 	}
 
 	msg = mempool_alloc(pool->pool, GFP_NOFS);
-	dout("msgpool_get %s %p\n", pool->name, msg);
+	pr_debug("msgpool_get %s %p\n", pool->name, msg);
 	return msg;
 }
 
 void ceph_msgpool_put(struct ceph_msgpool *pool, struct ceph_msg *msg)
 {
-	dout("msgpool_put %s %p\n", pool->name, msg);
+	pr_debug("msgpool_put %s %p\n", pool->name, msg);
 
 	/* reset msg front_len; user may have changed it */
 	msg->front.iov_len = pool->front_len;
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index e4fbcad6e7d8..b7bb5f2f5d61 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -112,11 +112,12 @@ static int calc_layout(struct ceph_file_layout *layout, u64 off, u64 *plen,
 	*objlen = xlen;
 	if (*objlen < orig_len) {
 		*plen = *objlen;
-		dout(" skipping last %llu, final file extent %llu~%llu\n",
-		     orig_len - *plen, off, *plen);
+		pr_debug("skipping last %llu, final file extent %llu~%llu\n",
+			 orig_len - *plen, off, *plen);
 	}
 
-	dout("calc_layout objnum=%llx %llu~%llu\n", *objnum, *objoff, *objlen);
+	pr_debug("calc_layout objnum=%llx %llu~%llu\n",
+		 *objnum, *objoff, *objlen);
 	return 0;
 }
 
@@ -482,8 +483,8 @@ static void ceph_osdc_release_request(struct kref *kref)
 					    struct ceph_osd_request, r_kref);
 	unsigned int which;
 
-	dout("%s %p (r_request %p r_reply %p)\n", __func__, req,
-	     req->r_request, req->r_reply);
+	pr_debug("%s %p (r_request %p r_reply %p)\n",
+		 __func__, req, req->r_request, req->r_reply);
 	request_release_checks(req);
 
 	if (req->r_request)
@@ -507,8 +508,7 @@ static void ceph_osdc_release_request(struct kref *kref)
 
 void ceph_osdc_get_request(struct ceph_osd_request *req)
 {
-	dout("%s %p (was %d)\n", __func__, req,
-	     kref_read(&req->r_kref));
+	pr_debug("%s %p (was %d)\n", __func__, req, kref_read(&req->r_kref));
 	kref_get(&req->r_kref);
 }
 EXPORT_SYMBOL(ceph_osdc_get_request);
@@ -516,8 +516,8 @@ EXPORT_SYMBOL(ceph_osdc_get_request);
 void ceph_osdc_put_request(struct ceph_osd_request *req)
 {
 	if (req) {
-		dout("%s %p (was %d)\n", __func__, req,
-		     kref_read(&req->r_kref));
+		pr_debug("%s %p (was %d)\n",
+			 __func__, req, kref_read(&req->r_kref));
 		kref_put(&req->r_kref, ceph_osdc_release_request);
 	}
 }
@@ -555,7 +555,7 @@ static void request_reinit(struct ceph_osd_request *req)
 	struct ceph_msg *request_msg = req->r_request;
 	struct ceph_msg *reply_msg = req->r_reply;
 
-	dout("%s req %p\n", __func__, req);
+	pr_debug("%s req %p\n", __func__, req);
 	WARN_ON(kref_read(&req->r_kref) != 1);
 	request_release_checks(req);
 
@@ -601,7 +601,7 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 	req->r_snapid = CEPH_NOSNAP;
 	req->r_snapc = ceph_get_snap_context(snapc);
 
-	dout("%s req %p\n", __func__, req);
+	pr_debug("%s req %p\n", __func__, req);
 	return req;
 }
 EXPORT_SYMBOL(ceph_osdc_alloc_request);
@@ -1246,19 +1246,20 @@ static struct ceph_osd *create_osd(struct ceph_osd_client *osdc, int onum)
 static struct ceph_osd *get_osd(struct ceph_osd *osd)
 {
 	if (refcount_inc_not_zero(&osd->o_ref)) {
-		dout("get_osd %p %d -> %d\n", osd, refcount_read(&osd->o_ref)-1,
-		     refcount_read(&osd->o_ref));
+		pr_debug("get_osd %p %d -> %d\n",
+			 osd, refcount_read(&osd->o_ref) - 01,
+			 refcount_read(&osd->o_ref));
 		return osd;
 	} else {
-		dout("get_osd %p FAIL\n", osd);
+		pr_debug("get_osd %p FAIL\n", osd);
 		return NULL;
 	}
 }
 
 static void put_osd(struct ceph_osd *osd)
 {
-	dout("put_osd %p %d -> %d\n", osd, refcount_read(&osd->o_ref),
-	     refcount_read(&osd->o_ref) - 1);
+	pr_debug("put_osd %p %d -> %d\n", osd, refcount_read(&osd->o_ref),
+		 refcount_read(&osd->o_ref) - 1);
 	if (refcount_dec_and_test(&osd->o_ref)) {
 		osd_cleanup(osd);
 		kfree(osd);
@@ -1271,7 +1272,7 @@ static void __move_osd_to_lru(struct ceph_osd *osd)
 {
 	struct ceph_osd_client *osdc = osd->o_osdc;
 
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	pr_debug("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
 	BUG_ON(!list_empty(&osd->o_osd_lru));
 
 	spin_lock(&osdc->osd_lru_lock);
@@ -1292,7 +1293,7 @@ static void __remove_osd_from_lru(struct ceph_osd *osd)
 {
 	struct ceph_osd_client *osdc = osd->o_osdc;
 
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	pr_debug("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
 
 	spin_lock(&osdc->osd_lru_lock);
 	if (!list_empty(&osd->o_osd_lru))
@@ -1310,7 +1311,7 @@ static void close_osd(struct ceph_osd *osd)
 	struct rb_node *n;
 
 	verify_osdc_wrlocked(osdc);
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	pr_debug("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
 
 	ceph_con_close(&osd->o_con);
 
@@ -1320,7 +1321,7 @@ static void close_osd(struct ceph_osd *osd)
 
 		n = rb_next(n); /* unlink_request() */
 
-		dout(" reassigning req %p tid %llu\n", req, req->r_tid);
+		pr_debug("reassigning req %p tid %llu\n", req, req->r_tid);
 		unlink_request(osd, req);
 		link_request(&osdc->homeless_osd, req);
 	}
@@ -1330,8 +1331,8 @@ static void close_osd(struct ceph_osd *osd)
 
 		n = rb_next(n); /* unlink_linger() */
 
-		dout(" reassigning lreq %p linger_id %llu\n", lreq,
-		     lreq->linger_id);
+		pr_debug("reassigning lreq %p linger_id %llu\n",
+			 lreq, lreq->linger_id);
 		unlink_linger(osd, lreq);
 		link_linger(&osdc->homeless_osd, lreq);
 	}
@@ -1349,7 +1350,7 @@ static int reopen_osd(struct ceph_osd *osd)
 {
 	struct ceph_entity_addr *peer_addr;
 
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	pr_debug("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
 
 	if (RB_EMPTY_ROOT(&osd->o_requests) &&
 	    RB_EMPTY_ROOT(&osd->o_linger_requests)) {
@@ -1362,8 +1363,7 @@ static int reopen_osd(struct ceph_osd *osd)
 			!ceph_con_opened(&osd->o_con)) {
 		struct rb_node *n;
 
-		dout("osd addr hasn't changed and connection never opened, "
-		     "letting msgr retry\n");
+		pr_debug("osd addr hasn't changed and connection never opened, letting msgr retry\n");
 		/* touch each r_stamp for handle_timeout()'s benfit */
 		for (n = rb_first(&osd->o_requests); n; n = rb_next(n)) {
 			struct ceph_osd_request *req =
@@ -1405,7 +1405,7 @@ static struct ceph_osd *lookup_create_osd(struct ceph_osd_client *osdc, int o,
 			      &osdc->osdmap->osd_addr[osd->o_osd]);
 	}
 
-	dout("%s osdc %p osd%d -> osd %p\n", __func__, osdc, o, osd);
+	pr_debug("%s osdc %p osd%d -> osd %p\n", __func__, osdc, o, osd);
 	return osd;
 }
 
@@ -1418,8 +1418,8 @@ static void link_request(struct ceph_osd *osd, struct ceph_osd_request *req)
 {
 	verify_osd_locked(osd);
 	WARN_ON(!req->r_tid || req->r_osd);
-	dout("%s osd %p osd%d req %p tid %llu\n", __func__, osd, osd->o_osd,
-	     req, req->r_tid);
+	pr_debug("%s osd %p osd%d req %p tid %llu\n",
+		 __func__, osd, osd->o_osd, req, req->r_tid);
 
 	if (!osd_homeless(osd))
 		__remove_osd_from_lru(osd);
@@ -1435,8 +1435,8 @@ static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
 {
 	verify_osd_locked(osd);
 	WARN_ON(req->r_osd != osd);
-	dout("%s osd %p osd%d req %p tid %llu\n", __func__, osd, osd->o_osd,
-	     req, req->r_tid);
+	pr_debug("%s osd %p osd%d req %p tid %llu\n",
+		 __func__, osd, osd->o_osd, req, req->r_tid);
 
 	req->r_osd = NULL;
 	erase_request(&osd->o_requests, req);
@@ -1502,8 +1502,8 @@ static int pick_random_replica(const struct ceph_osds *acting)
 {
 	int i = prandom_u32() % acting->size;
 
-	dout("%s picked osd%d, primary osd%d\n", __func__,
-	     acting->osds[i], acting->primary);
+	pr_debug("%s picked osd%d, primary osd%d\n",
+		 __func__, acting->osds[i], acting->primary);
 	return i;
 }
 
@@ -1532,8 +1532,9 @@ static int pick_closest_replica(struct ceph_osd_client *osdc,
 		}
 	} while (++i < acting->size);
 
-	dout("%s picked osd%d with locality %d, primary osd%d\n", __func__,
-	     acting->osds[best_i], best_locality, acting->primary);
+	pr_debug("%s picked osd%d with locality %d, primary osd%d\n",
+		 __func__, acting->osds[best_i],
+		 best_locality, acting->primary);
 	return best_i;
 }
 
@@ -1666,8 +1667,9 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
 		ct_res = CALC_TARGET_NO_ACTION;
 
 out:
-	dout("%s t %p -> %d%d%d%d ct_res %d osd%d\n", __func__, t, unpaused,
-	     legacy_change, force_resend, split, ct_res, t->osd);
+	pr_debug("%s t %p -> %d%d%d%d ct_res %d osd%d\n",
+		 __func__, t, unpaused, legacy_change, force_resend, split,
+		 ct_res, t->osd);
 	return ct_res;
 }
 
@@ -1987,9 +1989,11 @@ static bool should_plug_request(struct ceph_osd_request *req)
 	if (!backoff)
 		return false;
 
-	dout("%s req %p tid %llu backoff osd%d spgid %llu.%xs%d id %llu\n",
-	     __func__, req, req->r_tid, osd->o_osd, backoff->spgid.pgid.pool,
-	     backoff->spgid.pgid.seed, backoff->spgid.shard, backoff->id);
+	pr_debug("%s req %p tid %llu backoff osd%d spgid %llu.%xs%d id %llu\n",
+		 __func__, req, req->r_tid, osd->o_osd,
+		 backoff->spgid.pgid.pool,
+		 backoff->spgid.pgid.seed,
+		 backoff->spgid.shard, backoff->id);
 	return true;
 }
 
@@ -2171,8 +2175,9 @@ static void encode_request_partial(struct ceph_osd_request *req,
 	 */
 	msg->hdr.data_off = cpu_to_le16(req->r_data_offset);
 
-	dout("%s req %p msg %p oid %s oid_len %d\n", __func__, req, msg,
-	     req->r_t.target_oid.name, req->r_t.target_oid.name_len);
+	pr_debug("%s req %p msg %p oid %s oid_len %d\n",
+		 __func__, req, msg,
+		 req->r_t.target_oid.name, req->r_t.target_oid.name_len);
 }
 
 static void encode_request_finish(struct ceph_msg *msg)
@@ -2261,10 +2266,13 @@ static void encode_request_finish(struct ceph_msg *msg)
 	msg->front.iov_len = p - msg->front.iov_base;
 	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
 
-	dout("%s msg %p tid %llu %u+%u+%u v%d\n", __func__, msg,
-	     le64_to_cpu(msg->hdr.tid), le32_to_cpu(msg->hdr.front_len),
-	     le32_to_cpu(msg->hdr.middle_len), le32_to_cpu(msg->hdr.data_len),
-	     le16_to_cpu(msg->hdr.version));
+	pr_debug("%s msg %p tid %llu %u+%u+%u v%d\n",
+		 __func__, msg,
+		 le64_to_cpu(msg->hdr.tid),
+		 le32_to_cpu(msg->hdr.front_len),
+		 le32_to_cpu(msg->hdr.middle_len),
+		 le32_to_cpu(msg->hdr.data_len),
+		 le16_to_cpu(msg->hdr.version));
 }
 
 /*
@@ -2296,11 +2304,12 @@ static void send_request(struct ceph_osd_request *req)
 
 	encode_request_partial(req, req->r_request);
 
-	dout("%s req %p tid %llu to pgid %llu.%x spgid %llu.%xs%d osd%d e%u flags 0x%x attempt %d\n",
-	     __func__, req, req->r_tid, req->r_t.pgid.pool, req->r_t.pgid.seed,
-	     req->r_t.spgid.pgid.pool, req->r_t.spgid.pgid.seed,
-	     req->r_t.spgid.shard, osd->o_osd, req->r_t.epoch, req->r_flags,
-	     req->r_attempts);
+	pr_debug("%s req %p tid %llu to pgid %llu.%x spgid %llu.%xs%d osd%d e%u flags 0x%x attempt %d\n",
+		 __func__,
+		 req, req->r_tid, req->r_t.pgid.pool, req->r_t.pgid.seed,
+		 req->r_t.spgid.pgid.pool, req->r_t.spgid.pgid.seed,
+		 req->r_t.spgid.shard, osd->o_osd, req->r_t.epoch, req->r_flags,
+		 req->r_attempts);
 
 	req->r_t.paused = false;
 	req->r_stamp = jiffies;
@@ -2321,10 +2330,10 @@ static void maybe_request_map(struct ceph_osd_client *osdc)
 	if (ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
 	    ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSERD) ||
 	    ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSEWR)) {
-		dout("%s osdc %p continuous\n", __func__, osdc);
+		pr_debug("%s osdc %p continuous\n", __func__, osdc);
 		continuous = true;
 	} else {
-		dout("%s osdc %p onetime\n", __func__, osdc);
+		pr_debug("%s osdc %p onetime\n", __func__, osdc);
 	}
 
 	if (ceph_monc_want_map(&osdc->client->monc, CEPH_SUB_OSDMAP,
@@ -2345,7 +2354,7 @@ static void __submit_request(struct ceph_osd_request *req, bool wrlocked)
 	bool promoted = false;
 
 	WARN_ON(req->r_tid);
-	dout("%s req %p wrlocked %d\n", __func__, req, wrlocked);
+	pr_debug("%s req %p wrlocked %d\n", __func__, req, wrlocked);
 
 again:
 	ct_res = calc_target(osdc, &req->r_t, false);
@@ -2359,21 +2368,21 @@ static void __submit_request(struct ceph_osd_request *req, bool wrlocked)
 	}
 
 	if (osdc->abort_err) {
-		dout("req %p abort_err %d\n", req, osdc->abort_err);
+		pr_debug("req %p abort_err %d\n", req, osdc->abort_err);
 		err = osdc->abort_err;
 	} else if (osdc->osdmap->epoch < osdc->epoch_barrier) {
-		dout("req %p epoch %u barrier %u\n", req, osdc->osdmap->epoch,
-		     osdc->epoch_barrier);
+		pr_debug("req %p epoch %u barrier %u\n",
+			 req, osdc->osdmap->epoch, osdc->epoch_barrier);
 		req->r_t.paused = true;
 		maybe_request_map(osdc);
 	} else if ((req->r_flags & CEPH_OSD_FLAG_WRITE) &&
 		   ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSEWR)) {
-		dout("req %p pausewr\n", req);
+		pr_debug("req %p pausewr\n", req);
 		req->r_t.paused = true;
 		maybe_request_map(osdc);
 	} else if ((req->r_flags & CEPH_OSD_FLAG_READ) &&
 		   ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSERD)) {
-		dout("req %p pauserd\n", req);
+		pr_debug("req %p pauserd\n", req);
 		req->r_t.paused = true;
 		maybe_request_map(osdc);
 	} else if ((req->r_flags & CEPH_OSD_FLAG_WRITE) &&
@@ -2381,7 +2390,7 @@ static void __submit_request(struct ceph_osd_request *req, bool wrlocked)
 				     CEPH_OSD_FLAG_FULL_FORCE)) &&
 		   (ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
 		    pool_full(osdc, req->r_t.base_oloc.pool))) {
-		dout("req %p full/pool_full\n", req);
+		pr_debug("req %p full/pool_full\n", req);
 		if (ceph_test_opt(osdc->client, ABORT_ON_FULL)) {
 			err = -ENOSPC;
 		} else {
@@ -2448,7 +2457,7 @@ static void finish_request(struct ceph_osd_request *req)
 	struct ceph_osd_client *osdc = req->r_osdc;
 
 	WARN_ON(lookup_request_mc(&osdc->map_checks, req->r_tid));
-	dout("%s req %p tid %llu\n", __func__, req, req->r_tid);
+	pr_debug("%s req %p tid %llu\n", __func__, req, req->r_tid);
 
 	req->r_end_latency = ktime_get();
 
@@ -2468,8 +2477,8 @@ static void finish_request(struct ceph_osd_request *req)
 
 static void __complete_request(struct ceph_osd_request *req)
 {
-	dout("%s req %p tid %llu cb %ps result %d\n", __func__, req,
-	     req->r_tid, req->r_callback, req->r_result);
+	pr_debug("%s req %p tid %llu cb %ps result %d\n",
+		 __func__, req, req->r_tid, req->r_callback, req->r_result);
 
 	if (req->r_callback)
 		req->r_callback(req);
@@ -2490,7 +2499,7 @@ static void complete_request_workfn(struct work_struct *work)
  */
 static void complete_request(struct ceph_osd_request *req, int err)
 {
-	dout("%s req %p tid %llu err %d\n", __func__, req, req->r_tid, err);
+	pr_debug("%s req %p tid %llu err %d\n", __func__, req, req->r_tid, err);
 
 	req->r_result = err;
 	finish_request(req);
@@ -2517,7 +2526,7 @@ static void cancel_map_check(struct ceph_osd_request *req)
 
 static void cancel_request(struct ceph_osd_request *req)
 {
-	dout("%s req %p tid %llu\n", __func__, req, req->r_tid);
+	pr_debug("%s req %p tid %llu\n", __func__, req, req->r_tid);
 
 	cancel_map_check(req);
 	finish_request(req);
@@ -2527,7 +2536,7 @@ static void cancel_request(struct ceph_osd_request *req)
 
 static void abort_request(struct ceph_osd_request *req, int err)
 {
-	dout("%s req %p tid %llu err %d\n", __func__, req, req->r_tid, err);
+	pr_debug("%s req %p tid %llu err %d\n", __func__, req, req->r_tid, err);
 
 	cancel_map_check(req);
 	complete_request(req, err);
@@ -2547,7 +2556,7 @@ static int abort_fn(struct ceph_osd_request *req, void *arg)
  */
 void ceph_osdc_abort_requests(struct ceph_osd_client *osdc, int err)
 {
-	dout("%s osdc %p err %d\n", __func__, osdc, err);
+	pr_debug("%s osdc %p err %d\n", __func__, osdc, err);
 	down_write(&osdc->lock);
 	for_each_request(osdc, abort_fn, &err);
 	osdc->abort_err = err;
@@ -2566,8 +2575,8 @@ EXPORT_SYMBOL(ceph_osdc_clear_abort_err);
 static void update_epoch_barrier(struct ceph_osd_client *osdc, u32 eb)
 {
 	if (likely(eb > osdc->epoch_barrier)) {
-		dout("updating epoch_barrier from %u to %u\n",
-				osdc->epoch_barrier, eb);
+		pr_debug("updating epoch_barrier from %u to %u\n",
+			 osdc->epoch_barrier, eb);
 		osdc->epoch_barrier = eb;
 		/* Request map if we're not to the barrier yet */
 		if (eb > osdc->osdmap->epoch)
@@ -2643,11 +2652,12 @@ static void check_pool_dne(struct ceph_osd_request *req)
 		 * (i.e., it was deleted).
 		 */
 		req->r_map_dne_bound = map->epoch;
-		dout("%s req %p tid %llu pool disappeared\n", __func__, req,
-		     req->r_tid);
+		pr_debug("%s req %p tid %llu pool disappeared\n",
+			 __func__, req, req->r_tid);
 	} else {
-		dout("%s req %p tid %llu map_dne_bound %u have %u\n", __func__,
-		     req, req->r_tid, req->r_map_dne_bound, map->epoch);
+		pr_debug("%s req %p tid %llu map_dne_bound %u have %u\n",
+			 __func__, req, req->r_tid,
+			 req->r_map_dne_bound, map->epoch);
 	}
 
 	if (req->r_map_dne_bound) {
@@ -2673,12 +2683,13 @@ static void map_check_cb(struct ceph_mon_generic_request *greq)
 	down_write(&osdc->lock);
 	req = lookup_request_mc(&osdc->map_checks, tid);
 	if (!req) {
-		dout("%s tid %llu dne\n", __func__, tid);
+		pr_debug("%s tid %llu dne\n", __func__, tid);
 		goto out_unlock;
 	}
 
-	dout("%s req %p tid %llu map_dne_bound %u newest %llu\n", __func__,
-	     req, req->r_tid, req->r_map_dne_bound, greq->u.newest);
+	pr_debug("%s req %p tid %llu map_dne_bound %u newest %llu\n",
+		 __func__, req, req->r_tid,
+		 req->r_map_dne_bound, greq->u.newest);
 	if (!req->r_map_dne_bound)
 		req->r_map_dne_bound = greq->u.newest;
 	erase_request_mc(&osdc->map_checks, req);
@@ -2718,8 +2729,8 @@ static void linger_release(struct kref *kref)
 	struct ceph_osd_linger_request *lreq =
 	    container_of(kref, struct ceph_osd_linger_request, kref);
 
-	dout("%s lreq %p reg_req %p ping_req %p\n", __func__, lreq,
-	     lreq->reg_req, lreq->ping_req);
+	pr_debug("%s lreq %p reg_req %p ping_req %p\n",
+		 __func__, lreq, lreq->reg_req, lreq->ping_req);
 	WARN_ON(!RB_EMPTY_NODE(&lreq->node));
 	WARN_ON(!RB_EMPTY_NODE(&lreq->osdc_node));
 	WARN_ON(!RB_EMPTY_NODE(&lreq->mc_node));
@@ -2770,7 +2781,7 @@ linger_alloc(struct ceph_osd_client *osdc)
 	lreq->osdc = osdc;
 	target_init(&lreq->t);
 
-	dout("%s lreq %p\n", __func__, lreq);
+	pr_debug("%s lreq %p\n", __func__, lreq);
 	return lreq;
 }
 
@@ -2788,8 +2799,8 @@ static void link_linger(struct ceph_osd *osd,
 {
 	verify_osd_locked(osd);
 	WARN_ON(!lreq->linger_id || lreq->osd);
-	dout("%s osd %p osd%d lreq %p linger_id %llu\n", __func__, osd,
-	     osd->o_osd, lreq, lreq->linger_id);
+	pr_debug("%s osd %p osd%d lreq %p linger_id %llu\n",
+		 __func__, osd, osd->o_osd, lreq, lreq->linger_id);
 
 	if (!osd_homeless(osd))
 		__remove_osd_from_lru(osd);
@@ -2806,8 +2817,8 @@ static void unlink_linger(struct ceph_osd *osd,
 {
 	verify_osd_locked(osd);
 	WARN_ON(lreq->osd != osd);
-	dout("%s osd %p osd%d lreq %p linger_id %llu\n", __func__, osd,
-	     osd->o_osd, lreq, lreq->linger_id);
+	pr_debug("%s osd %p osd%d lreq %p linger_id %llu\n",
+		 __func__, osd, osd->o_osd, lreq, lreq->linger_id);
 
 	lreq->osd = NULL;
 	erase_linger(&osd->o_linger_requests, lreq);
@@ -2937,14 +2948,16 @@ static void do_watch_notify(struct work_struct *w)
 	struct ceph_osd_linger_request *lreq = lwork->lreq;
 
 	if (!linger_registered(lreq)) {
-		dout("%s lreq %p not registered\n", __func__, lreq);
+		pr_debug("%s lreq %p not registered\n", __func__, lreq);
 		goto out;
 	}
 
 	WARN_ON(!lreq->is_watch);
-	dout("%s lreq %p notify_id %llu notifier_id %llu payload_len %zu\n",
-	     __func__, lreq, lwork->notify.notify_id, lwork->notify.notifier_id,
-	     lwork->notify.payload_len);
+	pr_debug("%s lreq %p notify_id %llu notifier_id %llu payload_len %zu\n",
+		 __func__, lreq,
+		 lwork->notify.notify_id,
+		 lwork->notify.notifier_id,
+		 lwork->notify.payload_len);
 	lreq->wcb(lreq->data, lwork->notify.notify_id, lreq->linger_id,
 		  lwork->notify.notifier_id, lwork->notify.payload,
 		  lwork->notify.payload_len);
@@ -2960,11 +2973,11 @@ static void do_watch_error(struct work_struct *w)
 	struct ceph_osd_linger_request *lreq = lwork->lreq;
 
 	if (!linger_registered(lreq)) {
-		dout("%s lreq %p not registered\n", __func__, lreq);
+		pr_debug("%s lreq %p not registered\n", __func__, lreq);
 		goto out;
 	}
 
-	dout("%s lreq %p err %d\n", __func__, lreq, lwork->error.err);
+	pr_debug("%s lreq %p err %d\n", __func__, lreq, lwork->error.err);
 	lreq->errcb(lreq->data, lreq->linger_id, lwork->error.err);
 
 out:
@@ -2999,8 +3012,8 @@ static void linger_commit_cb(struct ceph_osd_request *req)
 	struct ceph_osd_linger_request *lreq = req->r_priv;
 
 	mutex_lock(&lreq->lock);
-	dout("%s lreq %p linger_id %llu result %d\n", __func__, lreq,
-	     lreq->linger_id, req->r_result);
+	pr_debug("%s lreq %p linger_id %llu result %d\n",
+		 __func__, lreq, lreq->linger_id, req->r_result);
 	linger_reg_commit_complete(lreq, req->r_result);
 	lreq->committed = true;
 
@@ -3015,10 +3028,10 @@ static void linger_commit_cb(struct ceph_osd_request *req)
 		/* make note of the notify_id */
 		if (req->r_ops[0].outdata_len >= sizeof(u64)) {
 			lreq->notify_id = ceph_decode_64(&p);
-			dout("lreq %p notify_id %llu\n", lreq,
-			     lreq->notify_id);
+			pr_debug("lreq %p notify_id %llu\n",
+				 lreq, lreq->notify_id);
 		} else {
-			dout("lreq %p no notify_id\n", lreq);
+			pr_debug("lreq %p no notify_id\n", lreq);
 		}
 	}
 
@@ -3044,8 +3057,9 @@ static void linger_reconnect_cb(struct ceph_osd_request *req)
 	struct ceph_osd_linger_request *lreq = req->r_priv;
 
 	mutex_lock(&lreq->lock);
-	dout("%s lreq %p linger_id %llu result %d last_error %d\n", __func__,
-	     lreq, lreq->linger_id, req->r_result, lreq->last_error);
+	pr_debug("%s lreq %p linger_id %llu result %d last_error %d\n",
+		 __func__,
+		 lreq, lreq->linger_id, req->r_result, lreq->last_error);
 	if (req->r_result < 0) {
 		if (!lreq->last_error) {
 			lreq->last_error = normalize_watch_error(req->r_result);
@@ -3063,7 +3077,8 @@ static void send_linger(struct ceph_osd_linger_request *lreq)
 	struct ceph_osd_req_op *op = &req->r_ops[0];
 
 	verify_osdc_wrlocked(req->r_osdc);
-	dout("%s lreq %p linger_id %llu\n", __func__, lreq, lreq->linger_id);
+	pr_debug("%s lreq %p linger_id %llu\n",
+		 __func__, lreq, lreq->linger_id);
 
 	if (req->r_osd)
 		cancel_linger_request(req);
@@ -3078,15 +3093,15 @@ static void send_linger(struct ceph_osd_linger_request *lreq)
 			op->watch.cookie != lreq->linger_id);
 		op->watch.op = CEPH_OSD_WATCH_OP_RECONNECT;
 		op->watch.gen = ++lreq->register_gen;
-		dout("lreq %p reconnect register_gen %u\n", lreq,
-		     op->watch.gen);
+		pr_debug("lreq %p reconnect register_gen %u\n",
+			 lreq, op->watch.gen);
 		req->r_callback = linger_reconnect_cb;
 	} else {
 		if (!lreq->is_watch)
 			lreq->notify_id = 0;
 		else
 			WARN_ON(op->watch.op != CEPH_OSD_WATCH_OP_WATCH);
-		dout("lreq %p register\n", lreq);
+		pr_debug("lreq %p register\n", lreq);
 		req->r_callback = linger_commit_cb;
 	}
 	mutex_unlock(&lreq->lock);
@@ -3102,9 +3117,9 @@ static void linger_ping_cb(struct ceph_osd_request *req)
 	struct ceph_osd_linger_request *lreq = req->r_priv;
 
 	mutex_lock(&lreq->lock);
-	dout("%s lreq %p linger_id %llu result %d ping_sent %lu last_error %d\n",
-	     __func__, lreq, lreq->linger_id, req->r_result, lreq->ping_sent,
-	     lreq->last_error);
+	pr_debug("%s lreq %p linger_id %llu result %d ping_sent %lu last_error %d\n",
+		 __func__, lreq, lreq->linger_id, req->r_result,
+		 lreq->ping_sent, lreq->last_error);
 	if (lreq->register_gen == req->r_ops[0].watch.gen) {
 		if (!req->r_result) {
 			lreq->watch_valid_thru = lreq->ping_sent;
@@ -3113,8 +3128,8 @@ static void linger_ping_cb(struct ceph_osd_request *req)
 			queue_watch_error(lreq);
 		}
 	} else {
-		dout("lreq %p register_gen %u ignoring old pong %u\n", lreq,
-		     lreq->register_gen, req->r_ops[0].watch.gen);
+		pr_debug("lreq %p register_gen %u ignoring old pong %u\n",
+			 lreq, lreq->register_gen, req->r_ops[0].watch.gen);
 	}
 
 	mutex_unlock(&lreq->lock);
@@ -3128,14 +3143,14 @@ static void send_linger_ping(struct ceph_osd_linger_request *lreq)
 	struct ceph_osd_req_op *op = &req->r_ops[0];
 
 	if (ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSERD)) {
-		dout("%s PAUSERD\n", __func__);
+		pr_debug("%s PAUSERD\n", __func__);
 		return;
 	}
 
 	lreq->ping_sent = jiffies;
-	dout("%s lreq %p linger_id %llu ping_sent %lu register_gen %u\n",
-	     __func__, lreq, lreq->linger_id, lreq->ping_sent,
-	     lreq->register_gen);
+	pr_debug("%s lreq %p linger_id %llu ping_sent %lu register_gen %u\n",
+		 __func__, lreq, lreq->linger_id, lreq->ping_sent,
+		 lreq->register_gen);
 
 	if (req->r_osd)
 		cancel_linger_request(req);
@@ -3233,12 +3248,12 @@ static void check_linger_pool_dne(struct ceph_osd_linger_request *lreq)
 
 	if (lreq->register_gen) {
 		lreq->map_dne_bound = map->epoch;
-		dout("%s lreq %p linger_id %llu pool disappeared\n", __func__,
-		     lreq, lreq->linger_id);
+		pr_debug("%s lreq %p linger_id %llu pool disappeared\n",
+			 __func__, lreq, lreq->linger_id);
 	} else {
-		dout("%s lreq %p linger_id %llu map_dne_bound %u have %u\n",
-		     __func__, lreq, lreq->linger_id, lreq->map_dne_bound,
-		     map->epoch);
+		pr_debug("%s lreq %p linger_id %llu map_dne_bound %u have %u\n",
+			 __func__, lreq, lreq->linger_id, lreq->map_dne_bound,
+			 map->epoch);
 	}
 
 	if (lreq->map_dne_bound) {
@@ -3265,13 +3280,13 @@ static void linger_map_check_cb(struct ceph_mon_generic_request *greq)
 	down_write(&osdc->lock);
 	lreq = lookup_linger_mc(&osdc->linger_map_checks, linger_id);
 	if (!lreq) {
-		dout("%s linger_id %llu dne\n", __func__, linger_id);
+		pr_debug("%s linger_id %llu dne\n", __func__, linger_id);
 		goto out_unlock;
 	}
 
-	dout("%s lreq %p linger_id %llu map_dne_bound %u newest %llu\n",
-	     __func__, lreq, lreq->linger_id, lreq->map_dne_bound,
-	     greq->u.newest);
+	pr_debug("%s lreq %p linger_id %llu map_dne_bound %u newest %llu\n",
+		 __func__, lreq, lreq->linger_id, lreq->map_dne_bound,
+		 greq->u.newest);
 	if (!lreq->map_dne_bound)
 		lreq->map_dne_bound = greq->u.newest;
 	erase_linger_mc(&osdc->linger_map_checks, lreq);
@@ -3308,7 +3323,8 @@ static int linger_reg_commit_wait(struct ceph_osd_linger_request *lreq)
 {
 	int ret;
 
-	dout("%s lreq %p linger_id %llu\n", __func__, lreq, lreq->linger_id);
+	pr_debug("%s lreq %p linger_id %llu\n",
+		 __func__, lreq, lreq->linger_id);
 	ret = wait_for_completion_interruptible(&lreq->reg_commit_wait);
 	return ret ?: lreq->reg_commit_error;
 }
@@ -3317,7 +3333,8 @@ static int linger_notify_finish_wait(struct ceph_osd_linger_request *lreq)
 {
 	int ret;
 
-	dout("%s lreq %p linger_id %llu\n", __func__, lreq, lreq->linger_id);
+	pr_debug("%s lreq %p linger_id %llu\n",
+		 __func__, lreq, lreq->linger_id);
 	ret = wait_for_completion_interruptible(&lreq->notify_finish_wait);
 	return ret ?: lreq->notify_finish_error;
 }
@@ -3338,7 +3355,7 @@ static void handle_timeout(struct work_struct *work)
 	LIST_HEAD(slow_osds);
 	struct rb_node *n, *p;
 
-	dout("%s osdc %p\n", __func__, osdc);
+	pr_debug("%s osdc %p\n", __func__, osdc);
 	down_write(&osdc->lock);
 
 	/*
@@ -3357,8 +3374,8 @@ static void handle_timeout(struct work_struct *work)
 			p = rb_next(p); /* abort_request() */
 
 			if (time_before(req->r_stamp, cutoff)) {
-				dout(" req %p tid %llu on osd%d is laggy\n",
-				     req, req->r_tid, osd->o_osd);
+				pr_debug("req %p tid %llu on osd%d is laggy\n",
+					 req, req->r_tid, osd->o_osd);
 				found = true;
 			}
 			if (opts->osd_request_timeout &&
@@ -3372,8 +3389,8 @@ static void handle_timeout(struct work_struct *work)
 			struct ceph_osd_linger_request *lreq =
 			    rb_entry(p, struct ceph_osd_linger_request, node);
 
-			dout(" lreq %p linger_id %llu is served by osd%d\n",
-			     lreq, lreq->linger_id, osd->o_osd);
+			pr_debug("lreq %p linger_id %llu is served by osd%d\n",
+				 lreq, lreq->linger_id, osd->o_osd);
 			found = true;
 
 			mutex_lock(&lreq->lock);
@@ -3425,7 +3442,7 @@ static void handle_osds_timeout(struct work_struct *work)
 	unsigned long delay = osdc->client->options->osd_idle_ttl / 4;
 	struct ceph_osd *osd, *nosd;
 
-	dout("%s osdc %p\n", __func__, osdc);
+	pr_debug("%s osdc %p\n", __func__, osdc);
 	down_write(&osdc->lock);
 	list_for_each_entry_safe(osd, nosd, &osdc->osd_lru, o_osd_lru) {
 		if (time_before(jiffies, osd->lru_ttl))
@@ -3658,11 +3675,11 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
 	int ret;
 	int i;
 
-	dout("%s msg %p tid %llu\n", __func__, msg, tid);
+	pr_debug("%s msg %p tid %llu\n", __func__, msg, tid);
 
 	down_read(&osdc->lock);
 	if (!osd_registered(osd)) {
-		dout("%s osd%d unknown\n", __func__, osd->o_osd);
+		pr_debug("%s osd%d unknown\n", __func__, osd->o_osd);
 		goto out_unlock_osdc;
 	}
 	WARN_ON(osd->o_osd != le64_to_cpu(msg->hdr.src.num));
@@ -3670,7 +3687,8 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
 	mutex_lock(&osd->lock);
 	req = lookup_request(&osd->o_requests, tid);
 	if (!req) {
-		dout("%s osd%d tid %llu unknown\n", __func__, osd->o_osd, tid);
+		pr_debug("%s osd%d tid %llu unknown\n",
+			 __func__, osd->o_osd, tid);
 		goto out_unlock_session;
 	}
 
@@ -3683,16 +3701,16 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
 		ceph_msg_dump(msg);
 		goto fail_request;
 	}
-	dout("%s req %p tid %llu flags 0x%llx pgid %llu.%x epoch %u attempt %d v %u'%llu uv %llu\n",
-	     __func__, req, req->r_tid, m.flags, m.pgid.pool, m.pgid.seed,
-	     m.epoch, m.retry_attempt, le32_to_cpu(m.replay_version.epoch),
-	     le64_to_cpu(m.replay_version.version), m.user_version);
+	pr_debug("%s req %p tid %llu flags 0x%llx pgid %llu.%x epoch %u attempt %d v %u'%llu uv %llu\n",
+		 __func__, req, req->r_tid, m.flags, m.pgid.pool, m.pgid.seed,
+		 m.epoch, m.retry_attempt, le32_to_cpu(m.replay_version.epoch),
+		 le64_to_cpu(m.replay_version.version), m.user_version);
 
 	if (m.retry_attempt >= 0) {
 		if (m.retry_attempt != req->r_attempts - 1) {
-			dout("req %p tid %llu retry_attempt %d != %d, ignoring\n",
-			     req, req->r_tid, m.retry_attempt,
-			     req->r_attempts - 1);
+			pr_debug("req %p tid %llu retry_attempt %d != %d, ignoring\n",
+				 req, req->r_tid, m.retry_attempt,
+				 req->r_attempts - 1);
 			goto out_unlock_session;
 		}
 	} else {
@@ -3700,8 +3718,8 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
 	}
 
 	if (!ceph_oloc_empty(&m.redirect.oloc)) {
-		dout("req %p tid %llu redirect pool %lld\n", req, req->r_tid,
-		     m.redirect.oloc.pool);
+		pr_debug("req %p tid %llu redirect pool %lld\n",
+			 req, req->r_tid, m.redirect.oloc.pool);
 		unlink_request(osd, req);
 		mutex_unlock(&osd->lock);
 
@@ -3719,7 +3737,7 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
 	}
 
 	if (m.result == -EAGAIN) {
-		dout("req %p tid %llu EAGAIN\n", req, req->r_tid);
+		pr_debug("req %p tid %llu EAGAIN\n", req, req->r_tid);
 		unlink_request(osd, req);
 		mutex_unlock(&osd->lock);
 
@@ -3744,8 +3762,8 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
 		goto fail_request;
 	}
 	for (i = 0; i < req->r_num_ops; i++) {
-		dout(" req %p tid %llu op %d rval %d len %u\n", req,
-		     req->r_tid, i, m.rval[i], m.outdata_len[i]);
+		pr_debug("req %p tid %llu op %d rval %d len %u\n",
+			 req, req->r_tid, i, m.rval[i], m.outdata_len[i]);
 		req->r_ops[i].rval = m.rval[i];
 		req->r_ops[i].outdata_len = m.outdata_len[i];
 		data_len += m.outdata_len[i];
@@ -3755,8 +3773,8 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
 		       le32_to_cpu(msg->hdr.data_len), req->r_tid);
 		goto fail_request;
 	}
-	dout("%s req %p tid %llu result %d data_len %u\n", __func__,
-	     req, req->r_tid, m.result, data_len);
+	pr_debug("%s req %p tid %llu result %d data_len %u\n",
+		 __func__, req, req->r_tid, m.result, data_len);
 
 	/*
 	 * Since we only ever request ONDISK, we should only ever get
@@ -3843,8 +3861,8 @@ static void scan_requests(struct ceph_osd *osd,
 
 		n = rb_next(n); /* recalc_linger_target() */
 
-		dout("%s lreq %p linger_id %llu\n", __func__, lreq,
-		     lreq->linger_id);
+		pr_debug("%s lreq %p linger_id %llu\n",
+			 __func__, lreq, lreq->linger_id);
 		ct_res = recalc_linger_target(lreq);
 		switch (ct_res) {
 		case CALC_TARGET_NO_ACTION:
@@ -3879,7 +3897,7 @@ static void scan_requests(struct ceph_osd *osd,
 
 		n = rb_next(n); /* unlink_request(), check_pool_dne() */
 
-		dout("%s req %p tid %llu\n", __func__, req, req->r_tid);
+		pr_debug("%s req %p tid %llu\n", __func__, req, req->r_tid);
 		ct_res = calc_target(osdc, &req->r_t, false);
 		switch (ct_res) {
 		case CALC_TARGET_NO_ACTION:
@@ -4044,7 +4062,7 @@ void ceph_osdc_handle_map(struct ceph_osd_client *osdc, struct ceph_msg *msg)
 	bool pauserd, pausewr;
 	int err;
 
-	dout("%s have %u\n", __func__, osdc->osdmap->epoch);
+	pr_debug("%s have %u\n", __func__, osdc->osdmap->epoch);
 	down_write(&osdc->lock);
 
 	/* verify fsid */
@@ -4060,7 +4078,7 @@ void ceph_osdc_handle_map(struct ceph_osd_client *osdc, struct ceph_msg *msg)
 
 	/* incremental maps */
 	ceph_decode_32_safe(&p, end, nr_maps, bad);
-	dout(" %d inc maps\n", nr_maps);
+	pr_debug("%d inc maps\n", nr_maps);
 	while (nr_maps > 0) {
 		ceph_decode_need(&p, end, 2*sizeof(u32), bad);
 		epoch = ceph_decode_32(&p);
@@ -4068,16 +4086,16 @@ void ceph_osdc_handle_map(struct ceph_osd_client *osdc, struct ceph_msg *msg)
 		ceph_decode_need(&p, end, maplen, bad);
 		if (osdc->osdmap->epoch &&
 		    osdc->osdmap->epoch + 1 == epoch) {
-			dout("applying incremental map %u len %d\n",
-			     epoch, maplen);
+			pr_debug("applying incremental map %u len %d\n",
+				 epoch, maplen);
 			err = handle_one_map(osdc, p, p + maplen, true,
 					     &need_resend, &need_resend_linger);
 			if (err)
 				goto bad;
 			handled_incremental = true;
 		} else {
-			dout("ignoring incremental map %u len %d\n",
-			     epoch, maplen);
+			pr_debug("ignoring incremental map %u len %d\n",
+				 epoch, maplen);
 		}
 		p += maplen;
 		nr_maps--;
@@ -4087,21 +4105,20 @@ void ceph_osdc_handle_map(struct ceph_osd_client *osdc, struct ceph_msg *msg)
 
 	/* full maps */
 	ceph_decode_32_safe(&p, end, nr_maps, bad);
-	dout(" %d full maps\n", nr_maps);
+	pr_debug("%d full maps\n", nr_maps);
 	while (nr_maps) {
 		ceph_decode_need(&p, end, 2*sizeof(u32), bad);
 		epoch = ceph_decode_32(&p);
 		maplen = ceph_decode_32(&p);
 		ceph_decode_need(&p, end, maplen, bad);
 		if (nr_maps > 1) {
-			dout("skipping non-latest full map %u len %d\n",
-			     epoch, maplen);
+			pr_debug("skipping non-latest full map %u len %d\n",
+				 epoch, maplen);
 		} else if (osdc->osdmap->epoch >= epoch) {
-			dout("skipping full map %u len %d, "
-			     "older than our %u\n", epoch, maplen,
-			     osdc->osdmap->epoch);
+			pr_debug("skipping full map %u len %d, older than our %u\n",
+				 epoch, maplen, osdc->osdmap->epoch);
 		} else {
-			dout("taking full map %u len %d\n", epoch, maplen);
+			pr_debug("taking full map %u len %d\n", epoch, maplen);
 			err = handle_one_map(osdc, p, p + maplen, false,
 					     &need_resend, &need_resend_linger);
 			if (err)
@@ -4178,11 +4195,11 @@ static void osd_fault(struct ceph_connection *con)
 	struct ceph_osd *osd = con->private;
 	struct ceph_osd_client *osdc = osd->o_osdc;
 
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	pr_debug("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
 
 	down_write(&osdc->lock);
 	if (!osd_registered(osd)) {
-		dout("%s osd%d unknown\n", __func__, osd->o_osd);
+		pr_debug("%s osd%d unknown\n", __func__, osd->o_osd);
 		goto out_unlock;
 	}
 
@@ -4297,8 +4314,9 @@ static void handle_backoff_block(struct ceph_osd *osd, struct MOSDBackoff *m)
 	struct ceph_osd_backoff *backoff;
 	struct ceph_msg *msg;
 
-	dout("%s osd%d spgid %llu.%xs%d id %llu\n", __func__, osd->o_osd,
-	     m->spgid.pgid.pool, m->spgid.pgid.seed, m->spgid.shard, m->id);
+	pr_debug("%s osd%d spgid %llu.%xs%d id %llu\n",
+		 __func__, osd->o_osd,
+		 m->spgid.pgid.pool, m->spgid.pgid.seed, m->spgid.shard, m->id);
 
 	spg = lookup_spg_mapping(&osd->o_backoff_mappings, &m->spgid);
 	if (!spg) {
@@ -4357,8 +4375,9 @@ static void handle_backoff_unblock(struct ceph_osd *osd,
 	struct ceph_osd_backoff *backoff;
 	struct rb_node *n;
 
-	dout("%s osd%d spgid %llu.%xs%d id %llu\n", __func__, osd->o_osd,
-	     m->spgid.pgid.pool, m->spgid.pgid.seed, m->spgid.shard, m->id);
+	pr_debug("%s osd%d spgid %llu.%xs%d id %llu\n",
+		 __func__, osd->o_osd,
+		 m->spgid.pgid.pool, m->spgid.pgid.seed, m->spgid.shard, m->id);
 
 	backoff = lookup_backoff_by_id(&osd->o_backoffs_by_id, m->id);
 	if (!backoff) {
@@ -4416,7 +4435,7 @@ static void handle_backoff(struct ceph_osd *osd, struct ceph_msg *msg)
 
 	down_read(&osdc->lock);
 	if (!osd_registered(osd)) {
-		dout("%s osd%d unknown\n", __func__, osd->o_osd);
+		pr_debug("%s osd%d unknown\n", __func__, osd->o_osd);
 		up_read(&osdc->lock);
 		return;
 	}
@@ -4488,14 +4507,14 @@ static void handle_watch_notify(struct ceph_osd_client *osdc,
 	down_read(&osdc->lock);
 	lreq = lookup_linger_osdc(&osdc->linger_requests, cookie);
 	if (!lreq) {
-		dout("%s opcode %d cookie %llu dne\n", __func__, opcode,
-		     cookie);
+		pr_debug("%s opcode %d cookie %llu dne\n",
+			 __func__, opcode, cookie);
 		goto out_unlock_osdc;
 	}
 
 	mutex_lock(&lreq->lock);
-	dout("%s opcode %d cookie %llu lreq %p is_watch %d\n", __func__,
-	     opcode, cookie, lreq, lreq->is_watch);
+	pr_debug("%s opcode %d cookie %llu lreq %p is_watch %d\n",
+		 __func__, opcode, cookie, lreq, lreq->is_watch);
 	if (opcode == CEPH_WATCH_EVENT_DISCONNECT) {
 		if (!lreq->last_error) {
 			lreq->last_error = -ENOTCONN;
@@ -4504,8 +4523,8 @@ static void handle_watch_notify(struct ceph_osd_client *osdc,
 	} else if (!lreq->is_watch) {
 		/* CEPH_WATCH_EVENT_NOTIFY_COMPLETE */
 		if (lreq->notify_id && lreq->notify_id != notify_id) {
-			dout("lreq %p notify_id %llu != %llu, ignoring\n", lreq,
-			     lreq->notify_id, notify_id);
+			pr_debug("lreq %p notify_id %llu != %llu, ignoring\n",
+				 lreq, lreq->notify_id, notify_id);
 		} else if (!completion_done(&lreq->notify_finish_wait)) {
 			struct ceph_msg_data *data =
 			    msg->num_data_items ? &msg->data[0] : NULL;
@@ -4586,7 +4605,7 @@ static int wait_request_timeout(struct ceph_osd_request *req,
 {
 	long left;
 
-	dout("%s req %p tid %llu\n", __func__, req, req->r_tid);
+	pr_debug("%s req %p tid %llu\n", __func__, req, req->r_tid);
 	left = wait_for_completion_killable_timeout(&req->r_completion,
 						ceph_timeout_jiffies(timeout));
 	if (left <= 0) {
@@ -4636,8 +4655,8 @@ void ceph_osdc_sync(struct ceph_osd_client *osdc)
 			ceph_osdc_get_request(req);
 			mutex_unlock(&osd->lock);
 			up_read(&osdc->lock);
-			dout("%s waiting on req %p tid %llu last_tid %llu\n",
-			     __func__, req, req->r_tid, last_tid);
+			pr_debug("%s waiting on req %p tid %llu last_tid %llu\n",
+				 __func__, req, req->r_tid, last_tid);
 			wait_for_completion(&req->r_completion);
 			ceph_osdc_put_request(req);
 			goto again;
@@ -4647,7 +4666,7 @@ void ceph_osdc_sync(struct ceph_osd_client *osdc)
 	}
 
 	up_read(&osdc->lock);
-	dout("%s done last_tid %llu\n", __func__, last_tid);
+	pr_debug("%s done last_tid %llu\n", __func__, last_tid);
 }
 EXPORT_SYMBOL(ceph_osdc_sync);
 
@@ -4954,7 +4973,7 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc,
 	if (!ret)
 		ret = linger_notify_finish_wait(lreq);
 	else
-		dout("lreq %p failed to initiate notify %d\n", lreq, ret);
+		pr_debug("lreq %p failed to initiate notify %d\n", lreq, ret);
 
 	linger_cancel(lreq);
 out_put_lreq:
@@ -4987,8 +5006,8 @@ int ceph_osdc_watch_check(struct ceph_osd_client *osdc,
 			stamp = lwork->queued_stamp;
 	}
 	age = jiffies - stamp;
-	dout("%s lreq %p linger_id %llu age %lu last_error %d\n", __func__,
-	     lreq, lreq->linger_id, age, lreq->last_error);
+	pr_debug("%s lreq %p linger_id %llu age %lu last_error %d\n",
+		 __func__, lreq, lreq->linger_id, age, lreq->last_error);
 	/* we are truncating to msecs, so return a safe upper bound */
 	ret = lreq->last_error ?: 1 + jiffies_to_msecs(age);
 
@@ -5021,9 +5040,9 @@ static int decode_watcher(void **p, void *end, struct ceph_watch_item *item)
 		ret = 0;
 	}
 
-	dout("%s %s%llu cookie %llu addr %s\n", __func__,
-	     ENTITY_NAME(item->name), item->cookie,
-	     ceph_pr_addr(&item->addr));
+	pr_debug("%s %s%llu cookie %llu addr %s\n",
+		 __func__, ENTITY_NAME(item->name), item->cookie,
+		 ceph_pr_addr(&item->addr));
 bad:
 	return ret;
 }
@@ -5117,7 +5136,7 @@ EXPORT_SYMBOL(ceph_osdc_list_watchers);
  */
 void ceph_osdc_flush_notifies(struct ceph_osd_client *osdc)
 {
-	dout("%s osdc %p\n", __func__, osdc);
+	pr_debug("%s osdc %p\n", __func__, osdc);
 	flush_workqueue(osdc->notify_wq);
 }
 EXPORT_SYMBOL(ceph_osdc_flush_notifies);
@@ -5212,7 +5231,7 @@ int ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
 {
 	int err;
 
-	dout("init\n");
+	pr_debug("init\n");
 	osdc->client = client;
 	init_rwsem(&osdc->lock);
 	osdc->osds = RB_ROOT;
@@ -5457,7 +5476,7 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 
 	down_read(&osdc->lock);
 	if (!osd_registered(osd)) {
-		dout("%s osd%d unknown, skipping\n", __func__, osd->o_osd);
+		pr_debug("%s osd%d unknown, skipping\n", __func__, osd->o_osd);
 		*skip = 1;
 		goto out_unlock_osdc;
 	}
@@ -5466,8 +5485,8 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	mutex_lock(&osd->lock);
 	req = lookup_request(&osd->o_requests, tid);
 	if (!req) {
-		dout("%s osd%d tid %llu unknown, skipping\n", __func__,
-		     osd->o_osd, tid);
+		pr_debug("%s osd%d tid %llu unknown, skipping\n",
+			 __func__, osd->o_osd, tid);
 		*skip = 1;
 		goto out_unlock_session;
 	}
@@ -5496,7 +5515,7 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	}
 
 	m = ceph_msg_get(req->r_reply);
-	dout("get_reply tid %lld %p\n", tid, m);
+	pr_debug("get_reply tid %lld %p\n", tid, m);
 
 out_unlock_session:
 	mutex_unlock(&osd->lock);
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 96c25f5e064a..e47e16aeb008 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -55,7 +55,7 @@ static void calc_pg_masks(struct ceph_pg_pool_info *pi)
 static int crush_decode_uniform_bucket(void **p, void *end,
 				       struct crush_bucket_uniform *b)
 {
-	dout("crush_decode_uniform_bucket %p to %p\n", *p, end);
+	pr_debug("crush_decode_uniform_bucket %p to %p\n", *p, end);
 	ceph_decode_need(p, end, (1+b->h.size) * sizeof(u32), bad);
 	b->item_weight = ceph_decode_32(p);
 	return 0;
@@ -67,7 +67,7 @@ static int crush_decode_list_bucket(void **p, void *end,
 				    struct crush_bucket_list *b)
 {
 	int j;
-	dout("crush_decode_list_bucket %p to %p\n", *p, end);
+	pr_debug("crush_decode_list_bucket %p to %p\n", *p, end);
 	b->item_weights = kcalloc(b->h.size, sizeof(u32), GFP_NOFS);
 	if (b->item_weights == NULL)
 		return -ENOMEM;
@@ -88,7 +88,7 @@ static int crush_decode_tree_bucket(void **p, void *end,
 				    struct crush_bucket_tree *b)
 {
 	int j;
-	dout("crush_decode_tree_bucket %p to %p\n", *p, end);
+	pr_debug("crush_decode_tree_bucket %p to %p\n", *p, end);
 	ceph_decode_8_safe(p, end, b->num_nodes, bad);
 	b->node_weights = kcalloc(b->num_nodes, sizeof(u32), GFP_NOFS);
 	if (b->node_weights == NULL)
@@ -105,7 +105,7 @@ static int crush_decode_straw_bucket(void **p, void *end,
 				     struct crush_bucket_straw *b)
 {
 	int j;
-	dout("crush_decode_straw_bucket %p to %p\n", *p, end);
+	pr_debug("crush_decode_straw_bucket %p to %p\n", *p, end);
 	b->item_weights = kcalloc(b->h.size, sizeof(u32), GFP_NOFS);
 	if (b->item_weights == NULL)
 		return -ENOMEM;
@@ -126,7 +126,7 @@ static int crush_decode_straw2_bucket(void **p, void *end,
 				      struct crush_bucket_straw2 *b)
 {
 	int j;
-	dout("crush_decode_straw2_bucket %p to %p\n", *p, end);
+	pr_debug("crush_decode_straw2_bucket %p to %p\n", *p, end);
 	b->item_weights = kcalloc(b->h.size, sizeof(u32), GFP_NOFS);
 	if (b->item_weights == NULL)
 		return -ENOMEM;
@@ -421,7 +421,7 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 	void *start = pbyval;
 	u32 magic;
 
-	dout("crush_decode %p to %p len %d\n", *p, end, (int)(end - *p));
+	pr_debug("crush_decode %p to %p len %d\n", *p, end, (int)(end - *p));
 
 	c = kzalloc(sizeof(*c), GFP_NOFS);
 	if (c == NULL)
@@ -466,8 +466,8 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 			c->buckets[i] = NULL;
 			continue;
 		}
-		dout("crush_decode bucket %d off %x %p to %p\n",
-		     i, (int)(*p-start), *p, end);
+		pr_debug("crush_decode bucket %d off %x %p to %p\n",
+			 i, (int)(*p - start), *p, end);
 
 		switch (alg) {
 		case CRUSH_BUCKET_UNIFORM:
@@ -501,8 +501,8 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 		b->weight = ceph_decode_32(p);
 		b->size = ceph_decode_32(p);
 
-		dout("crush_decode bucket size %d off %x %p to %p\n",
-		     b->size, (int)(*p-start), *p, end);
+		pr_debug("crush_decode bucket size %d off %x %p to %p\n",
+			 b->size, (int)(*p - start), *p, end);
 
 		b->items = kcalloc(b->size, sizeof(__s32), GFP_NOFS);
 		if (b->items == NULL)
@@ -547,21 +547,21 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 	}
 
 	/* rules */
-	dout("rule vec is %p\n", c->rules);
+	pr_debug("rule vec is %p\n", c->rules);
 	for (i = 0; i < c->max_rules; i++) {
 		u32 yes;
 		struct crush_rule *r;
 
 		ceph_decode_32_safe(p, end, yes, bad);
 		if (!yes) {
-			dout("crush_decode NO rule %d off %x %p to %p\n",
-			     i, (int)(*p-start), *p, end);
+			pr_debug("crush_decode NO rule %d off %x %p to %p\n",
+				 i, (int)(*p - start), *p, end);
 			c->rules[i] = NULL;
 			continue;
 		}
 
-		dout("crush_decode rule %d off %x %p to %p\n",
-		     i, (int)(*p-start), *p, end);
+		pr_debug("crush_decode rule %d off %x %p to %p\n",
+			 i, (int)(*p - start), *p, end);
 
 		/* len */
 		ceph_decode_32_safe(p, end, yes, bad);
@@ -574,7 +574,7 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 		c->rules[i] = r;
 		if (r == NULL)
 			goto badmem;
-		dout(" rule %d is at %p\n", i, r);
+		pr_debug("rule %d is at %p\n", i, r);
 		r->len = yes;
 		ceph_decode_copy_safe(p, end, &r->mask, 4, bad); /* 4 u8's */
 		ceph_decode_need(p, end, r->len*3*sizeof(u32), bad);
@@ -600,22 +600,22 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
         c->choose_local_tries = ceph_decode_32(p);
         c->choose_local_fallback_tries =  ceph_decode_32(p);
         c->choose_total_tries = ceph_decode_32(p);
-        dout("crush decode tunable choose_local_tries = %d\n",
-             c->choose_local_tries);
-        dout("crush decode tunable choose_local_fallback_tries = %d\n",
-             c->choose_local_fallback_tries);
-        dout("crush decode tunable choose_total_tries = %d\n",
-             c->choose_total_tries);
+	pr_debug("crush decode tunable choose_local_tries = %d\n",
+		 c->choose_local_tries);
+	pr_debug("crush decode tunable choose_local_fallback_tries = %d\n",
+		 c->choose_local_fallback_tries);
+	pr_debug("crush decode tunable choose_total_tries = %d\n",
+		 c->choose_total_tries);
 
 	ceph_decode_need(p, end, sizeof(u32), done);
 	c->chooseleaf_descend_once = ceph_decode_32(p);
-	dout("crush decode tunable chooseleaf_descend_once = %d\n",
-	     c->chooseleaf_descend_once);
+	pr_debug("crush decode tunable chooseleaf_descend_once = %d\n",
+		 c->chooseleaf_descend_once);
 
 	ceph_decode_need(p, end, sizeof(u8), done);
 	c->chooseleaf_vary_r = ceph_decode_8(p);
-	dout("crush decode tunable chooseleaf_vary_r = %d\n",
-	     c->chooseleaf_vary_r);
+	pr_debug("crush decode tunable chooseleaf_vary_r = %d\n",
+		 c->chooseleaf_vary_r);
 
 	/* skip straw_calc_version, allowed_bucket_algs */
 	ceph_decode_need(p, end, sizeof(u8) + sizeof(u32), done);
@@ -623,8 +623,8 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 
 	ceph_decode_need(p, end, sizeof(u8), done);
 	c->chooseleaf_stable = ceph_decode_8(p);
-	dout("crush decode tunable chooseleaf_stable = %d\n",
-	     c->chooseleaf_stable);
+	pr_debug("crush decode tunable chooseleaf_stable = %d\n",
+		 c->chooseleaf_stable);
 
 	if (*p != end) {
 		/* class_map */
@@ -643,13 +643,13 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 
 done:
 	crush_finalize(c);
-	dout("crush_decode success\n");
+	pr_debug("crush_decode success\n");
 	return c;
 
 badmem:
 	err = -ENOMEM;
 fail:
-	dout("crush_decode fail %d\n", err);
+	pr_debug("crush_decode fail %d\n", err);
 	crush_destroy(c);
 	return ERR_PTR(err);
 
@@ -940,11 +940,11 @@ static int decode_pool_names(void **p, void *end, struct ceph_osdmap *map)
 	u64 pool;
 
 	ceph_decode_32_safe(p, end, num, bad);
-	dout(" %d pool names\n", num);
+	pr_debug("%d pool names\n", num);
 	while (num--) {
 		ceph_decode_64_safe(p, end, pool, bad);
 		ceph_decode_32_safe(p, end, len, bad);
-		dout("  pool %llu len %d\n", pool, len);
+		pr_debug("pool %llu len %d\n", pool, len);
 		ceph_decode_need(p, end, len, bad);
 		pi = lookup_pg_pool(&map->pg_pools, pool);
 		if (pi) {
@@ -954,7 +954,7 @@ static int decode_pool_names(void **p, void *end, struct ceph_osdmap *map)
 				return -ENOMEM;
 			kfree(pi->name);
 			pi->name = name;
-			dout("  name is %s\n", pi->name);
+			pr_debug("name is %s\n", pi->name);
 		}
 		*p += len;
 	}
@@ -988,7 +988,7 @@ struct ceph_osdmap *ceph_osdmap_alloc(void)
 
 void ceph_osdmap_destroy(struct ceph_osdmap *map)
 {
-	dout("osdmap_destroy %p\n", map);
+	pr_debug("osdmap_destroy %p\n", map);
 	if (map->crush)
 		crush_destroy(map->crush);
 	while (!RB_EMPTY_ROOT(&map->pg_temp)) {
@@ -1046,7 +1046,7 @@ static int osdmap_set_max_osd(struct ceph_osdmap *map, u32 max)
 	u32 to_copy;
 	int i;
 
-	dout("%s old %u new %u\n", __func__, map->max_osd, max);
+	pr_debug("%s old %u new %u\n", __func__, map->max_osd, max);
 	if (max == map->max_osd)
 		return 0;
 
@@ -1111,7 +1111,7 @@ static int osdmap_set_crush(struct ceph_osdmap *map, struct crush_map *crush)
 		return PTR_ERR(crush);
 
 	work_size = crush_work_size(crush, CEPH_PG_MAX_SIZE);
-	dout("%s work_size %zu bytes\n", __func__, work_size);
+	pr_debug("%s work_size %zu bytes\n", __func__, work_size);
 	workspace = ceph_kvmalloc(work_size, GFP_NOIO);
 	if (!workspace) {
 		crush_destroy(crush);
@@ -1520,7 +1520,7 @@ static int osdmap_decode(void **p, void *end, struct ceph_osdmap *map)
 	u32 len, i;
 	int err;
 
-	dout("%s %p to %p len %d\n", __func__, *p, end, (int)(end - *p));
+	pr_debug("%s %p to %p len %d\n", __func__, *p, end, (int)(end - *p));
 
 	err = get_osdmap_client_data_v(p, end, "full", &struct_v);
 	if (err)
@@ -1637,7 +1637,7 @@ static int osdmap_decode(void **p, void *end, struct ceph_osdmap *map)
 	/* ignore the rest */
 	*p = end;
 
-	dout("full osdmap epoch %d max_osd %d\n", map->epoch, map->max_osd);
+	pr_debug("full osdmap epoch %d max_osd %d\n", map->epoch, map->max_osd);
 	return 0;
 
 e_inval:
@@ -1805,7 +1805,7 @@ struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end,
 	int err;
 	u8 struct_v;
 
-	dout("%s %p to %p len %d\n", __func__, *p, end, (int)(end - *p));
+	pr_debug("%s %p to %p len %d\n", __func__, *p, end, (int)(end - *p));
 
 	err = get_osdmap_client_data_v(p, end, "inc", &struct_v);
 	if (err)
@@ -1824,8 +1824,8 @@ struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end,
 	/* full map? */
 	ceph_decode_32_safe(p, end, len, e_inval);
 	if (len > 0) {
-		dout("apply_incremental full map len %d, %p to %p\n",
-		     len, *p, end);
+		pr_debug("apply_incremental full map len %d, %p to %p\n",
+			 len, *p, end);
 		return ceph_osdmap_decode(p, min(*p+len, end));
 	}
 
@@ -1930,7 +1930,7 @@ struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end,
 	/* ignore the rest */
 	*p = end;
 
-	dout("inc osdmap epoch %d max_osd %d\n", map->epoch, map->max_osd);
+	pr_debug("inc osdmap epoch %d max_osd %d\n", map->epoch, map->max_osd);
 	return map;
 
 e_inval:
@@ -2230,8 +2230,8 @@ void __ceph_object_locator_to_pg(struct ceph_pg_pool_info *pi,
 		raw_pgid->pool = oloc->pool;
 		raw_pgid->seed = ceph_str_hash(pi->object_hash, oid->name,
 					     oid->name_len);
-		dout("%s %s -> raw_pgid %llu.%x\n", __func__, oid->name,
-		     raw_pgid->pool, raw_pgid->seed);
+		pr_debug("%s %s -> raw_pgid %llu.%x\n",
+			 __func__, oid->name, raw_pgid->pool, raw_pgid->seed);
 	} else {
 		char stack_buf[256];
 		char *buf = stack_buf;
@@ -2247,9 +2247,9 @@ void __ceph_object_locator_to_pg(struct ceph_pg_pool_info *pi,
 		raw_pgid->seed = ceph_str_hash(pi->object_hash, buf, total);
 		if (buf != stack_buf)
 			kfree(buf);
-		dout("%s %s ns %.*s -> raw_pgid %llu.%x\n", __func__,
-		     oid->name, nsl, oloc->pool_ns->str,
-		     raw_pgid->pool, raw_pgid->seed);
+		pr_debug("%s %s ns %.*s -> raw_pgid %llu.%x\n",
+			 __func__, oid->name, nsl, oloc->pool_ns->str,
+			 raw_pgid->pool, raw_pgid->seed);
 	}
 }
 
@@ -2758,7 +2758,7 @@ int ceph_parse_crush_location(char *crush_location, struct rb_root *locs)
 	const char *type_name, *name, *colon;
 	size_t type_name_len, name_len;
 
-	dout("%s '%s'\n", __func__, crush_location);
+	pr_debug("%s '%s'\n", __func__, crush_location);
 	while ((type_name = strsep(&crush_location, "|"))) {
 		colon = strchr(type_name, ':');
 		if (!colon)
@@ -2790,8 +2790,9 @@ int ceph_parse_crush_location(char *crush_location, struct rb_root *locs)
 			return -EEXIST;
 		}
 
-		dout("%s type_name '%s' name '%s'\n", __func__,
-		     loc->cl_loc.cl_type_name, loc->cl_loc.cl_name);
+		pr_debug("%s type_name '%s' name '%s'\n",
+			 __func__,
+			 loc->cl_loc.cl_type_name, loc->cl_loc.cl_name);
 	}
 
 	return 0;
diff --git a/net/ceph/pagevec.c b/net/ceph/pagevec.c
index 64305e7056a1..598a93254998 100644
--- a/net/ceph/pagevec.c
+++ b/net/ceph/pagevec.c
@@ -140,26 +140,26 @@ void ceph_zero_page_vector_range(int off, int len, struct page **pages)
 
 	off &= ~PAGE_MASK;
 
-	dout("zero_page_vector_page %u~%u\n", off, len);
+	pr_debug("zero_page_vector_page %u~%u\n", off, len);
 
 	/* leading partial page? */
 	if (off) {
 		int end = min((int)PAGE_SIZE, off + len);
-		dout("zeroing %d %p head from %d\n", i, pages[i],
-		     (int)off);
+		pr_debug("zeroing %d %p head from %d\n",
+			 i, pages[i], (int)off);
 		zero_user_segment(pages[i], off, end);
 		len -= (end - off);
 		i++;
 	}
 	while (len >= PAGE_SIZE) {
-		dout("zeroing %d %p len=%d\n", i, pages[i], len);
+		pr_debug("zeroing %d %p len=%d\n", i, pages[i], len);
 		zero_user_segment(pages[i], 0, PAGE_SIZE);
 		len -= PAGE_SIZE;
 		i++;
 	}
 	/* trailing partial page? */
 	if (len) {
-		dout("zeroing %d %p tail to %d\n", i, pages[i], (int)len);
+		pr_debug("zeroing %d %p tail to %d\n", i, pages[i], (int)len);
 		zero_user_segment(pages[i], 0, len);
 	}
 }
-- 
2.26.0

