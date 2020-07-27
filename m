Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71E522FBBC
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgG0WAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:00:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:55874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgG0WAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:00:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D38BCAC97;
        Mon, 27 Jul 2020 22:01:03 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1BB986073D; Tue, 28 Jul 2020 00:00:53 +0200 (CEST)
Date:   Tue, 28 Jul 2020 00:00:53 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jamie Gloudon <jamie.gloudon@gmx.fr>,
        netdev@vger.kernel.org
Subject: Re: Broken link partner advertised reporting in ethtool
Message-ID: <20200727220053.gg4uozlks25vorbm@lion.mk-sys.cz>
References: <20200727154715.GA1901@gmx.fr>
 <871802ee-3b9a-87fb-4a16-db570828ef2d@intel.com>
 <20200727200912.GA1884@gmx.fr>
 <20200727204227.s2gv3hqszmpk7l7r@lion.mk-sys.cz>
 <20200727210141.GA1705504@lunn.ch>
 <20200727210843.kgcwrd6bpg65lyvj@lion.mk-sys.cz>
 <035ed67a-9da1-7023-853f-d5e62bb3f41b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <035ed67a-9da1-7023-853f-d5e62bb3f41b@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 02:27:56PM -0700, Jacob Keller wrote:
> 
> 
> On 7/27/2020 2:08 PM, Michal Kubecek wrote:
> > On Mon, Jul 27, 2020 at 11:01:41PM +0200, Andrew Lunn wrote:
> >>>   - the exact command you ran (including arguments)
> >>>   - expected output (or at least the relevant part)
> >>>   - actual output (or at least the relevant part)
> >>>   - output with dump of netlink messages, you can get it by enabling
> >>>     debugging flags, e.g. "ethtool --debug 0x12 eth0"
> >>  
> >> Hi Michal
> >>
> >> See if this helps.
> >>
> >> This is a Marvel Ethernet switch port using an Marvell PHY.
> > 
> > Thank you. I think I can see the problem. Can you try the patch below?
> > 
> > Michal
> > 
> 
> I think the patch below fixes part of the issue, but isn't completely
> correct, because NOMASK bitmaps can be sent in compact form as well.

I believe this part is correct; compact NOMASK bitmap would have no
ETHTOOL_A_BITSET_MASK and ETHTOOL_A_BITSET_BIT_VALUE would contain the
bits in it so that the code would generate correct output.

> Also, we'll need something to check the NOMASK flag and do the correct
> thing in all of the dump functions.

You are right, bitset_get_bit needs the same fix, updated version is
below.

Michal


diff --git a/netlink/bitset.c b/netlink/bitset.c
index 130bcdb5b52c..67b45778692c 100644
--- a/netlink/bitset.c
+++ b/netlink/bitset.c
@@ -50,6 +50,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
 	DECLARE_ATTR_TB_INFO(bitset_tb);
 	const struct nlattr *bits;
 	const struct nlattr *bit;
+	bool nomask;
 	int ret;
 
 	*retptr = 0;
@@ -68,6 +69,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
 		return bitmap[idx / 32] & (1U << (idx % 32));
 	}
 
+	nomask = bitset_tb[ETHTOOL_A_BITSET_NOMASK];
 	bits = bitset_tb[ETHTOOL_A_BITSET_BITS];
 	if (!bits)
 		goto err;
@@ -87,7 +89,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
 
 		my_idx = mnl_attr_get_u32(tb[ETHTOOL_A_BITSET_BIT_INDEX]);
 		if (my_idx == idx)
-			return mask || tb[ETHTOOL_A_BITSET_BIT_VALUE];
+			return mask || nomask || tb[ETHTOOL_A_BITSET_BIT_VALUE];
 	}
 
 	return false;
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
