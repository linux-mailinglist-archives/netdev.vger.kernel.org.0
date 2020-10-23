Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A381A2972E4
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464044AbgJWPvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 11:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S464023AbgJWPvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 11:51:49 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B34FC0613D2
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 08:51:49 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 13so2041322wmf.0
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 08:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=memsql.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j2altdvxVq9cTYOvLlN5vG2qWrVwolDphAk1PBfg2CI=;
        b=fDSaLV0j8opjb1K4Obxvjhuc0SWqGRZKReKoaUApOOEfnqdjYl8trGPcK29p2ASXLK
         K8muKg48DO9Ls2LcWdspp+yS08IFOoWkGSb8RHVGXXimJKlx0EjgBzfutWyBcQAhJIFH
         6GFXBBAoU+Tq/ox8lvTp5eORSmwYNqP9TE51k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j2altdvxVq9cTYOvLlN5vG2qWrVwolDphAk1PBfg2CI=;
        b=QZD+zXl476zA0XvFNG21VUfBrpReNLRxwXuIRNiNgzEuxMPLcqvuiitZEtiZfzVmwS
         1ecwnVazL7HVd7IrohosxF87oho+hZiT76kFQpNc0Cgdy0oSoHT8htQV2YAqdMvQRpm+
         07/Hx/HXFpFH7bq0G2rhw4soNZM+OxH99x4fEOISyJmvYiC8yQ5HZuKZOEcnkRmHFmdF
         VgKIw37Yk1RH6yTT0GjBu4LiKdvV36xpq+O9YXsSoFB3ETBELgvcKPKp2x4JiC1avWLe
         nkY3UUQ29SC/irWRT9syXQwSbqyZq2dyuqM5+06+JPMxqA4ScNpZezQaA2CH10AR5oqI
         tlsg==
X-Gm-Message-State: AOAM530Vwtqcw3eS8YAUn/1S+czRKdbrrECqHEIKWU7Z2ZgqZEGxTzZ2
        IS17NuOcw07E5erYPr2Ppy8oWA==
X-Google-Smtp-Source: ABdhPJwymsnIFYrZtPVNSAPU+nSyT71nB9LNizj5vVMluTmUGvHCPAZSFHbWbAUupG4G//xVWcYesg==
X-Received: by 2002:a1c:e154:: with SMTP id y81mr3069246wmg.111.1603468308043;
        Fri, 23 Oct 2020 08:51:48 -0700 (PDT)
Received: from rdias-suse-pc.lan (bl13-26-148.dsl.telepac.pt. [85.246.26.148])
        by smtp.gmail.com with ESMTPSA id a127sm4426442wmh.13.2020.10.23.08.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 08:51:47 -0700 (PDT)
Date:   Fri, 23 Oct 2020 16:51:45 +0100
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
Message-ID: <20201023155145.GA316015@rdias-suse-pc.lan>
References: <20201023111352.GA289522@rdias-suse-pc.lan>
 <CANn89iJDt=XpUZA_uYK98cK8tctW6M=f4RFtGQpTxRaqwnnqSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJDt=XpUZA_uYK98cK8tctW6M=f4RFtGQpTxRaqwnnqSQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 04:03:27PM +0200, Eric Dumazet wrote:
> On Fri, Oct 23, 2020 at 1:14 PM Ricardo Dias <rdias@memsql.com> wrote:
> >
> > When the TCP stack is in SYN flood mode, the server child socket is
> > created from the SYN cookie received in a TCP packet with the ACK flag
> > set.
> >
> ...
> 
> This patch only handles IPv4, unless I am missing something ?

Yes, currently the patch only handles IPv4. I'll improve it to also
handle the IPv6 case. 

> 
> It looks like the fix should be done in inet_ehash_insert(), not
> adding yet another helper in TCP.
> This would be family generic.

Ok, sounds good as long as there is not problem in changing the
signature and semantics of the inet_ehash_insert() function, as well as
changing the inet_ehash_nolisten() function.

> 
> Note that normally, all packets for the same 4-tuple should be handled
> by the same cpu,
> so this race is quite unlikely to happen in standard setups.

I was able to write a small client/server program that used the
loopback interface to create connections, which could hit the race
condition in 1/200 runs.

The server when accepts a connection sends an 8 byte identifier to
the client, and then waits for the client to echo the same identifier.
The client creates hundreds of simultaneous connections to the server,
and in each connection it sends one byte as soon as the connection is
established, then reads the 8 byte identifier from the server and sends
it back to the server.

When we hit the race condition, one of the server connections gets an 8
byte identifier different from its own identifier.

