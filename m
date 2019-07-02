Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0335DB29
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfGCBus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:50:48 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33625 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbfGCBus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:50:48 -0400
Received: by mail-lf1-f66.google.com with SMTP id y17so531553lfe.0
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 18:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OtNNYBNm1JpUmlbSXfOacWdVL+xLaEisgn4cxAyFWvc=;
        b=XkXLcra1GETf+BjtJgZFGGJHgfnyaEAhtVwPsFzqTDtvSzk7K4cYGXdzyMAn0iXhD2
         jsNS6ZX2Aig66f9lDi2DLk1VyTpg3+i6+S6+juCkqyrX+EgUjwPPgnJtLo2kld0p2Dc8
         mCYGIjeTEDVqSC1PpMFh9xH34snfD/cCl6XZf5oCIQVG8O8rVciIhMX9NnqexpCU9HN7
         YUm7aWXL2c54UWB+iwQ6zBqf1j7H3sZwddoqOAoAy7101fVpNGN+EO/kVTsjZ8Tkk6K+
         +1/1g0WsmEjJnan0VHjp5QH1Y5+G32htVXnLNhAFEtB297GY/1rPX5IZSa01NuqSmvDs
         RDGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=OtNNYBNm1JpUmlbSXfOacWdVL+xLaEisgn4cxAyFWvc=;
        b=l4p7D8nfOhW5IaOWg1uRpwGMXkmdS9aZd/gWkVbilJS1j7C8oyvZ6hgsVjojuTe1p4
         467wou3dI3NbqMRnbqPLJwSykvAY8QWXsZfD8H4esDpaTIYbxI6dmCNa38qoj8xVRBU8
         FMpHZBcWwMpMTVRO7tLekrkN8Z/xi3UOpJOiJPP6vWcxR+tS2DLzGCDOUmd5HpAUnUc4
         +9aWvd4EYvcKhnX1XzuYK+2tJDPbXOsm6Pnv3n5DZ79jlLVV3Mp/HDB35jS6R99rmo2X
         N6owRd6uGCFUMQZEeDq45Oi6+CHt3t2jModGYo4Nhzq9Tvvu2dlkrgnUjKbsCl/H0jhy
         RA+Q==
X-Gm-Message-State: APjAAAUiEqoAAqGuVNruPZslQeYYb9UpG26/Hi3Kq0GEBD+fiBUGaoNq
        Ve8RSIEtnLaNhOR2oa7ftL5d4A==
X-Google-Smtp-Source: APXvYqzEF5k5CVr4U5Ts3OSMxtAglpPUPMGzRm0CSe0eCHDtkMHcNuXCddOhxidOixjNKCUNogmnDg==
X-Received: by 2002:a19:7912:: with SMTP id u18mr15034634lfc.81.1562099313342;
        Tue, 02 Jul 2019 13:28:33 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id o187sm7642lfa.88.2019.07.02.13.28.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 13:28:32 -0700 (PDT)
Date:   Tue, 2 Jul 2019 23:28:30 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        grygorii.strashko@ti.com, jakub.kicinski@netronome.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: core: page_pool: add user refcnt and reintroduce
 page_pool_destroy
Message-ID: <20190702202829.GI4510@khorivan>
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
 <20190702145612.GF4510@khorivan>
 <20190702171029.76c60538@carbon>
 <20190702152112.GG4510@khorivan>
 <20190702202907.15fb30ce@carbon>
 <20190702185839.GH4510@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190702185839.GH4510@khorivan>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 09:58:40PM +0300, Ivan Khoronzhuk wrote:
>On Tue, Jul 02, 2019 at 08:29:07PM +0200, Jesper Dangaard Brouer wrote:
>>On Tue, 2 Jul 2019 18:21:13 +0300
>>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>>
>>>On Tue, Jul 02, 2019 at 05:10:29PM +0200, Jesper Dangaard Brouer wrote:
>>>>On Tue, 2 Jul 2019 17:56:13 +0300
>>>>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>>>>
>>>>> On Tue, Jul 02, 2019 at 04:52:30PM +0200, Jesper Dangaard Brouer wrote:
>>>>> >On Tue, 2 Jul 2019 17:44:27 +0300
>>>>> >Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>>>>> >
>>>>> >> On Tue, Jul 02, 2019 at 04:31:39PM +0200, Jesper Dangaard Brouer wrote:
>>>>> >> >From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>>>>> >> >
>>>>> >> >Jesper recently removed page_pool_destroy() (from driver invocation) and
>>>>> >> >moved shutdown and free of page_pool into xdp_rxq_info_unreg(), in-order to
>>>>> >> >handle in-flight packets/pages. This created an asymmetry in drivers
>>>>> >> >create/destroy pairs.
>>>>> >> >
>>>>> >> >This patch add page_pool user refcnt and reintroduce page_pool_destroy.
>>>>> >> >This serves two purposes, (1) simplify drivers error handling as driver now
>>>>> >> >drivers always calls page_pool_destroy() and don't need to track if
>>>>> >> >xdp_rxq_info_reg_mem_model() was unsuccessful. (2) allow special cases
>>>>> >> >where a single RX-queue (with a single page_pool) provides packets for two
>>>>> >> >net_device'es, and thus needs to register the same page_pool twice with two
>>>>> >> >xdp_rxq_info structures.
>>>>> >>
>>>>> >> As I tend to use xdp level patch there is no more reason to mention (2) case
>>>>> >> here. XDP patch serves it better and can prevent not only obj deletion but also
>>>>> >> pool flush, so, this one patch I could better leave only for (1) case.
>>>>> >
>>>>> >I don't understand what you are saying.
>>>>> >
>>>>> >Do you approve this patch, or do you reject this patch?
>>>>> >
>>>>> It's not reject, it's proposition to use both, XDP and page pool patches,
>>>>> each having its goal.
>>>>
>>>>Just to be clear, if you want this patch to get accepted you have to
>>>>reply with your Signed-off-by (as I wrote).
>>>>
>>>>Maybe we should discuss it in another thread, about why you want two
>>>>solutions to the same problem.
>>>
>>>If it solves same problem I propose to reject this one and use this:
>>>https://lkml.org/lkml/2019/7/2/651
>>
>>No, I propose using this one, and rejecting the other one.
>
>There is at least several arguments against this one (related (2) purpose)
>
>It allows:
>- avoid changes to page_pool/mlx5/netsec
>- save not only allocator obj but allocator "page/buffer flush"
>- buffer flush can be present not only in page_pool but for other allocators
> that can behave differently and not so simple solution.
>- to not limit cpsw/(potentially others) to use "page_pool" allocator only
>....
>
>This patch better leave also, as it simplifies error path for page_pool and
>have more error prone usage comparing with existent one.
>
>Please, don't limit cpsw and potentially other drivers to use only
>page_pool it can be zca or etc... I don't won't to modify each allocator.
>I propose to add both as by fact they solve different problems with common
>solution.

I can pick up this one but remove description related to (2) and add
appropriate modifications to cpsw.

-- 
Regards,
Ivan Khoronzhuk
