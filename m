Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62B44185E8
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 05:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhIZDXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 23:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbhIZDXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 23:23:00 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407C8C061570;
        Sat, 25 Sep 2021 20:21:25 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id k17so12453026pff.8;
        Sat, 25 Sep 2021 20:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JRqyf3B66XeAhUqakwcv2FRFo/oowQBy0SeUGcDW+Qk=;
        b=K+RQ9HFFHe1nITI7EDxCYpkXA/W3FBMlb+5E5LgqaDMrsdkyu9+pxRJr3h6FT4hFDb
         HfmWYlF/vhv9/hMZHbQIKzpcKIiM/m4+nNgs48qJkEXJHvrHvrNffLFbk5nzyzhTjo+3
         SNo5aW51aJI0UAU6z1VBIbK2jh7G9bQ7xRTp8P8pm3TuKTrmdcyyc5KFfyMpp8CSQGt5
         fGHkv0b1RzJ8LMLoc94lGPt6MFVtXbpI6yc35YVuSoLkBjLeEFDtzIyLal48K+h9z79F
         c1hXVzFdWiz8K58rYKYswen7bC+DZILQndVNaiFMVwtNpORTk0ytNzjoYBEcE0CU2T/z
         V20w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JRqyf3B66XeAhUqakwcv2FRFo/oowQBy0SeUGcDW+Qk=;
        b=F7L8ZnOw2TpYdloQeQoXKS7Sd3ODOKpyf87S5MhCpOsA7m5ybqeVPQ2qC/jexFzVaH
         glEbJVbErtZWDkN185Lj6wq+CUz8K1B22E8M3k06GWvXNCUkyBMecEm45jkXnzVNPodp
         7IYYgorGM+ZCb1tgGveR/gkk1M4ciwNiwuU9vqmeLhRs2f8RT5nsu2TPaMASc8I8NXZz
         XrDWraBAa8XBlKJk6rw8i56yQiPqbCd1TM6ddlTG/mR6h817Vclypx8SnC+0JFb2S4Sq
         e93Kb/7HfH9lB7Lw61onUxPLLPy6utykCCbvSJN4CVMsRlrlTX8Pw6SnsNVgr8a210d/
         u2SQ==
X-Gm-Message-State: AOAM531p+a2mKtKCuy4d19gzGaRlMHWm99ipE5n609yKzQjqC8jAlNVg
        RbkdkgPEm1VfGBorXtd1RKr23kH7IxQ=
X-Google-Smtp-Source: ABdhPJwy7PFJzX5k1hWzMRF3L8kXbaabvPU8xWGqfYD++XAqskRdVQfVyWuPcQQUE1yxj8XfGlOnxQ==
X-Received: by 2002:a63:595f:: with SMTP id j31mr10726473pgm.109.1632626484266;
        Sat, 25 Sep 2021 20:21:24 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r13sm14205312pgl.90.2021.09.25.20.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 20:21:23 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 0/4] net: bcmgenet: support for flow control
Date:   Sat, 25 Sep 2021 20:21:10 -0700
Message-Id: <20210926032114.1785872-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for flow control to the GENET driver, the
first 2 patches remove superfluous code, the 3rd one does re-organize
code a little bit and the 4th one ads the support for flow control
proper.

Doug Berger (4):
  net: bcmgenet: remove netif_carrier_off from adjust_link
  net: bcmgenet: remove old link state values
  net: bcmgenet: pull mac_config from adjust_link
  net: bcmgenet: add support for ethtool flow control

 .../net/ethernet/broadcom/genet/bcmgenet.c    |  56 ++++++-
 .../net/ethernet/broadcom/genet/bcmgenet.h    |   8 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c  | 155 +++++++++---------
 3 files changed, 130 insertions(+), 89 deletions(-)

-- 
2.25.1

