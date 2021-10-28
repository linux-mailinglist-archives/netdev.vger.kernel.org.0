Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8284043F2E1
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 00:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhJ1WkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 18:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhJ1WkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 18:40:20 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF8DC061570;
        Thu, 28 Oct 2021 15:37:52 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id bi29so7466343qkb.5;
        Thu, 28 Oct 2021 15:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=2TZX+xZUa56lC0cQXsab0mkG5bKLwat+shoyNBUWFBM=;
        b=CwkCn4knFeZ/VA8sErGYHpI/+8iIAPK2EK3yIu1kWy+BNVmjRZW1YVAO8yiScxcRNB
         j2IkUraytSlmFyF98TMiJVWloDozpfYWFv0g2JClshRj0DsP8a/YCF1U7SFdxsDO1qmG
         ZI/DJnfis3Z/e8T0J+V3P2/YRJgE4Ft63TnIgDoVtW1PEy55cGSvEyHQ8R1OfdWM3nUX
         Fbx/oCKsug5WL+Mjvcr3vUplCEER1g//kvTRJ94aToxeWDrZLqiRAtnB0zn0mZj4ygWC
         iSJUx+G1SFgxwmz8hVfJAKjn9UqNza+iLicu6ybpWf7qvcaylOxTIFTM+KItH1nDCZAy
         mnFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=2TZX+xZUa56lC0cQXsab0mkG5bKLwat+shoyNBUWFBM=;
        b=oCL1wGGc/K875jzSrEbMzkua3lDQpALVgaS40ErebCu7z6oqmEOM1K5A7PVPLfBodU
         vXvKCWfTl3siyT1eVPGNumNql7l94jalU7ANhjWRRula9Sjdk/10cXVR8sp+Sl/aDAoO
         un+M4iQ8rkX/6i2kesrDl/OieBMcXEqlkTqkQKYoEXqDMslCAqPrlERg4oGHSGs8ukjw
         DmOYRVTo2nY9PYOAKnpVT3MWVUdQ8eWkk+eDqGsdVoqIzeQV9bOOJthJDeOrN83z89TY
         IDL++tTd/Uzn65NpIbcJd567I+QMfkrCNrooxva+TZ0H6TpJI1hOYqtuIxpr6D8gUY4V
         Y6Lw==
X-Gm-Message-State: AOAM531qB31MLmXHfO6KESumWFkYFyOHDSFKG+yqJrPaT7TjLFG+n5v3
        U1yZq5uw5zbrgm/5kgquKWRKqxD1OBvuHw==
X-Google-Smtp-Source: ABdhPJw+6og7gjcR4W0oiWetNJuNLdpGjpr+B16veZHzRPEwz2+XAWNVVc4Mz59i833UfCyrAM7RNg==
X-Received: by 2002:ae9:dc84:: with SMTP id q126mr6141274qkf.128.1635460671867;
        Thu, 28 Oct 2021 15:37:51 -0700 (PDT)
Received: from 10-18-43-117.dynapool.wireless.nyu.edu (216-165-95-164.natpool.nyu.edu. [216.165.95.164])
        by smtp.gmail.com with ESMTPSA id c8sm3083182qtb.29.2021.10.28.15.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 15:37:51 -0700 (PDT)
Date:   Thu, 28 Oct 2021 18:37:49 -0400
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     bruceshenzk@gmail.com
Cc:     Pontus Fuchs <pontus.fuchs@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ar5523: Fix null-ptr-deref with unexpected
 WDCMSG_TARGET_START reply
Message-ID: <YXsmPQ3awHFLuAj2@10-18-43-117.dynapool.wireless.nyu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unexpected WDCMSG_TARGET_START replay can lead to null-ptr-deref
when ar->tx_cmd->odata is NULL. The patch adds a null check to
prevent such case.

KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 ar5523_cmd+0x46a/0x581 [ar5523]
 ar5523_probe.cold+0x1b7/0x18da [ar5523]
 ? ar5523_cmd_rx_cb+0x7a0/0x7a0 [ar5523]
 ? __pm_runtime_set_status+0x54a/0x8f0
 ? _raw_spin_trylock_bh+0x120/0x120
 ? pm_runtime_barrier+0x220/0x220
 ? __pm_runtime_resume+0xb1/0xf0
 usb_probe_interface+0x25b/0x710
 really_probe+0x209/0x5d0
 driver_probe_device+0xc6/0x1b0
 device_driver_attach+0xe2/0x120

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 49cc4b7ed..1baec4b41 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -153,6 +153,10 @@ static void ar5523_cmd_rx_cb(struct urb *urb)
 			ar5523_err(ar, "Invalid reply to WDCMSG_TARGET_START");
 			return;
 		}
+		if (!cmd->odata) {
+			ar5523_err(ar, "Unexpected WDCMSG_TARGET_START reply");
+			return;
+		}
 		memcpy(cmd->odata, hdr + 1, sizeof(u32));
 		cmd->olen = sizeof(u32);
 		cmd->res = 0;
-- 
2.25.1

