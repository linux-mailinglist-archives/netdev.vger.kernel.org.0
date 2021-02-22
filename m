Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE7E320F37
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 02:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhBVBlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 20:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhBVBlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 20:41:50 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10595C061574;
        Sun, 21 Feb 2021 17:41:10 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id d2so7966295pjs.4;
        Sun, 21 Feb 2021 17:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TegYIsZ25A3LfiaM2DL4uTLW6gJgEq61GqpsbzZMT/0=;
        b=dhBEEzCyGqPYzotWWTEtpm3kjxZTRyWXnMzKUllUAGy1fhWGm81OoCtYgzW8iglxSL
         V8dO4/aUlMvqtQW5z2VvefXpuWXDStwd57WLpeupnteJPL0Bo4Gjhzb6NDxooA5uyrL0
         Z4wv0bWYiZ54tYpuCT/KdoMUeUdhZTG32P9BwuwOW3Gy9K96gobEBAadmcslhARHIDtB
         w2v5bofsWB0/zo/uHLsh2KQ/0puTg3vOFQW6RLOmtJR4zRw5SIGVU4MvE8l1SSqwiBh9
         JMI3Gw7aY0THAUE6MemaurQRPULJPmzFGbnJvSCcfOGoyE99tTqQOzbcxilwoL48IMKy
         HD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TegYIsZ25A3LfiaM2DL4uTLW6gJgEq61GqpsbzZMT/0=;
        b=qki/LW3aG6tBLL4HIlbChhwfntjQ/oph314hF89q82eCqBOsPZ+czLR7hyhyM2ucjQ
         Evm9eh3HNqR4BQ0OCoBJsOCr1XvQAu1jytubNxlth+S+xgKZ2PiMM6lSxsnQ2hluwUbG
         xaI3MFm7c4W5MNZpfgglTm2upZzm3davfed98cxSD8wm/ua61jKqx6d1ots5te7dmsLK
         dwTHWpmbFHm7hnShuSUS2xw03nX0dYHcodvphUa2JKPbYD2lKIVn1PfGgf59mq+QXqaO
         w3Iazr6CYP0G33ZIddIUKdS0NAt7Ah24ZdGntP4MM6AiCx35+KZwEkVu+BRm2SgFh1yT
         BKRg==
X-Gm-Message-State: AOAM533mJ1SruuzrdIkQ8j3TOZ7CtkdNJcsVVfvHC54u6rQ+UQjI9wAv
        VLKXO59wpyVzW51lyl24n64=
X-Google-Smtp-Source: ABdhPJyJyWHgbkAwBF8w6e/bGuXigU6gd3e7KbZXdva3kd4jt77ZXeCIW2ouoqiLjncEQOsnDVCjag==
X-Received: by 2002:a17:90b:1494:: with SMTP id js20mr3451181pjb.224.1613958069571;
        Sun, 21 Feb 2021 17:41:09 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([211.25.125.254])
        by smtp.gmail.com with ESMTPSA id z10sm4462062pjq.5.2021.02.21.17.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 17:41:09 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     chris.snook@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>
Subject: [PATCH net] atl1c: switch to napi_gro_receive
Date:   Mon, 22 Feb 2021 09:40:45 +0800
Message-Id: <20210222014045.1425-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changing to napi_gro_receive() improves efficiency significantly. Tested
on Intel Core2-based motherboards and iperf3.

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 3f65f2b370c5..3e440c2dc68a 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1851,7 +1851,7 @@ static void atl1c_clean_rx_irq(struct atl1c_adapter *adapter,
 			vlan = le16_to_cpu(vlan);
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan);
 		}
-		netif_receive_skb(skb);
+		napi_gro_receive(&adapter->napi, skb);
 
 		(*work_done)++;
 		count++;
-- 
2.17.1

