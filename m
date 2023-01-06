Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CB8660A4E
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 00:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjAFXe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 18:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjAFXe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 18:34:56 -0500
Received: from mx06lb.world4you.com (mx06lb.world4you.com [81.19.149.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0575844C63
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 15:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SU0GQh0R6jCiVAkiFNG036kUh04UYzVx0hDMcGUGHIc=; b=EAw1i6A2zDJnjoL6UWQ2v9RMBR
        dt6NoXSXkiQjx1jPv2m1NPIKd/pXP/n1Y0Jl1kYwLfwg3z40F2QFHGsnlVywvX/YaPrecJt2YC+bP
        MfE3hzEkyhGpcyLKrJE504Z+fSp0iYQxkg0uKMQuNRIBq1R1iHT/UW69W/bcNP7g9iVw=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx06lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pDwER-0003mY-0k;
        Sat, 07 Jan 2023 00:34:39 +0100
Message-ID: <4f6bccd7-a117-fbae-cd1b-26db1d2a958f@engleder-embedded.com>
Date:   Sat, 7 Jan 2023 00:34:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v3 4/9] tsnep: Add XDP TX support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
 <20230104194132.24637-5-gerhard@engleder-embedded.com>
 <0d4b78ab-603d-e39d-f804-4f5d2f8efab8@intel.com>
 <01d5398f-84a1-0fbe-e815-76f9f2c3e022@engleder-embedded.com>
 <20230106141346.73f7c925@kernel.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20230106141346.73f7c925@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.01.23 23:13, Jakub Kicinski wrote:
> On Thu, 5 Jan 2023 22:13:00 +0100 Gerhard Engleder wrote:
>>>> -	if (entry->skb) {
>>>> +	if (entry->skb || entry->xdpf) {
>>>>    		entry->properties = length & TSNEP_DESC_LENGTH_MASK;
>>>>    		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
>>>> -		if (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
>>>> +		if (entry->type == TSNEP_TX_TYPE_SKB &&
>>>> +		    skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS)
>>>
>>> Please enclose bitops (& here) hanging around any logical ops (&& here
>>> in their own set of braces ().
>>
>> Will be done.
> 
> Dunno if that's strictly required in the kernel coding style.
> Don't we expect a good understanding of operator precedence
> from people reading the code?

checkpatch accepts both and I found no ruling in coding-style.rst.
I also found both styles in Ethernet drivers. checkpatch often
complained about unnecessary braces in my code, so I assumed less
braces are welcome. This fits to that a good understanding of operator
precedence is expected.

Gerhard
