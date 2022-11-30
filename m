Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B5363CEB3
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbiK3F1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbiK3F1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:27:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8EF2BF1
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:27:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2FBC6154A
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D461C433C1;
        Wed, 30 Nov 2022 05:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669786057;
        bh=j5kS1lVxbDXtuTAPcjUBXY8PkirlrkUDG7leAFcVXNo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hjtQMMNIWyhNLOJ1AthGO6ANKYA0s52rWPZmFtqju2KCBOK6XHNwBTf7cHemlH85Y
         3r1vnEQiSW0jxR2UrY+emXYLHLwkwpgFvE2BJMMqfrGpqF9vMEABmAmufXcU7vbcdf
         PEJ0Nqy89I0dNHXyVHFw6dlhj9YhsyN5AM6krimNfjVHGTpYa5ujxpmYgGTd78iyZu
         zA82tAD2SZB6GonNK2uz1JFgqIVWIYkt5Oydf3NyDtUdeoMcWjEuBHcWasBWOtxrxJ
         YTNnGHkkcwx/RDEGROXjKRwyADIGH3vvxQsxQYMM3VScjba2C+cTZKDHsFPYLdqRy3
         LCQu8Z9pnuonQ==
Date:   Tue, 29 Nov 2022 21:27:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [patch net-next v2] net: devlink: convert port_list into xarray
Message-ID: <20221129212736.60d3bb4b@kernel.org>
In-Reply-To: <20221128110803.1992340-1-jiri@resnulli.us>
References: <20221128110803.1992340-1-jiri@resnulli.us>
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

On Mon, 28 Nov 2022 12:08:03 +0100 Jiri Pirko wrote:
> @@ -9903,9 +9896,9 @@ void devlink_free(struct devlink *devlink)
>  	WARN_ON(!list_empty(&devlink->sb_list));
>  	WARN_ON(!list_empty(&devlink->rate_list));
>  	WARN_ON(!list_empty(&devlink->linecard_list));
> -	WARN_ON(!list_empty(&devlink->port_list));
>  
>  	xa_destroy(&devlink->snapshot_ids);
> +	xa_destroy(&devlink->ports);

Will it warn if not empty? Should we keep the warning ?
