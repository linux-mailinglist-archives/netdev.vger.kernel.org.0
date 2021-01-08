Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAF82EF1B7
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 13:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbhAHMBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 07:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbhAHMBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 07:01:06 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90D3C0612F4
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 04:00:25 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id e25so8222592wme.0
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 04:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jt3zw0dfENHCHUmf/u475QK+Rs4cwPdEOzlKvH1tBNE=;
        b=QW7d0W+Q0PnUu+/Ku5fWnArt0/2OgwcB/A7Tk3xy8lG15HV7WinZYkjR7GOkshat6D
         /+WOEnuG2UKiQ36zh7G7j/7fPdvqf756Fvl+SdJvGmabpS/WmOHRVMvC6cKLq/0fW1CZ
         2hb5wH/cm/VLLfaYd74/D4IJ59xD85AauVSy29IPEMa3H7AvgnsSwxDdYfmJrz9cYica
         giBelTGebnP8XYb40QRVQoBlAPm6b/8AdyYPoSQaIjmCcWMNWUCnuRpVOnRAFX6BLLhC
         n1c8vMgRjzAWPuCet6pGAs0riE/FuJk8ezLbHlRLy61x8nj5DjNzPhshjPy5jCFqBZ3s
         o+Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jt3zw0dfENHCHUmf/u475QK+Rs4cwPdEOzlKvH1tBNE=;
        b=WrdhCbmlM7EtlSTAMtiSyab9lFIxJc+abmG9frI2XBj7M325g+o5VzZtk7l6FMPznX
         a2RoNKTc69yxEx7v+xtIjN9d3/ODRCUaBVyxqehtIKCXUm6XxFFl0n5tPfnoh/sQmVup
         EUpf/fpEsMqtsaDW5p9LgvgxZxPiJ7yvhaIx10HB8jQh4nz6Ap45EO1T65n8pSMrdWYW
         fwU9LUrbJpogBNgiaKciTopaOXC+LIp/LFAt1omu06V9a+gJobys68xXVcz/0pfM1kUt
         pkzDr/raBTNnx5TrAKBWv7Wt59CLbyG7TIvMcHrqA/YHkMW8hXHO9psHrHhlrY+YBFjO
         B0Hw==
X-Gm-Message-State: AOAM533teSb7sSf5Vs/rH3/e1A5cCR82FTzp+wRFn7rH45caH/KquCPf
        i4Edze6i/pTdKPhyM9WHPMZvmcMtSiw=
X-Google-Smtp-Source: ABdhPJyRunovPtyLyzY17WzhUIK7WXIPLetyA0LkkB7rbLFdeewhDzKFNI2RoaNPPvo34n35NDcVjQ==
X-Received: by 2002:a1c:220a:: with SMTP id i10mr2703715wmi.93.1610107223898;
        Fri, 08 Jan 2021 04:00:23 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:6dbb:aa76:4e1a:5cc4? (p200300ea8f0655006dbbaa764e1a5cc4.dip0.t-ipconnect.de. [2003:ea:8f06:5500:6dbb:aa76:4e1a:5cc4])
        by smtp.googlemail.com with ESMTPSA id o8sm13095907wrm.17.2021.01.08.04.00.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 04:00:23 -0800 (PST)
Subject: [PATCH net-next v2 1/3] r8169: replace BUG_ON with WARN in
 _rtl_eri_write
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <938caef4-8a0b-bbbd-66aa-76f758ff877a@gmail.com>
Message-ID: <e3f1413c-04f5-b511-f2f8-5f9f26a71946@gmail.com>
Date:   Fri, 8 Jan 2021 12:57:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <938caef4-8a0b-bbbd-66aa-76f758ff877a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use WARN here to avoid stopping the system. In addition print the addr
and mask values that triggered the warning.

v2:
- return on WARN to avoid an invalid register write

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c9abc7ccb..317b34723 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -763,7 +763,9 @@ static void _rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
 {
 	u32 cmd = ERIAR_WRITE_CMD | type | mask | addr;
 
-	BUG_ON((addr & 3) || (mask == 0));
+	if (WARN(addr & 3 || !mask, "addr: 0x%x, mask: 0x%08x\n", addr, mask))
+		return;
+
 	RTL_W32(tp, ERIDR, val);
 	r8168fp_adjust_ocp_cmd(tp, &cmd, type);
 	RTL_W32(tp, ERIAR, cmd);
-- 
2.30.0


