Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF7D67A20B
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 20:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjAXTBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 14:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbjAXTB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 14:01:29 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265794DCD9
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 11:01:27 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d3so15651141plr.10
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 11:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=50cO/6ZppDTgK/hTEwdsnZtIUmof/i6Am5RFe+y6fDg=;
        b=jfE7I7WvzTda77if8o0AnlZyXeVHxwVIDww/9+S2ljpISGdXCqTC5lnP6jAn25+P3s
         JiEJswbNMHjeomPV9fvhWaP1X+eg4zcs17gt/efjfnNzHMspdGlPF5yq+/Cfg1HOvLg2
         Kp5IWDoo6CYqTnsILJ5HtBvSIVzD/oqlSVKFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=50cO/6ZppDTgK/hTEwdsnZtIUmof/i6Am5RFe+y6fDg=;
        b=cRaY9RzdnRKw3sMLpWj81WiZOyZ7prpAAL7uBB6BpfvHXJxun43VAC21riUuOmjU/i
         Xqn9FMG/eBCEcgcENEap40T7xXQ/7yNzjsCU6EzDq1JTclA8zzUZcQekzwu+1hpkeBp0
         55/ve55N3QA5kHs1bqF2fMoktGImbR9OJ9Ik570Ud3ft8sq3nQIMqnPJp+O8MKZT10NH
         rOHmI/iOx8q43tIAOkQ5r7f/vnsgaGT/pPYIHrTaK7h0l+gi6xIC78Bpt/FS32hn21pZ
         fKL1VfXyPQJxDobnnM8TQs2w0EYNf1dpTAZozo4+Q/Uo953ZmgmZl6DH915b+pHpPuym
         8f2A==
X-Gm-Message-State: AO0yUKV8WRRMfE7FSgjZU5CIyLbXKB9fQFWWCQ7oL68SOW1Zb5nxvioo
        nPfcle6pQ+Si9IWU29VeADIong==
X-Google-Smtp-Source: AK7set8UGHGugxZPfIDZziY43UqyiSusorvSQsjCeo4te4wOprdvp/KbTUT4tFW/IJ4PPfPd66crVg==
X-Received: by 2002:a17:903:18f:b0:196:cea:487a with SMTP id z15-20020a170903018f00b001960cea487amr6070801plg.53.1674586886656;
        Tue, 24 Jan 2023 11:01:26 -0800 (PST)
Received: from tictac2.mtv.corp.google.com ([2620:15c:9d:2:7b28:de8d:ee0:2cd6])
        by smtp.gmail.com with ESMTPSA id f10-20020a17090274ca00b001948720f6bdsm2010415plt.98.2023.01.24.11.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 11:01:26 -0800 (PST)
From:   Douglas Anderson <dianders@chromium.org>
To:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Youghandhar Chintala <quic_youghand@quicinc.com>,
        junyuu@chromium.org, Kalle Valo <kvalo@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 2/2] wifi: ath5k: Use platform_get_irq() to get the interrupt
Date:   Tue, 24 Jan 2023 11:01:01 -0800
Message-Id: <20230124110057.2.Ic4f8542b0588d7eb4bc6e322d4af3d2064e84ff0@changeid>
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
In-Reply-To: <20230124110057.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
References: <20230124110057.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the same reasons talked about in commit 9503a1fc123d ("ath9k: Use
platform_get_irq() to get the interrupt"), we should be using
platform_get_irq() in ath5k. Let's make the switch.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
I'm not setup to actually test this, but I figured that I might as
well go all the way and fix all the instances of the same pattern that
I found in the ath drivers since the old call was actually breaking me
in ath11k. I did at least confirm that the code compiles for me.

If folks would rather not land an untested patch like this, though,
feel free to drop this and just land patch #1 as long as that one
looks OK.

 drivers/net/wireless/ath/ath5k/ahb.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index 2c9cec8b53d9..28a1e5eff204 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -113,15 +113,13 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		goto err_out;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "no IRQ resource found\n");
-		ret = -ENXIO;
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no IRQ resource found: %d\n", irq);
+		ret = irq;
 		goto err_iounmap;
 	}
 
-	irq = res->start;
-
 	hw = ieee80211_alloc_hw(sizeof(struct ath5k_hw), &ath5k_hw_ops);
 	if (hw == NULL) {
 		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
-- 
2.39.1.405.gd4c25cc71f-goog

