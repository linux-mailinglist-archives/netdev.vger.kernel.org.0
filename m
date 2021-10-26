Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B163543B526
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbhJZPNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbhJZPNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 11:13:06 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4027FC061767
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 08:10:42 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h193so14447993pgc.1
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 08:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kTO/whCMANVpCMxt1nV4HtJDolGkv8V9YyRr/LsZOEs=;
        b=Xv7UzWlj8JoQknwGtRkrW2aPMOgK8V7iRm+V3ySVuqQuT4jKnYsChuqv3PzjsxE35Y
         rVdpj1PRG3TtQlGdWMNVqwk4aF0nyeTjQOPoLgffmAgUaEvdMbpJdxsw37dsLS5uzvPN
         WWjtxrFbRi+0izGIg5FIIGSHx/l0H5IR1xDNJXgwsNWRYLdtxtWSmJTCBuPzJu38Fati
         b8wxIacmLXF43iNiM7y0pY8pJ3zuv/oxfkl4tWLyiNaYswDISXzdpap/CTh3OiEF1HNk
         1v+bH5G+ClG7iWXnwklv+VacIUdxlwDlDWp81JAXydw2VKIdbC7nj6lsobTGIInqiAjk
         QbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kTO/whCMANVpCMxt1nV4HtJDolGkv8V9YyRr/LsZOEs=;
        b=Ru7jwAvN5LaVkWCnWSXFdTFFfHWXvG4AhQaAOL0Ol2h44KZk3Fk9gSlYh55WAQBsKB
         HviF96TKx48sUaV8JWd2QeBzGlpN4s4lGjDtk/e3UlZQYk3MuSq5SYIuC95E9lbr2QTs
         2ckZ7+I/S/PRoyz8gue51TBS8NebZI6sl0Zj4CQyLyhJHTtf2Zd5d7AnXUAeQT3G8khu
         6hOlbWu6jUh2zRDqL4Yb9StuaLZdtt+jm110UIvaySmmXbxB0rtJmBi18Z/6z7y9uDVT
         2qtaDnYZyWlhZOM4iOrrZDXYjPahtLCts8q97vKlgmXY17SJJFX2Vlo0wf3pvm7cioDv
         TCGw==
X-Gm-Message-State: AOAM533XKI6SgrSeAjdXeBJGIlxeK3x0Hg2h63JBUcxyUKk2FRHefKOs
        hBWV6AZvpmmWudSXHTIuiZE=
X-Google-Smtp-Source: ABdhPJxTcc4zv0l3Z0ZutsWfHq/2nkeRGcG2tHFieJX1NnTia81htyp0Oh3a8kjwa/BjiGAOUFiaUQ==
X-Received: by 2002:a63:7047:: with SMTP id a7mr18910979pgn.458.1635261041249;
        Tue, 26 Oct 2021 08:10:41 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id p1sm10911009pfo.143.2021.10.26.08.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 08:10:40 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Cc:     dkirjanov@suse.de, ap420073@gmail.com
Subject: [PATCH net-next 2/4 v4] amt: add data plane of amt interface
Date:   Tue, 26 Oct 2021 15:10:14 +0000
Message-Id: <20211026151016.25997-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211026151016.25997-1-ap420073@gmail.com>
References: <20211026151016.25997-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before forwarding multicast traffic, the amt interface establishes between
gateway and relay. In order to establish, amt defined some message type
and those message flow looks like the below.

                      Gateway                  Relay
                      -------                  -----
                         :        Request        :
                     [1] |           N           |
                         |---------------------->|
                         |    Membership Query   | [2]
                         |    N,MAC,gADDR,gPORT  |
                         |<======================|
                     [3] |   Membership Update   |
                         |   ({G:INCLUDE({S})})  |
                         |======================>|
                         |                       |
    ---------------------:-----------------------:---------------------
   |                     |                       |                     |
   |                     |    *Multicast Data    |  *IP Packet(S,G)    |
   |                     |      gADDR,gPORT      |<-----------------() |
   |    *IP Packet(S,G)  |<======================|                     |
   | ()<-----------------|                       |                     |
   |                     |                       |                     |
    ---------------------:-----------------------:---------------------
                         ~                       ~
                         ~        Request        ~
                     [4] |           N'          |
                         |---------------------->|
                         |   Membership Query    | [5]
                         | N',MAC',gADDR',gPORT' |
                         |<======================|
                     [6] |                       |
                         |       Teardown        |
                         |   N,MAC,gADDR,gPORT   |
                         |---------------------->|
                         |                       | [7]
                         |   Membership Update   |
                         |  ({G:INCLUDE({S})})   |
                         |======================>|
                         |                       |
    ---------------------:-----------------------:---------------------
   |                     |                       |                     |
   |                     |    *Multicast Data    |  *IP Packet(S,G)    |
   |                     |     gADDR',gPORT'     |<-----------------() |
   |    *IP Packet (S,G) |<======================|                     |
   | ()<-----------------|                       |                     |
   |                     |                       |                     |
    ---------------------:-----------------------:---------------------
                         |                       |
                         :                       :

1. Discovery
 - Sent by Gateway to Relay
 - To find Relay unique ip address
2. Advertisement
 - Sent by Relay to Gateway
 - Contains the unique IP address
3. Request
 - Sent by Gateway to Relay
 - Solicit to receive 'Query' message.
4. Query
 - Sent by Relay to Gateway
 - Contains General Query message.
5. Update
 - Sent by  Gateway to Relay
 - Contains report message.
6. Multicast Data
 - Sent by Relay to Gateway
 - encapsulated multicast traffic.
7. Teardown
 - Not supported at this time.

Except for the Teardown message, it supports all messages.

In the next patch, IGMP/MLD logic will be added.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
v1 -> v2:
 - Eliminate sparse warnings
   - Use bool type instead of __be16 for identifying v4/v6 protocol.

v2 -> v3:
 - Fix compile warning due to unsed variable.
 - Add missing spinlock comment.
 - Update help message of amt in Kconfig.

v3 -> v4:
 - Split patch.
 - Use CHECKSUM_NONE instead of CHECKSUM_UNNECESSARY

 drivers/net/amt.c | 1241 +++++++++++++++++++++++++++++++++++++++++++++
 include/net/amt.h |   45 ++
 2 files changed, 1286 insertions(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 8d4782c66cde..c3ac94b6d3e8 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -31,6 +31,1220 @@
 
 static struct workqueue_struct *amt_wq;
 
+static char *status_str[] = {
+	"AMT_STATUS_INIT",
+	"AMT_STATUS_SENT_DISCOVERY",
+	"AMT_STATUS_RECEIVED_DISCOVERY",
+	"AMT_STATUS_SENT_ADVERTISEMENT",
+	"AMT_STATUS_RECEIVED_ADVERTISEMENT",
+	"AMT_STATUS_SENT_REQUEST",
+	"AMT_STATUS_RECEIVED_REQUEST",
+	"AMT_STATUS_SENT_QUERY",
+	"AMT_STATUS_RECEIVED_QUERY",
+	"AMT_STATUS_SENT_UPDATE",
+	"AMT_STATUS_RECEIVED_UPDATE",
+};
+
+static char *type_str[] = {
+	"AMT_MSG_DISCOVERY",
+	"AMT_MSG_ADVERTISEMENT",
+	"AMT_MSG_REQUEST",
+	"AMT_MSG_MEMBERSHIP_QUERY",
+	"AMT_MSG_MEMBERSHIP_UPDATE",
+	"AMT_MSG_MULTICAST_DATA",
+	"AMT_MSG_TEATDOWM",
+};
+
+static struct amt_skb_cb *amt_skb_cb(struct sk_buff *skb)
+{
+	return (struct amt_skb_cb *)((void *)skb->cb +
+		sizeof(struct qdisc_skb_cb));
+}
+
+static struct sk_buff *amt_build_igmp_gq(struct amt_dev *amt)
+{
+	int hlen = LL_RESERVED_SPACE(amt->dev);
+	int tlen = amt->dev->needed_tailroom;
+	struct igmpv3_query *ihv3;
+	void *csum_start = NULL;
+	__sum16 *csum = NULL;
+	struct sk_buff *skb;
+	struct ethhdr *eth;
+	struct iphdr *iph;
+	unsigned int len;
+	int offset;
+
+	len = hlen + tlen + sizeof(*iph) + 4 + sizeof(*ihv3);
+	skb = netdev_alloc_skb_ip_align(amt->dev, len);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, hlen);
+	skb_push(skb, sizeof(*eth));
+	skb->protocol = htons(ETH_P_IP);
+	skb_reset_mac_header(skb);
+	skb->priority = TC_PRIO_CONTROL;
+	skb_put(skb, sizeof(*iph) + 4 + sizeof(*ihv3));
+	skb_pull(skb, sizeof(*eth));
+	skb_reset_network_header(skb);
+
+	iph		= ip_hdr(skb);
+	iph->version	= 4;
+	iph->ihl	= (sizeof(struct iphdr) + 4) >> 2;
+	iph->tos	= 0xc0;
+	iph->tot_len	= htons(sizeof(*iph) + 4 + sizeof(*ihv3));
+	iph->frag_off	= htons(IP_DF);
+	iph->ttl	= 1;
+	iph->id		= 0;
+	iph->protocol	= IPPROTO_IGMP;
+	iph->daddr	= htonl(INADDR_ALLHOSTS_GROUP);
+	iph->saddr	= htonl(INADDR_ANY);
+	((u8 *)&iph[1])[0] = IPOPT_RA;
+	((u8 *)&iph[1])[1] = 4;
+	((u8 *)&iph[1])[2] = 0;
+	((u8 *)&iph[1])[3] = 0;
+	ip_send_check(iph);
+
+	eth = eth_hdr(skb);
+	ether_addr_copy(eth->h_source, amt->dev->dev_addr);
+	ip_eth_mc_map(htonl(INADDR_ALLHOSTS_GROUP), eth->h_dest);
+	eth->h_proto = htons(ETH_P_IP);
+
+	ihv3		= skb_pull(skb, sizeof(*iph) + 4);
+	skb_reset_transport_header(skb);
+	ihv3->type	= IGMP_HOST_MEMBERSHIP_QUERY;
+	ihv3->code	= 1;
+	ihv3->group	= 0;
+	ihv3->qqic	= amt->qi;
+	ihv3->nsrcs	= 0;
+	ihv3->resv	= 0;
+	ihv3->suppress	= false;
+	ihv3->qrv	= amt->net->ipv4.sysctl_igmp_qrv;
+	ihv3->csum	= 0;
+	csum		= &ihv3->csum;
+	csum_start	= (void *)ihv3;
+	*csum		= ip_compute_csum(csum_start, sizeof(*ihv3));
+	offset		= skb_transport_offset(skb);
+	skb->csum	= skb_checksum(skb, offset, skb->len - offset, 0);
+	skb->ip_summed	= CHECKSUM_NONE;
+
+	skb_push(skb, sizeof(*eth) + sizeof(*iph) + 4);
+
+	return skb;
+}
+
+static void __amt_update_gw_status(struct amt_dev *amt, enum amt_status status,
+				   bool validate)
+{
+	if (validate && amt->status >= status)
+		return;
+	netdev_dbg(amt->dev, "Update GW status %s -> %s",
+		   status_str[amt->status], status_str[status]);
+	amt->status = status;
+}
+
+static void __amt_update_relay_status(struct amt_tunnel_list *tunnel,
+				      enum amt_status status,
+				      bool validate)
+{
+	if (validate && tunnel->status >= status)
+		return;
+	netdev_dbg(tunnel->amt->dev,
+		   "Update Tunnel(IP = %pI4, PORT = %u) status %s -> %s",
+		   &tunnel->ip4, ntohs(tunnel->source_port),
+		   status_str[tunnel->status], status_str[status]);
+	tunnel->status = status;
+}
+
+static void amt_update_gw_status(struct amt_dev *amt, enum amt_status status,
+				 bool validate)
+{
+	spin_lock_bh(&amt->lock);
+	__amt_update_gw_status(amt, status, validate);
+	spin_unlock_bh(&amt->lock);
+}
+
+static void amt_update_relay_status(struct amt_tunnel_list *tunnel,
+				    enum amt_status status, bool validate)
+{
+	spin_lock_bh(&tunnel->lock);
+	__amt_update_relay_status(tunnel, status, validate);
+	spin_unlock_bh(&tunnel->lock);
+}
+
+static void amt_send_discovery(struct amt_dev *amt)
+{
+	struct amt_header_discovery *amtd;
+	int hlen, tlen, offset;
+	struct socket *sock;
+	struct udphdr *udph;
+	struct sk_buff *skb;
+	struct iphdr *iph;
+	struct rtable *rt;
+	struct flowi4 fl4;
+	u32 len;
+	int err;
+
+	rcu_read_lock();
+	sock = rcu_dereference(amt->sock);
+	if (!sock)
+		goto out;
+
+	if (!netif_running(amt->stream_dev) || !netif_running(amt->dev))
+		goto out;
+
+	rt = ip_route_output_ports(amt->net, &fl4, sock->sk,
+				   amt->discovery_ip, amt->local_ip,
+				   amt->gw_port, amt->relay_port,
+				   IPPROTO_UDP, 0,
+				   amt->stream_dev->ifindex);
+	if (IS_ERR(rt)) {
+		amt->dev->stats.tx_errors++;
+		goto out;
+	}
+
+	hlen = LL_RESERVED_SPACE(amt->dev);
+	tlen = amt->dev->needed_tailroom;
+	len = hlen + tlen + sizeof(*iph) + sizeof(*udph) + sizeof(*amtd);
+	skb = netdev_alloc_skb_ip_align(amt->dev, len);
+	if (!skb) {
+		ip_rt_put(rt);
+		amt->dev->stats.tx_errors++;
+		goto out;
+	}
+
+	skb->priority = TC_PRIO_CONTROL;
+	skb_dst_set(skb, &rt->dst);
+
+	len = sizeof(*iph) + sizeof(*udph) + sizeof(*amtd);
+	skb_reset_network_header(skb);
+	skb_put(skb, len);
+	amtd = skb_pull(skb, sizeof(*iph) + sizeof(*udph));
+	amtd->version	= 0;
+	amtd->type	= AMT_MSG_DISCOVERY;
+	amtd->reserved	= 0;
+	amtd->nonce	= amt->nonce;
+	skb_push(skb, sizeof(*udph));
+	skb_reset_transport_header(skb);
+	udph		= udp_hdr(skb);
+	udph->source	= amt->gw_port;
+	udph->dest	= amt->relay_port;
+	udph->len	= htons(sizeof(*udph) + sizeof(*amtd));
+	udph->check	= 0;
+	offset = skb_transport_offset(skb);
+	skb->csum = skb_checksum(skb, offset, skb->len - offset, 0);
+	udph->check = csum_tcpudp_magic(amt->local_ip, amt->discovery_ip,
+					sizeof(*udph) + sizeof(*amtd),
+					IPPROTO_UDP, skb->csum);
+
+	skb_push(skb, sizeof(*iph));
+	iph		= ip_hdr(skb);
+	iph->version	= 4;
+	iph->ihl	= (sizeof(struct iphdr)) >> 2;
+	iph->tos	= 0xc0;
+	iph->frag_off	= 0;
+	iph->ttl	= ip4_dst_hoplimit(&rt->dst);
+	iph->daddr	= amt->discovery_ip;
+	iph->saddr	= amt->local_ip;
+	iph->protocol	= IPPROTO_UDP;
+	iph->tot_len	= htons(len);
+
+	skb->ip_summed = CHECKSUM_NONE;
+	ip_select_ident(amt->net, skb, NULL);
+	ip_send_check(iph);
+	err = ip_local_out(amt->net, sock->sk, skb);
+	if (unlikely(net_xmit_eval(err)))
+		amt->dev->stats.tx_errors++;
+
+	spin_lock_bh(&amt->lock);
+	__amt_update_gw_status(amt, AMT_STATUS_SENT_DISCOVERY, true);
+	spin_unlock_bh(&amt->lock);
+out:
+	rcu_read_unlock();
+}
+
+static void amt_send_request(struct amt_dev *amt, bool v6)
+{
+	struct amt_header_request *amtrh;
+	int hlen, tlen, offset;
+	struct socket *sock;
+	struct udphdr *udph;
+	struct sk_buff *skb;
+	struct iphdr *iph;
+	struct rtable *rt;
+	struct flowi4 fl4;
+	u32 len;
+	int err;
+
+	rcu_read_lock();
+	sock = rcu_dereference(amt->sock);
+	if (!sock)
+		goto out;
+
+	if (!netif_running(amt->stream_dev) || !netif_running(amt->dev))
+		goto out;
+
+	rt = ip_route_output_ports(amt->net, &fl4, sock->sk,
+				   amt->remote_ip, amt->local_ip,
+				   amt->gw_port, amt->relay_port,
+				   IPPROTO_UDP, 0,
+				   amt->stream_dev->ifindex);
+	if (IS_ERR(rt)) {
+		amt->dev->stats.tx_errors++;
+		goto out;
+	}
+
+	hlen = LL_RESERVED_SPACE(amt->dev);
+	tlen = amt->dev->needed_tailroom;
+	len = hlen + tlen + sizeof(*iph) + sizeof(*udph) + sizeof(*amtrh);
+	skb = netdev_alloc_skb_ip_align(amt->dev, len);
+	if (!skb) {
+		ip_rt_put(rt);
+		amt->dev->stats.tx_errors++;
+		goto out;
+	}
+
+	skb->priority = TC_PRIO_CONTROL;
+	skb_dst_set(skb, &rt->dst);
+
+	len = sizeof(*iph) + sizeof(*udph) + sizeof(*amtrh);
+	skb_reset_network_header(skb);
+	skb_put(skb, len);
+	amtrh = skb_pull(skb, sizeof(*iph) + sizeof(*udph));
+	amtrh->version	 = 0;
+	amtrh->type	 = AMT_MSG_REQUEST;
+	amtrh->reserved1 = 0;
+	amtrh->p	 = v6;
+	amtrh->reserved2 = 0;
+	amtrh->nonce	 = amt->nonce;
+	skb_push(skb, sizeof(*udph));
+	skb_reset_transport_header(skb);
+	udph		= udp_hdr(skb);
+	udph->source	= amt->gw_port;
+	udph->dest	= amt->relay_port;
+	udph->len	= htons(sizeof(*amtrh) + sizeof(*udph));
+	udph->check	= 0;
+	offset = skb_transport_offset(skb);
+	skb->csum = skb_checksum(skb, offset, skb->len - offset, 0);
+	udph->check = csum_tcpudp_magic(amt->local_ip, amt->remote_ip,
+					sizeof(*udph) + sizeof(*amtrh),
+					IPPROTO_UDP, skb->csum);
+
+	skb_push(skb, sizeof(*iph));
+	iph		= ip_hdr(skb);
+	iph->version	= 4;
+	iph->ihl	= (sizeof(struct iphdr)) >> 2;
+	iph->tos	= 0xc0;
+	iph->frag_off	= 0;
+	iph->ttl	= ip4_dst_hoplimit(&rt->dst);
+	iph->daddr	= amt->remote_ip;
+	iph->saddr	= amt->local_ip;
+	iph->protocol	= IPPROTO_UDP;
+	iph->tot_len	= htons(len);
+
+	skb->ip_summed = CHECKSUM_NONE;
+	ip_select_ident(amt->net, skb, NULL);
+	ip_send_check(iph);
+	err = ip_local_out(amt->net, sock->sk, skb);
+	if (unlikely(net_xmit_eval(err)))
+		amt->dev->stats.tx_errors++;
+
+out:
+	rcu_read_unlock();
+}
+
+static void amt_send_igmp_gq(struct amt_dev *amt,
+			     struct amt_tunnel_list *tunnel)
+{
+	struct sk_buff *skb;
+
+	skb = amt_build_igmp_gq(amt);
+	if (!skb)
+		return;
+
+	amt_skb_cb(skb)->tunnel = tunnel;
+	dev_queue_xmit(skb);
+}
+
+static void amt_secret_work(struct work_struct *work)
+{
+	struct amt_dev *amt = container_of(to_delayed_work(work),
+					   struct amt_dev,
+					   secret_wq);
+
+	spin_lock_bh(&amt->lock);
+	get_random_bytes(&amt->key, sizeof(siphash_key_t));
+	spin_unlock_bh(&amt->lock);
+	mod_delayed_work(amt_wq, &amt->secret_wq,
+			 msecs_to_jiffies(AMT_SECRET_TIMEOUT));
+}
+
+static void amt_discovery_work(struct work_struct *work)
+{
+	struct amt_dev *amt = container_of(to_delayed_work(work),
+					   struct amt_dev,
+					   discovery_wq);
+
+	spin_lock_bh(&amt->lock);
+	if (amt->status > AMT_STATUS_SENT_DISCOVERY)
+		goto out;
+	get_random_bytes(&amt->nonce, sizeof(__be32));
+	spin_unlock_bh(&amt->lock);
+
+	amt_send_discovery(amt);
+	spin_lock_bh(&amt->lock);
+out:
+	mod_delayed_work(amt_wq, &amt->discovery_wq,
+			 msecs_to_jiffies(AMT_DISCOVERY_TIMEOUT));
+	spin_unlock_bh(&amt->lock);
+}
+
+static void amt_req_work(struct work_struct *work)
+{
+	struct amt_dev *amt = container_of(to_delayed_work(work),
+					   struct amt_dev,
+					   req_wq);
+	u32 exp;
+
+	spin_lock_bh(&amt->lock);
+	if (amt->status < AMT_STATUS_RECEIVED_ADVERTISEMENT)
+		goto out;
+
+	if (amt->req_cnt++ > AMT_MAX_REQ_COUNT) {
+		netdev_dbg(amt->dev, "Gateway is not ready");
+		amt->qi = AMT_INIT_REQ_TIMEOUT;
+		amt->ready4 = false;
+		amt->ready6 = false;
+		amt->remote_ip = 0;
+		__amt_update_gw_status(amt, AMT_STATUS_INIT, false);
+		amt->req_cnt = 0;
+	}
+	spin_unlock_bh(&amt->lock);
+
+	amt_send_request(amt, false);
+	amt_send_request(amt, true);
+	amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
+	spin_lock_bh(&amt->lock);
+out:
+	exp = min_t(u32, (1 * (1 << amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
+	mod_delayed_work(amt_wq, &amt->req_wq, msecs_to_jiffies(exp * 1000));
+	spin_unlock_bh(&amt->lock);
+}
+
+static bool amt_send_membership_update(struct amt_dev *amt,
+				       struct sk_buff *skb,
+				       bool v6)
+{
+	struct amt_header_membership_update *amtmu;
+	struct socket *sock;
+	struct iphdr *iph;
+	struct flowi4 fl4;
+	struct rtable *rt;
+	int err;
+
+	sock = rcu_dereference(amt->sock);
+	if (!sock)
+		return true;
+
+	err = skb_cow_head(skb, LL_RESERVED_SPACE(amt->dev) + sizeof(*amtmu) +
+			   sizeof(*iph) + sizeof(struct udphdr));
+	if (err)
+		return true;
+
+	skb_reset_inner_headers(skb);
+	memset(&fl4, 0, sizeof(struct flowi4));
+	fl4.flowi4_oif         = amt->stream_dev->ifindex;
+	fl4.daddr              = amt->remote_ip;
+	fl4.saddr              = amt->local_ip;
+	fl4.flowi4_tos         = 0xc0;
+	fl4.flowi4_proto       = IPPROTO_UDP;
+	rt = ip_route_output_key(amt->net, &fl4);
+	if (IS_ERR(rt)) {
+		netdev_dbg(amt->dev, "no route to %pI4\n", &amt->remote_ip);
+		return true;
+	}
+
+	amtmu			= skb_push(skb, sizeof(*amtmu));
+	amtmu->version		= 0;
+	amtmu->type		= AMT_MSG_MEMBERSHIP_UPDATE;
+	amtmu->reserved		= 0;
+	amtmu->nonce		= amt->nonce;
+	amtmu->response_mac	= amt->mac;
+
+	if (!v6)
+		skb_set_inner_protocol(skb, htons(ETH_P_IP));
+	else
+		skb_set_inner_protocol(skb, htons(ETH_P_IPV6));
+	udp_tunnel_xmit_skb(rt, sock->sk, skb,
+			    fl4.saddr,
+			    fl4.daddr,
+			    0xc0,
+			    ip4_dst_hoplimit(&rt->dst),
+			    0,
+			    amt->gw_port,
+			    amt->relay_port,
+			    false,
+			    false);
+	amt_update_gw_status(amt, AMT_STATUS_SENT_UPDATE, true);
+	return false;
+}
+
+static void amt_send_multicast_data(struct amt_dev *amt,
+				    const struct sk_buff *oskb,
+				    struct amt_tunnel_list *tunnel,
+				    bool v6)
+{
+	struct amt_header_mcast_data *amtmd;
+	struct socket *sock;
+	struct sk_buff *skb;
+	struct iphdr *iph;
+	struct flowi4 fl4;
+	struct rtable *rt;
+
+	sock = rcu_dereference(amt->sock);
+	if (!sock)
+		return;
+
+	skb = skb_copy_expand(oskb, sizeof(*amtmd) + sizeof(*iph) +
+			      sizeof(struct udphdr), 0, GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	skb_reset_inner_headers(skb);
+	memset(&fl4, 0, sizeof(struct flowi4));
+	fl4.flowi4_oif         = amt->stream_dev->ifindex;
+	fl4.daddr              = tunnel->ip4;
+	fl4.saddr              = amt->local_ip;
+	fl4.flowi4_proto       = IPPROTO_UDP;
+	rt = ip_route_output_key(amt->net, &fl4);
+	if (IS_ERR(rt)) {
+		netdev_dbg(amt->dev, "no route to %pI4\n", &tunnel->ip4);
+		kfree_skb(skb);
+		return;
+	}
+
+	amtmd = skb_push(skb, sizeof(*amtmd));
+	amtmd->version = 0;
+	amtmd->reserved = 0;
+	amtmd->type = AMT_MSG_MULTICAST_DATA;
+
+	if (!v6)
+		skb_set_inner_protocol(skb, htons(ETH_P_IP));
+	else
+		skb_set_inner_protocol(skb, htons(ETH_P_IPV6));
+	udp_tunnel_xmit_skb(rt, sock->sk, skb,
+			    fl4.saddr,
+			    fl4.daddr,
+			    0xc0,
+			    ip4_dst_hoplimit(&rt->dst),
+			    0,
+			    amt->relay_port,
+			    tunnel->source_port,
+			    false,
+			    false);
+}
+
+static bool amt_send_membership_query(struct amt_dev *amt,
+				      struct sk_buff *skb,
+				      struct amt_tunnel_list *tunnel,
+				      bool v6)
+{
+	struct amt_header_membership_query *amtmq;
+	struct socket *sock;
+	struct rtable *rt;
+	struct flowi4 fl4;
+	int err;
+
+	sock = rcu_dereference(amt->sock);
+	if (!sock)
+		return true;
+
+	err = skb_cow_head(skb, LL_RESERVED_SPACE(amt->dev) + sizeof(*amtmq) +
+			   sizeof(struct iphdr) + sizeof(struct udphdr));
+	if (err)
+		return true;
+
+	skb_reset_inner_headers(skb);
+	memset(&fl4, 0, sizeof(struct flowi4));
+	fl4.flowi4_oif         = amt->stream_dev->ifindex;
+	fl4.daddr              = tunnel->ip4;
+	fl4.saddr              = amt->local_ip;
+	fl4.flowi4_tos         = 0xc0;
+	fl4.flowi4_proto       = IPPROTO_UDP;
+	rt = ip_route_output_key(amt->net, &fl4);
+	if (IS_ERR(rt)) {
+		netdev_dbg(amt->dev, "no route to %pI4\n", &tunnel->ip4);
+		return -1;
+	}
+
+	amtmq		= skb_push(skb, sizeof(*amtmq));
+	amtmq->version	= 0;
+	amtmq->type	= AMT_MSG_MEMBERSHIP_QUERY;
+	amtmq->reserved = 0;
+	amtmq->l	= 0;
+	amtmq->g	= 0;
+	amtmq->nonce	= tunnel->nonce;
+	amtmq->response_mac = tunnel->mac;
+
+	if (!v6)
+		skb_set_inner_protocol(skb, htons(ETH_P_IP));
+	else
+		skb_set_inner_protocol(skb, htons(ETH_P_IPV6));
+	udp_tunnel_xmit_skb(rt, sock->sk, skb,
+			    fl4.saddr,
+			    fl4.daddr,
+			    0xc0,
+			    ip4_dst_hoplimit(&rt->dst),
+			    0,
+			    amt->relay_port,
+			    tunnel->source_port,
+			    false,
+			    false);
+	amt_update_relay_status(tunnel, AMT_STATUS_SENT_QUERY, true);
+	return false;
+}
+
+static netdev_tx_t amt_dev_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct amt_dev *amt = netdev_priv(dev);
+	struct amt_tunnel_list *tunnel;
+	bool report = false;
+	struct igmphdr *ih;
+	bool query = false;
+	struct iphdr *iph;
+	bool data = false;
+	bool v6 = false;
+
+	rcu_read_lock();
+	iph = ip_hdr(skb);
+	if (iph->version == 4) {
+		if (!ipv4_is_multicast(iph->daddr))
+			goto free;
+
+		if (!ip_mc_check_igmp(skb)) {
+			ih = igmp_hdr(skb);
+			switch (ih->type) {
+			case IGMPV3_HOST_MEMBERSHIP_REPORT:
+			case IGMP_HOST_MEMBERSHIP_REPORT:
+				report = true;
+				break;
+			case IGMP_HOST_MEMBERSHIP_QUERY:
+				query = true;
+				break;
+			default:
+				goto free;
+			}
+		} else {
+			data = true;
+		}
+		v6 = false;
+	} else {
+		dev->stats.tx_errors++;
+		goto free;
+	}
+
+	if (!pskb_may_pull(skb, sizeof(struct ethhdr)))
+		goto free;
+
+	skb_pull(skb, sizeof(struct ethhdr));
+
+	if (amt->mode == AMT_MODE_GATEWAY) {
+		/* Gateway only passes IGMP/MLD packets */
+		if (!report)
+			goto free;
+		if ((!v6 && !amt->ready4) || (v6 && !amt->ready6))
+			goto free;
+		if (amt_send_membership_update(amt, skb,  v6))
+			goto free;
+		goto unlock;
+	} else if (amt->mode == AMT_MODE_RELAY) {
+		if (query) {
+			tunnel = amt_skb_cb(skb)->tunnel;
+			if (!tunnel) {
+				WARN_ON(1);
+				goto free;
+			}
+
+			/* Do not forward unexpected query */
+			if (amt_send_membership_query(amt, skb, tunnel, v6))
+				goto free;
+			goto unlock;
+		}
+
+		if (!data)
+			goto free;
+		list_for_each_entry_rcu(tunnel, &amt->tunnel_list, list)
+			amt_send_multicast_data(amt, skb, tunnel, v6);
+	}
+
+	dev_kfree_skb(skb);
+	rcu_read_unlock();
+	return NETDEV_TX_OK;
+free:
+	dev_kfree_skb(skb);
+unlock:
+	rcu_read_unlock();
+	dev->stats.tx_dropped++;
+	return NETDEV_TX_OK;
+}
+
+static int amt_parse_type(struct sk_buff *skb)
+{
+	struct amt_header *amth;
+
+	if (!pskb_may_pull(skb, sizeof(struct udphdr) +
+			   sizeof(struct amt_header)))
+		return -1;
+
+	amth = (struct amt_header *)(udp_hdr(skb) + 1);
+
+	if (amth->version != 0)
+		return -1;
+
+	if (amth->type >= __AMT_MSG_MAX || !amth->type)
+		return -1;
+	return amth->type;
+}
+
+static void amt_tunnel_expire(struct work_struct *work)
+{
+	struct amt_tunnel_list *tunnel = container_of(to_delayed_work(work),
+						      struct amt_tunnel_list,
+						      gc_wq);
+	struct amt_dev *amt = tunnel->amt;
+
+	spin_lock_bh(&amt->lock);
+	rcu_read_lock();
+	list_del_rcu(&tunnel->list);
+	amt->nr_tunnels--;
+	rcu_read_unlock();
+	spin_unlock_bh(&amt->lock);
+	kfree_rcu(tunnel, rcu);
+}
+
+static bool amt_advertisement_handler(struct amt_dev *amt, struct sk_buff *skb)
+{
+	struct amt_header_advertisement *amta;
+	int hdr_size;
+
+	hdr_size = sizeof(*amta) - sizeof(struct amt_header);
+
+	if (!pskb_may_pull(skb, hdr_size))
+		return true;
+
+	amta = (struct amt_header_advertisement *)(udp_hdr(skb) + 1);
+	if (!amta->ip4)
+		return true;
+
+	if (amta->reserved || amta->version)
+		return true;
+
+	if (ipv4_is_loopback(amta->ip4) || ipv4_is_multicast(amta->ip4))
+		return true;
+
+	amt->remote_ip = amta->ip4;
+	netdev_dbg(amt->dev, "advertised remote ip = %pI4\n", &amt->remote_ip);
+	mod_delayed_work(amt_wq, &amt->req_wq, 0);
+
+	amt_update_gw_status(amt, AMT_STATUS_RECEIVED_ADVERTISEMENT, true);
+	return false;
+}
+
+static bool amt_multicast_data_handler(struct amt_dev *amt, struct sk_buff *skb)
+{
+	struct amt_header_mcast_data *amtmd;
+	int hdr_size, len, err;
+	struct ethhdr *eth;
+	struct iphdr *iph;
+
+	amtmd = (struct amt_header_mcast_data *)(udp_hdr(skb) + 1);
+	if (amtmd->reserved || amtmd->version)
+		return true;
+
+	hdr_size = sizeof(*amtmd) + sizeof(struct udphdr);
+	if (iptunnel_pull_header(skb, hdr_size, htons(ETH_P_IP), false))
+		return true;
+	skb_reset_network_header(skb);
+	skb_push(skb, sizeof(*eth));
+	skb_reset_mac_header(skb);
+	skb_pull(skb, sizeof(*eth));
+	eth = eth_hdr(skb);
+	iph = ip_hdr(skb);
+	if (iph->version == 4) {
+		if (!ipv4_is_multicast(iph->daddr))
+			return true;
+		skb->protocol = htons(ETH_P_IP);
+		eth->h_proto = htons(ETH_P_IP);
+		ip_eth_mc_map(iph->daddr, eth->h_dest);
+	} else {
+		return true;
+	}
+
+	skb->pkt_type = PACKET_MULTICAST;
+	skb->ip_summed = CHECKSUM_NONE;
+	len = skb->len;
+	err = gro_cells_receive(&amt->gro_cells, skb);
+	if (likely(err == NET_RX_SUCCESS))
+		dev_sw_netstats_rx_add(amt->dev, len);
+	else
+		amt->dev->stats.rx_dropped++;
+
+	return false;
+}
+
+static bool amt_membership_query_handler(struct amt_dev *amt,
+					 struct sk_buff *skb)
+{
+	struct amt_header_membership_query *amtmq;
+	struct igmpv3_query *ihv3;
+	struct ethhdr *eth, *oeth;
+	struct iphdr *iph;
+	int hdr_size, len;
+
+	hdr_size = sizeof(*amtmq) - sizeof(struct amt_header);
+
+	if (!pskb_may_pull(skb, hdr_size))
+		return true;
+
+	amtmq = (struct amt_header_membership_query *)(udp_hdr(skb) + 1);
+	if (amtmq->reserved || amtmq->version)
+		return true;
+
+	hdr_size = sizeof(*amtmq) + sizeof(struct udphdr) - sizeof(*eth);
+	if (iptunnel_pull_header(skb, hdr_size, htons(ETH_P_TEB), false))
+		return true;
+	oeth = eth_hdr(skb);
+	skb_reset_mac_header(skb);
+	skb_pull(skb, sizeof(*eth));
+	skb_reset_network_header(skb);
+	eth = eth_hdr(skb);
+	iph = ip_hdr(skb);
+	if (iph->version == 4) {
+		if (!ipv4_is_multicast(iph->daddr))
+			return true;
+		if (!pskb_may_pull(skb, sizeof(*iph) +  4 + sizeof(*ihv3)))
+			return true;
+
+		ihv3 = skb_pull(skb, sizeof(*iph) + 4);
+		skb_reset_transport_header(skb);
+		skb_push(skb, sizeof(*iph) + 4);
+		spin_lock_bh(&amt->lock);
+		amt->ready4 = true;
+		amt->mac = amtmq->response_mac;
+		amt->req_cnt = 0;
+		amt->qi = ihv3->qqic;
+		spin_unlock_bh(&amt->lock);
+		skb->protocol = htons(ETH_P_IP);
+		eth->h_proto = htons(ETH_P_IP);
+		ip_eth_mc_map(iph->daddr, eth->h_dest);
+	} else {
+		return true;
+	}
+
+	ether_addr_copy(eth->h_source, oeth->h_source);
+	skb->pkt_type = PACKET_MULTICAST;
+	skb->ip_summed = CHECKSUM_NONE;
+	len = skb->len;
+	if (netif_rx(skb) == NET_RX_SUCCESS) {
+		amt_update_gw_status(amt, AMT_STATUS_RECEIVED_QUERY, true);
+		dev_sw_netstats_rx_add(amt->dev, len);
+	} else {
+		amt->dev->stats.rx_dropped++;
+	}
+
+	return false;
+}
+
+static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
+{
+	struct amt_header_membership_update *amtmu;
+	struct amt_tunnel_list *tunnel;
+	struct udphdr *udph;
+	struct ethhdr *eth;
+	struct iphdr *iph;
+	int len;
+
+	iph = ip_hdr(skb);
+	udph = udp_hdr(skb);
+
+	if (__iptunnel_pull_header(skb, sizeof(*udph), skb->protocol,
+				   false, false))
+		return true;
+
+	amtmu = (struct amt_header_membership_update *)skb->data;
+	if (amtmu->reserved || amtmu->version)
+		return true;
+
+	skb_pull(skb, sizeof(*amtmu));
+	skb_reset_network_header(skb);
+
+	list_for_each_entry_rcu(tunnel, &amt->tunnel_list, list) {
+		if (tunnel->ip4 == iph->saddr) {
+			if ((amtmu->nonce == tunnel->nonce &&
+			     amtmu->response_mac == tunnel->mac)) {
+				mod_delayed_work(amt_wq, &tunnel->gc_wq,
+						 msecs_to_jiffies(amt_gmi(amt))
+								  * 3);
+				goto report;
+			} else {
+				netdev_dbg(amt->dev, "Invalid MAC\n");
+				return true;
+			}
+		}
+	}
+
+	return false;
+
+report:
+	iph = ip_hdr(skb);
+	if (iph->version == 4) {
+		if (ip_mc_check_igmp(skb)) {
+			netdev_dbg(amt->dev, "Invalid IGMP\n");
+			return true;
+		}
+
+		skb_push(skb, sizeof(struct ethhdr));
+		skb_reset_mac_header(skb);
+		eth = eth_hdr(skb);
+		skb->protocol = htons(ETH_P_IP);
+		eth->h_proto = htons(ETH_P_IP);
+		ip_eth_mc_map(iph->daddr, eth->h_dest);
+	} else {
+		netdev_dbg(amt->dev, "Unsupported Protocol\n");
+		return true;
+	}
+
+	skb_pull(skb, sizeof(struct ethhdr));
+	skb->pkt_type = PACKET_MULTICAST;
+	skb->ip_summed = CHECKSUM_NONE;
+	len = skb->len;
+	if (netif_rx(skb) == NET_RX_SUCCESS) {
+		amt_update_relay_status(tunnel, AMT_STATUS_RECEIVED_UPDATE,
+					true);
+		dev_sw_netstats_rx_add(amt->dev, len);
+	} else {
+		amt->dev->stats.rx_dropped++;
+	}
+
+	return false;
+}
+
+static void amt_send_advertisement(struct amt_dev *amt, __be32 nonce,
+				   __be32 daddr, __be16 dport)
+{
+	struct amt_header_advertisement *amta;
+	int hlen, tlen, offset;
+	struct socket *sock;
+	struct udphdr *udph;
+	struct sk_buff *skb;
+	struct iphdr *iph;
+	struct rtable *rt;
+	struct flowi4 fl4;
+	u32 len;
+	int err;
+
+	rcu_read_lock();
+	sock = rcu_dereference(amt->sock);
+	if (!sock)
+		goto out;
+
+	if (!netif_running(amt->stream_dev) || !netif_running(amt->dev))
+		goto out;
+
+	rt = ip_route_output_ports(amt->net, &fl4, sock->sk,
+				   daddr, amt->local_ip,
+				   dport, amt->relay_port,
+				   IPPROTO_UDP, 0,
+				   amt->stream_dev->ifindex);
+	if (IS_ERR(rt)) {
+		amt->dev->stats.tx_errors++;
+		goto out;
+	}
+
+	hlen = LL_RESERVED_SPACE(amt->dev);
+	tlen = amt->dev->needed_tailroom;
+	len = hlen + tlen + sizeof(*iph) + sizeof(*udph) + sizeof(*amta);
+	skb = netdev_alloc_skb_ip_align(amt->dev, len);
+	if (!skb) {
+		ip_rt_put(rt);
+		amt->dev->stats.tx_errors++;
+		goto out;
+	}
+
+	skb->priority = TC_PRIO_CONTROL;
+	skb_dst_set(skb, &rt->dst);
+
+	len = sizeof(*iph) + sizeof(*udph) + sizeof(*amta);
+	skb_reset_network_header(skb);
+	skb_put(skb, len);
+	amta = skb_pull(skb, sizeof(*iph) + sizeof(*udph));
+	amta->version	= 0;
+	amta->type	= AMT_MSG_ADVERTISEMENT;
+	amta->reserved	= 0;
+	amta->nonce	= nonce;
+	amta->ip4	= amt->local_ip;
+	skb_push(skb, sizeof(*udph));
+	skb_reset_transport_header(skb);
+	udph		= udp_hdr(skb);
+	udph->source	= amt->relay_port;
+	udph->dest	= dport;
+	udph->len	= htons(sizeof(*amta) + sizeof(*udph));
+	udph->check	= 0;
+	offset = skb_transport_offset(skb);
+	skb->csum = skb_checksum(skb, offset, skb->len - offset, 0);
+	udph->check = csum_tcpudp_magic(amt->local_ip, daddr,
+					sizeof(*udph) + sizeof(*amta),
+					IPPROTO_UDP, skb->csum);
+
+	skb_push(skb, sizeof(*iph));
+	iph		= ip_hdr(skb);
+	iph->version	= 4;
+	iph->ihl	= (sizeof(struct iphdr)) >> 2;
+	iph->tos	= 0xc0;
+	iph->frag_off	= 0;
+	iph->ttl	= ip4_dst_hoplimit(&rt->dst);
+	iph->daddr	= daddr;
+	iph->saddr	= amt->local_ip;
+	iph->protocol	= IPPROTO_UDP;
+	iph->tot_len	= htons(len);
+
+	skb->ip_summed = CHECKSUM_NONE;
+	ip_select_ident(amt->net, skb, NULL);
+	ip_send_check(iph);
+	err = ip_local_out(amt->net, sock->sk, skb);
+	if (unlikely(net_xmit_eval(err)))
+		amt->dev->stats.tx_errors++;
+
+out:
+	rcu_read_unlock();
+}
+
+static bool amt_discovery_handler(struct amt_dev *amt, struct sk_buff *skb)
+{
+	struct amt_header_discovery *amtd;
+	struct udphdr *udph;
+	struct iphdr *iph;
+
+	if (!pskb_may_pull(skb, sizeof(*udph) + sizeof(*amtd)))
+		return true;
+
+	iph = ip_hdr(skb);
+	udph = udp_hdr(skb);
+	amtd = (struct amt_header_discovery *)(udp_hdr(skb) + 1);
+
+	if (amtd->reserved || amtd->version)
+		return true;
+
+	amt_send_advertisement(amt, amtd->nonce, iph->saddr, udph->source);
+
+	return false;
+}
+
+static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
+{
+	struct amt_header_request *amtrh;
+	struct amt_tunnel_list *tunnel;
+	unsigned long long key;
+	struct udphdr *udph;
+	struct iphdr *iph;
+	u64 mac;
+	int i;
+
+	if (!pskb_may_pull(skb, sizeof(*udph) + sizeof(*amtrh)))
+		return true;
+
+	iph = ip_hdr(skb);
+	udph = udp_hdr(skb);
+	amtrh = (struct amt_header_request *)(udp_hdr(skb) + 1);
+
+	if (amtrh->reserved1 || amtrh->reserved2 || amtrh->version)
+		return true;
+
+	list_for_each_entry_rcu(tunnel, &amt->tunnel_list, list)
+		if (tunnel->ip4 == iph->saddr)
+			goto send;
+
+	if (amt->nr_tunnels >= amt->max_tunnels) {
+		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
+		return true;
+	}
+
+	tunnel = kmalloc(sizeof(*tunnel) +
+			 (sizeof(struct hlist_head) * amt->hash_buckets),
+			 GFP_ATOMIC);
+	if (!tunnel)
+		return true;
+
+	tunnel->source_port = udph->source;
+	tunnel->ip4 = iph->saddr;
+	tunnel->nr_groups = 0;
+	tunnel->nr_sources = 0;
+
+	memcpy(&key, &tunnel->key, sizeof(unsigned long long));
+	tunnel->reserved = 0;
+	tunnel->amt = amt;
+	spin_lock_init(&tunnel->lock);
+	for (i = 0; i < amt->hash_buckets; i++)
+		INIT_HLIST_HEAD(&tunnel->groups[i]);
+
+	INIT_DELAYED_WORK(&tunnel->gc_wq, amt_tunnel_expire);
+
+	spin_lock_bh(&amt->lock);
+	list_add_tail_rcu(&tunnel->list, &amt->tunnel_list);
+	tunnel->key = amt->key;
+	amt_update_relay_status(tunnel, AMT_STATUS_RECEIVED_REQUEST, true);
+	amt->nr_tunnels++;
+	mod_delayed_work(amt_wq, &tunnel->gc_wq,
+			 msecs_to_jiffies(amt_gmi(amt)));
+	spin_unlock_bh(&amt->lock);
+
+send:
+	tunnel->nonce = amtrh->nonce;
+	mac = siphash_3u32((__force u32)tunnel->ip4,
+			   (__force u32)tunnel->source_port,
+			   (__force u32)tunnel->nonce,
+			   &tunnel->key);
+	tunnel->mac = mac >> 16;
+
+	if (!netif_running(amt->dev) || !netif_running(amt->stream_dev))
+		return true;
+
+	if (!amtrh->p)
+		amt_send_igmp_gq(amt, tunnel);
+
+	return false;
+}
+
+static int amt_rcv(struct sock *sk, struct sk_buff *skb)
+{
+	struct amt_dev *amt;
+	struct iphdr *iph;
+	int type;
+	bool err;
+
+	rcu_read_lock_bh();
+	amt = rcu_dereference_sk_user_data(sk);
+	if (!amt) {
+		err = true;
+		goto out;
+	}
+
+	skb->dev = amt->dev;
+	iph = ip_hdr(skb);
+	type = amt_parse_type(skb);
+	if (type == -1) {
+		err = true;
+		goto drop;
+	}
+
+	if (amt->mode == AMT_MODE_GATEWAY) {
+		switch (type) {
+		case AMT_MSG_ADVERTISEMENT:
+			if (iph->saddr != amt->discovery_ip) {
+				netdev_dbg(amt->dev, "Invalid Relay IP\n");
+				err = true;
+				goto drop;
+			}
+			if (amt_advertisement_handler(amt, skb))
+				amt->dev->stats.rx_dropped++;
+			goto out;
+		case AMT_MSG_MULTICAST_DATA:
+			if (iph->saddr != amt->remote_ip) {
+				netdev_dbg(amt->dev, "Invalid Relay IP\n");
+				err = true;
+				goto drop;
+			}
+			err = amt_multicast_data_handler(amt, skb);
+			if (err)
+				goto drop;
+			else
+				goto out;
+		case AMT_MSG_MEMBERSHIP_QUERY:
+			if (iph->saddr != amt->remote_ip) {
+				netdev_dbg(amt->dev, "Invalid Relay IP\n");
+				err = true;
+				goto drop;
+			}
+			err = amt_membership_query_handler(amt, skb);
+			if (err)
+				goto drop;
+			else
+				goto out;
+		default:
+			err = true;
+			netdev_dbg(amt->dev, "Invalid type of Gateway\n");
+			break;
+		}
+	} else {
+		switch (type) {
+		case AMT_MSG_DISCOVERY:
+			err = amt_discovery_handler(amt, skb);
+			break;
+		case AMT_MSG_REQUEST:
+			err = amt_request_handler(amt, skb);
+			break;
+		case AMT_MSG_MEMBERSHIP_UPDATE:
+			err = amt_update_handler(amt, skb);
+			if (err)
+				goto drop;
+			else
+				goto out;
+		default:
+			err = true;
+			netdev_dbg(amt->dev, "Invalid type of relay\n");
+			break;
+		}
+	}
+drop:
+	if (err) {
+		amt->dev->stats.rx_dropped++;
+		kfree_skb(skb);
+	} else {
+		consume_skb(skb);
+	}
+out:
+	rcu_read_unlock_bh();
+	return 0;
+}
+
+static int amt_err_lookup(struct sock *sk, struct sk_buff *skb)
+{
+	struct amt_dev *amt;
+	int type;
+
+	rcu_read_lock_bh();
+	amt = rcu_dereference_sk_user_data(sk);
+	if (!amt)
+		goto drop;
+
+	if (amt->mode != AMT_MODE_GATEWAY)
+		goto drop;
+
+	type = amt_parse_type(skb);
+	if (type == -1)
+		goto drop;
+
+	netdev_dbg(amt->dev, "Received IGMP Unreachable of %s\n",
+		   type_str[type]);
+	switch (type) {
+	case AMT_MSG_DISCOVERY:
+		break;
+	case AMT_MSG_REQUEST:
+	case AMT_MSG_MEMBERSHIP_UPDATE:
+		if (amt->status >= AMT_STATUS_RECEIVED_ADVERTISEMENT)
+			mod_delayed_work(amt_wq, &amt->req_wq, 0);
+		break;
+	default:
+		goto drop;
+	}
+	rcu_read_unlock_bh();
+	return 0;
+drop:
+	rcu_read_unlock_bh();
+	amt->dev->stats.rx_dropped++;
+	return 0;
+}
+
 static struct socket *amt_create_sock(struct net *net, __be16 port)
 {
 	struct udp_port_cfg udp_conf;
@@ -63,6 +1277,8 @@ static int amt_socket_create(struct amt_dev *amt)
 	memset(&tunnel_cfg, 0, sizeof(tunnel_cfg));
 	tunnel_cfg.sk_user_data = amt;
 	tunnel_cfg.encap_type = 1;
+	tunnel_cfg.encap_rcv = amt_rcv;
+	tunnel_cfg.encap_err_lookup = amt_err_lookup;
 	tunnel_cfg.encap_destroy = NULL;
 	setup_udp_tunnel_sock(amt->net, sock, &tunnel_cfg);
 
@@ -88,14 +1304,26 @@ static int amt_dev_open(struct net_device *dev)
 	spin_unlock_bh(&amt->lock);
 
 	amt->status = AMT_STATUS_INIT;
+	if (amt->mode == AMT_MODE_GATEWAY) {
+		mod_delayed_work(amt_wq, &amt->discovery_wq, 0);
+		mod_delayed_work(amt_wq, &amt->req_wq, 0);
+	} else if (amt->mode == AMT_MODE_RELAY) {
+		mod_delayed_work(amt_wq, &amt->secret_wq,
+				 msecs_to_jiffies(AMT_SECRET_TIMEOUT));
+	}
 	return err;
 }
 
 static int amt_dev_stop(struct net_device *dev)
 {
 	struct amt_dev *amt = netdev_priv(dev);
+	struct amt_tunnel_list *tunnel, *tmp;
 	struct socket *sock;
 
+	cancel_delayed_work_sync(&amt->req_wq);
+	cancel_delayed_work_sync(&amt->discovery_wq);
+	cancel_delayed_work_sync(&amt->secret_wq);
+
 	/* shutdown */
 	sock = rtnl_dereference(amt->sock);
 	RCU_INIT_POINTER(amt->sock, NULL);
@@ -106,6 +1334,13 @@ static int amt_dev_stop(struct net_device *dev)
 	amt->ready4 = false;
 	amt->ready6 = false;
 
+	list_for_each_entry_safe(tunnel, tmp, &amt->tunnel_list, list) {
+		list_del_rcu(&tunnel->list);
+		amt->nr_tunnels--;
+		cancel_delayed_work_sync(&tunnel->gc_wq);
+		kfree_rcu(tunnel, rcu);
+	}
+
 	return 0;
 }
 
@@ -156,6 +1391,7 @@ static const struct net_device_ops amt_netdev_ops = {
 	.ndo_uninit             = amt_dev_uninit,
 	.ndo_open		= amt_dev_open,
 	.ndo_stop		= amt_dev_stop,
+	.ndo_start_xmit         = amt_dev_xmit,
 	.ndo_get_stats64        = dev_get_tstats64,
 	.ndo_change_mtu         = amt_change_mtu,
 };
@@ -331,6 +1567,11 @@ static int amt_newlink(struct net *net, struct net_device *dev,
 		return err;
 	}
 
+	INIT_DELAYED_WORK(&amt->discovery_wq, amt_discovery_work);
+	INIT_DELAYED_WORK(&amt->req_wq, amt_req_work);
+	INIT_DELAYED_WORK(&amt->secret_wq, amt_secret_work);
+	INIT_LIST_HEAD(&amt->tunnel_list);
+
 	return 0;
 }
 
diff --git a/include/net/amt.h b/include/net/amt.h
index e1520d71d782..b9bc9374d6a1 100644
--- a/include/net/amt.h
+++ b/include/net/amt.h
@@ -39,6 +39,18 @@ enum amt_status {
 
 #define AMT_STATUS_MAX (__AMT_STATUS_MAX - 1)
 
+struct amt_header {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	u8 type:4,
+	   version:4;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	u8 version:4,
+	   type:4;
+#else
+#error  "Please fix <asm/byteorder.h>"
+#endif
+} __packed;
+
 struct amt_header_discovery {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	u32	type:4,
@@ -157,6 +169,29 @@ struct amt_relay_headers {
 	};
 } __packed;
 
+struct amt_skb_cb {
+	struct amt_tunnel_list *tunnel;
+};
+
+struct amt_tunnel_list {
+	struct list_head	list;
+	/* Protect All resources under an amt_tunne_list */
+	spinlock_t		lock;
+	struct amt_dev		*amt;
+	u32			nr_groups;
+	u32			nr_sources;
+	enum amt_status		status;
+	struct delayed_work	gc_wq;
+	__be16			source_port;
+	__be32			ip4;
+	__be32			nonce;
+	siphash_key_t		key;
+	u64			mac:48,
+				reserved:16;
+	struct rcu_head		rcu;
+	struct hlist_head	groups[];
+};
+
 struct amt_dev {
 	struct net_device       *dev;
 	struct net_device       *stream_dev;
@@ -217,7 +252,12 @@ struct amt_dev {
 #define AMT_HSIZE_SHIFT		8
 #define AMT_HSIZE		(1 << AMT_HSIZE_SHIFT)
 
+#define AMT_DISCOVERY_TIMEOUT	5000
+#define AMT_INIT_REQ_TIMEOUT	1
 #define AMT_INIT_QUERY_INTERVAL	125
+#define AMT_MAX_REQ_TIMEOUT	120
+#define AMT_MAX_REQ_COUNT	3
+#define AMT_SECRET_TIMEOUT	60000
 #define IANA_AMT_UDP_PORT	2268
 #define AMT_MAX_TUNNELS         128
 #define AMT_MAX_REQS		128
@@ -233,4 +273,9 @@ static inline bool netif_is_amt(const struct net_device *dev)
 	return dev->rtnl_link_ops && !strcmp(dev->rtnl_link_ops->kind, "amt");
 }
 
+static inline u64 amt_gmi(const struct amt_dev *amt)
+{
+	return ((amt->qrv * amt->qi) + amt->qri) * 1000;
+}
+
 #endif /* _NET_AMT_H_ */
-- 
2.17.1

