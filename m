Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F10686A77
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404690AbfHHTRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:17:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38896 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404590AbfHHTRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:17:32 -0400
Received: from [38.64.181.146] (helo=nyx.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1hvnuj-0001El-Rv; Thu, 08 Aug 2019 19:17:30 +0000
Received: by nyx.localdomain (Postfix, from userid 1000)
        id CE64824091C; Thu,  8 Aug 2019 15:17:28 -0400 (EDT)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id C943F280657;
        Thu,  8 Aug 2019 15:17:28 -0400 (EDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     "Felix" <fei.feng@linux.alibaba.com>
cc:     "vfalico" <vfalico@gmail.com>, "andy" <andy@greyhouse.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [bonding][patch] Regarding a bonding lacp issue
In-reply-to: <8799b243-36da-4baf-8c67-aeb5f978c34f.fei.feng@linux.alibaba.com>
References: <8799b243-36da-4baf-8c67-aeb5f978c34f.fei.feng@linux.alibaba.com>
Comments: In-reply-to "Felix" <fei.feng@linux.alibaba.com>
   message dated "Thu, 08 Aug 2019 23:33:25 +0800."
X-Mailer: MH-E 8.5+bzr; nmh 1.7.1-RC3; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24903.1565291848.1@nyx>
Date:   Thu, 08 Aug 2019 15:17:28 -0400
Message-ID: <24904.1565291848@nyx>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Felix <fei.feng@linux.alibaba.com> wrote:

>Dear Mainteners,
>
>Recently I hit a packet drop issue in bonding driver on Linux 4.9. Please
>see details below. Please take a look to see if my understanding is
>correct. Many thanks.
>
>What is the problem?
>The bonding driver starts to send packets even if the Partner(Switch)'s
>Collecting bit is not enabled yet. Partner would drop all packets until
>its Collecting bit is enabled.
>
>What is the root cuase?
>According to LACP spec, the Actor need to check Partner's Sync and
>Collecting bits before enable its Distributing bit and Distributing
>function. Please see the PIC below.

	The diagram you reference is found in 802.1AX-2014 figure 6-21,
which shows the state diagram for an independent control implementation,
i.e., collecting and distributing are managed independently.

	However, Linux bonding implements coupled control, which is
shown in figure 6-22.  Here, there is no Partner.Collecting requirement
on the state transition from ATTACHED to COLLECTING_DISTRIBUTING.

	To quote 802.1AX-2014 6.4.15:

	As independent control is not possible, the coupled control
	state machine does not wait for the Partner to signal that
	collection has started before enabling both collection and
	distribution.

	Now, that said, I agree that what you're seeing is likely
explained by this behavior, and your fix should resolve the immediate
problem (that bonding sends packets before the peer has enabled
COLLECTING).

	However, your fix does put bonding out of compliance with the
standard, as it does not really implement COLLECTING and DISTRIBUTING as
discrete states.  In particular, if the peer in your case were to later
clear Partner.Collecting, bonding will not react to this as a figure
6-21 independent control implementation would (which isn't a change from
current behavior, but currently this isn't expected).

	So, in my opinion a patch like this should have a comment
attached noting that we are deliberately not in compliance with the
standard in this specific situation.  The proper fix is to implement
figure 6-21 separate state.

	Lastly, are you able to test and generate a patch against
current upstream, instead of 4.9?

	-J

>How to fix?
>Please see the diff as following. And the patch is attached.
>
>--- ../origin/linux-4.9.188/drivers/net/bonding/bond_3ad.c 2019-08-07
>00:29:42.000000000 +0800
>+++ drivers/net/bonding/bond_3ad.c 2019-08-08 23:13:29.015640197 +0800
>@@ -937,6 +937,7 @@
>     */
>    if ((port->sm_vars & AD_PORT_SELECTED) &&
>        (port->partner_oper.port_state & AD_STATE_SYNCHRONIZATION) &&
>+       (port->partner_oper.port_state & AD_STATE_COLLECTING) &&
>        !__check_agg_selection_timer(port)) {
>     if (port->aggregator->is_active)
>      port->sm_mux_state =
>
>------
>Thanks,
>Felix

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
