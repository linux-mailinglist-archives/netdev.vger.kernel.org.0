Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A73C21FE3E
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 22:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgGNUNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 16:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbgGNUNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 16:13:00 -0400
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022E9C061755;
        Tue, 14 Jul 2020 13:13:00 -0700 (PDT)
Received: from iva8-d077482f1536.qloud-c.yandex.net (iva8-d077482f1536.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f26:0:640:d077:482f])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id A506D2E15F3;
        Tue, 14 Jul 2020 23:12:57 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by iva8-d077482f1536.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id dyvrGtcYRL-Cusa6gBr;
        Tue, 14 Jul 2020 23:12:57 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1594757577; bh=cywGoq2TmkojrQZol7y+3L633j2AT6oJYK8jB49KVOs=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=IeArH+FO4T3o5BfV+0L3WzKFyYG8mb7HBmtSVrhhZQNQb6qhA5sREmqlZiyo0I0TA
         WNJxyoQ9d1YEOC+th9IrSCD2hC+10TGNoXE+o5t4dOHUyxT1G590vU3d+vRRpPGH/d
         8THVSbm/7xuSRgNKvsT+TvCF2arn7ctJlDR7z2zc=
Authentication-Results: iva8-d077482f1536.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 37.9.72.161-iva.dhcp.yndx.net (37.9.72.161-iva.dhcp.yndx.net [37.9.72.161])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id PwhVeBFRq1-CujCWwvW;
        Tue, 14 Jul 2020 23:12:56 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
Subject: [PATCH bpf-next v2 1/4] bpf: setup socket family and addresses in bpf_prog_test_run_skb
Date:   Tue, 14 Jul 2020 23:12:42 +0300
Message-Id: <20200714201245.99528-2-zeil@yandex-team.ru>
In-Reply-To: <20200714201245.99528-1-zeil@yandex-team.ru>
References: <20200714201245.99528-1-zeil@yandex-team.ru>
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

