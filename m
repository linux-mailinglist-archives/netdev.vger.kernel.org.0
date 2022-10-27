Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4846105CA
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 00:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbiJ0WeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 18:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbiJ0WeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 18:34:22 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BC7AC381
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 15:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666910062; x=1698446062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=004cpljwsR+hqzllcWQPvYgMlhqTXc0DAgxhLvleVNc=;
  b=SfkwW4N6ZO7cx+UO/iNIrSvbB1zZ9FtZVMLa6WnyTFeJa3P7qbysFGsb
   o+5cU9AW9RseViyzNeMrO2i3c9T3xUWLi2yBDtdHJDGHNaA9CZOsIY1zQ
   YeJr8iyOy8OHmRevVn7bXDAkiqYaAmf9R7Kw0/wHjtnwn3SyeijTgI6bp
   NacKd4KDVI+HRQqT3Rk5kM4foMW5w7xhE2/3/OwcquAVAaSTEbu0yjv7k
   rH+0XVz+HfisD02xLNiAL6B7bai+1M9WcMe7PbQj1UQd5PgBmgpeuc/ro
   kyaKMx+608EOwZ3q1btGQ6dOE20Kl27/ms9zzRg8nEUREchXY3uE9v2cs
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="307084306"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="307084306"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 15:34:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="807617427"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="807617427"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 27 Oct 2022 15:34:19 -0700
Received: from pkitszel-desk.tendawifi.com (arajji-mobl.ger.corp.intel.com [10.252.28.153])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 29RMYHCU016616;
        Thu, 27 Oct 2022 23:34:18 +0100
From:   Przemek Kitszel <przemyslaw.kitszel@intel.com>
To:     netdev@vger.kernel.org
Cc:     Przemek Kitszel <przemyslaw.kitszel@intel.com>,
        alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: Re: [PATCH net-next v7 4/9] devlink: Allow for devlink-rate nodes parent reassignment
Date:   Fri, 28 Oct 2022 00:34:14 +0200
Message-Id: <20221027223414.11627-1-przemyslaw.kitszel@intel.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20221027130049.2418531-5-michal.wilczynski@intel.com>
References: <20221027130049.2418531-5-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Michal Wilczynski <michal.wilczynski@intel.com>
Date:   Thu, 27 Oct 2022 15:00:44 +0200

[...]

> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 864fa0967b7a..1e0c1b0376bf 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -1875,10 +1875,9 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
>  	int err = -EOPNOTSUPP;
>  
>  	parent = devlink_rate->parent;
> -	if (parent && len) {
> -		NL_SET_ERR_MSG_MOD(info->extack, "Rate object already has parent.");
> -		return -EBUSY;
> -	} else if (parent && !len) {
> +
> +	/* if a parent is already set, just reassign the parent */
> +	if (parent && !len) {

Comment that you have added should be placed way below, here it is misleading.

>  		if (devlink_rate_is_leaf(devlink_rate))
>  			err = ops->rate_leaf_parent_set(devlink_rate, NULL,
>  							devlink_rate->priv, NULL,
> @@ -1892,7 +1891,7 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
>  
>  		refcount_dec(&parent->refcnt);
>  		devlink_rate->parent = NULL;
> -	} else if (!parent && len) {
> +	} else if (len) {
>  		parent = devlink_rate_node_get_by_name(devlink, parent_name);
>  		if (IS_ERR(parent))
>  			return -ENODEV;
> @@ -1919,6 +1918,10 @@ devlink_nl_rate_parent_node_set(struct devlink_rate *devlink_rate,
>  		if (err)
>  			return err;
>  

Comment above makes more sense here, likely combined with the one just below.

> +		if (devlink_rate->parent)
> +			/* we're reassigning to other parent in this case */
> +			refcount_dec(&devlink_rate->parent->refcnt);
> +
>  		refcount_inc(&parent->refcnt);
>  		devlink_rate->parent = parent;
>  	}
> --

Thanks for splitting this patch out of the other, change itself is easier 
to follow now. Code (modulo comments) is correct, you could add my Reviewed-by
after comment fix.

Side note: ops (rate_{leaf|node}_parent_set) lack documentation. There is also 
not much usage of them as of now, so maybe we could extend them to actually do
refcount_inc + refcount_dec (if applicable) + set pointers.
OTOH: As of now those are more of "on-event" callbacks, not "do-something", 
what is further confirmed in name (word "set" on the end, not begining).

--PK
