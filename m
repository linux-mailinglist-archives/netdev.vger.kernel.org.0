Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2124CEF03
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 00:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfJGWWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 18:22:34 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37990 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbfJGWWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 18:22:34 -0400
Received: by mail-pf1-f195.google.com with SMTP id h195so9546726pfe.5;
        Mon, 07 Oct 2019 15:22:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PdkJ4Z+HzytIxudQqsDlaQKJxjFii3sZzUB2db98gvY=;
        b=ZJ71WyEP5XXMr+1aiGaBVryqG0NdieaiYHaC82iND4CyN9GpJd53Yw4fpivjtxh+0E
         OCdYe3U01uELX/6k650grCMVFJe32yudWjgh2eCFJe452kaEPiE/eKq+ioCDW9RpGozc
         2UzhxRAlvoX/xtjqMkZ0/hlG5yP6rmTbRgALrKOUJLqpGEvWYo3bmAD6XSbiEpp/g3rz
         S7xQG11e0pA2dqAECRhP9OKjD7HX/Op/u9c1UPiDj0ja3/EriF8ORRoaVQ7NNj7ruCWr
         N9DRJaS0bUdI09YcAWPvdEewtJuJKL7SwmTtV8VBd1fFioXPIgw2RWLiOXUAEAjv3Js6
         zzww==
X-Gm-Message-State: APjAAAUjqk4Ia36ikopRuxutwgIBc8ZPn9WwQtpYHc21iCGtI3YiT1Sw
        LOa7r7doZb6yBq1rbSVSs1YFu/Ui
X-Google-Smtp-Source: APXvYqzdKNwxtKOMAm1+Gvne26nJWbaDyd2nTTcmgg64eaPk+FXegTjIsKwG7jOyi1K3FyTqL5FOLw==
X-Received: by 2002:a65:4785:: with SMTP id e5mr32267378pgs.407.1570486952364;
        Mon, 07 Oct 2019 15:22:32 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id b185sm16432284pfg.14.2019.10.07.15.22.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 15:22:31 -0700 (PDT)
Subject: Re: [PATCH rdma-next v2 2/3] RDMA/rw: Support threshold for
 registration vs scattering to local pages
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20191007135933.12483-1-leon@kernel.org>
 <20191007135933.12483-3-leon@kernel.org>
 <c0105196-b0e4-854e-88ff-40f5ba2d4105@acm.org> <20191007160336.GB5855@unreal>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8d610a58-abb5-941a-2a52-96ab9287572b@acm.org>
Date:   Mon, 7 Oct 2019 15:22:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191007160336.GB5855@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/19 9:03 AM, Leon Romanovsky wrote:
> On Mon, Oct 07, 2019 at 08:07:55AM -0700, Bart Van Assche wrote:
>> On 10/7/19 6:59 AM, Leon Romanovsky wrote:
>>>    /*
>>> - * Check if the device might use memory registration.  This is currently only
>>> - * true for iWarp devices. In the future we can hopefully fine tune this based
>>> - * on HCA driver input.
>>> + * Check if the device might use memory registration. This is currently
>>> + * true for iWarp devices and devices that have optimized SGL registration
>>> + * logic.
>>>     */
>>
>> The following sentence in the above comment looks confusing to me: "Check if
>> the device might use memory registration." That sentence suggests that the
>> HCA decides whether or not to use memory registration. Isn't it the RDMA R/W
>> code that decides whether or not to use memory registration?
> 
> I'm open for any reasonable text, what do you expect to be written there?

Hi Leon,

How about the following (not sure whether this is correct)?

/*
  * Report whether memory registration should be used. Memory
  * registration must be used for iWarp devices because of
  * iWARP-specific limitations. Memory registration is also enabled if
  * registering memory will yield better performance than using multiple
  * SGE entries.
  */

Thanks,

Bart.
