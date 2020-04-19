Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CD81AFCDC
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 19:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgDSRol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 13:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgDSRok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 13:44:40 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61EEC061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 10:44:39 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j1so3779579wrt.1
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 10:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lXTOWlwTGr+oC6p1l4xeWM2MUVEQYd96/dT0V72zNtI=;
        b=U5fs0NIpWmNgX/AowuwT7WDiwh53JkiE74kc/Ae6toLFHuDK0TklTYHnrMIqA4Efnn
         zSERvAt5Z14S2MKubUyXioBof+NX0Y0qXfy1aoQSbhZtgtyA3LpyYxq706gjHEY0iMwe
         rMyETDh404mzp6YdujE6yZ97j8e4ZUfHGnYYqqqNPzzWfOMermYEbXFATgQDzzxPtpa8
         wgGgGpsMjcM2Y8UYXl3ZGWvyqYTqdNS6QN16h2hCk5+H17tJWL+2i+wtqo9CmeUUaXgr
         T93neMWyy1QfgMGVN80THE4ICai+y+ZJEEx/vKt6PMILxvZlI+Wy9j1o7lA60QePyqnF
         5FcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lXTOWlwTGr+oC6p1l4xeWM2MUVEQYd96/dT0V72zNtI=;
        b=kqHVUHsnHDlKbDiX75Pf1afbGXJDD+7zUPXGRzOXc1Gk5CJbS5bonXHlAFfx5eArTw
         ZWpOdRddwfrxluTs9o5fTDB2DlEJaEXWNDoIP5K18iTd1XhDHpW1rNc3wEXVIKQ5/7D/
         RORFUhM4gXf6rPzewujZQMourOJUgR2kNZtwgmDRR6zgqWtB9DkSSWxmej9uGrIgVX84
         1uGDtRh9TD5XtuYxbz8M7Qly+p9YElW/QLAgIuVB9F2ZjEjODrQ/bL+pDQBAM4deW7t3
         hzRItUXpKIlavDDuD/34S2VOVGy88gFBIF2lCIqFql5pgYbi/zpY4MgfkafDk4jIAtAc
         lE5g==
X-Gm-Message-State: AGi0PuZyu3slnDJil3dnYL3zmZcdyPB2riNkPjwB4ax+aR7d0bEe+jXU
        BlA+BiQjBdeC4qdeWsRhebl26/YF
X-Google-Smtp-Source: APiQypL+LgWJvk+7mSRuJjvMXPkkjYS3OmHcPAVMkZ5uYPv3xQ+1l9/0t8IWtRHEg7Gc6QywIX6mCg==
X-Received: by 2002:a05:6000:10c2:: with SMTP id b2mr15518775wrx.118.1587318278219;
        Sun, 19 Apr 2020 10:44:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id k14sm41789390wrp.53.2020.04.19.10.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 10:44:37 -0700 (PDT)
Subject: [PATCH net-next 3/4] r8169: replace dma_rmb with READ_ONCE in rtl_rx
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c1df4a9e-6be8-d529-7eb0-ea5bdf2b77ec@gmail.com>
Message-ID: <ac49e4e3-241c-2796-9112-62e410e0bf6c@gmail.com>
Date:   Sun, 19 Apr 2020 19:42:29 +0200
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

We want to ensure that desc->opts1 is read before desc->opts2.
This doesn't require a full compiler barrier. READ_ONCE provides
the ordering guarantee we need.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 038cd6fde..df788063e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1548,7 +1548,7 @@ static inline u32 rtl8169_tx_vlan_tag(struct sk_buff *skb)
 
 static void rtl8169_rx_vlan_tag(struct RxDesc *desc, struct sk_buff *skb)
 {
-	u32 opts2 = le32_to_cpu(desc->opts2);
+	u32 opts2 = le32_to_cpu(READ_ONCE(desc->opts2));
 
 	if (opts2 & RxVlanTag)
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), swab16(opts2 & 0xffff));
@@ -4490,16 +4490,11 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 		struct RxDesc *desc = tp->RxDescArray + entry;
 		u32 status;
 
-		status = le32_to_cpu(desc->opts1);
+		/* Use READ_ONCE to order descriptor field reads */
+		status = le32_to_cpu(READ_ONCE(desc->opts1));
 		if (status & DescOwn)
 			break;
 
-		/* This barrier is needed to keep us from reading
-		 * any other fields out of the Rx descriptor until
-		 * we know the status of DescOwn
-		 */
-		dma_rmb();
-
 		if (unlikely(status & RxRES)) {
 			netif_info(tp, rx_err, dev, "Rx ERROR. status = %08x\n",
 				   status);
-- 
2.26.1


