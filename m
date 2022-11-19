Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A356308E6
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 02:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiKSByD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 20:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234335AbiKSBxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 20:53:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB0B1153
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 17:40:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87232B825BB
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 01:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158AFC433C1;
        Sat, 19 Nov 2022 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668822013;
        bh=WFGZYEXgIi4oqkGHfsBnUX6Stn7gvirvTA803pixhdo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X1z52MWL6M+W1rh1Hln3L0oUBjOrdOO8lXyDnZ6qke4DUzQQ85m8pBBJGUc1dwHTw
         Se4ZiEZp9fREnz278eBUvGJMFFJPo3TjpKrWIJIMer69FD7qq15WtfVGQFt1vb4ZiR
         /+t/Tco/qV68oRJlX2hMdoW56WP34yixhev5zLRtleufGG8YL+QamF6JXsHd4djuSZ
         oRJ/H8WP6U6P1x4MgnjL0cMblmyFYVIHSVWdG4LrPTCyZ14i98CUaanTr7MOOcUYys
         SzZI8I8BqMEj68Lb3k/ydHioUMu/u+/5SIlUZGInuxkSvgl5F9H14fIYFmQRSLTjoK
         bbJRr1YR0Ldog==
Date:   Fri, 18 Nov 2022 17:40:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 3/8] devlink: report extended error message in
 region_read_dumpit
Message-ID: <20221118174012.5f4f5e21@kernel.org>
In-Reply-To: <20221117220803.2773887-4-jacob.e.keller@intel.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
        <20221117220803.2773887-4-jacob.e.keller@intel.com>
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

On Thu, 17 Nov 2022 14:07:58 -0800 Jacob Keller wrote:
> Report extended error details in the devlink_nl_cmd_region_read_dumpit
> function, by using the extack structure from the netlink_callback.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
>  net/core/devlink.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 932476956d7e..f2ee1da5283c 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -6453,8 +6453,14 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>  
>  	devl_lock(devlink);
>  
> -	if (!attrs[DEVLINK_ATTR_REGION_NAME] ||
> -	    !attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
> +	if (!attrs[DEVLINK_ATTR_REGION_NAME]) {
> +		NL_SET_ERR_MSG_MOD(cb->extack, "No region name provided");
> +		err = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	if (!attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {

Please use GENL_REQ_ATTR_CHECK() instead of adding strings.

> +		NL_SET_ERR_MSG_MOD(cb->extack, "No snapshot id provided");
>  		err = -EINVAL;
>  		goto out_unlock;
>  	}
> @@ -6477,6 +6483,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>  		region = devlink_region_get_by_name(devlink, region_name);
>  
>  	if (!region) {
> +		NL_SET_ERR_MSG_MOD(cb->extack,
> +				   "The requested region does not exist");

NL_SET_ERR_MSG_ATTR()

>  		err = -EINVAL;
>  		goto out_unlock;
>  	}
> @@ -6484,6 +6492,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
>  	snapshot_id = nla_get_u32(attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
>  	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
>  	if (!snapshot) {
> +		NL_SET_ERR_MSG_MOD(cb->extack,
> +				   "The requested snapshot id does not exist");

ditto

>  		err = -EINVAL;
>  		goto out_unlock;
>  	}

