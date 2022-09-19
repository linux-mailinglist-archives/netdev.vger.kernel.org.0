Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3B35BD65A
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 23:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiISV1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 17:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiISV1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 17:27:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99A04D26B;
        Mon, 19 Sep 2022 14:27:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oaOIp-0002VJ-8N; Mon, 19 Sep 2022 23:27:43 +0200
Date:   Mon, 19 Sep 2022 23:27:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Chris Clayton <chris2553@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        regressions@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: removing conntrack helper toggle to enable auto-assignment [was
 Re: b118509076b3 (probably) breaks my firewall]
Message-ID: <20220919212743.GC3498@breakpoint.cc>
References: <e5d757d7-69bc-a92a-9d19-0f7ed0a81743@googlemail.com>
 <20220908191925.GB16543@breakpoint.cc>
 <78611fbd-434e-c948-5677-a0bdb66f31a5@googlemail.com>
 <20220908214859.GD16543@breakpoint.cc>
 <YxsTMMFoaNSM9gLN@salvia>
 <a3c79b7d-526f-92ce-144a-453ec3c200a5@googlemail.com>
 <YxvwKlE+nyfUjHx8@salvia>
 <20220919124024.0c341af4@kernel.org>
 <20220919202310.GA3498@breakpoint.cc>
 <20220919135715.6057331d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919135715.6057331d@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> I think we should do _something_ because we broke so many things 
> in this release if we let this rot until its smell reaches Linus -
> someone is getting yelled at...

Well, we can restore the knob and some strongly worded printk.
(or even tain/warn_on_once/whatever).

So its not like we no options, but autoassign=1 is a
problematic configuration and so it would prefer to finally get rid
of it.

> Now, Linus is usually okay with breaking uAPI if there is no other 
> way of preventing a security issue. But (a) we break autoload of
> all helpers and we only have security issue in one,

This isn't 100% correct either, because its not necessarliy about
a security bug.  Helpers (by design) make things reachable that
otherwise would not be, e.g. ftp with 'loose=1' modparam adds a
'from anywhere to x:y' reverse forward, so if client is behind nat
(and the helper is active) this can be used to expose a service to
a 3rd party (granted, this is unlikely, given its off by default).

> and (b) not loading
> the module doesn't necessarily mean removing the file (at least IMHO).

We did not disable module load, but loading a connection tracking
module has no effect anymore without the needed iptables (or nftables)
rules to tell the conntrack engine which connections need to be
monitored by which helper.
