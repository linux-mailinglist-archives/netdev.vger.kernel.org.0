Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E81613764
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 14:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiJaNH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 09:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJaNH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 09:07:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE6D26E7;
        Mon, 31 Oct 2022 06:07:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F7736120B;
        Mon, 31 Oct 2022 13:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22ADC433C1;
        Mon, 31 Oct 2022 13:07:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MmQJALq7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1667221670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=066nlii8sLRwns6G0fh9UJOIf7iqKUOWghwvkHsSMpc=;
        b=MmQJALq7M1//KnUb45FCh0Id62AEeZiaG4Dqtw3GetKb1Umvaf36tdyVSbuXTR91Ixco+C
        wtxRZpYn9Z5n+Fs/EfBzLhHRol8bKWTLWzg83/D2sY+Zt97Raob6jjdPR3R7ITlPUaTfGu
        hrKEEJnCZ0TZ8d4o4FFZeCp3Vxmgn+A=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 62f39b6c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 31 Oct 2022 13:07:49 +0000 (UTC)
Date:   Mon, 31 Oct 2022 14:07:45 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] wireguard (gcc13): cast enum limits members to int in
 prints
Message-ID: <Y1/IoR44xGaVTRUf@zx2c4.com>
References: <20221031114424.10438-1-jirislaby@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221031114424.10438-1-jirislaby@kernel.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Mon, Oct 31, 2022 at 12:44:24PM +0100, Jiri Slaby (SUSE) wrote:
> Since gcc13, each member of an enum has the same type as the enum [1]. And
> that is inherited from its members. Provided "REKEY_AFTER_MESSAGES = 1ULL
> << 60", the named type is unsigned long.
> 
> This generates warnings with gcc-13:
>   error: format '%d' expects argument of type 'int', but argument 6 has type 'long unsigned int'
> 
> Cast the enum members to int when printing them.
> 
> Alternatively, we can cast it to ulong (to silence gcc < 12) and use %lu.
> Alternatively, we can move REKEY_AFTER_MESSAGES away from the enum.
> 
> [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113

Huh, interesting situation. It's interesting that 1<<60 even works at
all on old gccs. I guess that in this case, it just takes the type of
the actual constant, rather than of the enum type?

Either way, I'll apply (a version of) your patch and push it back out on
the next wireguard fixup series.

Thanks for this.

Jason
