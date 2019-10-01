Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A867DC2E33
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 09:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732998AbfJAHZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 03:25:19 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55848 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732725AbfJAHZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 03:25:18 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iFCWv-0000k4-KX; Tue, 01 Oct 2019 09:25:05 +0200
Message-ID: <72bc9727d0943c56403eac03b6de69c00b0f53f6.camel@sipsolutions.net>
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
Date:   Tue, 01 Oct 2019 09:25:03 +0200
In-Reply-To: <CAMArcTWrMq0qK72VJv=6ATugMSt_b=FiE4d+xOmi2K3FE8aEyA@mail.gmail.com> (sfid-20190929_100319_579807_F8AE265E)
References: <20190928164843.31800-1-ap420073@gmail.com>
         <20190928164843.31800-8-ap420073@gmail.com>
         <33adc57c243dccc1dcb478113166fa01add3d49a.camel@sipsolutions.net>
         <CAMArcTWrMq0qK72VJv=6ATugMSt_b=FiE4d+xOmi2K3FE8aEyA@mail.gmail.com>
         (sfid-20190929_100319_579807_F8AE265E)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> > I didn't see any discussion on this, but perhaps I missed it? The cost
> > would be a bigger netdev struct (when lockdep is enabled), but we
> > already have that for all the VLANs etc. it's just in the private data,
> > so it's not a _huge_ difference really I'd think, and this is quite a
> > bit of code for each device type now.
> 
> Actually I agree with your opinion.
> The benefits of this way are to be able to make common helper functions.
> That would reduce duplicate codes and we can maintain this more easily.
> But I'm not sure about the overhead of this way. So I would like to ask
> maintainers and more reviewers about this.

:-)

> Using "struct nested_netdev_lockdep" looks really good.
> I will make common codes such as "struct nested_netdev_lockdep"
> and "netdev_devinit_nested_lockdep" and others in a v5 patch.

That makes *sense*, but it seems to me that for example in virt_wifi we
just missed this part completely, so addressing it in the generic code
would still reduce overall code and complexity?

Actually, looking at net-next, we already have
netdev_lockdep_set_classes() as a macro there that handles all this. I
guess having it as a macro makes some sense so it "evaporates" when
lockdep isn't enabled.


I'd probably try that but maybe somebody else can chime in and say what
they think about applying that to *every* netdev instead though.


> > What's not really clear to me is why the qdisc locks can actually stay
> > the same at all levels? Can they just never nest? But then why are they
> > different per device type?
> 
> I didn't test about qdisc so I didn't modify code related to qdisc code.
> If someone reviews this, I would really appreciate.

I didn't really think hard about it when I wrote this ...

But it seems to me the whole nesting also has to be applied here?

__dev_xmit_skb:
 * qdisc_run_begin()
 * sch_direct_xmit()
   * HARD_TX_LOCK(dev, txq, smp_processor_id());
   * dev_hard_start_xmit() // say this is VLAN
     * dev_queue_xmit() // on real_dev
       * __dev_xmit_skb // recursion on another netdev

Now if you have VLAN-in-VLAN the whole thing will recurse right?

johannes

