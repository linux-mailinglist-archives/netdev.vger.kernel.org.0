Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63DD537199
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 17:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiE2PjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 11:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiE2PjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 11:39:14 -0400
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358DC62CF2;
        Sun, 29 May 2022 08:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1653838744;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=xGbv7HlqU9NUiVmKFFfWHWJ7GjiXkmgNU5UawXCQxn8=;
        b=CEiWwOtlT6bd2aVw4bG73jCv97mRPVBdqfemmSl/LrQoOQJuysu1DOyLp9C6hlcb
        l2D8QE9ga+kYz/ATTtLgF0EOURGdgn332FlVJoPf6/C9LyQkbp8oe5lGo+4xeIauouw
        7C7pRqm4BnKd9PBU8/vgPBg4yEo7o44a99YUBhJg=
Received: from localhost.localdomain (81.71.33.115 [81.71.33.115]) by mx.zoho.com.cn
        with SMTPS id 1653838743051746.6363796456236; Sun, 29 May 2022 23:39:03 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20220529153456.4183738-7-cgxu519@mykernel.net>
Subject: [PATCH 6/6] media: platform: fix missing/incorrect resource cleanup in error case
Date:   Sun, 29 May 2022 23:34:56 +0800
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220529153456.4183738-1-cgxu519@mykernel.net>
References: <20220529153456.4183738-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In error case of s5p_mfc_power_on() we should call
clk_disable_unprepare() for the
clocks(from pm->clocks[0] to pm->clocks[i-1]).

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc_pm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_pm.c b/drivers/=
media/platform/samsung/s5p-mfc/s5p_mfc_pm.c
index 72a901e99450..187849841a28 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_pm.c
@@ -88,7 +88,6 @@ int s5p_mfc_power_on(void)
 =09=09if (ret < 0) {
 =09=09=09mfc_err("clock prepare failed for clock: %s\n",
 =09=09=09=09pm->clk_names[i]);
-=09=09=09i++;
 =09=09=09goto err;
 =09=09}
 =09}
@@ -98,7 +97,7 @@ int s5p_mfc_power_on(void)
=20
 =09return 0;
 err:
-=09while (--i > 0)
+=09while (--i >=3D 0)
 =09=09clk_disable_unprepare(pm->clocks[i]);
 =09pm_runtime_put(pm->device);
 =09return ret;
--=20
2.27.0


