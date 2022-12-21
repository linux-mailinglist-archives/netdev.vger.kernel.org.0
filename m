Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2B56535FF
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 19:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbiLUSQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 13:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiLUSQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 13:16:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D6525A;
        Wed, 21 Dec 2022 10:16:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1114B81BE3;
        Wed, 21 Dec 2022 18:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544D8C433EF;
        Wed, 21 Dec 2022 18:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671646601;
        bh=U2B14lwdBibL4H0DghSmBCWEFem5J9yzy1hl/N9eCgc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gNNyHzDXCFgjJKB4hCmvsBkRgHFU3/44T3h0wCUpqZVhvohpVuRAGz6BB4/4GHcLW
         8fSh59mEq5xYyf1YFLf7atfiG3tMH+YagGv0Y5q3rxCca2c3fc8uoEWGO+G5wdM/so
         cqiQuaTLBWgG6hY77lgXV9jKvOD0lIjoUnMkCpNLGAaUH9Wy9kfWGFTPvzjDEQAZUM
         SlV4/EX2iUAzAuajIiH7NVx3Ay152otsCW1oebkv1ZKJcUfFiMlK1RXk5rE+VfhT4/
         ldsulQi6ujCN22A8P4cys7F9Jg++o7N5RmmU7QARJIJwnw7WlcRQxqHoj1HI87LdwT
         dnflSZCL7CHcQ==
Date:   Wed, 21 Dec 2022 10:16:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PULL] Networking for v6.2-rc1
Message-ID: <20221221101640.136fda18@kernel.org>
In-Reply-To: <CAHk-=wg-W+0gh-XeUrN409RvdOO=VpcWiiPUNm2=Jru5bKWRDQ@mail.gmail.com>
References: <20221220203022.1084532-1-kuba@kernel.org>
        <CAHk-=wg-W+0gh-XeUrN409RvdOO=VpcWiiPUNm2=Jru5bKWRDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Dec 2022 09:16:35 -0800 Linus Torvalds wrote:
> On Tue, Dec 20, 2022 at 12:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Traffic is winding down significantly so let us pass our fixes to you
> > earlier than the usual Thu schedule.
> >
> > We have a fix for the BPF issue we were looking at before 6.1 final,
> > no surprises there. RxRPC fixes were merged relatively late so there's
> > an outpour of follow ups. Last one worth mentioning is the tree-wide
> > fix for network file systems / in-tree socket users, to prevent nested
> > networking calls from corrupting socket memory allocator.  
> 
> The  biggest changes seem to be to the intel 2.5Gb driver ("igc"), but
> they weren't mentioned...

Right, it was an odd is-it-a-fix-or-is-it-a-feature series,
if I'm completely honest I wasn't sure what to say about it.
It seemed safe to merge either way - it only changes the TSN parts
of igc, so the stuff very embedded users would care about.
It's somewhat interesting how Intel uses similar parts for embedded 
and client platforms. There are features which are supported on laptops
(due to being embedded-adjacent) which I'd really like to see in servers
but they are not there :S

> Also, maybe more people should look at this one:
> 
>    https://lore.kernel.org/all/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/
> 
> which seems to be a regression in 6.1 (and still present, afaik).

Ah, yes, the bhash2 conversion, the gift that keeps giving...
Kuniyuki seems to be on top of it:

https://lore.kernel.org/all/20221221151258.25748-1-kuniyu@amazon.com/

we should have a fix for rc2, rc3 worst case.

FWIW this is completely different to the previous python test problem.
