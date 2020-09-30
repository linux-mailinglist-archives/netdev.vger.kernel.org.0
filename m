Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF3B27DDC0
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 03:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgI3B1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 21:27:12 -0400
Received: from mail-m972.mail.163.com ([123.126.97.2]:33818 "EHLO
        mail-m972.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgI3B1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 21:27:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=uJR2+
        kHD67D/W0UAJxory5DlslOyqbmHQlUC5LT3n4Q=; b=Xir3yfGciA25slWNSHSYt
        tDFo8y4o0sSdYkCy+BDdrqjU2FHswbFc5b0znEplbLSnQy38SwJqH81hNisx8+HK
        fVArAwqy3pBN9tJvtfKFGmSrbQt0nmWnUBWb0VWm1O2EKoWJB39ZdeLByfU8vULZ
        Ls4OvJKaovT+UUsVRyhAgw=
Received: from localhost.localdomain (unknown [111.202.93.98])
        by smtp2 (Coremail) with SMTP id GtxpCgDXpYW53nNfgTuFRg--.396S2;
        Wed, 30 Sep 2020 09:26:18 +0800 (CST)
From:   "longguang.yue" <bigclouds@163.com>
Cc:     kuba@kernel.org, yuelongguang@gmail.com,
        "longguang.yue" <bigclouds@163.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:IPVS),
        lvs-devel@vger.kernel.org (open list:IPVS),
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] ipvs: Add traffic statistic up even it is VS/DR or VS/TUN mode
Date:   Wed, 30 Sep 2020 09:26:10 +0800
Message-Id: <20200930012611.54859-1-bigclouds@163.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200929074110.33d7d740@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200929074110.33d7d740@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GtxpCgDXpYW53nNfgTuFRg--.396S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJryDGw15Gw1kKrWrKr1rWFg_yoW8uw17pF
        18ta43XrW8GFy5J3W7Ar97CryfCr1kt3Zrur4Yk34Sy3WDXFnxAFs0krya9a45ArsYqaya
        qw4Fqw13Crykt3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jx5r7UUUUU=
X-Originating-IP: [111.202.93.98]
X-CM-SenderInfo: peljuzprxg2qqrwthudrp/xtbBZBqvQ1QHK4aeXwAAst
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's ipvs's duty to do traffic statistic if packets get hit,
no matter what mode it is.

Signed-off-by: longguang.yue <bigclouds@163.com>
---
 net/netfilter/ipvs/ip_vs_conn.c | 14 ++++++++++++--
 net/netfilter/ipvs/ip_vs_core.c |  5 ++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index a90b8eac16ac..c4d164ce8ca7 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -401,6 +401,8 @@ struct ip_vs_conn *ip_vs_ct_in_get(const struct ip_vs_conn_param *p)
 struct ip_vs_conn *ip_vs_conn_out_get(const struct ip_vs_conn_param *p)
 {
 	unsigned int hash;
+	__be16 cport;
+	const union nf_inet_addr *caddr;
 	struct ip_vs_conn *cp, *ret=NULL;
 
 	/*
@@ -411,10 +413,18 @@ struct ip_vs_conn *ip_vs_conn_out_get(const struct ip_vs_conn_param *p)
 	rcu_read_lock();
 
 	hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[hash], c_list) {
-		if (p->vport == cp->cport && p->cport == cp->dport &&
+		cport = cp->dport;
+		caddr = &cp->daddr;
+
+		if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ) {
+			cport = cp->vport;
+			caddr = &cp->vaddr;
+		}
+
+		if (p->vport == cp->cport && p->cport == cport &&
 		    cp->af == p->af &&
 		    ip_vs_addr_equal(p->af, p->vaddr, &cp->caddr) &&
-		    ip_vs_addr_equal(p->af, p->caddr, &cp->daddr) &&
+		    ip_vs_addr_equal(p->af, p->caddr, caddr) &&
 		    p->protocol == cp->protocol &&
 		    cp->ipvs == p->ipvs) {
 			if (!__ip_vs_conn_get(cp))
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index e3668a6e54e4..7ba88dab297a 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1413,8 +1413,11 @@ ip_vs_out(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, in
 			     ipvs, af, skb, &iph);
 
 	if (likely(cp)) {
-		if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ)
+		if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ) {
+			ip_vs_out_stats(cp, skb);
+			skb->ipvs_property = 1;
 			goto ignore_cp;
+		}
 		return handle_response(af, skb, pd, cp, &iph, hooknum);
 	}
 
-- 
2.20.1 (Apple Git-117)

