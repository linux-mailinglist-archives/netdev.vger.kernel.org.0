Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEED34C1AAA
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 19:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238536AbiBWSKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 13:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233265AbiBWSKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 13:10:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3DC147AEF
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 10:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645639820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vulY2qj7g6EJ/ygFw9E28wHoeoQ71D+5jmaUtGLvzco=;
        b=e6NKFMpbkVYb2VDf4em0Ldth6d73huRtWx57BfbbUmchr8yki5upm4DkPFxVpDi0iIDJ1h
        cYNWmOElkmmbKGuuVdI1qFignYAeo4BDz+Brf+9DpBa6/pBSxxvgShmSnTRxkpxcW/f9ji
        JjoTALodS+lUZMSyyKyF0fROzJWZAEI=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-iklunwnXOoKiydbBalG96Q-1; Wed, 23 Feb 2022 13:10:19 -0500
X-MC-Unique: iklunwnXOoKiydbBalG96Q-1
Received: by mail-lj1-f197.google.com with SMTP id q17-20020a2e7511000000b0023c95987502so7717829ljc.16
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 10:10:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=vulY2qj7g6EJ/ygFw9E28wHoeoQ71D+5jmaUtGLvzco=;
        b=I49UyJo6Hp0V4wfUJcveG4/IyM+MOMd8wMn1I/vw4WTnae3Ihx0+ya3Ym+x8XRUiAt
         xeDV53JSXeraLFsaQQkFKbh9ESdBP+JHWFcS1TPGNKq8qD6ul1QelpG2OvEEcIYVwInC
         UPUTbrHT4OkB6cBC4Z1N7NCfA4yCCqxD4+8Ho2i1hR1bXeA7g3EhU0JiEShuT2dUFv4q
         ROONZkogjCQ9uOGNcFlcpHB710a0gRqTbU0NEknFbPNxvrZ4NuAdvtUBNoKDV2udkMot
         AUJVy/e437Rku6PYYWy+hA/40r3zfXjZ/wGO+SW6TVC4SQGDYi3hgW5Kw7D1OxNe9Q1p
         N8yQ==
X-Gm-Message-State: AOAM531aUl/BtmrhwAEKdotSZGZ4zeHIfobOboGhhwZp4Dat6b9Wdr87
        7Rp4Pei6Rpv2gg+TlwwmNoGX9KLbltbtV6tYq/8ga0B2jAR9JuVJs7iSXbsa/8cMUKBjZ4DGCRd
        mzcxnuEEJ/JOaDqxo
X-Received: by 2002:a05:6512:b15:b0:443:c5bd:4512 with SMTP id w21-20020a0565120b1500b00443c5bd4512mr538037lfu.175.1645639817757;
        Wed, 23 Feb 2022 10:10:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxdFBTOdT51zmGZey/k+5lMNEN5itNb5s2WhUh7JpJK6QiB+/TrAvTRKQZAqdsskjmAal4+0A==
X-Received: by 2002:a05:6512:b15:b0:443:c5bd:4512 with SMTP id w21-20020a0565120b1500b00443c5bd4512mr538024lfu.175.1645639817545;
        Wed, 23 Feb 2022 10:10:17 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id t3sm44379ljd.116.2022.02.23.10.10.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 10:10:16 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <7a2d23b2-5a7d-d68e-1ae4-13f114c5a380@redhat.com>
Date:   Wed, 23 Feb 2022 19:10:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, Jesper Dangaard Brouer <jbrouer@redhat.com>,
        netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, hawk@kernel.org, saeed@kernel.org,
        ttoukan.linux@gmail.com
Subject: Re: [net-next v6 1/2] page_pool: Add page_pool stats
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>, Jakub Kicinski <kuba@kernel.org>
References: <1645574424-60857-1-git-send-email-jdamato@fastly.com>
 <1645574424-60857-2-git-send-email-jdamato@fastly.com>
 <21c87173-667f-55c1-2eab-a1f684c75352@redhat.com>
 <CALALjgwqLhTe8zFPugbW7XcMqnhRTKevv-zuVY+CWOjSYTLQRQ@mail.gmail.com>
 <20220223094010.326b0a5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALALjgwm9LpmnT+2kXNvv-aDiyrWWjMO=j0BBmZd4Qh4wQQXhg@mail.gmail.com>
In-Reply-To: <CALALjgwm9LpmnT+2kXNvv-aDiyrWWjMO=j0BBmZd4Qh4wQQXhg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/02/2022 18.45, Joe Damato wrote:
> On Wed, Feb 23, 2022 at 9:40 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Wed, 23 Feb 2022 09:05:06 -0800 Joe Damato wrote:
>>> Are the cache-line placement and per-cpu designations the only
>>> remaining issues with this change?
>>
>> page_pool_get_stats() has no callers as is, I'm not sure how we can
>> merge it in current form.
>>
>> Maybe I'm missing bigger picture or some former discussion.
> 
> I wrote the mlx5 code to call this function and export the data via
> ethtool. I had assumed the mlx5 changes should be in a separate
> patchset. I can include that code as part of this change, if needed.

I agree with Jakub we need to see how this is used by drivers.

--Jesper

