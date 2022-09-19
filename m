Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3166D5BD5AE
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 22:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiISUXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 16:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiISUXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 16:23:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932723ECC9;
        Mon, 19 Sep 2022 13:23:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oaNIM-0002Cv-PR; Mon, 19 Sep 2022 22:23:10 +0200
Date:   Mon, 19 Sep 2022 22:23:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Chris Clayton <chris2553@googlemail.com>,
        Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        regressions@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: removing conntrack helper toggle to enable auto-assignment [was
 Re: b118509076b3 (probably) breaks my firewall]
Message-ID: <20220919202310.GA3498@breakpoint.cc>
References: <e5d757d7-69bc-a92a-9d19-0f7ed0a81743@googlemail.com>
 <20220908191925.GB16543@breakpoint.cc>
 <78611fbd-434e-c948-5677-a0bdb66f31a5@googlemail.com>
 <20220908214859.GD16543@breakpoint.cc>
 <YxsTMMFoaNSM9gLN@salvia>
 <a3c79b7d-526f-92ce-144a-453ec3c200a5@googlemail.com>
 <YxvwKlE+nyfUjHx8@salvia>
 <20220919124024.0c341af4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919124024.0c341af4@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Sat, 10 Sep 2022 04:02:18 +0200 Pablo Neira Ayuso wrote:
> > > > I'll update netfilter.org to host a copy of the github sources.
> > > > 
> > > > We have been announcing this going deprecated for 10 years...  
> > > 
> > > That may be the case, it should be broken before -rc1 is released. Breaking it at -rc4+ is, I think, a regression!
> > > Adding Thorsten Leemuis to cc list  
> > 
> > Disagreed, reverting and waiting for one more release cycle will just
> > postpone the fact that users must adapt their policies, and that they
> > rely on a configuration which is not secure.
> 
> What are the chances the firewall actually needs the functionality?

Unknown, there is no way to tell.

In old times, it was enough (not tested, just for illustration):

iptables -A FORWARD -p tcp -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

and load nf_conntrack_ftp (or whatever).  Module will auto-snoop traffic
on tcp port 21 for ftp commands, if it finds some, it auto-installs dynamic
'expectation entries', so when data connection comes it will hit RELATED rule
above.

This stopped working years ago, unless you did set the (now removed)
knob back to 1.

Assuming iptables, users would need to do something like
iptables -t raw -A PREROUTING -p tcp --dport 21 -d $ftpaddr -j CT --helper "ftp"

to tell that packets/connections on tcp:21 need to be examined for ftp commands.

> Perhaps we can add the file back but have it do nothing?

I think its even worse, users would think that auto-assign is enabled.
