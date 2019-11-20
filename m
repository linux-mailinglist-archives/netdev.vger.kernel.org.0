Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3C51040CB
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 17:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731450AbfKTQ3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 11:29:15 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40734 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729442AbfKTQ3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 11:29:14 -0500
Received: by mail-pj1-f65.google.com with SMTP id ep1so60827pjb.7
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 08:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=Wla9NseeUHR+EPcmdshjtdS4HCXhniVpIUFykPTVAUo=;
        b=mJ1SW4P4iGbfrmI+ZsEeXyCQa+CGxcCIBqeUvSLb+CnMXBMQoUg0/D3wy6b3rf9ydC
         zO8f0mKWiRoq1ty2/+9VXhMHlwQ5BvlKU+/RbUKE9w7lbfG3S8SntPygXMywN0+pBemf
         Vs9xenTuuZeWN9di7E+mZeWPCofal+Rxf7bZyaWeCadlSS2nQ974mHpD8gmzImFuhK2A
         TYE4DnEMr3vTpW1NWh15hAJu2KZ3q5ExS99xXOZe32C78awU+wVU8gzaiWSfbL1aUIvw
         u0rRWBHJhV2dDfoQbGfRvMf/5ItinAm+mQkD7a1PnWhQCVJNPSuDFdIFekouv1ukorP9
         TJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=Wla9NseeUHR+EPcmdshjtdS4HCXhniVpIUFykPTVAUo=;
        b=g7Rjo8NGV7kCdhUtO7WbglVHLJiiYKHWQXmDb10xlQygIpp1gdTQpuIEPxtYEy9aFb
         jVitCIh1eEC2/5WAkZ2wXofccQIGtqudIRllFjAw0xmeat361Y9sHSGjinNTKp8pS8dS
         nbE5gjE5DTZkEaBedZyHuqwGZgpRVULbW7byqDpvt0dJKVlJJ4E/BYAzOizBbxPc5ynv
         D11rR0tibTqtPXycQePSYzHtroeAa/uayvRdakNVCVX1rn2IMS9pw5bxBpnCXRORrNAr
         8Rw3C8njoKwMR7TTJqNnluzS8zhr5d1eN0J1XPr3yevLS2ltJF0aGZTxf5X93Ybz5qAY
         PmQQ==
X-Gm-Message-State: APjAAAU8zcDoZbHivo2pFfygBWNjf7oaoalb9X9RYFsdbeAvKqeRj+2p
        FyqCvnybh2BtBC5ixaqPrDDkWc4D
X-Google-Smtp-Source: APXvYqwcgom1r3l1BfIl3dHiDg/+GWJJk44eD9SEfQCIsM2MUALFYUgibMPVnph8VHPnIgSEp7d4/A==
X-Received: by 2002:a17:90a:4fe6:: with SMTP id q93mr5207774pjh.88.1574267354074;
        Wed, 20 Nov 2019 08:29:14 -0800 (PST)
Received: from [172.26.111.194] ([2620:10d:c090:180::1a00])
        by smtp.gmail.com with ESMTPSA id h195sm32399355pfe.88.2019.11.20.08.29.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 08:29:13 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Lorenzo Bianconi" <lorenzo.bianconi@redhat.com>
Cc:     "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, ilias.apalodimas@linaro.org, mcroce@redhat.com
Subject: Re: [PATCH v4 net-next 3/3] net: mvneta: get rid of huge dma sync in
 mvneta_rx_refill
Date:   Wed, 20 Nov 2019 08:29:11 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <F768E1EB-8F66-4437-AE1E-1A9E8452BDC1@gmail.com>
In-Reply-To: <20191120092120.GA2538@localhost.localdomain>
References: <cover.1574083275.git.lorenzo@kernel.org>
 <7bd772e5376af0c55e7319b7974439d4981aa167.1574083275.git.lorenzo@kernel.org>
 <20191119123850.5cd60c0e@carbon>
 <20191119121911.GC3449@localhost.localdomain>
 <20191119155143.0683f754@carbon>
 <20191119153827.GE3449@localhost.localdomain>
 <188EF030-DAB4-4FD0-AFD1-107C24A10943@gmail.com>
 <20191120092120.GA2538@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20 Nov 2019, at 1:21, Lorenzo Bianconi wrote:

>> On 19 Nov 2019, at 7:38, Lorenzo Bianconi wrote:
>>
>>> [...]
>>>>>>> -		page_pool_recycle_direct(rxq->page_pool,
>>>>>>> -					 virt_to_head_page(xdp->data));
>>>>>>> +		__page_pool_put_page(rxq->page_pool,
>>>>>>> +				     virt_to_head_page(xdp->data),
>>>>>>> +				     xdp->data_end - xdp->data_hard_start,
>>>>>>> +				     true);
>>>>>>
>>>>>> This does beg for the question: Should we create an API wrapper 
>>>>>> for
>>>>>> this in the header file?
>>>>>>
>>>>>> But what to name it?
>>>>>>
>>>>>> I know Jonathan doesn't like the "direct" part of the
>>>>>> previous function
>>>>>> name page_pool_recycle_direct.  (I do considered calling
>>>>>> this 'napi'
>>>>>> instead, as it would be inline with networking use-cases,
>>>>>> but it seemed
>>>>>> limited if other subsystem end-up using this).
>>>>>>
>>>>>> Does is 'page_pool_put_page_len' sound better?
>>>>>>
>>>>>> But I want also want hide the bool 'allow_direct' in the API 
>>>>>> name.
>>>>>> (As it makes it easier to identify users that uses this from
>>>>>> softirq)
>>>>>>
>>>>>> Going for 'page_pool_put_page_len_napi' starts to be come
>>>>>> rather long.
>>>>>
>>>>> What about removing the second 'page'? Something like:
>>>>> - page_pool_put_len_napi()
>>>>
>>>> Well, we (unfortunately) already have page_pool_put(), which is 
>>>> used
>>>> for refcnt on the page_pool object itself.
>>>
>>> __page_pool_put_page(pp, data, len, true) is a more generic version 
>>> of
>>> page_pool_recycle_direct where we can specify even the length. So 
>>> what
>>> about:
>>>
>>> - page_pool_recycle_len_direct
>>> - page_pool_recycle_len_napi
>>
>> I'd suggest:
>>
>> /* elevated refcounts, page may seen by networking stack */
>> page_pool_drain(pool, page, count)              /* non napi, len = -1 
>> */
>> page_pool_drain_direct(pool, page, count)       /* len = -1 */
>>
>> page_pool_check_put_page(page)                  /* may not belong to 
>> pool */
>>
>> /* recycle variants drain/expect refcount == 1 */
>> page_pool_recycle(pool, page, len)
>> page_pool_recycle_direct(pool, page, len)
>>
>> page_pool_put_page(pool, page, len, mode)	    /* generic, for 
>> __xdp_return
>
> I am not against the suggestion but personally I would prefer to 
> explicitate in
> the routine name where/how it is actually used. Moreover 
> page_pool_recycle_direct or
> page_pool_put_page are currently used by multiple drivers and it seems 
> to me
> out of the scope of this series. I think we can address it in a 
> follow-up series
> and use __page_pool_put_page for the moment (it is actually just used 
> by mvneta).
> Agree?

Fine with me - I have a naming cleanup patch pending, I can roll it into
this afterwards.
-- 
Jonathan
