Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9C54B218F
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348458AbiBKJUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:20:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348575AbiBKJUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:20:13 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFD6333
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 01:20:12 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@osmocom.org>)
        id 1nIS60-00Gkod-Px; Fri, 11 Feb 2022 10:20:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@osmocom.org>)
        id 1nIS2R-004xhQ-IJ;
        Fri, 11 Feb 2022 10:16:23 +0100
Date:   Fri, 11 Feb 2022 10:16:23 +0100
From:   Harald Welte <laforge@osmocom.org>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "osmocom-net-gprs@lists.osmocom.org" 
        <osmocom-net-gprs@lists.osmocom.org>
Subject: Re: [RFC PATCH net-next v4 4/6] gtp: Implement GTP echo response
Message-ID: <YgYpZzOo3FQG+SY2@nataraja>
References: <20220204164929.10356-1-marcin.szycik@linux.intel.com>
 <20220204165101.10673-1-marcin.szycik@linux.intel.com>
 <Yf6rKbkyzCnZE/10@nataraja>
 <MW4PR11MB5776D18B1DA527575987CB1DFD2D9@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB5776D18B1DA527575987CB1DFD2D9@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wojciech,

On Tue, Feb 08, 2022 at 02:12:33PM +0000, Drewek, Wojciech wrote:
> > Remember, GTP-U uses different IP addresses and also typically completely
> > different hosts/systems, so having GTP-C connectivity between two GSN
> > doesn't say anything about the GTP-U path.
>
> Two  approaches come to mind.
> The first one assumes that peers are stored in kernel as PDP contexts in
> gtp_dev (tid_hash and addr_hash). Then we could enable a watchdog
> that could in regular intervals (defined by the user) send echo requests
> to all peers.

Interesting proposal.  However, it raises the next question of what to do if
the path is deemed to be lost (N out of M recent echo requests unanswered)? It
would have to notify the userspace daemon (control plane) via a netlink event
or the like.  So at that point you need to implement some special processing in
that userspace daemon...

> In the second one user could trigger echo request from userspace
> (using new genl cmd) at any time. However this approach would require that
> some userspace daemon would implement triggering this command.

I think this is the better approach.  It keeps a lot of logic like timeouts,
frequency of transmission, determining when a path is considered dead, ... out
of the kernel, where it doesn't need to be.

> What do you think?

As both approaches require some support from the userspace control plane instance,
I would argue that the second proposal is superior.

Regards,
	Harald

-- 
- Harald Welte <laforge@osmocom.org>            http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
