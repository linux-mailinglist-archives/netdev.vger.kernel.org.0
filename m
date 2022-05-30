Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC37B538194
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240800AbiE3OUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241434AbiE3ORf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:17:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD09A50008;
        Mon, 30 May 2022 06:47:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68E9360EC3;
        Mon, 30 May 2022 13:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17995C3411C;
        Mon, 30 May 2022 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918426;
        bh=+hGjQKfDNGnTsMzTo9PMesAjDFTq1kh+tT1+3aPgf3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=axk87PkP5bGhgRXvraDgQAwwAECGpBA+iEb4P1RU8yQ9G/BJCGR+5rl1a7ZKYQ61w
         Ha4vj/PKnTkuaddyC/UwLpBeuDj7uJPLrApxdsOpdMG28nMLCdLdl/xiUsUMm06A+v
         xrjrmCcvC7uq046m0mrbPCPl6n/FFhuzwS05x0fRrakrTLWIOqXwaHJq4sxIGCBsP4
         zgkTYf/tbyPx9s3c+IrS3iLzuoiVuU1OtjGLvV8S6/sMXif1OaTG3SXkfaIKFCMIoR
         /u/3m9idbTr+H2evF5eNa49xeLvpeRe01Py+xMKrI5b7i68CmrE66bgJLYWz/1CQKo
         Mi23Eimt4K3UQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niels Dossche <dossche.niels@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/55] mwifiex: add mutex lock for call in mwifiex_dfs_chan_sw_work_queue
Date:   Mon, 30 May 2022 09:46:08 -0400
Message-Id: <20220530134701.1935933-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134701.1935933-1-sashal@kernel.org>
References: <20220530134701.1935933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit 3e12968f6d12a34b540c39cbd696a760cc4616f0 ]

cfg80211_ch_switch_notify uses ASSERT_WDEV_LOCK to assert that
net_device->ieee80211_ptr->mtx (which is the same as priv->wdev.mtx)
is held during the function's execution.
mwifiex_dfs_chan_sw_work_queue is one of its callers, which does not
hold that lock, therefore violating the assertion.
Add a lock around the call.

Disclaimer:
I am currently working on a static analyser to detect missing locks.
This was a reported case. I manually verified the report by looking
at the code, so that I do not send wrong information or patches.
After concluding that this seems to be a true positive, I created
this patch.
However, as I do not in fact have this particular hardware,
I was unable to test it.

Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220321225515.32113-1-dossche.niels@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/11h.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/11h.c b/drivers/net/wireless/marvell/mwifiex/11h.c
index 238accfe4f41..c4176e357b22 100644
--- a/drivers/net/wireless/marvell/mwifiex/11h.c
+++ b/drivers/net/wireless/marvell/mwifiex/11h.c
@@ -303,5 +303,7 @@ void mwifiex_dfs_chan_sw_work_queue(struct work_struct *work)
 
 	mwifiex_dbg(priv->adapter, MSG,
 		    "indicating channel switch completion to kernel\n");
+	mutex_lock(&priv->wdev.mtx);
 	cfg80211_ch_switch_notify(priv->netdev, &priv->dfs_chandef);
+	mutex_unlock(&priv->wdev.mtx);
 }
-- 
2.35.1

