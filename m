Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F2E1E9419
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 00:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgE3WAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 18:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgE3WAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 18:00:17 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F351C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 15:00:17 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id n5so7646796wmd.0
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 15:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=crG4E3kuy2W2YxYv21NV8BPelIbycfVrq+mYiF0r58w=;
        b=bBMnXoV6RvCWShsWlYmuBJ/UUCMJh++fwfIPV7Zaleure8uEvpQu67u95Vf80ivSpS
         ZjZGMmuKAZzzHgS0ZVXO5P0+4zF/d+KmGylNl7NM+LO3KeEfFSIS//DKAGClUgUjCrkm
         HRaeN7HbyXvfVbfMjTBAHvyv9m6l6b5SI+CO0khbzrgh0bbwO0zab4wY9oY76S0k6UjO
         +uwf3oNifHi6hCDlMqRK6h8j8EINDVtXuYqOwwovfkh+a7nPJ0jAPpbn4JENlnGVecoL
         lGbfLAB2pwlbtqpuhbLuBSoVOl1Y5ZX/lxdyELjhitmfqoZm1h9E73ylP0fBRxSBc/7B
         xafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=crG4E3kuy2W2YxYv21NV8BPelIbycfVrq+mYiF0r58w=;
        b=IOfamQvSo2l7NWiLyDHc4TkCaxS5e6agmeGRcOH95uGLfvu2vKKvUNTl72tdSlTft6
         VvjskUPgUf4kISmDEFL0aiGrXd7u8wgzL8H1q18nx1vBQrGtAHvGfkHT5GAElaMnRYSd
         33WzT3snFrlZaKUXwl3z5y7DwUT6G+ZtfjAdFRJNSkrdvJpSeuDuyKRx2xDZoLhc1ZNZ
         UM71ST0dICukOCpa/PasrbC3dX+LtN8CN8SY4xyEewxLVIlztMb5Pq4D0qX3JmvAOLdw
         2XRvIKLnWN/ZPQO5/k7nNQJnwZ8ExM1Ip8otYstQ32viJkrK1mmmLKxYsRwQtkD6axk4
         Yokw==
X-Gm-Message-State: AOAM532nxoy2liLz4cX324UGZD8Yq+Rs45sHjgJqQDbNbMw6wnUFMlEs
        2236G2eNsFhbxPFLVf/I0PDqThIt
X-Google-Smtp-Source: ABdhPJz36E2/K2avV+W0jIj9jxujyFl2a3Y+wGWdGGEy9LCQ2uTOf3A1+TUB50OkFLTMLFH1Biwn5w==
X-Received: by 2002:a1c:22d7:: with SMTP id i206mr14414930wmi.186.1590876015861;
        Sat, 30 May 2020 15:00:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0? (p200300ea8f2357008c7380e5b6bad8b0.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0])
        by smtp.googlemail.com with ESMTPSA id l204sm5920092wmf.19.2020.05.30.15.00.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 15:00:15 -0700 (PDT)
Subject: [PATCH net-next 2/6] r8169: enable WAKE_PHY as only WoL source when
 runtime-suspending
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
Message-ID: <770d03ee-a3df-3be5-ff42-811d54055f30@gmail.com>
Date:   Sat, 30 May 2020 23:55:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We go to runtime-suspend few secs after cable removal. As cable is
removed "physical link up" is the only meaningful WoL source.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 810398ef7..6fcd35ac8 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4884,7 +4884,7 @@ static int rtl8169_runtime_suspend(struct device *device)
 		return 0;
 
 	rtl_lock_work(tp);
-	__rtl8169_set_wol(tp, WAKE_ANY);
+	__rtl8169_set_wol(tp, WAKE_PHY);
 	rtl_unlock_work(tp);
 
 	rtl8169_net_suspend(tp);
-- 
2.26.2


