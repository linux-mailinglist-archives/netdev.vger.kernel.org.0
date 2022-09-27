Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F5F5EB65A
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 02:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiI0AkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 20:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiI0Aj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 20:39:59 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280AB13D3D
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 17:39:56 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id b21so7704764plz.7
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 17:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=gjxDtq0Rs25czueJLh+kJywKCTsPWEllkeEaIximls0=;
        b=Qt+pUXJLWWjyzrTWNLVv+IQOkUSuFq6QCzrTd+bfNJnEC/mlmP7mJ1ZUPsX+Z6hY3m
         UM7tKgEFBDCquZJfU17BA8hgD9xba/Apk87oVo5NgbL4bDm6u2I2ISuoXK3+DTdTX8VJ
         rzbW/CRrTHVIGYT5eCnI9w3mgYaszxwfLJYmk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=gjxDtq0Rs25czueJLh+kJywKCTsPWEllkeEaIximls0=;
        b=Kk+xJaRIDv8BClbWpA5zdImd1PpK7vs+9+F2zRTGsuMIXQIAdMpeGLtQmbN+8/weXa
         POYdEfyWx+g1mX7IU4jtBVfjZ5DGk4ELeXV3fdJRv1mDQAXzn69vWF5Yth0IXjAz5TAQ
         QCOLY52mBtL7a2duoMAnShhcw+cqqUqZPx3oX7RiGkOL6wD1tIt+oJGVID4M/SjP6IcL
         Txa3hKWF149SVhQOq3vyGTw/PkmGXF0v5hCskmWB7+WdySc7wuFZWj+VlP1+DZRBCq5m
         RicqQinSZrLxFzdWCzGDscCZl2GVSn4m4iHFZIGj9i9Whth7Q5iNDiT9Tt4SoxFCPLwi
         lT2Q==
X-Gm-Message-State: ACrzQf1QvdhjA+TD4BnXh8zc1XbGqi8CR5Ft0OR1VSoANtcPyixr79s0
        YpZ7YCOyHbnm3+erorsKH//+9A==
X-Google-Smtp-Source: AMsMyM5pQdcBoOOjpvAnHrRCRpqxxSRTU/ZRyp8BkwhdPdn40BuanqBBOrCLJUQGCUnzyKSBznk1fQ==
X-Received: by 2002:a17:903:2005:b0:178:3a78:80f5 with SMTP id s5-20020a170903200500b001783a7880f5mr24986789pla.174.1664239195767;
        Mon, 26 Sep 2022 17:39:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h13-20020aa796cd000000b00540a346477csm133564pfq.76.2022.09.26.17.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 17:39:55 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] s390/qeth: Split memcpy() of struct qeth_ipacmd_addr_change flexible array
Date:   Mon, 26 Sep 2022 17:39:53 -0700
Message-Id: <20220927003953.1942442-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1525; h=from:subject; bh=bUXptYsfn3QynH+ULXH8Hc9/lgFc7+jyEV9USOVT9ms=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjMkZYJo3tqJvuRRvDT0Kc6P0APNVENYY0JXVpJPN6 o6X87pSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYzJGWAAKCRCJcvTf3G3AJoKLD/ 4pR/ZckZK4sdm9vPPPFA6WxL7A7xzH3EEfNBZ9NGAtkbm3elkZ/DRy0ULpzf7cp9z3/+g8ELZZio3Q llnRP2YMWF2GtNjMvhOctWgPQs7E3S80c5K3o5/j8A4PCZYo1RZli9eCra34cEQVrtKBXRRkspKGkv OjOrwLys51OAEu1HlZi3JckcCBQjGMjGQdDY+kk08Gt2XJv7N7iUxvy4kpp4bF6jobSVhmpKkyvDZt Mv4ydOMUF0j03BktcAJ4z/EtNf4JRPYuoVZIm1+JQiG51ewlVlndEhZ6kCiiIQPdq+RkkR/sMMC0s1 tsByRgpVn4jm95vXnuFV6lzdXnFSlsLQnTsjktuThpW+Nl5Cy0BVubYDZlOUlEcwP8u7PFiOkPcoWo 6Alczo9emoomb9jpWVbfd1Y5E2mW+mwukZlPd5z561oY2BDXC5oPLjCf5pDiRrM1pej99tT9ecFlTc ntLfR9LdRzBrQoyya648IpdOWzMgF5/VqJAaijut2pe7EYXILso1I6wKy0pvf1HLwE2DEv5kKUrMkm CfjGvONdqD3v0wbW3/p5bxPOac1ZgjsdxeF5a83y+Yn4MaY1MQRE4oQg/8DptmBvHLCooSHxqfRaG9 R8ITRB0DB14zuluOnP1MMssvrXDnUVNElfF2eAUJLu5LYQ9dEMKNeDvKstJA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To work around a misbehavior of the compiler's ability to see into
composite flexible array structs (as detailed in the coming memcpy()
hardening series[1]), split the memcpy() of the header and the payload
so no false positive run-time overflow warning will be generated.

[1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org/

Cc: Alexandra Winter <wintera@linux.ibm.com>
Cc: Wenjia Zhang <wenjia@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/s390/net/qeth_l2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 2d4436cbcb47..0ce635b7b472 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1530,8 +1530,8 @@ static void qeth_addr_change_event(struct qeth_card *card,
 	else
 		INIT_DELAYED_WORK(&data->dwork, qeth_l2_dev2br_worker);
 	data->card = card;
-	memcpy(&data->ac_event, hostevs,
-			sizeof(struct qeth_ipacmd_addr_change) + extrasize);
+	data->ac_event = *hostevs;
+	memcpy(data->ac_event.entry, hostevs->entry, extrasize);
 	queue_delayed_work(card->event_wq, &data->dwork, 0);
 }
 
-- 
2.34.1

