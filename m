Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008AA467B1A
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 17:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbhLCQSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 11:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238837AbhLCQSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 11:18:14 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15E5C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 08:14:49 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id y13so13470762edd.13
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 08:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qOK8iUXpKDtshLKXbEzuxzFWHAuraVg3kVy5fN0voAk=;
        b=VArjfpIsvH7R37KlNSdcBWmjGSZIJqnqn1EnSvl8n7a8QAUXYDblPj4hhC2rVV3gSc
         /HwrwJYJh8wxrf4eLI/u0GJkvtLfHyYGNuE7qS21BqexrswUPfAFx8IupyRHWjQmFdyu
         OpLuS5ztvgtTTMLF/K8chaNP/urkxVy+J82sefAzMDnq0jdQhGptNRXyuQzL9NUUIGJX
         AywgnwfPlvlaoWRn4TqVeNikb3CDgXgRD1hPyDWta0nDDd+2CkbFLQlPpBfjyzM3cdjY
         zGZoXnW6HFUyER5ilFML2CKhG+JGwqiYZKhhUmgce4E1BeA2QMwlf2pTFp0JbmHoA4wR
         VzMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qOK8iUXpKDtshLKXbEzuxzFWHAuraVg3kVy5fN0voAk=;
        b=Qu6hlzXBC7ddgcgVeDXKMkVauJ0ugu2s82/sHaFbfgwXpVvJ051+i3Q5oVzJtN6e7I
         k5Wdrc6gRrH6aw2EEYJx8SLrH23xRFVOYmIWcD4ICdlBNqFng4isf259m9s6QISWkId5
         9yKY6UAPbx1eSSKm+T2q4w0D/uGMGl7QHyo2W5aA7+bW7LQjzSzwCWnlzN7QWWxa16qQ
         fuDvCEn2Um/vySEOaYzHYO8n5+hG/XmttH8j22qnn+rt/L4sa5ghnkq9seW6pJTEEUIw
         l9Pkko7Gj3u6we5ofZ951rHdbvHlJ0aAVFbzXU62e1baMzXyFxsDjFp0164Hx664FvqZ
         GKpQ==
X-Gm-Message-State: AOAM533o7TnlZNdsEmaXxAG/nz2b9wjeOOjRevbWAwoo1zQibBv81RIc
        hhoYTABumI0SAQdpmERKVnuwbBwcgs0=
X-Google-Smtp-Source: ABdhPJwKgEdtAc9TV9frP08kvkgmb/kIL3rQ0YP3AWft0f5I1pRzvgOZ64QXwpAatfmaUCTEO/tGAw==
X-Received: by 2002:a17:907:3f95:: with SMTP id hr21mr24808575ejc.427.1638548071461;
        Fri, 03 Dec 2021 08:14:31 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id el20sm2109680ejc.40.2021.12.03.08.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 08:14:31 -0800 (PST)
Date:   Fri, 3 Dec 2021 18:14:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Message-ID: <20211203161429.htqt4vuzd22rlwkf@skbuf>
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com>
 <20211202131040.rdxzbfwh2slhftg5@skbuf>
 <CANn89iLW4kwKf0x094epVeCaKhB4GtYgbDwE2=Fp0HnW8UdKzw@mail.gmail.com>
 <20211202162916.ieb2wn35z5h4aubh@skbuf>
 <CANn89iJEfDL_3C39Gp9eD=yPDqW4MGcVm7AyUBcTVdakS-X2dg@mail.gmail.com>
 <20211202204036.negad3mnrm2gogjd@skbuf>
 <9eefc224988841c9b1a0b6c6eb3348b8@AcuMS.aculab.com>
 <20211202214009.5hm3diwom4qsbsjd@skbuf>
 <eb25fee06370430d8cd14e25dff5e653@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb25fee06370430d8cd14e25dff5e653@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 02:57:04PM +0000, David Laight wrote:
> From: Vladimir Oltean
> > Sent: 02 December 2021 21:40
> ...
> > >
> > > Try replacing both ~ with -.
> > > So replace:
> > > 		skb->csum = ~csum_partial(start, len, ~skb->csum);
> > > with:
> > > 		skb->csum = -csum_partial(start, len, -skb->csum);
> > >
> > > That should geneate ~0u instead 0 (if I've got my maths right).
> > 
> > Indeed, replacing both one's complement operations with two's complement
> > seems to produce correct results (consistent with old code) in all cases
> > that I am testing with (ICMP, TCP, UDP). Thanks!
> 
> You need to generate (or persuade Eric to generate) a patch.
> I don't have the right source tree.
> 
> Any code that does ~csum_partial() is 'dubious' unless followed
> by a check for 0.
> The two's compliment negate save the conditional - provided the
> offset of 1 can be added in earlier.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

Eric, could you please send a patch with this change?
If you want and if it helps, I can also help you reproduce this locally
using the dsa_loop mockup driver.
