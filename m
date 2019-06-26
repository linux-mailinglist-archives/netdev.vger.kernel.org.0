Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC5556A28
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfFZNQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:16:34 -0400
Received: from mail.us.es ([193.147.175.20]:40958 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbfFZNQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 09:16:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 15EC8B571C
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 15:16:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 014FE1021B2
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 15:16:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E49B64EDAF; Wed, 26 Jun 2019 15:16:30 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8FB7EDA732;
        Wed, 26 Jun 2019 15:16:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Jun 2019 15:16:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.197.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3601D4265A31;
        Wed, 26 Jun 2019 15:16:28 +0200 (CEST)
Date:   Wed, 26 Jun 2019 15:16:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: Re: [PATCH net-next 04/12] net: sched: add tcf_block_setup()
Message-ID: <20190626131626.ihkjqvs2iciski2o@salvia>
References: <20190620194917.2298-1-pablo@netfilter.org>
 <20190620194917.2298-5-pablo@netfilter.org>
 <20190621171603.GF2414@nanopsycho.orion>
 <20190625083154.jfzhh22zsl3fu2ik@salvia>
 <20190626121256.GA2424@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626121256.GA2424@nanopsycho>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 02:12:56PM +0200, Jiri Pirko wrote:
> Tue, Jun 25, 2019 at 10:31:54AM CEST, pablo@netfilter.org wrote:
> >On Fri, Jun 21, 2019 at 07:16:03PM +0200, Jiri Pirko wrote:
> >> Thu, Jun 20, 2019 at 09:49:09PM CEST, pablo@netfilter.org wrote:
> >> 
> >> [...]
> >> 
> >> > 
> >> >+static LIST_HEAD(tcf_block_cb_list);
> >> 
> >> I still don't like the global list. Have to go throught the code more
> >> carefully, but why you can't pass the priv/ctx from tc/netfilter. From
> >> tc it would be tcf_block as it is now, from netfilter something else.
> >
> >This tcf_block_cb_list should go away at some point, once drivers know
> >how to deal with multiple subsystems using the setup block
> >infrastructure. As I said in my previous email, only one can set up
> >the block at this stage, the ones coming later will hit busy.
> 
> The driver should know if it can bind or is busy. Also, the bind cmd
> should contain type of binder (tc/nft/whatever) or perhaps rather binder
> priority (according to the hook order in rx/tx).

OK, so I see two possible paths then:

#1 Add global list and allow one single subsystem to bind by now. Then
   later, in a follow up patchset. Add binder type and priority once
   there is a driver that can handle the three subsystems, remove
   this global list and each driver deals/knows what to do from the
   binder path.

#2 Remove the global list now, each driver maintains a list of flow blocks
   internally, allow one single flow block by now. This will need a bit more
   code, since there will be code in the driver to maintain the list of
   existing flow blocks, per driver, instead of global. So it will be
   a per-driver global local to check if there is a flow block with
   this [ cb, cb_ident ] already in place.

#1 is almost ready - it's this batch :-) -  then #2 may need more code -
this batch is slightly large.

I understand though that path #2 may make it easier for the first
driver client allowing for the three subsystems to bind.

Let me know what path your prefer.

Thanks for reviewing.
