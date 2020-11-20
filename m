Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A112BA310
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 08:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgKTHXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 02:23:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:49858 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgKTHXY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 02:23:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1A252AC0C;
        Fri, 20 Nov 2020 07:23:23 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 9F6D0603F9; Fri, 20 Nov 2020 08:23:22 +0100 (CET)
Date:   Fri, 20 Nov 2020 08:23:22 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     tanhuazhong <tanhuazhong@huawei.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, kuba@kernel.org
Subject: Re: [RFC net-next 1/2] ethtool: add support for controling the type
 of adaptive coalescing
Message-ID: <20201120072322.slrpgqydcupm63ep@lion.mk-sys.cz>
References: <1605758050-21061-1-git-send-email-tanhuazhong@huawei.com>
 <1605758050-21061-2-git-send-email-tanhuazhong@huawei.com>
 <20201119041557.GR1804098@lunn.ch>
 <e43890d1-5596-3439-f4a7-d704c069a035@huawei.com>
 <20201119220203.fv2uluoeekyoyxrv@lion.mk-sys.cz>
 <8e9ba4c4-3ef4-f8bc-ab2f-92d695f62f12@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e9ba4c4-3ef4-f8bc-ab2f-92d695f62f12@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 10:59:59AM +0800, tanhuazhong wrote:
> On 2020/11/20 6:02, Michal Kubecek wrote:
> > 
> > We could use a similar approach as struct ethtool_link_ksettings, e.g.
> > 
> > 	struct kernel_ethtool_coalesce {
> > 		struct ethtool_coalesce base;
> > 		/* new members which are not part of UAPI */
> > 	}
> > 
> > get_coalesce() and set_coalesce() would get pointer to struct
> > kernel_ethtool_coalesce and ioctl code would be modified to only touch
> > the base (legacy?) part.
> >  > While already changing the ops arguments, we could also add extack
> > pointer, either as a separate argument or as struct member (I slightly
> > prefer the former).
> 
> If changing the ops arguments, each driver who implement
> set_coalesce/get_coalesce of ethtool_ops need to be updated. Is it
> acceptable adding two new ops to get/set ext_coalesce info (like
> ecc31c60240b ("ethtool: Add link extended state") does)? Maybe i can send V2
> in this way, and then could you help to see which one is more suitable?

If it were just this one case, adding an extra op would be perfectly
fine. But from long term point of view, we should expect extending also
other existing ethtool requests and going this way for all of them would
essentially double the number of callbacks in struct ethtool_ops.

Michal
