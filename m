Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926B24C5196
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 23:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbiBYWfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 17:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238275AbiBYWfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 17:35:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258461BE0DA
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 14:34:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E9B4B82AC0
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 22:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28C0C340E7;
        Fri, 25 Feb 2022 22:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645828473;
        bh=P7OMAbtw6ZINLFBGNi+0YkYeZqrWRLuLOtpxpGZZ5iA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vBsz7PsyW2m635ZK/SPuof2c2fPMcfVbpBwsT6bxDT/a6CqZlF5YYaqN8+8JU0vFa
         UU4TJxPoMqUSUxd7n8ggHsNGN1b5/+vlREpnVqnNu6apg7/8Px3mEWy2McgBiaH434
         zO5drCDDIu88enhyokj5aA3D/6OjT9feft3cx6Ho4k7+xaUY/bBmWQMQVPKOVDORex
         PJZMl2YYrSS7pVEADzGOBGhJIFU77aOYCxIUvvLTf71AVc/mPjRdG86peln1el6FZx
         7vG/TlMFB8HTReezGtttkluqQQEy/imbgQ0lRovpMpCw7/RXh6PsHIxAK7ESZ/xm7P
         A8uu7CHXnEjWA==
Date:   Fri, 25 Feb 2022 14:34:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        stephen@networkplumber.org, nikolay@cumulusnetworks.com,
        idosch@nvidia.com, dsahern@gmail.com, bpoirier@nvidia.com
Subject: Re: [PATCH net-next v2 11/12] drivers: vxlan: vnifilter: per vni
 stats
Message-ID: <20220225143431.716256c9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <79eed237-4659-7e86-ed26-93f70b1d47bc@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
        <20220222025230.2119189-12-roopa@nvidia.com>
        <20220223200206.20169386@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <79eed237-4659-7e86-ed26-93f70b1d47bc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Feb 2022 09:49:20 -0800 Roopa Prabhu wrote:
> On 2/23/22 20:02, Jakub Kicinski wrote:
> > On Tue, 22 Feb 2022 02:52:29 +0000 Roopa Prabhu wrote:  
> >>   /* vxlan_multicast.c */
> >>   int vxlan_multicast_join(struct vxlan_dev *vxlan);
> >>   int vxlan_multicast_leave(struct vxlan_dev *vxlan);
> >> +void vxlan_vnifilter_count(struct vxlan_dev *vxlan, __be32 vni,
> >> +			   int type, unsigned int len)
> >> +{
> >> +	struct vxlan_vni_node *vninode;
> >> +
> >> +	if (!(vxlan->cfg.flags & VXLAN_F_VNIFILTER))
> >> +		return;
> >> +
> >> +	vninode = vxlan_vnifilter_lookup(vxlan, vni);
> >> +	if (!vninode)
> >> +		return;  
> > Don't we end up calling vxlan_vnifilter_lookup() multiple times for
> > every packet? Can't we remember the vninode from vxlan_vs_find_vni()?
> >  
> you are right, its done this way to not propagate vninode into vxlan_rcv.
> 
> let me see what we can do here.thanks

Thanks for making the changes, BTW there was also a transient warning
here about vxlan_vnifilter_stats_get() being defined but not used.
Maybe move it to the next patch?
