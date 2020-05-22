Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C2B1DF056
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 22:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730991AbgEVUFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 16:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730963AbgEVUFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 16:05:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975C4C061A0E;
        Fri, 22 May 2020 13:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=EfYPlaAM0tVJqWDjM23M348UGPgcOmSUMDNAnYQU29U=; b=HciuDFp8SowQPIaUS2biMqz/X/
        8SHMGvdi6h9nWzfOfxTu00QeHcKY9nmKjJfoYJIppM+ZHVRlx44AUGCwTzHu8srIBta4xPzlKPT9Y
        gY0/Q0XfAIw9LL8Hu57fYFH6ZPY8xruyxLiZnEYoG7bWydIiqvWX4fYq9rqJuS8he4TBvtrnxgdz5
        UhbCg1ocxGXB5aBGTBLsT3PcH9/4IfKIZST9pQASCVIEu6PKIEsGVZyMQDWHmodCTAXp4sKGwK+gl
        CHyC2xAk0vrs/agqi5KMruBuE3zH34zLvtwxxdqyGeDf6cFyXK/o/yQobbKq2rGX8j0Y+eLUTGZhl
        dtP02Nuw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcDv5-0001ki-Ud; Fri, 22 May 2020 20:05:27 +0000
To:     LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Yotam Gigi <yotam.gi@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH net-next v2] net: psample: fix build error when CONFIG_INET is
 not enabled
Message-ID: <ca2be940-4514-4027-13f9-4e6bd99152ab@infradead.org>
Date:   Fri, 22 May 2020 13:05:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix psample build error when CONFIG_INET is not set/enabled by
bracketing the tunnel code in #ifdef CONFIG_NET / #endif.

../net/psample/psample.c: In function ‘__psample_ip_tun_to_nlattr’:
../net/psample/psample.c:216:25: error: implicit declaration of function ‘ip_tunnel_info_opts’; did you mean ‘ip_tunnel_info_opts_set’? [-Werror=implicit-function-declaration]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Yotam Gigi <yotam.gi@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
---
v2: Just bracket the new tunnel support code inside ifdef/endif (Cong Wang).

 net/psample/psample.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-next-20200522.orig/net/psample/psample.c
+++ linux-next-20200522/net/psample/psample.c
@@ -209,6 +209,7 @@ void psample_group_put(struct psample_gr
 }
 EXPORT_SYMBOL_GPL(psample_group_put);
 
+#ifdef CONFIG_INET
 static int __psample_ip_tun_to_nlattr(struct sk_buff *skb,
 			      struct ip_tunnel_info *tun_info)
 {
@@ -352,12 +353,15 @@ static int psample_tunnel_meta_len(struc
 
 	return sum;
 }
+#endif
 
 void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
 			   u32 trunc_size, int in_ifindex, int out_ifindex,
 			   u32 sample_rate)
 {
+#ifdef CONFIG_INET
 	struct ip_tunnel_info *tun_info;
+#endif
 	struct sk_buff *nl_skb;
 	int data_len;
 	int meta_len;
@@ -371,9 +375,11 @@ void psample_sample_packet(struct psampl
 		   nla_total_size(sizeof(u32)) +	/* group_num */
 		   nla_total_size(sizeof(u32));		/* seq */
 
+#ifdef CONFIG_INET
 	tun_info = skb_tunnel_info(skb);
 	if (tun_info)
 		meta_len += psample_tunnel_meta_len(tun_info);
+#endif
 
 	data_len = min(skb->len, trunc_size);
 	if (meta_len + nla_total_size(data_len) > PSAMPLE_MAX_PACKET_SIZE)
@@ -429,11 +435,13 @@ void psample_sample_packet(struct psampl
 			goto error;
 	}
 
+#ifdef CONFIG_INET
 	if (tun_info) {
 		ret = psample_ip_tun_to_nlattr(nl_skb, tun_info);
 		if (unlikely(ret < 0))
 			goto error;
 	}
+#endif
 
 	genlmsg_end(nl_skb, data);
 	genlmsg_multicast_netns(&psample_nl_family, group->net, nl_skb, 0,

