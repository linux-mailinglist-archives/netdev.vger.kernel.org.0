Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6BB5FF2E0
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 19:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiJNRUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 13:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiJNRUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 13:20:45 -0400
Received: from mail.codeweavers.com (mail.codeweavers.com [65.103.31.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7EF57258;
        Fri, 14 Oct 2022 10:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=codeweavers.com; s=6377696661; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EyQhJSXWD0na1sAKSM1PZmYSSPO/aWIU0nptxObWazE=; b=uEgxfjID/ryR0D1gRZ5Kc09HlE
        6aAUzHPkO0ssSS1gUAxN1YIpuxr/6H8jkg/fuvGKw+lSPUpK9OCDp8O/A0OChVftlUhk1anfpqUDK
        b4eciePkveCm2K67nUpu4jLTLLycFy1haQSV2hE+KcrVnMUOoUCLenkosWfDFqYPIeWo=;
Received: from cw141ip123.vpn.codeweavers.com ([10.69.141.123])
        by mail.codeweavers.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <pgofman@codeweavers.com>)
        id 1ojOMS-00GB8q-88; Fri, 14 Oct 2022 12:20:40 -0500
Message-ID: <03031c84-baa0-fe99-b1d7-44963cad0001@codeweavers.com>
Date:   Fri, 14 Oct 2022 12:20:37 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [RFC] EADDRINUSE from bind() on application restart after killing
Content-Language: en-GB
To:     Eric Dumazet <edumazet@google.com>
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        "open list:NETWORKING [TCP]" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <5099dc39-c6d9-115a-855b-6aa98d17eb4b@collabora.com>
 <8dff3e46-6dac-af6a-1a3b-e6a8b93fdc60@collabora.com>
 <CANn89iLOdgExV3ydkg0r2iNwavSp5Zu9hskf34TTqmCZQCfUdA@mail.gmail.com>
 <5db967de-ea7e-9f35-cd74-d4cca2fcb9ee@codeweavers.com>
 <CANn89iJTNUCDLptS_rV4JUDcEH8JNXvOTx4xgzvaDHG6eodtXg@mail.gmail.com>
 <81b0e6c9-6c13-aecd-1e0e-6417eb89285f@codeweavers.com>
 <CANn89iKD=ceuLnhK-zpk3QerpS-FUb_wb_HevkpvsVqGJ_T4NQ@mail.gmail.com>
 <342a762d-22f5-b979-411f-aab0474feda2@codeweavers.com>
 <CANn89iKoaLRupASAJKW5ZprXhSMiXSs7vi5UT=wEU11R5+iLZQ@mail.gmail.com>
From:   Paul Gofman <pgofman@codeweavers.com>
In-Reply-To: <CANn89iKoaLRupASAJKW5ZprXhSMiXSs7vi5UT=wEU11R5+iLZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/22 11:45, Eric Dumazet wrote:
> On Fri, Oct 14, 2022 at 9:39 AM Paul Gofman <pgofman@codeweavers.com> wrote:
>
> I think it is documented.
>
> man 7 socket
>
>         SO_REUSEADDR
>                Indicates that the rules used in validating addresses
> supplied in a bind(2) call should allow reuse of local addresses.  For
> AF_INET sockets this means
>                that a socket may bind, except when there is an active
> listening socket bound to the address.  When the listening socket is
> bound to INADDR_ANY with  a
>                specific port then it is not possible to bind to this
> port for any local address.  Argument is an integer boolean flag.
>
> You seem to need another way, so you will have to ask this question in IETF.
Thanks a lot, I think it answers my question, I am afraid I was reading 
this a bit wrong.
