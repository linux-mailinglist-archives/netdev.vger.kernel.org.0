Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D07AD128481
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 23:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfLTWSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 17:18:00 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41616 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbfLTWR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 17:17:59 -0500
Received: by mail-pf1-f195.google.com with SMTP id w62so5966162pfw.8
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 14:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4UvOxdVv4Nrk7yctz71cdlsxDaFRIgsa/BREx7jPG8c=;
        b=S6HCQudfzBGxfzUBou1Hf3PpIPC86esqbC+jrlMMS93keji9+XUvxZDJsyPMbmx9Lz
         tWIqzny2XK7kDRVAB7EJaQHj4X6/HYimFT0MAZc0ImmhdpsvRZCFd7bdjYOI8XHSWF3b
         88kI2Z6pCykdNP5wxyyPde8o+FQxHF1AcWP0+hQLiJ8Ml1Y3AZrdVYfsokeeS5V7ld/A
         BvGvWhblU/NqPaYGXg3C47E1qhRgGZSkhlBCD5CUAiynJuWIquBp+OXF/aNv9q3bssym
         p2EHYDfF2eqi2Su27iGPpRkCuHnjhrGkGmTGBe4HWirh5zUHqVrDZTQDsQ3N+mYGs1hM
         o78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4UvOxdVv4Nrk7yctz71cdlsxDaFRIgsa/BREx7jPG8c=;
        b=a1eICSfXEOzsX9vJ62ea8bld0lSIKvCbJRguTEN7oPaYcfcPmgthqIIHOWj2dLkU3N
         2KcerXIIvgg207H95wRWMjSQZ9fyTG98sJfKcMTmRr+HwUhsdw9B/NFKeaEgDbh39WmM
         ZKv1BSQThzPWbJF4DSlhEElxSI+roeThgQcD+P9k5tnxszlYBd6iHKceX0FX2QrJazbn
         JSF3z+rwGO1gyLRpgfukn112Il072AO+9tCY88+JKm2QtZbdKs9sMDStZfB1DQ8UyK6I
         i3I/kp3Nn6LIyYfRIshykOrgwk8GkNnt7hPV3plVpfk07OmHEH8FpG2e1zmcaYcwTB0P
         JLhg==
X-Gm-Message-State: APjAAAXD1pVr9XNLIW3qDGrbbilZYDq1aPbZlmJOuzQhX0LQ1/ovfWfI
        59DtrYxuw72zbqO35od5EvI=
X-Google-Smtp-Source: APXvYqwti81cyjaMAWRRW+0U1m+6m7RtREziixPaMsx4NUcNc4wx46zmMjYgU5K7o+MjMAj20CFilw==
X-Received: by 2002:a63:da4d:: with SMTP id l13mr18212719pgj.106.1576880279097;
        Fri, 20 Dec 2019 14:17:59 -0800 (PST)
Received: from [192.168.1.236] (KD124211219252.ppp-bb.dion.ne.jp. [124.211.219.252])
        by smtp.gmail.com with ESMTPSA id r7sm14641605pfg.34.2019.12.20.14.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 14:17:58 -0800 (PST)
Subject: Re: [RFC net-next 11/14] tun: run XDP program in tx path
To:     David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
 <20191218081050.10170-12-prashantbhole.linux@gmail.com>
 <20191218110732.33494957@carbon> <87fthh6ehg.fsf@toke.dk>
 <20191218181944.3ws2oy72hpyxshhb@ast-mbp.dhcp.thefacebook.com>
 <35a07230-3184-40bf-69ff-852bdfaf03c6@gmail.com> <874kxw4o4r.fsf@toke.dk>
 <5eb791bf-1876-0b4b-f721-cb3c607f846c@gmail.com>
 <75228f98-338e-453c-3ace-b6d36b26c51c@redhat.com>
 <3654a205-b3fd-b531-80ac-42823e089b39@gmail.com>
 <3e7bbc36-256f-757b-d4e0-aeaae7009d6c@gmail.com>
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <58e0f61d-cb17-f517-d76d-8a665af31618@gmail.com>
Date:   Sat, 21 Dec 2019 07:17:54 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3e7bbc36-256f-757b-d4e0-aeaae7009d6c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/21/2019 1:11 AM, David Ahern wrote:
> On 12/19/19 9:46 PM, Prashant Bhole wrote:
>>
>> "It can improve container networking where veth pair links the host and
>> the container. Host can set ACL by setting tx path XDP to the veth
>> iface."
> 
> Just to be clear, this is the use case of interest to me, not the
> offloading. I want programs managed by and viewable by the host OS and
> not necessarily viewable by the guest OS or container programs.
> 

Yes the plan is to implement this while having a provision to implement
offload feature on top of it.
