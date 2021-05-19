Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCAE3892B0
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 17:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354892AbhESPdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 11:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354862AbhESPdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 11:33:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7163461019;
        Wed, 19 May 2021 15:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621438302;
        bh=/5k+h9ogJ0bXYmfxI52m24QI7eZYZB1/fdwBPZW6G1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nYbqRnPUb+Mwh2KgbD3B7EDNkLAtvZDJo5q4bR+n7uoM2GN2w2pGNtLUq/74DrsRo
         LI2tWamVnzZfnDWBodchGdrLVj9HgXz5Q2NfEkG2MlU4kPaEYsTcft/FzmgyO6vbKQ
         Lfw3+I8SVJINILOkUOm9GSxd0Dpeo/lEWAYBQx0dGwSbLjfhte0woaKVUL6t2zi3vZ
         81cJEu/T47PwoftHumNl1qJdbrWPeJrOyMjFjSfLVf1MtylHpZGfaCAjr9BcioSswS
         nlg6RepccUsw9JhKjh0knMYRFP8LCI7yhQCfJ4yQ3nnYeigl3+m64l8SEHV21EAsAF
         sa5dB5qL61DPg==
Date:   Wed, 19 May 2021 18:31:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shai Malin <malin1024@gmail.com>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, sagi@grimberg.me, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Dean Balandin <dbalandin@marvell.com>
Subject: Re: [RFC PATCH v5 17/27] qedn: Add qedn probe
Message-ID: <YKUvWqvlZNGJqBCy@unreal>
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-18-smalin@marvell.com>
 <YKUFLVHrUdzEsUeq@unreal>
 <CAKKgK4z+Ha9cv0zHtjrBiTb=K9MvWZB-kzg5CP9__pCJYmyNVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKKgK4z+Ha9cv0zHtjrBiTb=K9MvWZB-kzg5CP9__pCJYmyNVA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 05:29:32PM +0300, Shai Malin wrote:
> On Wed, 19 May 2021 at 15:31, Leon Romanovsky wrote:
> > On Wed, May 19, 2021 at 02:13:30PM +0300, Shai Malin wrote:
> > > This patch introduces the functionality of loading and unloading
> > > physical function.
> > > qedn_probe() loads the offload device PF(physical function), and
> > > initialize the HW and the FW with the PF parameters using the
> > > HW ops->qed_nvmetcp_ops, which are similar to other "qed_*_ops" which
> > > are used by the qede, qedr, qedf and qedi device drivers.
> > > qedn_remove() unloads the offload device PF, re-initialize the HW and
> > > the FW with the PF parameters.
> > >
> > > The struct qedn_ctx is per PF container for PF-specific attributes and
> > > resources.
> > >
> > > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > > Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> > > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > > Signed-off-by: Shai Malin <smalin@marvell.com>
> > > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > > ---
> > >  drivers/nvme/hw/Kconfig          |   1 +
> > >  drivers/nvme/hw/qedn/qedn.h      |  35 +++++++
> > >  drivers/nvme/hw/qedn/qedn_main.c | 159 ++++++++++++++++++++++++++++++-
> > >  3 files changed, 190 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/nvme/hw/Kconfig b/drivers/nvme/hw/Kconfig
> > > index 374f1f9dbd3d..91b1bd6f07d8 100644
> > > --- a/drivers/nvme/hw/Kconfig
> > > +++ b/drivers/nvme/hw/Kconfig
> > > @@ -2,6 +2,7 @@
> > >  config NVME_QEDN
> > >       tristate "Marvell NVM Express over Fabrics TCP offload"
> > >       depends on NVME_TCP_OFFLOAD
> > > +     select QED_NVMETCP
> > >       help
> > >         This enables the Marvell NVMe TCP offload support (qedn).
> > >
> > > diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
> > > index bcd0748a10fd..f13073afbced 100644
> > > --- a/drivers/nvme/hw/qedn/qedn.h
> > > +++ b/drivers/nvme/hw/qedn/qedn.h
> > > @@ -6,14 +6,49 @@
> > >  #ifndef _QEDN_H_
> > >  #define _QEDN_H_
> > >
> > > +#include <linux/qed/qed_if.h>
> > > +#include <linux/qed/qed_nvmetcp_if.h>
> > > +
> > >  /* Driver includes */
> > >  #include "../../host/tcp-offload.h"
> > >
> > > +#define QEDN_MAJOR_VERSION           8
> > > +#define QEDN_MINOR_VERSION           62
> > > +#define QEDN_REVISION_VERSION                10
> > > +#define QEDN_ENGINEERING_VERSION     0
> > > +#define DRV_MODULE_VERSION __stringify(QEDE_MAJOR_VERSION) "."       \
> > > +             __stringify(QEDE_MINOR_VERSION) "."             \
> > > +             __stringify(QEDE_REVISION_VERSION) "."          \
> > > +             __stringify(QEDE_ENGINEERING_VERSION)
> > > +
> >
> > This driver module version is not used in this series and more
> > important the module version have no meaning in upstream at all
> > and the community strongly against addition of new such code.
> 
> Will be fixed.
> 
> >
> > >  #define QEDN_MODULE_NAME "qedn"
> >
> > And the general note, it will be great if you convert your probe/remove
> > flows to use auxiliary bus like other drivers that cross subsystems.
> 
> qedn is simply fitting in with the existing design of qed/qede/qedr/qedf/qedi.

I know.

> Changing the entire multi-protocol design to auxiliary bus is being studied.

It will be required to do at some point of time.

Thanks
