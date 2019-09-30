Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1BF8C1B1A
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 07:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbfI3FqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 01:46:23 -0400
Received: from mail-m964.mail.126.com ([123.126.96.4]:39976 "EHLO
        mail-m964.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfI3FqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 01:46:23 -0400
X-Greylist: delayed 1870 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Sep 2019 01:46:21 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=f4VmT
        OLjqsdDW7siEPbVTeTGa05H6kPxmqkXSCHcXuY=; b=djrYmuZnBsvgWHcTYkmY6
        +cRQ2Y3d4aGlycFV9LAMBWfgkNj9PsSQJOEmKomiX+xnSyIyFXNnMIAWACVOC3iO
        OUdoOSwIDYAeQpMAXQixOIIHYJfcf8bEQab7fn5AoGiqoON4gmee25ve2qlWDJe7
        ttKIlfAqsmxOURxu3wTp44=
Received: from toolchain (unknown [114.249.233.149])
        by smtp9 (Coremail) with SMTP id NeRpCgAH2QFPj5FdvqFeAA--.31303S2;
        Mon, 30 Sep 2019 13:14:56 +0800 (CST)
Date:   Mon, 30 Sep 2019 13:14:55 +0800
From:   zhang kai <zhangkaiheb@126.com>
To:     wensong@linux-vs.org, horms@verge.net.au,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] ipvs: no need to update skb route entry for local
 destination packets.
Message-ID: <20190930051455.GA20692@toolchain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-CM-TRANSID: NeRpCgAH2QFPj5FdvqFeAA--.31303S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7JFyfWr17tw4UGryxtFWxXrb_yoW8JrWfpF
        nIkrZ7XrWkGF10vw1kJr40kry5Ga15Jr13WryrCr93Aw45Zrs8JFs0kFyIqF1FvFWFyrW5
        JrZ8Kw43ZrZ8ZFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jBCJPUUUUU=
X-Originating-IP: [114.249.233.149]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbinxBA-lpD9p38KQAAsW
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the end of function __ip_vs_get_out_rt/__ip_vs_get_out_rt_v6,the
'local' variable is always zero.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 9c464d24beec..037c7c91044e 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -407,12 +407,9 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 		goto err_put;
 
 	skb_dst_drop(skb);
-	if (noref) {
-		if (!local)
-			skb_dst_set_noref(skb, &rt->dst);
-		else
-			skb_dst_set(skb, dst_clone(&rt->dst));
-	} else
+	if (noref)
+		skb_dst_set_noref(skb, &rt->dst);
+	else
 		skb_dst_set(skb, &rt->dst);
 
 	return local;
@@ -574,12 +571,9 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 		goto err_put;
 
 	skb_dst_drop(skb);
-	if (noref) {
-		if (!local)
-			skb_dst_set_noref(skb, &rt->dst);
-		else
-			skb_dst_set(skb, dst_clone(&rt->dst));
-	} else
+	if (noref)
+		skb_dst_set_noref(skb, &rt->dst);
+	else
 		skb_dst_set(skb, &rt->dst);
 
 	return local;
-- 
2.17.1

