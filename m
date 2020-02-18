Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1172C1632D8
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgBRURH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:17:07 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52411 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgBRUQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:16:18 -0500
Received: by mail-wm1-f65.google.com with SMTP id p9so4102462wmc.2;
        Tue, 18 Feb 2020 12:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=faBVqPTcYPP2mJjHh2h8k1eNwReQK/o/MeBiESpq7Co=;
        b=Gv2OvzIvDKL8C1oLMCAExLfw7s1uXTT3LNrkPFqKMKXwvGKdHVIT1c8O/JqoX2e1jL
         FbvEgOprTF3QVHY59MVQOeXD2JY0nN6946HVq4Ie9YSLpI0YPyThjHdbtvW5bPeoEoIB
         feodXJDktTZAzvJ02ibilJ/Idf5sb3RGSNTC9NP63HePr80rz66jEbnM31tPDRBlZ609
         GZbJcqJsLoC7qsHSpZmoj87W0l7xSOYXnUbWQP7JsKoKta0cFJvNmQi+3veWQMSMCZ0Y
         SRa9oi92JkhNm6KJ8W8sjcSd6aTOPnJG0p8NxMJXc7A3pxEZz10vrDlxCaZ+foWwKz2Y
         7OfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=faBVqPTcYPP2mJjHh2h8k1eNwReQK/o/MeBiESpq7Co=;
        b=L0CZrZ++7Qy645IqXkg8WjAo0JjgLCOpAVFppOGNjgLmFUEtWXrUKBtcn+JeaOE2Qg
         2l+DBVn/VKncnFi+DuMsBNzYZgYg7l4E9EeGxW1s3d56S17BRyodnyMo0TI/aL63pjik
         dRKhh1RfYSXgKWd4Xpcvlz2MH17hDRsmxKeAN7WNGRJmBZwAp499FG+mSLyPtSqGkyEe
         NhA64oXAjIMjUtWc2blCjZWSeblhrZWrqOj9yQuIwBNHfmKVIYDeMIDcScd3qFphtQpL
         auCwOH1ovbzrQeMP7VI/WyJMAmD+VC7vNM/M5FvIU2/FgxC/4NkCegT6AdBwoy8TSKS7
         r5jg==
X-Gm-Message-State: APjAAAWwRvNwaL92TS127FVl7Q9O3/QvQomSWKy3baBremoJBmn5YPjQ
        kpIOYwh4NV5lAgRFJ2S49YawN61b
X-Google-Smtp-Source: APXvYqwj9n0AWyFCf7wlztQVh7m87fwQMuFHKD3sMCvi3AvICoXSkgax7knIe2MzB3xz8/JcsHTpvw==
X-Received: by 2002:a1c:ded7:: with SMTP id v206mr5112438wmg.106.1582056976440;
        Tue, 18 Feb 2020 12:16:16 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id h128sm5112270wmh.33.2020.02.18.12.16.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 12:16:16 -0800 (PST)
Subject: [PATCH net-next v2 08/13] ionic: use new helper tcp_v6_gso_csum_prep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Message-ID: <6960380e-cee3-b65c-010f-551635cb3988@gmail.com>
Date:   Tue, 18 Feb 2020 21:07:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new helper tcp_v6_gso_csum_prep in additional network drivers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index e452f4242..020acc300 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -632,10 +632,7 @@ static int ionic_tx_tcp_pseudo_csum(struct sk_buff *skb)
 					   ip_hdr(skb)->daddr,
 					   0, IPPROTO_TCP, 0);
 	} else if (skb->protocol == cpu_to_be16(ETH_P_IPV6)) {
-		tcp_hdr(skb)->check =
-			~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-					 &ipv6_hdr(skb)->daddr,
-					 0, IPPROTO_TCP, 0);
+		tcp_v6_gso_csum_prep(skb);
 	}
 
 	return 0;
-- 
2.25.1


