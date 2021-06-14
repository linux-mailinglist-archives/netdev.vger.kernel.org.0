Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160AF3A5B8E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 04:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhFNC13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 22:27:29 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:37740 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbhFNC11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 22:27:27 -0400
Received: by mail-ed1-f49.google.com with SMTP id b11so44416758edy.4;
        Sun, 13 Jun 2021 19:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eYvGHjDCuADljb2rO2hqe2W6UV06jWEIjTXex3m2bhA=;
        b=PQX9yYVQvnz5dq179dkPQmpGdFd3ItqDA1jcKzBU8MIvy0EtETm0nrNvjbz4rZ7PGe
         cqOdt6U/gefLe41c0KzC94UOoiB7/yItRgYwvTE8d3K55OMoWONRX6tuxDgNkLSQM8ws
         d2pWjUF7JiZT6acwXgAPIDYDHvBgBKqNaaBdQhhmYT2IL1zyRXiQFS0Tbtlfa/XP0YyS
         ZJZ3PWC1WnwChA1solrT6nTuXwd1Z/Cyb5anzrBaIq2SV61+1nd9jE/DC8GuaolPjnvO
         e30x6+qEtQHTDFvXI4MFFqLW+RaBcXnKKX3FNfAhhNe3SUK13eSxMNoj2gZRd7ncNpkB
         PCvg==
X-Gm-Message-State: AOAM533yMk/P5APA/pvDkcEcKX/l33DO5d7jv+KT47gGxZQC/GhWXLyi
        wiG/00x/YvhDCtMOIdQAa+WDSIKj4QI=
X-Google-Smtp-Source: ABdhPJz5Qf30YVGRpepkKqj0PbwpcLmyuUi6u4xZAFZbFSFqAwbCycSGOGuaj9rxmuwf+p8ksRXqHw==
X-Received: by 2002:aa7:ce03:: with SMTP id d3mr14552830edv.360.1623637512333;
        Sun, 13 Jun 2021 19:25:12 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-37-119-128-179.cust.vodafonedsl.it. [37.119.128.179])
        by smtp.gmail.com with ESMTPSA id f18sm2768255edu.5.2021.06.13.19.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 19:25:11 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Drew Fustini <drew@beagleboard.org>,
        Emil Renner Berthing <kernel@esmil.dk>
Subject: [PATCH net-next] stmmac: align RX buffers
Date:   Mon, 14 Jun 2021 04:25:04 +0200
Message-Id: <20210614022504.24458-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

On RX an SKB is allocated and the received buffer is copied into it.
But on some architectures, the memcpy() needs the source and destination
buffers to have the same alignment to be efficient.

This is not our case, because SKB data pointer is misaligned by two bytes
to compensate the ethernet header.

Align the RX buffer the same way as the SKB one, so the copy is faster.
An iperf3 RX test gives a decent improvement on a RISC-V machine:

before:
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   733 MBytes   615 Mbits/sec   88             sender
[  5]   0.00-10.01  sec   730 MBytes   612 Mbits/sec                  receiver

after:
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.10 GBytes   942 Mbits/sec    0             sender
[  5]   0.00-10.00  sec  1.09 GBytes   940 Mbits/sec                  receiver

And the memcpy() overhead during the RX drops dramatically.

before:
Overhead  Shared O  Symbol
  43.35%  [kernel]  [k] memcpy
  33.77%  [kernel]  [k] __asm_copy_to_user
   3.64%  [kernel]  [k] sifive_l2_flush64_range

after:
Overhead  Shared O  Symbol
  45.40%  [kernel]  [k] __asm_copy_to_user
  28.09%  [kernel]  [k] memcpy
   4.27%  [kernel]  [k] sifive_l2_flush64_range

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index b6cd43eda7ac..04bdb3950d63 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -338,9 +338,9 @@ static inline bool stmmac_xdp_is_enabled(struct stmmac_priv *priv)
 static inline unsigned int stmmac_rx_offset(struct stmmac_priv *priv)
 {
 	if (stmmac_xdp_is_enabled(priv))
-		return XDP_PACKET_HEADROOM;
+		return XDP_PACKET_HEADROOM + NET_IP_ALIGN;
 
-	return 0;
+	return NET_SKB_PAD + NET_IP_ALIGN;
 }
 
 void stmmac_disable_rx_queue(struct stmmac_priv *priv, u32 queue);
-- 
2.31.1

