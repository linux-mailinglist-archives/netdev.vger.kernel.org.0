Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B181462E1B
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 09:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239331AbhK3ID4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 03:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239332AbhK3IDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 03:03:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C45AC061714;
        Tue, 30 Nov 2021 00:00:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D5065CE1805;
        Tue, 30 Nov 2021 08:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2E8C53FC7;
        Tue, 30 Nov 2021 08:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638259232;
        bh=gwVGC0FCLR9lTUsfRmzZgc76rFUCFN275E0muoiWsyo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GtpdM2vtVEDqKjuuYCPFplX6Kqy//iHakJXjcI2g+X0C7os4V9LAO/Yrg1scbZY6h
         p2lGycR7k+oLbh/mNGJ4M+QTYvtAtvHDwomFRKntFb4o/A5GhR9UMOCmshuFnAXPZT
         8sVX1IPLrK9JovYJCSkVzsDGfxd+xjffJEMaI9Th65BrHYAI4cEidHdwROVvr7vtXJ
         DbSNCF+4ZhPL0GltwHdmSHp852EALV4PWICJMSp/BIJM6d/IuhFiZq8LtbuFW/5Flj
         14R+kg/vi3LQtoUilvtt3htt7X88SMq75PIFEyWW+G4baYmC65rLKiXxQzGVU2RQeS
         CieIW90nZRewQ==
Date:   Tue, 30 Nov 2021 10:00:28 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v1] devlink: Simplify devlink resources
 unregister call
Message-ID: <YaXaHCW3/WQiiTeS@unreal>
References: <e8684abc2c8ced4e35026e8fa85fe29447ef60b6.1638103213.git.leonro@nvidia.com>
 <20211129201400.488c8ef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129201400.488c8ef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 08:14:00PM -0800, Jakub Kicinski wrote:
> On Sun, 28 Nov 2021 14:42:44 +0200 Leon Romanovsky wrote:
> > The devlink_resources_unregister() used second parameter as an
> > entry point for the recursive removal of devlink resources. None
> > of external to devlink users needed to use this field, so lat's
> 
> None of the callers outside of devlink core...
> s/lat/let/
> 
> > remove it.
> 
> > diff --git a/include/net/devlink.h b/include/net/devlink.h
> > index e3c88fabd700..043fcec8b0aa 100644
> > --- a/include/net/devlink.h
> > +++ b/include/net/devlink.h
> > @@ -361,33 +361,6 @@ devlink_resource_size_params_init(struct devlink_resource_size_params *size_para
> >  
> >  typedef u64 devlink_resource_occ_get_t(void *priv);
> >  
> > -/**
> > - * struct devlink_resource - devlink resource
> > - * @name: name of the resource
> > - * @id: id, per devlink instance
> > - * @size: size of the resource
> > - * @size_new: updated size of the resource, reload is needed
> > - * @size_valid: valid in case the total size of the resource is valid
> > - *              including its children
> > - * @parent: parent resource
> > - * @size_params: size parameters
> > - * @list: parent list
> > - * @resource_list: list of child resources
> > - */
> > -struct devlink_resource {
> > -	const char *name;
> > -	u64 id;
> > -	u64 size;
> > -	u64 size_new;
> > -	bool size_valid;
> > -	struct devlink_resource *parent;
> > -	struct devlink_resource_size_params size_params;
> > -	struct list_head list;
> > -	struct list_head resource_list;
> > -	devlink_resource_occ_get_t *occ_get;
> > -	void *occ_get_priv;
> > -};
> 
> > diff --git a/net/core/devlink.c b/net/core/devlink.c
> > index fd21022145a3..db3b52110cf2 100644
> > --- a/net/core/devlink.c
> > +++ b/net/core/devlink.c
> > @@ -69,6 +69,35 @@ struct devlink {
> >  	char priv[] __aligned(NETDEV_ALIGN);
> >  };
> >  
> > +/**
> > + * struct devlink_resource - devlink resource
> > + * @name: name of the resource
> > + * @id: id, per devlink instance
> > + * @size: size of the resource
> > + * @size_new: updated size of the resource, reload is needed
> > + * @size_valid: valid in case the total size of the resource is valid
> > + *              including its children
> > + * @parent: parent resource
> > + * @size_params: size parameters
> > + * @list: parent list
> > + * @resource_list: list of child resources
> > + * @occ_get: occupancy getter callback
> > + * @occ_get_priv: occupancy getter callback priv
> > + */
> > +struct devlink_resource {
> > +	const char *name;
> > +	u64 id;
> > +	u64 size;
> > +	u64 size_new;
> > +	bool size_valid;
> > +	struct devlink_resource *parent;
> > +	struct devlink_resource_size_params size_params;
> > +	struct list_head list;
> > +	struct list_head resource_list;
> > +	devlink_resource_occ_get_t *occ_get;
> > +	void *occ_get_priv;
> > +};
> 
> Hiding struct devlink_resource is not mentioned in the commit message
> and entirely unrelated to removal of the unused argument.

devlink_resources_unregister() was the API function that is declared in
the devlink.h that used "struct devlink_resource". Once we removed extra
parameter from that function, the "struct devlink_resource" left as not
used at all. So this "hiding" is related and part of this simplification
patch.

I will add it to the commit message.

Thanks
