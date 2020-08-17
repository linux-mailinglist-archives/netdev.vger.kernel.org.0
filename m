Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246E3245A72
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 03:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgHQBeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 21:34:50 -0400
Received: from smtprelay0004.hostedemail.com ([216.40.44.4]:58222 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726263AbgHQBeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 21:34:46 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id D16D4364D;
        Mon, 17 Aug 2020 01:34:42 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:69:327:355:379:541:800:960:968:973:988:989:1260:1311:1314:1345:1359:1437:1515:1605:1730:1747:1777:1792:2194:2199:2393:2538:2553:2559:2562:2689:2898:2899:2900:3138:3139:3140:3141:3142:3865:3867:3868:3870:3871:3874:4250:4321:4384:4605:5007:6119:6248:6261:6691:7875:7903:8603:9040:10004:10226:10848:11026:11473:11658:11914:12043:12291:12296:12297:12438:12555:12679:12683:12895:12986:13894:14110:14394:21080:21324:21433:21451:21627:21740:21810:21987:21990:30029:30030:30045:30054:30056:30070:30090,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: legs45_2e0dfbb27012
X-Filterd-Recvd-Size: 24447
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Mon, 17 Aug 2020 01:34:41 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ceph-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 4/6] net: ceph: Remove embedded function names from pr_debug uses
Date:   Sun, 16 Aug 2020 18:34:07 -0700
Message-Id: <7b5986dfb99bc7ad7cc8e80f89dc0e8547457847.1597626802.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1597626802.git.joe@perches.com>
References: <cover.1597626802.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use "%s: " ..., __func__ so function renaming changes the logging too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/ceph/auth_none.c   |  2 +-
 net/ceph/auth_x.c      | 26 ++++++------
 net/ceph/ceph_common.c |  4 +-
 net/ceph/debugfs.c     |  2 +-
 net/ceph/messenger.c   | 91 +++++++++++++++++++++---------------------
 net/ceph/mon_client.c  |  8 ++--
 net/ceph/msgpool.c     |  4 +-
 net/ceph/osd_client.c  |  6 +--
 net/ceph/osdmap.c      | 30 +++++++-------
 9 files changed, 87 insertions(+), 86 deletions(-)

diff --git a/net/ceph/auth_none.c b/net/ceph/auth_none.c
index f4be840c5961..d6e6e27e6899 100644
--- a/net/ceph/auth_none.c
+++ b/net/ceph/auth_none.c
@@ -130,7 +130,7 @@ int ceph_auth_none_init(struct ceph_auth_client *ac)
 {
 	struct ceph_auth_none_info *xi;
 
-	pr_debug("ceph_auth_none_init %p\n", ac);
+	pr_debug("%s: %p\n", __func__, ac);
 	xi = kzalloc(sizeof(*xi), GFP_NOFS);
 	if (!xi)
 		return -ENOMEM;
diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index f83944ec10c3..312362515c28 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -25,8 +25,8 @@ static int ceph_x_is_authenticated(struct ceph_auth_client *ac)
 	int need;
 
 	ceph_x_validate_tickets(ac, &need);
-	pr_debug("ceph_x_is_authenticated want=%d need=%d have=%d\n",
-		 ac->want_keys, need, xi->have_keys);
+	pr_debug("%s: want=%d need=%d have=%d\n",
+		 __func__, ac->want_keys, need, xi->have_keys);
 	return (ac->want_keys & xi->have_keys) == ac->want_keys;
 }
 
@@ -36,8 +36,8 @@ static int ceph_x_should_authenticate(struct ceph_auth_client *ac)
 	int need;
 
 	ceph_x_validate_tickets(ac, &need);
-	pr_debug("ceph_x_should_authenticate want=%d need=%d have=%d\n",
-		 ac->want_keys, need, xi->have_keys);
+	pr_debug("%s: want=%d need=%d have=%d\n",
+		 __func__, ac->want_keys, need, xi->have_keys);
 	return need != 0;
 }
 
@@ -146,7 +146,7 @@ static void remove_ticket_handler(struct ceph_auth_client *ac,
 {
 	struct ceph_x_info *xi = ac->private;
 
-	pr_debug("remove_ticket_handler %p %d\n", th, th->service);
+	pr_debug("%s: %p %d\n", __func__, th, th->service);
 	rb_erase(&th->node, &xi->ticket_handlers);
 	ceph_crypto_key_destroy(&th->session_key);
 	if (th->ticket_blob)
@@ -672,8 +672,8 @@ static int ceph_x_update_authorizer(
 
 	au = (struct ceph_x_authorizer *)auth->authorizer;
 	if (au->secret_id < th->secret_id) {
-		pr_debug("ceph_x_update_authorizer service %u secret %llu < %llu\n",
-			 au->service, au->secret_id, th->secret_id);
+		pr_debug("%s: service %u secret %llu < %llu\n",
+			 __func__, au->service, au->secret_id, th->secret_id);
 		return ceph_x_build_authorizer(ac, th, au);
 	}
 	return 0;
@@ -766,7 +766,7 @@ static void ceph_x_destroy(struct ceph_auth_client *ac)
 	struct ceph_x_info *xi = ac->private;
 	struct rb_node *p;
 
-	pr_debug("ceph_x_destroy %p\n", ac);
+	pr_debug("%s: %p\n", __func__, ac);
 	ceph_crypto_key_destroy(&xi->secret);
 
 	while ((p = rb_first(&xi->ticket_handlers)) != NULL) {
@@ -903,11 +903,11 @@ static int ceph_x_check_message_signature(struct ceph_auth_handshake *auth,
 	if (sig_check == msg->footer.sig)
 		return 0;
 	if (msg->footer.flags & CEPH_MSG_FOOTER_SIGNED)
-		pr_debug("ceph_x_check_message_signature %p has signature %llx expect %llx\n",
-			 msg, msg->footer.sig, sig_check);
+		pr_debug("%s: %p has signature %llx expect %llx\n",
+			 __func__, msg, msg->footer.sig, sig_check);
 	else
-		pr_debug("ceph_x_check_message_signature %p sender did not set CEPH_MSG_FOOTER_SIGNED\n",
-			 msg);
+		pr_debug("%s: %p sender did not set CEPH_MSG_FOOTER_SIGNED\n",
+			 __func__, msg);
 	return -EBADMSG;
 }
 
@@ -934,7 +934,7 @@ int ceph_x_init(struct ceph_auth_client *ac)
 	struct ceph_x_info *xi;
 	int ret;
 
-	pr_debug("ceph_x_init %p\n", ac);
+	pr_debug("%s: %p\n", __func__, ac);
 	ret = -ENOMEM;
 	xi = kzalloc(sizeof(*xi), GFP_NOFS);
 	if (!xi)
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 1750e14115e6..e8af3bf2fdb5 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -224,7 +224,7 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
 	int err = -EINVAL;
 	int d;
 
-	pr_debug("parse_fsid '%s'\n", str);
+	pr_debug("%s: '%s'\n", __func__, str);
 	tmp[2] = 0;
 	while (*str && i < 16) {
 		if (ispunct(*str)) {
@@ -244,7 +244,7 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
 
 	if (i == 16)
 		err = 0;
-	pr_debug("parse_fsid ret %d got fsid %pU\n", err, fsid);
+	pr_debug("%s: ret %d got fsid %pU\n", __func__, err, fsid);
 	return err;
 }
 
diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index f07cfb595a1c..4bb571f909ac 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -411,7 +411,7 @@ void ceph_debugfs_client_init(struct ceph_client *client)
 	snprintf(name, sizeof(name), "%pU.client%lld", &client->fsid,
 		 client->monc.auth->global_id);
 
-	pr_debug("ceph_debugfs_client_init %p %s\n", client, name);
+	pr_debug("%s: %p %s\n", __func__, client, name);
 
 	client->debugfs_dir = debugfs_create_dir(name, ceph_debugfs_dir);
 
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 652b7cf2812a..aa2a62654836 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -594,7 +594,7 @@ static int con_close_socket(struct ceph_connection *con)
 {
 	int rc = 0;
 
-	pr_debug("con_close_socket on %p sock %p\n", con, con->sock);
+	pr_debug("%s: on %p sock %p\n", __func__, con, con->sock);
 	if (con->sock) {
 		rc = con->sock->ops->shutdown(con->sock, SHUT_RDWR);
 		sock_release(con->sock);
@@ -636,7 +636,7 @@ static void reset_connection(struct ceph_connection *con)
 {
 	/* reset connection, out_queue, msg_ and connect_seq */
 	/* discard existing out_queue and msg_seq */
-	pr_debug("reset_connection %p\n", con);
+	pr_debug("%s: %p\n", __func__, con);
 	ceph_msg_remove_list(&con->out_queue);
 	ceph_msg_remove_list(&con->out_sent);
 
@@ -1234,7 +1234,7 @@ static void prepare_write_message_footer(struct ceph_connection *con)
 
 	m->footer.flags |= CEPH_MSG_FOOTER_COMPLETE;
 
-	pr_debug("prepare_write_message_footer %p\n", con);
+	pr_debug("%s: %p\n", __func__, con);
 	con_out_kvec_add(con, sizeof_footer(con), &m->footer);
 	if (con->peer_features & CEPH_FEATURE_MSG_AUTH) {
 		if (con->ops->sign_message)
@@ -1290,8 +1290,8 @@ static void prepare_write_message(struct ceph_connection *con)
 			con->ops->reencode_message(m);
 	}
 
-	pr_debug("prepare_write_message %p seq %lld type %d len %d+%d+%zd\n",
-		 m, con->out_seq, le16_to_cpu(m->hdr.type),
+	pr_debug("%s: %p seq %lld type %d len %d+%d+%zd\n",
+		 __func__, m, con->out_seq, le16_to_cpu(m->hdr.type),
 		 le32_to_cpu(m->hdr.front_len), le32_to_cpu(m->hdr.middle_len),
 		 m->data_length);
 	WARN_ON(m->front.iov_len != le32_to_cpu(m->hdr.front_len));
@@ -1469,8 +1469,8 @@ static int prepare_write_connect(struct ceph_connection *con)
 		BUG();
 	}
 
-	pr_debug("prepare_write_connect %p cseq=%d gseq=%d proto=%d\n",
-		 con, con->connect_seq, global_seq, proto);
+	pr_debug("%s: %p cseq=%d gseq=%d proto=%d\n",
+		 __func__, con, con->connect_seq, global_seq, proto);
 
 	con->out_connect.features =
 	    cpu_to_le64(from_msgr(con->msgr)->supported_features);
@@ -1498,7 +1498,7 @@ static int write_partial_kvec(struct ceph_connection *con)
 {
 	int ret;
 
-	pr_debug("write_partial_kvec %p %d left\n", con, con->out_kvec_bytes);
+	pr_debug("%s: %p %d left\n", __func__, con, con->out_kvec_bytes);
 	while (con->out_kvec_bytes > 0) {
 		ret = ceph_tcp_sendmsg(con->sock, con->out_kvec_cur,
 				       con->out_kvec_left, con->out_kvec_bytes,
@@ -1525,8 +1525,8 @@ static int write_partial_kvec(struct ceph_connection *con)
 	con->out_kvec_left = 0;
 	ret = 1;
 out:
-	pr_debug("write_partial_kvec %p %d left in %d kvecs ret = %d\n",
-		 con, con->out_kvec_bytes, con->out_kvec_left, ret);
+	pr_debug("%s: %p %d left in %d kvecs ret = %d\n",
+		 __func__, con, con->out_kvec_bytes, con->out_kvec_left, ret);
 	return ret;  /* done! */
 }
 
@@ -1714,7 +1714,7 @@ static int read_partial_banner(struct ceph_connection *con)
 	int end;
 	int ret;
 
-	pr_debug("read_partial_banner %p at %d\n", con, con->in_base_pos);
+	pr_debug("%s: %p at %d\n", __func__, con, con->in_base_pos);
 
 	/* peer's banner */
 	size = strlen(CEPH_BANNER);
@@ -1747,7 +1747,7 @@ static int read_partial_connect(struct ceph_connection *con)
 	int end;
 	int ret;
 
-	pr_debug("read_partial_connect %p at %d\n", con, con->in_base_pos);
+	pr_debug("%s: %p at %d\n", __func__, con, con->in_base_pos);
 
 	size = sizeof (con->in_reply);
 	end = size;
@@ -1771,8 +1771,8 @@ static int read_partial_connect(struct ceph_connection *con)
 			goto out;
 	}
 
-	pr_debug("read_partial_connect %p tag %d, con_seq = %u, g_seq = %u\n",
-		 con, (int)con->in_reply.tag,
+	pr_debug("%s: %p tag %d, con_seq = %u, g_seq = %u\n",
+		 __func__, con, (int)con->in_reply.tag,
 		 le32_to_cpu(con->in_reply.connect_seq),
 		 le32_to_cpu(con->in_reply.global_seq));
 out:
@@ -2037,8 +2037,8 @@ static int process_banner(struct ceph_connection *con)
 		       sizeof(con->peer_addr_for_me.in_addr));
 		addr_set_port(&con->msgr->inst.addr, port);
 		encode_my_addr(con->msgr);
-		pr_debug("process_banner learned my addr is %s\n",
-			 ceph_pr_addr(&con->msgr->inst.addr));
+		pr_debug("%s: learned my addr is %s\n",
+			 __func__, ceph_pr_addr(&con->msgr->inst.addr));
 	}
 
 	return 0;
@@ -2051,7 +2051,7 @@ static int process_connect(struct ceph_connection *con)
 	u64 server_feat = le64_to_cpu(con->in_reply.features);
 	int ret;
 
-	pr_debug("process_connect on %p tag %d\n", con, (int)con->in_tag);
+	pr_debug("%s: on %p tag %d\n", __func__, con, (int)con->in_tag);
 
 	if (con->auth) {
 		int len = le32_to_cpu(con->in_reply.authorizer_len);
@@ -2108,8 +2108,8 @@ static int process_connect(struct ceph_connection *con)
 
 	case CEPH_MSGR_TAG_BADAUTHORIZER:
 		con->auth_retry++;
-		pr_debug("process_connect %p got BADAUTHORIZER attempt %d\n",
-			 con, con->auth_retry);
+		pr_debug("%s: %p got BADAUTHORIZER attempt %d\n",
+			 __func__, con, con->auth_retry);
 		if (con->auth_retry == 2) {
 			con->error_msg = "connect authorization failure";
 			return -1;
@@ -2129,8 +2129,8 @@ static int process_connect(struct ceph_connection *con)
 		 * that they must have reset their session, and may have
 		 * dropped messages.
 		 */
-		pr_debug("process_connect got RESET peer seq %u\n",
-			 le32_to_cpu(con->in_reply.connect_seq));
+		pr_debug("%s: got RESET peer seq %u\n",
+			 __func__, le32_to_cpu(con->in_reply.connect_seq));
 		pr_err("%s%lld %s connection reset\n",
 		       ENTITY_NAME(con->peer_name),
 		       ceph_pr_addr(&con->peer_addr));
@@ -2156,7 +2156,8 @@ static int process_connect(struct ceph_connection *con)
 		 * If we sent a smaller connect_seq than the peer has, try
 		 * again with a larger value.
 		 */
-		pr_debug("process_connect got RETRY_SESSION my seq %u, peer %u\n",
+		pr_debug("%s: got RETRY_SESSION my seq %u, peer %u\n",
+			 __func__,
 			 le32_to_cpu(con->out_connect.connect_seq),
 			 le32_to_cpu(con->in_reply.connect_seq));
 		con->connect_seq = le32_to_cpu(con->in_reply.connect_seq);
@@ -2172,8 +2173,8 @@ static int process_connect(struct ceph_connection *con)
 		 * If we sent a smaller global_seq than the peer has, try
 		 * again with a larger value.
 		 */
-		pr_debug("process_connect got RETRY_GLOBAL my %u peer_gseq %u\n",
-			 con->peer_global_seq,
+		pr_debug("%s: got RETRY_GLOBAL my %u peer_gseq %u\n",
+			 __func__, con->peer_global_seq,
 			 le32_to_cpu(con->in_reply.global_seq));
 		get_global_seq(con->msgr,
 			       le32_to_cpu(con->in_reply.global_seq));
@@ -2203,8 +2204,8 @@ static int process_connect(struct ceph_connection *con)
 		con->peer_global_seq = le32_to_cpu(con->in_reply.global_seq);
 		con->connect_seq++;
 		con->peer_features = server_feat;
-		pr_debug("process_connect got READY gseq %d cseq %d (%d)\n",
-			 con->peer_global_seq,
+		pr_debug("%s: got READY gseq %d cseq %d (%d)\n",
+			 __func__, con->peer_global_seq,
 			 le32_to_cpu(con->in_reply.connect_seq),
 			 con->connect_seq);
 		WARN_ON(con->connect_seq !=
@@ -2366,7 +2367,7 @@ static int read_partial_message(struct ceph_connection *con)
 	u64 seq;
 	u32 crc;
 
-	pr_debug("read_partial_message con %p msg %p\n", con, m);
+	pr_debug("%s: con %p msg %p\n", __func__, con, m);
 
 	/* header */
 	size = sizeof (con->in_hdr);
@@ -2478,8 +2479,8 @@ static int read_partial_message(struct ceph_connection *con)
 		m->footer.sig = 0;
 	}
 
-	pr_debug("read_partial_message got msg %p %d (%u) + %d (%u) + %d (%u)\n",
-		 m, front_len, m->footer.front_crc, middle_len,
+	pr_debug("%s: got msg %p %d (%u) + %d (%u) + %d (%u)\n",
+		 __func__, m, front_len, m->footer.front_crc, middle_len,
 		 m->footer.middle_crc, data_len, m->footer.data_crc);
 
 	/* crc ok? */
@@ -2562,7 +2563,7 @@ static int try_write(struct ceph_connection *con)
 {
 	int ret = 1;
 
-	pr_debug("try_write start %p state %lu\n", con, con->state);
+	pr_debug("%s: start %p state %lu\n", __func__, con, con->state);
 	if (con->state != CON_STATE_PREOPEN &&
 	    con->state != CON_STATE_CONNECTING &&
 	    con->state != CON_STATE_NEGOTIATING &&
@@ -2580,8 +2581,8 @@ static int try_write(struct ceph_connection *con)
 
 		BUG_ON(con->in_msg);
 		con->in_tag = CEPH_MSGR_TAG_READY;
-		pr_debug("try_write initiating connect on %p new state %lu\n",
-			 con, con->state);
+		pr_debug("%s: initiating connect on %p new state %lu\n",
+			 __func__, con, con->state);
 		ret = ceph_tcp_connect(con);
 		if (ret < 0) {
 			con->error_msg = "connect error";
@@ -2590,7 +2591,7 @@ static int try_write(struct ceph_connection *con)
 	}
 
 more:
-	pr_debug("try_write out_kvec_bytes %d\n", con->out_kvec_bytes);
+	pr_debug("%s: out_kvec_bytes %d\n", __func__, con->out_kvec_bytes);
 	BUG_ON(!con->sock);
 
 	/* kvec data queued? */
@@ -2619,8 +2620,8 @@ static int try_write(struct ceph_connection *con)
 		if (ret == 0)
 			goto out;
 		if (ret < 0) {
-			pr_debug("try_write write_partial_message_data err %d\n",
-				 ret);
+			pr_debug("%s: write_partial_message_data err %d\n",
+				 __func__, ret);
 			goto out;
 		}
 	}
@@ -2644,10 +2645,10 @@ static int try_write(struct ceph_connection *con)
 
 	/* Nothing to do! */
 	con_flag_clear(con, CON_FLAG_WRITE_PENDING);
-	pr_debug("try_write nothing else to write\n");
+	pr_debug("%s: nothing else to write\n", __func__);
 	ret = 0;
 out:
-	pr_debug("try_write done on %p ret %d\n", con, ret);
+	pr_debug("%s: done on %p ret %d\n", __func__, con, ret);
 	return ret;
 }
 
@@ -2659,7 +2660,7 @@ static int try_read(struct ceph_connection *con)
 	int ret = -1;
 
 more:
-	pr_debug("try_read start on %p state %lu\n", con, con->state);
+	pr_debug("%s: start on %p state %lu\n", __func__, con, con->state);
 	if (con->state != CON_STATE_CONNECTING &&
 	    con->state != CON_STATE_NEGOTIATING &&
 	    con->state != CON_STATE_OPEN)
@@ -2667,11 +2668,11 @@ static int try_read(struct ceph_connection *con)
 
 	BUG_ON(!con->sock);
 
-	pr_debug("try_read tag %d in_base_pos %d\n",
-		 (int)con->in_tag, con->in_base_pos);
+	pr_debug("%s: tag %d in_base_pos %d\n",
+		 __func__, (int)con->in_tag, con->in_base_pos);
 
 	if (con->state == CON_STATE_CONNECTING) {
-		pr_debug("try_read connecting\n");
+		pr_debug("%s: connecting\n", __func__);
 		ret = read_partial_banner(con);
 		if (ret <= 0)
 			goto out;
@@ -2696,7 +2697,7 @@ static int try_read(struct ceph_connection *con)
 	}
 
 	if (con->state == CON_STATE_NEGOTIATING) {
-		pr_debug("try_read negotiating\n");
+		pr_debug("%s: negotiating\n", __func__);
 		ret = read_partial_connect(con);
 		if (ret <= 0)
 			goto out;
@@ -2727,7 +2728,7 @@ static int try_read(struct ceph_connection *con)
 		ret = ceph_tcp_recvmsg(con->sock, &con->in_tag, 1);
 		if (ret <= 0)
 			goto out;
-		pr_debug("try_read got tag %d\n", (int)con->in_tag);
+		pr_debug("%s: got tag %d\n", __func__, (int)con->in_tag);
 		switch (con->in_tag) {
 		case CEPH_MSGR_TAG_MSG:
 			prepare_read_message(con);
@@ -2789,7 +2790,7 @@ static int try_read(struct ceph_connection *con)
 	}
 
 out:
-	pr_debug("try_read done on %p ret %d\n", con, ret);
+	pr_debug("%s: done on %p ret %d\n", __func__, con, ret);
 	return ret;
 
 bad_tag:
@@ -3073,7 +3074,7 @@ static void clear_standby(struct ceph_connection *con)
 {
 	/* come back from STANDBY? */
 	if (con->state == CON_STATE_STANDBY) {
-		pr_debug("clear_standby %p and ++connect_seq\n", con);
+		pr_debug("%s: %p and ++connect_seq\n", __func__, con);
 		con->state = CON_STATE_PREOPEN;
 		con->connect_seq++;
 		WARN_ON(con_flag_test(con, CON_FLAG_WRITE_PENDING));
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 96aecc142f1c..b0e8563a2ca5 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -241,7 +241,7 @@ static void __schedule_delayed(struct ceph_mon_client *monc)
 	else
 		delay = CEPH_MONC_PING_INTERVAL;
 
-	pr_debug("__schedule_delayed after %lu\n", delay);
+	pr_debug("%s: after %lu\n", __func__, delay);
 	mod_delayed_work(system_wq, &monc->delayed_work,
 			 round_jiffies_relative(delay));
 }
@@ -645,11 +645,11 @@ static struct ceph_msg *get_generic_reply(struct ceph_connection *con,
 	mutex_lock(&monc->mutex);
 	req = lookup_generic_request(&monc->generic_request_tree, tid);
 	if (!req) {
-		pr_debug("get_generic_reply %lld dne\n", tid);
+		pr_debug("%s: %lld dne\n", __func__, tid);
 		*skip = 1;
 		m = NULL;
 	} else {
-		pr_debug("get_generic_reply %lld got %p\n", tid, req->reply);
+		pr_debug("%s: %lld got %p\n", __func__, tid, req->reply);
 		*skip = 0;
 		m = ceph_msg_get(req->reply);
 		/*
@@ -978,7 +978,7 @@ static void delayed_work(struct work_struct *work)
 	struct ceph_mon_client *monc =
 		container_of(work, struct ceph_mon_client, delayed_work.work);
 
-	pr_debug("monc delayed_work\n");
+	pr_debug("%s: monc\n", __func__);
 	mutex_lock(&monc->mutex);
 	if (monc->hunting) {
 		pr_debug("%s continuing hunt\n", __func__);
diff --git a/net/ceph/msgpool.c b/net/ceph/msgpool.c
index 4341c941d269..a198b869a14f 100644
--- a/net/ceph/msgpool.c
+++ b/net/ceph/msgpool.c
@@ -17,9 +17,9 @@ static void *msgpool_alloc(gfp_t gfp_mask, void *arg)
 	msg = ceph_msg_new2(pool->type, pool->front_len, pool->max_data_items,
 			    gfp_mask, true);
 	if (!msg) {
-		pr_debug("msgpool_alloc %s failed\n", pool->name);
+		pr_debug("%s: %s failed\n", __func__, pool->name);
 	} else {
-		pr_debug("msgpool_alloc %s %p\n", pool->name, msg);
+		pr_debug("%s: %s %p\n", __func__, pool->name, msg);
 		msg->pool = pool;
 	}
 	return msg;
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index b7bb5f2f5d61..20b5d0a853e1 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -116,8 +116,8 @@ static int calc_layout(struct ceph_file_layout *layout, u64 off, u64 *plen,
 			 orig_len - *plen, off, *plen);
 	}
 
-	pr_debug("calc_layout objnum=%llx %llu~%llu\n",
-		 *objnum, *objoff, *objlen);
+	pr_debug("%s: objnum=%llx %llu~%llu\n",
+		 __func__, *objnum, *objoff, *objlen);
 	return 0;
 }
 
@@ -5515,7 +5515,7 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	}
 
 	m = ceph_msg_get(req->r_reply);
-	pr_debug("get_reply tid %lld %p\n", tid, m);
+	pr_debug("%s: tid %lld %p\n", __func__, tid, m);
 
 out_unlock_session:
 	mutex_unlock(&osd->lock);
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index e47e16aeb008..dcdca28fb979 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -67,7 +67,7 @@ static int crush_decode_list_bucket(void **p, void *end,
 				    struct crush_bucket_list *b)
 {
 	int j;
-	pr_debug("crush_decode_list_bucket %p to %p\n", *p, end);
+	pr_debug("%s: %p to %p\n", __func__, *p, end);
 	b->item_weights = kcalloc(b->h.size, sizeof(u32), GFP_NOFS);
 	if (b->item_weights == NULL)
 		return -ENOMEM;
@@ -88,7 +88,7 @@ static int crush_decode_tree_bucket(void **p, void *end,
 				    struct crush_bucket_tree *b)
 {
 	int j;
-	pr_debug("crush_decode_tree_bucket %p to %p\n", *p, end);
+	pr_debug("%s: %p to %p\n", __func__, *p, end);
 	ceph_decode_8_safe(p, end, b->num_nodes, bad);
 	b->node_weights = kcalloc(b->num_nodes, sizeof(u32), GFP_NOFS);
 	if (b->node_weights == NULL)
@@ -105,7 +105,7 @@ static int crush_decode_straw_bucket(void **p, void *end,
 				     struct crush_bucket_straw *b)
 {
 	int j;
-	pr_debug("crush_decode_straw_bucket %p to %p\n", *p, end);
+	pr_debug("%s: %p to %p\n", __func__, *p, end);
 	b->item_weights = kcalloc(b->h.size, sizeof(u32), GFP_NOFS);
 	if (b->item_weights == NULL)
 		return -ENOMEM;
@@ -126,7 +126,7 @@ static int crush_decode_straw2_bucket(void **p, void *end,
 				      struct crush_bucket_straw2 *b)
 {
 	int j;
-	pr_debug("crush_decode_straw2_bucket %p to %p\n", *p, end);
+	pr_debug("%s: %p to %p\n", __func__, *p, end);
 	b->item_weights = kcalloc(b->h.size, sizeof(u32), GFP_NOFS);
 	if (b->item_weights == NULL)
 		return -ENOMEM;
@@ -421,7 +421,7 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 	void *start = pbyval;
 	u32 magic;
 
-	pr_debug("crush_decode %p to %p len %d\n", *p, end, (int)(end - *p));
+	pr_debug("%s: %p to %p len %d\n", __func__, *p, end, (int)(end - *p));
 
 	c = kzalloc(sizeof(*c), GFP_NOFS);
 	if (c == NULL)
@@ -466,8 +466,8 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 			c->buckets[i] = NULL;
 			continue;
 		}
-		pr_debug("crush_decode bucket %d off %x %p to %p\n",
-			 i, (int)(*p - start), *p, end);
+		pr_debug("%s: bucket %d off %x %p to %p\n",
+			 __func__, i, (int)(*p - start), *p, end);
 
 		switch (alg) {
 		case CRUSH_BUCKET_UNIFORM:
@@ -501,8 +501,8 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 		b->weight = ceph_decode_32(p);
 		b->size = ceph_decode_32(p);
 
-		pr_debug("crush_decode bucket size %d off %x %p to %p\n",
-			 b->size, (int)(*p - start), *p, end);
+		pr_debug("%s: bucket size %d off %x %p to %p\n",
+			 __func__, b->size, (int)(*p - start), *p, end);
 
 		b->items = kcalloc(b->size, sizeof(__s32), GFP_NOFS);
 		if (b->items == NULL)
@@ -554,14 +554,14 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 
 		ceph_decode_32_safe(p, end, yes, bad);
 		if (!yes) {
-			pr_debug("crush_decode NO rule %d off %x %p to %p\n",
-				 i, (int)(*p - start), *p, end);
+			pr_debug("%s: NO rule %d off %x %p to %p\n",
+				 __func__, i, (int)(*p - start), *p, end);
 			c->rules[i] = NULL;
 			continue;
 		}
 
-		pr_debug("crush_decode rule %d off %x %p to %p\n",
-			 i, (int)(*p - start), *p, end);
+		pr_debug("%s: rule %d off %x %p to %p\n",
+			 __func__, i, (int)(*p - start), *p, end);
 
 		/* len */
 		ceph_decode_32_safe(p, end, yes, bad);
@@ -643,13 +643,13 @@ static struct crush_map *crush_decode(void *pbyval, void *end)
 
 done:
 	crush_finalize(c);
-	pr_debug("crush_decode success\n");
+	pr_debug("%s: success\n", __func__);
 	return c;
 
 badmem:
 	err = -ENOMEM;
 fail:
-	pr_debug("crush_decode fail %d\n", err);
+	pr_debug("%s: fail %d\n", __func__, err);
 	crush_destroy(c);
 	return ERR_PTR(err);
 
-- 
2.26.0

