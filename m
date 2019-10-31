Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 529C8EB659
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbfJaRsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:48:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23417 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728999AbfJaRsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 13:48:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572544119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sarH5n506MjBGVryT20NOT4A+asB36O1i3CqtoZk8ZQ=;
        b=hIf0qtpYUhzIDmzr/kl7zic2I2GFmiNu+t6BwG00AYv/IGIAI6tA3Lty9PSVJCFCxIfX/O
        a878R77u7ow+2nImyk3TYXDcCZrEZsAdBuxPIsGiPrBdWCMx+aAh35mSR6a1AJWXDKQjyJ
        2MDEfgZRei+5x764G5esbaMYsC0Cpho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-k7ib80AAMcqFTB2eI7Onyg-1; Thu, 31 Oct 2019 13:48:29 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01CDD800D49;
        Thu, 31 Oct 2019 17:48:28 +0000 (UTC)
Received: from hmswarspite.think-freely.org (ovpn-120-224.rdu2.redhat.com [10.10.120.224])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B80E160852;
        Thu, 31 Oct 2019 17:48:26 +0000 (UTC)
Date:   Thu, 31 Oct 2019 13:48:25 -0400
From:   Neil Horman <nhorman@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     joe@perches.com, jeffrey.t.kirsher@intel.com, davem@davemloft.net,
        zdai@linux.vnet.ibm.com, netdev@vger.kernel.org,
        smorumu1@in.ibm.com, intel-wired-lan@lists.osuosl.org,
        aaron.f.brown@intel.com, sassmann@redhat.com
Subject: Re: [next-queue/net-next PATCH] e1000e: Use netdev_info instead of
 pr_info for link messages
Message-ID: <20191031174825.GC11617@hmswarspite.think-freely.org>
References: <cf197ef61703cbaa64ac522cf5d191b4b74f64d6.camel@linux.intel.com>
 <20191031165537.24154.48242.stgit@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <20191031165537.24154.48242.stgit@localhost.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: k7ib80AAMcqFTB2eI7Onyg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 09:58:51AM -0700, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>=20
> Replace the pr_info calls with netdev_info in all cases related to the
> netdevice link state.
>=20
> As a result of this patch the link messages will change as shown below.
> Before:
> e1000e: ens3 NIC Link is Down
> e1000e: ens3 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
>=20
> After:
> e1000e 0000:00:03.0 ens3: NIC Link is Down
> e1000e 0000:00:03.0 ens3: NIC Link is Up 1000 Mbps Full Duplex, Flow Cont=
rol: Rx/Tx
>=20
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>=20
> Since Joe hasn't gotten back to me on if he wanted to do the patch or if
> he wanted me to do it I just went ahead and did it. This should address t=
he
> concerns he had about the message formatting in "e1000e: Use rtnl_lock to
> prevent race".
>=20
>  drivers/net/ethernet/intel/e1000e/netdev.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/eth=
ernet/intel/e1000e/netdev.c
> index ef8ca0c134b0..a1aa48168855 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -4720,7 +4720,7 @@ int e1000e_close(struct net_device *netdev)
>  =09=09e1000_free_irq(adapter);
> =20
>  =09=09/* Link status message must follow this format */
> -=09=09pr_info("%s NIC Link is Down\n", netdev->name);
> +=09=09netdev_info(netdev, "NIC Link is Down\n");
>  =09}
> =20
>  =09napi_disable(&adapter->napi);
> @@ -5070,8 +5070,9 @@ static void e1000_print_link_info(struct e1000_adap=
ter *adapter)
>  =09u32 ctrl =3D er32(CTRL);
> =20
>  =09/* Link status message must follow this format for user tools */
> -=09pr_info("%s NIC Link is Up %d Mbps %s Duplex, Flow Control: %s\n",
> -=09=09adapter->netdev->name, adapter->link_speed,
> +=09netdev_info(adapter->netdev,
> +=09=09"NIC Link is Up %d Mbps %s Duplex, Flow Control: %s\n",
> +=09=09adapter->link_speed,
>  =09=09adapter->link_duplex =3D=3D FULL_DUPLEX ? "Full" : "Half",
>  =09=09(ctrl & E1000_CTRL_TFCE) && (ctrl & E1000_CTRL_RFCE) ? "Rx/Tx" :
>  =09=09(ctrl & E1000_CTRL_RFCE) ? "Rx" :
> @@ -5304,7 +5305,7 @@ static void e1000_watchdog_task(struct work_struct =
*work)
>  =09=09=09adapter->link_speed =3D 0;
>  =09=09=09adapter->link_duplex =3D 0;
>  =09=09=09/* Link status message must follow this format */
> -=09=09=09pr_info("%s NIC Link is Down\n", adapter->netdev->name);
> +=09=09=09netdev_info(netdev, "NIC Link is Down\n");
>  =09=09=09netif_carrier_off(netdev);
>  =09=09=09netif_stop_queue(netdev);
>  =09=09=09if (!test_bit(__E1000_DOWN, &adapter->state))
>=20
Acked-by: Neil Horman <nhorman@tuxdriver.com>

