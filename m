Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7568E4E52DC
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 14:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244193AbiCWNPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 09:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238027AbiCWNPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 09:15:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C95A3DFF0
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 06:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648041213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ifuc5oqWU21Io0fAnVVGyPcyUyUccxzM0pDfQGg0di4=;
        b=XO0YXmNXHujDODAYqvwg4c6IUPeesIobDdGWhhFoTBDHL9J7OPcJy8J1VPWEhuqh5encfa
        vJNNLzv7AKoixslyBhvT+lfGyuelQLcehfmR7Yhzm4L5g/8tB0HaNUZ8wSMqbkt365zVaf
        m7zjgI0tOT6lSGw6v5WqdmP46TjDJi8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147--aB9q3YKOnG-GF3oXiLYyA-1; Wed, 23 Mar 2022 09:13:30 -0400
X-MC-Unique: -aB9q3YKOnG-GF3oXiLYyA-1
Received: by mail-qk1-f199.google.com with SMTP id w200-20020a3762d1000000b0067d2149318dso950513qkb.1
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 06:13:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Ifuc5oqWU21Io0fAnVVGyPcyUyUccxzM0pDfQGg0di4=;
        b=Ze+ehwjVdRo+lxFyzZng3MejgrCngR0aWcbTLuxpg4tz1tFGaLih8SqGP7bJrAd+jr
         xXo7vv9lL6Q5lTfOKqRDuHv7lYnfGX5uJpIHjcsOFv1ztTRMUZSvvNJrFR1qsCTpnT5Q
         D67wR4yRXomn9W/7Ag1xhexBSCcim+7177I4npRH6LRHRR2PMBet82+fJLeH/GRsQXcz
         GCLa31/Q1gNtesqiU7GG3zLz64Q4E/7Nd2kVCBBpXe8FtR1GDctrYN9G2Nu8Wf92knOx
         U0Ilnl2+PN8UPjFhILwMbhsqiRgL4c8nxrIP0b4MuR/n/0H7UGxLgddSIfTDLbkcZOXa
         tBag==
X-Gm-Message-State: AOAM532Po6vUx5MFM4BD9nAQgN2m9Xi3wrimAXHD4GwbWaJyf+iA2Boc
        HNC8EJ8IUsCCNWa6ByzukFSuowmrx8Cc1dZkaiIiTrRKs7Q2izFsyw67qvglvMacpz2yPcDdo6j
        5aHpUwBt3/ZaVmeXn
X-Received: by 2002:ad4:5f05:0:b0:440:ea8c:c439 with SMTP id fo5-20020ad45f05000000b00440ea8cc439mr22435354qvb.69.1648041210026;
        Wed, 23 Mar 2022 06:13:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUgNb4wvcfdWZ2zbAFuWeegIGg+k6cziT03ZdV/wBH98ZC0J9cJTusg3OZ0832ZtCJW5BOOA==
X-Received: by 2002:ad4:5f05:0:b0:440:ea8c:c439 with SMTP id fo5-20020ad45f05000000b00440ea8cc439mr22435335qvb.69.1648041209812;
        Wed, 23 Mar 2022 06:13:29 -0700 (PDT)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id b202-20020ae9ebd3000000b0067b11d53365sm10517757qkg.47.2022.03.23.06.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 06:13:28 -0700 (PDT)
Subject: Re: [PATCH] ath9k: initialize arrays at compile time
To:     Joe Perches <joe@perches.com>,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        John Crispin <john@phrozen.org>, toke@toke.dk,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220320152028.2263518-1-trix@redhat.com>
 <af6042d0-952f-f497-57e7-37fef45a1f76@phrozen.org>
 <233074c3-03dc-cf8b-a597-da0fb5d98be0@newmedia-net.de>
 <7a12fd4599758b8cd5fd376db6c9a950d2ed2094.camel@perches.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <c290ae27-9e4a-96ed-d8d6-a8b8bf8d0181@redhat.com>
Date:   Wed, 23 Mar 2022 06:13:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <7a12fd4599758b8cd5fd376db6c9a950d2ed2094.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/20/22 10:36 AM, Joe Perches wrote:
> On Sun, 2022-03-20 at 18:17 +0100, Sebastian Gottschall wrote:
>> Am 20.03.2022 um 17:48 schrieb John Crispin:
>>>
>>> On 20.03.22 16:20, trix@redhat.com wrote:
>>>> array[size] = { 0 };
>>> should this not be array[size] = { }; ?!
>>>
>>> If I recall correctly { 0 } will only set the first element of the
>>> struct/array to 0 and leave random data in all others elements
>>>
>>>      John
>> You are right, john
> No.  The patch is fine.
>
> Though generally the newer code in the kernel uses
>
> 	type dec[size] = {};
>
> to initialize stack arrays.
>
> array stack declarations not using 0
>
> $ git grep -P '^\t(?:\w++\s*){1,2}\[\s*\w+\s*\]\s*=\s*\{\s*\};' -- '*.c' | wc -l
> 213
>
> array stack declarations using 0
>
> $ git grep -P '^\t(?:\w++\s*){1,2}\[\s*\w+\s*\]\s*=\s*\{\s*0\s*\};' -- '*.c' | wc -l
> 776
>
> Refer to the c standard section on initialization 6.7.8 subsections 19 and 21
>
> 19
>
> The initialization shall occur in initializer list order, each initializer provided for a
> particular subobject overriding any previously listed initializer for the same subobject
> all subobjects that are not initialized explicitly shall be initialized implicitly the same as
> objects that have static storage duration.
>
> ...
>
> 21
>
> If there are fewer initializers in a brace-enclosed list than there are elements or members
> of an aggregate, or fewer characters in a string literal used to initialize an array of known
> size than there are elements in the array, the remainder of the aggregate shall be
> initialized implicitly the same as objects that have static storage duration.
>
Joe,

Thanks for providing these sections for c reference !

I will update the commit log and replace { 0 } with { }

Tom

