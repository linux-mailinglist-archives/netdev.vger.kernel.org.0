Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D778B466B45
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 21:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349053AbhLBVBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349050AbhLBVBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 16:01:32 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9AEC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 12:58:08 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id t5so3347581edd.0
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 12:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HcTVzhqFSvLowOEDknCAUMicLuvrddnoa9qVRIf3a1o=;
        b=k3fEnWEz6ir+1AmqnTmTiYxRmczfrA2BJ7Ve1yRvvYTHtyNMyK4h4hEGM/Mcn8cm3U
         /p6/wHUy8eZ+fEPQFoknGUXBwCBAN3wNU8TDRjDPAIkE7vl+EVtlmKnc4mpNutwWUGZo
         4GdZI3f2J0UV9M/8SZty4mkJ6Zs5zRJC11rlsKMDjQExIeeFYc7ctzjj06Nzh1a753An
         ZO6jmXTKMcrNMD4It14MMa3YJDJoHmJUt6LJrcG9Q9Z4WUhV3Gg/vQXSrIw1fZr5oSmV
         yxK49dpbAkcQrPFbF0UAIhSTFojnyXFsrWcHb8rI2Lb6cuRcqPSLyorpvU2iYfFa0Tdb
         WqIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HcTVzhqFSvLowOEDknCAUMicLuvrddnoa9qVRIf3a1o=;
        b=ZT8OEdivsAeex1SLpUB38zVnj0DoODoeEERyr5Sk/Cq1jWEoyrXJocVGhoHpJJ9pjJ
         XFsd/jh/O3mOT3S/eDoGVXiBAYhpaDKb6I5fiZPYq9xDPDAdn0baJMKZh9BWtmpwUSxb
         MwQL4K1boJW+IECL6KemP6W/UxVNs4ZXs/jyusJfA/2uyQHyNypGuexi0U0vnJLiq0of
         nmBEwqBM6X1VY/jUkPO8o8Xg3V09WCbzDstlyhsSLKIdolz4yY84FPx+ntdkY/5+GnOZ
         oB6+FB80b2srS+YGCGsq90fePWugeVSGoYO7KJTp9vL4VtaZqjLoAuRlsmaS4Watw2ZX
         O0vw==
X-Gm-Message-State: AOAM532v5p5M3pdW2jg70dlNpfdKsxd4A6b7gn4SW7T1ib4iI1/jjNo5
        58TOMrL81ZkjQCT3Ru/2hT0=
X-Google-Smtp-Source: ABdhPJzfu7Jv1Vx4PXF000PXDIC5KQ0UPyO4lFVlAjE7dmjF4tvbVkiCp/Le9fD0iyYslTp0WOotsw==
X-Received: by 2002:a17:907:a426:: with SMTP id sg38mr18270078ejc.392.1638478687406;
        Thu, 02 Dec 2021 12:58:07 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id b14sm556934edw.6.2021.12.02.12.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 12:58:07 -0800 (PST)
Date:   Thu, 2 Dec 2021 22:58:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Message-ID: <20211202205806.kw4v5grupjlzober@skbuf>
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com>
 <20211202131040.rdxzbfwh2slhftg5@skbuf>
 <CANn89iLW4kwKf0x094epVeCaKhB4GtYgbDwE2=Fp0HnW8UdKzw@mail.gmail.com>
 <20211202162916.ieb2wn35z5h4aubh@skbuf>
 <CANn89iJEfDL_3C39Gp9eD=yPDqW4MGcVm7AyUBcTVdakS-X2dg@mail.gmail.com>
 <20211202204036.negad3mnrm2gogjd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202204036.negad3mnrm2gogjd@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 10:40:36PM +0200, Vladimir Oltean wrote:
> To me it looks like the strange part is that the checksum of the removed
> block (printed by me as "csum_partial(start, len, 0)" inside
> skb_postpull_rcsum()) is the same as the skb->csum itself.
> 
> [   66.287583] fsl_enetc 0000:00:00.2 eno2: enetc_get_offloads 991: skb 0xffff4050c3671f00 csum 0x3c1d
> [   66.296716] skb csum of 20 bytes (20 to the left of skb->data) using old method: 0x0, new method: 0xffffffff, orig csum 0x3c1d, csum of removed block 0x3c1d

sorry, this line is confusing, what is printed as the "old method" is in
fact the "new method" and viceversa. I tried to rename them from
something clearer than "method 1" and "method 2" and failed.

> [   66.310786] skb len=84 headroom=98 headlen=84 tailroom=1546
> [   66.310786] mac=(84,-6) net=(78,0) trans=78
> [   66.310786] shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
> [   66.310786] csum(0xffffffff ip_summed=2 complete_sw=0 valid=0 level=0)
> [   66.310786] hash(0x0 sw=0 l4=0) proto=0x00f8 pkttype=3 iif=7
> [   66.338997] dev name=eno2 feat=0x0x00020100001149a9
> [   66.343904] skb headroom: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   66.351600] skb headroom: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   66.359295] skb headroom: 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   66.366990] skb headroom: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   66.374685] skb headroom: 00000040: 88 80 00 0a 00 38 c1 17 3d 01 01 80 00 00 08 0f
> [   66.382379] skb headroom: 00000050: 00 10 00 00 52 f3 98 af f9 8c d2 ee 27 92 2d 6c
> [   66.390073] skb headroom: 00000060: 08 00
> [   66.394105] skb linear:   00000000: 45 00 00 54 c8 59 40 00 40 01 28 fb c0 a8 64 01
> [   66.401799] skb linear:   00000010: c0 a8 64 02 08 00 ee 94 06 98 00 04 03 2e a9 61
> [   66.409493] skb linear:   00000020: 00 00 00 00 8b 6c 0c 00 00 00 00 00 10 11 12 13
> [   66.417187] skb linear:   00000030: 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23
> [   66.424880] skb linear:   00000040: 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33
> [   66.432574] skb linear:   00000050: 34 35 36 37
> [   66.437128] skb tailroom: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   67.181735] fsl_enetc 0000:00:00.2 eno2: ocelot_rcv 131: skb 0xffff4050c3671f00 csum before skb_postpull_rcsum 0x3c1d, after 0xffffffff
