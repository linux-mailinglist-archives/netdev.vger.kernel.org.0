Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CEB24A414
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgHSQal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 12:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgHSQak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 12:30:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A479E204FD;
        Wed, 19 Aug 2020 16:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597854639;
        bh=vNDMUoPsqWvcZ7sbEoVUpAmiK4IUIhGGtEnI12bNWJc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J9Z96cJYgThR5IHFlrZdTKlDvvOQY8qZdgjCcRHWKukJxaLSgLivRdKMyfyCV6tXE
         rzEvZkSlqKWyDu4GGrvNAG3E1zRMlzu0DoBzDhobbyrqCb1L0c8H2dhnTkxEL/V+jT
         AGPS3QdpO6DNwy/FnVuttpZyajYbKsjFC6AxeSXU=
Date:   Wed, 19 Aug 2020 09:30:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next v3 3/4] devlink: introduce flash update overwrite
 mask
Message-ID: <20200819093038.2d448fee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <02874ECE860811409154E81DA85FBB58C8B9BF18@fmsmsx101.amr.corp.intel.com>
References: <20200819002821.2657515-1-jacob.e.keller@intel.com>
        <20200819002821.2657515-4-jacob.e.keller@intel.com>
        <20200818205451.35191c0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <02874ECE860811409154E81DA85FBB58C8B9BF18@fmsmsx101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 16:01:02 +0000 Keller, Jacob E wrote:
> > > -#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT	BIT(0)
> > > +#define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT		BIT(0)
> > > +#define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(1)  
> > 
> > Since core will check supported flags, I'd be tempted to have a flag
> > for each override type. Saves an 'if' in every driver.
> 
> Combinations might not be valid (as in ice where identifiers alone
> isn't supportable) but I suppose I could add something for it.

I see, looking at the i40e patch it does seem to not matter in practice
if core checks this or not.

> Would it make sense to just add them to the
> supported_flash_update_params? This results in a bit offset where the
> "supported" bits don't match the actual used bits in overwrite_mask,
> so we could also introduce a separate "supported_overwrite_mask" but
> that might just be overkill since I doubt we'll need to add more than
> a handlful of overwrite bits...
>
> > >  struct devlink_region;
> > >  struct devlink_info_req;
> > > diff --git a/include/uapi/linux/devlink.h
> > > b/include/uapi/linux/devlink.h index cfef4245ea5a..1d8bbe9c1ae1
> > > 100644 --- a/include/uapi/linux/devlink.h
> > > +++ b/include/uapi/linux/devlink.h
> > > @@ -228,6 +228,28 @@ enum {
> > >  	DEVLINK_ATTR_STATS_MAX = __DEVLINK_ATTR_STATS_MAX - 1
> > >  };
> > >
> > > +/* Specify what sections of a flash component can be overwritten
> > > when
> > > + * performing an update. Overwriting of firmware binary sections
> > > is always
> > > + * implicitly assumed to be allowed.
> > > + *
> > > + * Each section must be documented in
> > > + * Documentation/networking/devlink/devlink-flash.rst
> > > + *
> > > + */
> > > +enum {
> > > +	DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT,
> > > +	DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT,  
> > 
> > IMHO generally a good practice to have 0 be undefined.
> 
> Even for bits? I saw that for attribute values 0 was undefined, but
> that didn't seem right for a bit position. sending the bitfield with
> zero bit set means the same as not sending the bitfield.

Ah, misread the code, sorry.
