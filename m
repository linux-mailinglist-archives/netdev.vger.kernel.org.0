Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A0821DF9D
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgGMSZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:25:42 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:41136 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726758AbgGMSZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 14:25:39 -0400
Received: from iva8-d077482f1536.qloud-c.yandex.net (iva8-d077482f1536.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f26:0:640:d077:482f])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 9DD552E0906;
        Mon, 13 Jul 2020 21:25:32 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by iva8-d077482f1536.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id IehjKGftm9-PVs0unNT;
        Mon, 13 Jul 2020 21:25:32 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1594664732; bh=cywGoq2TmkojrQZol7y+3L633j2AT6oJYK8jB49KVOs=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=kNrW8Ghi6BWEW3au2mGPfl2Vu5Wjl1DGIYfwCz+PO6hSEaXfaO0hg1sLFKTXPtF9Y
         6oWYKnT4EQo57jxeLfDs6P4sG6WeBIvJOXrWJ++4KGq1Ul+lD9EAvREux7ZYkUFx5G
         k5V5x5a8+qropD9tdUliR8v3LwVYcGfH29FsJwVM=
Authentication-Results: iva8-d077482f1536.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 37.9.72.97-iva.dhcp.yndx.net (37.9.72.97-iva.dhcp.yndx.net [37.9.72.97])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id liA4tjrt5e-PVjq9U62;
        Mon, 13 Jul 2020 21:25:31 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
Subject: [PATCH bpf-next 1/4] bpf: setup socket family and addresses in bpf_prog_test_run_skb
Date:   Mon, 13 Jul 2020 21:25:17 +0300
Message-Id: <20200713182520.97606-2-zeil@yandex-team.ru>
In-Reply-To: <20200713182520.97606-1-zeil@yandex-team.ru>
References: <20200713182520.97606-1-zeil@yandex-team.ru>
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

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 net/bpf/test_run.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index bfd4ccd..a58b399 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -432,6 +432,21 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	skb->protocol = eth_type_trans(skb, current->nsproxy->net_ns->loopback_dev);
 	skb_reset_network_header(skb);
 
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		sk->sk_family = AF_INET;
+		sk->sk_rcv_saddr = ip_hdr(skb)->saddr;
+		sk->sk_daddr = ip_hdr(skb)->daddr;
+		break;
+	case htons(ETH_P_IPV6):
+		sk->sk_family = AF_INET6;
+		sk->sk_v6_rcv_saddr = ipv6_hdr(skb)->saddr;
+		sk->sk_v6_daddr = ipv6_hdr(skb)->daddr;
+		break;
+	default:
+		break;
+	}
+
 	if (is_l2)
 		__skb_push(skb, hh_len);
 	if (is_direct_pkt_access)
-- 
2.7.4

