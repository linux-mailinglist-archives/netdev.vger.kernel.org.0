Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400B42E27A3
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 15:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgLXO0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 09:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgLXO0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 09:26:34 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4475CC06179C;
        Thu, 24 Dec 2020 06:25:54 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id i5so1659713pgo.1;
        Thu, 24 Dec 2020 06:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=M1ZWqv1znGqr6p1lRTewGyanamdITR8p87XaqsvWjsM=;
        b=Wh/DAn1Lg1lqObkMZFfvyZF388WBeIbZXFBq13tAd1VEgkw+M4LJXfjs0b95ahtOMX
         c32Vv0rwkYWwbPaug66GZYzdpluAsMTAp4v5g/aTMPwCtrRomVxyktE06en1BFEHHKYh
         Au6IaYUjex7Joi/d3HkP4UKEy/J9x/1D5VyWUysSNubgG1RbcgY5lefa7gbqytCWjqPF
         9pctvA8uVHEL0dPMJ2hblTTx/Yi+4k3uRAn/3LDBUKM7+UWwRK89o1DwVs3HXm7kOUGB
         q0L2gdlFO9T6xRv7xeGmpstUqGsIw2VMyAFFG6SQe4XT8I+gWMupEhdTi71QJZw62WLc
         nkYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=M1ZWqv1znGqr6p1lRTewGyanamdITR8p87XaqsvWjsM=;
        b=k7DudgeDgQ+lzbUP8qQsRJ4Vpd3Ql/eMF5BSMUK3QMUO/mrhr1smojXZ0rHhzjo7CG
         eMkjIbMAFl/C+T99HiJP4cp7/mnqiUruGPEFef2vEvV4f7UiJeCv0dTJS7YTWdbDOMsR
         VXU2MvYMqimRFQmoZo1FLtr6JzYAVrfAXpd7EMzFtIk4bVzvWnjA+8+WPPr9kJ+jkQes
         4Wyk07KW7y/omEwXAm2uUsXZ4xUsnWjJ2FiRJ8PVwV9J/mtaUk/+HlQ+EWLhc8+l5llr
         WvZeTttXsdAWlSs9kWRIruWc0o4uW5GiJpcQXRTWW53JX1xcUp1zfahknYotM7YhaS/U
         k4IA==
X-Gm-Message-State: AOAM530XGtucnP2NKjYC5OvicVanKdykac9PFc2b5GiScZB12E/YnJWH
        M465CdY1nP+QNqQpK22OA0c=
X-Google-Smtp-Source: ABdhPJxahunFhGBPVq1miW5Ne/emwEly58wXygON2lajXZ4StPqI8VIN/zU1tYPEPO5hDWAoiF5xVg==
X-Received: by 2002:a63:1220:: with SMTP id h32mr28741916pgl.309.1608819953741;
        Thu, 24 Dec 2020 06:25:53 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id r185sm26936351pfc.53.2020.12.24.06.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 06:25:53 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/6] bcm63xx_enet: major makeover of driver
Date:   Thu, 24 Dec 2020 22:24:15 +0800
Message-Id: <20201224142421.32350-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series aim to improve the bcm63xx_enet driver by integrating the
latest networking features, i.e. batched rx processing, BQL, build_skb, etc.

The newer enetsw SoCs are found to be able to do unaligned rx DMA by adding
NET_IP_ALIGN padding which, combined with these patches, improved packet
processing performance by ~50% on BCM6328.

Older non-enetsw SoCs still benefit mainly from rx batching. Performance
improvement of ~30% is observed on BCM6333.

The BCM63xx SoCs are designed for routers. As such, having BQL is beneficial
as well as trivial to add.

v2:
* Add xmit_more support and rx loop improvisation patches.
* Moved BQL netdev_reset_queue() to bcm_enet_stop()/bcm_enetsw_stop()
  functions as suggested by Florian Fainelli.
* Improved commit messages.

Sieng Piaw Liew (6):
  bcm63xx_enet: batch process rx path
  bcm63xx_enet: add BQL support
  bcm63xx_enet: add xmit_more support
  bcm63xx_enet: alloc rx skb with NET_IP_ALIGN
  bcm63xx_enet: convert to build_skb
  bcm63xx_enet: improve rx loop

 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 184 ++++++++++---------
 drivers/net/ethernet/broadcom/bcm63xx_enet.h |  14 +-
 2 files changed, 103 insertions(+), 95 deletions(-)

-- 
2.17.1

