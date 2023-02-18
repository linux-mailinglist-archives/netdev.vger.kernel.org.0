Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E279F69BA55
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 15:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjBROCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 09:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBROCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 09:02:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B3E13D5A
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 06:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676728924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qRzLO+tA/rMKWELgzSE4vwEgVXv8YBCOYe+f1LqKzkY=;
        b=fWXCBvb9+n9mnzFODXUGblNvfNTMj/zhfCnxvVr3zb3H1QDMCCLm7b6VJ0O0vQVfogWRb5
        SbBNGfRWjI7g0CZAEHBhnJrNQQq1JC1gXok4Jmc9cad5GX6g2P3cMgv4uGI7sTD/yu5Plj
        Rip5jFiAuHZMCJoS7Wp3Fi79A+XrGns=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-547--4ubCkpmOOOx_ZHhv_vkgw-1; Sat, 18 Feb 2023 09:02:00 -0500
X-MC-Unique: -4ubCkpmOOOx_ZHhv_vkgw-1
Received: by mail-ed1-f72.google.com with SMTP id cs14-20020a0564020c4e00b004ace77022ebso1134660edb.8
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 06:02:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qRzLO+tA/rMKWELgzSE4vwEgVXv8YBCOYe+f1LqKzkY=;
        b=C2emXc5WEcQ+OZz6/PLzLwn5EfQg1+T/ASxrbaTOLaEWxZeRqwlUiXkrxAoj71uz+X
         8FMYFD6VBWLA1pUA8xyKWYYsYq6E52TWMNrR+HL6bGB7PYWVc46mDcPC5Kf07arlOLWB
         XAIIIi4Orh/l7rEAa2gJkrJvBbZJp8DV1xmCdyFtZRdXTYD86TiYziiA2OayG2QD709O
         OTNYEnsTkct0xDqBMX4P5wnmyu/4IPU/TY7ntGvxubs8UnRq1MERoadhSiGrgvzJF4y5
         rzE31MdGgLTtge7QHdSuodaVOd9tToIJHs7NNTY1gBouea9qI5G3qrOD9DsJlhMVz4rX
         Jbhw==
X-Gm-Message-State: AO0yUKVhe/rqOeNp6O5kPlayKpfMeJ3HeIbQxIOwcZSNgV1TsR6ovVZZ
        sCdtgjRPm2c3dw7l05F9pAo5/ZE72fPRfL5dvVo9pX/Wu55vOADlkN1ehXu649fs3w01SXvkEyY
        rIMe4nypcv2RgWCTf
X-Received: by 2002:a05:6402:1101:b0:4ab:2423:e310 with SMTP id u1-20020a056402110100b004ab2423e310mr559538edv.28.1676728919527;
        Sat, 18 Feb 2023 06:01:59 -0800 (PST)
X-Google-Smtp-Source: AK7set9PYXjrsok6ngp3XrR7xLUnp336tLH9uDj5zEdDkekt+6s1HRybMlhmpjAG0Vj9ISGSKBlTlg==
X-Received: by 2002:a05:6402:1101:b0:4ab:2423:e310 with SMTP id u1-20020a056402110100b004ab2423e310mr559518edv.28.1676728919271;
        Sat, 18 Feb 2023 06:01:59 -0800 (PST)
Received: from [192.168.42.100] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id t9-20020a50d709000000b004a249a97d84sm3602514edi.23.2023.02.18.06.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Feb 2023 06:01:58 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <df48ff0b-d96b-7231-1b3d-02509a574c9b@redhat.com>
Date:   Sat, 18 Feb 2023 15:01:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net
Subject: Re: [xdp-hints] Re: [PATCH bpf-next V2] xdp: bpf_xdp_metadata use
 NODEV for no device support
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@linux.dev>
References: <167663589722.1933643.15760680115820248363.stgit@firesoul>
 <Y++6IvP+PloUrCxs@google.com>
 <514bb57b-cc3e-7b7e-c7d4-94cdf52565d6@linux.dev>
 <CAKH8qBujK0RnOHi3EH_KwKamEtQRYJ6izoYRBB2_2CQias0HXA@mail.gmail.com>
 <eed53c45-84c4-9978-5323-cede57d9d797@linux.dev>
 <CAKH8qBvwPA_VaHfwqzPN4SNFqCTgVFWH9zMj0LXio_=8Dg3TOw@mail.gmail.com>
 <87mt5cow4w.fsf@toke.dk>
In-Reply-To: <87mt5cow4w.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17/02/2023 21.49, Toke Høiland-Jørgensen wrote:
> Stanislav Fomichev <sdf@google.com> writes:
> 
>> On Fri, Feb 17, 2023 at 9:55 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>>
>>> On 2/17/23 9:40 AM, Stanislav Fomichev wrote:
>>>> On Fri, Feb 17, 2023 at 9:39 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>>>>>
>>>>> On 2/17/23 9:32 AM, Stanislav Fomichev wrote:
>>>>>> On 02/17, Jesper Dangaard Brouer wrote:
>>>>>>> With our XDP-hints kfunc approach, where individual drivers overload the
>>>>>>> default implementation, it can be hard for API users to determine
>>>>>>> whether or not the current device driver have this kfunc available.
>>>>>>
>>>>>>> Change the default implementations to use an errno (ENODEV), that
>>>>>>> drivers shouldn't return, to make it possible for BPF runtime to
>>>>>>> determine if bpf kfunc for xdp metadata isn't implemented by driver.
>>>>>>
>>>>>>> This is intended to ease supporting and troubleshooting setups. E.g.
>>>>>>> when users on mailing list report -19 (ENODEV) as an error, then we can
>>>>>>> immediately tell them their device driver is too old.
>>>>>>
>>>>>> I agree with the v1 comments that I'm not sure how it helps.
>>>>>> Why can't we update the doc in the same fashion and say that
>>>>>> the drivers shouldn't return EOPNOTSUPP?

Okay, lets go in this direction then.
I will update the drivers to not return EOPNOTSUPP.

What should drivers then return instead.
I will propose that driver return ENODATA instead?

--Jesper

