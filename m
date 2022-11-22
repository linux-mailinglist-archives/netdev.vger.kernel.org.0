Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85511633468
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiKVE07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiKVE0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:26:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150AD1DA6E
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:26:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A451B60A51
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1827C433C1;
        Tue, 22 Nov 2022 04:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669091214;
        bh=QKcKPSey20rJDtHWLK91nzYUkA4spG90LyNDx7erTm8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W9OKTpd3X/LGAwgo3KJKW1HgJvOmsKr5ijm17FK/39LH32Lyn42VYyz4k6zAdI5iU
         lLavvPuzrtE9kM2kOeoqz3RFY13ZQXHpHEWofgjFsj0BxZ2zItynMtYelfFcMIakix
         ssa54wOz+ERy/SfdwYWXRXmviG3W75ZO0pgSgYa7wTRucWm8VrYqxMru/twN/Q0m3m
         +AKzkR4dbXR1GWlxhoUi9PrIz1YJ1AS/cfkGs4NtWpRZbCjg+0CIH/Gskjyse4mSPN
         CRdzTgyH8GQ+0XwU7lV51vlcd54SAEhd2WiYI8pPojpF7k1nkjhC41Ysa1xzfuB4I+
         VI9P1MPMVCGrg==
Date:   Mon, 21 Nov 2022 20:26:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next] nfp: ethtool: support reporting link modes
Message-ID: <20221121202652.57f0b901@kernel.org>
In-Reply-To: <20221121112045.862295-1-simon.horman@corigine.com>
References: <20221121112045.862295-1-simon.horman@corigine.com>
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

On Mon, 21 Nov 2022 12:20:45 +0100 Simon Horman wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> Add support for reporting link modes,
> including `Supported link modes` and `Advertised link modes`,
> via ethtool $DEV.
> 
> A new command `SPCODE_READ_MEDIA` is added to read info from
> management firmware. Also, the mapping table `nfp_eth_media_table`
> associates the link modes between NFP and kernel. Both of them
> help to support this ability.

> +static void nfp_add_media_link_mode(struct nfp_port *port,
> +				    struct nfp_eth_table_port *eth_port,
> +				    struct ethtool_link_ksettings *cmd)
> +{
> +	struct nfp_eth_media_buf ethm = {.eth_index = eth_port->eth_index};

nit: spaces, comma at the end

> +	struct nfp_cpp *cpp = port->app->cpp;
> +	u8 i;

nit: int or uint, don't pointlessly limit the size of iterators

> +struct nfp_eth_media_buf {
> +	u8 eth_index;
> +	u8 reserved[7];
> +	DECLARE_BITMAP(supported_modes, NFP_NSP_MAX_MODE_SIZE);
> +	DECLARE_BITMAP(advertised_modes, NFP_NSP_MAX_MODE_SIZE);

You can't use DECLATE_BITMAP() in FW APIs. unsigned long will have
different layout depending on word side and endian.

> +int nfp_eth_read_media(struct nfp_cpp *cpp, struct nfp_eth_media_buf *ethm)
> +{
> +	struct nfp_nsp *nsp;
> +	int err;

nit: you use your ret for variables which are returned both 
     on the success and failure paths.

