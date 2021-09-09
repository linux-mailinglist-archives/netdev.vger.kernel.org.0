Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B42F404C62
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238636AbhIIL4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244421AbhIILyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:54:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBEC96137A;
        Thu,  9 Sep 2021 11:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187893;
        bh=EBbZEKk1Q8+0/FK1lc9ndXo46blG1XTr/+ky+ipJG2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPR73eX7WnWDPPVwWZaRRaTyhMek6hxoM6XbrK0/HbcuV0r4UEkjPkhpovdeK7FD5
         rUX3wRGMx/5jICMci1tEzM3N1zaizKHPC4+qavoPrQ2FYhppBHeBtcX8mtCfNrmvp8
         7R6YAuSZbJ6cal7iH+S9NurZ9ySybBBoiPUs/Z45tviB72wXLwW1ABTt/+1a8VtJuJ
         PYI1hdAJCTwP8gM8yzuK+MoWWwlNqiOonsdB0N27ZtM4VXVAe5lE+AZDu5DL4L30+1
         dNOYoWml6AUd8Axyk8gRzhJwBxZ3NJee81IRs8z+bdY+jULWiFZF1lazk0GO+P3BF9
         uLH/gPnIU59Wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 174/252] selftests: nci: Fix the code for next nlattr offset
Date:   Thu,  9 Sep 2021 07:39:48 -0400
Message-Id: <20210909114106.141462-174-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

[ Upstream commit 78a7b2a8a0fa31f63ac16ac13601db6ed8259dfc ]

nlattr could have a padding for 4 bytes alignment. So next nla's offset
should be calculated with a padding.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nci/nci_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 57b505cb1561..9687100f15ea 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -113,8 +113,8 @@ static int send_cmd_mt_nla(int sd, __u16 nlmsg_type, __u32 nlmsg_pid,
 		if (nla_len > 0)
 			memcpy(NLA_DATA(na), nla_data[cnt], nla_len[cnt]);
 
-		msg.n.nlmsg_len += NLMSG_ALIGN(na->nla_len);
-		prv_len = na->nla_len;
+		prv_len = NLA_ALIGN(nla_len[cnt]) + NLA_HDRLEN;
+		msg.n.nlmsg_len += prv_len;
 	}
 
 	buf = (char *)&msg;
-- 
2.30.2

