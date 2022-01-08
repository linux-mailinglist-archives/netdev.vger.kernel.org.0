Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D668D488440
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 16:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbiAHPjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 10:39:03 -0500
Received: from mx3.wp.pl ([212.77.101.9]:36817 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229582AbiAHPjC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jan 2022 10:39:02 -0500
Received: (wp-smtpd smtp.wp.pl 21519 invoked from network); 8 Jan 2022 16:38:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1641656339; bh=JDyJZijKbzW/bA7FC6rgs8PEPxMktxgfUDwI1yY3boY=;
          h=Subject:To:Cc:From;
          b=kSp9n64uVvCLz0YOxw2Sj5/YIi5HOysIrl+2Ccm5aScRw7NLM+v72Ky5OEgdWwNXq
           cu3WkkmZKSr0IGtmuW2O9vjLCimOZ0wnLGXFw//aTd/ziJGkOnPA8X/92iPEI5j9p/
           pTiafA3kAp87ZLOU69hh0xTo9miTDqxBwuu48BQc=
Received: from riviera.nat.ds.pw.edu.pl (HELO [192.168.3.133]) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <joe@perches.com>; 8 Jan 2022 16:38:59 +0100
Message-ID: <dd6bc95f-ee94-b9b4-35ba-1a4284d96049@wp.pl>
Date:   Sat, 8 Jan 2022 16:38:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next] net: lantiq_etop: add blank line after
 declaration
Content-Language: en-US
To:     Joe Perches <joe@perches.com>, davem@davemloft.net,
        kuba@kernel.org, rdunlap@infradead.org, jgg@ziepe.ca,
        arnd@arndb.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>
References: <20211228220031.71576-1-olek2@wp.pl>
 <fc1bf93d92bb5b2f99c6c62745507cc22f3a7b2d.camel@perches.com>
From:   Aleksander Bajkowski <olek2@wp.pl>
In-Reply-To: <fc1bf93d92bb5b2f99c6c62745507cc22f3a7b2d.camel@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-WP-MailID: d31c9a37df5b2af05e9d7f5ec7fba301
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000B [IRMk]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,

On 1/8/22 09:04, Joe Perches wrote:
> (adding John Crispin, the original submitter of this driver)
> 
> On Tue, 2021-12-28 at 23:00 +0100, Aleksander Jan Bajkowski wrote:
>> This patch adds a missing line after the declaration and
>> fixes the checkpatch warning:
>>
>> WARNING: Missing a blank line after declarations
>> +		int desc;
>> +		for (desc = 0; desc < LTQ_DESC_NUM; desc++)
>>
>> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> []
>> diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
> []
>> @@ -218,6 +218,7 @@ ltq_etop_free_channel(struct net_device *dev, struct ltq_etop_chan *ch)
>>  		free_irq(ch->dma.irq, priv);
>>  	if (IS_RX(ch->idx)) {
>>  		int desc;
>> +
>>  		for (desc = 0; desc < LTQ_DESC_NUM; desc++)
>>  			dev_kfree_skb_any(ch->skb[ch->dma.desc]);
>>  	}
> 
> The change is innocuous and has already been applied but the code
> doesn't seem to make sense.
> 
> Why is dev_kfree_skb_any called multiple times with the same argument?
> 
> Is there some missing logic here?  Maybe a missing ++?
> 
> Something like:
> 
> 		for (desc = 0; desc < LTQ_DESC_NUM; desc++)
>  			dev_kfree_skb_any(ch->skb[ch->dma.desc++]);
> 
> Dunno, but the current code seems wrong.
> 
> 


FYI: This driver is mainly used by OpenWRT. OpenWRT has two
patches that were never upstreamed. One of them is called
"various etop fixes" and I would expect more bugs in this driver.
The part that adds support for ar9 must be rewritten before
upstreaming. This SoC has a built-in 2 port switch and needs
a DSA driver. The rest of the fixes in this patch can probably
be sent upstream.


1. https://github.com/abajk/openwrt/blob/master/target/linux/lantiq/patches-5.10/0028-NET-lantiq-various-etop-fixes.patch
2. https://github.com/abajk/openwrt/blob/master/target/linux/lantiq/patches-5.10/0701-NET-lantiq-etop-of-mido.patch
