Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2482EBFC6
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 15:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbhAFOnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbhAFOnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 09:43:51 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2D2C061357;
        Wed,  6 Jan 2021 06:43:10 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id t6so1657835plq.1;
        Wed, 06 Jan 2021 06:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DLIKv+eKqqnnvu0p4iHlq0fOrM6uv27Uln7K79Hro0M=;
        b=uiSP9hGYOQFHTMx2LJhB8wakxyazQ0N7BARXxgMXa/eqAaUsBh4rNRf2I+8Ed+4k/z
         k3v5u53mzE9po6FW8zN2C3OxzPkNZfNNyzZO62tIhDxX1yOMMH1qFv/iSjp3lvP7wAQ4
         GuY2CtazcpllP6cE9NR1XIH/HYdV4iLQVb0dlakXSAQm+Gb1NZ+ox8MIXCuw/18icrlg
         nUkqX31GlG7+8qGAPjqKeWIxhxu5F2iPIvlf/yPzefaE8GkP32qwMX/JX0D4ysBrp0sJ
         Sm+Wv6y+yyawAGAftTXSDy+tVo1np3ItwPUMXRYOc/yO1gvpmFgXFeku8PrcIO1FuiND
         8Hmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DLIKv+eKqqnnvu0p4iHlq0fOrM6uv27Uln7K79Hro0M=;
        b=kU4c1RFVT3nLb8nAe5KMYgVRHlSvcxAw9ok5CQrKF87cd63X53XPpbWngwHhHdJTCe
         NGJQvq3E9bj0lP/wOD3mU4ZNQaat49XnmMZECPu4lTCWT5v8hQqNDrROVuXi6O7hkTaU
         HXSyGwMxxqWMuWmB3n67vF11zH07sg2/T5Si/+t5LhetL1BK3n41hxWVmDPxc3leLBXb
         5dMGqNIEXcSLrvLoJ1aLVS1XcPlHO1nrNAbcW4p/rwFt7PRLfIE/FfB37nCgt4a5w9eJ
         6ItgPqAzGoVbW+CneGwD58/jxk+dPp0+m5sS73+o8tbkaW7uSWVJorGsLofPt5xLiSwY
         s94Q==
X-Gm-Message-State: AOAM5338qE8iydNXny5LQ53HMSRhyBoinuhU/C6Ubh0mDTTdAkchM2o9
        7DuPK9DIbTnvlpk/x39ZkRE=
X-Google-Smtp-Source: ABdhPJx6RTMFF8vqnv7T1nx8vdqu2vLJRI/lNPACmVDaa9S+5Un46N3oWlvgzOO1Ns3971p+SOOhsg==
X-Received: by 2002:a17:90b:f16:: with SMTP id br22mr4529371pjb.221.1609944190036;
        Wed, 06 Jan 2021 06:43:10 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id h8sm3076774pjc.2.2021.01.06.06.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 06:43:09 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 0/7] bcm63xx_enet: major makeover of driver
Date:   Wed,  6 Jan 2021 22:42:01 +0800
Message-Id: <20210106144208.1935-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series aim to improve the bcm63xx_enet driver by integrating the
latest networking features, i.e. batched rx processing, BQL, build_skb,
etc.

The newer enetsw SoCs are found to be able to do unaligned rx DMA by adding
NET_IP_ALIGN padding which, combined with these patches, improved packet
processing performance by ~50% on BCM6328.

Older non-enetsw SoCs still benefit mainly from rx batching. Performance
improvement of ~30% is observed on BCM6333.

The BCM63xx SoCs are designed for routers. As such, having BQL is
beneficial as well as trivial to add.

v3:
* Simplify xmit_more patch by not moving around the code needlessly.
* Fix indentation in xmit_more patch.
* Fix indentation in build_skb patch.
* Split rx ring cleanup patch from build_skb patch and precede build_skb
  patch for better understanding, as suggested by Florian Fainelli.

v2:
* Add xmit_more support and rx loop improvisation patches.
* Moved BQL netdev_reset_queue() to bcm_enet_stop()/bcm_enetsw_stop()
  functions as suggested by Florian Fainelli.
* Improved commit messages.

Sieng Piaw Liew (7):
  bcm63xx_enet: batch process rx path
  bcm63xx_enet: add BQL support
  bcm63xx_enet: add xmit_more support
  bcm63xx_enet: alloc rx skb with NET_IP_ALIGN
  bcm63xx_enet: consolidate rx SKB ring cleanup code
  bcm63xx_enet: convert to build_skb
  bcm63xx_enet: improve rx loop

 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 186 +++++++++----------
 drivers/net/ethernet/broadcom/bcm63xx_enet.h |  14 +-
 2 files changed, 103 insertions(+), 97 deletions(-)

-- 
2.17.1

