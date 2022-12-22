Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A118653A48
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 02:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiLVBWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 20:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234932AbiLVBWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 20:22:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35CA220C7
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 17:22:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71ED96199A
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 01:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3DBC433F0;
        Thu, 22 Dec 2022 01:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671672128;
        bh=pcoFL1WSDfO5okaNDJW7Kn08ZVaEAbtjxjAPMgaJJpY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D9E+NI1rhibRIs0n5ztXbNM+vGg07+eRaJaI4y6569krTfmiKS/egI4nUo/1u8629
         oTURydpJt3n7N+3VrsMvUc0Zp5hEl07u8N+orQjrB11EFwsIsYldSPnahw+sv23EZI
         lD9zbMRbqgvdE+wOgeFaVCaiKYCgRNUjwpPZtwWjm91d7phy8EWZvUTCiNiFa5DcqK
         QtHDeEk4OwsuNMqzrx4wNQRu918qrJZ6RPAs2MgRpRIZCWQiIb+zsVRUF5z1JHTa35
         8p6nCEWIieFeZOHWOKH6gg0S5HXPvpPBm/G3tgjGPDUZXCuzOuLV+8q60+fxte6Pbq
         QcVA/Vik36Luw==
Date:   Wed, 21 Dec 2022 17:22:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        corbet@lwn.net, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH ethtool-next v2 2/2] netlink: add netlink handler for
 get rss (-x)
Message-ID: <20221221172207.30127f4f@kernel.org>
In-Reply-To: <20221222001343.1220090-3-sudheer.mogilappagari@intel.com>
References: <20221222001343.1220090-1-sudheer.mogilappagari@intel.com>
        <20221222001343.1220090-3-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Dec 2022 16:13:43 -0800 Sudheer Mogilappagari wrote:
> Add support for netlink based "ethtool -x <dev>" command using
> ETHTOOL_MSG_RSS_GET netlink message. It implements same functionality
> provided by traditional ETHTOOL_GRSSH subcommand. This displays RSS
> table, hash key and hash function along with JSON support.
> 
> Sample output with json option:
> $ethtool --json -x eno2
> [ {
>     "ifname": "eno2",
>     "RSS indirection table": [ 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

"indirection-table"

>     1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2
>     ...skip similar lines...
>     7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7 ],
>     "RSS hash Key": "be:c3:13:a6:59:9a:c3:c5:d8:60:75:2b:4c:

again, better key name, and please use an array of ints:

"hash-key": [ 190, 195, 19, ...

(Or binary encoded string (if it's compliant with JSON):

"hash-key": "\xbe\xc3\x13\xa6...

but I think array is easier to deal with.)

>     b2:12:cc:5c:4e:34:8a:f9:ab:16:c7:19:5d:ab:1d:b5:c1:c7:57:
>     c7:a2:e1:2b:e3:ea:02:60:88:8e:96:ef:2d:64:d2:de:2c:16:72:b6",
>     "RSS hash function": {
>             "toeplitz": "on",
>             "xor": "off",
>             "crc32": "off"

Please use true / false.

>         }
>     } ]


> +void dump_rss_info(struct cmd_context *ctx, struct ethtool_rxfh *rss,
> +		   const struct stringset *hash_funcs)
> +{
> +	unsigned int indir_bytes = rss->indir_size * sizeof(u32);
> +	char *indir_str = NULL;
> +	char *hkey_str = NULL;
> +	unsigned int i;
> +
> +	open_json_object(NULL);
> +	print_string(PRINT_JSON, "ifname", NULL, ctx->devname);
> +
> +	if (rss->indir_size) {
> +		indir_str = calloc(1, indir_bytes * 3);
> +		if (!indir_str) {

where is this used?

> +			perror("Cannot allocate memory for RSS config");
> +			goto err;
> +		}
> +
> +		open_json_array("RSS indirection table", NULL);
> +		for (i = 0; i < rss->indir_size; i++)
> +			print_uint(PRINT_ANY, NULL, "%u", rss->rss_config[i]);
> +		close_json_array("\n");
> +	} else {
> +		print_string(PRINT_JSON, "RSS indirection table", NULL,
> +			     "not supported");

Why not skip the field? In non-JSON output I think we use "n/a" when not
supported.

> +	}

