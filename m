Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBDCC1031DC
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 04:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfKTDFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 22:05:52 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:55365 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfKTDFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 22:05:51 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Nov 2019 22:05:48 EST
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 2CEB55C1B0B;
        Wed, 20 Nov 2019 10:59:40 +0800 (CST)
From:   wenxu@ucloud.cn
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2] ip_gre: Make none-tun-dst gre tunnel store tunnel info as metadat_dst in recv 
Date:   Wed, 20 Nov 2019 10:59:39 +0800
Message-Id: <1574218779-17410-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVIQ0JCQkJDTU1PQ05NWVdZKFlBSU
        I3V1ktWUFJV1kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Njo6FSo5Hjg0EwgMM0I6DTw0
        GCIwCzxVSlVKTkxPSUpDTENLSUhJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlMT0s3Bg++
X-HM-Tid: 0a6e86c04e232087kuqy2ceb55c1b0b
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Currently collect_md gre tunnel will store the tunnel info(metadata_dst)
to skb_dst.
And now the non-tun-dst gre tunnel already can add tunnel header through
lwtunnel.

When received a arp_request on the non-tun-dst gre tunnel. The packet of 
arp response will send through the non-tun-dst tunnel without tunnel info 
which will lead the arp response packet to be dropped.

If the non-tun-dst gre tunnel also store the tunnel info as metadata_dst,
The arp response packet will set the releted tunnel info in the
iptunnel_metadata_reply.


The following is the test script:

ip netns add cl
ip l add dev vethc type veth peer name eth0 netns cl

ifconfig vethc 172.168.0.7/24 up
ip l add dev tun1000 type gretap key 1000

ip link add user1000 type vrf table 1
ip l set user1000 up
ip l set dev tun1000 master user1000
ifconfig tun1000 10.0.1.1/24 up

ip netns exec cl ifconfig eth0 172.168.0.17/24 up
ip netns exec cl ip l add dev tun type gretap local 172.168.0.17 remote 172.168.0.7 key 1000
ip netns exec cl ifconfig tun 10.0.1.7/24 up
ip r r 10.0.1.7 encap ip id 1000 dst 172.168.0.17 key dev tun1000 table 1

With this patch
ip netns exec cl ping 10.0.1.1 can success

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/ipv4/ip_gre.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 10636fb..572b630 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -340,6 +340,8 @@ static int __ipgre_rcv(struct sk_buff *skb, const struct tnl_ptk_info *tpi,
 				  iph->saddr, iph->daddr, tpi->key);
 
 	if (tunnel) {
+		const struct iphdr *tnl_params;
+
 		if (__iptunnel_pull_header(skb, hdr_len, tpi->proto,
 					   raw_proto, false) < 0)
 			goto drop;
@@ -348,7 +350,9 @@ static int __ipgre_rcv(struct sk_buff *skb, const struct tnl_ptk_info *tpi,
 			skb_pop_mac_header(skb);
 		else
 			skb_reset_mac_header(skb);
-		if (tunnel->collect_md) {
+
+		tnl_params = &tunnel->parms.iph;
+		if (tunnel->collect_md || tnl_params->daddr == 0) {
 			__be16 flags;
 			__be64 tun_id;
 
-- 
1.8.3.1

