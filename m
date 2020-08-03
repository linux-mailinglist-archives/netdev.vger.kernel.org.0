Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCF423A189
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 11:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgHCJGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 05:06:12 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:33202 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726002AbgHCJGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 05:06:05 -0400
Received: from iva8-d077482f1536.qloud-c.yandex.net (iva8-d077482f1536.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f26:0:640:d077:482f])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id A68792E14DA;
        Mon,  3 Aug 2020 12:06:02 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by iva8-d077482f1536.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id Pik32C3rL4-61t8Rq9W;
        Mon, 03 Aug 2020 12:06:02 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1596445562; bh=h4diBcf3n/zSiX3cDllkZDCGVGuX41GM1QGhDBl6cII=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=yyk4yIYIjYtGQBb41tV5quYvPQpKFUJV1EBk243stI2AYJOrXoAhSBxzd918zgLL1
         81I+77A8idv5XJZhy8a+RrFtwJSKBUUyE+LpmyL1pkZofCJ4DGsUMfKl8QK+SMRNsJ
         cN3BGPdbpYs21J7kow+zJhycBFuNcikuw6HRZZB8=
Authentication-Results: iva8-d077482f1536.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 178.154.163.76-vpn.dhcp.yndx.net (178.154.163.76-vpn.dhcp.yndx.net [178.154.163.76])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 1ZDFznne1R-61iCUags;
        Mon, 03 Aug 2020 12:06:01 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     eric.dumazet@gmail.com, sdf@google.com
Subject: [PATCH bpf-next v6 1/2] bpf: setup socket family and addresses in bpf_prog_test_run_skb
Date:   Mon,  3 Aug 2020 12:05:44 +0300
Message-Id: <20200803090545.82046-2-zeil@yandex-team.ru>
In-Reply-To: <20200803090545.82046-1-zeil@yandex-team.ru>
References: <20200803090545.82046-1-zeil@yandex-team.ru>
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

v4:
  - do not use pskb_may_pull() in skb length checking (Alexei Starovoitov)

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 net/bpf/test_run.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index b03c469..736a596 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -449,6 +449,27 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	skb->protocol = eth_type_trans(skb, current->nsproxy->net_ns->loopback_dev);
 	skb_reset_network_header(skb);
 
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		sk->sk_family = AF_INET;
+		if (sizeof(struct iphdr) <= skb_headlen(skb)) {
+			sk->sk_rcv_saddr = ip_hdr(skb)->saddr;
+			sk->sk_daddr = ip_hdr(skb)->daddr;
+		}
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6):
+		sk->sk_family = AF_INET6;
+		if (sizeof(struct ipv6hdr) <= skb_headlen(skb)) {
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

