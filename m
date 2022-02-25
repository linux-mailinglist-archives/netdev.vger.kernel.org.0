Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541604C3E29
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237707AbiBYGBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbiBYGBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:01:06 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC501FE57C;
        Thu, 24 Feb 2022 22:00:33 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id o26so3087974pgb.8;
        Thu, 24 Feb 2022 22:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=715+iHDIteBSVf+EcibgL15UYpQnPyaHRHADoqHckY0=;
        b=CIC5CFvUXwBODJfkqpuPVIhYaZoMjAxsqXxnQFNVJeieuYuEFLck1KxZ4sVAiWgp7O
         tZmaJ7DSMuxb42TAfX+uyhmIGPJnbwy+Zpye5HkzYL5E5y/I2PbgTUtVdNCHR8Vfr1vB
         klqt9q/conYHnUkLWqXj1OHb3tLuwL27DfQqpHUACt3GnOqT7qjfOipLI5WBFx1jwhRM
         xThIaepJQ5Z2hxBNcQNFBJd2R2GJ2fwfdijKx1iavn3nFnapjxN5YZN/FoGnhaB/M36Q
         8HiqGhAhDvB4EKSUEhvrHeRBGqAtyIY9Ap9A8XkWLt7waF91lUOEZJlfMj6fgnWmPRpS
         +vqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=715+iHDIteBSVf+EcibgL15UYpQnPyaHRHADoqHckY0=;
        b=PyJHlxJ0TKOdDiVpxcZbGWJncmuiQ9GGN1KQFFYcRiQDEMq3t2JdSKqWnWWmmG9Wtc
         VzW9+7r50HGyiO0ZDGnjpVcK9/bmJev0Cl4yOBX0W+1Sbsq3rcvSHQxIJ2a/thfd87Bj
         afusqA+6QWRxqbJ3eJU4oel1Maj8K7bHHpqLkEwIHZUcGzzv2SArmDodQGBegG/38LXQ
         heERMX9cUZSmsBaZ8uMaPisAxuHAXqH0NLaQmCe28hYG56lY+OcxZj72WTcipan8txcd
         VUK8MjAZjZpZYa0nCT0fe3o8tubdg7bHdMYA7BM+lr0BTBDK8eHKtUS0ERu00vrHsg+t
         VsNQ==
X-Gm-Message-State: AOAM533FvfSgbERWoBFqQGrvjpuAmdF/wfBu5Ie5X/gEK6U+7i8feJsr
        0jxYZRB8qzI0YksfpZUTxxY=
X-Google-Smtp-Source: ABdhPJwph3GsQFyYTh10yHH7GfFNpJCAOAPLzALMHANKlri7mkftQ6gNyti2OTw2bbrv/eXGlBDklA==
X-Received: by 2002:a05:6a00:1aca:b0:4e1:a2b6:5b9 with SMTP id f10-20020a056a001aca00b004e1a2b605b9mr6202235pfv.4.1645768833303;
        Thu, 24 Feb 2022 22:00:33 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.54])
        by smtp.gmail.com with ESMTPSA id d14-20020a056a0024ce00b004f3c87df62bsm1491120pfv.81.2022.02.24.22.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 22:00:32 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, stefan.maetje@esd.eu, mailhol.vincent@wanadoo.fr,
        paskripkin@gmail.com, thunder.leizhen@huawei.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] can: usb: fix a possible memory leak in esd_usb2_start_xmit
Date:   Fri, 25 Feb 2022 14:00:19 +0800
Message-Id: <20220225060019.21220-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As in case of ems_usb_start_xmit, dev_kfree_skb needs to be called when
usb_submit_urb fails to avoid possible refcount leaks.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 drivers/net/can/usb/esd_usb2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 286daaaea0b8..7b5e6c250d00 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -810,7 +810,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 		usb_unanchor_urb(urb);
 
 		stats->tx_dropped++;
-
+		dev_kfree_skb(skb);
 		if (err == -ENODEV)
 			netif_device_detach(netdev);
 		else
-- 
2.25.1

