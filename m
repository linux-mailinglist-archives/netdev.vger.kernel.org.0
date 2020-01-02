Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA41E12E6CF
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 14:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgABN2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 08:28:51 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:57490 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728323AbgABN2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 08:28:50 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1in0Wl-005R8Q-C2; Thu, 02 Jan 2020 14:28:39 +0100
Message-ID: <1762437703fd150bb535ee488c78c830f107a531.camel@sipsolutions.net>
Subject: Re: PROBLEM: Wireless networking goes down on Acer C720P Chromebook
 (bisected)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Stephen Oberholtzer <stevie@qrpff.net>, toke@redhat.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 02 Jan 2020 14:28:35 +0100
In-Reply-To: <CAD_xR9eDL+9jzjYxPXJjS7U58ypCPWHYzrk0C3_vt-w26FZeAQ@mail.gmail.com> (sfid-20200101_015805_066597_5A8428D1)
References: <CAD_xR9eDL+9jzjYxPXJjS7U58ypCPWHYzrk0C3_vt-w26FZeAQ@mail.gmail.com>
         (sfid-20200101_015805_066597_5A8428D1)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-12-31 at 19:49 -0500, Stephen Oberholtzer wrote:
> Wireless networking goes down on Acer C720P Chromebook (bisected)
> 
> Culprit: 7a89233a ("mac80211: Use Airtime-based Queue Limits (AQL) on
> packet dequeue")
> 
> I found that the newest kernel (5.4) displayed a curious issue on my
> Acer C720P Chromebook: shortly after bringing networking up, all
> connections would suddenly fail.  I discovered that I could
> consistently reproduce the issue by ssh'ing into the machine and
> running 'dmesg' -- on a non-working kernel; I would get partial
> output, and then the connection would completely hang. This was so
> consistent, in fact, that I was able to leverage it to automate the
> process from 'git bisect run'.
> 
> KEYWORDS: c720p, chromebook, wireless, networking, mac80211
> 
> KERNEL: any kernel containing commit 7a89233a ("mac80211: Use
> Airtime-based Queue Limits (AQL) on packet dequeue")
> 
> I find this bit in the offending commit's message suspicious:
> 
> > This patch does *not* include any mechanism to wake a throttled TXQ again,
> > on the assumption that this will happen anyway as a side effect of whatever
> >  freed the skb (most commonly a TX completion).
> 
> Methinks this assumption is not a fully valid one.

I think I found at least one hole in this, but IIRC (it was before my
vacation, sorry) it was pretty unlikely to actually happen. Perhaps
there are more though.

https://lore.kernel.org/r/b14519e81b6d2335bd0cb7dcf074f0d1a4eec707.camel@sipsolutions.net


> I'll be happy to test any patches. If you need some printk calls, just
> tell me where to put 'em.

Do you get any output at all? Like a WARN_ON() for an underflow, or
something?

johannes

