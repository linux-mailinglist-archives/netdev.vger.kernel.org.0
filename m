Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957E66426E0
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 11:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiLEKlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 05:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiLEKlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 05:41:35 -0500
X-Greylist: delayed 1473 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Dec 2022 02:41:34 PST
Received: from cinnabar.sosdg.org (unknown [IPv6:2620:64::5054:ff:fe48:4373])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FD96437
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 02:41:34 -0800 (PST)
Received: from qiyong by cinnabar.sosdg.org with local (Exim 4.94.2)
        (envelope-from <qiyong@cinnabar.sosdg.org>)
        id 1p28Wx-00HEcO-VB; Mon, 05 Dec 2022 18:17:00 +0800
Date:   Mon, 5 Dec 2022 18:16:59 +0800
From:   qiyong@sosdg.org
To:     qiangqing.zhang@nxp.com
Cc:     netdev@vger.kernel.org, yong.qi@i-soft.com.cn
Subject: fec_restart fix
Message-ID: <Y43FGyItmu/0Rxst@cinnabar.sosdg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_20,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fec_restart fix. fec would not recevie packets without this fix. Tested with s32v234.

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 659331fca40a..e5c8c15bfa04 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1005,6 +1005,7 @@ fec_restart(struct net_device *ndev)
 	 * instead of reset MAC itself.
 	 */
 	if (fep->quirks & FEC_QUIRK_HAS_MULTI_QUEUES ||
+	    (fep->quirks & FEC_QUIRK_HAS_AVB) ||
 	    ((fep->quirks & FEC_QUIRK_NO_HARD_RESET) && fep->link)) {
 		writel(0, fep->hwp + FEC_ECNTRL);
 	} else {
