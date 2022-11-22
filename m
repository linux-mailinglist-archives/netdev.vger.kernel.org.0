Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7292D6343A1
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbiKVSaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbiKVSaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:30:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7656D5DBBD
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:30:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 301C0B81D2C
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 18:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA601C433C1;
        Tue, 22 Nov 2022 18:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669141806;
        bh=UG9uKD1tv66OhEDb3l+yBrmeQtYL23MCcMh6/vmEMB0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pxUu9Jp3hc/n/PGyOHHdgePnXe1srOKEvUk3zTvXNMySMYRCwofs/OHq4isR7HMiE
         39z2yvv7JRkCn0CYcOQc95W9Dk1e9o8ZRKDLcwSlAhZ0KJjyJeY/nKgxOtl+BCCghY
         MqomrhcWOLTvEdv/9Gct1nUSJmhQdAKpZISkmQGv+lnMektefx5FzYmCtlEHFaVZTF
         bbVX72ADUD8h+/GlsuYUS0WrblM6skP/l0LjQHEj9GblIVb/oMn8cWOxpSwEZxVwUT
         apmMs155UImVIwe0/yzbfZVUp//fcnSfAk+PdkWwtckJGTqHbqmcNx9G4DNmLejYKv
         RiUpz8zYZ72FQ==
Date:   Tue, 22 Nov 2022 10:30:05 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jamie Bainbridge <jamie.bainbridge@gmail.com>
Subject: Re: [PATCH net-next] tcp: Fix build break when CONFIG_IPV6=n
Message-ID: <Y30VLZGDYHAk+lSL@x130.lan>
References: <20221122093131.161499-1-saeed@kernel.org>
 <CAMuHMdVQAkPhtEdq=-kwQE8v2sgyCx_bD-f2yk95Fc7t4Fz56w@mail.gmail.com>
 <CANn89i+1JanTp=HacjfLkKR_nnC4vA4VJz2tMzAqEb+cFn_3tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89i+1JanTp=HacjfLkKR_nnC4vA4VJz2tMzAqEb+cFn_3tw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22 Nov 08:42, Eric Dumazet wrote:
>On Tue, Nov 22, 2022 at 1:37 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>
>> Hi Saeed,
>>
>> On Tue, Nov 22, 2022 at 10:31 AM Saeed Mahameed <saeed@kernel.org> wrote:
>> > From: Saeed Mahameed <saeedm@nvidia.com>
>> >
>> > The cited commit caused the following build break when CONFIG_IPV6 was
>> > disabled
>> >
>> > net/ipv4/tcp_input.c: In function ‘tcp_syn_flood_action’:
>> > include/net/sock.h:387:37: error: ‘const struct sock_common’ has no member named ‘skc_v6_rcv_saddr’; did you mean ‘skc_rcv_saddr’?
>> >
>> > Fix by using inet6_rcv_saddr() macro which handles this situation
>> > nicely.
>> >
>> > Fixes: d9282e48c608 ("tcp: Add listening address to SYN flood message")
>> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>>
>> Thanks for your patch!
>>
>> > --- a/net/ipv4/tcp_input.c
>> > +++ b/net/ipv4/tcp_input.c
>> > @@ -6843,9 +6843,9 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
>> >
>> >         if (!READ_ONCE(queue->synflood_warned) && syncookies != 2 &&
>> >             xchg(&queue->synflood_warned, 1) == 0) {
>> > -               if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
>> > +               if (sk->sk_family == AF_INET6) {
>>
>> I think the IS_ENABLED() should stay, to make sure the IPV6-only
>> code is optimized away when IPv6-support is disabled.
>
>Agreed.

sending V2.

but for the record, I don't think such a user exist. Simply if you care
about such micro optimization, then you are serious enough not to disable
IPv6.

