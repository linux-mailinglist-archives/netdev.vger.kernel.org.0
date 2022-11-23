Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D056363E5
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238780AbiKWPhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238778AbiKWPh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:37:26 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6387C442
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669217844; x=1700753844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HSGcl78CFbVlEfVpiLWGg8rSH/fZyIDTs9COPTUcRO0=;
  b=cMSwzwR+eOmOF1lD7K20NpH8E0IJbqUIhlmaFIYVDYjTWUF9GSRm4+PV
   NILIHg2kThSea919YHh4m5GBmAMkLriS5zE87ralRX2IpOS9uEOzHoGGG
   zWWWGCAfIHZAjVHABLBmTSud3vJ0CR46FyMuyzCUERS2TS/0l/J8J7CIR
   kL+6C1ty/BTAjeRBFWN+1+jql+TEDVidvoLI2zpUb8WekRIMAVj79hKYk
   f1uwDdYiLj2xz9P+6hjevnhirnrMwoIcv2BerdBRzHaMXUU87KhWXRJC6
   siZn1dNhn1wtWfomTEZiuXAHI0ThnTz6OHbn0luKSEGzG2w/2jYbM61iR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315912593"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="315912593"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:37:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="710625622"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="710625622"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 23 Nov 2022 07:37:21 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ANFbJkY029620;
        Wed, 23 Nov 2022 15:37:20 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Nikolay Borisov <nikolay.borisov@virtuozzo.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] drop_monitor: Add namespace filtering/reporting for hardware drops
Date:   Wed, 23 Nov 2022 16:37:19 +0100
Message-Id: <20221123153719.483800-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123142817.2094993-3-nikolay.borisov@virtuozzo.com>
References: <20221123142817.2094993-1-nikolay.borisov@virtuozzo.com> <20221123142817.2094993-3-nikolay.borisov@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Borisov <nikolay.borisov@virtuozzo.com>
Date: Wed, 23 Nov 2022 16:28:16 +0200

> Add support for filtering and conveying the netnamespace where a
> particular drop event occured. This is counterpart to the software
> drop events support that was added earlier.
> 
> Signed-off-by: Nikolay Borisov <nikolay.borisov@virtuozzo.com>
> ---
>  include/uapi/linux/net_dropmon.h |  1 +
>  net/core/drop_monitor.c          | 28 ++++++++++++++++++++++++++--
>  2 files changed, 27 insertions(+), 2 deletions(-)

[...]

> @@ -452,6 +456,21 @@ static void net_dm_hw_summary_work(struct work_struct *work)
>  	kfree(hw_entries);
>  }
>  
> +static bool hw_entry_matches(struct net_dm_hw_entry *entry,
> +			     const char *trap_name, unsigned long ns_id)
> +{
> +	if (net_dm_ns && entry->ns_id == net_dm_ns &&
> +	    !strncmp(entry->trap_name, trap_name,
> +		     NET_DM_MAX_HW_TRAP_NAME_LEN - 1))
> +		return true;
> +	else if (net_dm_ns == 0 && entry->ns_id == ns_id &&
> +		 !strncmp(entry->trap_name, trap_name,
> +			  NET_DM_MAX_HW_TRAP_NAME_LEN - 1))
> +		return true;
> +	else
> +		return false;

Same as in my previous mail.

> +}
> +
>  static void
>  net_dm_hw_trap_summary_probe(void *ignore, const struct devlink *devlink,
>  			     struct sk_buff *skb,

[...]

> -- 
> 2.34.1

Thanks,
Olek
