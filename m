Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0FF5F905A
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbiJIWYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiJIWW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:22:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60761392;
        Sun,  9 Oct 2022 15:17:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B502B80DEA;
        Sun,  9 Oct 2022 22:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9747EC43470;
        Sun,  9 Oct 2022 22:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353546;
        bh=YHvVHIJX2HPHSLT4eGLhe20mkccL+miqWFxNvBZc7ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chVjI7fLnK9Wm59MtGVvtZnWqtwQBqUUdnvNc+33OulBXSYk1tlV/TZvdjvcqW194
         ejdfiSoKMwK9Pnj2yDLxRkIcQX3cd0gEY3U1niKBcJdHdyWuGmyIE7sFh0YkC7w+ES
         wx9jYDX7OK8o/l9LkclAUOeD09MUJ2cHQsRpiRCswk8RctWzMeSmPD1BOcY0/RC/e2
         ylzbfjLqjE044i4XhglYW2upH967YxMaPUOyjN0uI70BPvuG1zPYu4rg9Bqz+oLq+5
         3Y3bI2do8ozUIbrq9UWywTVkMef57W93TvZEUeHRGgT/4FQw5hF4+GyfFkmV4Sw/Qt
         JBuKkT45Bd4UA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Richard Cochran <richardcochran@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 59/77] bnxt_en: replace reset with config timestamps
Date:   Sun,  9 Oct 2022 18:07:36 -0400
Message-Id: <20221009220754.1214186-59-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vfedorenko@novek.ru>

[ Upstream commit 8db3d514e96715c897fe793c4d5fc0fd86aca517 ]

Any change to the hardware timestamps configuration triggers nic restart,
which breaks transmition and reception of network packets for a while.
But there is no need to fully restart the device because while configuring
hardware timestamps. The code for changing configuration runs after all
of the initialisation, when the NIC is actually up and running. This patch
changes the code that ioctl will only update configuration registers and
will not trigger carrier status change, but in case of timestamps for
all rx packetes it fallbacks to close()/open() sequnce because of
synchronization issues in the hardware. Tested on BCM57504.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20220922191038.29921-1-vfedorenko@novek.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 8e316367f6ce..2132ce63193c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -505,9 +505,13 @@ static int bnxt_hwrm_ptp_cfg(struct bnxt *bp)
 	ptp->tstamp_filters = flags;
 
 	if (netif_running(bp->dev)) {
-		rc = bnxt_close_nic(bp, false, false);
-		if (!rc)
-			rc = bnxt_open_nic(bp, false, false);
+		if (ptp->rx_filter == HWTSTAMP_FILTER_ALL) {
+			rc = bnxt_close_nic(bp, false, false);
+			if (!rc)
+				rc = bnxt_open_nic(bp, false, false);
+		} else {
+			bnxt_ptp_cfg_tstamp_filters(bp);
+		}
 		if (!rc && !ptp->tstamp_filters)
 			rc = -EIO;
 	}
-- 
2.35.1

