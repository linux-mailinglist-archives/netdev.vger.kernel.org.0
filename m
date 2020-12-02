Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F176E2CC464
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730968AbgLBR4U convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Dec 2020 12:56:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50703 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgLBR4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:56:20 -0500
Received: from 1.general.jvosburgh.uk.vpn ([10.172.196.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kkWLi-0000FH-5l; Wed, 02 Dec 2020 17:55:30 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 9B6D05FEE8; Wed,  2 Dec 2020 09:55:28 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 960CB9FAB0;
        Wed,  2 Dec 2020 09:55:28 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     linux-kernel@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] bonding: fix feature flag setting at init time
In-reply-to: <20201202173053.13800-1-jarod@redhat.com>
References: <20201123031716.6179-1-jarod@redhat.com> <20201202173053.13800-1-jarod@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Wed, 02 Dec 2020 12:30:53 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14710.1606931728.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 02 Dec 2020 09:55:28 -0800
Message-ID: <14711.1606931728@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>Don't try to adjust XFRM support flags if the bond device isn't yet
>registered. Bad things can currently happen when netdev_change_features()
>is called without having wanted_features fully filled in yet. Basically,
>this code was racing against register_netdevice() filling in
>wanted_features, and when it got there first, the empty wanted_features
>led to features also getting emptied out, which was definitely not the
>intended behavior, so prevent that from happening.

	Is this an actual race?  Reading Ivan's prior message, it sounds
like it's an ordering problem (in that bond_newlink calls
register_netdevice after bond_changelink).

	The change to bond_option_mode_set tests against reg_state, so
presumably it wants to skip the first(?) time through, before the
register_netdevice call; is that right?

	-J

>Originally, I'd hoped to stop adjusting wanted_features at all in the
>bonding driver, as it's documented as being something only the network
>core should touch, but we actually do need to do this to properly update
>both the features and wanted_features fields when changing the bond type,
>or we get to a situation where ethtool sees:
>
>    esp-hw-offload: off [requested on]
>
>I do think we should be using netdev_update_features instead of
>netdev_change_features here though, so we only send notifiers when the
>features actually changed.
>
>v2: rework based on further testing and suggestions from ivecera
>
>Fixes: a3b658cfb664 ("bonding: allow xfrm offload setup post-module-load")
>Reported-by: Ivan Vecera <ivecera@redhat.com>
>Suggested-by: Ivan Vecera <ivecera@redhat.com>
>Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>Cc: Veaceslav Falico <vfalico@gmail.com>
>Cc: Andy Gospodarek <andy@greyhouse.net>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Thomas Davis <tadavis@lbl.gov>
>Cc: netdev@vger.kernel.org
>Signed-off-by: Jarod Wilson <jarod@redhat.com>
>---
> drivers/net/bonding/bond_main.c    | 10 ++++------
> drivers/net/bonding/bond_options.c |  6 +++++-
> 2 files changed, 9 insertions(+), 7 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index e0880a3840d7..5fe5232cc3f3 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -4746,15 +4746,13 @@ void bond_setup(struct net_device *bond_dev)
> 				NETIF_F_HW_VLAN_CTAG_FILTER;
> 
> 	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
>-#ifdef CONFIG_XFRM_OFFLOAD
>-	bond_dev->hw_features |= BOND_XFRM_FEATURES;
>-#endif /* CONFIG_XFRM_OFFLOAD */
> 	bond_dev->features |= bond_dev->hw_features;
> 	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
> #ifdef CONFIG_XFRM_OFFLOAD
>-	/* Disable XFRM features if this isn't an active-backup config */
>-	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
>-		bond_dev->features &= ~BOND_XFRM_FEATURES;
>+	bond_dev->hw_features |= BOND_XFRM_FEATURES;
>+	/* Only enable XFRM features if this is an active-backup config */
>+	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
>+		bond_dev->features |= BOND_XFRM_FEATURES;
> #endif /* CONFIG_XFRM_OFFLOAD */
> }
> 
>diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
>index 9abfaae1c6f7..19205cfac751 100644
>--- a/drivers/net/bonding/bond_options.c
>+++ b/drivers/net/bonding/bond_options.c
>@@ -768,11 +768,15 @@ static int bond_option_mode_set(struct bonding *bond,
> 		bond->params.tlb_dynamic_lb = 1;
> 
> #ifdef CONFIG_XFRM_OFFLOAD
>+	if (bond->dev->reg_state != NETREG_REGISTERED)
>+		goto noreg;
>+
> 	if (newval->value == BOND_MODE_ACTIVEBACKUP)
> 		bond->dev->wanted_features |= BOND_XFRM_FEATURES;
> 	else
> 		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
>-	netdev_change_features(bond->dev);
>+	netdev_update_features(bond->dev);
>+noreg:
>
> #endif /* CONFIG_XFRM_OFFLOAD */
> 
> 	/* don't cache arp_validate between modes */
>-- 
>2.28.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
