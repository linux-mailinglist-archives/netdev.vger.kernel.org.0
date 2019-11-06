Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1B8F201C
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 21:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732242AbfKFUvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 15:51:41 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44851 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727587AbfKFUvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 15:51:41 -0500
Received: by mail-wr1-f68.google.com with SMTP id f2so76339wrs.11
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 12:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YAOxfH3S6OCSID0zy3/R6cBnW7pwH4KQmZSHdTtmaU0=;
        b=ED5G2/pBSjUg9exh/jBN3S4z+/k/k4+nD7jWuLpUVFM/31pwiTS/a4fwgTNiJDxhhC
         Wz3b5XEb2EyQXwjvk6gOqckceN0+cY3KnLM49l6rfUG14indMu1X44155NmoTYgIOBBN
         9by/+mJ5lZS9hvwVFvSwL/+N26t7//el4uB6t6DxJndgNRk0GktpEcfj9ntQ6FVYImOP
         rsVG1YjVVhawD78IyUkifr6u+MvmNBQ30zWt1e4ej18/gS5RmDJ1LEz7NiuUL0HdEC95
         IJldROmtRnEeX9E1SLA/NrlmAyDew2Fqx83ve2qsqrRJCx001f4dg9ENfdDqS9ptKQDm
         z16g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YAOxfH3S6OCSID0zy3/R6cBnW7pwH4KQmZSHdTtmaU0=;
        b=FSOmw4QC7g9s/jnXz4OC8CSR6pjns4xX8vyWAtMaZC42i0EHFCXp7kNpaqkgd7KkOn
         HCb5AgVpyXfKCwltOMSEBmErDlh7jZgmh/aglAiBhSP8/5wMiT7w+h+gwOAjXEMzOg9N
         b0MgGSzz5EZpENbtPJr9OqsoIdlEVnqcWAxnWQv1vyo7sc1UDNpettCA3jl2/vu4As0j
         8OGyf/5fmIfaiAAxHsGRg+DkMWabSCgZ0AFSR5ve+NBiAVJ0SO+XOah/BDWo9J+oTOmY
         BhIPguhnLi+eefpJwIPDwAz2hLQVV+WXWMS2bxAta/uS5y6bCpNMH/oaQZv58aeRG5mz
         EIpA==
X-Gm-Message-State: APjAAAUanuVdBEJ0DesF3D7U0OsXRt7j5S+fc0mT1Q6ZxCTaGObTI3Lr
        4Yt0YS4pTnqEf8stgRuuT94U8Wfi
X-Google-Smtp-Source: APXvYqzd7UU5f2PPQCuO+aSeZ/PhyP2mWnzgFw4RZky+KCnSkVIAi2q3g1M7wsjINyxkLBXtM91H9g==
X-Received: by 2002:adf:dc81:: with SMTP id r1mr4978954wrj.84.1573073498676;
        Wed, 06 Nov 2019 12:51:38 -0800 (PST)
Received: from ?IPv6:2003:ea:8f17:6e00:25aa:f905:14e6:6be2? (p200300EA8F176E0025AAF90514E66BE2.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:25aa:f905:14e6:6be2])
        by smtp.googlemail.com with ESMTPSA id 76sm4545030wma.0.2019.11.06.12.51.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Nov 2019 12:51:38 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix page read in r8168g_mdio_read
Message-ID: <6a72148a-5ad3-6835-cfbf-974d871498e3@gmail.com>
Date:   Wed, 6 Nov 2019 21:51:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions like phy_modify_paged() read the current page, on Realtek
PHY's this means reading the value of register 0x1f. Add special
handling for reading this register, similar to what we do already
in r8168g_mdio_write(). Currently we read a random value that by
chance seems to be 0 always.

Fixes: a2928d28643e ("r8169: use paged versions of phylib MDIO access functions")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0704f8bd1..8a7b22301 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -910,6 +910,9 @@ static void r8168g_mdio_write(struct rtl8169_private *tp, int reg, int value)
 
 static int r8168g_mdio_read(struct rtl8169_private *tp, int reg)
 {
+	if (reg == 0x1f)
+		return tp->ocp_base == OCP_STD_PHY_BASE ? 0 : tp->ocp_base >> 4;
+
 	if (tp->ocp_base != OCP_STD_PHY_BASE)
 		reg -= 0x10;
 
-- 
2.24.0

