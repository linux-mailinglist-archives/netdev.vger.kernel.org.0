Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52733408960
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 12:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239189AbhIMKvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 06:51:46 -0400
Received: from mail.stusta.mhn.de ([141.84.69.5]:57596 "EHLO
        mail.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238690AbhIMKvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 06:51:46 -0400
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2021 06:51:45 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.stusta.mhn.de (Postfix) with ESMTPSA id 4H7NMS5XB0z1cv;
        Mon, 13 Sep 2021 12:41:56 +0200 (CEST)
Date:   Mon, 13 Sep 2021 13:41:54 +0300
From:   Adrian Bunk <bunk@kernel.org>
To:     Shai Malin <smalin@marvell.com>
Cc:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bnx2x: Fix enabling network interfaces without VFs
Message-ID: <20210913104154.GT11834@localhost>
References: <SJ0PR18MB38825BC9620238DE3327C64FCCD99@SJ0PR18MB3882.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SJ0PR18MB38825BC9620238DE3327C64FCCD99@SJ0PR18MB3882.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 08:14:33AM +0000, Shai Malin wrote:
> On 9/12/2021 at 10:08PM, Adrian Bunk Wrote:
> > This function is called to enable SR-IOV when available,
> > not enabling interfaces without VFs was a regression.
> > 
> > Fixes: 65161c35554f ("bnx2x: Fix missing error code in bnx2x_iov_init_one()")
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > Reported-by: YunQiang Su <wzssyqa@gmail.com>
> > Tested-by: YunQiang Su <wzssyqa@gmail.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> > b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> > index f255fd0b16db..6fbf735fca31 100644
> > --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> > +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
> > @@ -1224,7 +1224,7 @@ int bnx2x_iov_init_one(struct bnx2x *bp, int
> > int_mode_param,
> > 
> >  	/* SR-IOV capability was enabled but there are no VFs*/
> >  	if (iov->total == 0) {
> > -		err = -EINVAL;
> > +		err = 0;
> >  		goto failed;
> >  	}
> 
> Thanks for reporting this issue!
> But the complete fix should also not use "goto failed".
> Instead, please create a new "goto skip_vfs" so it will skip 
> the log of "Failed err=".

Is this really desirable?
It is a debug print not enabled by default,
and trying to enable SR-IOV did fail.

cu
Adrian
