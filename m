Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7197E2B0C78
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgKLSWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgKLSWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:22:19 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388E6C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:19 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id f18so4874383pgi.8
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CeSP90eT2JE1bNP53L/Gh+KbyGKotvj69qXfEA8YCFQ=;
        b=nZrkxE3iSZ4VdI1F8ot81coz1JGoT2Ak4hZaGad0EV23V4Dv/K9QCshyhgtdkRiTGX
         IR/GmD5Pb80BSJDyD7cFgcG6lR+maj9RxD/RH7ZBG/4r5XqbQw2VSBRGzbdpuhT27OoA
         WMhagai8Rx+9bVAemHMREr7jf3YjygnnKlwr6Pjdr7sR/2U9pZCTiLG/XGD7/J5u+Zh/
         obs22LIqdi2Bwfl4lis61nNJ9TBZ9sRtTbgofUAOUl6W2gzGByIbeTnQ1hRh5u+pJQ8I
         f2KN4lbg+Oyw4YHpkI0l26BuJVdKfwerKshvKCqoim678iNPC2iS+NLDaHyaJh0mN3Jb
         UpKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CeSP90eT2JE1bNP53L/Gh+KbyGKotvj69qXfEA8YCFQ=;
        b=eZvlpRu40NPTcqGfnwTZ6fT1Rezl9xvQ6PCyj7bMIVv5nZWo+pTBMoMt6mTbyhuMUZ
         IyO/bQ43775LGNP/17IK0it5pXUTKRWPDcZJZGig9LRo+CxFTTrCqV6h0yyCRVpjij+x
         sODLjSazGMKW4Rav9sUxvMxR0xOuJe5jProsvGyTCOffB4kHWU4XuQi52ocXyp5qv3tb
         VYfbL94fHH5Yx0bHTmGGbU73JEqtmHWVp/qDtiUT8X+xMaG2G/035YACxomFv6cuwvz4
         EessZSD24M1e86MhurZxggROGu43pqE8lISyrIUvQHw+APQ4aE18CKJj9w0+N3pUuGT8
         uYGw==
X-Gm-Message-State: AOAM530SOnVMlZ13oyYllYkxtKtOTmje/kyVZop7jrPHrjybTQlP9Zcm
        FMyOwPvUGYeyo45r6AL9bFSX0i4tsb2qQA==
X-Google-Smtp-Source: ABdhPJx260zRvT7QTbY7Jxo8JuVOlyFlrc6cvbEaTDZSFOCTqQyHfaVA+RHGEUunqcdwcyfHQ2eZHQ==
X-Received: by 2002:a63:4247:: with SMTP id p68mr641936pga.338.1605205338549;
        Thu, 12 Nov 2020 10:22:18 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id m6sm7152292pfa.61.2020.11.12.10.22.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2020 10:22:18 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 2/8] ionic: check for link after netdev registration
Date:   Thu, 12 Nov 2020 10:22:02 -0800
Message-Id: <20201112182208.46770-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201112182208.46770-1-snelson@pensando.io>
References: <20201112182208.46770-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Request a link check as soon as the netdev is registered rather
than waiting for the watchdog to go off in order to get the
interface operational a little more quickly.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 5457fb5d69ed..519d544821af 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2959,6 +2959,8 @@ int ionic_lif_register(struct ionic_lif *lif)
 		dev_err(lif->ionic->dev, "Cannot register net device, aborting\n");
 		return err;
 	}
+
+	ionic_link_status_check_request(lif, true);
 	lif->registered = true;
 	ionic_lif_set_netdev_info(lif);
 
-- 
2.17.1

