Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C02324FB1
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 13:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhBYMLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 07:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhBYMLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 07:11:54 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDB8C061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:11:13 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id e10so4784809wro.12
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:reply-to:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Elk6XkroCvy6YDZtlzcazzq5EnmxSahtrCRPixJOSKQ=;
        b=ZtAMC2V0VcR42+wjwA4H3eAxtNacRvwFmrrkpegVmsuoMmvaaVoVzvCW0AEW7M45ZH
         UOCACS+my5DkA0YLxoCJswlhzD70TpW6R6GdJW2JLgvFn5fG7ZttoyMaKdV2E7oGpLYP
         Si2EwEbiZzTSeSUtd5NUUbF8LwUl9vf43KPTKdhIEUX0EIkIXldaoetQ15CFuC+Rc3CC
         aG/3WAc8M73W1wzm4r2gbEImAJiJ9SVCYhZ6uCHfLpXQAfaBxom6SvXapNFDY/fy+9WH
         s/X5mTW1TGBgsnr+UCSNvmSEw+1SZLgvikykKkvpVSECHqALTYiH8G4Z6ky0zNMFHvcI
         0wpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:subject:to:cc:references
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Elk6XkroCvy6YDZtlzcazzq5EnmxSahtrCRPixJOSKQ=;
        b=ElZTInTnQoAxn0rzd9E6IYU9J/e4vI42yY2FCr6HW5u1fTvaaLsWchbuMlivj6HiyQ
         +GqpXLTIic7pohxP8DWV9eBbOTqpbUnGmheQCxikPOy2m4NaXHwCxD6AqDdOMWtG7qRg
         6Vs896bbY+2RLvLU+Tj+1Nl3sGYor7TAsIWyJxOhJS8aswynK5bIF46rg8Khxj1d5g9k
         ObgwbQayAGSeLct0dPrUAwvP2p8t3dqm1g6pN6n5fC4Jv4cJqXPue/CK8igaQNbo1EE3
         jgm/YrPaTG136Fe16JAJdn7tSbPzIQ8vLDVSbG6UUGGBObwbakQ3y/3dZVBhg3afoCKw
         9KHA==
X-Gm-Message-State: AOAM530jueY81yP6uIYd7strDp1la0C9aBuN4fj2dGzsRmHFjNCyHrem
        FU75vx/aleIux2Nw9Wl5hnQvR7rqUFY=
X-Google-Smtp-Source: ABdhPJx2i045TU5mnHfbXmvONbyukZsIZCSDA+0N1+KE57sH6FqvEo8nub4xMCR8IevpMvWxOWr/XA==
X-Received: by 2002:adf:f7cc:: with SMTP id a12mr3203944wrq.54.1614255072541;
        Thu, 25 Feb 2021 04:11:12 -0800 (PST)
Received: from ?IPv6:2a00:23c5:5785:9a01:ad9a:ab78:5748:a7ec? ([2a00:23c5:5785:9a01:ad9a:ab78:5748:a7ec])
        by smtp.gmail.com with ESMTPSA id g1sm7018230wmh.9.2021.02.25.04.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 04:11:12 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Reply-To: paul@xen.org
Subject: Re: [PATCH] xen-netback: correct success/error reporting for the
 SKB-with-fraglist case
To:     Jan Beulich <jbeulich@suse.com>
Cc:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Liu <wl@xen.org>
References: <4dd5b8ec-a255-7ab1-6dbf-52705acd6d62@suse.com>
 <67bc0728-761b-c3dd-bdd5-1a850ff79fbb@xen.org>
 <76c94541-21a8-7ae5-c4c4-48552f16c3fd@suse.com>
Message-ID: <17e50fb5-31f7-60a5-1eec-10d18a40ad9a@xen.org>
Date:   Thu, 25 Feb 2021 12:11:11 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <76c94541-21a8-7ae5-c4c4-48552f16c3fd@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/02/2021 07:33, Jan Beulich wrote:
> On 24.02.2021 17:39, Paul Durrant wrote:
>> On 23/02/2021 16:29, Jan Beulich wrote:
>>> When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
>>> special considerations for the head of the SKB no longer apply. Don't
>>> mistakenly report ERROR to the frontend for the first entry in the list,
>>> even if - from all I can tell - this shouldn't matter much as the overall
>>> transmit will need to be considered failed anyway.
>>>
>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>>
>>> --- a/drivers/net/xen-netback/netback.c
>>> +++ b/drivers/net/xen-netback/netback.c
>>> @@ -499,7 +499,7 @@ check_frags:
>>>    				 * the header's copy failed, and they are
>>>    				 * sharing a slot, send an error
>>>    				 */
>>> -				if (i == 0 && sharedslot)
>>> +				if (i == 0 && !first_shinfo && sharedslot)
>>>    					xenvif_idx_release(queue, pending_idx,
>>>    							   XEN_NETIF_RSP_ERROR);
>>>    				else
>>>
>>
>> I think this will DTRT, but to my mind it would make more sense to clear
>> 'sharedslot' before the 'goto check_frags' at the bottom of the function.
> 
> That was my initial idea as well, but
> - I think it is for a reason that the variable is "const".
> - There is another use of it which would then instead need further
>    amending (and which I believe is at least part of the reason for
>    the variable to be "const").
> 

Oh, yes. But now that I look again, don't you want:

if (i == 0 && first_shinfo && sharedslot)

? (i.e no '!')

The comment states that the error should be indicated when the first 
frag contains the header in the case that the map succeeded but the 
prior copy from the same ref failed. This can only possibly be the case 
if this is the 'first_shinfo' (which is why I still think it is safe to 
unconst 'sharedslot' and clear it).

   Paul


> Jan
> 

