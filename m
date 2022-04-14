Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2AE500C87
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 13:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242539AbiDNMAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiDNMAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:00:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80C47DA86;
        Thu, 14 Apr 2022 04:58:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F41EB82933;
        Thu, 14 Apr 2022 11:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F64CC385A5;
        Thu, 14 Apr 2022 11:58:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="U63Cq0fl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1649937497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0+tyDdaud0kiRmw8JRN89CzIpjI4CklQbrxH74flBhI=;
        b=U63Cq0fl5eBV+Bco0G7lzZ9CpSjnbV3gIrnLyWveyQB4k2Bgzzu3oIYzMk+d4Q0ieovZ92
        O9ogC+fJ+dqpF6Df1TFUQWZPzuGaTaoLoH1QU0kYLajCg55r78TUmpHaN+ffHcfOhEBk24
        R276B/heUPweH4/IfWwDDNnXE/uUZeA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 185da3bc (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 14 Apr 2022 11:58:17 +0000 (UTC)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-2eba37104a2so53156317b3.0;
        Thu, 14 Apr 2022 04:58:16 -0700 (PDT)
X-Gm-Message-State: AOAM531LvtM07hqu5MH1UcyFktBZnILQfqSXIyRvjzbjF0oKmxZvoTsH
        FjtG0A6570SHmWI1W+HGaNbBKH+kdo5ZYsA0Xjo=
X-Google-Smtp-Source: ABdhPJw5pFFo3/eGiTk3uI3THl4Do92diVuSvMWAn3JON0H3IzibadXY4xzo3Jp01LIaTcrdhee3BfMGV1MYR9QYmIM=
X-Received: by 2002:a81:1d4:0:b0:2eb:1b10:f43e with SMTP id
 203-20020a8101d4000000b002eb1b10f43emr1685819ywb.100.1649937495961; Thu, 14
 Apr 2022 04:58:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220414104458.3097244-1-razor@blackwall.org> <20220414104458.3097244-2-razor@blackwall.org>
In-Reply-To: <20220414104458.3097244-2-razor@blackwall.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 14 Apr 2022 13:58:04 +0200
X-Gmail-Original-Message-ID: <CAHmME9qZyz26gnfcZCjAiLhYqZ9LwJN1VZ+3rgGmhxJYrGvZCw@mail.gmail.com>
Message-ID: <CAHmME9qZyz26gnfcZCjAiLhYqZ9LwJN1VZ+3rgGmhxJYrGvZCw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] wireguard: device: fix metadata_dst xmit null
 pointer dereference
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martynas Pumputis <m@lambda.lt>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

On Thu, Apr 14, 2022 at 12:45 PM Nikolay Aleksandrov
<razor@blackwall.org> wrote:
> When we try to transmit an skb with md_dst attached through wireguard
> we hit a null pointer dereference[1] in wg_xmit() due to the use of
> dst_mtu() which calls into dst_blackhole_mtu() which in turn tries to
> dereference dst->dev. Since wireguard doesn't use md_dsts we should use
> skb_valid_dst() which checks for DST_METADATA flag and if it's set then
> fallback to wireguard's device mtu. That gives us the best chance of
> transmitting the packet, otherwise if the blackhole netdev is used we'd
> get ETH_MIN_MTU.

Thanks for the patch. Will queue up this patch #1 in the wireguard
tree and send it out to net.git not before too long.

Jason
