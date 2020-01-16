Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBFC313F067
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395511AbgAPSVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:21:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392060AbgAPR1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:27:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEB25246E9;
        Thu, 16 Jan 2020 17:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195667;
        bh=v9Lp2EmHI5PVUDJ4zW54quaf6jsktkRDtB35oO0fFgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DUNFNza02c56GAuL1C+0nMf0V1I+DRRmSV2QunylJh8CODRf1ACz4i7AGryqr7kw
         IfFCeoAnAMEQNeNYbgNahVj1aMMg8LfKtJeBsdDPvPCu/MX4j8Z+MQtKPib+nybApL
         tQO9Qb7qkIx8pAtZz8wSNVA6q4YasmnpE94AqxRE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George Wilkie <gwilkie@vyatta.att-mail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 225/371] mpls: fix warning with multi-label encap
Date:   Thu, 16 Jan 2020 12:21:37 -0500
Message-Id: <20200116172403.18149-168-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George Wilkie <gwilkie@vyatta.att-mail.com>

[ Upstream commit 2f3f7d1fa0d1039b24a55d127ed190f196fc3e79 ]

If you configure a route with multiple labels, e.g.
  ip route add 10.10.3.0/24 encap mpls 16/100 via 10.10.2.2 dev ens4
A warning is logged:
  kernel: [  130.561819] netlink: 'ip': attribute type 1 has an invalid
  length.

This happens because mpls_iptunnel_policy has set the type of
MPLS_IPTUNNEL_DST to fixed size NLA_U32.
Change it to a minimum size.
nla_get_labels() does the remaining validation.

Fixes: e3e4712ec096 ("mpls: ip tunnel support")
Signed-off-by: George Wilkie <gwilkie@vyatta.att-mail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/mpls_iptunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mpls/mpls_iptunnel.c b/net/mpls/mpls_iptunnel.c
index 6e558a419f60..6c01166f972b 100644
--- a/net/mpls/mpls_iptunnel.c
+++ b/net/mpls/mpls_iptunnel.c
@@ -28,7 +28,7 @@
 #include "internal.h"
 
 static const struct nla_policy mpls_iptunnel_policy[MPLS_IPTUNNEL_MAX + 1] = {
-	[MPLS_IPTUNNEL_DST]	= { .type = NLA_U32 },
+	[MPLS_IPTUNNEL_DST]	= { .len = sizeof(u32) },
 	[MPLS_IPTUNNEL_TTL]	= { .type = NLA_U8 },
 };
 
-- 
2.20.1

