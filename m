Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178E01AFD24
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 20:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgDSSQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 14:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDSSQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 14:16:38 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD44C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 11:16:37 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x18so9331070wrq.2
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 11:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hOJKu6+hXN4oWwRYPk4f7modmHIuix1R+fKs55WqgOk=;
        b=jzi+WVUjjHzq7OMyz773c+P0Z8GblSi69AZlNhXmVFIm/tIl63lE/sJBn363L6+YHm
         Jlkqe7TMwVE/LxQm+XlQi02IkfEfU7WFZxxrbzMpa+ySJ1dIppWMuQXKUo3XQp264wbY
         XKoNEHW6DoQA+/U4Q2rUeP9wCDVHn9SQwJrWc7zNzQOlnMBxhUoYOR3//CPxy+eihc1E
         i82dhYR4e/t5fe0ZglGQbHnUwONkSDTYWKydeCAUmGh2V/fa9A79H4ZbS1EyYdJ7C1hP
         qufpkf2bfpGQs1UqiFTBxuRONZgFaWeLcysVY2dTm6L9zgzvEWt2zQ3wEFzLVu7A4rZ/
         ncbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hOJKu6+hXN4oWwRYPk4f7modmHIuix1R+fKs55WqgOk=;
        b=Ve6w1zepZwm0CWd34xVM4yWVPo2t8GCuY06bJAdryOVzHq6pjR7W08oKvZz+zD+O5l
         25pHrSUjhQImCB0qVjNzfNy3+hd2rnBUaOyi/3+CC7IeMHvv7nhqbEff1baIvYeQFtHx
         TaPy5W212ehdD2p+NUuPACgU3Q5T5vxTRv26c/HoUxV4VQDr/tDuIUwYcTt6ta+qCbMk
         281w92q7uq38tZaBcp0/KLKPKKLOuLi3IJwBhiKopSHekG0lfpsAF2Dzs5YShhj0WqxW
         5gBQJ4kh6hLyE7ixpBTyOuPv4jtbmPWdHHaKu253ftXKHy0DjtGq9DuqH8s+By2kNo6R
         1lcg==
X-Gm-Message-State: AGi0Pua7NuppzWPiv4JEEsyl6CRWj7ubFVE49gShsjznzsf+wP/vZHXG
        AJtpd93yJwDoZFUFIsVQiEIe8HBJ
X-Google-Smtp-Source: APiQypIz1p+oOrXTH6J9JZeTH1kpAv8qPoUB/YsyuGd1+VBTKb7hI53Q0NmcJRv17uFVddPsPjRoqg==
X-Received: by 2002:adf:e681:: with SMTP id r1mr15952532wrm.213.1587320196003;
        Sun, 19 Apr 2020 11:16:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id z16sm43438810wrl.0.2020.04.19.11.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 11:16:35 -0700 (PDT)
Subject: [PATCH net-next v2 1/3] r8169: use smp_store_mb in rtl_tx
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a7e1d491-bede-6f86-cff0-f2b74d8af2b3@gmail.com>
Message-ID: <788ff95b-9d2c-65c4-4271-025ed0339554@gmail.com>
Date:   Sun, 19 Apr 2020 20:14:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a7e1d491-bede-6f86-cff0-f2b74d8af2b3@gmail.com>
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


