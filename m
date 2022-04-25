Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EED650DE44
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241593AbiDYK5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236959AbiDYK5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:57:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BE582D30;
        Mon, 25 Apr 2022 03:54:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1niwLq-0003NM-Px; Mon, 25 Apr 2022 12:53:54 +0200
Date:   Mon, 25 Apr 2022 12:53:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Mark Mielke <mark.mielke@gmail.com>, dev@openvswitch.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Antti Antinoja <antti@fennosys.fi>
Subject: Re: [ovs-dev] [PATCH] openvswitch: Ensure nf_ct_put is not called
 with null pointer
Message-ID: <20220425105354.GC26757@breakpoint.cc>
References: <20220409094036.20051-1-mark.mielke@gmail.com>
 <YlL6uN9WDPtFri0p@strlen.de>
 <590d44a1-ca27-c171-de87-fe57fc07dff5@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <590d44a1-ca27-c171-de87-fe57fc07dff5@ovn.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ilya Maximets <i.maximets@ovn.org> wrote:
> Hi, Florian.
> 
> There is a problem on 5.15 longterm tree where the offending commit
> got backported, but the previous one was not, so it triggers an issue
> while loading the openvswitch module.
> 
> To be more clear, v5.15.35 contains the following commit:
>   408bdcfce8df ("net: prefer nf_ct_put instead of nf_conntrack_put")
> backported as commit 72dd9e61fa319bc44020c2d365275fc8f6799bff, but
> it doesn't have the previous one:
>   6ae7989c9af0 ("netfilter: conntrack: avoid useless indirection during conntrack destruction")
> that adds the NULL pointer check to the nf_ct_put().
> 
> Either 6ae7989c9af0 should be backported to 5.15 or 72dd9e61fa31
> reverted on that tree.

The commit was never meant to be backported to stable, it doesn't fix any bug.

I suspect it was done to take 'net/sched: act_ct: fix ref leak when
switching zones' without munging it.

I suggest to add stable-only patch that makes nf_ct_put(NULL)
legal, like in linux.git, but I don't know stable team preferences.
