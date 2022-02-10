Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02BA4B19F6
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 01:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345977AbiBKAAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 19:00:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344855AbiBKAAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 19:00:16 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E2DB43;
        Thu, 10 Feb 2022 16:00:17 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id c188so9484478iof.6;
        Thu, 10 Feb 2022 16:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1VzDs/UF8yNYolinMWkkLgNxpJN0NuoP4WS4+Lqu0sA=;
        b=m35rj5AcGg4ZoO/CaQ6n0yBhN80NZMhAZaAYPc5oQ5QLdbRk6Sl/E8joLQn53J4ff3
         2Q4sVyUWGAiW9X/8aoIfgolVHBX39NTLvrHb/NT1sL9Ckw7tjAj0TA2/Mf+TMPFdlKhe
         E/D2qMjz7iKjdcFKzXN01mzzHTOMC7ys6tQ7P5WAjTgXg7NNG67Tn7WARC/UTrpPNLu/
         p53LCn/B4zYErDdyOIsWeNVIQlH5nblQtYEZAqvmI6fWAjalLCk1MiS0Wix4HmyL1m/7
         /fcQYKq/1C0EpHDZ+djamC1YqlAZ5ps0Tw7cMdqna9BtQRZ1tlLH8EZAZlG8OgZ/vokz
         YQJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1VzDs/UF8yNYolinMWkkLgNxpJN0NuoP4WS4+Lqu0sA=;
        b=Zju7Ck6xu/Agr/t93XDt/4p8c391UDeERVDtbVb1tJjcGC7sgrXgMDveebI62ab3FP
         /uxWwEZbHK225FEIMli81Er4Tb5NViHt2o2iwqVJ7i0eac2n3WsOkyVjeWtv5jcBBmEy
         TBBDNVA6ZR/w4CyGTESsBaxdhRU3kxU4C8/lhFIldDI51TqTY5xLgM/CzExItbfWt8vT
         G8t1fYe6wVMurzAr0+v7muJcFHebKIYutWIxSQUVXBx6lvwtgTqnhntnwAJeCEm1ucbz
         YbwCTV9Yq8k+QGpEw/JlQ9TPYGgswfwlkJ1y4wC9QgqnVkrLHQznUAJHD5xNQtaPHAW0
         dubA==
X-Gm-Message-State: AOAM5339rAB14H7Dix/65hY4Ud1PKg2/L08m6wwnTyGFRGYC7gRMVMh7
        VC1TgxGF7m8fTKwn/pCewcw=
X-Google-Smtp-Source: ABdhPJxIsukjl91lmQIP9KGBjssEZgccEFXHxU6BJidUIyqZB50gNcturaZWfIbyxXDkBQagwZ6erQ==
X-Received: by 2002:a05:6602:148c:: with SMTP id a12mr5156955iow.139.1644537616646;
        Thu, 10 Feb 2022 16:00:16 -0800 (PST)
Received: from localhost ([12.28.44.171])
        by smtp.gmail.com with ESMTPSA id x1sm11412699ilc.34.2022.02.10.16.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 16:00:16 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 31/49] octeontx2-pf: replace bitmap_weight with bitmap_weight_{eq,gt}
Date:   Thu, 10 Feb 2022 14:49:15 -0800
Message-Id: <20220210224933.379149-32-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210224933.379149-1-yury.norov@gmail.com>
References: <20220210224933.379149-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OcteonTX2 code calls bitmap_weight() to compare the weight of bitmap with
a given number. We can do it more efficiently with bitmap_weight_{eq,gt}
because conditional bitmap_weight may stop traversing the bitmap earlier,
as soon as condition is (or can't be) met.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index abe5267210ef..152890066c2a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -287,7 +287,7 @@ static int otx2_set_channels(struct net_device *dev,
 	if (!channel->rx_count || !channel->tx_count)
 		return -EINVAL;
 
-	if (bitmap_weight(&pfvf->rq_bmap, pfvf->hw.rx_queues) > 1) {
+	if (bitmap_weight_gt(&pfvf->rq_bmap, pfvf->hw.rx_queues, 1)) {
 		netdev_err(dev,
 			   "Receive queues are in use by TC police action\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 80b2d64b4136..55c899a6fcdd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -1170,8 +1170,8 @@ int otx2_remove_flow(struct otx2_nic *pfvf, u32 location)
 		 * interface mac address and configure CGX/RPM block in
 		 * promiscuous mode
 		 */
-		if (bitmap_weight(&flow_cfg->dmacflt_bmap,
-				  flow_cfg->dmacflt_max_flows) == 1)
+		if (bitmap_weight_eq(&flow_cfg->dmacflt_bmap,
+				     flow_cfg->dmacflt_max_flows, 1))
 			otx2_update_rem_pfmac(pfvf, DMAC_ADDR_DEL);
 	} else {
 		err = otx2_remove_flow_msg(pfvf, flow->entry, false);
-- 
2.32.0

