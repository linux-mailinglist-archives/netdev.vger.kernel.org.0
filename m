Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4932EB2D0
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 19:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbhAESu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 13:50:58 -0500
Received: from mga04.intel.com ([192.55.52.120]:7425 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbhAESu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 13:50:58 -0500
IronPort-SDR: iWOgC0YKorD/bMWB3dqFEhLA8P8OPtgdo1xcrxrnN0pfscifcYe676rtcRpZBvYdZyQ8Zrlqsn
 HnGDlwlfoQyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="174585326"
X-IronPort-AV: E=Sophos;i="5.78,477,1599548400"; 
   d="scan'208";a="174585326"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 10:50:17 -0800
IronPort-SDR: 0ls99+HrFYsO+uiljWCXtB4FrbW7vqTisp4XqMOW8zUjrK4pcwKZJKxSvhpBluto1nrk1Eo0mM
 zVQsY8UIYgBA==
X-IronPort-AV: E=Sophos;i="5.78,477,1599548400"; 
   d="scan'208";a="349961503"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.7.147]) ([10.212.7.147])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 10:50:17 -0800
Subject: Re: [PATCH net-next] devlink: use _BITUL() macro instead of BIT() in
 the UAPI header
To:     Tobias Klauser <tklauser@distanz.ch>, Jiri Pirko <jiri@nvidia.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20201215102531.16958-1-tklauser@distanz.ch>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <8ac29d40-f954-e481-f877-493a8c055aba@intel.com>
Date:   Tue, 5 Jan 2021 10:50:14 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201215102531.16958-1-tklauser@distanz.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/2020 2:25 AM, Tobias Klauser wrote:
> The BIT() macro is not available for the UAPI headers. Moreover, it can
> be defined differently in user space headers. Thus, replace its usage
> with the _BITUL() macro which is already used in other macro definitions
> in <linux/devlink.h>.
> 
> Fixes: dc64cc7c6310 ("devlink: Add devlink reload limit option")
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Yep, this is correct, and we ran into this exact issue a few months ago
with the flash update parameters work. Wonder how difficult it would be
to get something like checkpatch.pl or another utility to complain about
using BIT() macros in UAPI..?

Unfortunately this is easy to overlook because the kernel side code
almost always has BIT defined, so you won't get a compilation failure
until you try to use the uapi header in a userspace program.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  include/uapi/linux/devlink.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index 5203f54a2be1..cf89c318f2ac 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -322,7 +322,7 @@ enum devlink_reload_limit {
>  	DEVLINK_RELOAD_LIMIT_MAX = __DEVLINK_RELOAD_LIMIT_MAX - 1
>  };
>  
> -#define DEVLINK_RELOAD_LIMITS_VALID_MASK (BIT(__DEVLINK_RELOAD_LIMIT_MAX) - 1)
> +#define DEVLINK_RELOAD_LIMITS_VALID_MASK (_BITUL(__DEVLINK_RELOAD_LIMIT_MAX) - 1)
>  
>  enum devlink_attr {
>  	/* don't change the order or add anything between, this is ABI! */
> 
