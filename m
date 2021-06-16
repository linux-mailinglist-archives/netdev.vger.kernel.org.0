Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0283AA4C2
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhFPT4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbhFPT4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 15:56:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306E6C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:54:02 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mj8-20020a17090b3688b029016ee34fc1b3so2454141pjb.0
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hP/vb4dAk3glgAbj1Pm59eiznyXf3U0FYK4B0w4C71c=;
        b=NdyGmlMzaud06mmPzqPXI3RVbM8g+LwzrH3k/Vqru0sGy4iHBjHAYUa2mLAefyV3Vm
         Y1u+XxlJGUCezQOghv3YGrvm/gb90Ukjxq/HMUCdJ7PxiqeQlbc7OuCXryqJ7PkeC5qs
         mEEnmVWfsCLePCemE7UPDV59YKmCSPzH6H1vA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hP/vb4dAk3glgAbj1Pm59eiznyXf3U0FYK4B0w4C71c=;
        b=TLY4uhvdPx3TU6P1C1LzBP+wjEXOQRlI5A2MCxa4J0OX1gzsfnTw9Yr+WbhPF3Uq5F
         yHtVhARd0yC+kg3OiTmTuSGWopzYofpKGhaivYKHAlSuBLrjMevKJuC5b3W7DfKt7oUY
         RF5ZaACgfNrOmf8gCFyTTuI2AzOe86Hx7/jUIFjBsHYWcOlMj005qshH9p6ngd47V//7
         7N1DXOL5YevdwqO5egnZFSMY6VDpsBliwJpb5bEIBk5Zhw50CSH3IB4725KBdam8ai9t
         tFz+cJN0a2BqlY1LeoM0UmzObX7UH5d/bIr62RSknflu/h8LDu+45KURw8KUYwInF1X+
         0qCA==
X-Gm-Message-State: AOAM532w6ZzR9FBEDxvGDJZFwJ+keN5cfdYlF6i4tRk3WUxJlu+UkYwM
        vy08bq8AyJS5+cowpVQdUhe4Jg==
X-Google-Smtp-Source: ABdhPJw4tvFdhPLQS0CoV6XfSBGx69vCybkZgIYZxyTce9BsB9lDFb+RzPPFvmiwW0LFrb68AcuVeA==
X-Received: by 2002:a17:903:188:b029:114:a132:1e9 with SMTP id z8-20020a1709030188b0290114a13201e9mr1143258plg.24.1623873241793;
        Wed, 16 Jun 2021 12:54:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n11sm2859900pfu.29.2021.06.16.12.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 12:54:01 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     netdev@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        nic_swsd@realtek.com, linux-hardening@vger.kernel.org
Subject: [PATCH] r8169: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Wed, 16 Jun 2021 12:53:59 -0700
Message-Id: <20210616195359.1231984-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=964eb9cbe3c11a824a079aa4553a4148d7aeefe1; i=mWTdhlIN8EOPk+kK5Tlt/6ol6tz4t5mr8WWbljTVla8=; m=CF57NG64wUjRAJMr07rJpYR31VG7hNQuEGsWk+kxwfo=; p=1/xDugcsE8T7YfRxtZt3HYiYLkq/IwuFbyCBAyie+BU=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDKVtcACgkQiXL039xtwCb27w//WX3 CnyN1NEOmoN9HpXNcLmaKEPweAE0/oOmpHHpuYzwBNWNcJ7ZAJezPMlIq5c1eN3TDu+yTWGGaVP87 M7JvVnUsMqa6MQG93iys5CqKjsxaKLwOpovgTPQDax9W8FbczXbSn4RADAPIabFQbORu96BcPNRLr WVd6NuAPDppO9O1zTHAcBDSqJWvSAYvJio/TxBEeANU7Uki8IbVaxJxXaiht9US99pLCRYCi5Br+w /4U4F2pvg4J1MMRMzbtRO6yaBR22RaKsqBqqq465PKzQzrvnheuJPwsIVTruqHG6JRidtqZmzfBSC YLFGucm8qPJrczMGTOWIgW7jqSpDNV5Tm4B/+JIRonxtngbhJNrnnXRZ37x264IhQTITRvti1V0lN +5/obO+nRHOBcaXG2j+drCjV1SVeqgky+P3TOIsGPj0jP5Q0hhbBHfVTlBN/F6E4SaF0tq4mmOrXi t3sa2XVCvoW/aIUEGHHpJbDfC2ScIeTOz4lMcqu+831R1t7tqNxuCXKU7yAtjQ20ekwQq461oDlzO +IQEse4XhLl+SSBsjHA2LHpp0PNBsH1oPfOiVNlobxzpUICrCKr2K4eLbEQCgShMkHy05r7IrGAYG RcH98VhPy+Xc0wqnLQZCPxY4CCTucQoS8f/Av/xofkutsOdWQoF+po3BB1yZYh8M=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally reading across neighboring array fields.

The memcpy() is copying the entire structure, not just the first array.
Adjust the source argument so the compiler can do appropriate bounds
checking.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6a9fe9f7e0be..f744557c33a3 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1669,7 +1669,7 @@ static void rtl8169_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 {
 	switch(stringset) {
 	case ETH_SS_STATS:
-		memcpy(data, *rtl8169_gstrings, sizeof(rtl8169_gstrings));
+		memcpy(data, rtl8169_gstrings, sizeof(rtl8169_gstrings));
 		break;
 	}
 }
-- 
2.25.1

