Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692332974D8
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 18:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464863AbgJWQsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 12:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372965AbgJWQs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 12:48:29 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586D9C0613CE
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 09:48:29 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b8so2786482wrn.0
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 09:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=memsql.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZC2Dh9koWunjCaFQ0yegSpVnhZcJzrp1WPeUxVV9K1U=;
        b=ei2DFm6ifLWtvvqfEDL51CwiGCAXkhvcCTRMhU48M7dErj6QHje58qXOACqG03RsEZ
         u8NPenEqnD/YVLi1uOVbKVI8kyA/FLShuD+KMQqCzlnBaGv+F4uFNV+c3DFU4pUsHMMc
         bZa21diwQJgBd5vDZc8g15TCn0s26O/kxQpTM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZC2Dh9koWunjCaFQ0yegSpVnhZcJzrp1WPeUxVV9K1U=;
        b=CZdukocgVeJD8FXxNzGk4xDdnpfXfqlsOBG8YKCkFX6dj7xpt2HhJT8qW6aUc6kg5H
         MBhjvPDJ8NGumNIpsgCTFreaIdWoI+efbf+Ldt98V8ZV6Fp/zpZUI3t6KbiEMk6Mm9Ao
         klNtU3YjZqBFKza1x7fPls8XpQoGk7pQqKMVOrUoDqQuqFgfD8NVas2sY7RaVBpruIaB
         mZPVGLDZOk/GFcjFecstRHNvAkyHbRASG0mEkXlxkin5AS5ldL09ZVVt/zE5tCbg4MRa
         aaWLqLTx2ftG3/glDkQ/9CZ9tWzcallB4/hbrYeYUw1UEGdFA7+oJmLue6cgvrJEMbwW
         OC7A==
X-Gm-Message-State: AOAM530680ZFDu1bZ2VJ7l6Y/4bBOCAOxkTCpzj60IcZn0eJ7ULu6+0S
        cRJTWhMc39gghrQs2fZ7zFGtUg==
X-Google-Smtp-Source: ABdhPJwpEgf9jzJ4lH1LeQe5HX73reEjlkdFwZ3NHT2X1w0fwY+VwRvl3p55TC0ZnWN0ZsSok77bvA==
X-Received: by 2002:adf:8362:: with SMTP id 89mr3738705wrd.280.1603471708004;
        Fri, 23 Oct 2020 09:48:28 -0700 (PDT)
Received: from rdias-suse-pc.lan (bl13-26-148.dsl.telepac.pt. [85.246.26.148])
        by smtp.gmail.com with ESMTPSA id m14sm4508047wro.43.2020.10.23.09.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 09:48:27 -0700 (PDT)
Date:   Fri, 23 Oct 2020 17:48:25 +0100
From:   Ricardo Dias <rdias@memsql.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tcp: fix race condition when creating child sockets from
 syncookies
Message-ID: <20201023164825.GA321826@rdias-suse-pc.lan>
References: <20201023111352.GA289522@rdias-suse-pc.lan>
 <CANn89iJDt=XpUZA_uYK98cK8tctW6M=f4RFtGQpTxRaqwnnqSQ@mail.gmail.com>
 <20201023155145.GA316015@rdias-suse-pc.lan>
 <CANn89iL2VOH+Mg9-U7pkpMkKykDfhoX-GMRnF-oBmZmCGohDtA@mail.gmail.com>
 <20201023160628.GA316690@rdias-suse-pc.lan>
 <CANn89i+OZF2HJQYT0FGtzyFeZMdof9RAfGXQRKUVY6Hg9ZPpcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+OZF2HJQYT0FGtzyFeZMdof9RAfGXQRKUVY6Hg9ZPpcg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 06:36:29PM +0200, Eric Dumazet wrote:
> On Fri, Oct 23, 2020 at 6:06 PM Ricardo Dias <rdias@memsql.com> wrote:
> 
> > And what about the loopback interface? Why couldn't the loopback
> > interface also use a single RX queue?
> >
> 
> Loopback is using a per-cpu queue, with no crossing, for efficiency.
> 
> That means : whenever a packet is sent on lo interface from CPU X, it
> is put on CPU X backlog queue.
> 
> If the connect() and sendmsg() are run from different cpus, then the
> ACK (from last packet of 3WH) and the data packet might land on
> different queues.

In that case, I can change the patch to only iterate the ehash bucket
only when the listening socket is using the loopback interface, correct?


