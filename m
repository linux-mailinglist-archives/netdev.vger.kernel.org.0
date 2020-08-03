Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFD023AFD6
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 23:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgHCVyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 17:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgHCVyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 17:54:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A58872076E;
        Mon,  3 Aug 2020 21:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596491677;
        bh=yd35aQLvzKJSlzDsOn7EMwgekmxECDUaArph5a7WwE4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LZcWNwXwc4/GPX1lHadBPrqYnsNFxscQNd6amIvwQTYjRweFb9rJTUd49WV9lMyOS
         fnFcu9oqp1Nl4x0Ghmxifj6ceJjnBXPe7d60r+r3zA9+kS+bOpO+NeOvEF2A0q5qWg
         e/W91g15JksbpdInVxd8yFy4eSMiDBFntc354SEI=
Date:   Mon, 3 Aug 2020 14:54:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 03/11] sfc_ef100: read Design Parameters at
 probe time
Message-ID: <20200803145435.1e364a1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9d248f15-2315-9598-9647-c9b25ab54b94@solarflare.com>
References: <31de2e73-bce7-6c9d-0c20-49b32e2043cc@solarflare.com>
        <48b1fedf-0863-8fab-7f7a-e2df6946b764@solarflare.com>
        <20200731131857.41b0f32a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9d248f15-2315-9598-9647-c9b25ab54b94@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Aug 2020 15:33:39 +0100 Edward Cree wrote:
> On 31/07/2020 21:18, Jakub Kicinski wrote:
> > On Fri, 31 Jul 2020 13:58:35 +0100 Edward Cree wrote: =20
> >> +	default:
> >> +		/* Host interface says "Drivers should ignore design parameters
> >> +		 * that they do not recognise."
> >> +		 */
> >> +		netif_info(efx, probe, efx->net_dev,
> >> +			   "Ignoring unrecognised design parameter %u\n",
> >> +			   reader->type); =20
> >=20
> > Is this really important enough to spam the logs with? =20
>
> Well, it implies your NIC (FPGA image) is newer than your driver,
> =C2=A0and saying things the driver doesn't understand; I feel like that
> =C2=A0should be recorded somewhere.

There are scenarios in which the driver may legitimately be older
 - bootloader kernel may not be updated as often as the production one
 - the driver doesn't actually need the feature, because it's for a
   different OS / workaround that doesn't apply. So all the kernel
   would be missing is a patch to ignore the TLV.

At scale FW and kernel are also maintained by different teams, not=20
to mention applications. The FW may very well be newer while the
application team validates and moves to the latest kernel release.

But since it's just at info level I guess its more of a noise situation
than an annoyance.

> Maybe this should be a netif_dbg() instead?=C2=A0 (Or is this a subtle
> =C2=A0way of telling me "you should implement devlink health"?)

Not devlink health.
