Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D770432F5DE
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 23:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhCEWZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 17:25:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhCEWZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 17:25:31 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40051C06175F;
        Fri,  5 Mar 2021 14:25:31 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id m25so4173080oie.12;
        Fri, 05 Mar 2021 14:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=L9qw6y0f/4x5jeN7qjKB91j9vnd2pvN2mt/Fz923hAc=;
        b=OQwW3qpaGsQtYHWq4DWyzXqvytmy+j9AARX7JQoG4TD3uCeuMvGHra5SAp6Bg1eWWp
         v+bGKORuZAOaAoYiJbbtrj1k2nboBKWHGTdnx0tw1DtsUFh8biGydbojVjTgKgTL42t9
         EmUphAtirwIoMVSEG6ieznOLF0+VxB6Xh1N+3NvvopB7eS2N1FV+eUoVP83N9FOAwhl3
         DKnthKnnVw7ZTXGqA0ZfdWnMbyKnMhFpgIwrWokQr1tDoPzF1Br3dC9xnCFiJONokBDq
         8OqQug3+y/melLM34U2kDHD15NQmGpC9zK/ze/McDPX/ZOjaoen25WWw4ph6XZJxfc0i
         C/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=L9qw6y0f/4x5jeN7qjKB91j9vnd2pvN2mt/Fz923hAc=;
        b=Im5CmvMb5+ayOCaj1JOXifOFpeIffIfXSm3kC9tIeXAWPFtSb39FM9hX1PAPlkRGsz
         SXZzUk5tdIL3EuAzML/mSJU84IjgZGnhZ4B6RlLCytdevrs4sJFhR3C4xzW0t+8+GQ8F
         4wqM1BZS1ak4eM7rKhN++C2iUutNkhmREyKnzJJmx00AWD+lHo8v61xiQxjTOIN3c70Z
         jvuH9I1HNhzQrbI/PRwSSAPhIV0FZYSqC72vcfswpQFsERITiknZ6eZ6z/FZr8Ib3p+t
         qi9NDV9bDPOB13r7qnObCf+ht8uJ27C0AcMHOf+hR08NbEkByoMd4UEN+yyl9IVcV7Uf
         NW2w==
X-Gm-Message-State: AOAM532g/qN6Qv2DK4XOvezpNrIkogqzxQt/f31tUeGHKSF0kQQn2rbY
        s8+sXnSfBzVL0qIWlMVVBQ==
X-Google-Smtp-Source: ABdhPJzKVcWhqytnowZa454HbZWy50n5OEMjVHeW+jB3e2ifCYp376E/ATzhFGMDv3mtuGYtL0Or1Q==
X-Received: by 2002:aca:da83:: with SMTP id r125mr8805599oig.127.1614983130540;
        Fri, 05 Mar 2021 14:25:30 -0800 (PST)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id w3sm880768oti.71.2021.03.05.14.25.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Mar 2021 14:25:30 -0800 (PST)
From:   George McCollister <george.mccollister@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sven Van Asbroeck <thesven73@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net] lan743x: trim all 4 bytes of the FCS; not just 2
Date:   Fri,  5 Mar 2021 16:24:45 -0600
Message-Id: <20210305222445.19053-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trim all 4 bytes of the received FCS; not just 2 of them. Leaving 2
bytes of the FCS on the frame breaks DSA tailing tag drivers.

Fixes: a8db76d40e4d ("lan743x: boost performance on cpu archs w/o dma cache snooping")
Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 334e99ffe56f..360d16965a5c 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2040,7 +2040,7 @@ lan743x_rx_trim_skb(struct sk_buff *skb, int frame_length)
 		dev_kfree_skb_irq(skb);
 		return NULL;
 	}
-	frame_length = max_t(int, 0, frame_length - RX_HEAD_PADDING - 2);
+	frame_length = max_t(int, 0, frame_length - RX_HEAD_PADDING - 4);
 	if (skb->len > frame_length) {
 		skb->tail -= skb->len - frame_length;
 		skb->len = frame_length;
-- 
2.11.0

