Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4385858FE9A
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 16:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbiHKOxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 10:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbiHKOxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 10:53:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB8212634;
        Thu, 11 Aug 2022 07:53:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76872615C5;
        Thu, 11 Aug 2022 14:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDF4C433C1;
        Thu, 11 Aug 2022 14:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660229627;
        bh=h9s7l7q5amy2zqf4P8tCh1Nw/YBcD+Tja4O2/0X2cmQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EXduw3SBJD1cKpcZYOylsIHo4bulVjfYb9qR7iWDyN5wFYFDEzYzxzZIoYfcTIyvi
         9A7eWf8zthVQDXeNQPAXFDeTYkHa86gcEwRrc0V1tHGaoPjTn4bN1rwwyYTTF16lYw
         0XqY4ReSb2Crakm45c2xF2jyTCQvlfHD6vYjKdzo0QQaKpoXH43UhiXtWCiwWQ6SbL
         yzGUTrUaS1GqitGGfzRNhCBhTNByAPNmQ7Wp9BGu1MsUSZn/pyXTfnlBHo4NOYXxVb
         TDjgPE20mA0o5qNjGk5pp/cRaKLMGj2ZA/fI0YH2c2WjWTU1ArFWDbot52smAhxcbA
         DYvA/1schUXGA==
Date:   Thu, 11 Aug 2022 07:53:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-kernel@vger.kernel.org, "Denis V . Lunev" <den@openvz.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        kernel@openvz.org, devel@openvz.org
Subject: Re: [PATCH v2 0/2] neighbour: fix possible DoS due to net iface
 start/stop loop
Message-ID: <20220811075346.22699ece@kernel.org>
In-Reply-To: <CAJqdLrq6D+w=H_9t8A7s0c96GyitHFTnY0a2QvUrVeuxaUdtAQ@mail.gmail.com>
References: <20220729103559.215140-1-alexander.mikhalitsyn@virtuozzo.com>
        <20220810160840.311628-1-alexander.mikhalitsyn@virtuozzo.com>
        <20220811074630.4784fe6e@kernel.org>
        <CAJqdLrq6D+w=H_9t8A7s0c96GyitHFTnY0a2QvUrVeuxaUdtAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 17:51:32 +0300 Alexander Mikhalitsyn wrote:
> On Thu, Aug 11, 2022 at 5:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 10 Aug 2022 19:08:38 +0300 Alexander Mikhalitsyn wrote:  
> > >  include/net/neighbour.h |  1 +
> > >  net/core/neighbour.c    | 46 +++++++++++++++++++++++++++++++++--------
> > >  2 files changed, 38 insertions(+), 9 deletions(-)  
> >
> > Which tree are these based on? They don't seem to apply cleanly  
> 
> It's based on 5.19 tree, but I can easily resent it based on net-next.

netdev/net would be the most appropriate tree for a fix.
Not that it differs much from net-next at this stage of 
the merge window.
