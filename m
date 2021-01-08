Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19A72EF1B9
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 13:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbhAHMBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 07:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbhAHMBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 07:01:09 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2633C0612F6
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 04:00:28 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id w5so8714174wrm.11
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 04:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2BgG1Oq469kmsx9I+eoguuVlj/o96Nb8n0c0wyoGSew=;
        b=HHWpAMkviEIn4ZNoBai/V8H4jwY2HBre/welDdD3sWsH9zxKqyXofFfTv4pDJAo6/c
         lEmhGpAioZ8hQBnmVACe68G6AtNMROShjEO/Zj2Z0wXVyhqMyFMxmNcGrvDVScyCx2gq
         CJb3mULNFFsBRH0UowDnbECmH6cYuKAt0vKhGoXwpKw75UWfseYhfWoVISS2FT/6i4QF
         KwFPN3SKxYdZEb+rW3tlX9ewRDh57B5zFzs4j+9Sjcn3ibV288WgxQKIoMkuzh0PiHOa
         /PqRALXp5o/rwsUbf7tH6GJK+DwQUVwFNgWO0+ZLDZbLjUvt8Wm3C7Cmj423zn67hwjE
         mKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2BgG1Oq469kmsx9I+eoguuVlj/o96Nb8n0c0wyoGSew=;
        b=Ey6QGn230LWy0kY/sufgb3+GnFVoFkc9eV7EDP3kYKN1kTpF1mQ9MUPVPiXZrH4znM
         f2qi5Rstl029Mdx0ynB3TZnIXj0LlRaoUaXX7ktJ36XbOSoXWZaqo7b2JQcx1TYWVUtL
         SXOaKf1+iLVNqsR7Wjv+TlO+CWbVrFBUSjWPSmkqnsDmNNvJh/lECNngHTG8LjboqGIr
         UIMozpNQdxquaX0xk8rKZoSrkcy5etMXnmOlHTOqvhcGcLRGB+4a6Lsfx8wvMqmCfvXr
         UWq8T2UFW0cw29kHt8hPynVoeDJKwr/dEjBA+UOZfpBsnND8pmgAdKk5kAqJ6TdpH6fr
         E3ew==
X-Gm-Message-State: AOAM532rKVz6mM7hPz0xLIz1eR8mVDi1tzHM2i5NG8jhw13bFPKWayHX
        WY+Zr9/7YIAgAEdYltdCtgJdZU2/syU=
X-Google-Smtp-Source: ABdhPJxcCiEx4phEfInZwnJt4x1lmNSkqgfXX4rSGM4G37ZPmzR9mgEL2CwhyoAQwAQh6Zoa2EVlhQ==
X-Received: by 2002:a5d:6045:: with SMTP id j5mr3179462wrt.223.1610107227373;
        Fri, 08 Jan 2021 04:00:27 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:6dbb:aa76:4e1a:5cc4? (p200300ea8f0655006dbbaa764e1a5cc4.dip0.t-ipconnect.de. [2003:ea:8f06:5500:6dbb:aa76:4e1a:5cc4])
        by smtp.googlemail.com with ESMTPSA id i9sm13832327wrs.70.2021.01.08.04.00.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 04:00:26 -0800 (PST)
Subject: [PATCH net-next v2 3/3] r8169: don't wakeup-enable device on shutdown
 if WOL is disabled
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <938caef4-8a0b-bbbd-66aa-76f758ff877a@gmail.com>
Message-ID: <a177aed9-fc27-9bac-c42a-941528559fd1@gmail.com>
Date:   Fri, 8 Jan 2021 13:00:13 +0100
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

If WOL isn't enabled, then there's no need to enable wakeup from D3
on system shutdown.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6005d37b6..982e6b2f0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4876,7 +4876,7 @@ static void rtl_shutdown(struct pci_dev *pdev)
 			rtl_wol_shutdown_quirk(tp);
 		}
 
-		pci_wake_from_d3(pdev, true);
+		pci_wake_from_d3(pdev, tp->saved_wolopts);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
 }
-- 
2.30.0



