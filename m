Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8AB22FB12
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 23:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgG0VIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 17:08:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:47344 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgG0VIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 17:08:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D3C41AD46;
        Mon, 27 Jul 2020 21:08:53 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 2B0066030D; Mon, 27 Jul 2020 23:08:43 +0200 (CEST)
Date:   Mon, 27 Jul 2020 23:08:43 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jamie Gloudon <jamie.gloudon@gmx.fr>,
        Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Subject: Re: Broken link partner advertised reporting in ethtool
Message-ID: <20200727210843.kgcwrd6bpg65lyvj@lion.mk-sys.cz>
References: <20200727154715.GA1901@gmx.fr>
 <871802ee-3b9a-87fb-4a16-db570828ef2d@intel.com>
 <20200727200912.GA1884@gmx.fr>
 <20200727204227.s2gv3hqszmpk7l7r@lion.mk-sys.cz>
 <20200727210141.GA1705504@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727210141.GA1705504@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 11:01:41PM +0200, Andrew Lunn wrote:
> >   - the exact command you ran (including arguments)
> >   - expected output (or at least the relevant part)
> >   - actual output (or at least the relevant part)
> >   - output with dump of netlink messages, you can get it by enabling
> >     debugging flags, e.g. "ethtool --debug 0x12 eth0"
>  
> Hi Michal
> 
> See if this helps.
> 
> This is a Marvel Ethernet switch port using an Marvell PHY.

Thank you. I think I can see the problem. Can you try the patch below?

Michal


diff --git a/netlink/settings.c b/netlink/settings.c
index 35ba2f5dd6d5..60523ad6edf5 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -280,6 +280,7 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
 	const struct nlattr *bit;
 	bool first = true;
 	int prev = -2;
+	bool nomask;
 	int ret;
 
 	ret = mnl_attr_parse_nested(bitset, attr_cb, &bitset_tb_info);
@@ -338,6 +339,7 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
 		goto after;
 	}
 
+	nomask = bitset_tb[ETHTOOL_A_BITSET_NOMASK];
 	printf("\t%s", before);
 	mnl_attr_for_each_nested(bit, bits) {
 		const struct nlattr *tb[ETHTOOL_A_BITSET_BIT_MAX + 1] = {};
@@ -354,7 +356,7 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
 		if (!tb[ETHTOOL_A_BITSET_BIT_INDEX] ||
 		    !tb[ETHTOOL_A_BITSET_BIT_NAME])
 			goto err;
-		if (!mask && !tb[ETHTOOL_A_BITSET_BIT_VALUE])
+		if (!mask && !nomask && !tb[ETHTOOL_A_BITSET_BIT_VALUE])
 			continue;
 
 		idx = mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_BIT_INDEX]);
