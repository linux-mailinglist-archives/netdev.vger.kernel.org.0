Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C809185DB9
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 16:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgCOPDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 11:03:07 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37649 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728310AbgCOPDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 11:03:07 -0400
Received: by mail-pf1-f196.google.com with SMTP id 3so495851pff.4;
        Sun, 15 Mar 2020 08:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kc0ThdNzpJn+Kfcg/RI1G+X6IBpfBw1q8Ln/bdPz3gg=;
        b=gun4vQCyYWP1bqzzwNKXuuKF29zaiHKnVk83U9ZMhT/rCB7hAm6a8Cdj6qI1V3e4IV
         /Rc7jjUJVxlSRNl/AwxR+g2q3fzUzLVCP2EOb8tHLoG3V8WBY8fg2EGbLABKxuLHV2q1
         PiOUTheCzjMuRt2W6lhsPgXp6r7UDlhK2w73y5XXMnBK86ZlVt2aa933ie9R5UyvC7ty
         p8wqaaMYQc7ACTMv2TzR/043Gd8/OfEcmi+dvCTZR5zobaN2Kb9/xvv4umxfhiiUfXhx
         ADRo2NteR1DfuarrFYR/q/mXLAKF3UA0UMXwsQKBlb85Axs7z7mJYll4R2ierDo8TfzS
         3Img==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kc0ThdNzpJn+Kfcg/RI1G+X6IBpfBw1q8Ln/bdPz3gg=;
        b=L/z2Ho35OK4sWT6B/rx1/eNVDGiNvZmTuRPEKWdg8uNTG9Kf4/Stp4EnHJRp7Pz6uk
         KhuBfPMg7vLdz9tQSl0YG36A8fsOBnfIr8whcj1BWZTm+rkuIXl9E5SSHavpqebhpmzT
         LOV3dVLhWUUSQb1qVx0jvnW1IPXysYb24G9/v3mGDlMyW0H0OgHhSRFfa7RLYwtsFaXN
         keoIPw9XW5LiIlgRDey1KRVFIRjw+p94kHX+6ozIBXbl2lruW6NqZkVjHD2Y1/KMdxMw
         smcYKFvskj3AQStLHdMvDa2zE6GYCgRLP8DmWsu9X8Z7CYIvCQP9C8JoawVT81yc1y4n
         Fr8Q==
X-Gm-Message-State: ANhLgQ0f98a2VsS/fdpS6oBuxQq1PcZv6rnrpgeSGP6TeG7RKtRuyyTf
        7yI1c9bX6pyQvNYCciavSr0=
X-Google-Smtp-Source: ADFU+vtgzU9quN1fDPCbfmM0oAkAxz6+u3OVdKrZFBtlqzFobCSi93pYCDNldrZGFZPFHgHvfmczRA==
X-Received: by 2002:a63:cb4a:: with SMTP id m10mr22706434pgi.259.1584284586339;
        Sun, 15 Mar 2020 08:03:06 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id y9sm17201060pjj.17.2020.03.15.08.03.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 15 Mar 2020 08:03:05 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v2 0/2] net: stmmac: Use readl_poll_timeout() to simplify the code
Date:   Sun, 15 Mar 2020 23:02:59 +0800
Message-Id: <20200315150301.32129-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sets just for replace the open-coded loop to the
readl_poll_timeout() helper macro for simplify the code in
stmmac driver.

v1 -> v2:
	- no changed. I am a newbie and sent this patch a month
	  ago (February 6th). So far, I have not received any comments or
	  suggestion. I think it may be lost somewhere in the world, so
	  resend it.

Dejin Zheng (2):
  net: stmmac: use readl_poll_timeout() function in init_systime()
  net: stmmac: use readl_poll_timeout() function in dwmac4_dma_reset()

 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   | 14 ++++++--------
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  | 14 ++++++--------
 2 files changed, 12 insertions(+), 16 deletions(-)

-- 
2.25.0

