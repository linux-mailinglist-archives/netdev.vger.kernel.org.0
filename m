Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A7F5A139
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfF1Qnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:43:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47526 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF1Qnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 12:43:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FE2E14E03B19;
        Fri, 28 Jun 2019 09:43:44 -0700 (PDT)
Date:   Fri, 28 Jun 2019 09:43:43 -0700 (PDT)
Message-Id: <20190628.094343.1065314747200152509.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        jaswinder.singh@linaro.org, ard.biesheuvel@linaro.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, maciejromanfijalkowski@gmail.com
Subject: Re: [PATCH 1/3, net-next] net: netsec: Use page_pool API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190628150434.30da8852@carbon>
References: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
        <1561718355-13919-2-git-send-email-ilias.apalodimas@linaro.org>
        <20190628150434.30da8852@carbon>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 09:43:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Fri, 28 Jun 2019 15:04:34 +0200

> On Fri, 28 Jun 2019 13:39:13 +0300
> Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> 
>> Use page_pool and it's DMA mapping capabilities for Rx buffers instead
>> of netdev/napi_alloc_frag()
>> 
>> Although this will result in a slight performance penalty on small sized
>> packets (~10%) the use of the API will allow to easily add XDP support.
>> The penalty won't be visible in network testing i.e ipef/netperf etc, it
>> only happens during raw packet drops.
>> Furthermore we intend to add recycling capabilities on the API
>> in the future. Once the recycling is added the performance penalty will
>> go away.
>> The only 'real' penalty is the slightly increased memory usage, since we
>> now allocate a page per packet instead of the amount of bytes we need +
>> skb metadata (difference is roughly 2kb per packet).
>> With a minimum of 4BG of RAM on the only SoC that has this NIC the
>> extra memory usage is negligible (a bit more on 64K pages)
>> 
>> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>> ---
>>  drivers/net/ethernet/socionext/Kconfig  |   1 +
>>  drivers/net/ethernet/socionext/netsec.c | 121 +++++++++++++++---------
>>  2 files changed, 75 insertions(+), 47 deletions(-)
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Jesper this is confusing, you just asked if the code needs to be moved
around to be correct and then right now immediately afterwards you ACK
the patch.
