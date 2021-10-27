Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC5743CBCA
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242464AbhJ0OTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:19:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242449AbhJ0ORU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 10:17:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635344094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hJrML/RRrYOCcLcaDpLc5DyYFDVAJz2ir0815yDh2Js=;
        b=JaRW1soB9llkss5+C2fIC7esGFk1ATY6gC1dte8XyM/aZmz959zzDbTcsAIwBmsTvYkACY
        110YpoGCeMUz1L7+UoCDguQWVsiHSdoypdKA7Jn9HQAhCAmZ8WVRWo9d0maNzvGrsUN7mG
        FmgOUJqjcF5S+LKmCe1UMs8F/+eD9RE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-AyFWpsHFNxWvgDJNk17mcw-1; Wed, 27 Oct 2021 10:14:51 -0400
X-MC-Unique: AyFWpsHFNxWvgDJNk17mcw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DAFF1129581;
        Wed, 27 Oct 2021 14:14:49 +0000 (UTC)
Received: from ceranb (unknown [10.40.193.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0781419D9F;
        Wed, 27 Oct 2021 14:14:46 +0000 (UTC)
Date:   Wed, 27 Oct 2021 16:14:40 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: bridge: fix uninitialized variables when
 BRIDGE_CFM is disabled
Message-ID: <20211027161440.00cb1107@ceranb>
In-Reply-To: <a9b7d8d2-da03-42f0-bd16-3446cdcaecc8@nvidia.com>
References: <20211027134926.1412459-1-ivecera@redhat.com>
        <a9b7d8d2-da03-42f0-bd16-3446cdcaecc8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 16:54:39 +0300
Nikolay Aleksandrov <nikolay@nvidia.com> wrote:

> On 27/10/2021 16:49, Ivan Vecera wrote:
> > Function br_get_link_af_size_filtered() calls br_cfm_{,peer}_mep_count()
> > but does not check their return value. When BRIDGE_CFM is not enabled
> > these functions return -EOPNOTSUPP but do not modify count parameter.
> > Calling function then works with uninitialized variables.
> > 
> > Fixes: b6d0425b816e ("bridge: cfm: Netlink Notifications.")
> > Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> > ---
> >  net/bridge/br_netlink.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> > index 5c6c4305ed23..12d602495ea0 100644
> > --- a/net/bridge/br_netlink.c
> > +++ b/net/bridge/br_netlink.c
> > @@ -126,8 +126,10 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
> >  		return vinfo_sz;
> >  
> >  	/* CFM status info must be added */
> > -	br_cfm_mep_count(br, &num_cfm_mep_infos);
> > -	br_cfm_peer_mep_count(br, &num_cfm_peer_mep_infos);
> > +	if (br_cfm_mep_count(br, &num_cfm_mep_infos) < 0)
> > +		num_cfm_mep_infos = 0;
> > +	if (br_cfm_peer_mep_count(br, &num_cfm_peer_mep_infos) < 0)
> > +		num_cfm_peer_mep_infos = 0;
> >  
> >  	vinfo_sz += nla_total_size(0);	/* IFLA_BRIDGE_CFM */
> >  	/* For each status struct the MEP instance (u32) is added */
> >   
> 
> Hi,
> Could you please rather update the EOPNOTSUPP helpers to set these infos to 0 before
> returning? Someone else might decide to use them and hit the same bug.
> 
> E.g.
> static inline int br_cfm_mep_count(struct net_bridge *br, u32 *count)
> {
> 	*count = 0;
>         return -EOPNOTSUPP;
> }
> 
> We already do the same for br_allowed_ingress, nbp_vlan_add() etc.
> 
> Thanks,
>  Nik
> 

Ok, Nik... works for me.

Thanks,
Ivan

