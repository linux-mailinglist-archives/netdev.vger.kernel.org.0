Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7EF2B3095
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 21:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgKNUQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 15:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgKNUQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 15:16:17 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBBEC0613D1;
        Sat, 14 Nov 2020 12:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=pe7tFvBv1g4PMKXTwwbxmGziSUNNmw4hslJpP7t6A1g=; b=BfHJnKj218BveLTnZUcr/58FGX
        FKwsMppg7fNZVpo83kMewCQfCzy8wHa725c5rRBkOTVf1LR3iDdiYmbEDFJWAPCxb4XsacN9bzLLj
        GDsTleha9//trDxwq5HAFCjXzR1cwutpBh4Dz5EhY4BszxDM4hlSGbBkqqmdSyquxv4HnAjkN+Kid
        07/TIonBMDlm1K8x8lOe+qabymhFANqK+tZS6XJ+xy27oEXinOioJToCHn7MfGuRJ+aCvBsBR2DaX
        1s84ETCkA5DuhOu730jlboLiRx+5EeQLqPbDypCUz38pLa0z1NnHCzAkjgaBa1WHegz0fPLqpI65m
        FwnXa2uw==;
Received: from [2601:1c0:6280:3f0::f32]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ke1y1-0005z9-0M; Sat, 14 Nov 2020 20:16:13 +0000
Subject: Re: [PATCH net-next v2] net: linux/skbuff.h: combine SKB_EXTENSIONS +
 KCOV handling
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-next@vger.kernel.org, netdev@vger.kernel.org
References: <20201114174618.24471-1-rdunlap@infradead.org>
 <20201114115437.55eed094@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <eab5982c-c03e-5001-abf7-052588dfa089@infradead.org>
Date:   Sat, 14 Nov 2020 12:16:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201114115437.55eed094@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/20 11:54 AM, Jakub Kicinski wrote:
> On Sat, 14 Nov 2020 09:46:18 -0800 Randy Dunlap wrote:
>> The previous Kconfig patch led to some other build errors as
>> reported by the 0day bot and my own overnight build testing.
>>
>> These are all in <linux/skbuff.h> when KCOV is enabled but
>> SKB_EXTENSIONS is not enabled, so fix those by combining those conditions
>> in the header file.
>>
>> Fixes: 6370cc3bbd8a ("net: add kcov handle to skb extensions")
>> Fixes: 85ce50d337d1 ("net: kcov: don't select SKB_EXTENSIONS when there is no NET")
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Cc: Aleksandr Nogikh <nogikh@google.com>
>> Cc: Willem de Bruijn <willemb@google.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: linux-next@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> ---
>> v2: (as suggested by Matthieu Baerts <matthieu.baerts@tessares.net>)
>>   drop an extraneous space in a comment;
>>   use CONFIG_SKB_EXTENSIONS instead of CONFIG_NET;
> 
> Thanks for the fix Randy!
> 
>> --- linux-next-20201113.orig/include/linux/skbuff.h
>> +++ linux-next-20201113/include/linux/skbuff.h
>> @@ -4151,7 +4151,7 @@ enum skb_ext_id {
>>  #if IS_ENABLED(CONFIG_MPTCP)
>>  	SKB_EXT_MPTCP,
>>  #endif
>> -#if IS_ENABLED(CONFIG_KCOV)
>> +#if IS_ENABLED(CONFIG_KCOV) && IS_ENABLED(CONFIG_SKB_EXTENSIONS)
> 
> I don't think this part is necessary, this is already under an ifdef:
> 
> #ifdef CONFIG_SKB_EXTENSIONS
> enum skb_ext_id {
> 
> if I'm reading the code right.

Oops, you are correct. Sorry I missed that.


> That said I don't know why the enum is under CONFIG_SKB_EXTENSIONS in
> the first place.
> 
> If extensions are not used doesn't matter if we define the enum and with
> how many entries.
> 
> At the same time if we take the enum from under the ifdef and add stubs
> for skb_ext_add() and skb_ext_find() we could actually remove the stubs
> for kcov-related helpers. That seems cleaner and less ifdefy to me.
> 
> WDYT?

Good thing I am on my third cup of coffee.

OK, it looks like that should work -- with less #ifdef-ery.

I'll work at it...


>>  	SKB_EXT_KCOV_HANDLE,
>>  #endif
>>  	SKB_EXT_NUM, /* must be last */
>> @@ -4608,7 +4608,7 @@ static inline void skb_reset_redirect(st
>>  #endif
>>  }
>>  
>> -#ifdef CONFIG_KCOV
>> +#if IS_ENABLED(CONFIG_KCOV) && IS_ENABLED(CONFIG_SKB_EXTENSIONS)
>>  static inline void skb_set_kcov_handle(struct sk_buff *skb,
>>  				       const u64 kcov_handle)
>>  {
>> @@ -4636,7 +4636,7 @@ static inline u64 skb_get_kcov_handle(st
>>  static inline void skb_set_kcov_handle(struct sk_buff *skb,
>>  				       const u64 kcov_handle) { }
>>  static inline u64 skb_get_kcov_handle(struct sk_buff *skb) { return 0; }
>> -#endif /* CONFIG_KCOV */
>> +#endif /* CONFIG_KCOV && CONFIG_SKB_EXTENSIONS */
>>  
>>  #endif	/* __KERNEL__ */
>>  #endif	/* _LINUX_SKBUFF_H */
> 

thanks.
-- 
~Randy

