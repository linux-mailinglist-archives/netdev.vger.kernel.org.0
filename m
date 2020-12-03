Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBD42CDB80
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501878AbgLCQqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:46:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387522AbgLCQqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 11:46:09 -0500
Date:   Thu, 3 Dec 2020 08:45:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607013927;
        bh=Y0iV1RunWskn9BD9xD2fPJamNpVv9vN+8r7Rej431Wk=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=eS9DCfhixf8+N+bVQkL3bbc4rAFr2WbeYJjr+fbtutmySfM6HeSd/t74XWNBSqbQB
         2tVNi0m6K59OStLSF+cDI0qwOBkqD8bXc2c0yEbpSKIp8NjJ72pj+7O0RvSlflLmGq
         Km73pSsU9qhnllyAzpCHQthgXGSw2u2wx1YUNwzZyJJiJTb5faOKwQdn+Tw5mqTtEt
         Bkh+nofgkT55bGSmb2jgwcS82d292MKjq5gCXuwn8QMSz1D9qemmlPVSYDWpHVl1j4
         P0xPw41ekoPZuEVAd+yUT1+lp0RrQS7azEnuZ0GDDGAQsMqcEffeuvFvvN9f5XaDQW
         ImA0ez0R91OLg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net v3] bonding: fix feature flag setting at init time
Message-ID: <20201203084525.7f1a8e93@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
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
> Don't try to adjust XFRM support flags if the bond device isn't yet
> registered. Bad things can currently happen when netdev_change_features()
> is called without having wanted_features fully filled in yet. This code
> runs on post-module-load mode changes, as well as at module init time
> and new bond creation time, and in the latter two scenarios, it is
> running prior to register_netdevice() having been called and
> subsequently filling in wanted_features. The empty wanted_features led
> to features also getting emptied out, which was definitely not the
> intended behavior, so prevent that from happening.
> 
> Originally, I'd hoped to stop adjusting wanted_features at all in the
> bonding driver, as it's documented as being something only the network
> core should touch, but we actually do need to do this to properly update
> both the features and wanted_features fields when changing the bond type,
> or we get to a situation where ethtool sees:
> 
>     esp-hw-offload: off [requested on]
> 
> I do think we should be using netdev_update_features instead of
> netdev_change_features here though, so we only send notifiers when the
> features actually changed.
> 
> v2: rework based on further testing and suggestions from ivecera
> v3: add helper function, remove goto, fix problem description
> 
> Fixes: a3b658cfb664 ("bonding: allow xfrm offload setup post-module-load")
> Reported-by: Ivan Vecera <ivecera@redhat.com>
> Suggested-by: Ivan Vecera <ivecera@redhat.com>
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Veaceslav Falico <vfalico@gmail.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Thomas Davis <tadavis@lbl.gov>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  drivers/net/bonding/bond_main.c    | 10 ++++------
>  drivers/net/bonding/bond_options.c | 19 ++++++++++++++-----
>  2 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 47afc5938c26..7905534a763b 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -4747,15 +4747,13 @@ void bond_setup(struct net_device *bond_dev)
>  				NETIF_F_HW_VLAN_CTAG_FILTER;
>  
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
>  }
>  
> diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
> index 9abfaae1c6f7..1ae0e5ab8c67 100644
> --- a/drivers/net/bonding/bond_options.c
> +++ b/drivers/net/bonding/bond_options.c
> @@ -745,6 +745,18 @@ const struct bond_option *bond_opt_get(unsigned int option)
>  	return &bond_opts[option];
>  }
>  
> +#ifdef CONFIG_XFRM_OFFLOAD
> +static void bond_set_xfrm_features(struct net_device *bond_dev, u64 mode)
> +{
> +	if (mode == BOND_MODE_ACTIVEBACKUP)
> +		bond_dev->wanted_features |= BOND_XFRM_FEATURES;
> +	else
> +		bond_dev->wanted_features &= ~BOND_XFRM_FEATURES;
> +
> +	netdev_update_features(bond_dev);
> +}
> +#endif /* CONFIG_XFRM_OFFLOAD */
> +
>  static int bond_option_mode_set(struct bonding *bond,
>  				const struct bond_opt_value *newval)
>  {
> @@ -768,11 +780,8 @@ static int bond_option_mode_set(struct bonding *bond,
>  		bond->params.tlb_dynamic_lb = 1;
>  
>  #ifdef CONFIG_XFRM_OFFLOAD
> -	if (newval->value == BOND_MODE_ACTIVEBACKUP)
> -		bond->dev->wanted_features |= BOND_XFRM_FEATURES;
> -	else
> -		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
> -	netdev_change_features(bond->dev);
> +	if (bond->dev->reg_state == NETREG_REGISTERED)
> +		bond_set_xfrm_features(bond->dev, newval->value);
>  #endif /* CONFIG_XFRM_OFFLOAD */

nit: let's narrow down the ifdef-enery

no need for the ifdef here, if the helper looks like this:

+static void bond_set_xfrm_features(struct net_device *bond_dev, u64 mode)
+{
+#ifdef CONFIG_XFRM_OFFLOAD
+	if (mode == BOND_MODE_ACTIVEBACKUP)
+		bond_dev->wanted_features |= BOND_XFRM_FEATURES;
+	else
+		bond_dev->wanted_features &= ~BOND_XFRM_FEATURES;
+
+	netdev_update_features(bond_dev);
+#endif /* CONFIG_XFRM_OFFLOAD */
+}

Even better:

+static void bond_set_xfrm_features(struct net_device *bond_dev, u64 mode)
+{
+	if (!IS_ENABLED(CONFIG_XFRM_OFFLOAD))
+		return;
+
+	if (mode == BOND_MODE_ACTIVEBACKUP)
+		bond_dev->wanted_features |= BOND_XFRM_FEATURES;
+	else
+		bond_dev->wanted_features &= ~BOND_XFRM_FEATURES;
+
+	netdev_update_features(bond_dev);
+}

(Assuming BOND_XFRM_FEATURES doesn't itself hide under an ifdef.)

>  
>  	/* don't cache arp_validate between modes */

