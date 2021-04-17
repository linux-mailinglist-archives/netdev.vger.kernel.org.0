Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553A73631DF
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 20:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbhDQSr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 14:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236679AbhDQSr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 14:47:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B459260240;
        Sat, 17 Apr 2021 18:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618685249;
        bh=e3ZgvC+6EHtjPECiQdxfVCM6DMEk0hOOQjIlio9HlYM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WKN7VTvKCpyLhi0GTzTGgxaU9+F042q3nbw3SHA6XpD5HgwH4otAtlWXMhtej+i2C
         CsYLHI8B2fdpcK+xP3ulo2QlvmbnruuFaggQlmjofZU0DSTNGSjnnNqRkILKc2ZuhC
         VxIheWu6UbHmpVI1FvmVEcLhvToD4K5PyYy8Cr+i7D9UcO7jCAO5IdzYIGtKC7W7oW
         Zvckm/3yjQylF7gYF8R/2JpFTLeqfDGrAKVGHYv7ttZlUt8FJEYtlT6JduCNc9YYpE
         aAClDq6sVMCOTvPZQuduFPFlRsG9r8143Xype0e+JxYn+LxM7vNB4KAXDzMxUDzerb
         bXDgdzjBFjvFQ==
Date:   Sat, 17 Apr 2021 11:47:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, idosch@nvidia.com, mkubecek@suse.cz
Subject: Re: [RFC ethtool 6/6] netlink: add support for standard stats
Message-ID: <20210417114728.660490a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YHslkLKkb825OUEI@shredder.lan>
References: <20210416160252.2830567-1-kuba@kernel.org>
        <20210416160252.2830567-7-kuba@kernel.org>
        <YHslkLKkb825OUEI@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Apr 2021 21:14:40 +0300 Ido Schimmel wrote:
> > +	if (!is_json_context()) {
> > +		fprintf(stdout, "rmon-%s-etherStatsPkts",
> > +			mnl_attr_get_type(hist) == ETHTOOL_A_STATS_GRP_HIST_RX ?
> > +			"rx" : "tx");
> > +
> > +		if (low && hi) {
> > +			fprintf(stdout, "%uto%uOctets: %llu\n", low, hi, val);
> > +		} else if (hi) {
> > +			fprintf(stdout, "%uOctets: %llu\n", hi, val);
> > +		} else if (low) {
> > +			fprintf(stdout, "%utoMaxOctets: %llu\n", low, val);
> > +		} else {
> > +			fprintf(stderr, "invalid kernel response - bad histogram entry bounds\n");
> > +			return 1;
> > +		}
> > +	} else {
> > +		open_json_object(NULL);
> > +		print_uint(PRINT_JSON, "low", NULL, low);
> > +		print_uint(PRINT_JSON, "high", NULL, hi);
> > +		print_u64(PRINT_JSON, "val", NULL, val);  
> 
> In the non-JSON output you distinguish between Rx/Tx, but it's missing
> from the JSON output as can be seen in your example:
> 
> ```
>        "pktsNtoM": [
>          {
>            "low": 0,
>            "high": 64,
>            "val": 1
>          },
>          {
>            "low": 128,
>            "high": 255,
>            "val": 1
>          },
>          {
>            "low": 1024,
>            "high": 0,
>            "val": 0
>          }
>        ]
> ```
> 
> I see that mlxsw and mlx5 only support Rx, but it's going to be
> confusing with bnxt that supports both Rx and Tx.

Good catch! I added Tx last minute (even though it's non standard).
I'll split split into two arrays - "rx-pktsNtoM" and "tx-pktsNtoM",
sounds good? Or we can add a layer: ["pktsNtoM"]["rx"] etc.

> Made me think about the structure of these attributes. Currently you
> have:
> 
> ETHTOOL_A_STATS_GRP_HIST_RX
> 	ETHTOOL_A_STATS_GRP_HIST_BKT_LOW
> 	ETHTOOL_A_STATS_GRP_HIST_BKT_HI
> 	ETHTOOL_A_STATS_GRP_HIST_VAL
> 
> ETHTOOL_A_STATS_GRP_HIST_TX
> 	ETHTOOL_A_STATS_GRP_HIST_BKT_LOW
> 	ETHTOOL_A_STATS_GRP_HIST_BKT_HI
> 	ETHTOOL_A_STATS_GRP_HIST_VAL
> 
> Did you consider:
> 
> ETHTOOL_A_STATS_GRP_HIST
> 	ETHTOOL_A_STATS_GRP_HIST_BKT_LOW
> 	ETHTOOL_A_STATS_GRP_HIST_BKT_HI
> 	ETHTOOL_A_STATS_GRP_HIST_VAL
> 	ETHTOOL_A_STATS_GRP_HIST_BKT_UNITS
> 	ETHTOOL_A_STATS_GRP_HIST_TYPE

I went back and forth on that. The reason I put the direction in the
type is that normal statistics don't have an extra _TYPE or direction.

It will also be easier to break the stats out to arrays if they are
typed on the outside, see below.

> So you will have something like:
> 
> ETHTOOL_A_STATS_GRP_HIST_BKT_UNITS_BYTES

Histogram has two dimensions, what's the second dimension for bytes?
Time? Packet arrival?

> ETHTOOL_A_STATS_GRP_HIST_VAL_TYPE_RX_PACKETS
> ETHTOOL_A_STATS_GRP_HIST_VAL_TYPE_TX_PACKETS
> 
> And it will allow you to get rid of the special casing of the RMON stuff
> below:
> 
> ```
> 	if (id == ETHTOOL_STATS_RMON) {
> 		open_json_array("pktsNtoM", "");
> 
> 		mnl_attr_for_each_nested(attr, grp) {
> 			s = mnl_attr_get_type(attr);
> 			if (s != ETHTOOL_A_STATS_GRP_HIST_RX &&
> 			    s != ETHTOOL_A_STATS_GRP_HIST_TX)
> 				continue;
> 
> 			if (parse_rmon_hist(attr))
> 				goto err_close_rmon;
> 		}
> 		close_json_array("");
> 	}
> ```

We can drop the if, but we still need a separate for() loop
to be able to place those entries in a JSON array.

> I don't know how many histograms we are going to have as part of RFCs,
> but at least mlxsw also supports histograms of the Tx queue depth and
> latency. Not to be exposed by this interface, but shows the importance
> of encoding the units.

TBH I hope we'll never use the hist for anything else. Sadly the
bucketing of various drivers is really different (at least 6
variants). But the overarching goal is a common interface for common
port stats.
