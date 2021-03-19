Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291BE3413FC
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 05:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhCSEFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 00:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhCSEF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 00:05:28 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FD1C06174A;
        Thu, 18 Mar 2021 21:05:25 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id u19so2820485pgh.10;
        Thu, 18 Mar 2021 21:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OI5efL3P1EfDwff82tITyKNz1NYqRpMkwQHhw6FWFKo=;
        b=K62zUapxlZOSghari5mFxkSKFIO2dAtMQz1/G0M8F21e9CdGoi7F2hFxL+lP2xPIpt
         ShGYVW8+oivXTUc3o89cvkI/Ugq4WD+CntpSQsIL4LyAwOxXjSLorMAgQkQ3SMQqgXWd
         tMdxX1qOgXzY5drM7NFbE51ktolgcfPDlBwUKyMH8QM/9lPtxOHr6oolY1ywsN4DpyNA
         6tbwQbbX48yKTn7G2Aax/wXp9SwRtn2J6BYSBfJNAKZo2mEn37wRFd+oOVeJrARSUpyk
         9ybWxmvsuCWVqmxHnn4gIteLraV/waZJkmLjObbXGGncvPD5eeG1Di1tRj2w5NHApu+2
         ECsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OI5efL3P1EfDwff82tITyKNz1NYqRpMkwQHhw6FWFKo=;
        b=SbXA2xNSjUFnJblYj5NEzwtiAwppIGikXMygfTfOJG8ittkVrsWC/YMhhsuEB7TbYf
         FN5nbksNd96Mr9/VtFiJ2YQuSiaPrg9T/P4a5aFThMEDbTRPc7uICF2qZEgeXozCBhH8
         18T8IybxsCQ4kKTuxwOeZonGBxBuLv4CPGKdo4Fl6nC4Mpx+F1j9tsDvbA5Rsx1uMjSo
         /vLaI3a6COd0Qv17sMZ5hZsv5psXwuDecpVPyUQEazg5XrAzmg9BjobH9W/tgfxRNqT0
         1RceZk7H2IQy6W9rsALvSHmhLieKqkFIilhtsvCK25/ODDTMOnCab3zeHBcKCRnaflBO
         9How==
X-Gm-Message-State: AOAM531ShdW2g5x73GcBYEx5MgaI1XuwA2m7uf/ea67MyKNgzzygrjuy
        nV0CIVNCYpmRty2ucWVjSgTs/YyuaUg=
X-Google-Smtp-Source: ABdhPJwybfpscksrpd84ET8QUZDSJdLZgx7QVvIK5D5AVQHc5k3QnnpWGNBeSgLWyOkSgZZNjego3w==
X-Received: by 2002:a63:2152:: with SMTP id s18mr2640087pgm.190.1616126725273;
        Thu, 18 Mar 2021 21:05:25 -0700 (PDT)
Received: from DESKTOP-8REGVGF.localdomain ([115.164.184.3])
        by smtp.gmail.com with ESMTPSA id i1sm3854732pfo.160.2021.03.18.21.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 21:05:25 -0700 (PDT)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     chris.snook@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>
Subject: [PATCH] atl1c: optimize rx loop
Date:   Fri, 19 Mar 2021 12:04:47 +0800
Message-Id: <20210319040447.527-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove this trivial bit of inefficiency from the rx receive loop,
results in increase of a few Mbps in iperf3. Tested on Intel Core2
platform.

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 3f65f2b370c5..b995f9a0479c 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -1796,9 +1796,7 @@ static void atl1c_clean_rx_irq(struct atl1c_adapter *adapter,
 	struct atl1c_recv_ret_status *rrs;
 	struct atl1c_buffer *buffer_info;
 
-	while (1) {
-		if (*work_done >= work_to_do)
-			break;
+	while (*work_done < work_to_do) {
 		rrs = ATL1C_RRD_DESC(rrd_ring, rrd_ring->next_to_clean);
 		if (likely(RRS_RXD_IS_VALID(rrs->word3))) {
 			rfd_num = (rrs->word0 >> RRS_RX_RFD_CNT_SHIFT) &
-- 
2.17.1

