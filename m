Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D029E63E943
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 06:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiLAFSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 00:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiLAFSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 00:18:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D63578E2
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 21:18:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F08BB81DA5
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 05:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17645C433C1;
        Thu,  1 Dec 2022 05:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669871881;
        bh=9ozpd8nYFysugKfgBPxD+MKlyYn9QbBTzWIdlCRuNzA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vAIzMlyrl/HGnUNfTmbORyFJFvy03r8z34VyWXHABsoPnlc2Q032KVBiLeTUOlV6A
         JF6lrl/i17eVd2fUi0SgGw31x0wkjVrGhWMXBPaO2iGgiWGAteuCOfxGThhOr3QwpX
         Y2qRwMhyISnSbm7z2XucFA89U2mx4Z5iGHz2YENwiWrwAE4Nyy82H6n7LuGSwtrKv1
         V8JLymz1HhCBkirPsApMzpRfbkDYkJ9h3P1Zz2si/EnJdI2EF9tigmD9KEornYi7K9
         weQobAFg4YCYXEXpqzNYQlzQ1v8EnvCMBZmXfvK6zKn9E2eNcFIF1q4bY0wLz7NZiy
         gLjcEUcVIK9gw==
Date:   Wed, 30 Nov 2022 21:18:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        corbet@lwn.net, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v6] ethtool: add netlink based get rss support
Message-ID: <20221130211800.372f9a9b@kernel.org>
In-Reply-To: <20221128175556.49354-1-sudheer.mogilappagari@intel.com>
References: <20221128175556.49354-1-sudheer.mogilappagari@intel.com>
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

On Mon, 28 Nov 2022 09:55:56 -0800 Sudheer Mogilappagari wrote:
> Add netlink based support for "ethtool -x <dev> [context x]"
> command by implementing ETHTOOL_MSG_RSS_GET netlink message.
> This is equivalent to functionality provided via ETHTOOL_GRSSH
> in ioctl path. It sends RSS table, hash key and hash function
> of an interface to user space.
> 
> This patch implements existing functionality available
> in ioctl path and enables addition of new RSS context
> based parameters in future.

Please try make htmldocs, the tables below are mis-formatted.

> +=====================================  ======  ==========================
> +  ``ETHTOOL_A_RSS_HEADER``             nested  request header
> +  ``ETHTOOL_A_RSS_CONTEXT``            u32     context number
> + ====================================  ======  ==========================
> +
> +Kernel response contents:
> +
> +=====================================  ======  ==========================
> +  ``ETHTOOL_A_RSS_HEADER``             nested  reply header
> +  ``ETHTOOL_A_RSS_HFUNC``              u32     RSS hash func
> +  ``ETHTOOL_A_RSS_INDIR``              binary  Indir table bytes
> +  ``ETHTOOL_A_RSS_HKEY``               binary  Hash key bytes
> + ====================================  ======  ==========================

> +static int
> +rss_reply_size(const struct ethnl_req_info *req_base,
> +	       const struct ethnl_reply_data *reply_base)
> +{
> +	const struct rss_reply_data *data = RSS_REPDATA(reply_base);
> +	int len;
> +
> +	len =  nla_total_size(sizeof(u32)) +	/* _RSS_HFUNC */
> +	       nla_total_size(sizeof(u32) * data->indir_size) + /* _RSS_INDIR */
> +	       nla_total_size(data->hkey_size);	/* _RSS_HKEY */

nit: double space after =
