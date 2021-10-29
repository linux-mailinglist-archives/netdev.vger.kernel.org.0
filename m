Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D332243FECF
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 16:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhJ2PAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 11:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhJ2PAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 11:00:32 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8758C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 07:58:03 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id o12so24968805ybk.1
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 07:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jr8ArlXibLhBUCnJ+nTKbwdecMoXfNfv0SlCR1Npzhk=;
        b=UNeZL7iOzx3q33R6nnZrnQVPkcq7TLsPp5XynS6KYKXIH1dO2FxvfeMN43lGn9Myw2
         85DXFQWLSe0wlOdhRM89lvLZ97kuTyz+uG8fhZyVn+R+b2NP8cT0yjYIWns9ZUmwFEVW
         podHoCjRdZF74ntXpIRcJYRV5TAWiNpQ6DKjHzESIZQMYwu7PBlrg4VfcRndC/1CgU9l
         O/nsiBfuQiJUwsmfsSY9gYR2NFVTp74ix+VETvtiNPP3X7urU99Gl8wBO3ic6BB9PUpy
         QSOgW68qbmkh1kvz4SNc3yAxwPXXbxubKHrSZHLJtyt9+0LYErOAf6Eri498KVhTtPn/
         A6Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jr8ArlXibLhBUCnJ+nTKbwdecMoXfNfv0SlCR1Npzhk=;
        b=XSyLSdlE1iJtDAE156SstBLaClk0ISUtYyzVHcbs6GOIqk2dh2B2fe8SQKNfpii00T
         rtd2ggGvGqYUF3rFqIeRKJH1gj9crZU+xmpKH820NUv625gX5AnZJT7VKUKawHbUyzzR
         xnIuyZfbOfie2xOIlgjvReElVBSMxioPLHUb7aanjCivH79V26cBygc4hXDyAELLZt5i
         SGMnTHSrLT8j7vxZyTB0p30pCL2szJUc8iosst3JCcmUb60WWvDtl4AjrqNWu27dY7s1
         y6b5hO2PiwB3u+SlKlkdSKGUOHTdASC1/Hd/fq0iBhSuky+6fyBVxC6HbThh9XE5gTgA
         hJXw==
X-Gm-Message-State: AOAM533pczqd+EmxKt/SseuIr2eQh0lcMxQRH3V2vdaclFFpB6EgyTQI
        T2G15C/f1vigISeQeWLy7gFyHl8ycrdLKV9SbXnFjQ==
X-Google-Smtp-Source: ABdhPJzl5od2K9+0M93lEwjaodHYYKeVaHGMcCae6GFMnIyRiBkkR+YMO+qZ6L1SaSC0Lrdm9j4FijQ9YoAEhRL68YQ=
X-Received: by 2002:a5b:783:: with SMTP id b3mr11790588ybq.328.1635519481918;
 Fri, 29 Oct 2021 07:58:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211028191500.47377-1-asadsa@ifi.uio.no> <CADVnQykDUB4DgUaV0rd6-OKafO+F6w=BRfxviuZ_MJLY3xMV+Q@mail.gmail.com>
 <CANn89iLcTNHCudo-9=RLR1N3o1T0QgVvbedwXeTaFFo5RdMzkg@mail.gmail.com>
In-Reply-To: <CANn89iLcTNHCudo-9=RLR1N3o1T0QgVvbedwXeTaFFo5RdMzkg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 29 Oct 2021 07:57:50 -0700
Message-ID: <CANn89iKKDMh26yqyR2hYB4CCbbgKH2_LaQQCStmNM1-R0_R8xQ@mail.gmail.com>
Subject: Re: [PATCH net-next] fq_codel: avoid under-utilization with
 ce_threshold at low link rates
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Asad Sajjad Ahmed <asadsa@ifi.uio.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>,
        Bob Briscoe <research@bobbriscoe.net>,
        Olga Albisser <olga@albisser.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 7:53 AM Eric Dumazet <edumazet@google.com> wrote:

> Setting ce_threshold to 1ms while the link rate is 12Mbs sounds
> misconfiguration to me.
>

It is like using a ce_threshold of 1usec on a 10Gbit link.
About all packets would get CE marked.
