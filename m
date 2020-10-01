Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9733727FA2B
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731449AbgJAHXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731498AbgJAHXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:23:11 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA41FC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 00:23:10 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id md26so841867ejb.10
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 00:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=euySubMLNn0hpcE/3ehb/nX++VODJcqhFgRzScT/BDo=;
        b=BbPsYL+LyQ0iDdWfm4g9SaQpkl2jEEkwScvdZWOFgI6EqO58T6T242c6IzUgSVIubx
         d5AxrbuWyjnaM3sd/RzwDCk1w2xyNR2PdyR0CeFGypIWvM5ySHSnGbvsI1Ss95MSDltw
         n0DXdanLVwrNvwNowU1++eNOmmSc3aVfGtjhKQWTKxciZXQoVklIVD9WkBe+fGBmyi1C
         YjFiuJMljBATrg7ajRkASyKIxVHuoIW4P+U9K/+Bh8wh3RQLBW+J4Gsylskz0R9w2l3o
         uuKWDu9QnMHp154fghLdSG2fJXiCsXeyvBx3GOFzgFGVMr64i9qWnM3qY7fRb+anIa5d
         4nXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=euySubMLNn0hpcE/3ehb/nX++VODJcqhFgRzScT/BDo=;
        b=C2U3bS+H758ZSdX5gMe3/OCrQf/WZVwbz7tc+0y6bf2c1VZ8HPUTvUaI2YroBSyZ0h
         4TFN0DcsX0A5VgFq/NHmUxZnwIVrBE6fNVSI2CwH44Ec+TvtPGOaN3meuZoUT3nKkoIa
         yBhaVS30H0nrmCeqpXjEntdx3+iVUcy7u/3eGAkPoghk3ysr2w0Tp3Ccg0S/kb/trsxw
         4jdVlKreSY6ADiTB5MZ9BjTnZo+1kyqUrXvCSfMPEtB9MwXIq0z1AdTxRx1n+nminP/F
         yhVQrO9Qk8GXJvm8k+qzCaytciGOhbrSPPid72YXtSoLTXeQDCTxgoDXdHp7leYhjcAw
         pvRg==
X-Gm-Message-State: AOAM532ys+zyCsf6f8KiAmcr2BqNZwOZ7nRmyHjaNhQZFqp0patUqsbI
        9M4cAHtfRTWjRrMp0McQLf8=
X-Google-Smtp-Source: ABdhPJy873iDtJZxUWOHwTbeOjftYDhaTPrlYsftcvcDZOhJtVNVniOBjpi8LZ5gBb2eEw85hf0VSw==
X-Received: by 2002:a17:906:1f42:: with SMTP id d2mr6548793ejk.407.1601536989345;
        Thu, 01 Oct 2020 00:23:09 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:758b:d2db:8faf:4c9e? (p200300ea8f006a00758bd2db8faf4c9e.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:758b:d2db:8faf:4c9e])
        by smtp.googlemail.com with ESMTPSA id o23sm3514440eju.17.2020.10.01.00.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 00:23:08 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Petr Tesarik <ptesarik@suse.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix data corruption issue on RTL8402
Message-ID: <41cca6ed-088c-da5d-94bd-4269b2071a9c@gmail.com>
Date:   Thu, 1 Oct 2020 09:23:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr reported that after resume from suspend RTL8402 partially
truncates incoming packets, and re-initializing register RxConfig
before the actual chip re-initialization sequence is needed to avoid
the issue.

Reported-by: Petr Tesarik <ptesarik@suse.cz>
Proposed-by: Petr Tesarik <ptesarik@suse.cz>
Tested-by: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
Hard to provide a Fixes tag because it seems the issue has been
always there. Due to frequent changes in function rtl8169_resume()
we would need a number of different fixes for the stable kernel
versions. That the issue was reported only now indicates that chip
version RTL8402 is rare. Therefore treat this change mainly as an
improvement. This fix version applies from 5.9 after just submitted
fix "r8169: fix handling ether_clk".
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 72351c5b0..0fa99298a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4848,6 +4848,10 @@ static int __maybe_unused rtl8169_resume(struct device *device)
 	if (!device_may_wakeup(tp_to_dev(tp)))
 		clk_prepare_enable(tp->clk);
 
+	/* Reportedly at least Asus X453MA truncates packets otherwise */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
+		rtl_init_rxcfg(tp);
+
 	return rtl8169_net_resume(tp);
 }
 
-- 
2.28.0

