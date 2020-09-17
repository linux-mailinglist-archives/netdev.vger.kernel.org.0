Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F02726E76F
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 23:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgIQV3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 17:29:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:33310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgIQV3V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 17:29:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CA1E6B178;
        Thu, 17 Sep 2020 21:29:53 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 962076074F; Thu, 17 Sep 2020 23:29:19 +0200 (CEST)
Date:   Thu, 17 Sep 2020 23:29:19 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethtool: add and use message type for tunnel info
 reply
Message-ID: <20200917212919.3n6f3zdegjeyhfud@lion.mk-sys.cz>
References: <20200916230410.34FCE6074F@lion.mk-sys.cz>
 <20200917014151.GK3463198@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917014151.GK3463198@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 03:41:51AM +0200, Andrew Lunn wrote:
> On Thu, Sep 17, 2020 at 01:04:10AM +0200, Michal Kubecek wrote:
> > Tunnel offload info code uses ETHTOOL_MSG_TUNNEL_INFO_GET message type (cmd
> > field in genetlink header) for replies to tunnel info netlink request, i.e.
> > the same value as the request have. This is a problem because we are using
> > two separate enums for userspace to kernel and kernel to userspace message
> > types so that this ETHTOOL_MSG_TUNNEL_INFO_GET (28) collides with
> > ETHTOOL_MSG_CABLE_TEST_TDR_NTF which is what message type 28 means for
> > kernel to userspace messages.
> 
> >  
> >  	rskb = ethnl_reply_init(reply_len, req_info.dev,
> > -				ETHTOOL_MSG_TUNNEL_INFO_GET,
> > +				ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
> >  				ETHTOOL_A_TUNNEL_INFO_HEADER,
> >  				info, &reply_payload);
> 
> Michal
> 
> Maybe it would make sense to change the two enums from anonymous to
> tagged. We can then make ethnl_reply_init() do type checking and
> hopefully catch such problems earlier?

This sounds like a good idea, it should prevent similar mistakes.

> I just wonder if we then run into ABI problems?

I don't think there would be a problem with ABI, binary representation
of the values shouldn't change and ethnl_reply_init() is not even
exported; ethtool_notify() which would also benefit from stricter type
checking is exported but it is still kernel API which is not guaranteed
to be stable.

On the other hand, the enums are part of userspace API so I better take
a closer look to make sure we don't run into some trouble there.

Michal
