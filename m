Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CACC1AFCDB
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 19:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgDSRoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 13:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgDSRoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 13:44:38 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8F0C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 10:44:38 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k1so9221343wrx.4
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 10:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hOJKu6+hXN4oWwRYPk4f7modmHIuix1R+fKs55WqgOk=;
        b=JSby5esjSkoPk51QNFnWooYwRIuxK/1AmCRj3osEmyLP14oNp6p0MS4kS4yiiqjSvf
         LRbOtY+KmKxiO5S0+xOLaVitcZ3ZB+izirRXdvtafNSWWbnQ9DrX7G09IpTiaXMuYIPO
         VTHXToJY5vpWKsVKtPlfFzXMJbZzXDcy6IU/rTcRxCy75bhRyVRMyMZf9LUD/NkKY9A0
         bI/iRqC0ErMPNWCsOJthw1p/ysJ5BfqEvcFckndHnbroh7uLYFDYsEQIUvyW8kkhKBfY
         +KADyFwZAUfVkPr+MYwj0QvB3KoHeUM/EBAp1hwgHu77Bc2881qaz5zb30cCD9BPjqp4
         byOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hOJKu6+hXN4oWwRYPk4f7modmHIuix1R+fKs55WqgOk=;
        b=IlXHrrsASywqaijC2KBGnqFZJEWOMespSUuCHR7VONMEyHi3X65nihsBupZVgYuSYq
         zNpzKmvrEn6hqPfRDFN+KAVVfFhTx2XI4CwcDpBI2Hl+0mDm329q/JmAs5jIYgW9MPN3
         mkd04X5muou+VvICPl27rBr253LWL7YWbL7I16YYuQrtKk6EL132EeQxTF4KlwIBmXu7
         JQAUiV+O+Z01TySeaEbxgOk5QlZdbM4mtOpDJM84uDmluYGO+2Pq9vogXZQSkfgwmPAv
         C84Cmuzj6IQKPODOyXdi1ut3Wx+rRSTSYoqQM3B4ZD8ILjbu0gDPFzn0KUTX9xmHOgaI
         rGGw==
X-Gm-Message-State: AGi0PubJAKrRE+ONWSWc0v1uEVyvvA5lCSw/klq6LIJXVgEkEDMAJcbz
        pSpvOkiez9S/ed+MTb3MivWVq2p1
X-Google-Smtp-Source: APiQypKCSWJMsQXUmIYC7CpzljcpBbJwgV1tAB065QH7q2yzIzlVavohfOsU9E1kRIZ/6cHqsOipEw==
X-Received: by 2002:a05:6000:1008:: with SMTP id a8mr14967587wrx.189.1587318276431;
        Sun, 19 Apr 2020 10:44:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id v7sm13320195wmg.3.2020.04.19.10.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 10:44:35 -0700 (PDT)
Subject: [PATCH net-next 1/4] r8169: use smp_store_mb in rtl_tx
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c1df4a9e-6be8-d529-7eb0-ea5bdf2b77ec@gmail.com>
Message-ID: <d2cfa4e2-d0f1-c13f-d7e7-09c999037ece@gmail.com>
Date:   Sun, 19 Apr 2020 19:39:03 +0200
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

Use helper smp_store_mb() instead of open-coding the functionality.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1bc415d00..dd6113fd7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4438,7 +4438,6 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		tp->tx_stats.bytes += bytes_compl;
 		u64_stats_update_end(&tp->tx_stats.syncp);
 
-		tp->dirty_tx = dirty_tx;
 		/* Sync with rtl8169_start_xmit:
 		 * - publish dirty_tx ring index (write barrier)
 		 * - refresh cur_tx ring index and queue status (read barrier)
@@ -4446,7 +4445,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		 * a racing xmit thread can only have a right view of the
 		 * ring status.
 		 */
-		smp_mb();
+		smp_store_mb(tp->dirty_tx, dirty_tx);
 		if (netif_queue_stopped(dev) &&
 		    rtl_tx_slots_avail(tp, MAX_SKB_FRAGS)) {
 			netif_wake_queue(dev);
-- 
2.26.1


