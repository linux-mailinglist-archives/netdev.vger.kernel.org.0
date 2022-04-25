Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A4050ECE2
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238275AbiDYX4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235888AbiDYX4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:56:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4145C42A0C
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 16:53:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02633B80CE0
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 23:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A47EC385A7;
        Mon, 25 Apr 2022 23:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650930802;
        bh=rtv0aNjantozQbyemS8v+srbXfOx8D9Z/bk9HJWiwXk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ILyLfG9f/1MBSYdZtoOMgA1OupedreOMrTo3KbMu8PUUao0tXSO1ZO740bj5+CXXk
         qKZ07VodjsLFl28L/mdLGyX1hMEspqhy2/vjWi72YZ8mWs2IGDTsTWkaCQTZjaOW/v
         qjNLeW5Z7iql4QlcCRdB2hZWJJbp7wFLQELdu6cAMdxPRxjgj53PUHNLbzApDj8OzQ
         122etkkCSWLPMO6xrRC4pO8csiL+I0nEkg/ygXLZjPiZ3O43z4J2iWu0FSAfvGCJCV
         GP+KraeMGx5GeAwjlMG+1BlX1M492UkQiai/0IUjjZAUTAdcMQcszG6GvXLm6uJOLC
         eIG4PybM6xgyw==
Date:   Mon, 25 Apr 2022 16:53:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Bin Chen <bin.chen@corigine.com>
Subject: Re: [PATCH net-next] nfp: VF rate limit support
Message-ID: <20220425165321.1856ebb7@kernel.org>
In-Reply-To: <20220422131945.948311-1-simon.horman@corigine.com>
References: <20220422131945.948311-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Apr 2022 15:19:45 +0200 Simon Horman wrote:
> +	if (max_tx_rate > 0 || min_tx_rate > 0) {
> +		if (max_tx_rate > 0 && max_tx_rate < min_tx_rate) {
> +			nfp_warn(app->cpp, "min-tx-rate exceeds max_tx_rate.\n");
> +			return -EINVAL;
> +		}

This check should be moved to the core, I reckon.

> +		if (max_tx_rate > NFP_NET_VF_RATE_MAX || min_tx_rate > NFP_NET_VF_RATE_MAX) {

Please wrap the lines at 80 chars, it's actually going to be easier 
to read here.

> +			nfp_warn(app->cpp, "tx-rate exceeds 0x%x.\n", NFP_NET_VF_RATE_MAX);

Does it really make sense to print the rate as hex?

> +			return -EINVAL;
> +		}

> @@ -261,5 +294,18 @@ int nfp_app_get_vf_config(struct net_device *netdev, int vf,
>  	ivi->trusted = FIELD_GET(NFP_NET_VF_CFG_CTRL_TRUST, flags);
>  	ivi->linkstate = FIELD_GET(NFP_NET_VF_CFG_CTRL_LINK_STATE, flags);
>  
> +	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_RATE, "rate");
> +	if (!err) {
> +		rate = readl(app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_RATE);
> +
> +		ivi->max_tx_rate = FIELD_GET(NFP_NET_VF_CFG_MAX_RATE, rate);
> +		ivi->min_tx_rate = FIELD_GET(NFP_NET_VF_CFG_MIN_RATE, rate);
> +
> +		if (ivi->max_tx_rate == NFP_NET_VF_RATE_MAX)
> +			ivi->max_tx_rate = 0;

If rate == NFP_NET_VF_RATE_MAX means unset then the check on set should
disallow it, IOW:

	if (max_tx_rate >= NFP_NET_VF_RATE_MAX || 
            min_tx_rate >= NFP_NET_VF_RATE_MAX) {
		nfp_war(...

no?

> +		if (ivi->min_tx_rate == NFP_NET_VF_RATE_MAX)
> +			ivi->max_tx_rate = 0;

*squint* you check min and clear max, is this intentional?
