Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998D318618D
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 03:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbgCPCdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 22:33:01 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55362 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729329AbgCPCdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 22:33:00 -0400
Received: by mail-pj1-f65.google.com with SMTP id mj6so7281149pjb.5;
        Sun, 15 Mar 2020 19:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LdMG7Y+xU0eu7euegCHI14a27CukttOQVa2zPD7qKFg=;
        b=qaD+nGz+4req7pisApL3TUgA0bDYUAFYBmMwL+17JsqmYhf05/TQgGkvVW5BleOaVN
         J/ArPj8zJhtN5OBrAcb/uch4u4bsxOR8JqLHkChDE0m25vx07AYeKrZFaF2O9GjiOWhg
         hfFwu9EFCbArdNKVZexcfOTlhp9/a/qBSUinhX/YSyraqkhfFulgcR7Pd5bCwR0pO28+
         nu73c/DvxBaxr/vmey0ww+UOL18TLJ3AFX3k/jonOGvydHwMpqQGER0OlZOKVN7jzFjA
         mgR+3Y7GiyGKn1ZGiFaXwHuPkpDMYNeR+WmKGPTHtRNQZ0BnbV03/ZGkSi0N4zqokKDG
         JtGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LdMG7Y+xU0eu7euegCHI14a27CukttOQVa2zPD7qKFg=;
        b=QEHQd+6zhUH1VGOJ8HCqWQy1Ii70+SziG8FUVB51ImjJouGi1TBjmHgcWVGkbz0ZdX
         vYyJm0ZbLbyXRPbfA4ryLUfEand4p2/e/fQ8t+0YJCMAQA08M9Wl6V42EzQw9fF6Zcz5
         b86Wb5UyySV1mZJNnoJrhcPQmUcHhy0fIxTemv3v0CRQn/QVXZ7KNHBmJR1z4lI/fMmU
         pU2KGscrt6T5u5yaTw9X1eiZ4wB7elEdatXPtL4Gf4LuT8DaRzJypMZcqaqSjFUXsEvp
         htvoypVpl9QCKih9NgbRlgGR2F4OQKNr74zLnRJQBuHukBjtVaV13/PjPB/W8YtEh3Bq
         0e2g==
X-Gm-Message-State: ANhLgQ3T8JujcMZlF+R5Hzxm6qNzL64u7B/wUftzzci1yXepClKT691O
        iz6gWiXuYA0H7+gh9YMM93Q=
X-Google-Smtp-Source: ADFU+vvefGbRI50sNUTTuCEtd9NhIpfisHMiyldT0aZLPmtS2/VO55W4NpqcF4zc7qkrvptmGtG9fw==
X-Received: by 2002:a17:902:b710:: with SMTP id d16mr22228351pls.293.1584325979094;
        Sun, 15 Mar 2020 19:32:59 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id l1sm14949598pje.9.2020.03.15.19.32.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 15 Mar 2020 19:32:58 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, andrew@lunn.ch
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v3 0/2] net: stmmac: Use readl_poll_timeout() to simplify the code
Date:   Mon, 16 Mar 2020 10:32:52 +0800
Message-Id: <20200316023254.13201-1-zhengdejin5@gmail.com>
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

v2 -> v3:
	- return whatever error code by readl_poll_timeout() returned.
v1 -> v2:
	- no changed. I am a newbie and sent this patch a month
	  ago (February 6th). So far, I have not received any comments or
	  suggestion. I think it may be lost somewhere in the world, so
	  resend it.

Dejin Zheng (2):
  net: stmmac: use readl_poll_timeout() function in init_systime()
  net: stmmac: use readl_poll_timeout() function in dwmac4_dma_reset()

 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c  | 15 ++++-----------
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 15 ++++-----------
 2 files changed, 8 insertions(+), 22 deletions(-)

-- 
2.25.0

