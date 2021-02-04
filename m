Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652D630F74E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbhBDQJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:09:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237835AbhBDQJa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 11:09:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B37B264F6A;
        Thu,  4 Feb 2021 16:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612454929;
        bh=3IAPQCCNYn5V60zzmVrr36a9HtGkWRc99HBODO496rg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SbGXD2TYulwmiUQymxa1aJ6E9gI3aWMtXnHBN5sPgXVrkpXtCbu+v0ZHPxelGg3kf
         OCEK7Js2lxNP6OULdJSFxzpq9FfVDxZmJCQNHvO0+GZx0qC8q1M2tspWFbV3CM2ebX
         7vYTxzaaKedXFZO77mr+R3l5UMy2ORCNsruSabzc=
Date:   Thu, 4 Feb 2021 17:08:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Haren Myneni <haren@us.ibm.com>,
        Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Steven Royer <seroyer@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH] vio: make remove callback return void
Message-ID: <YBwcDmtefa2WmS90@kroah.com>
References: <20210127215010.99954-1-uwe@kleine-koenig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210127215010.99954-1-uwe@kleine-koenig.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 10:50:10PM +0100, Uwe Kleine-König wrote:
> The driver core ignores the return value of struct bus_type::remove()
> because there is only little that can be done. To simplify the quest to
> make this function return void, let struct vio_driver::remove() return
> void, too. All users already unconditionally return 0, this commit makes
> it obvious that returning an error code is a bad idea and makes it
> obvious for future driver authors that returning an error code isn't
> intended.
> 
> Note there are two nominally different implementations for a vio bus:
> one in arch/sparc/kernel/vio.c and the other in
> arch/powerpc/platforms/pseries/vio.c. I didn't care to check which
> driver is using which of these busses (or if even some of them can be
> used with both) and simply adapt all drivers and the two bus codes in
> one go.
> 
> Note that for the powerpc implementation there is a semantical change:
> Before this patch for a device that was bound to a driver without a
> remove callback vio_cmo_bus_remove(viodev) wasn't called. As the device
> core still considers the device unbound after vio_bus_remove() returns
> calling this unconditionally is the consistent behaviour which is
> implemented here.
> 
> Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
> ---
> Hello,
> 
> note that this change depends on
> https://lore.kernel.org/r/20210121062005.53271-1-ljp@linux.ibm.com which removes
> an (ignored) return -EBUSY in drivers/net/ethernet/ibm/ibmvnic.c.
> I don't know when/if this latter patch will be applied, so it might take
> some time until my patch can go in.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
