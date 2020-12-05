Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C352CFE8A
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgLETp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:45:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:60646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLETpz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:45:55 -0500
Date:   Sat, 5 Dec 2020 11:45:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607197515;
        bh=waY9/Lv9f7z230WTpMxBq86+oBITP8tsVVKJVz/83Ig=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=GYT7M0x2SJfwFvRNCB97xzPZmcO5TWdUUAwrcaKRNh5cfsc8JbXY0l98Ws2NviVta
         htXJbEGwJt8vCE/0qsn5KFCwRFrXdQeAjrddOH51gofAyrKLn3aUzezWcJ4BUtle3p
         hunomva0QZAvfrAZgsLWiCnK95Ql2YSNlkpmY/gCnYLPzdi/3DcWF4+Tj8o4VMDRc/
         kbDYjHRdRZcRMl5SxzVmZ4VJr0gKs2wGTqIIOJNM1t/3gu5Kc0N/WREGtBplJ946X+
         KTGORioc3K0XggAGtUHUkTYAK1Ecc/YrNeNaZYMga1GG0lkRujVCAu8LZHOoqZBAqt
         ASu5F+gKrqZqQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lars Everbrand <lars.everbrand@protonmail.com>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] bonding: correct rr balancing during link
 failure
Message-ID: <20201205114513.4886d15e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <X8f/WKR6/j9k+vMz@black-debian>
References: <X8f/WKR6/j9k+vMz@black-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 02 Dec 2020 20:55:57 +0000 Lars Everbrand wrote:
> This patch updates the sending algorithm for roundrobin to avoid
> over-subscribing interface(s) when one or more interfaces in the bond is
> not able to send packets. This happened when order was not random and
> more than 2 interfaces were used.
> 
> Previously the algorithm would find the next available interface
> when an interface failed to send by, this means that most often it is
> current_interface + 1. The problem is that when the next packet is to be
> sent and the "normal" algorithm then continues with interface++ which
> then hits that same interface again.
> 
> This patch updates the resending algorithm to update the global counter
> of the next interface to use.
> 
> Example (prior to patch):
> 
> Consider 6 x 100 Mbit/s interfaces in a rr bond. The normal order of links
> being used to send would look like:
> 1 2 3 4 5 6  1 2 3 4 5 6  1 2 3 4 5 6 ...
> 
> If, for instance, interface 2 where unable to send the order would have been:
> 1 3 3 4 5 6  1 3 3 4 5 6  1 3 3 4 5 6 ...
> 
> The resulting speed (for TCP) would then become:
> 50 + 0 + 100 + 50 + 50 + 50 = 300 Mbit/s
> instead of the expected 500 Mbit/s.
> 
> If interface 3 also would fail the resulting speed would be half of the
> expected 400 Mbit/s (33 + 0 + 0 + 100 + 33 + 33).
> 
> Signed-off-by: Lars Everbrand <lars.everbrand@protonmail.com>

Thanks for the patch!

Looking at the code in question it feels a little like we're breaking
abstractions if we bump the counter directly in get_slave_by_id.

For one thing when the function is called for IGMP packets the counter
should not be incremented at all. But also if packets_per_slave is not
1 we'd still be hitting the same leg multiple times (packets_per_slave
/ 2). So it seems like we should round the counter up somehow?

For IGMP maybe we don't have to call bond_get_slave_by_id() at all,
IMHO, just find first leg that can TX. Then we can restructure
bond_get_slave_by_id() appropriately for the non-IGMP case.

> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index e0880a3840d7..e02d9c6d40ee 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -4107,6 +4107,7 @@ static struct slave *bond_get_slave_by_id(struct bonding *bond,
>  		if (--i < 0) {
>  			if (bond_slave_can_tx(slave))
>  				return slave;
> +			bond->rr_tx_counter++;
>  		}
>  	}
>  
> @@ -4117,6 +4118,7 @@ static struct slave *bond_get_slave_by_id(struct bonding *bond,
>  			break;
>  		if (bond_slave_can_tx(slave))
>  			return slave;
> +		bond->rr_tx_counter++;
>  	}
>  	/* no slave that can tx has been found */
>  	return NULL;

