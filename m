Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829E52359C7
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 20:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgHBS0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 14:26:49 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:40716 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbgHBS0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 14:26:49 -0400
Received: from vla1-fdfb804fb3f3.qloud-c.yandex.net (vla1-fdfb804fb3f3.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3199:0:640:fdfb:804f])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 19E102E0906;
        Sun,  2 Aug 2020 21:26:45 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by vla1-fdfb804fb3f3.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id lm7E2se0Dk-QiqegKo0;
        Sun, 02 Aug 2020 21:26:44 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1596392804; bh=7brAAly1pD7yvGyvgRESCqVN7vgpJY4GDunvZawZmpY=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=1o368LbNpvAl2vIqK16feRpcqTpje1D6gyPMm+x5ea3I5Zn1nfXSc/czoPysr7iLO
         kUvrRDEBbt0Od5nkqh8n+PeBLwox58VAg/RUWiTqC1pGhPaOdM6O6zdz4/Pbb3pojf
         3bhCBEsalCiD1IJVcud2JMxeJScuzwOGdxPixswU=
Authentication-Results: vla1-fdfb804fb3f3.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [178.154.220.66])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id BgDnkfhBPV-Qij4YBtA;
        Sun, 02 Aug 2020 21:26:44 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
Subject: [PATCH bpf-next v4 1/2] bpf: setup socket family and addresses in bpf_prog_test_run_skb
Date:   Sun,  2 Aug 2020 21:26:37 +0300
Message-Id: <20200802182638.77377-2-zeil@yandex-team.ru>
In-Reply-To: <20200802182638.77377-1-zeil@yandex-team.ru>
References: <20200802182638.77377-1-zeil@yandex-team.ru>
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

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 net/bpf/test_run.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index b03c469..2521b27 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -449,6 +449,23 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	skb->protocol = eth_type_trans(skb, current->nsproxy->net_ns->loopback_dev);
 	skb_reset_network_header(skb);
 
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		sk->sk_family = AF_INET;
+		sk->sk_rcv_saddr = ip_hdr(skb)->saddr;
+		sk->sk_daddr = ip_hdr(skb)->daddr;
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6):
+		sk->sk_family = AF_INET6;
+		sk->sk_v6_rcv_saddr = ipv6_hdr(skb)->saddr;
+		sk->sk_v6_daddr = ipv6_hdr(skb)->daddr;
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

