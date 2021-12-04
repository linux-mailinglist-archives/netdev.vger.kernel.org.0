Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC928468602
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 16:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345197AbhLDPvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 10:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbhLDPvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 10:51:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67317C061751;
        Sat,  4 Dec 2021 07:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=WRnKEg35GZRxlFBDZ8nAe1ThfeNpialM6JAsEXyKYhE=; b=gdprMrDXo5A4+arqeARYGRAihR
        UdIvyB7kSxMOpV82l7r42HGn+k8Pel//Fd6868kXaKf4Qr+b9Qmq6EKRqYQEJP7V5gnrk+QrxrXAD
        mykg2ZBbnLSU6pLhGOGjvdPXSFn5PdcVQVQ9y7mRCl03rsCS9WSRpFFd3WWVfrZGAL7WqvmY5Eqgr
        0IQQ9BPScEkxQ1hUsiP/91ERtF1rnqdHsBH2Qc/q+pHEVObYFcujp3SA55Eh0QMNk1UweLqMOJnsU
        Bl8HBm62h7KPbvgA/o1BOnvvMVg9adm005X8DLTmPuv9odQyGr4vTsszpxNeD6jYhFO05AbOy6lCF
        fhVkisiA==;
Received: from [2602:306:c5a2:a380:b27b:25ff:fe2c:51a8]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mtXGK-00DcGI-Uq; Sat, 04 Dec 2021 15:47:45 +0000
Subject: Re: [PATCH] net: spider_net: Use non-atomic bitmap API when
 applicable
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kou.ishizaki@toshiba.co.jp, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <3de0792f5088f00d135c835df6c19e63ae95f5d2.1638026251.git.christophe.jaillet@wanadoo.fr>
From:   Geoff Levand <geoff@infradead.org>
Message-ID: <450ecfe8-94ce-46cb-0216-9fff22682426@infradead.org>
Date:   Sat, 4 Dec 2021 07:47:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <3de0792f5088f00d135c835df6c19e63ae95f5d2.1638026251.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

On 11/27/21 7:18 AM, Christophe JAILLET wrote:
> No concurrent access is possible when a bitmap is local to a function.
> So prefer the non-atomic functions to save a few cycles.
>    - replace a 'for' loop by an equivalent non-atomic 'bitmap_fill()' call
>    - use '__set_bit()'
> 
> While at it, clear the 'bitmask' bitmap only when needed.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> This patch is *not* compile tested. I don't have the needed cross compiling
> tool chain.
> ---
>  drivers/net/ethernet/toshiba/spider_net.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

As I mentioned, my tdd-builder Docker image has a
gcc-powerpc-linux-gnu cross compiler that can be used to build
a ppc64 kernel:

  https://hub.docker.com/r/glevand/tdd-builder

I also have a few helper scripts to run the container and cross
compile a kernel:

  https://github.com/glevand/tdd--docker/blob/master/builder/run-builder.sh
  https://github.com/glevand/tdd-project/blob/master/scripts/build-linux-kernel.sh


I applied your patch to v5.16-rc3 and no spider_net warnings
or errors were seen when building with ppc64_defconfig. Thanks
for your contribution.

Acked-by: Geoff Levand <geoff@infradead.org>
