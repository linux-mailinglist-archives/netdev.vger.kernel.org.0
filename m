Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB183E04DC
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239517AbhHDPv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239214AbhHDPv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:51:57 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ACEC0613D5;
        Wed,  4 Aug 2021 08:51:43 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id m9so3100351ljp.7;
        Wed, 04 Aug 2021 08:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MFb0mtSBNfYCXWuLJ4WFezyMCJ+009tKgdeIKYVHYDk=;
        b=N5MxHxPzZWY/QQdU+75Q5PW5zVR2TFcqf3SAKpSTQqNyKbFjFMw3TO9XTHcYQsrrGX
         ejLL8A3e0ezvqhOrMQZcRUZVU8kGswjndweMy1CauCIsMmcKTZRD5haKOG9TU7M+p8Uu
         iQLoVM3Cd6ehlLMEl/T+CLltHCW9ATMuvwf0jNZHCGBKEJa2vHnpkwetUnYE++QF8sJn
         j7aLH3rAeN+WuKHqPTrkwyppMGOueXdWy/3KOelMTEpFmeikv7rzJA+ut0DtWwXiNcRz
         mTuheHVAYpdhfaFd4vtJXqx7ln6GnFFBnSyeT1sq5nzLrgTYxFg8v4u3P1xY/c5qk7xr
         m3cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MFb0mtSBNfYCXWuLJ4WFezyMCJ+009tKgdeIKYVHYDk=;
        b=hOYnNRdUAnGOsE3SMyBbyKYF8AUvrWhHFopKmhKBO/PRdHtiLIThxhxTzjcFy+J5Fk
         zvVOstHmZrK4w2zdI/xfTSG2AZh7vlJCBOSdF9wjEvggoPAppFitJl4TEcsYTTZuZydk
         ipISpzxut2et8PU/D8QKs6EPi3Yk8MSv5pN84747snUl3vBLaoCAWbqArHc0lSdaxAvk
         Okb6TQTwE01oMg/vIlNE/ty6cNTOoMKaVvoEj4h3LEYEikmQrLBr8Xz9veTjXjrDeHWK
         7S5xHfSNltJg3ASoI5dO4Ogxjk6IAf7BYby/XxxE+GcqqrQtRZesTHkylRCqnIrgD4MV
         okJQ==
X-Gm-Message-State: AOAM532J/3kKJJqeAiKvW9rK7ed9AWwAeoQL8WgiB9pYA4DkuNDNOLTh
        7Kpms02ZPz62oQnJ0Xt0p+0=
X-Google-Smtp-Source: ABdhPJyXyWLi2G16uEgpKXqO84/1hTJ/7A8rsSh+jBN3J+5RPvyZ7EaB8u95yq1b+5VzrcNUmoqr0w==
X-Received: by 2002:a05:651c:3c1:: with SMTP id f1mr107539ljp.82.1628092302185;
        Wed, 04 Aug 2021 08:51:42 -0700 (PDT)
Received: from localhost.localdomain ([94.103.226.235])
        by smtp.gmail.com with ESMTPSA id i21sm231641lfc.92.2021.08.04.08.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:51:41 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, qiangqing.zhang@nxp.com,
        hslester96@gmail.com, fugang.duan@nxp.com, jdmason@kudzu.us,
        jesse.brandeburg@intel.com, colin.king@canonical.com
Cc:     dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 0/2] net: fix use-after-free bugs
Date:   Wed,  4 Aug 2021 18:48:57 +0300
Message-Id: <cover.1628091954.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've added new checker to smatch yesterday. It warns about using
netdev_priv() pointer after free_{netdev,candev}() call. I hope, it will
get into next smatch release.

Some of the reported bugs are fixed and upstreamed already, but Dan ran new
smatch with allmodconfig and found 2 more. Big thanks to Dan for doing it,
because I totally forgot to do it.

Pavel Skripkin (2):
  net: fec: fix use-after-free in fec_drv_remove
  net: vxge: fix use-after-free in vxge_device_unregister

 drivers/net/ethernet/freescale/fec_main.c      | 2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.32.0

