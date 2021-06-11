Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB903A3A14
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 05:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhFKDHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 23:07:02 -0400
Received: from m12-15.163.com ([220.181.12.15]:59915 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhFKDHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 23:07:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=0Ym6k
        /3DmPhpmY+UFOFonjPWD4GzBEfsl7y9mwmxEh4=; b=Pho3XBuvvbSLEQR0iqLrn
        yS9VrGM/Ogb+8vKHyvyES5m4YJaBFJrgidP8QIXPhoYmEXzyYeBX1AuCT/vyZ6fq
        w/OWXu+IBgJJ7E3+Us+aD8+ilsCCWv9WVViyL6DbABAl65+OwYctZnNOcozaToSF
        v0sl39o3Nabifl9BKGr6UI=
Received: from localhost (unknown [218.17.89.92])
        by smtp11 (Coremail) with SMTP id D8CowAAXa9C00sJgL3t8AA--.2S2;
        Fri, 11 Jun 2021 11:04:28 +0800 (CST)
Date:   Fri, 11 Jun 2021 11:04:19 +0800
From:   Zhongjun Tan <hbut_tan@163.com>
To:     Alex Elder <elder@ieee.org>
Cc:     David Miller <davem@davemloft.net>, elder@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tanzhongjun@yulong.com
Subject: Re: [PATCH] soc: qcom: ipa: Remove superfluous error message around
 platform_get_irq()
Message-ID: <20210611110419.00003810.hbut_tan@163.com>
In-Reply-To: <a3765a86-bb9e-b5f8-32a1-3c3fa939bb4e@ieee.org>
References: <20210610140118.1437-1-hbut_tan@163.com>
        <20210610.141142.1384244468678097702.davem@davemloft.net>
        <a3765a86-bb9e-b5f8-32a1-3c3fa939bb4e@ieee.org>
Organization: Yulong
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=GB18030
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: D8CowAAXa9C00sJgL3t8AA--.2S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww4fGr1kAw1xCr4xGw1kuFg_yoW8Ar18pr
        s0kayayr95ta1xG3W8Ja4ruFy5ur18tFW3Kw1Yg3WruFW5Xr90qr1rtFWF9rn5ur48C3W5
        XF4j9ws5CFyFva7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jDPE-UUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: xkex3sxwdqqiywtou0bp/1tbiKB2uxl7WF+SVIwAAsQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Jun 2021 16:38:43 -0500
Alex Elder <elder@ieee.org> wrote:

> On 6/10/21 4:11 PM, David Miller wrote:
> > From:  Zhongjun Tan <hbut_tan@163.com>
> > Date: Thu, 10 Jun 2021 22:01:18 +0800
> >   
> >> diff --git a/drivers/net/ipa/ipa_smp2p.c
> >> b/drivers/net/ipa/ipa_smp2p.c index 34b68dc43886..93270e50b6b3
> >> 100644 --- a/drivers/net/ipa/ipa_smp2p.c
> >> +++ b/drivers/net/ipa/ipa_smp2p.c
> >> @@ -177,11 +177,8 @@ static int ipa_smp2p_irq_init(struct
> >> ipa_smp2p *smp2p, const char *name, int ret;
> >>   
> >>   	ret = platform_get_irq_byname(smp2p->ipa->pdev, name);
> >> -	if (ret <= 0) {
> >> -		dev_err(dev, "DT error %d getting \"%s\" IRQ
> >> property\n",
> >> -			ret, name);
> >> +	if (ret <= 0)  
> > Applied, but this code still rejects an irq of zero which is a
> > valid irq number.  
> 
> It rejects IRQ 0 intentionally.  And if 0 is returned, there
> will now be no message printed by the platform code.
> 
> As I recall, I looked for a *long* time to see whether IRQ 0
> was a valid IRQ number in Linux.  One reason I even questioned
> it is that NO_IRQ is defined with value 0 on some architectures
> (though not for Arm).  I even asked Rob Herring about privately
> it a few years back and he suggested I shouldn't allow 0.
> 
> Yes, it *looked* like IRQ 0 could be a valid return.  But I
> decided it was safer to just reject it, on the assumption
> that it's unlikely to be returned (I don't believe it is
> or ever will be used as the IRQ for SMP2P).
> 
> If you are certain it's valid, and should be allowed, I
> have no objection to changing that "<=" to be "<".
> 
> 					-Alex
> 
> PS  A quick search found this oldie:
>        https://yarchive.net/comp/linux/no_irq.html

I think so , It is better to change "<=" to be "<".

