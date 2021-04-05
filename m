Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F09354508
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 18:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242331AbhDEQRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 12:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238609AbhDEQRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 12:17:41 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B95C061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 09:17:33 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso6103543pjh.2
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 09:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=tR1ZLiRK+PAehFiDOulLPllAICg8U6vjKvk1ZWvrX/4=;
        b=rd8xKB2waNzqKOl/pXRJlA6YdDUb7jio3qP0u+GPidhv36E0KKpdlOaHOZ3wtfoL80
         swpQpKicsh4II2MAxEq2aPRQm04+Ui2T+gn2dMse5JxWW+poEv/Sroc2U5c26ZFPa5my
         xndzDxSyxPA4sGsFKk4W0YLTnYFFzV0yfwmqVNlyRRbGLHAxPwKH1dD6LNWzF3ss9SZa
         hh70/PEi9U5HM6xNhEnVFqZNL9ZrczXPBpfPFcE5rUWANWhw6UgZHOCi2mMwSNi6y44p
         ahSgvjQyh8kzYvq3SiYs6DAkSDhIpM4vKD9HAKLJtLmE1dXJT2wXq2a2PpXmaqbNRxDe
         kubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tR1ZLiRK+PAehFiDOulLPllAICg8U6vjKvk1ZWvrX/4=;
        b=fyvABYdfp6UuWpjtvWk8p68IXruybrsw5xnpXj9ekBZ3lHWI1iebMOiE8a2xXqmaKK
         kIsOmYVgDturL5SofX2srpK1xrnmi+ccdaMM99nP0Uqn1AQF8US03xbSShYDom7F+pUT
         LrUem0sFk94Cou/5e7V6fYRg+4cqYgSnNa/IBkxsBoGKRrt+JKrgl6utCmn6ex6liwFU
         +qUDXTPFO/8x9FuUtiZmglOTkL1NN1f2//sD6FN/vNOVy5fR13GTFZWhOo6LQLHZ0JBy
         NWZBqvW82KuCdHE9YJiAe7+TnWDyv3xEqNqJCGIc5tunfJw0q2PseSrS3TsORC+/BQ4F
         3ngg==
X-Gm-Message-State: AOAM532qNDWxTS2qVOGX4oEoNMMJoHQmDwuT0NOAJJ9JeFDxX3bUw9TE
        y6QThGJg+FzTwhp0dM1HjysjVA==
X-Google-Smtp-Source: ABdhPJxbaxA6JQIzHA+VZtRQ+RO8iFLYw2jykzsBdG4Th0I3hpppIDgmVaKFfxycoov2iIfngxdsdQ==
X-Received: by 2002:a17:902:e5d2:b029:e9:3900:558f with SMTP id u18-20020a170902e5d2b02900e93900558fmr233403plf.15.1617639453545;
        Mon, 05 Apr 2021 09:17:33 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id m7sm16867125pjc.54.2021.04.05.09.17.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 09:17:33 -0700 (PDT)
Subject: Re: [PATCH net-next 02/12] ionic: add handling of larger descriptors
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-3-snelson@pensando.io>
 <20210404225049.GA24720@hoboy.vegasvil.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <decfa346-8836-a1d4-1739-250b88e598ef@pensando.io>
Date:   Mon, 5 Apr 2021 09:17:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210404225049.GA24720@hoboy.vegasvil.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/4/21 3:50 PM, Richard Cochran wrote:
> On Thu, Apr 01, 2021 at 10:56:00AM -0700, Shannon Nelson wrote:
>> @@ -1722,11 +1722,15 @@ static void ionic_txrx_free(struct ionic_lif *lif)
>>   
>>   static int ionic_txrx_alloc(struct ionic_lif *lif)
>>   {
>> -	unsigned int sg_desc_sz;
>> +	unsigned int num_desc, desc_sz, comp_sz, sg_desc_sz;
>>   	unsigned int flags;
>>   	unsigned int i;
> Coding Style nit: List of ints wants alphabetically order,
> List can also fir 'flags' and 'i' with the others.
>
>> @@ -2246,9 +2258,9 @@ static void ionic_swap_queues(struct ionic_qcq *a, struct ionic_qcq *b)
>>   int ionic_reconfigure_queues(struct ionic_lif *lif,
>>   			     struct ionic_queue_params *qparam)
>>   {
>> +	unsigned int num_desc, desc_sz, comp_sz, sg_desc_sz;
>>   	struct ionic_qcq **tx_qcqs = NULL;
>>   	struct ionic_qcq **rx_qcqs = NULL;
>> -	unsigned int sg_desc_sz;
>>   	unsigned int flags;
> Ditto.
>
> Thanks,
> Richard

I can tweak this is a followup patch.  Thanks for your review time.
sln

