Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6A735CB22
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243409AbhDLQXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243351AbhDLQXa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E48B60FD7;
        Mon, 12 Apr 2021 16:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244592;
        bh=CgiJsvtTIlGr2/3Du8E/ao+Rgt3ipSLSiXpBcnrtv50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0sfQL5YZzWQ8140KA60K57Dicf6CvU2tHyafSTM/UkMBpcOMn6v2+iHE4ZzY7l0/
         cgBsEVXIZykRuOrOc9wA7SPt/Vi0SvPWSQlJlj8w/t3Z3nvDQK9IHwEyfi6La37cBI
         1Yt42oaISMWuucjOmBMgcYtjxTmVjJpyVKHffZeWNXeyeN1t/6ZNDVlbcTmZtBSkSa
         eE+41vNxrSkjDn8RAB2EaWrwC0Bt5HT8xlmjlTz0ZKIkGR9T1Q2jS7Xs772AN4F356
         S8G49rWLk89wapP7TUne7ZKqt11IEeMUEPaRkOxBVhUBUvohqws9Ry1P+bZnln1orG
         7n0JyeHqDktUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>, Xiumei Mu <xmu@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 12/51] xfrm: BEET mode doesn't support fragments for inner packets
Date:   Mon, 12 Apr 2021 12:22:17 -0400
Message-Id: <20210412162256.313524-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 68dc022d04eb0fd60a540e242dcb11ec1bee07e2 ]

BEET mode replaces the IP(6) Headers with new IP(6) Headers when sending
packets. However, when it's a fragment before the replacement, currently
kernel keeps the fragment flag and replace the address field then encaps
it with ESP. It would cause in RX side the fragments to get reassembled
before decapping with ESP, which is incorrect.

In Xiumei's testing, these fragments went over an xfrm interface and got
encapped with ESP in the device driver, and the traffic was broken.

I don't have a good way to fix it, but only to warn this out in dmesg.

Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_output.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index a7ab19353313..a455356c8be4 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -660,6 +660,12 @@ static int xfrm4_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
 	int err;
 
+	if (x->outer_mode.encap == XFRM_MODE_BEET &&
+	    ip_is_fragment(ip_hdr(skb))) {
+		net_warn_ratelimited("BEET mode doesn't support inner IPv4 fragments\n");
+		return -EAFNOSUPPORT;
+	}
+
 	err = xfrm4_tunnel_check_size(skb);
 	if (err)
 		return err;
@@ -705,8 +711,15 @@ static int xfrm6_tunnel_check_size(struct sk_buff *skb)
 static int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_IPV6)
+	unsigned int ptr = 0;
 	int err;
 
+	if (x->outer_mode.encap == XFRM_MODE_BEET &&
+	    ipv6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT, NULL, NULL) >= 0) {
+		net_warn_ratelimited("BEET mode doesn't support inner IPv6 fragments\n");
+		return -EAFNOSUPPORT;
+	}
+
 	err = xfrm6_tunnel_check_size(skb);
 	if (err)
 		return err;
-- 
2.30.2

