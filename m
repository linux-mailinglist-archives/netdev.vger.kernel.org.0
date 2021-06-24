Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F523B2EE0
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 14:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhFXMZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 08:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhFXMZw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 08:25:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 937C861209;
        Thu, 24 Jun 2021 12:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624537413;
        bh=JTsUy6jEymu4qp5qGCh4JVhR5yjdg1Lz3myy2L5OZJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QvClQ3g2Htt0PFAENbaUhP8J94m0ztjO+UjJ/8v1MDWqUWSbTiiXYg2gxvP15Coxm
         FkDdN64l6rzNumPsxbxhBgsv6hJ1RtC9K7lOnuO9v1B0756lA6iqnGwQ3TneWrbSOG
         Ty5Nr9Krggxb5ET4emDq8Dfm/J67T2CioXuvCGqA=
Date:   Thu, 24 Jun 2021 14:23:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, bpf@vger.kernel.org,
        wsd_upstream@mediatek.com, chao.song@mediatek.com,
        kuohong.wang@mediatek.com
Subject: Re: [PATCH 1/4] net: if_arp: add ARPHRD_PUREIP type
Message-ID: <YNR5QuYqknaZS9+j@kroah.com>
References: <YNNv1AxDNBdPcQ1U@kroah.com>
 <20210624115349.2264-1-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624115349.2264-1-rocco.yue@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 07:53:49PM +0800, Rocco Yue wrote:
> >> +/* exposed API
> >> + * receive incoming datagrams from the Modem and push them to the
> >> + * kernel networking system
> >> + */
> >> +int ccmni_rx_push(unsigned int ccmni_idx, struct sk_buff *skb)
> > 
> > Ah, so this driver doesn't really do anything on its own, as there is no
> > modem driver for it.
> > 
> > So without a modem driver, it will never be used?  Please submit the
> > modem driver at the same time, otherwise it's impossible to review this
> > correctly.
> > 
> 
> without MTK ap ccci driver (modem driver), ccmni_rx_push() and
> ccmni_hif_hook() are not be used.
> 
> Both of them are exported as symbols because MTK ap ccci driver
> will be complied to the ccci.ko file.

But I do not see any code in this series that use these symbols.  We can
not have exports that no one uses.  Please add the driver to this patch
series when you resend it.

> In addition, the code of MTK's modem driver is a bit complicated,
> because this part has more than 30,000 lines of code and contains
> more than 10 modules. We are completeing the upload of this huge
> code step by step. Our original intention was to upload the ccmni
> driver that directly interacts with the kernel first, and then
> complete the code from ccmni to the bottom layer one by one from
> top to bottom. We expect the completion period to be about 1 year.

Again, we can not add code to the kernel that is not used, sorry.  That
would not make any sense, would you want to maintain such a thing?

And 30k of code seems a bit excesive for a modem driver.   Vendors find
that when they submit code for inclusion in the kernel tree, in the end,
they end up 1/3 the original size, so 10k is reasonable.

I can also take any drivers today into the drivers/staging/ tree, and
you can do the cleanups there as well as getting help from others.

1 year seems like a long time to do "cleanup", good luck!

> > +++ b/drivers/net/ethernet/mediatek/ccmni/ccmni.h
> > 
> > Why do you have a .h file for a single .c file?  that shouldn't be
> > needed.
> 
> I add a .h file to facilitate subsequent code expansion. If it's
> not appropriate to do this here, I can add the content of .h into
> .c file.

If nothing other than a single .c file needs it, put it into that .c
file please.

thanks,

greg k-h
