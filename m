Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7484AAA50
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 18:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380512AbiBERAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 12:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239376AbiBERAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 12:00:10 -0500
X-Greylist: delayed 1189 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 05 Feb 2022 09:00:08 PST
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84544C061348
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 09:00:08 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@osmocom.org>)
        id 1nGOPs-008Zk9-8F; Sat, 05 Feb 2022 18:00:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@osmocom.org>)
        id 1nGOHy-003EWm-0B;
        Sat, 05 Feb 2022 17:51:54 +0100
Date:   Sat, 5 Feb 2022 17:51:53 +0100
From:   Harald Welte <laforge@osmocom.org>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, michal.swiatkowski@linux.intel.com,
        wojciech.drewek@intel.com, davem@davemloft.net, kuba@kernel.org,
        pablo@netfilter.org, osmocom-net-gprs@lists.osmocom.org
Subject: Re: [RFC PATCH net-next v4 4/6] gtp: Implement GTP echo response
Message-ID: <Yf6rKbkyzCnZE/10@nataraja>
References: <20220204164929.10356-1-marcin.szycik@linux.intel.com>
 <20220204165101.10673-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204165101.10673-1-marcin.szycik@linux.intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin, Wojciech,

I would prefer to move this patch to right after introducing the
kernel-socket mode, as the former makes no sense without this patch.

Now that this patch implements responding to the GTP ECHO procedure,
one interesting question that comes to mind is how you would foresee
outbound GTP echo procedures to be used in this new use pattern.

With the existing (userspace creates the socket) pattern, the userspace
instance can at any point send GTP ECHO request packets to any of the
peers, while I don't really see how this would work if the socket is in
the kernel.

The use of the outbound ECHO procedure is not required for GTP-U by TS
29.060, so spec-wise it is fine to not support it.  It just means
that any higher-layer applications using this 'socketless' use pattern
will be deprived of being able to check for GTP-U path failure.

IMHO, this is non-negligable, as there are no other rqeust-response
message pairs on the GTP-U plane,  so transmitting and receiving ECHO
is the only way a control plane / management instance has to detect
GTP-U path failure.

So without being able to trigger GTP-ECHO, things could look prefectly
fine on the GPT-C side of things, but GTP-U may not be working at all.

Remember, GTP-U uses different IP addresses and also typically completely
different hosts/systems, so having GTP-C connectivity between two GSN
doesn't say anything about the GTP-U path.

Regards,
	Harald

-- 
- Harald Welte <laforge@osmocom.org>            http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
