Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7D8249B52
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 13:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgHSLDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 07:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgHSLDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 07:03:23 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E47C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 04:03:22 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id qc22so25782605ejb.4
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 04:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tLjbNKLSMAzHDZq9DWWnrNIpuZL3mhC0Yc/t2ZOgSNo=;
        b=FHclh3fMKVJZit8B3MXw+ISHPbhAEXDoP/QfGIwBY5Qele5mZAYFfo5jXQ2U5zTMC1
         imIr8tArnKx7sa/TeHAETeIok/bYptwj+q0a3k+KPKMYyusmgchbSKVo/22ukNcxEH/f
         7m54rRg8LwR9SfEXn6PdHgF5D9DzPmBJV82Keo0Dz5wh4R0gCbaM78OfEJFbWbdI7Jyv
         YczNOXcDkk5v4obn0Y9FuNcqJKq8hNYTeg/HxDHbHsI928WTfV7hniE1zANUXvbZdnOF
         GMzQUbrJSOoVvdnkSUQwg29hIia0CBpoOfnv/v2wabNeDvLV6sjJgjqegNTO9zE/CWgW
         2nnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tLjbNKLSMAzHDZq9DWWnrNIpuZL3mhC0Yc/t2ZOgSNo=;
        b=UKazxEidh301V1CQJSsB+67rQOGLZ4kSUSZw++SRQKFB4IBtg1X+PFosQF1iLDMgHj
         4Z5uZeKhQwe21SXXmrKkkpSc4fl8QEqXMUxnoS7fG/B5avX/EFsJipXfM8NsgCqNHeyl
         f6GFsfrocb4OGUNoTbAl86b51d2c13OEOw3j18wug3gZ6FfnB2iIJXRqUDh9Tk8MukMP
         IvXw0Ybt67VnBGXOKTVg8hGOnWgJLlUG4HWVvkrfvLmtty2phUO+tk67d//gfk1t92he
         aOuUQZBZFLbfvQB4IvoSq1p4+hvfTrsc+hj7Qj6a3nftv0cGESotym9G3iVPv0kc+K3R
         D2Vw==
X-Gm-Message-State: AOAM531+PveccKmZwSVe/lwou6pHdBCayRYw/Y8nnHYoc+LvXwes2++t
        m3JmgtVMiMZl+chTWRIRFOzHuiHpjfDjFA==
X-Google-Smtp-Source: ABdhPJzq9iBhoMNhhfxc96DuqGkHDHfoK6xM5UrOnpWUeiQG7yab8CboAE43D0RM7+Hgzdl8DIvWHQ==
X-Received: by 2002:a17:906:f847:: with SMTP id ks7mr26112660ejb.402.1597835000920;
        Wed, 19 Aug 2020 04:03:20 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8106:4619:9f30:5ac7? (p200300ea8f235700810646199f305ac7.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8106:4619:9f30:5ac7])
        by smtp.googlemail.com with ESMTPSA id dm5sm17862606edb.32.2020.08.19.04.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 04:03:20 -0700 (PDT)
Subject: [PATCH net-next 1/2] r8169: use napi_complete_done return value
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <18f0fcd2-919e-3580-979d-d0270c81a9ad@gmail.com>
Message-ID: <56676f3b-5b08-cd86-adf5-61089b66f768@gmail.com>
Date:   Wed, 19 Aug 2020 13:02:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <18f0fcd2-919e-3580-979d-d0270c81a9ad@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consider the return value of napi_complete_done(), this allows users to
use the gro_flush_timeout sysfs attribute as an alternative to classic
interrupt coalescing.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d1da92ac7..dbc324c53 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4596,10 +4596,8 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
 
 	rtl_tx(dev, tp, budget);
 
-	if (work_done < budget) {
-		napi_complete_done(napi, work_done);
+	if (work_done < budget && napi_complete_done(napi, work_done))
 		rtl_irq_enable(tp);
-	}
 
 	return work_done;
 }
-- 
2.28.0


