Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E8D2A9403
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 11:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgKFKVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 05:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbgKFKVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 05:21:10 -0500
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CB1C0613CF;
        Fri,  6 Nov 2020 02:21:10 -0800 (PST)
Received: by mail-qk1-x743.google.com with SMTP id r7so584297qkf.3;
        Fri, 06 Nov 2020 02:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UXqRBQbHsD6Rb/zBf/i8QK+56/Xf9uE8Ats9BY4Fm3o=;
        b=XPwNVPUCYHjjSo2Tvaxwb5x5k/TJj8hZbWGjTnQwFpFIUpdLY2o8Jpk96X94YiPBpZ
         msAKLNKEP0U2MRnAg1FPq3klo6pG4o6w8wGK7kxUQASAYdomXPPI5bF+hR+Rg3W5jqpn
         Vg6ZRmaiTmh28hbSkieVzALqKsyUcy/AfdfV1BFpgCi2YqmbyY7nYDGZDsIOvqCXnXsb
         l0+v31qH2OH+CAjmkxWuGkrr2ta2SOtUvnPRkzD7nGVhSMGqHMvDJZUGOf5ujMwozkUx
         sPTw2INqwdeafuYxrEdDUGgzkOK17Jua8BYi+Xfsun2zLpTbra2COCPfEb6ZCT3eaW9b
         XyCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UXqRBQbHsD6Rb/zBf/i8QK+56/Xf9uE8Ats9BY4Fm3o=;
        b=pDKnQX4pWRZFekyCTBi995iwc69134lF2gnGoKK/5z/ieA45K/kw9xg4dxAZ+lZiMP
         MvXrpb+UOkV6tDFRU7VU2s/jT+dAvYBDSJpzNaIP1xMN6H57c85P8Hm/fMA7hpcVEGwN
         tKbZm4y/kmH9i0dqx95fBqZPU2MewvABATyyTH95b614tQNVFBcGIBGe18pGx8VHq7ov
         jwI4afnDnKdJM8pi5WMukh+9nhkUW0xjI3xbfg7p2mu6+hrzEGBjs4lgcuHE2FBEna7f
         4WYQ/iDzmfvg/msGaX2csImeIibR4E6tHHPcwxEnYTxEE2FTHabgQGe9bhxbpVODNgLX
         IgKQ==
X-Gm-Message-State: AOAM531//jrMn+R9ke8uKS9X55srAvQuDja2mzVgHa4seEnE2JGoCctL
        BrszNaj+ZKxq946zBVeO3rM=
X-Google-Smtp-Source: ABdhPJw5MppbbUgb3kUr4w/nA0ZljgruhSVMT0SxwI/DEO2YPPQw2Zu1OJkSzp2DGTs1y2mO/sqJpA==
X-Received: by 2002:a37:6b07:: with SMTP id g7mr770883qkc.265.1604658069161;
        Fri, 06 Nov 2020 02:21:09 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f016:78d6:ae13:4668:2f4c:ca7a])
        by smtp.gmail.com with ESMTPSA id n7sm264150qtp.93.2020.11.06.02.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 02:21:08 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 4C688C1B80; Fri,  6 Nov 2020 07:21:06 -0300 (-03)
Date:   Fri, 6 Nov 2020 07:21:06 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Petr Malat <oss@malat.biz>
Cc:     linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: Fix sending when PMTU is less than
 SCTP_DEFAULT_MINSEGMENT
Message-ID: <20201106102106.GB3556@localhost.localdomain>
References: <20201105103946.18771-1-oss@malat.biz>
 <20201106084634.GA3556@localhost.localdomain>
 <20201106094824.GA7570@bordel.klfree.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106094824.GA7570@bordel.klfree.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 10:48:24AM +0100, Petr Malat wrote:
> On Fri, Nov 06, 2020 at 05:46:34AM -0300, Marcelo Ricardo Leitner wrote:
> > On Thu, Nov 05, 2020 at 11:39:47AM +0100, Petr Malat wrote:
> > > Function sctp_dst_mtu() never returns lower MTU than
> > > SCTP_TRUNC4(SCTP_DEFAULT_MINSEGMENT) even when the actual MTU is less,
> > > in which case we rely on the IP fragmentation and must enable it.
> > 
> > This should be being handled at sctp_packet_will_fit():
> 
> sctp_packet_will_fit() does something a little bit different, it
> allows fragmentation, if the packet must be longer than the pathmtu
> set in SCTP structures, which is never less than 512 (see
> sctp_dst_mtu()) even when the actual mtu is less than 512.
> 
> One can test it by setting mtu of an interface to e.g. 300,
> and sending a longer packet (e.g. 400B):
> >           psize = packet->size;
> >           if (packet->transport->asoc)
> >                   pmtu = packet->transport->asoc->pathmtu;
> >           else
> >                   pmtu = packet->transport->pathmtu;
> here the returned pmtu will be 512

Thing is, your patch is using the same vars to check for it:
+       pmtu = tp->asoc ? tp->asoc->pathmtu : tp->pathmtu;

> 
> > 
> >           /* Decide if we need to fragment or resubmit later. */
> >           if (psize + chunk_len > pmtu) {
> This branch will not be taken as the packet length is less then 512

Right, ok. While then your patch will catch it because pmtu will be
SCTP_DEFAULT_MINSEGMENT, as it is checking with '<='.

> 
> >            }
> > 
> And the whole function will return SCTP_XMIT_OK without setting
> ipfragok.
> 
> I think the idea of never going bellow 512 in sctp_dst_mtu() is to
> reduce overhead of SCTP headers, which is fine, but when we do that,
> we must be sure to allow the IP fragmentation, which is currently
> missing.

Hmm. ip frag is probably just worse than higher header/payload
overhead.

> 
> The other option would be to keep track of the real MTU in pathmtu
> and perform max(512, pathmtu) in sctp_packet_will_fit() function.

I need to check where this 512 came from. I don't recall it from top
of my head and it's from before git history. Maybe we should just drop
this limit, if it's artificial. IPV4_MIN_MTU is 68.

> 
> Not sure when exactly this got broken, but using MTU less than 512
> used to work in 4.9.

Uhh, that's a bit old already. If you could narrow it down, that would
be nice.

  Marcelo
