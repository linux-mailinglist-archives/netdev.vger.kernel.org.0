Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F20722FD06
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgG0XYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbgG0XYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:24:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D97D22B3F;
        Mon, 27 Jul 2020 23:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892286;
        bh=5rkRIb3U+cgcQZ4kmQQZEzU4H5D2wfdrv2LhgBPwlHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6P5sEhyBSTDyJ1bgIVRkFcN5nEYzwM4MB1YKQrSrbnxYzfoblYaq0Cw1ONOpX83r
         38Trld51QEpoq7+wrHwKuwvSWZTEJ64sOmdzItWztCJo3pC1HaMBxZtS0x/GHDCdBd
         5o1cFosI7QYybn3FayfZMAZ6f0ZgsdFaOv7N2dA8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurence Oberman <loberman@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/10] qed: Disable "MFW indication via attention" SPAM every 5 minutes
Date:   Mon, 27 Jul 2020 19:24:35 -0400
Message-Id: <20200727232443.718000-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200727232443.718000-1-sashal@kernel.org>
References: <20200727232443.718000-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurence Oberman <loberman@redhat.com>

[ Upstream commit 1d61e21852d3161f234b9656797669fe185c251b ]

This is likely firmware causing this but its starting to annoy customers.
Change the message level to verbose to prevent the spam.
Note that this seems to only show up with ISCSI enabled on the HBA via the
qedi driver.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_int.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index f9e475075d3ea..61d5d76545687 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1015,7 +1015,8 @@ static int qed_int_attentions(struct qed_hwfn *p_hwfn)
 			index, attn_bits, attn_acks, asserted_bits,
 			deasserted_bits, p_sb_attn_sw->known_attn);
 	} else if (asserted_bits == 0x100) {
-		DP_INFO(p_hwfn, "MFW indication via attention\n");
+		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR,
+			   "MFW indication via attention\n");
 	} else {
 		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR,
 			   "MFW indication [deassertion]\n");
-- 
2.25.1

