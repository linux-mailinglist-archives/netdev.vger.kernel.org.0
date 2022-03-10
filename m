Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A07B4D4EAB
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239900AbiCJQRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241652AbiCJQRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:17:01 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7304192CA2
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:15:48 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id yy13so13241125ejb.2
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KBRlxPdJMssjtNZRguyEtM50LYBflNdJFSbuoineT2Q=;
        b=mRDIekoOfmjqJPvI12wW46Sn2Ak/OLZfQsb3mi4gnPhFYoHK7zV9YLHCAQrRazYKvw
         n6fSOK05emRMwST3C0eZvFwcl7t8USNRdPX32WApDNZOqeOj/Wyz+6WvMTkeO1Gm/GOE
         wRLDDh5Hw8rLb0Mc+jF7kalmNmHz53k1Yr0ThbU+h1wY+c3YCLQVbuvMc0eXupc8W9I9
         9bFqdeVNXxbuPaYqPoA6ld2S5rHchU7/tnZ96nTMSRUgJcu9KmW4eLNzj8N4Nthy4YCR
         W6TVbQ/VbQP0qkW0oy6AtrB3I5hcnSs49hHyFREpROUpbhrcXKc+Q9yEbZo4Ib9j+5Us
         +FRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KBRlxPdJMssjtNZRguyEtM50LYBflNdJFSbuoineT2Q=;
        b=AfHSbHAtN51R6hUuOQUjWlNZKQRCsqE/ndcDm6AD2zvY1h2DUWp67GG45ReLiRnixi
         KO0ZgNqTW8jzg782j04fZvMK2YkNiRwhx+5UT1jCHCAJ3QDq21iVsBBA7EBVlVTmsS05
         9eGJLLpGSIFSO+23OzfrGdB/Vj9R7yU2iwyeutr4sZWEWCAH697gxwFw817zmIg/fAAw
         JccvFqrAUfzWBMNF/fwuu4U96CQMmU52zTqCnwun9b6a//uhCy50rgrK7F7Z3vRlD56I
         P9ZJpJL3GrTuqeK9DH+XtS4ywZxXnHhuwyFOlJLsIar/7FYvrGw+VHqH+olvuX3EH9F8
         9JmA==
X-Gm-Message-State: AOAM533IZP4xgXpXWiStM/lTuU6zKh1+ZWVDZtSrDhFjnlgoiLwdrLfz
        0mpptRP+FKXemn5blZ7cWLO+f7IR2I0e0A==
X-Google-Smtp-Source: ABdhPJx/KwosCYukLIVCRpt5+IS+g8+IqjMp/1zhrphZduI/5AhzR0GCkzug8ANG1goA+Iw2Uq+new==
X-Received: by 2002:a17:906:1804:b0:6d6:dc46:d9ed with SMTP id v4-20020a170906180400b006d6dc46d9edmr4815720eje.288.1646928946478;
        Thu, 10 Mar 2022 08:15:46 -0800 (PST)
Received: from nlaptop.localdomain (ptr-dtfv0poj8u7zblqwbt6.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:f2b6:6987:9238:41ca])
        by smtp.gmail.com with ESMTPSA id bx1-20020a0564020b4100b00410f01a91f0sm2280107edb.73.2022.03.10.08.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 08:15:46 -0800 (PST)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH] alx: acquire mutex for alx_reinit in alx_change_mtu
Date:   Thu, 10 Mar 2022 17:13:16 +0100
Message-Id: <20220310161313.43595-1-dossche.niels@gmail.com>
X-Mailer: git-send-email 2.35.1
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

alx_reinit has a lockdep assertion that the alx->mtx mutex must be held.
alx_reinit is called from two places: alx_reset and alx_change_mtu.
alx_reset does acquire alx->mtx before calling alx_reinit.
alx_change_mtu does not acquire this mutex, nor do its callers or any
path towards alx_change_mtu.
Acquire the mutex in alx_change_mtu.

Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
---
 drivers/net/ethernet/atheros/alx/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 4ad3fc72e74e..a89b93cb4e26 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1181,8 +1181,11 @@ static int alx_change_mtu(struct net_device *netdev, int mtu)
 	alx->hw.mtu = mtu;
 	alx->rxbuf_size = max(max_frame, ALX_DEF_RXBUF_SIZE);
 	netdev_update_features(netdev);
-	if (netif_running(netdev))
+	if (netif_running(netdev)) {
+		mutex_lock(&alx->mtx);
 		alx_reinit(alx);
+		mutex_unlock(&alx->mtx);
+	}
 	return 0;
 }
 
-- 
2.35.1

