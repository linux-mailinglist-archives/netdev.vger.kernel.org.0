Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C624B5A4B98
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbiH2MYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiH2MXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:23:51 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06318A7AB4;
        Mon, 29 Aug 2022 05:08:19 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 9CBAE1E80D5E;
        Mon, 29 Aug 2022 19:09:05 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id baIy2p6apqZl; Mon, 29 Aug 2022 19:09:02 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 0D4FF1E80D59;
        Mon, 29 Aug 2022 19:09:02 +0800 (CST)
From:   Li Qiong <liqiong@nfschina.com>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>,
        Li Qiong <liqiong@nfschina.com>
Subject: [PATCH v2] wifi: brcmfmac: add error code in brcmf_notify_sched_scan_results()
Date:   Mon, 29 Aug 2022 19:12:56 +0800
Message-Id: <20220829111256.21923-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20220829065831.14023-1-liqiong@nfschina.com>
References: <20220829065831.14023-1-liqiong@nfschina.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The err code is 0 at the first two "out_err" paths, add error code
'-EINVAL' for these error paths.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
---
v1->v2:
- Modify subject.
- Resend patch and CC to linux-wireless.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index db45da33adfd..b965649bb0e4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3553,6 +3553,7 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 	WARN_ON(status != BRCMF_PNO_SCAN_COMPLETE);
 	brcmf_dbg(SCAN, "PFN NET FOUND event. count: %d\n", result_count);
 	if (!result_count) {
+		err = -EINVAL;
 		bphy_err(drvr, "FALSE PNO Event. (pfn_count == 0)\n");
 		goto out_err;
 	}
@@ -3560,6 +3561,7 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 	netinfo_start = brcmf_get_netinfo_array(pfn_result);
 	datalen = e->datalen - ((void *)netinfo_start - (void *)pfn_result);
 	if (datalen < result_count * sizeof(*netinfo)) {
+		err = -EINVAL;
 		bphy_err(drvr, "insufficient event data\n");
 		goto out_err;
 	}
-- 
2.11.0

