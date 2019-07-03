Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF7C5E2AA
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 13:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfGCLNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 07:13:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:55660 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726486AbfGCLNx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 07:13:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 080F8AD89;
        Wed,  3 Jul 2019 11:13:50 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 2C95EE0159; Wed,  3 Jul 2019 13:13:47 +0200 (CEST)
Date:   Wed, 3 Jul 2019 13:13:47 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 05/15] ethtool: helper functions for netlink
 interface
Message-ID: <20190703111347.GK20101@unicorn.suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <44957b13e8edbced71aca893908d184eb9e57341.1562067622.git.mkubecek@suse.cz>
 <20190702130515.GO2250@nanopsycho>
 <20190702163437.GE20101@unicorn.suse.cz>
 <20190703100435.GS2250@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703100435.GS2250@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 12:04:35PM +0200, Jiri Pirko wrote:
> Tue, Jul 02, 2019 at 06:34:37PM CEST, mkubecek@suse.cz wrote:
> >On Tue, Jul 02, 2019 at 03:05:15PM +0200, Jiri Pirko wrote:
> >> Tue, Jul 02, 2019 at 01:50:04PM CEST, mkubecek@suse.cz wrote:
> >> >+
> >> >+	req_info->dev = dev;
> >> >+	ethnl_update_u32(&req_info->req_mask, tb[ETHTOOL_A_HEADER_INFOMASK]);
> >> >+	ethnl_update_u32(&req_info->global_flags, tb[ETHTOOL_A_HEADER_GFLAGS]);
> >> >+	ethnl_update_u32(&req_info->req_flags, tb[ETHTOOL_A_HEADER_RFLAGS]);
> >> 
> >> Just:
> >> 	req_info->req_mask = nla_get_u32(tb[ETHTOOL_A_HEADER_INFOMASK];
> >> 	...
> >> 
> >> Not sure what ethnl_update_u32() is good for, but it is not needed here.
> >
> >That would result in null pointer dereference if the attribute is
> >missing. So you would need at least
> >
> >	if (tb[ETHTOOL_A_HEADER_INFOMASK])
> >		req_info->req_mask = nla_get_u32(tb[ETHTOOL_A_HEADER_INFOMASK]);
> >	if (tb[ETHTOOL_A_HEADER_GFLAGS])
> >		req_info->global_flags =
> >			nla_get_u32(tb[ETHTOOL_A_HEADER_GFLAGS]);
> >	if (tb[ETHTOOL_A_HEADER_RFLAGS])
> >		req_info->req_flags = nla_get_u32(tb[ETHTOOL_A_HEADER_RFLAGS]);
> 
> Yeah, sure.
> 
> >
> >I don't think it looks better.
> 
> Better than hiding something inside a helper in my opinion - helper that
> is there for different reason moreover. Much easier to read the code
> and follow.

OK, I'll use nla_get_u32() directly here. With the change below, use of
ethnl_update_u32() would really look unnatural.

> >> >+/* The ethnl_update_* helpers set value pointed to by @dst to the value of
> >> >+ * netlink attribute @attr (if attr is not null). They return true if *dst
> >> >+ * value was changed, false if not.
> >> >+ */
> >> >+static inline bool ethnl_update_u32(u32 *dst, struct nlattr *attr)
> >> 
> >> I'm still not sure I'm convinced about these "update helpers" :)
> >
> >Just imagine what would e.g.
> >
> >	if (ethnl_update_u32(&data.rx_pending, tb[ETHTOOL_A_RING_RX_PENDING]))
> >		mod = true;
> >	if (ethnl_update_u32(&data.rx_mini_pending,
> >			     tb[ETHTOOL_A_RING_RX_MINI_PENDING]))
> >		mod = true;
> >	if (ethnl_update_u32(&data.rx_jumbo_pending,
> >			     tb[ETHTOOL_A_RING_RX_JUMBO_PENDING]))
> >		mod = true;
> >	if (ethnl_update_u32(&data.tx_pending, tb[ETHTOOL_A_RING_TX_PENDING]))
> >		mod = true;
> >	if (!mod)
> >		return 0;
> >
> >look like without them. And coalescing parameters would be much worse
> >(22 attributes / struct members).
> 
> No, I understand your motivation, don't get me wrong. I just wonder that
> no other netlink implementation need such mechanism. Maybe I'm not
> looking close enough. But if it does, should be rathe netlink helper.

I'll check some existing interfaces to see how they handle "set" type
requests.

> Regarding the example code you have here. It is prefered to store
> function result in a variable "if check" that variable. But in your,
> code, couldn't this be done without ifs?
> 
> 	bool mod = false;
> 
> 	ethnl_update_u32(&mod, &data.rx_pending, tb[ETHTOOL_A_RING_RX_PENDING]))
> 	ethnl_update_u32(&mod, &data.rx_mini_pending,
> 			 tb[ETHTOOL_A_RING_RX_MINI_PENDING]))
> 	ethnl_update_u32(&mod, &data.rx_jumbo_pending,
> 			 tb[ETHTOOL_A_RING_RX_JUMBO_PENDING]))
> 	ethnl_update_u32(&mod, &data.tx_pending, tb[ETHTOOL_A_RING_TX_PENDING]))
> 	
> 	if (!mod)
> 		return 0;

Ah, right. Somehow I completely missed the possibility that update
helper can use "set of leave as it is" logic instead of "set to true or
false". Thanks, I'll rewrite the update helpers to this style.

Michal
