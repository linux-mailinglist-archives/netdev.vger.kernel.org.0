Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C48599C2F
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 14:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348925AbiHSMgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 08:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348737AbiHSMf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 08:35:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87607D83E5;
        Fri, 19 Aug 2022 05:35:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oP1Dy-0000rG-J3; Fri, 19 Aug 2022 14:35:42 +0200
Date:   Fri, 19 Aug 2022 14:35:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Abhishek Shah <abhishek.shah@columbia.edu>
Cc:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pabeni@redhat.com, pablo@netfilter.org,
        Gabriel Ryan <gabe@cs.columbia.edu>,
        linux-kernel@vger.kernel.org
Subject: Re: data-race in nf_tables_newtable / nf_tables_newtable
Message-ID: <20220819123542.GA2461@breakpoint.cc>
References: <CAEHB2488dNqBKcgWLSeq500JLC1+q6RV=ENcUPm=rN9bWf0QkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEHB2488dNqBKcgWLSeq500JLC1+q6RV=ENcUPm=rN9bWf0QkQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abhishek Shah <abhishek.shah@columbia.edu> wrote:
> Hi all,
> 
> We found a race involving the table->handle variable here
> <https://elixir.bootlin.com/linux/v5.18-rc5/source/net/netfilter/nf_tables_api.c#L1221>.
> This race advances the pointer, which can cause out-of-bounds memory
> accesses in the future. Please let us know what you think.
> 
> Thanks!
> 
> 
> *---------------------Report-----------------*
> *read-write* to 0xffffffff883a01e8 of 8 bytes by task 6542 on cpu 0:
>  nf_tables_newtable+0x6dc/0xc00 net/netfilter/nf_tables_api.c:1221
>  nfnetlink_rcv_batch net/netfilter/nfnetlink.c:513 [inline]

[..]

> *read-write* to 0xffffffff883a01e8 of 8 bytes by task 6541 on cpu 1:
>  nf_tables_newtable+0x6dc/0xc00 net/netfilter/nf_tables_api.c:1221
>  nfnetlink_rcv_batch net/netfilter/nfnetlink.c:513 [inline]

[..]

I don't understand.  Like all batch operations, nf_tables_newtable is
supposed to run with the transaction mutex held, i.e. parallel execution
is not expected.

There is a lockdep assertion at start of nf_tables_newtable(); I
don't see how its possible that two threads can run this concurrently.
