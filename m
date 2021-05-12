Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC0C37ED06
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384978AbhELUGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241233AbhELSFI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 14:05:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B19861448;
        Wed, 12 May 2021 18:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842632;
        bh=NIA5fAMjpk1RwpqY4MlElviJvCZGHJESiiCEeAkUWAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gritCY94LuumgDN3blclopeh+CprKw/fZjtPa6a7pw2VWhp7osv01XDWS7G4CesnY
         iBrG8ggaJ+hTAA5cwG18+Seief8UEvDXj47l3VgYeoXKBrCNhR5e+BlJzykCgcfOEu
         ylybWlgwaQyV30m3BBfgzqOLahbhuM8bKPIRPub2BgrmWIk3kTAS11vOUHUrz9XkXa
         Wr2W7eBeSW777mdBtr30VaKOsnmooT9dOUUExRqK+n//A+t+1EvNOvDrgBYQRqm3Tf
         YowyqEHWCYOZC9H8ERIPMSeAThGdC5EHWIwf5JdmgrqVO+aKS9WY9Q/1dSYVJnBTMZ
         YGUWPYUWnrawg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phillip Potter <phil@philpotter.co.uk>,
        syzbot+e267bed19bfc5478fb33@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/34] net: hsr: check skb can contain struct hsr_ethhdr in fill_frame_info
Date:   Wed, 12 May 2021 14:02:57 -0400
Message-Id: <20210512180306.664925-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180306.664925-1-sashal@kernel.org>
References: <20210512180306.664925-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

[ Upstream commit 2e9f60932a2c19e8a11b4a69d419f107024b05a0 ]

Check at start of fill_frame_info that the MAC header in the supplied
skb is large enough to fit a struct hsr_ethhdr, as otherwise this is
not a valid HSR frame. If it is too small, return an error which will
then cause the callers to clean up the skb. Fixes a KMSAN-found
uninit-value bug reported by syzbot at:
https://syzkaller.appspot.com/bug?id=f7e9b601f1414f814f7602a82b6619a8d80bce3f

Reported-by: syzbot+e267bed19bfc5478fb33@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index b4e06ae08834..90c72e4c0a8f 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -493,6 +493,10 @@ static int fill_frame_info(struct hsr_frame_info *frame,
 	struct ethhdr *ethhdr;
 	__be16 proto;
 
+	/* Check if skb contains hsr_ethhdr */
+	if (skb->mac_len < sizeof(struct hsr_ethhdr))
+		return -EINVAL;
+
 	memset(frame, 0, sizeof(*frame));
 	frame->is_supervision = is_supervision_frame(port->hsr, skb);
 	frame->node_src = hsr_get_node(port, &hsr->node_db, skb,
-- 
2.30.2

