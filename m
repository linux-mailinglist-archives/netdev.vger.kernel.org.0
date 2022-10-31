Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7EF6138FE
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 15:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiJaOc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 10:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiJaOc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 10:32:57 -0400
Received: from mail.draketalley.com (mail.draketalley.com [3.213.214.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D680EFADC;
        Mon, 31 Oct 2022 07:32:55 -0700 (PDT)
Received: from pop-os.lan (cpe-74-72-139-32.nyc.res.rr.com [74.72.139.32])
        by mail.draketalley.com (Postfix) with ESMTPSA id 0A33055DD3;
        Mon, 31 Oct 2022 14:25:31 +0000 (UTC)
From:   drake@draketalley.com
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev
Cc:     linux-kernel@vger.kernel.org, Drake Talley <drake@draketalley.com>
Subject: [PATCH 2/3] staging: qlge: replace msleep with usleep_range
Date:   Mon, 31 Oct 2022 10:25:15 -0400
Message-Id: <20221031142516.266704-3-drake@draketalley.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221031142516.266704-1-drake@draketalley.com>
References: <20221031142516.266704-1-drake@draketalley.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,SPF_HELO_SOFTFAIL,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Drake Talley <drake@draketalley.com>

Since msleep may delay for up to 20ms, usleep_range is recommended for
short durations in the docs linked in the below warning.  I set the
range to 1000-2000 based on looking at other usages of usleep_range.

Reported by checkpatch:

WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.rst

Signed-off-by: Drake Talley <drake@draketalley.com>
---
 drivers/staging/qlge/qlge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 8c1fdd8ebba0..c8403dbb5bad 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3890,7 +3890,7 @@ static int qlge_close(struct net_device *ndev)
 	 * (Rarely happens, but possible.)
 	 */
 	while (!test_bit(QL_ADAPTER_UP, &qdev->flags))
-		msleep(1);
+		usleep_range(1000, 2000);
 
 	/* Make sure refill_work doesn't re-enable napi */
 	for (i = 0; i < qdev->rss_ring_count; i++)
-- 
2.34.1

