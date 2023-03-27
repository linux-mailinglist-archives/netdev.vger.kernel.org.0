Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573F66CA8B4
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 17:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbjC0PMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 11:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjC0PMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 11:12:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C29E2D75
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 08:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679929919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DYh+IUQKnsNavgY4j1iAAQrUA1J5asaTGD0FKGxhaXM=;
        b=epmD2FzYSyYo/E9Sl84B1VYDL+AM5VqxkNexV6a2364V7vDLroYyqJDhBo99NrcHJ8p1RA
        SKMoM9YuMWks+Ro+FQXXhai9pZGaIQw7dKWw6LQqGika28/WAvkhS6qrSH8LXFFmze1BQs
        jaHDzt9lGawqWyuN6ksOJceItPbwUC8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-lBljx-QrO52bWSsqzOomRQ-1; Mon, 27 Mar 2023 11:11:56 -0400
X-MC-Unique: lBljx-QrO52bWSsqzOomRQ-1
Received: by mail-qv1-f71.google.com with SMTP id r4-20020ad44044000000b005ad0ce58902so3654059qvp.5
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 08:11:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679929915;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DYh+IUQKnsNavgY4j1iAAQrUA1J5asaTGD0FKGxhaXM=;
        b=UaCvZju72Mpkkd0vJKbevYnikv3b7Xxnw5Cj1cwWgj9csGwm43MUvCknSAUQ8aoEGE
         K9bBe6jb3kYEFopded+Beywk/YSahEgW+AjvlWTsWfJIYzgWeAtxlvL6vS/nBSXAnajE
         PMI2OFmemowRlu1Krf0HDkyUX/wumm5VkNXMfBOnOOHqcVa3AOxyhK2dfdZS5t0mY5yl
         lVO3oe+Ae0hxh0X0FTxeOL/iDpismrth52IRLc5+M7l7EO6psapp4IzlTVFHAax0l1H2
         QrPq7EylMBj5jYkUYTKailZfsXv14gjb1hCWaWdHR+X7WyY1hqm+Mc6010+pZGhVc3ef
         QBNw==
X-Gm-Message-State: AO0yUKVrvKl5JXFs60XnKeo8cvC3TX8I8awGMt12koluTUADZ0A/uCB3
        c6OEf51IcxAKoB0GQ9uEeFs/Ncje5E6NbxxvWx5qv6MO/TCcY7Xq3pqjEpBI0j44J5mVKe3hMG9
        yS99dJxJVl4WdcLOd
X-Received: by 2002:ac8:57c2:0:b0:3e1:6c7e:2ee0 with SMTP id w2-20020ac857c2000000b003e16c7e2ee0mr22110174qta.11.1679929915681;
        Mon, 27 Mar 2023 08:11:55 -0700 (PDT)
X-Google-Smtp-Source: AK7set9BAzNnvmMx3UPAztYRtfcEZS/JC0Zbgk59lkyKNRW1O3h/77E7anPa59QcSLU+bg9VrGKy2w==
X-Received: by 2002:ac8:57c2:0:b0:3e1:6c7e:2ee0 with SMTP id w2-20020ac857c2000000b003e16c7e2ee0mr22110133qta.11.1679929915395;
        Mon, 27 Mar 2023 08:11:55 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id l6-20020ac848c6000000b003bfb0ea8094sm8328255qtr.83.2023.03.27.08.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 08:11:55 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] brcmsmac: ampdu: remove unused suc_mpdu variable
Date:   Mon, 27 Mar 2023 11:11:51 -0400
Message-Id: <20230327151151.1771350-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang with W=1 reports
drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c:848:5: error: variable
  'suc_mpdu' set but not used [-Werror,-Wunused-but-set-variable]
        u8 suc_mpdu = 0, tot_mpdu = 0;
           ^
This variable is not used so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
index 2631eb7569eb..e24228e60027 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
@@ -845,7 +845,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	u16 seq, start_seq = 0, bindex, index, mcl;
 	u8 mcs = 0;
 	bool ba_recd = false, ack_recd = false;
-	u8 suc_mpdu = 0, tot_mpdu = 0;
+	u8 tot_mpdu = 0;
 	uint supr_status;
 	bool retry = true;
 	u16 mimoantsel = 0;
@@ -975,7 +975,6 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw,
 							    p);
 				ack_recd = true;
-				suc_mpdu++;
 			}
 		}
 		/* either retransmit or send bar if ack not recd */
-- 
2.27.0

