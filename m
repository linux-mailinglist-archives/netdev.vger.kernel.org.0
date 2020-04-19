Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8B71AFCDD
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 19:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgDSRol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 13:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgDSRoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 13:44:39 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB365C061A0F
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 10:44:38 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id h2so8319817wmb.4
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 10:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A+Vd2BXyliJgGE4HKrw7OlmjrDOuLp+ovt0puIdwfOo=;
        b=MS1ar4iYJo0qt9U5bK4ofu3nMObl8J2GEO6ZXTyGasNqiZMFVsGB3HFdsj2VF6jeKG
         duXffJh/5R+boDmV/5zs+G1nlfEo+NcYjtvVyEjHIE7Nr24hdxdcOSHNujEHz6hqGULP
         C+vfayT4qYaCUIsJYvfIEeDfESF/krtEahPb4OceqFLHSL0uJNrNCSSx/MJPbUK6bhpn
         nfbn/ZpdC/5bL473+xUZgafDsJi3JnPhtRrhDooeWjT1tvrNd9WNQO00hbqUkzTkDVfj
         MMvleL3aEJF62O2wPBie8NnttGL93f06c489vYP/Kuy/PX+7JOK5ekQ3nnzhMEUxMZ/E
         j1rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A+Vd2BXyliJgGE4HKrw7OlmjrDOuLp+ovt0puIdwfOo=;
        b=h+dksZRnFq7SnAWETv7GKszDxSORj+i42duBcMphmti6nZQTi+3zULEfv31aXukxqN
         lB+Hmhw/bTclYmCrQ/+rM5AXq0lb8fNDzyRy682j3Spfw20ueDt+l9MwogefszfqV2rJ
         CRvEGiFl98ROjia/Cm1MaCkZjKzTMPu9VMXTYqbda1KvIVBBT32WC1lvQyhYgW/79g73
         HcYtU+MucrssQSzdIk61AjkL3tUDemIsip9tKn+HLoyZRUvogHmOoJYSZWlxvFO4Jyle
         BZQKCE8gBkzAJp2RLmBE4cXt0K3Nk/SA5dqje4fxHMjqFXk3YqNXdvNYgfLmebIhrffF
         YqGw==
X-Gm-Message-State: AGi0PuZHlZSY5guTloMUZBrDt0faKr7WHYwqSuXwBNIocWSW7yhYOO/h
        rAORwoZG/+sUNNX9jbZYHcMDsnm9
X-Google-Smtp-Source: APiQypLHWqdNcC+K5FHDeHiIqcPGtegonYNs+cBAO/O2kI1d+4k2NbdG7krGEhvqvaP9kea+c2llAw==
X-Received: by 2002:a1c:1c8:: with SMTP id 191mr9566679wmb.37.1587318277311;
        Sun, 19 Apr 2020 10:44:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id u30sm20775248wru.13.2020.04.19.10.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 10:44:36 -0700 (PDT)
Subject: [PATCH net-next 2/4] r8169: change wmb to dma_wmb in
 rtl8169_start_xmit
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c1df4a9e-6be8-d529-7eb0-ea5bdf2b77ec@gmail.com>
Message-ID: <d6d705a9-ebe7-5ed5-ec08-840500739c2c@gmail.com>
Date:   Sun, 19 Apr 2020 19:41:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c1df4a9e-6be8-d529-7eb0-ea5bdf2b77ec@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's the typical dma_wmb() use case to finish descriptor writes before
ringing the device doorbell. Therefore switch to this lighter barrier.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dd6113fd7..038cd6fde 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4259,7 +4259,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	txd_first->opts1 |= cpu_to_le32(DescOwn | FirstFrag);
 
 	/* Force all memory writes to complete before notifying device */
-	wmb();
+	dma_wmb();
 
 	tp->cur_tx += frags + 1;
 
-- 
2.26.1


