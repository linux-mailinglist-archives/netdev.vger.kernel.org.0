Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE56306A6D
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhA1BdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:33:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231405AbhA1BcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 20:32:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD81064DC4;
        Thu, 28 Jan 2021 01:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611797494;
        bh=O8J3QU8RKLJLES52uzD6a56bPivq9qUgXZENgpbJ+yw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KY0kt6/5pJvFBbuXvgz7orsamMiAQ4E5TwxUOKz0ry2ljGRpBCOnpFddYEweNDw/y
         s8Cm5tf+yU2cX60iHCAQHAB1WMq9KVHyfAx8CodTr2ytWjXS9CzkZ2l8ozEbe7R49I
         +HSHJ0kbaSfwxvzTP5BmAr2sSV/Y04+/OFV57jvhnZ7h3ZlMvHkIchEkHNY1P72SR+
         Bz8g6QCL5ca25eBchtj7AKnWMtX57zEbOnNGdOEp+VJLhbTSGQUae87ywtnjaMYY4a
         j+B2tBi68JY5LHNLUAVx2it+zevKbVn0l3mJTNMYHz2UOsuyh1jhaFU2+Ol65g7gxI
         dyH+wCtE8VaDQ==
Date:   Wed, 27 Jan 2021 17:31:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] ibmvnic: Ensure that CRQ entry read are
 correctly ordered
Message-ID: <20210127173133.1fb08b8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOhMmr7B4T6XRiGbawsyGBg_Ysa+fBVVacHFPACM8_+4+yjs_g@mail.gmail.com>
References: <20210125232023.78649-1-ljp@linux.ibm.com>
        <20210127170105.011ebb9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAOhMmr7B4T6XRiGbawsyGBg_Ysa+fBVVacHFPACM8_+4+yjs_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021 19:22:25 -0600 Lijun Pan wrote:
> On Wed, Jan 27, 2021 at 7:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 25 Jan 2021 17:20:23 -0600 Lijun Pan wrote:  
> > > Ensure that received Command-Response Queue (CRQ) entries are
> > > properly read in order by the driver. dma_rmb barrier has
> > > been added before accessing the CRQ descriptor to ensure
> > > the entire descriptor is read before processing.
> > >
> > > Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
> > > Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> > > ---
> > > v2: drop dma_wmb according to Jakub's opinion
> > >
> > >  drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> > > index 9778c83150f1..d84369bd5fc9 100644
> > > --- a/drivers/net/ethernet/ibm/ibmvnic.c
> > > +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> > > @@ -5084,6 +5084,14 @@ static void ibmvnic_tasklet(struct tasklet_struct *t)
> > >       while (!done) {
> > >               /* Pull all the valid messages off the CRQ */
> > >               while ((crq = ibmvnic_next_crq(adapter)) != NULL) {
> > > +                     /* Ensure that the entire CRQ descriptor queue->msgs
> > > +                      * has been loaded before reading its contents.  
> >
> > I still find this sentence confusing, maybe you mean to say stored
> > instead of loaded?  
> 
> The above 2 lines are the general description. The below 4 lines are
> detailed explanations. If it is still confusing, we can delete the above
> 2 lines of comments.

Yes, I'd find the comment clearer without them, thanks.
