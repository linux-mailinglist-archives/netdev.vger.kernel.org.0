Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9361F2D85
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgFHXOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:14:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbgFHXOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ED1D20B80;
        Mon,  8 Jun 2020 23:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658076;
        bh=0wblg+mjV7gSWmz93T+E11WB/Wjp2kweRBmGDzFdv/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeTMlYmxgc6x5QU2HfYUqodcuqRsNx3/5S0LAkjDT4nuJar5H4MXstYQ5hDzwaucT
         i5yOFqgHIPa1K8jiCUS/X6Sib5tntLnhPc01NYcY42HvhGpAtCPeWbg7OrQvnammSP
         mIzhVLVhQugDKe+OARX4w8KZa3EPJUXz4uQsZ1WM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshiyuki Kurauchi <ahochauwaaaaa@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 121/606] gtp: set NLM_F_MULTI flag in gtp_genl_dump_pdp()
Date:   Mon,  8 Jun 2020 19:04:06 -0400
Message-Id: <20200608231211.3363633-121-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoshiyuki Kurauchi <ahochauwaaaaa@gmail.com>

[ Upstream commit 846c68f7f1ac82c797a2f1db3344a2966c0fe2e1 ]

In drivers/net/gtp.c, gtp_genl_dump_pdp() should set NLM_F_MULTI
flag since it returns multipart message.
This patch adds a new arg "flags" in gtp_genl_fill_info() so that
flags can be set by the callers.

Signed-off-by: Yoshiyuki Kurauchi <ahochauwaaaaa@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 672cd2caf2fb..21640a035d7d 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1169,11 +1169,11 @@ static int gtp_genl_del_pdp(struct sk_buff *skb, struct genl_info *info)
 static struct genl_family gtp_genl_family;
 
 static int gtp_genl_fill_info(struct sk_buff *skb, u32 snd_portid, u32 snd_seq,
-			      u32 type, struct pdp_ctx *pctx)
+			      int flags, u32 type, struct pdp_ctx *pctx)
 {
 	void *genlh;
 
-	genlh = genlmsg_put(skb, snd_portid, snd_seq, &gtp_genl_family, 0,
+	genlh = genlmsg_put(skb, snd_portid, snd_seq, &gtp_genl_family, flags,
 			    type);
 	if (genlh == NULL)
 		goto nlmsg_failure;
@@ -1227,8 +1227,8 @@ static int gtp_genl_get_pdp(struct sk_buff *skb, struct genl_info *info)
 		goto err_unlock;
 	}
 
-	err = gtp_genl_fill_info(skb2, NETLINK_CB(skb).portid,
-				 info->snd_seq, info->nlhdr->nlmsg_type, pctx);
+	err = gtp_genl_fill_info(skb2, NETLINK_CB(skb).portid, info->snd_seq,
+				 0, info->nlhdr->nlmsg_type, pctx);
 	if (err < 0)
 		goto err_unlock_free;
 
@@ -1271,6 +1271,7 @@ static int gtp_genl_dump_pdp(struct sk_buff *skb,
 				    gtp_genl_fill_info(skb,
 					    NETLINK_CB(cb->skb).portid,
 					    cb->nlh->nlmsg_seq,
+					    NLM_F_MULTI,
 					    cb->nlh->nlmsg_type, pctx)) {
 					cb->args[0] = i;
 					cb->args[1] = j;
-- 
2.25.1

