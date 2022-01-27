Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCA149E4DC
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242552AbiA0Omi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiA0Omh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:42:37 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4787BC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 06:42:37 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1nD5yp-00DoD1-O2; Thu, 27 Jan 2022 15:42:31 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1nD5xE-001mzf-Ui;
        Thu, 27 Jan 2022 15:40:52 +0100
Date:   Thu, 27 Jan 2022 15:40:52 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, michal.swiatkowski@linux.intel.com,
        wojciech.drewek@intel.com, davem@davemloft.net, kuba@kernel.org,
        pablo@netfilter.org, osmocom-net-gprs@lists.osmocom.org
Subject: Re: [RFC PATCH net-next v2 1/5] gtp: Allow to create GTP device
 without FDs
Message-ID: <YfKu9NwF7/RKsMbb@nataraja>
References: <20220127125725.125915-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127125725.125915-1-marcin.szycik@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wojciech,

thanks for your contribution, I think in general it is a good idea.

However, I do not think this can be merged, as the resulting system would
not be possible to use in a spec-compliant way.

> Currently, when the user wants to create GTP device, he has to
> provide file handles to the sockets created in userspace (IFLA_GTP_FD0,
> IFLA_GTP_FD1). This behaviour is not ideal, considering the option of
> adding support for GTP device creation through ip link. Ip link
> application is not a good place to create such sockets.

The GTP kernel module in its past and current form only handles G-PDU packets
and not any other packets.  So it relies on always having a user space process
[the one with the socket you want to make optional to handle other frames,
such as GTP ECHO.

So if you apply your patch, you will end up creating a GTP-U instance which
does not respond to echo requests, which is in violation of 3GPP specs and
which will create problems in production.

So if you want to make this optional, you'd also have to implement GTP-U ECHO handling
in the kernel, and require that in-kernel handling to be enabled when creating a GTP
device without the socket file descriptors.

Regards,
	Harald

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
