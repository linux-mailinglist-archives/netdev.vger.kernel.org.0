Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC247427EA6
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 06:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhJJEFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 00:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhJJEFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 00:05:37 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BF8C061570
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 21:03:39 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id k26so11699520pfi.5
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 21:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FT2PvAk/XkrQLx6DnHqvOn73k8uYvFY8jqSoZ1X+yyA=;
        b=ABKeSlJR/VXESQrZBSKadcEyuo8rVFIEKjZSLH4jBv705uzylCdRCgc+X01T09yAY5
         3fnHKlYwj7OYvGfHg3cH/Ws8ZIS95hwba+OGr+76NyaTO60DIYFZGlAfknKEPpKLJXNf
         Awk3i4Ri0kazlt0bKCQ3Ejd+GQPk/3jaV6HKtWpamkxKQA1WBpx4TbEtjdYz22YLMxtl
         Sx9S3rPlkuExIfGYOIxnrCY97G+2zvFmvpcJde2R9qRUjrUIVaQ3c4xlyKCWhze/Q05W
         W3dKTJuKHnEA7vbbYyfpNDahH9zJmX0UyM+Eb2JBgp3lBBVFlFY7GGPvOrGkzls1FL4S
         2o9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FT2PvAk/XkrQLx6DnHqvOn73k8uYvFY8jqSoZ1X+yyA=;
        b=CCRITfD+3xui5TCi9+kT66W+vV+60yh+DJ19aJdjTTAsrBJi8BlXkNos8tc5AKG7Ue
         4qKpxjNHx33p3/3PyLzpy/c+JXcOJMlG9lXvrzgcuiNepQ3sL4fFXg0Ee6B6H2apslVK
         zyQIDFy9DWvUsCsDao3xQmhXveASvCywPQDaoOxcCSHE2G0focfy7hA8/9kaadYStb6Y
         P16KT3lKZA2w+m2DZFVOn1pthBBjEmUXIBZcdeZvNznOzvT7xww0c6/KvgBf8h3v7781
         quf39DmhTN+Yps6fKeTIip4MYmmDR+K9TOwMOnTw+DNt3zjiESmUgy6FM7m8+66eUWo8
         2UkA==
X-Gm-Message-State: AOAM530PYWozsHr9E96nPLFvhR7CPoErtV4Gf+ZWfmBurkQeLs06T35o
        38JFU1ptV13dyiB4wsFi7Cc=
X-Google-Smtp-Source: ABdhPJzVNNeg05YW/rxO9NUEre3Y4jTFAJGu869HbdB94cfJ6i8KenbTEe6ET0qaTdOLU+OIW6wL0g==
X-Received: by 2002:a63:e64a:: with SMTP id p10mr12541125pgj.263.1633838617781;
        Sat, 09 Oct 2021 21:03:37 -0700 (PDT)
Received: from localhost.localdomain ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id m6sm3507763pff.189.2021.10.09.21.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 21:03:37 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     michael.chan@broadcom.com, davem@davemloft.net, kuba@kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] net-next: replace open code with helper functions
Date:   Sun, 10 Oct 2021 13:03:26 +0900
Message-Id: <20211010040329.1078-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there are many helper functions on netdevice.h. However, 
some code doesn't use the helper functions and remains open code. 
So this patchset replaces open code with an appropriate helper function.

First patch modifies to use netif_is_rxfh_configured instead of 
dev->priv_flags & IFF_RXFH_CONFIGURED.
Second patch replaces open code with netif_is_bond_master.
Last patch substitutes netif_is_macsec() for dev->priv_flags & IFF_MACSEC.

Juhee Kang (3):
  bnxt: use netif_is_rxfh_configured instead of open code
  hv_netvsc: use netif_is_bond_master() instead of open code
  mlxsw: spectrum: use netif_is_macsec() instead of open code

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 drivers/net/hyperv/netvsc_drv.c                   | 3 +--
 include/linux/netdevice.h                         | 2 +-
 4 files changed, 4 insertions(+), 5 deletions(-)

-- 
2.25.1

