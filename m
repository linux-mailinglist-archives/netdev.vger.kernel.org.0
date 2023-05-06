Return-Path: <netdev+bounces-722-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F9A36F950A
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 01:31:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C4CE1C2186B
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 23:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17AD51118A;
	Sat,  6 May 2023 23:30:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0482A11189
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 23:30:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33E561A3
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 16:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683415800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HTNOXZ9d3dhcO4s9WBiEF9HWEodG/IEQpgnehQ6yqCY=;
	b=RXl30NJ1y11e3gJKaeMrH4mYr6drFGXtqN7hpgTa+IyzJLw6ll2RaF8oFPFWeS/78Nbu4l
	jb9CKq8et1V2aUDSsv399/fTVv+FiH3wGgaHdGii9Oi32qevtU9O7txRDXUSRT7LQWjIB1
	lIReENgCs52ZvF+Wg2q/r0sNWTi2/uY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-THfngOn5Ola1sr8UyS1tjA-1; Sat, 06 May 2023 19:29:56 -0400
X-MC-Unique: THfngOn5Ola1sr8UyS1tjA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E555884626;
	Sat,  6 May 2023 23:29:56 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.2.16.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 882FA35443;
	Sat,  6 May 2023 23:29:55 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: Lee Duncan <lduncan@suse.com>,
	linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com,
	netdev@vger.kernel.org
Cc: Chris Leech <cleech@redhat.com>
Subject: [PATCH 04/11] iscsi: make all iSCSI netlink multicast namespace aware
Date: Sat,  6 May 2023 16:29:23 -0700
Message-Id: <20230506232930.195451-5-cleech@redhat.com>
In-Reply-To: <20230506232930.195451-1-cleech@redhat.com>
References: <20230506232930.195451-1-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Lee Duncan <lduncan@suse.com>

Make use of the per-net netlink sockets. Responses are sent back on the
same socket/namespace the request was received on.  Async events are
reported on the socket/namespace stored in the iscsi_cls_host associated
with the event.

Signed-off-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 92 +++++++++++++++++++----------
 1 file changed, 60 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 814aef6da4a3..0249c6d889c4 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2657,8 +2657,8 @@ iscsi_if_transport_lookup(struct iscsi_transport *tt)
 }
 
 static int
-iscsi_multicast_netns(struct net *net, struct sk_buff *skb,
-		      uint32_t group, gfp_t gfp)
+iscsi_multicast_skb(struct net *net, struct sk_buff *skb,
+		    uint32_t group, gfp_t gfp)
 {
 	struct sock *nls;
 	struct iscsi_net *isn;
@@ -2669,17 +2669,10 @@ iscsi_multicast_netns(struct net *net, struct sk_buff *skb,
 }
 
 static int
-iscsi_multicast_skb(struct sk_buff *skb, uint32_t group, gfp_t gfp)
-{
-	return iscsi_multicast_netns(&init_net, skb, group, gfp);
-}
-
-static int
-iscsi_unicast_skb(struct sk_buff *skb, u32 portid)
+iscsi_unicast_skb(struct net *net, struct sk_buff *skb, u32 portid)
 {
 	struct sock *nls;
 	struct iscsi_net *isn;
-	struct net *net = &init_net;
 
 	isn = net_generic(net, iscsi_net_id);
 	nls = isn->nls;
@@ -2694,6 +2687,7 @@ int iscsi_recv_pdu(struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 	struct iscsi_uevent *ev;
 	char *pdu;
 	struct iscsi_internal *priv;
+	struct net *net;
 	int len = nlmsg_total_size(sizeof(*ev) + sizeof(struct iscsi_hdr) +
 				   data_size);
 
@@ -2720,7 +2714,8 @@ int iscsi_recv_pdu(struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 	memcpy(pdu, hdr, sizeof(struct iscsi_hdr));
 	memcpy(pdu + sizeof(struct iscsi_hdr), data, data_size);
 
-	return iscsi_multicast_skb(skb, ISCSI_NL_GRP_ISCSID, GFP_ATOMIC);
+	net = iscsi_conn_net(conn);
+	return iscsi_multicast_skb(net, skb, ISCSI_NL_GRP_ISCSID, GFP_ATOMIC);
 }
 EXPORT_SYMBOL_GPL(iscsi_recv_pdu);
 
@@ -2731,6 +2726,7 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
 	struct nlmsghdr	*nlh;
 	struct sk_buff *skb;
 	struct iscsi_uevent *ev;
+	struct net *net;
 	int len = nlmsg_total_size(sizeof(*ev) + data_size);
 
 	skb = alloc_skb(len, GFP_ATOMIC);
@@ -2755,7 +2751,8 @@ int iscsi_offload_mesg(struct Scsi_Host *shost,
 
 	memcpy((char *)ev + sizeof(*ev), data, data_size);
 
-	return iscsi_multicast_skb(skb, ISCSI_NL_GRP_UIP, GFP_ATOMIC);
+	net = iscsi_host_net(shost->shost_data);
+	return iscsi_multicast_skb(net, skb, ISCSI_NL_GRP_UIP, GFP_ATOMIC);
 }
 EXPORT_SYMBOL_GPL(iscsi_offload_mesg);
 
@@ -2765,6 +2762,7 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	struct sk_buff	*skb;
 	struct iscsi_uevent *ev;
 	struct iscsi_internal *priv;
+	struct net *net;
 	int len = nlmsg_total_size(sizeof(*ev));
 	unsigned long flags;
 	int state;
@@ -2812,7 +2810,8 @@ void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	ev->r.connerror.cid = conn->cid;
 	ev->r.connerror.sid = iscsi_conn_get_sid(conn);
 
-	iscsi_multicast_skb(skb, ISCSI_NL_GRP_ISCSID, GFP_ATOMIC);
+	net = iscsi_conn_net(conn);
+	iscsi_multicast_skb(net, skb, ISCSI_NL_GRP_ISCSID, GFP_ATOMIC);
 
 	iscsi_cls_conn_printk(KERN_INFO, conn, "detected conn error (%d)\n",
 			      error);
@@ -2826,6 +2825,7 @@ void iscsi_conn_login_event(struct iscsi_cls_conn *conn,
 	struct sk_buff  *skb;
 	struct iscsi_uevent *ev;
 	struct iscsi_internal *priv;
+	struct net *net;
 	int len = nlmsg_total_size(sizeof(*ev));
 
 	priv = iscsi_if_transport_lookup(conn->transport);
@@ -2846,7 +2846,9 @@ void iscsi_conn_login_event(struct iscsi_cls_conn *conn,
 	ev->r.conn_login.state = state;
 	ev->r.conn_login.cid = conn->cid;
 	ev->r.conn_login.sid = iscsi_conn_get_sid(conn);
-	iscsi_multicast_skb(skb, ISCSI_NL_GRP_ISCSID, GFP_ATOMIC);
+
+	net = iscsi_conn_net(conn);
+	iscsi_multicast_skb(net, skb, ISCSI_NL_GRP_ISCSID, GFP_ATOMIC);
 
 	iscsi_cls_conn_printk(KERN_INFO, conn, "detected conn login (%d)\n",
 			      state);
@@ -2857,11 +2859,17 @@ void iscsi_post_host_event(uint32_t host_no, struct iscsi_transport *transport,
 			   enum iscsi_host_event_code code, uint32_t data_size,
 			   uint8_t *data)
 {
+	struct Scsi_Host *shost;
+	struct net *net;
 	struct nlmsghdr *nlh;
 	struct sk_buff *skb;
 	struct iscsi_uevent *ev;
 	int len = nlmsg_total_size(sizeof(*ev) + data_size);
 
+	shost = scsi_host_lookup(host_no);
+	if (!shost)
+		return;
+
 	skb = alloc_skb(len, GFP_NOIO);
 	if (!skb) {
 		printk(KERN_ERR "gracefully ignored host event (%d):%d OOM\n",
@@ -2880,7 +2888,9 @@ void iscsi_post_host_event(uint32_t host_no, struct iscsi_transport *transport,
 	if (data_size)
 		memcpy((char *)ev + sizeof(*ev), data, data_size);
 
-	iscsi_multicast_skb(skb, ISCSI_NL_GRP_ISCSID, GFP_NOIO);
+	net = iscsi_host_net(shost->shost_data);
+	scsi_host_put(shost);
+	iscsi_multicast_skb(net, skb, ISCSI_NL_GRP_ISCSID, GFP_NOIO);
 }
 EXPORT_SYMBOL_GPL(iscsi_post_host_event);
 
@@ -2888,11 +2898,17 @@ void iscsi_ping_comp_event(uint32_t host_no, struct iscsi_transport *transport,
 			   uint32_t status, uint32_t pid, uint32_t data_size,
 			   uint8_t *data)
 {
+	struct Scsi_Host *shost;
+	struct net *net;
 	struct nlmsghdr *nlh;
 	struct sk_buff *skb;
 	struct iscsi_uevent *ev;
 	int len = nlmsg_total_size(sizeof(*ev) + data_size);
 
+	shost = scsi_host_lookup(host_no);
+	if (!shost)
+		return;
+
 	skb = alloc_skb(len, GFP_NOIO);
 	if (!skb) {
 		printk(KERN_ERR "gracefully ignored ping comp: OOM\n");
@@ -2909,12 +2925,15 @@ void iscsi_ping_comp_event(uint32_t host_no, struct iscsi_transport *transport,
 	ev->r.ping_comp.data_size = data_size;
 	memcpy((char *)ev + sizeof(*ev), data, data_size);
 
-	iscsi_multicast_skb(skb, ISCSI_NL_GRP_ISCSID, GFP_NOIO);
+	net = iscsi_host_net(shost->shost_data);
+	scsi_host_put(shost);
+	iscsi_multicast_skb(net, skb, ISCSI_NL_GRP_ISCSID, GFP_NOIO);
 }
 EXPORT_SYMBOL_GPL(iscsi_ping_comp_event);
 
 static int
-iscsi_if_send_reply(u32 portid, int type, void *payload, int size)
+iscsi_if_send_reply(struct net *net, u32 portid, int type,
+		    void *payload, int size)
 {
 	struct sk_buff	*skb;
 	struct nlmsghdr	*nlh;
@@ -2928,11 +2947,11 @@ iscsi_if_send_reply(u32 portid, int type, void *payload, int size)
 
 	nlh = __nlmsg_put(skb, 0, 0, type, (len - sizeof(*nlh)), 0);
 	memcpy(nlmsg_data(nlh), payload, size);
-	return iscsi_unicast_skb(skb, portid);
+	return iscsi_unicast_skb(net, skb, portid);
 }
 
 static int
-iscsi_if_get_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
+iscsi_if_get_stats(struct net *net, struct iscsi_transport *transport, struct nlmsghdr *nlh)
 {
 	struct iscsi_uevent *ev = nlmsg_data(nlh);
 	struct iscsi_stats *stats;
@@ -2989,7 +3008,7 @@ iscsi_if_get_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 		skb_trim(skbstat, NLMSG_ALIGN(actual_size));
 		nlhstat->nlmsg_len = actual_size;
 
-		err = iscsi_multicast_skb(skbstat, ISCSI_NL_GRP_ISCSID,
+		err = iscsi_multicast_skb(net, skbstat, ISCSI_NL_GRP_ISCSID,
 					  GFP_ATOMIC);
 	} while (err < 0 && err != -ECONNREFUSED);
 
@@ -3009,6 +3028,7 @@ int iscsi_session_event(struct iscsi_cls_session *session,
 	struct iscsi_uevent *ev;
 	struct sk_buff  *skb;
 	struct nlmsghdr *nlh;
+	struct net *net;
 	int rc, len = nlmsg_total_size(sizeof(*ev));
 
 	priv = iscsi_if_transport_lookup(session->transport);
@@ -3053,7 +3073,8 @@ int iscsi_session_event(struct iscsi_cls_session *session,
 	 * this will occur if the daemon is not up, so we just warn
 	 * the user and when the daemon is restarted it will handle it
 	 */
-	rc = iscsi_multicast_skb(skb, ISCSI_NL_GRP_ISCSID, GFP_KERNEL);
+	net = iscsi_sess_net(session);
+	rc = iscsi_multicast_skb(net, skb, ISCSI_NL_GRP_ISCSID, GFP_KERNEL);
 	if (rc == -ESRCH)
 		iscsi_cls_session_printk(KERN_ERR, session,
 					 "Cannot notify userspace of session "
@@ -3416,7 +3437,8 @@ iscsi_send_ping(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 }
 
 static int
-iscsi_get_chap(struct iscsi_transport *transport, struct nlmsghdr *nlh)
+iscsi_get_chap(struct net *net, struct iscsi_transport *transport,
+	       struct nlmsghdr *nlh)
 {
 	struct iscsi_uevent *ev = nlmsg_data(nlh);
 	struct Scsi_Host *shost = NULL;
@@ -3475,7 +3497,7 @@ iscsi_get_chap(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 		skb_trim(skbchap, NLMSG_ALIGN(actual_size));
 		nlhchap->nlmsg_len = actual_size;
 
-		err = iscsi_multicast_skb(skbchap, ISCSI_NL_GRP_ISCSID,
+		err = iscsi_multicast_skb(net, skbchap, ISCSI_NL_GRP_ISCSID,
 					  GFP_KERNEL);
 	} while (err < 0 && err != -ECONNREFUSED);
 
@@ -3822,7 +3844,8 @@ static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
+iscsi_get_host_stats(struct net *net, struct iscsi_transport *transport,
+		     struct nlmsghdr *nlh)
 {
 	struct iscsi_uevent *ev = nlmsg_data(nlh);
 	struct Scsi_Host *shost = NULL;
@@ -3882,8 +3905,8 @@ iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 		skb_trim(skbhost_stats, NLMSG_ALIGN(actual_size));
 		nlhhost_stats->nlmsg_len = actual_size;
 
-		err = iscsi_multicast_skb(skbhost_stats, ISCSI_NL_GRP_ISCSID,
-					  GFP_KERNEL);
+		err = iscsi_multicast_skb(net, skbhost_stats,
+					  ISCSI_NL_GRP_ISCSID, GFP_KERNEL);
 	} while (err < 0 && err != -ECONNREFUSED);
 
 exit_host_stats:
@@ -4005,7 +4028,8 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 }
 
 static int
-iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
+iscsi_if_recv_msg(struct net *net, struct sk_buff *skb,
+		  struct nlmsghdr *nlh, uint32_t *group)
 {
 	int err = 0;
 	u32 portid;
@@ -4100,7 +4124,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		err = iscsi_if_transport_conn(transport, nlh);
 		break;
 	case ISCSI_UEVENT_GET_STATS:
-		err = iscsi_if_get_stats(transport, nlh);
+		err = iscsi_if_get_stats(net, transport, nlh);
 		break;
 	case ISCSI_UEVENT_TRANSPORT_EP_CONNECT:
 	case ISCSI_UEVENT_TRANSPORT_EP_POLL:
@@ -4125,7 +4149,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		err = iscsi_send_ping(transport, ev);
 		break;
 	case ISCSI_UEVENT_GET_CHAP:
-		err = iscsi_get_chap(transport, nlh);
+		err = iscsi_get_chap(net, transport, nlh);
 		break;
 	case ISCSI_UEVENT_DELETE_CHAP:
 		err = iscsi_delete_chap(transport, ev);
@@ -4156,7 +4180,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 				     nlmsg_attrlen(nlh, sizeof(*ev)));
 		break;
 	case ISCSI_UEVENT_GET_HOST_STATS:
-		err = iscsi_get_host_stats(transport, nlh);
+		err = iscsi_get_host_stats(net, transport, nlh);
 		break;
 	default:
 		err = -ENOSYS;
@@ -4174,6 +4198,8 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 static void
 iscsi_if_rx(struct sk_buff *skb)
 {
+	struct sock *sk = skb->sk;
+	struct net *net = sock_net(sk);
 	u32 portid = NETLINK_CB(skb).portid;
 
 	mutex_lock(&rx_queue_mutex);
@@ -4196,7 +4222,7 @@ iscsi_if_rx(struct sk_buff *skb)
 		if (rlen > skb->len)
 			rlen = skb->len;
 
-		err = iscsi_if_recv_msg(skb, nlh, &group);
+		err = iscsi_if_recv_msg(net, skb, nlh, &group);
 		if (err) {
 			ev->type = ISCSI_KEVENT_IF_ERROR;
 			ev->iferror = err;
@@ -4212,7 +4238,9 @@ iscsi_if_rx(struct sk_buff *skb)
 				break;
 			if (ev->type == ISCSI_UEVENT_GET_CHAP && !err)
 				break;
-			err = iscsi_if_send_reply(portid, nlh->nlmsg_type,
+			if (ev->type == ISCSI_UEVENT_GET_HOST_STATS && !err)
+				break;
+			err = iscsi_if_send_reply(net, portid, nlh->nlmsg_type,
 						  ev, sizeof(*ev));
 			if (err == -EAGAIN && --retries < 0) {
 				printk(KERN_WARNING "Send reply failed, error %d\n", err);
-- 
2.39.2


