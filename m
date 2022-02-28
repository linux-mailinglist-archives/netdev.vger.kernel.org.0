Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D7C4C64E8
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 09:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbiB1Iho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 03:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiB1Ihn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 03:37:43 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B8366202;
        Mon, 28 Feb 2022 00:37:05 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id bd1so10051389plb.13;
        Mon, 28 Feb 2022 00:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RdJaANiEHPY4Xp6y7T90xtbRbQ1zCSCWRMALDqz2S1E=;
        b=O+SiBscvMN4QOyf2WWIJIimqdE2rPKAVCNlbFv93sJTuOvxKetcxl1sM+knwyr3qRN
         R9vNWvyFnwUgi5JIM+wZ4oy2WTr+Q/nf6IRhpuCytRZbZEBSqRwHEFAstg9wLj+r/W9m
         pG0Kp7ciljhEHrpjAMZMLt9giHvxIj+ySQCVNNHTbKboORB7bFMuG33zjzB/oGMul0rH
         5zdrVzRDSSoUtw8dVmYX4HC3bVx/G+KWBe082KLZFEm6orgltFNQWeh6AoRBLs8SH/M2
         fBNjmSaBjiP8tOGjTMQo5lI2werXGqBfjycnD0wdmMRdGvLcsxFDYv4Q4uiqIDsb7U63
         9nQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RdJaANiEHPY4Xp6y7T90xtbRbQ1zCSCWRMALDqz2S1E=;
        b=m9UhO2wagAuw9ictOAfMH1U7V2KKK8nxKo/QuJGdloFT6jinGjev8jqLHxQxh/2Ye7
         UEeFmtgc7JIIA2TSF2HKrbRXhAkhhwY9j/vgRg2pXymgVBvSK9FDJioge+AhqdQv6ixZ
         QbOcq0zWj2+1j8rl9uHleqODL8rrvauyT2gFc20PSan1hSkhGgTOVPNtqBeTMdhmO1dY
         wFjGHWkw6YruJI08PNVCb/LybINVN/WeoUP5s9X+kA+oKnbr/Xidd8uaUzlZuAj7yb8Z
         cHRl3IobOubZJrtlMWp0mavUXoQIJhamwD0D6aUU3g6/3f1d4jvao3qgi+IlC1fsCN3E
         i3XA==
X-Gm-Message-State: AOAM532lG1LNtMSfMsWpJi8HiW8EI8qnBNrM7roKfPaZLCX9K//RZt52
        U1IP0UBR6BIq4ms8B1Q7CAz4tFpkIK8AsdvG
X-Google-Smtp-Source: ABdhPJzYDieLjOM8cJWQ0nnleIGse98JBYhW63ed+4WhqGry8DeDpwFdI9CmCOiyzeA+ZSGFfkesCA==
X-Received: by 2002:a17:90a:2b0d:b0:1b5:8087:4b4e with SMTP id x13-20020a17090a2b0d00b001b580874b4emr15409414pjc.70.1646037425070;
        Mon, 28 Feb 2022 00:37:05 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id nl12-20020a17090b384c00b001bc1bb5449bsm10146280pjb.2.2022.02.28.00.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 00:37:04 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, stefan.maetje@esd.eu, mailhol.vincent@wanadoo.fr,
        paskripkin@gmail.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] can: usb: delete a redundant dev_kfree_skb() in ems_usb_start_xmit()
Date:   Mon, 28 Feb 2022 16:36:39 +0800
Message-Id: <20220228083639.38183-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
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

There is no need to call dev_kfree_skb when usb_submit_urb fails beacause
can_put_echo_skb deletes original skb and can_free_echo_skb deletes the cloned
skb.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 drivers/net/can/usb/ems_usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 7bedceffdfa3..bbec3311d893 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -819,7 +819,6 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buff *skb, struct net_device *ne
 
 		usb_unanchor_urb(urb);
 		usb_free_coherent(dev->udev, size, buf, urb->transfer_dma);
-		dev_kfree_skb(skb);
 
 		atomic_dec(&dev->active_tx_urbs);
 
-- 
2.25.1

