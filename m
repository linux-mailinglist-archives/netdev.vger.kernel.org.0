Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7613324F79
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 12:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhBYLu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 06:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhBYLut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 06:50:49 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0769C06174A;
        Thu, 25 Feb 2021 03:50:08 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DmWLG6r0dz9sVF;
        Thu, 25 Feb 2021 22:49:58 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1614253805;
        bh=/SYtgE5qENlSC96VzcIwZTaGUmL6HCYNrQHwHPYZSs4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=iSkCaS/DJVPQlH0gbL+LD45kazqnKgdUXrGSiY0t5rVH7XgWyEZ3dVcZQMrrdzWxb
         5MgqcVG9pQkFcrHW+MXEpmHj5iL5Dc/O0Q3xerdpbA7nNL2QioWinUYOGNO1CftmBu
         foAGxV0uCzTC0mgQqEJOVDt+y1/5VQz2b92Jel0/OqIMCucyj2A49/JmP77ew5X9ex
         7ocZxtF4Q7Ij1XMzTR+G4KGixhAD12BQzG5y3VyTqzm+g5IL6UR67JPFL4nCBTOTxL
         1NBGWLbvxkYV3zB/XybDZ47lwrc8H7FUaYmZhnqcTWr1RcqeZBKCgq+EBQqZHvNLXS
         lfxhg1WNI9+Mg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Haren Myneni <haren@us.ibm.com>,
        Breno =?utf-8?Q?Leit?= =?utf-8?Q?=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Steven Royer <seroyer@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH v2] vio: make remove callback return void
In-Reply-To: <20210224072516.74696-1-uwe@kleine-koenig.org>
References: <20210224072516.74696-1-uwe@kleine-koenig.org>
Date:   Thu, 25 Feb 2021 22:49:54 +1100
Message-ID: <87sg5ks6xp.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uwe Kleine-K=C3=B6nig <uwe@kleine-koenig.org> writes:
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

I'm 99% sure there's no connection between the two implementations,
other than the name.

So splitting the patch by arch would make it easier to merge. I'm
reluctant to merge changes to sparc code.

The list of powerpc specific drivers is:

  drivers/char/hw_random/pseries-rng.c
  drivers/char/tpm/tpm_ibmvtpm.c
  drivers/crypto/nx/nx-842-pseries.c
  drivers/crypto/nx/nx.c
  drivers/misc/ibmvmc.c
  drivers/net/ethernet/ibm/ibmveth.c
  drivers/net/ethernet/ibm/ibmvnic.c
  drivers/scsi/ibmvscsi/ibmvfc.c
  drivers/scsi/ibmvscsi/ibmvscsi.c
  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
  drivers/tty/hvc/hvcs.c

cheers
