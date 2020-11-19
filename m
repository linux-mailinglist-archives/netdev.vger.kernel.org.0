Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2652B9C68
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgKSVAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgKSVAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 16:00:19 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3506C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:00:18 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id c198so6572182wmd.0
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=J7z5q9WNXDeiH8uhYMuaqr+rh5gKUBaWmOqMamqD8fI=;
        b=PIN3jc7jWd3rnKh/DUD+mDFg6cZKSAccQJGWOEOiyxjTG1HU2Q88WGPpeJlfqUuOEq
         MFgS7xKzEK1nZ54xjVbRlknkI0+RXFmRJ9aWUFQnkgGRBstdhqPzj1AQuyUtNPmOcjTU
         34aLMEdwZ/+1LwbD3kxwQBm2pH7g38ghXvJkQmgOmGi2LCHJYK7Vv9tickma1aWzF6N3
         u+Umfu4h4gfgLhGi+p5DzWhd+o5WJq/fXsnXhIm5xo6jHHza/vucLK8LuvQ6BaGRnIp2
         RKW30xTKKvabhHONSUD7yqeSPRAn189IS77vKNc3dAhhNkECV/h/fVyvue2u/CXxlHwX
         cq1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=J7z5q9WNXDeiH8uhYMuaqr+rh5gKUBaWmOqMamqD8fI=;
        b=Y92X3mVvKrWkx/o3aHUY4q/oPqPKaUtZYp9CTmu88phn3aFyQq8/Uj4+o0sByYbM1B
         e4AslEQe587NvYEy8UkZycDZt3+M43E8ms5/5+Pdx+0bMJfpjQw0oNYxmdFcnP3xEgGj
         zbeL87+y05UyOtWT/1ijBfNLBO65O+NSZp0Yj4VrCQVwNsb+Y5XLNlpXuS1bMgv8tXTM
         TvkQ48lGy0a3g7Zbgy66uaDTkfoTPPLJdTjlxhkP25WRWMcApzh2F9H3MAleH7fkACI0
         5AF6btsDvBpauv4xXmho2gF5yeqq/u6vWz5zRn++KiD59F297it6rjUUZENHIICKgeY3
         V2Cg==
X-Gm-Message-State: AOAM533muAfzrEq+N8Q0y/BrikdEMMCEKUh4v0xdedbksqHG/1iiz+oe
        OE5aXDVT8ANQ7cRJ6iSaLlVsY67sXtI+Iw==
X-Google-Smtp-Source: ABdhPJxGB/Sp5x5RssP7suN9bq72zAIYwFbSTL6hXzlW0X4EuvDeM4/25PkBRDETAV9I/QME+GL8zw==
X-Received: by 2002:a1c:df8a:: with SMTP id w132mr6402385wmg.90.1605819617390;
        Thu, 19 Nov 2020 13:00:17 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:6d7c:9ea3:dfaa:d617? (p200300ea8f2328006d7c9ea3dfaad617.dip0.t-ipconnect.de. [2003:ea:8f23:2800:6d7c:9ea3:dfaa:d617])
        by smtp.googlemail.com with ESMTPSA id t13sm1676632wru.67.2020.11.19.13.00.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 13:00:16 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: reduce number of workaround doorbell rings
Message-ID: <0a15a83c-aecf-ab51-8071-b29d9dcd529a@gmail.com>
Date:   Thu, 19 Nov 2020 21:57:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some chip versions have a hw bug resulting in lost door bell rings.
To work around this the doorbell is also rung whenever we still have
tx descriptors in flight after having cleaned up tx descriptors.
These PCI(e) writes come at a cost, therefore let's reduce the number
of extra doorbell rings.
If skb is NULL then this means:
- last cleaned-up descriptor belongs to a skb with at least one fragment
  and last fragment isn't marked as sent yet
- hw is in progress sending the skb, therefore no extra doorbell ring
  is needed for this skb
- once last fragment is marked as transmitted hw will trigger
  a tx done interrupt and we come here again (with skb != NULL)
  and ring the doorbell if needed
Therefore skip the workaround doorbell ring if skb is NULL.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1acf7128c..7dd643f53 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4356,18 +4356,19 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		   int budget)
 {
 	unsigned int dirty_tx, bytes_compl = 0, pkts_compl = 0;
+	struct sk_buff *skb;
 
 	dirty_tx = tp->dirty_tx;
 
 	while (READ_ONCE(tp->cur_tx) != dirty_tx) {
 		unsigned int entry = dirty_tx % NUM_TX_DESC;
-		struct sk_buff *skb = tp->tx_skb[entry].skb;
 		u32 status;
 
 		status = le32_to_cpu(tp->TxDescArray[entry].opts1);
 		if (status & DescOwn)
 			break;
 
+		skb = tp->tx_skb[entry].skb;
 		rtl8169_unmap_tx_skb(tp, entry);
 
 		if (skb) {
@@ -4397,8 +4398,10 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 		 * too close. Let's kick an extra TxPoll request when a burst
 		 * of start_xmit activity is detected (if it is not detected,
 		 * it is slow enough). -- FR
+		 * If skb is NULL then we come here again once a tx irq is
+		 * triggered after the last fragment is marked transmitted.
 		 */
-		if (tp->cur_tx != dirty_tx)
+		if (tp->cur_tx != dirty_tx && skb)
 			rtl8169_doorbell(tp);
 	}
 }
-- 
2.29.2

