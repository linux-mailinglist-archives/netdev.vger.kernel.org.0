Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A5D7733F
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfGZVKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:10:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55122 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbfGZVKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:10:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A02F612B0259E;
        Fri, 26 Jul 2019 14:10:53 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:10:53 -0700 (PDT)
Message-Id: <20190726.141053.972271542982124792.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     willy@infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Build fixes for skb_frag_size conversion
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAK8P3a1Ae3r=dOa-LSWxUEWH5qY4c8HfnGuT0y5BEL51tUCDOQ@mail.gmail.com>
References: <20190724113615.11961-1-willy@infradead.org>
        <CAK8P3a1Ae3r=dOa-LSWxUEWH5qY4c8HfnGuT0y5BEL51tUCDOQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jul 2019 14:10:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 25 Jul 2019 13:08:18 +0200

> On Wed, Jul 24, 2019 at 1:37 PM Matthew Wilcox <willy@infradead.org> wrote:
>>
>> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>>
>> I missed a few places.  One is in some ifdeffed code which will probably
>> never be re-enabled; the others are in drivers which can't currently be
>> compiled on x86.
>>
>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
>> diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
>> index cc12c78f73f1..46a6fcf1414d 100644
>> --- a/drivers/staging/octeon/ethernet-tx.c
>> +++ b/drivers/staging/octeon/ethernet-tx.c
>> @@ -284,7 +284,7 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
>>
>>                         hw_buffer.s.addr =
>>                                 XKPHYS_TO_PHYS((u64)skb_frag_address(fs));
>> -                       hw_buffer.s.size = fs->size;
>> +                       hw_buffer.s.size = skb_drag_size(fs);
>>                         CVM_OCT_SKB_CB(skb)[i + 1] = hw_buffer.u64;
>>                 }
>>                 hw_buffer.s.addr = XKPHYS_TO_PHYS((u64)CVM_OCT_SKB_CB(skb));
> 
> Kernelci noticed a build failure from a typo here:
> https://kernelci.org/build/id/5d3943f859b514103f688918/logs/

I just checked this into net-next:

====================
From 1fbf400b58fa70c35bf671ff640b83799e45388d Mon Sep 17 00:00:00 2001
From: "David S. Miller" <davem@davemloft.net>
Date: Fri, 26 Jul 2019 14:10:30 -0700
Subject: [PATCH] staging: octeon: Fix build failure due to typo.

drivers/staging/octeon/ethernet-tx.c:287:23: error: implicit declaration of function 'skb_drag_size'; did you mean 'skb_frag_size'? [-Werror=implicit-function-declaration]

From kernelci report:

	https://kernelci.org/build/id/5d3943f859b514103f688918/logs/

Fixes: 92493a2f8a8d ("Build fixes for skb_frag_size conversion")
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/staging/octeon/ethernet-tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 46a6fcf1414d..44f79cd32750 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -284,7 +284,7 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 
 			hw_buffer.s.addr =
 				XKPHYS_TO_PHYS((u64)skb_frag_address(fs));
-			hw_buffer.s.size = skb_drag_size(fs);
+			hw_buffer.s.size = skb_frag_size(fs);
 			CVM_OCT_SKB_CB(skb)[i + 1] = hw_buffer.u64;
 		}
 		hw_buffer.s.addr = XKPHYS_TO_PHYS((u64)CVM_OCT_SKB_CB(skb));
-- 
2.20.1

