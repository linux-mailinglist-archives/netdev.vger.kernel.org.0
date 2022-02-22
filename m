Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8590A4C0359
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 21:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiBVUuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 15:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiBVUui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 15:50:38 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82380A9A5D
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 12:50:12 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1nMc6m-00FSXz-BE; Tue, 22 Feb 2022 21:50:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1nMbxD-0024TY-TA;
        Tue, 22 Feb 2022 21:40:11 +0100
Date:   Tue, 22 Feb 2022 21:40:11 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "osmocom-net-gprs@lists.osmocom.org" 
        <osmocom-net-gprs@lists.osmocom.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next v7 3/7] gtp: Implement GTP echo request
Message-ID: <YhVKK16JRo3THp7h@nataraja>
References: <20220221101425.19776-1-marcin.szycik@linux.intel.com>
 <20220221101425.19776-4-marcin.szycik@linux.intel.com>
 <YhSDfvQoNDyoAaV9@nataraja>
 <MW4PR11MB5776AA2256C00293FAC07C16FD3B9@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB5776AA2256C00293FAC07C16FD3B9@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wojciech,

On Tue, Feb 22, 2022 at 09:38:08AM +0000, Drewek, Wojciech wrote:

> > I think either the Tx and the Rx ard triggered by / notified to userspace,
> > or you would also do periodic triggering of Tx in the kernel autonomously,
> > and process the responses.  But at that point then you also need to think
> > about further consequences, such as counting the number of missed ECHO RESP,
> > and then notify userspace if that condition "N out of M last responses missed".
> > 
> 
> I thought that with the GTP device created from ip link, userspace
> would be unable to receive Echo Response (similar to Echo Request).
> If it's not the case than I will get rid of handling Echo Response in the
> next version.

Well, userspace cannot 'receive' the ECHO response through the UDP socket as
the UDP socket is hidden in the kernel.  I was thinking of the same mechanism
you introduce for transmit:  You can trigger the Tx of GTP ECHO REQ via netlink,
so why shouldn't you receive a notifiation about its completion also via netlink?

Just don't think of it as sending an ECHO REQ via netlink, but triggering the tx
and acknowledging the completion/reception of a related response.

One of the advantages of the existing mechanism via 'socket is held in userspace'
is that we don't have to jump through any such hoops or invent strange interfaces:
The process can just send and receive the messages as usual via UDP socket related
syscalls.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
