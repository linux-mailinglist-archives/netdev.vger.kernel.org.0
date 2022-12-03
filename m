Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41371641858
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 19:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiLCSCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 13:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiLCSCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 13:02:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844C864C3
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 10:02:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BBB160CF8
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 18:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DD7C433D6;
        Sat,  3 Dec 2022 18:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670090567;
        bh=CDsA+S29qhWKive4czKe6bvEctu32HZWBnJ7I3B8bUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h1Sd8+SoDQlbNQMqwS2KstsHxXXmIo0a9yMnjE3q+dKDFiQ/7lUGwSiAAiI+Z4w8/
         vFVvGERZPMKlYWNAqwBydp8Dxlbibh/PVVXwDd2/UCMRsuqmW2Qbx9jxmTSTGQMHqC
         /3YbBZB8AHT52f/xa/3Uyepnkv6N2NapQk8kETwS392U9nprrznoVexutP1IOH3yZ4
         Oxh7NxOcnUfWxsFYkeiAGMevGxyuqa2dQ0ck6t7RmIYD9wCAYlt7bJOD6SLqNXQdod
         vIARw0PMvEE7en5AnLhOykTtYVvTk2P3nWpaGOJ6nQxPqNC0+WyZ+r8vb9ZbNNWDt1
         2flit+aXiA8HQ==
Date:   Sat, 3 Dec 2022 11:02:45 -0700
From:   David Ahern <dsahern@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH iproute2-next] devlink: support direct region read
 requests
Message-ID: <20221203180245.GA29763@u2004-local>
References: <20221128204256.1200695-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221128204256.1200695-1-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index 8aefa101b2f8..5057b09505ef 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -8535,11 +8535,15 @@ static int cmd_region_read(struct dl *dl)
>  	int err;
>  
>  	err = dl_argv_parse(dl, DL_OPT_HANDLE_REGION | DL_OPT_REGION_ADDRESS |
> -			    DL_OPT_REGION_LENGTH | DL_OPT_REGION_SNAPSHOT_ID,
> -			    0);
> +			    DL_OPT_REGION_LENGTH,
> +			    DL_OPT_REGION_SNAPSHOT_ID);
>  	if (err)
>  		return err;
>  
> +	/* If user didn't provide a snapshot id, perform a direct read */
> +	if (!(dl->opts.present & DL_OPT_REGION_SNAPSHOT_ID))
> +		mnl_attr_put(nlh, DEVLINK_ATTR_REGION_DIRECT, 0, NULL);
> +
>  	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_REGION_READ,
>  			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
>  
> 
> base-commit: 2ed09c3bf8aca185b2f3eb369ae435503f9b9826
> -- 
> 2.38.1.420.g319605f8f00e
> 

This introduces a compile warning:

devlink.c: In function ‘dl_cmd’:
devlink.c:8613:3: warning: ‘nlh’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 8613 |   mnl_attr_put(nlh, DEVLINK_ATTR_REGION_DIRECT, 0, NULL);
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
devlink.c:8602:19: note: ‘nlh’ was declared here

and always add maintainers to iproute2 patches.

