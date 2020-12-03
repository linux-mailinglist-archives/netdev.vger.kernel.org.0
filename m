Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523352CDB92
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgLCQup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:50:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbgLCQuo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 11:50:44 -0500
Date:   Thu, 3 Dec 2020 08:50:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607014203;
        bh=YHfuCjdtDnHU2kz0MrlrIr2AWgOYTlJneLrx1j97NQc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=JwB/MUidaGtf2zBZaB4b5wK3fFxbydy1DlLoXypQliapRImVuMFO7e4naf72ARwGo
         9kIU9RvdpbkeKXd6pokZD5grCOJU9rvdMwKj7Xf0j2hpBasSxHG3p2/a/OhOH6fDa2
         OJ5B/u8ewOAso41Kxals4f7jjlH0giGmW61TQ3YdQSlTJg+GDyWADz1ZrZEeJA9ztX
         RM5Cz/V9nNy6bUb5qW6eUUgWFbQuZ210AJs/K4usniPVQwujEc1IQMxfdkG2yi9qMq
         MJyWs8rRvhtNXQMIZeIQbsHZ1Gs7CkkO/nGMyLsBeti1X3DnQJnbYRV4iv9FKpAIh/
         cbKKiHESqR0Rw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net v3] bonding: fix feature flag setting at init time
Message-ID: <20201203085001.4901c97f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203004357.3125-1-jarod@redhat.com>
References: <20201202173053.13800-1-jarod@redhat.com>
        <20201203004357.3125-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 19:43:57 -0500 Jarod Wilson wrote:
>  	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
> -#ifdef CONFIG_XFRM_OFFLOAD
> -	bond_dev->hw_features |= BOND_XFRM_FEATURES;
> -#endif /* CONFIG_XFRM_OFFLOAD */
>  	bond_dev->features |= bond_dev->hw_features;
>  	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
>  #ifdef CONFIG_XFRM_OFFLOAD
> -	/* Disable XFRM features if this isn't an active-backup config */
> -	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
> -		bond_dev->features &= ~BOND_XFRM_FEATURES;
> +	bond_dev->hw_features |= BOND_XFRM_FEATURES;
> +	/* Only enable XFRM features if this is an active-backup config */
> +	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
> +		bond_dev->features |= BOND_XFRM_FEATURES;
>  #endif /* CONFIG_XFRM_OFFLOAD */

This makes no functional change, or am I reading it wrong?
