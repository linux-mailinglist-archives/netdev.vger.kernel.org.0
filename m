Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DC71C0735
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgD3UAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbgD3UAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:00:14 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45FAC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:13 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j1so8721831wrt.1
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MTt4Vl/E9kRkOy67AEM6BcySa0W3+p1+bNbqablUp0o=;
        b=U/sFnoLm8sYQz1Bhw2XNtccQAy/n2VRK2tffyo/KR+WpuPSH4lnyxYtgmaFb2n3Bra
         lfcDLBCXNsm5lxVVii6NwAka6FmU9XpmPaAc2w1kOG0cP+FIV11n80qKdKv84IIZhok5
         reJrbPO2QNn3Z9o11Lx1xEDRlU0xISteHHnZaBWdWEt+yCUkwckBVarnT6jvvJ1n+Gwx
         IKNd3fUm7eNKtlMNS7LI2h3veZzYZ6gtWteyfp9FO1QW4Htv64PNo3qdC4dJrfct/Ukb
         5X5QD5OGQug8VryBn5rZBAjTeUtcgPpq1KMPJCR08DlWDLvcA/h033PvuQ+1LTpD1O5K
         /o6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MTt4Vl/E9kRkOy67AEM6BcySa0W3+p1+bNbqablUp0o=;
        b=oRqXYYyfvIxaeZiew/2dDdmqhcQMeEyrrkjmCtHzng9vfxMRr16fSEXz8YZX4U3hxD
         PWOEYZj+nRrcX39hg0KVyM7BiZcewIcUoQ1BL/9vmdEGPIaaGKbiyeschLtkZysHB+4l
         Cyv78mdBk2mYeKgMCvA6mXjmGXFGftsqv7eIccFU3xCMH/FXl59cVXvjkA2MuxqGRbTV
         AzmG/WkHICmG5Z3oVsfXz1rCehK8XPanCazQpX1DH6Y4uZ+j8lMW5HkFQtGdToP/BkpU
         xun2h0z0lIqJ1dsy6oxB4wcPxv5cwsmO49E8an7S7fuQYhakjHNkvZiycry8TQf9oBCH
         EejA==
X-Gm-Message-State: AGi0PuadsWRfwMMQ3bemXIwiqaJEY1bjPqmmCd9u0Xo4l+2+x67T62rt
        VYwmMOOQ30AcDqJzkFcDqGj9yYjU
X-Google-Smtp-Source: APiQypJoXhlJzAkXnJzWp7C7grSfEUzenMipfUwHM5i01XRIIIQLlD9JS1QtUYaDJOOJwopPP7h7pg==
X-Received: by 2002:adf:f750:: with SMTP id z16mr241660wrp.115.1588276812303;
        Thu, 30 Apr 2020 13:00:12 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f0e:e300:b04f:e17d:bb1a:140e? (p200300EA8F0EE300B04FE17DBB1A140E.dip0.t-ipconnect.de. [2003:ea:8f0e:e300:b04f:e17d:bb1a:140e])
        by smtp.googlemail.com with ESMTPSA id p7sm1150174wrf.31.2020.04.30.13.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 13:00:11 -0700 (PDT)
Subject: [PATCH net-next 5/7] r8169: improve interrupt coalescing parameter
 handling
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
Message-ID: <b929adc1-75e1-ba74-64e6-1db1f7b0e485@gmail.com>
Date:   Thu, 30 Apr 2020 21:58:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The chip supports only frame limits 0, 4, 8, .. 60 internally.
Returning EINVAL for all val % 4 != 0 seems to be a little bit too
unfriendly to the user. Therefore round up the frame limit to the next
supported value. In addition round up the time limit, else a very low
limit could be rounded down to 0, and interpreted as "ignore value"
by the chip.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a95615684..fe95c47e7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1909,21 +1909,21 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 		 * - then user does `ethtool -C eth0 rx-usecs 100`
 		 *
 		 * since ethtool sends to kernel whole ethtool_coalesce
-		 * settings, if we do not handle rx_usecs=!0, rx_frames=1
-		 * we'll reject it below in `frames % 4 != 0`.
+		 * settings, if we want to ignore rx_frames then it has
+		 * to be set to 0.
 		 */
 		if (p->frames == 1) {
 			p->frames = 0;
 		}
 
-		units = p->usecs * 1000 / scale;
-		if (p->frames > RTL_COALESCE_FRAME_MAX || p->frames % 4)
-			return -EINVAL;
+		units = DIV_ROUND_UP(p->usecs * 1000, scale);
+		if (p->frames > RTL_COALESCE_FRAME_MAX)
+			return -ERANGE;
 
 		w <<= RTL_COALESCE_SHIFT;
 		w |= units;
 		w <<= RTL_COALESCE_SHIFT;
-		w |= p->frames >> 2;
+		w |= DIV_ROUND_UP(p->frames, 4);
 	}
 
 	rtl_lock_work(tp);
-- 
2.26.2


