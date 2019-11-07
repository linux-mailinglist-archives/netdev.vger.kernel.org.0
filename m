Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF04CF244C
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 02:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732837AbfKGBdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 20:33:18 -0500
Received: from ozlabs.org ([203.11.71.1]:34719 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbfKGBdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 20:33:18 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 477mBM1pCWz9sP3;
        Thu,  7 Nov 2019 12:33:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1573090395;
        bh=VsO3fAeYbjN3S7yG234wazO8/qEHsnbG2v/22nq4++I=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Lcx6oiQjxm6zMh4RQJV3KsUIPJRUwi8f6KDb0MP9MUJLbu8fT9BEVUd+K5MbrMJ/t
         UqlONSGcEoKlE+gHySDu6EpQxb+6IkonQflL45F2U6hXFNB+ka+I6rQGaTQNmF554k
         j4ZoaosB270YkC2Hvecy/S6dgX7AdkKjC0MjjrG/lvFy2YIDs0oSM6ERTbY03xd57y
         K2Mf+hO/RjzQhNQ3TWT9H8iLSNG1yum4We6FUgJt7vv2BxTYbF0AxIdb2MH2f19imM
         eMoOnou/89LDKZs3uEbygAfzrsHGPbVd/JuFPUnJd1Z15tf2LL/0Vyqj2YCp+Fu5Lc
         BQRGkh7+yZe8A==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     nathanl@linux.ibm.com, netdev@vger.kernel.org,
        Thomas Falcon <tlfalcon@linux.ibm.com>, msuchanek@suse.com,
        tyreld@linux.ibm.com
Subject: Re: [RFC PATCH] powerpc/pseries/mobility: notify network peers after migration
In-Reply-To: <1572998794-9392-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1572998794-9392-1-git-send-email-tlfalcon@linux.ibm.com>
Date:   Thu, 07 Nov 2019 12:33:09 +1100
Message-ID: <87tv7g5v3e.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

Thomas Falcon <tlfalcon@linux.ibm.com> writes:
> After a migration, it is necessary to send a gratuitous ARP
> from all running interfaces so that the rest of the network
> is aware of its new location. However, some supported network
> devices are unaware that they have been migrated. To avoid network
> interruptions and other unwanted behavior, force a GARP on all
> valid, running interfaces as part of the post_mobility_fixup
> routine.
>
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/mobility.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

This patch is in powerpc code, but it's doing networking stuff that I
don't really understand.

So I'd like an Ack from Dave or someone else in netdev land before I
merge it.

cheers


> diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
> index b571285f6c14..c1abc14cf2bb 100644
> --- a/arch/powerpc/platforms/pseries/mobility.c
> +++ b/arch/powerpc/platforms/pseries/mobility.c
> @@ -17,6 +17,9 @@
>  #include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <linux/stringify.h>
> +#include <linux/netdevice.h>
> +#include <linux/rtnetlink.h>
> +#include <net/net_namespace.h>
>  
>  #include <asm/machdep.h>
>  #include <asm/rtas.h>
> @@ -331,6 +334,8 @@ void post_mobility_fixup(void)
>  {
>  	int rc;
>  	int activate_fw_token;
> +	struct net_device *netdev;
> +	struct net *net;
>  
>  	activate_fw_token = rtas_token("ibm,activate-firmware");
>  	if (activate_fw_token == RTAS_UNKNOWN_SERVICE) {
> @@ -371,6 +376,21 @@ void post_mobility_fixup(void)
>  	/* Possibly switch to a new RFI flush type */
>  	pseries_setup_rfi_flush();
>  
> +	/* need to force a gratuitous ARP on running interfaces */
> +	rtnl_lock();
> +	for_each_net(net) {
> +		for_each_netdev(net, netdev) {
> +			if (netif_device_present(netdev) &&
> +			    netif_running(netdev) &&
> +			    !(netdev->flags & (IFF_NOARP | IFF_LOOPBACK)))
> +				call_netdevice_notifiers(NETDEV_NOTIFY_PEERS,
> +							 netdev);
> +				call_netdevice_notifiers(NETDEV_RESEND_IGMP,
> +							 netdev);
> +		}
> +	}
> +	rtnl_unlock();
> +
>  	return;
>  }
>  
> -- 
> 2.12.3
