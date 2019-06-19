Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B60E4B4E4
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 11:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731440AbfFSJ13 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Jun 2019 05:27:29 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:49884 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfFSJ13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 05:27:29 -0400
Received: from [5.158.153.52] (helo=mitra)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hdWsH-0001vo-Lp; Wed, 19 Jun 2019 11:27:25 +0200
Date:   Wed, 19 Jun 2019 11:18:32 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 0/2] enable broadcom tagging for bcm531x5 switches
Message-ID: <20190619111832.16935a93@mitra>
In-Reply-To: <bc932af1-d957-bd40-fa65-ee05b9478ec7@gmail.com>
References: <20190618175712.71148-1-b.spranger@linutronix.de>
        <bc932af1-d957-bd40-fa65-ee05b9478ec7@gmail.com>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jun 2019 11:16:23 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

> How is that a problem for other machines? Does that lead to some kind
> of broadcast storm because there are machines that keep trying to
> respond to ARP solicitations?
Mirroring broadcast packages on the interface they are coming in, is
IMHO a poor idea. As a result any switch connected to wan update the
MAC table and send packages on a port where they do not belong to.
Just imagine to send a DHCP request. The BPi R1 acts as nearly perfect
black hole in such a situation.

> The few aspects that bother me, not in any particular order, are that:
> 
> - you might be able to not change anything and just get away with the
> one line patch below that sets skb->offload_fwd_mark to 1 to indicate
> to the bridge, not to bother with sending a copy of the packet, since
> the HW took care of that already

I can test it, but i like to note that the changed function is not
executed in case of bcm53125.

See commit 54e98b5d663f ("net: dsa: b53: Turn off Broadcom tags for
more switches")

From drivers/net/dsa/b53/b53_common.c:
---8<---
/* Older models (5325, 5365) support a different tag format that we do
 * not support in net/dsa/tag_brcm.c yet. 539x and 531x5 require managed
 * mode to be turned on which means we need to specifically manage ARL
 * misses on multicast addresses (TBD).
 */
if (is5325(dev) || is5365(dev) || is539x(dev) || is531x5(dev) ||
    !b53_can_enable_brcm_tags(ds, port))
	return DSA_TAG_PROTO_NONE;
---8<---

> - the patch from me that you included was part of a larger series that
> also addressed multicast while in management mode, such we would not
> have to chose like you did, have you tested it, did it somehow not
> work?
Since the patch series was not available any more, I had to gather the
snippets. Trying these patches was the last effort to get the switch
running without causing network problems.
(As far as I see are other parts of the original patch series in
mainline)

> - you have not copied the DSA maintainers on all of the patches, so
> you get a C grade for your patch submission
OK. As a RFC patch I am more interrested in the attention of the
original author of the patch, which I received :)

Regards
    Bene Spranger
