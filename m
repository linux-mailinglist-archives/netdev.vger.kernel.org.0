Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F3CCE0B3
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfJGLlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:41:37 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33862 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbfJGLlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 07:41:37 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iHRO8-0004uH-9s; Mon, 07 Oct 2019 13:41:16 +0200
Message-ID: <bb48fca5a5ffb0a877b2bff8de07ec8090b63427.camel@sipsolutions.net>
Subject: Re: [PATCH net v4 07/12] macvlan: use dynamic lockdep key instead
 of subclass
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?Q?Ji=C5=99=C3=AD_P=C3=ADrko?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Cody Schuffelen <schuffelen@google.com>, bjorn@mork.no
Date:   Mon, 07 Oct 2019 13:41:14 +0200
In-Reply-To: <CAMArcTVeFGqA2W26=rBD5KkjRpFB6gjSgXj8dp+WWrrwJ7pr-A@mail.gmail.com> (sfid-20191005_111343_179256_72415A7E)
References: <20190928164843.31800-1-ap420073@gmail.com>
         <20190928164843.31800-8-ap420073@gmail.com>
         <33adc57c243dccc1dcb478113166fa01add3d49a.camel@sipsolutions.net>
         <CAMArcTWrMq0qK72VJv=6ATugMSt_b=FiE4d+xOmi2K3FE8aEyA@mail.gmail.com>
         <72bc9727d0943c56403eac03b6de69c00b0f53f6.camel@sipsolutions.net>
         <CAMArcTVeFGqA2W26=rBD5KkjRpFB6gjSgXj8dp+WWrrwJ7pr-A@mail.gmail.com>
         (sfid-20191005_111343_179256_72415A7E)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-10-05 at 18:13 +0900, Taehee Yoo wrote:
> 
> If we place lockdep keys into "struct net_device", this macro would be a
> little bit modified and reused. And driver code shape will not be huge
> changed. I think this way is better than this v4 way.
> So I will try it.

What I was thinking was that if we can do this for every VLAN netdev,
why shouldn't we do it for *every* netdev unconditionally? Some code
could perhaps even be simplified if this was just a general part of
netdev allocation.

> > But it seems to me the whole nesting also has to be applied here?
> > 
> > __dev_xmit_skb:
> >  * qdisc_run_begin()
> >  * sch_direct_xmit()
> >    * HARD_TX_LOCK(dev, txq, smp_processor_id());
> >    * dev_hard_start_xmit() // say this is VLAN
> >      * dev_queue_xmit() // on real_dev
> >        * __dev_xmit_skb // recursion on another netdev
> > 
> > Now if you have VLAN-in-VLAN the whole thing will recurse right?
> > 
> 
> I have checked on this routine.
> Only xmit_lock(HARD_TX_LOCK) could be nested. other
> qdisc locks(runinng, busylock) will not be nested. 

OK, I still didn't check it too closely I guess, or got confused which
lock I should look at.

> This patch already
> handles the _xmit_lock key. so I think there is no problem.

Right

> But I would like to place four lockdep keys(busylock, address,
> running, _xmit_lock) into "struct net_device" because of code complexity.
> 
> Let me know if I misunderstood anything.

Nothing to misunderstand - I was just asking/wondering why the qdisc
locks were not treated the same way.

johannes

