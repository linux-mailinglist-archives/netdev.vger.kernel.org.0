Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2467DC8C14
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 16:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfJBOxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 10:53:03 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40509 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfJBOxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 10:53:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id l3so20012255wru.7;
        Wed, 02 Oct 2019 07:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o23+/YYDG+Ee+Qyr+92wFjfClhStyHjFn2X5WQR18MQ=;
        b=p7FbiuEr/6KYe6o5t0uYYu2oOszZw3U6UaipfErabCO4Mk4HoqAYfUr/Aw8kURcqo8
         aUBKYIUORkIOl7Gf19j0guczJvBUNXxRnZqSvnWX6hAw+7Glocbe4zN7X0jSTVUZ4aXJ
         AqXa6BUeykDdpl9drjp8mJP0lyCvSPLjjMnZJl1+FlAH0jjdZR2Lha3upICWkoXzW9rL
         cKr483ckbk85ZUxfgi/fbA1XgAF2zfZB1ulmiDPwdGZxdZkxvCPoHpg+HP5HhO8RUUcW
         YF7Tq3v/AfdVvPBdTZGnsH/r8XvEDNBhpN4GGcrCB+ZA5PunACxof9sPobgWIcqZya+A
         1VQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o23+/YYDG+Ee+Qyr+92wFjfClhStyHjFn2X5WQR18MQ=;
        b=in1nwVEay+tCvZrvFrmKW8OKRn2yUhlhWoo0Qsn1G/9A6hF6UEzBx7rtgtJ75KZnHs
         kmufKF9+mGwwES0y6WOpMk298jZtbK0hszv2Jvb840qD6tVpoDktz7qS2vGFSwCN28DK
         h2ttq3Z/nA8BsaGKvx3nlgADNFf02nEpjZ8pNsN1vfuDljQySIa0++GKrixfgWU6nBqi
         DDQJ6+2cNp5kIDubKuUXJVGqfY/yXmqEpLc+ZWcMAtC8WqJGdBEo/lSqF8l7lwKu3l+Z
         2SJ6EnytllbvvTypgh9L1dr4B68ZFN+OELtX8QcVrJw3rhB8oUFrdx1x7jruae0q47Qm
         uGiQ==
X-Gm-Message-State: APjAAAWWocLCNZepn07GJWqZyvoCg+htbiEwNFvtFVVfi0sijo3Gjwi9
        43ZjJ8eY122mh5RspVWPS2U=
X-Google-Smtp-Source: APXvYqzezIkpoenxsuvp6FSTFMFoGl/rwDreLXMCTo33EVvYDZznWrxPr/56cJXb4sioCTHnLkyABg==
X-Received: by 2002:a5d:4f0b:: with SMTP id c11mr3069557wru.63.1570027981072;
        Wed, 02 Oct 2019 07:53:01 -0700 (PDT)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id f143sm13685946wme.40.2019.10.02.07.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 07:52:59 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH net-next v4 0/2] net: stmmac: Enhanced addressing mode for DWMAC 4.10
Date:   Wed,  2 Oct 2019 16:52:56 +0200
Message-Id: <20191002145258.178745-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The DWMAC 4.10 supports the same enhanced addressing mode as later
generations. Parse this capability from the hardware feature registers
and set the EAME (Enhanced Addressing Mode Enable) bit when necessary.

Thierry

Thierry Reding (2):
  net: stmmac: Only enable enhanced addressing mode when needed
  net: stmmac: Support enhanced addressing mode for DWMAC 4.10

 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  1 +
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  4 +--
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 28 +++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  3 ++
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |  5 +++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  7 +++++
 include/linux/stmmac.h                        |  1 +
 7 files changed, 46 insertions(+), 3 deletions(-)

-- 
2.23.0

