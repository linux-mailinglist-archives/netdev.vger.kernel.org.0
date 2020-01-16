Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C81B813F7D0
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733262AbgAPQ4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729634AbgAPQ4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D10F22192A;
        Thu, 16 Jan 2020 16:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193798;
        bh=pIaYyaxHpbQT38MmLmafgubNEt7PRUb/LGjMRMvir50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SH5WzASer0LXJL2v6VoKeEngzlP4iYquEC+QqCgaFru1+fjx/AIOREIUqWocfHqwQ
         4+Rkwe7KF4l/16zWZF7zx1Y6sevHK0g70SuJAIHQW/kNtCWFt3yWEn1pzaW6LxrKoG
         07MmL4d2YiE8R8igACGkgtiKKRBkeo/B5TWnfazc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 067/671] ipv6: add missing tx timestamping on IPPROTO_RAW
Date:   Thu, 16 Jan 2020 11:44:58 -0500
Message-Id: <20200116165502.8838-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit fbfb2321e950918b430e7225546296b2dcadf725 ]

Raw sockets support tx timestamping, but one case is missing.

IPPROTO_RAW takes a separate packet construction path. raw_send_hdrinc
has an explicit call to sock_tx_timestamp, but rawv6_send_hdrinc does
not. Add it.

Fixes: 11878b40ed5c ("net-timestamp: SOCK_RAW and PING timestamping")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/raw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 4856d9320b28..a41156a00dd4 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -660,6 +660,8 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
+	sock_tx_timestamp(sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+
 	if (flags & MSG_CONFIRM)
 		skb_set_dst_pending_confirm(skb, 1);
 
-- 
2.20.1

