Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7EA5AA74E
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 07:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbiIBFjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 01:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIBFjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 01:39:53 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C09D6B;
        Thu,  1 Sep 2022 22:39:51 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oTzOq-0007c5-Vx; Fri, 02 Sep 2022 07:39:29 +0200
Date:   Fri, 2 Sep 2022 07:39:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH net 1/4] netfilter: remove nf_conntrack_helper sysctl and
 modparam toggles
Message-ID: <20220902053928.GA5881@breakpoint.cc>
References: <20220901071238.3044-1-fw@strlen.de>
 <20220901071238.3044-2-fw@strlen.de>
 <20220901210715.00c7b4e1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901210715.00c7b4e1@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu,  1 Sep 2022 09:12:35 +0200 Florian Westphal wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > __nf_ct_try_assign_helper() remains in place but it now requires a
> > template to configure the helper.
> > 
> > A toggle to disable automatic helper assignment was added by:
> > 
> >   a9006892643a ("netfilter: nf_ct_helper: allow to disable automatic helper assignment")
> > 
> > in 2012 to address the issues described in "Secure use of iptables and
> > connection tracking helpers". Automatic conntrack helper assignment was
> > disabled by:
> > 
> >   3bb398d925ec ("netfilter: nf_ct_helper: disable automatic helper assignment")
> > 
> > back in 2016.
> > 
> > This patch removes the sysctl and modparam toggles, users now have to
> > rely on explicit conntrack helper configuration via ruleset.
> > 
> > Update tools/testing/selftests/netfilter/nft_conntrack_helper.sh to
> > check that auto-assignment does not happen anymore.
> 
> From the description itself it's unclear why this is a part of a net PR.
> Could you elucidate?

Yes, there is improper checking in the irc dcc helper, its possible to
trigger the 'please do dynamic port forward' from outside by embedding
a 'DCC' in a PING request; if the client echos that back a expectation/
port forward gets added.

A fix for this will come in the next net PR, however, one part of the
issue is that point-blank-autassign is problematic and that helpers
should only be enabled for addresses that need it.

If you like I can resend the PR with an updated cover letter, or resend
with the dcc helper fix included as well.
