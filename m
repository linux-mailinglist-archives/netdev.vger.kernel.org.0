Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8DC3D401F
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 20:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhGWRWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 13:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhGWRWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 13:22:25 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9076C061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:02:58 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d17so3930342plh.10
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 11:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=l//IZdXbqqUgW+m9qbEoUty4dz6Y6I0o7p3mB+V/2/o=;
        b=KSBzH1hmpInO4ws6i7/R+x8HQeQQuN6rNmMZkP1iQF5X4StpNHV8sBfsDUNFYVNhgm
         Yx1v+1yaVbMu6aK0MZBoioPzXCL+WJgcQcgNzm1His+8ch5q8HCuplz/fjUVmzJsRHxK
         g7MikmhEv0mAB3rVFF5ur0L2JiXqwvnB/w/iGrn6HvxXiPi5J3gvYSczXejRr/ckaZqy
         ir2peBTgOCWPmB6y4536HAHAcsD/EIqgLIQCwL9Y8h3T8COOC4Hv2Cy2sgYDnY2yjNcf
         qMCmEcGCyVQ1AxPM8sC1Xq5lv2IF9JcQN9ZveJGEwuqtXiaDewz/0VwaRQzaruBGeCbq
         863w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l//IZdXbqqUgW+m9qbEoUty4dz6Y6I0o7p3mB+V/2/o=;
        b=Bk9fxRk9JV1oJt5yYGLRLo2Zh+wx8JxAD5MOENxt5F8H2rId1U5HpnKjjv7SE8jxNK
         t+DzbmKVwcdZwq3cHBk/F2NnPG16BZQM7QsfnyNXmRhhnfXyRKpakY+E7I2Y5UTq1sG0
         +wlDBeZ0eZLL1eAtVF2eDd1sMt2AXkx8LU5Yf694aF2fsLFCVqq5+UANoGH998fpijg9
         DKZ13ieuB7frskUiL3tHDUTdLk7TuYKkHhRxlTahItxSU+6FdkaRORYLrjm7jeSp+Wwn
         B7wRLAOm+pa6KcgLzq55VosKDjOZ8NcEFRrE7gPWYAYLlzhOrhx+WHFpga/GnLvQZABH
         YoWA==
X-Gm-Message-State: AOAM530xpPvoonaWhfbrZrZl9+8Qdq5pazJPwvdKT7iocqPVE2uggwWF
        oDOvp9D2xF0hcLWtVotpwSLU0w==
X-Google-Smtp-Source: ABdhPJyLLfT5qr/3dF7KweKcc+5fu9Ar+yBCYuJr2RLU1s4nVG1kwpcUSy8BF5QM7dLasjNFnb6Zmg==
X-Received: by 2002:aa7:9a07:0:b029:329:46d2:c6e4 with SMTP id w7-20020aa79a070000b029032946d2c6e4mr5656784pfj.81.1627063378230;
        Fri, 23 Jul 2021 11:02:58 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c23sm19437934pfo.174.2021.07.23.11.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 11:02:57 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 0/5] ionic: bug fixes
Date:   Fri, 23 Jul 2021 11:02:44 -0700
Message-Id: <20210723180249.57599-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a thread race in rx_mode, remove unnecessary log message,
fix dynamic coalescing issues, and count all csum_none cases.

Shannon Nelson (5):
  ionic: make all rx_mode work threadsafe
  ionic: catch no ptp support earlier
  ionic: remove intr coalesce update from napi
  ionic: fix up dim accounting for tx and rx
  ionic: count csum_none when offload enabled

 .../net/ethernet/pensando/ionic/ionic_lif.c   | 197 +++++++++---------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  11 +-
 .../net/ethernet/pensando/ionic/ionic_phc.c   |  10 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  41 ++--
 4 files changed, 132 insertions(+), 127 deletions(-)

-- 
2.17.1

