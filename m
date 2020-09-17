Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4388826D101
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 04:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgIQCNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 22:13:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgIQCNL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 22:13:11 -0400
X-Greylist: delayed 1869 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 22:13:10 EDT
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kIivn-00F0Td-D2; Thu, 17 Sep 2020 03:41:51 +0200
Date:   Thu, 17 Sep 2020 03:41:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethtool: add and use message type for tunnel info
 reply
Message-ID: <20200917014151.GK3463198@lunn.ch>
References: <20200916230410.34FCE6074F@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916230410.34FCE6074F@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 01:04:10AM +0200, Michal Kubecek wrote:
> Tunnel offload info code uses ETHTOOL_MSG_TUNNEL_INFO_GET message type (cmd
> field in genetlink header) for replies to tunnel info netlink request, i.e.
> the same value as the request have. This is a problem because we are using
> two separate enums for userspace to kernel and kernel to userspace message
> types so that this ETHTOOL_MSG_TUNNEL_INFO_GET (28) collides with
> ETHTOOL_MSG_CABLE_TEST_TDR_NTF which is what message type 28 means for
> kernel to userspace messages.

>  
>  	rskb = ethnl_reply_init(reply_len, req_info.dev,
> -				ETHTOOL_MSG_TUNNEL_INFO_GET,
> +				ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
>  				ETHTOOL_A_TUNNEL_INFO_HEADER,
>  				info, &reply_payload);

Michal

Maybe it would make sense to change the two enums from anonymous to
tagged. We can then make ethnl_reply_init() do type checking and
hopefully catch such problems earlier?

I just wonder if we then run into ABI problems?

	  Andrew
