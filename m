Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FFB3E933A
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 16:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbhHKOFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 10:05:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231872AbhHKOFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 10:05:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628690717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u+UwXrDdUvMVeVeP5V7tq2RnSOSZajczg7aig3TAtJw=;
        b=LR7b3qyXIUivawaMJas+7EbdhEqirBTzgNvi35ZCpkr90S3Mi68sBLki6UzEMnhoRZuoNT
        K78dajXm6g1h2xeoNpLYsod9lNFAk6bm6vgN0Km1wQrZcORr4VJz+f7p2QPyNnAt7niZQt
        s64Iazc3OoyGTPuu9pyK4zk26LxDptw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-_2lhzVIIPbqYUCSvdbLp4g-1; Wed, 11 Aug 2021 10:05:16 -0400
X-MC-Unique: _2lhzVIIPbqYUCSvdbLp4g-1
Received: by mail-qt1-f197.google.com with SMTP id o19-20020a05622a0093b029029624b5db4fso1349182qtw.23
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 07:05:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u+UwXrDdUvMVeVeP5V7tq2RnSOSZajczg7aig3TAtJw=;
        b=H4C/aMWzz53rJo3GPE5kppE3CrzQGCtrawSev8lIprhAAipvRVJx/v/G+/xsdHNoMM
         625jZC7GzHMVZx55VsoHUzWiGQNB2Ntr2xCOlx2A/Ftzjb7paor9Sk9qAsXj1O2NI353
         CuCuAFyqrimfzOedgneJI9Uly2ph3QkdHEWtvuIPArjVo9RWazEArxA/pZqGJgBkAbt9
         ZHiig7LfAYf55UXSJ0GLiGY5pe9eOEtycDwDGKpJA5t5oTLuuDe3OA9UALMtoW2tJ43d
         3e9PCoFlygZBDebIktm6TZYAqJgv9IUtSYGSV5DW9WwNSmIdhlZ8XllWHMKDkJX0yzBH
         Ok5Q==
X-Gm-Message-State: AOAM531UWtMx+2qV1pWzgYq1y3eGZeFoGepvbWh5jDT8ECF/joLQ/naU
        X4HXc174sG7Ope9nt2htLFNmQyKxmpTipoq4NDyUO9VPuxu13XjqYBy0RVgBfPQobDVW9QWh5ol
        3foRotKEKIj/bB6YM
X-Received: by 2002:a37:9643:: with SMTP id y64mr32674332qkd.213.1628690715645;
        Wed, 11 Aug 2021 07:05:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCyP6IAxayqVXnCpyOW3A+Q4cpJNidAxOrcHuQ7RfdL9iiN6zS6fZT6rLuYZQ8u7eQLyhK4g==
X-Received: by 2002:a37:9643:: with SMTP id y64mr32674294qkd.213.1628690715222;
        Wed, 11 Aug 2021 07:05:15 -0700 (PDT)
Received: from jtoppins.rdu.csb ([107.15.110.69])
        by smtp.gmail.com with ESMTPSA id 18sm12894916qkm.128.2021.08.11.07.05.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 07:05:14 -0700 (PDT)
Subject: Re: [PATCH bpf-next v6 1/7] net: bonding: Refactor bond_xmit_hash for
 use with xdp_buff
To:     Jussi Maki <joamaki@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210731055738.16820-1-joamaki@gmail.com>
 <20210731055738.16820-2-joamaki@gmail.com>
 <2bb53e7c-0a2f-5895-3d8b-aa43fd03ff52@redhat.com>
 <CAHn8xckOsLD463JW2rc1LhjjY0FQ-aRNqSif_SJ6GT9bAH7VqQ@mail.gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
Message-ID: <3b0657f0-d7ef-e568-57c2-0db41acea615@redhat.com>
Date:   Wed, 11 Aug 2021 10:05:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAHn8xckOsLD463JW2rc1LhjjY0FQ-aRNqSif_SJ6GT9bAH7VqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/21 4:22 AM, Jussi Maki wrote:
> Hi Jonathan,
> 
> Thanks for catching this. You're right, this will NULL deref if XDP
> bonding is used with the VLAN_SRCMAC xmit policy. I think what
> happened was that a very early version restricted the xmit policies
> that were applicable, but it got dropped when this was refactored.
> I'll look into this today and will add in support (or refuse) the
> VLAN_SRCMAC xmit policy and extend the tests to cover this.

In support of some customer requests and to stop adding more and more 
hashing policies I was looking at adding a custom policy that exposes a 
bitfield so userspace can select which header items should be included 
in the hash. I was looking at a flow dissector implementation to parse 
the packet and then generate the hash from the flow data pulled. It 
looks like the outer hashing functions as they exist now, 
bond_xmit_hash() and bond_xmit_hash_xdp(), could make the correctly 
formatted call to __skb_flow_dissect(). We would then pass around the 
resultant struct flow_keys, or bonding specific one to add MAC header 
parsing support, and it appears we could avoid making the actual hashing 
functions know if they need to hash an sk_buff vs xdp_buff. What do you 
think?

-Jon

