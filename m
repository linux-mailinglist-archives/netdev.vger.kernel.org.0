Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89905D230
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfGBO4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:56:18 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37676 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfGBO4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 10:56:17 -0400
Received: by mail-lj1-f196.google.com with SMTP id 131so17204954ljf.4
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 07:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7rK7qDKEwGgygAo6exJfMYowjRvJTz2OfqB0lXA6Pfg=;
        b=PCN9X2D/JW/E7t0T4zSJTdmG1LASGkY2AXb3iTdWBl644wY1XW1wMWZx2DP2Z/7KHI
         3FJIpNnyGXhQsq+k3+NYCBfzwP9WdvqY75RlPTDw4pbqNOD/6m8H3qw/qg0N18SQ/wPt
         4c4uLlo1rPSeaYy0OMQOej73UvqLzO8XZcxw5AYlPCAfA6XdXD25Or/zz8kahtocP9k1
         HP6k/DoZ2d5hSz4DPGbHfR7v85tgbjBOzfay3uzxZnKkWtBdzfzfn1GjSUTwNq4YXCRj
         FEh7jnHkPs4vr0tyZ+XMoXSHKnN/Cf8+zUif3+xZqPp/bBUyCM7u5iwhWe6jUlRv/UeN
         Wf3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=7rK7qDKEwGgygAo6exJfMYowjRvJTz2OfqB0lXA6Pfg=;
        b=GiAun9gFOW1I/N4+XlhsEtRHWEuOsEgqkwPMDS96CON+SXOOWJXNvbA6Pvubm5itZW
         PKttgIhpqx1cC/5WrCcKXOLCsiJVgFRRaZnjUeibeWJfoc01dMwVdry0iBn40XufQSbH
         xE6UO2pLMidwa1VU4b2MaUx4mcGyFuG+sg3FIcYN9GEPe3Pk1mICxuH4ACY4s85EHC4N
         ocpvGJJUdZS6XWH2nqbSai/n5vcVVNaHynDTquj4wQ5/Ty9y5AaPRVvNaSvLaJwa3Pm0
         brcUPT6m8p7jcpDGmYTeMTFRS2FoI36z0piRU+WH1gN2jUD5jEkZh+e1j4IeBYBQXbz1
         go4Q==
X-Gm-Message-State: APjAAAX1/f1EUNEMaEbLpJ/Nng4jKr19AbQkPZFOfAuVqFnKytJ4XcbU
        KOsWtiRsPEARMc6uQ2Yx2NcZ3Q==
X-Google-Smtp-Source: APXvYqxOMQT0G6y7V2pn2t8I+DIDfhNyZFaiJCq4TFQLkjR1uetJemhwCrBPg9N3EDdg7uo1Fm1J1w==
X-Received: by 2002:a2e:5302:: with SMTP id h2mr17005806ljb.47.1562079375922;
        Tue, 02 Jul 2019 07:56:15 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id v202sm241305lfa.28.2019.07.02.07.56.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 07:56:15 -0700 (PDT)
Date:   Tue, 2 Jul 2019 17:56:13 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        grygorii.strashko@ti.com, jakub.kicinski@netronome.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: core: page_pool: add user refcnt and reintroduce
 page_pool_destroy
Message-ID: <20190702145612.GF4510@khorivan>
Mail-Followup-To: Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        grygorii.strashko@ti.com, jakub.kicinski@netronome.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
References: <20190702153902.0e42b0b2@carbon>
 <156207778364.29180.5111562317930943530.stgit@firesoul>
 <20190702144426.GD4510@khorivan>
 <20190702165230.6caa36e3@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190702165230.6caa36e3@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 04:52:30PM +0200, Jesper Dangaard Brouer wrote:
>On Tue, 2 Jul 2019 17:44:27 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> On Tue, Jul 02, 2019 at 04:31:39PM +0200, Jesper Dangaard Brouer wrote:
>> >From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>> >
>> >Jesper recently removed page_pool_destroy() (from driver invocation) and
>> >moved shutdown and free of page_pool into xdp_rxq_info_unreg(), in-order to
>> >handle in-flight packets/pages. This created an asymmetry in drivers
>> >create/destroy pairs.
>> >
>> >This patch add page_pool user refcnt and reintroduce page_pool_destroy.
>> >This serves two purposes, (1) simplify drivers error handling as driver now
>> >drivers always calls page_pool_destroy() and don't need to track if
>> >xdp_rxq_info_reg_mem_model() was unsuccessful. (2) allow special cases
>> >where a single RX-queue (with a single page_pool) provides packets for two
>> >net_device'es, and thus needs to register the same page_pool twice with two
>> >xdp_rxq_info structures.
>>
>> As I tend to use xdp level patch there is no more reason to mention (2) case
>> here. XDP patch serves it better and can prevent not only obj deletion but also
>> pool flush, so, this one patch I could better leave only for (1) case.
>
>I don't understand what you are saying.
>
>Do you approve this patch, or do you reject this patch?
>
It's not reject, it's proposition to use both, XDP and page pool patches,
each having its goal.

-- 
Regards,
Ivan Khoronzhuk
