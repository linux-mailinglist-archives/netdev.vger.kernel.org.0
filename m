Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B12E6B373F
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjCJHVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjCJHVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:21:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150D6FEF2E
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 23:21:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A81DCB821C3
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 07:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFEFC4339C;
        Fri, 10 Mar 2023 07:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678432887;
        bh=X66qBBrpDBu4IQ98INHA9aIIDXWR0rOrcz5tLvx8VKo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bcgizJgcRlUE9/7igmd3IEq5nwbI1yExaonXutGH9EEFdCcZB8ckETFFM38vGdAOT
         IlgnqZb05kXskxJLjdsA9X2nK/R4xiStHtSm7wnV2MZWtINFhj2LhZ622s8GsXgU8N
         FvomzmHTQKHvtKdtD21Mk06W76QUFvZOruch6VLUyRjPN8zof/hvVS+PA8/FCyr1/s
         IzTn7zzdcqcxoyTKzuC0mbtGWv7AUeXffz829uPEklA1QmLCpXOgN2+oxJcGJOecIG
         WrTHIaNRbEBiYNyGDHakSqtFuH0d8PI1xqn2OzCX3qzDUOXlA/xorHX9DzBpZkiacL
         bjHpvZdl84RYA==
Date:   Thu, 9 Mar 2023 23:21:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next] ethtool: add netlink support for rss set
Message-ID: <20230309232126.7067af28@kernel.org>
In-Reply-To: <20230309220544.177248-1-sudheer.mogilappagari@intel.com>
References: <20230309220544.177248-1-sudheer.mogilappagari@intel.com>
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

On Thu,  9 Mar 2023 14:05:44 -0800 Sudheer Mogilappagari wrote:
> Add netlink based support for "ethtool -X <dev>" command by
> implementing ETHTOOL_MSG_RSS_SET netlink message. This is
> equivalent to functionality provided via ETHTOOL_SRSSH in
> ioctl path. It allows creation and deletion of RSS context
> and modifying RSS table, hash key and hash function of an
> interface.
> 
> Functionality is backward compatible with the one available
> in ioctl path but enables addition of new RSS context based
> parameters in future.

RSS contexts are somewhat under-defined, so I'd prefer to wait
until we actually need to extend the API before going to netlink.
I think I told you as much when you posted initial code for RSS?

> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> index d39ce21381c5..56c4e8570dc6 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -52,6 +52,7 @@ enum {
>  	ETHTOOL_MSG_PSE_GET,
>  	ETHTOOL_MSG_PSE_SET,
>  	ETHTOOL_MSG_RSS_GET,
> +	ETHTOOL_MSG_RSS_SET,
>  	ETHTOOL_MSG_PLCA_GET_CFG,
>  	ETHTOOL_MSG_PLCA_SET_CFG,
>  	ETHTOOL_MSG_PLCA_GET_STATUS,

You certainly can't add entries half way thru an enum in uAPI..
