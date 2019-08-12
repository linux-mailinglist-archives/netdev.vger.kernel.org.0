Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4578A67D
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 20:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfHLSrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 14:47:51 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38090 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfHLSru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 14:47:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so105472293wrr.5
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 11:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=zk3m6DEwienNmYLPinxx0X95P0qA87rPxS+hCeTBUXM=;
        b=c/mw2Q5UptgOrvSDGC/AtRLzBaBYD7e1F1cfLVMqGzxQ09Zb0s8IzYtEU8yonxnehA
         IWE99BmYMP3wYDaaxSUKCjbjzAAld1PHFeQomypc2i1qPhbeac98fQyaupqiVTH9/kdj
         y6VziyXL4U3gP6q7+tM/EkLAM84bxsj/i5d536ZsuVeUpwk09DP8HHTVKVrN9QRWxgBh
         Ax6nvuMOGC+I9QsTMiwwbok7041AfXCL73eGfk+RhFx+B5gnJ/0+Aeg92Dbq+b9bg0GQ
         6wiSlEQZFNEwLy76NA48m/4/A4d/Q4HoM3HEZCoSs8pKW0h9wc1iBMcDe4RMCLvU30yN
         JQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=zk3m6DEwienNmYLPinxx0X95P0qA87rPxS+hCeTBUXM=;
        b=mxlFPQef1VrYO+WLfRKnSeqndGkjj61R1e2NfZCaVnZQ3ejHJNcHIwfLOQxnvpdkJO
         KT7zuf6m2vv1a4jUsI8WRh6EfjH43C5hWZ9OEgzE5K6tpxuR43AcynxpiMT+9tKu8cQX
         xn4hBA4SztKGiWtJImjYSdpwO3nmdmdB0z/87GU0JpWV5KkAk2tmZc1luTu6iA66klcU
         kQAU8U6DNSoGoTMAtVcK+apLCFGEjavMnqTXqhdyEVggmqMDRJc2MYHe10hV8acG/QQ9
         +jhbojUIB0UpzZ1TMtFmcvCep+uOXR1xSKF9mCSjpUZGt9VW97Xyh5AdqEUXIVA9a/2C
         gmkA==
X-Gm-Message-State: APjAAAUQKe5XJWMJuAQTK7TopY4eXoJc2+ut4DuOaZfEg1bOSc8spuiX
        +NtOGyPGv6AqQSl9fZrHvbk=
X-Google-Smtp-Source: APXvYqxKuaGcTwidTPAP2q2t9N2ERmR87pYm2UgZkiZIxOeS6fzeshFPff+fOO3jaTKeybP4uqmjUg==
X-Received: by 2002:adf:fe10:: with SMTP id n16mr42668081wrr.92.1565635668661;
        Mon, 12 Aug 2019 11:47:48 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6? (p200300EA8F2F3200E9C14D4C1CCF09D6.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6])
        by smtp.googlemail.com with ESMTPSA id j15sm6061092wrn.70.2019.08.12.11.47.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 11:47:48 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: fix sporadic transmit timeout issue
Message-ID: <e343933b-1965-4617-3011-6290ed30d4ae@gmail.com>
Date:   Mon, 12 Aug 2019 20:47:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Holger reported sporadic transmit timeouts and it turned out that one
path misses ringing the doorbell. Fix was suggested by Eric.

Fixes: ef14358546b1 ("r8169: make use of xmit_more")
Suggested-by: Eric Dumazet <edumazet@google.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 641a34942..448047a32 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5681,6 +5681,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 		 */
 		smp_wmb();
 		netif_stop_queue(dev);
+		door_bell = true;
 	}
 
 	if (door_bell)
-- 
2.22.0

