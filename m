Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9A165B864
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 01:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbjACAdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 19:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjACAda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 19:33:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D316378
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 16:33:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ACE661123
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 00:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854BFC433D2;
        Tue,  3 Jan 2023 00:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672706007;
        bh=gKNB+eHYFrlHuh6xprr6dFu7Pzzx/u81rK7YToU/RpU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E3FpuJBI9IDpw/T7kfGD33WUhatSsdyMF6IgShBtXz3BIfS9KeCqdfL9AuElTw+wh
         aSs8SgJLeQkGxKbFt7XSVMjBu+pXronPRR7TKc0lQDUWjYbU4bUYy8H7up+4MTJAn1
         O+gSwPrchWfKDCfKoFXuGVBnt2AWPgrAk3dVLky4CJug+aXL3xkCIHgZ4e0nToVOQH
         7oUqFpbpn6dyZwqrILwBGKiYJd2+zH9U29NB2q16UIC2OYRv14rcmgARiFHqUf1kFI
         rvJxPblDWRSvG3P/3Rk5qxn9sYxaAlPUlzZ2Z/pdRue2Gql5gbV4mVfcVe8xr4VuJp
         6ne4t8KaMRfeg==
Date:   Mon, 2 Jan 2023 16:33:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH ethtool-next v4 2/2] netlink: add netlink handler for
 get rss (-x)
Message-ID: <20230102163326.4b982650@kernel.org>
In-Reply-To: <20221229011243.1527945-3-sudheer.mogilappagari@intel.com>
References: <20221229011243.1527945-1-sudheer.mogilappagari@intel.com>
        <20221229011243.1527945-3-sudheer.mogilappagari@intel.com>
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

On Wed, 28 Dec 2022 17:12:43 -0800 Sudheer Mogilappagari wrote:
> Add support for netlink based "ethtool -x <dev>" command using
> ETHTOOL_MSG_RSS_GET netlink message. It implements same functionality
> provided by traditional ETHTOOL_GRSSH subcommand. This displays RSS
> table, hash key and hash function along with JSON support.

> +void dump_json_rss_info(struct cmd_context *ctx, struct ethtool_rxfh *rss,
> +			const struct stringset *hash_funcs)
> +{
> +	unsigned int indir_bytes = rss->indir_size * sizeof(rss->rss_config[0]);
> +	unsigned int i;
> +
> +	open_json_object(NULL);
> +	print_string(PRINT_JSON, "ifname", NULL, ctx->devname);
> +	if (rss->indir_size) {
> +		open_json_array("rss-indirection-table", NULL);
> +		for (i = 0; i < rss->indir_size; i++)
> +			print_uint(PRINT_JSON, NULL, NULL, rss->rss_config[i]);
> +		close_json_array("\n");
> +	}
> +
> +	if (rss->key_size) {
> +		const char *hkey = ((char *)rss->rss_config + indir_bytes);
> +
> +		open_json_array("rss-hash-key", NULL);
> +		for (i = 0; i < rss->key_size; i++)
> +			print_uint(PRINT_JSON, NULL, NULL, (u8)hkey[i]);
> +		close_json_array("\n");
> +	}
> +
> +	if (rss->hfunc) {
> +		open_json_object("rss-hash-function");
> +		for (i = 0; i < get_count(hash_funcs); i++)
> +			print_bool(PRINT_JSON, get_string(hash_funcs, i), NULL,
> +				   (rss->hfunc & (1 << i)));
> +		close_json_object();
> +	}

I believe there can only be a single bit set here, so why not print:

	 "rss-hash-function": "toeplitz"

rather than:

	  "rss-hash-function": {
            "toeplitz": true,
            "xor": false,
            "crc32": false
          }

We can make the kernel ensure only one bit is set by checking 
hweight() == 1 on the value returned by the driver.

> +	close_json_object();
> +}
> +
> +int rss_reply_cb(const struct nlmsghdr *nlhdr, void *data)
> +{
> +	const struct nlattr *tb[ETHTOOL_A_RSS_MAX + 1] = {};
> +	unsigned int indir_bytes = 0, hkey_bytes = 0;
> +	DECLARE_ATTR_TB_INFO(tb);
> +	struct cb_args *args = data;
> +	struct nl_context *nlctx =  args->nlctx;

double space

> +	const struct stringset *hash_funcs;
> +	u32 rss_config_size, rss_hfunc;
> +	const char *indir_table, *hkey;
> +
> +	struct ethtool_rxfh *rss;
> +	bool silent;
> +	int err_ret;
> +	int ret;
> +
> +	silent = nlctx->is_dump || nlctx->is_monitor;
> +	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
> +	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
> +	if (ret < 0)
> +		return err_ret;
> +	nlctx->devname = get_dev_name(tb[ETHTOOL_A_RSS_HEADER]);
> +	if (!dev_ok(nlctx))
> +		return err_ret;
> +
> +	if (silent)
> +		putchar('\n');

show_cr()

> +	rss_hfunc = mnl_attr_get_u32(tb[ETHTOOL_A_RSS_HFUNC]);
> +
> +	indir_bytes = mnl_attr_get_payload_len(tb[ETHTOOL_A_RSS_INDIR]);
> +	indir_table = mnl_attr_get_str(tb[ETHTOOL_A_RSS_INDIR]);
> +
> +	hkey_bytes = mnl_attr_get_payload_len(tb[ETHTOOL_A_RSS_HKEY]);
> +	hkey = mnl_attr_get_str(tb[ETHTOOL_A_RSS_HKEY]);

All elements of tb can be NULL, AFAIU.

> +	rss_config_size = indir_bytes + hkey_bytes;
> +
> +	rss = calloc(1, sizeof(*rss) + rss_config_size);
> +	if (!rss) {
> +		perror("Cannot allocate memory for RX flow hash config");
> +		return 1;
> +	}
> +
> +	rss->indir_size = indir_bytes / sizeof(rss->rss_config[0]);
> +	rss->key_size = hkey_bytes;
> +	rss->hfunc = rss_hfunc;
> +
> +	memcpy(rss->rss_config, indir_table, indir_bytes);
> +	memcpy(rss->rss_config + rss->indir_size, hkey, hkey_bytes);

Do you only perform this coalescing to reuse the existing print
helpers? With a bit of extra refactoring this seems avoidable...

> +	/* Fetch RSS hash functions and their status and print */
> +
> +	if (!nlctx->is_monitor) {
> +		ret = netlink_init_ethnl2_socket(nlctx);
> +		if (ret < 0)
> +			return MNL_CB_ERROR;
> +	}
> +	hash_funcs = global_stringset(ETH_SS_RSS_HASH_FUNCS,
> +				      nlctx->ethnl2_socket);
> +
> +	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
> +	if (ret < 0)
> +		return silent ? MNL_CB_OK : MNL_CB_ERROR;
> +	nlctx->devname = get_dev_name(tb[ETHTOOL_A_RSS_HEADER]);
> +	if (!dev_ok(nlctx))
> +		return MNL_CB_OK;
> +
> +	if (is_json_context()) {
> +		dump_json_rss_info(nlctx->ctx, rss, hash_funcs);
> +	} else {
> +		print_rss_info(nlctx->ctx, args->num_rings, rss);
> +		printf("RSS hash function:\n");
> +		if (!rss_hfunc) {
> +			printf("    Operation not supported\n");
> +			return 0;
> +		}
> +		for (unsigned int i = 0; i < get_count(hash_funcs); i++) {
> +			printf("    %s: %s\n", get_string(hash_funcs, i),
> +			       (rss_hfunc & (1 << i)) ? "on" : "off");
> +		}
> +	}
> +
> +	free(rss);
> +	return MNL_CB_OK;
> +}

> +int get_channels_cb(const struct nlmsghdr *nlhdr, void *data)
> +{
> +	const struct nlattr *tb[ETHTOOL_A_CHANNELS_MAX + 1] = {};
> +	DECLARE_ATTR_TB_INFO(tb);
> +	struct cb_args *args = data;
> +	struct nl_context *nlctx =  args->nlctx;
> +	bool silent;
> +	int err_ret;
> +	int ret;
> +
> +	silent = nlctx->is_dump || nlctx->is_monitor;
> +	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
> +	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
> +	if (ret < 0)
> +		return err_ret;
> +	nlctx->devname = get_dev_name(tb[ETHTOOL_A_CHANNELS_HEADER]);

We need to check that the kernel has filled in the attrs before accessing them, no?

> +	if (!dev_ok(nlctx))
> +		return err_ret;
> +
> +	args->num_rings = mnl_attr_get_u8(tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT]);

u32, not u8

The correct value is combined + rx, I think I mentioned this before.

> +	return MNL_CB_OK;

I'm also not sure if fetching the channel info shouldn't be done over
the nl2 socket, like the string set. If we are in monitor mode we may
confuse ourselves trying to parse the wrong messages.
