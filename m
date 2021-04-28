Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811FA36DD26
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 18:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240995AbhD1QgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 12:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240862AbhD1QgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 12:36:18 -0400
Received: from mail.as397444.net (mail.as397444.net [IPv6:2620:6e:a000:dead:beef:15:bad:f00d])
        by lindbergh.monkeyblade.net (Postfix) with UTF8SMTPS id 02A28C0613ED
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 09:35:32 -0700 (PDT)
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id F386155B76A;
        Wed, 28 Apr 2021 16:35:28 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattcorallo.com;
        s=1619625664; t=1619627729;
        bh=m6s62/obytHANW+CMc2arDEQhP2GDonZEh7Iblwfuho=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=FYUYRnT7iSws5HMgqC/ojba7YSdp/0xJnE9/walA/E98T+QEp/qYCdKuZsuzh6ITJ
         RxaClR/aaPjVaWE22qXLmGE1Y3MImHgU3y695ywGutwBUk/49IpHY3zChDlzB30mJj
         peWAd1VwlpqqvDZVQ3otYhOQ4ycTJs26u/7Etz0xKZZMg27dz0Qyc9IBIY4RXm/P9/
         NnL1LsMDPV1ez9iA2Q0huAZ3aKnTp8qdS1u/D8x8zT+ST7MBWTkLXreiidihGVT1M2
         AhSvYdqeEm0viKot7Gh3ZXYrBhomPyRpRXmwgxh8BtQBy3+dVyaBmWac+51/E0Sldb
         JSvTm8y8kB8MQ==
Message-ID: <64829c98-e4eb-6725-0fee-dc3c6681506f@bluematt.me>
Date:   Wed, 28 Apr 2021 12:35:28 -0400
MIME-Version: 1.0
Subject: Re: [PATCH net-next] Reduce IP_FRAG_TIME fragment-reassembly timeout
 to 1s, from 30s
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Willy Tarreau <w@1wt.eu>, "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Keyu Man <kman001@ucr.edu>
References: <d840ddcf-07a6-a838-abf8-b1d85446138e@bluematt.me>
 <CANn89i+L2DuD2+EMHzwZ=qYYKo1A9gw=nTTmh20GV_o9ADxe2Q@mail.gmail.com>
 <0cb19f7e-a9b3-58f8-6119-0736010f1326@bluematt.me>
 <20210428141319.GA7645@1wt.eu>
 <055d0512-216c-9661-9dd4-007c46049265@bluematt.me>
 <CANn89iKfGhNYJVpj4T2MLkomkwPsYWyOof+COVvNFsfVfb7CRQ@mail.gmail.com>
From:   Matt Corallo <netdev-list@mattcorallo.com>
In-Reply-To: <CANn89iKfGhNYJVpj4T2MLkomkwPsYWyOof+COVvNFsfVfb7CRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/21 11:38, Eric Dumazet wrote:
> On Wed, Apr 28, 2021 at 4:28 PM Matt Corallo
> <netdev-list@mattcorallo.com> wrote:
> I have been working in wifi environments (linux conferences) where RTT
> could reach 20 sec, and even 30 seconds, and this was in some very
> rich cities in the USA.
> 
> Obviously, when a network is under provisioned by 50x factor, you
> _need_ more time to complete fragments.

Its also a trade-off - if you're in a hugely under-provisioned environment with bufferblot issues you may have some 
fragments that need more time for reassembly if they've gotten horribly reordered (though just having 20 second RTT 
doesn't imply that fragments are going to be re-ordered by 20 seconds, more likely you might see a small fraction of 
it), but you're also likely to have more *lost* fragments, which can trigger the black-holing behavior here.

If you have some loss in the flow, its very easy to hit 1Mbps of lost fragments and suddenly instead of just giving more 
time to reassemble, you're just black-holing instead. I'm not claiming I have the right trade-off here, I'd love more 
input, but at least in my experience trying to just occasionally send fragments on a pretty standard DOCSIS modem, 30s 
is way off.

> For some reason, the crazy IP reassembly stuff comes every couple of
> years, and it is now a FAQ.
> 
> The Internet has changed for the  lucky ones, but some deployments are
> using 4Mbps satellite connectivity, shared by hundreds of people.

I'd think this is a great example of a case where you precisely *dont* want such a low threshold for dropping all 
fragments. Note that in my specific deployment (standard DOCSIS), we're talking about the same speed and network as was 
available ten years ago, this isn't exactly an uncommon or particularly fancy deployment. The real issue is applications 
which happily send 8MB of fragments within a few seconds and suddenly find themselves completely black-holed for 30 
seconds, but this isn't going to just go away.

> I urge application designers to _not_ rely on doomed frags, even in
> controlled networks.

I'd love to, but we're talking about a default value for fragment reassembly. At least in my subjective experience here, 
the conservative 30s time takes things from "more time" to "completely blackhole", which feels like the wrong tradeoff. 
At the end of the day, you can't expect fragments to work super well, indeed, and you assume some amount of loss, the 
goal is to minimize the loss you see from them.

Even if you have some reordering, you're unlikely to see every fragment reordered (I guess you could imagine a horribly 
broken qdisc, does such a thing exist in practice?) such that you always need 30s to reassemble. Taking some loss to 
avoid making it so easy to completely blackhole fragments seems like a reasonable tradeoff.

Matt
