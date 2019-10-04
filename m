Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A32CBCB404
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 06:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387916AbfJDEwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 00:52:09 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39634 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387754AbfJDEwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 00:52:09 -0400
Received: by mail-pl1-f195.google.com with SMTP id s17so2554858plp.6;
        Thu, 03 Oct 2019 21:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=8bsgxeTo1IrwaM9JN4Qhx6pcsBRRlUNyz/GUpfVl8rc=;
        b=U418xwuCcWDB/IyjoaTLRI7WI8HmR6zhH4fg0Q6GX1AGPTTuQzvJEt02C+DqNDCvKq
         tr3g3+ZEpqSrlUPrF9kyrcOnqKqN+R8gceu/Yex5Ds0gbPnVwnK4tbJO9OU2byedI5Di
         qhYgOccfcU5MMbqfNuwdtcT/6tW5qQeucLN/sS0qmQaBLI2NkfmEPjaV+8DgDWuAcc+Y
         y+TbzZifmEQLzfl0T9Wx/RWplxBSXhwioM/oeSMgSK4aHFaNsx3mekIyLhCz14+TLPWK
         kCOnZu0BXqhTGWs2t3y+SQZ+P8IpqsoZGCzIkoAfRItH6vFFNHk0WvUYQh2lAosjfg+T
         H7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=8bsgxeTo1IrwaM9JN4Qhx6pcsBRRlUNyz/GUpfVl8rc=;
        b=a4DsHnnHdd39PN9R8jP7GhVGq0ICYLF+QZgQa8t2TvuRTHoyc4CyoaIoqof1nT/vWP
         vvgj/pZGZFwt37H2vVGlglXNYzVekbesvjFCeCBh1v1Y/v0GbaLXLoKtJdrQ4kfY8ysS
         yJOk6LzB6gH8SIINxyfX3BR17SVxqLOchA/LnU6sJ/hoQgWZ3i6BCeD4HrqG7N2+F7YQ
         Mdalge/gIPSprw1wz/qFswpDAxRhDxodB340Z+a1OpldiJWyOq9hScAd5KhvEAXZfeZP
         J0yUB2jSmVwJsp8CnZcuVkbiYdbxne6qi4lc1mTIyxODylTBtflFpNBjOvqM2Qec37RQ
         gUTQ==
X-Gm-Message-State: APjAAAVpVWNQUfnTjt1nEG/HmA+P6Yt71LVidLjT56MwRHb0NRKIAeAn
        m5H5TEja/Lj+ZfaOflCqj9omCqXaBN8=
X-Google-Smtp-Source: APXvYqwSPYRW67xIC5EGPcenGaycMnv9T9tVrv3M2l8DH3+91OkwML8wh9mShRlWhZm67LUjM0gtRg==
X-Received: by 2002:a17:902:6b05:: with SMTP id o5mr13096039plk.33.1570164728291;
        Thu, 03 Oct 2019 21:52:08 -0700 (PDT)
Received: from LGEARND20B15 ([27.122.242.75])
        by smtp.gmail.com with ESMTPSA id y144sm4589388pfb.188.2019.10.03.21.52.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 21:52:07 -0700 (PDT)
Date:   Fri, 4 Oct 2019 13:52:03 +0900
From:   Austin Kim <austindh.kim@gmail.com>
To:     romieu@fr.zoreil.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        austindh.kim@gmail.com
Subject: [PATCH] net/velocity: fix -Wunused-but-set-variable warnings
Message-ID: <20191004045203.GA124692@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'curr_status' is declared as u32.
But this variable is not used after below statement.
   curr_status = vptr->mii_status & (~VELOCITY_LINK_FAIL);

This variable could be dropped to mute below warning message:

   drivers/net/ethernet/via/via-velocity.c:868:6:
   warning: variable ‘curr_status’ set but not used 
   [-Wunused-but-set-variable]

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 drivers/net/ethernet/via/via-velocity.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 346e441..36d402c 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -865,11 +865,9 @@ static u32 check_connection_type(struct mac_regs __iomem *regs)
  */
 static int velocity_set_media_mode(struct velocity_info *vptr, u32 mii_status)
 {
-	u32 curr_status;
 	struct mac_regs __iomem *regs = vptr->mac_regs;
 
 	vptr->mii_status = mii_check_media_mode(vptr->mac_regs);
-	curr_status = vptr->mii_status & (~VELOCITY_LINK_FAIL);
 
 	/* Set mii link status */
 	set_mii_flow_control(vptr);
-- 
2.6.2

