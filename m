Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD721239C27
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 23:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgHBVaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 17:30:55 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:40356 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726364AbgHBVaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 17:30:55 -0400
Received: from vla1-fdfb804fb3f3.qloud-c.yandex.net (vla1-fdfb804fb3f3.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3199:0:640:fdfb:804f])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id BE7A82E1453;
        Mon,  3 Aug 2020 00:30:51 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by vla1-fdfb804fb3f3.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id TRYgufj1o3-UoqiadTV;
        Mon, 03 Aug 2020 00:30:51 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1596403851; bh=8psgmHYbOAdZPn1YluxtldEijzcXgkILJiP0RgofstY=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=mSY979CF1pT/m2NUzfTFOSC0Bj5jcb/vd+JVIGcWgN3l1dg2SNfhseJbGwu8lsXmU
         s+pDxZrmCsN6uuDY7BGvIgw6NTw20GKJbyiU6icgDECAcIJe1Z/+WDJCgNiH6fEePZ
         HRZIm7anUdl+LmIOc9V5xoNFb2KT504jCjjNAHZk=
Authentication-Results: vla1-fdfb804fb3f3.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [178.154.141.161])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id CwYyvqXlFC-Uojm1Ndk;
        Mon, 03 Aug 2020 00:30:50 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
Subject: [PATCH bpf-next v5 1/2] bpf: setup socket family and addresses in bpf_prog_test_run_skb
Date:   Mon,  3 Aug 2020 00:30:25 +0300
Message-Id: <20200802213026.78731-2-zeil@yandex-team.ru>
In-Reply-To: <20200802213026.78731-1-zeil@yandex-team.ru>
References: <20200802213026.78731-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now it's impossible to test all branches of cgroup_skb bpf program which
accesses skb->family and skb->{local,remote}_ip{4,6} fields because they
are zeroed during socket allocation. This commit fills socket family and
addresses from related fields in constructed skb.

v2:
  - fix build without CONFIG_IPV6 (kernel test robot <lkp@intel.com>)

v3:
  - check skb length before access to inet headers (Eric Dumazet)

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 net/bpf/test_run.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index b03c469..8d69295 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -449,6 +449,27 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	skb->protocol = eth_type_trans(skb, current->nsproxy->net_ns->loopback_dev);
 	skb_reset_network_header(skb);
 
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		sk->sk_family = AF_INET;
+		if (pskb_may_pull(skb, sizeof(struct iphdr))) {
+			sk->sk_rcv_saddr = ip_hdr(skb)->saddr;
+			sk->sk_daddr = ip_hdr(skb)->daddr;
+		}
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6):
+		sk->sk_family = AF_INET6;
+		if (pskb_may_pull(skb, sizeof(struct ipv6hdr))) {
+			sk->sk_v6_rcv_saddr = ipv6_hdr(skb)->saddr;
+			sk->sk_v6_daddr = ipv6_hdr(skb)->daddr;
+		}
+		break;
+#endif
+	default:
+		break;
+	}
+
 	if (is_l2)
 		__skb_push(skb, hh_len);
 	if (is_direct_pkt_access)
-- 
2.7.4

