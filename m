Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B7A48EB0B
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 14:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbiANNqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 08:46:36 -0500
Received: from mga14.intel.com ([192.55.52.115]:45267 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241428AbiANNoh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 08:44:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642167877; x=1673703877;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/Kg1DuHEKRfRXUwMOMGd1Jl+AMgJ4KEURtXNTVWk4U8=;
  b=l/FkJ0KsfPVyp3N47ar7S24Ku9YCGAeutUSyyAlIBRnbDSGu3/9onqBb
   +rXXd1uRPWdHKs0wAhY+pJZ7MI4D1XIFUuFYxiT6XTUeHp2IuW81kxACY
   2FKE51YvRUmXNoMaA85V1zSMY03OB5fbBGeOcGJh3M89r7wtegqpmLr+o
   89xm49AQpo1KmcMBGWcHFZcLpJALbCZz1hZsJEpXIwy69X7Q7pQRqkpCE
   5yPReMYRsRopDPo3Z4jBgOuwZVRmTOPB91a4zDz70gaVBjHcpPDsgoDk0
   vmFQm1+OwysrnZx0+ZoW/d5dga6mIw/i21os7Z3BUtkTNcill3B8yon4L
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="244447018"
X-IronPort-AV: E=Sophos;i="5.88,288,1635231600"; 
   d="scan'208";a="244447018"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 05:44:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,288,1635231600"; 
   d="scan'208";a="614342556"
Received: from smile.fi.intel.com ([10.237.72.61])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2022 05:44:32 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1n8Mr3-00Acul-Es;
        Fri, 14 Jan 2022 15:42:57 +0200
Date:   Fri, 14 Jan 2022 15:42:34 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v4 01/13] list: Add list_next_entry_circular()
 and list_prev_entry_circular()
Message-ID: <YeF9yq/eZBWL6eUy@smile.fi.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
 <20220114010627.21104-2-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114010627.21104-2-ricardo.martinez@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 06:06:15PM -0700, Ricardo Martinez wrote:
> Add macros to get the next or previous entries and wraparound if
> needed. For example, calling list_next_entry_circular() on the last
> element should return the first element in the list.

FWIW,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---
>  include/linux/list.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index dd6c2041d09c..c147eeb2d39d 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -563,6 +563,19 @@ static inline void list_splice_tail_init(struct list_head *list,
>  #define list_next_entry(pos, member) \
>  	list_entry((pos)->member.next, typeof(*(pos)), member)
>  
> +/**
> + * list_next_entry_circular - get the next element in list
> + * @pos:	the type * to cursor.
> + * @head:	the list head to take the element from.
> + * @member:	the name of the list_head within the struct.
> + *
> + * Wraparound if pos is the last element (return the first element).
> + * Note, that list is expected to be not empty.
> + */
> +#define list_next_entry_circular(pos, head, member) \
> +	(list_is_last(&(pos)->member, head) ? \
> +	list_first_entry(head, typeof(*(pos)), member) : list_next_entry(pos, member))
> +
>  /**
>   * list_prev_entry - get the prev element in list
>   * @pos:	the type * to cursor
> @@ -571,6 +584,19 @@ static inline void list_splice_tail_init(struct list_head *list,
>  #define list_prev_entry(pos, member) \
>  	list_entry((pos)->member.prev, typeof(*(pos)), member)
>  
> +/**
> + * list_prev_entry_circular - get the prev element in list
> + * @pos:	the type * to cursor.
> + * @head:	the list head to take the element from.
> + * @member:	the name of the list_head within the struct.
> + *
> + * Wraparound if pos is the first element (return the last element).
> + * Note, that list is expected to be not empty.
> + */
> +#define list_prev_entry_circular(pos, head, member) \
> +	(list_is_first(&(pos)->member, head) ? \
> +	list_last_entry(head, typeof(*(pos)), member) : list_prev_entry(pos, member))
> +
>  /**
>   * list_for_each	-	iterate over a list
>   * @pos:	the &struct list_head to use as a loop cursor.
> -- 
> 2.17.1
> 

-- 
With Best Regards,
Andy Shevchenko


