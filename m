Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8AE3574BC
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 21:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355530AbhDGTCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 15:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348646AbhDGTCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 15:02:14 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E846FC061761
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 12:02:02 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso1808193pji.3
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 12:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8q0QHq9l4LF9PHx0etSU7nJSKEAb9gzaAE8xuzl5E8k=;
        b=Vg46FhLEi9cn5jYSsZNA7SRRcJq634l6s+jrMmkoqB8xEbtmmZ3wO0+i1v/Jo9fjn3
         oG4viB354PfuNOXJ8vqJe/WHaqlQzkM0LicWuKOMjK4f91/1AhJt4dYFNN/BS0308Fod
         5wfSG+iCSyUKclk/Z05Y4mSX2SkUtUPcPReto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8q0QHq9l4LF9PHx0etSU7nJSKEAb9gzaAE8xuzl5E8k=;
        b=ciRbL9ePujURQLDJH6hS3SSiUdqGkcr+QrWDXzTWwNErHHPIy2xZLf4dMI7pIQTanJ
         5Z8hjbTenzxI4AHaB94BzLn3utWBwLtjFNh0aaII6H496GkeTTInZjlxQeLbyKsk2FSs
         iXPzKg4nTxi0uV2IX6biAtfW8HP4Et3ee6qaeSBpjVD+/XZqYGORRrSY6KtjOps3eQjK
         Ld5RftwskU6d4IYqcq8rcqnyiNWmVwS+IxeTDDOQMDbYKmWYBVDKDA4jnHhnlIS5xi4Z
         WKlBWAY+5THncDU38/Mx9zDKDT12qUtlwSa/fRmgUIDmyWBY0gPO6/D0O9jIX3EABKoL
         bDZw==
X-Gm-Message-State: AOAM532yXAHeDEjx8jYZ/B3604zErFqXsRF/2DqlzgIeZgVhN1NkUqb1
        0NUglomZTzJ/tR4LSB3O99tUn/R9almUmw==
X-Google-Smtp-Source: ABdhPJz4ys47YHIOPJKyCBVOUB1raDUBV8qm1x+U7bt/dMyiob+58CCl5Yya5TA7z1nvNhyYeF4uKg==
X-Received: by 2002:a17:902:c411:b029:e9:3d37:afc with SMTP id k17-20020a170902c411b02900e93d370afcmr4402507plk.17.1617822122466;
        Wed, 07 Apr 2021 12:02:02 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t8sm5840623pjj.0.2021.04.07.12.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 12:02:01 -0700 (PDT)
Date:   Wed, 7 Apr 2021 12:02:00 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 2/2][next] wl3501_cs: Fix out-of-bounds warning in
 wl3501_mgmt_join
Message-ID: <202104071158.B4FA1956@keescook>
References: <cover.1617226663.git.gustavoars@kernel.org>
 <83b0388403a61c01fad8d638db40b4245666ff53.1617226664.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83b0388403a61c01fad8d638db40b4245666ff53.1617226664.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 04:45:34PM -0500, Gustavo A. R. Silva wrote:
> Fix the following out-of-bounds warning by enclosing
> some structure members into new struct req:
> 
> arch/x86/include/asm/string_32.h:182:25: warning: '__builtin_memcpy' offset [39, 108] from the object at 'sig' is out of the bounds of referenced subobject 'beacon_period' with type 'short unsigned int' at offset 36 [-Warray-bounds]
> 
> Refactor the code, accordingly:
> 
> $ pahole -C wl3501_join_req drivers/net/wireless/wl3501_cs.o
> struct wl3501_join_req {
> 	u16                        next_blk;             /*     0     2 */
> 	u8                         sig_id;               /*     2     1 */
> 	u8                         reserved;             /*     3     1 */
> 	struct iw_mgmt_data_rset   operational_rset;     /*     4    10 */
> 	u16                        reserved2;            /*    14     2 */
> 	u16                        timeout;              /*    16     2 */
> 	u16                        probe_delay;          /*    18     2 */
> 	u8                         timestamp[8];         /*    20     8 */
> 	u8                         local_time[8];        /*    28     8 */
> 	struct {
> 		u16                beacon_period;        /*    36     2 */
> 		u16                dtim_period;          /*    38     2 */
> 		u16                cap_info;             /*    40     2 */
> 		u8                 bss_type;             /*    42     1 */
> 		u8                 bssid[6];             /*    43     6 */
> 		struct iw_mgmt_essid_pset ssid;          /*    49    34 */
> 		/* --- cacheline 1 boundary (64 bytes) was 19 bytes ago --- */
> 		struct iw_mgmt_ds_pset ds_pset;          /*    83     3 */
> 		struct iw_mgmt_cf_pset cf_pset;          /*    86     8 */
> 		struct iw_mgmt_ibss_pset ibss_pset;      /*    94     4 */
> 		struct iw_mgmt_data_rset bss_basic_rset; /*    98    10 */
> 	} req;                                           /*    36    72 */

This section is the same as a large portion of struct wl3501_scan_confirm:

struct wl3501_scan_confirm {
        u16                         next_blk;
        u8                          sig_id;
        u8                          reserved;
        u16                         status;
        char                        timestamp[8];
        char                        localtime[8];

from here
        u16                         beacon_period;
        u16                         dtim_period;
        u16                         cap_info;
        u8                          bss_type;
        u8                          bssid[ETH_ALEN];
        struct iw_mgmt_essid_pset   ssid;
        struct iw_mgmt_ds_pset      ds_pset;
        struct iw_mgmt_cf_pset      cf_pset;
        struct iw_mgmt_ibss_pset    ibss_pset;
        struct iw_mgmt_data_rset    bss_basic_rset;
through here

        u8                          rssi;
};

It seems like maybe extracting that and using it in both structures
would make more sense?

> 
> 	/* size: 108, cachelines: 2, members: 10 */
> 	/* last cacheline: 44 bytes */
> };
> 
> The problem is that the original code is trying to copy data into a
> bunch of struct members adjacent to each other in a single call to
> memcpy(). Now that a new struct _req_ enclosing all those adjacent
> members is introduced, memcpy() doesn't overrun the length of
> &sig.beacon_period, because the address of the new struct object
> _req_ is used as the destination, instead.
> 
> Also, this helps with the ongoing efforts to enable -Warray-bounds and
> avoid confusing the compiler.
> 
> Link: https://github.com/KSPP/linux/issues/109
> Reported-by: kernel test robot <lkp@intel.com>
> Build-tested-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/lkml/60641d9b.2eNLedOGSdcSoAV2%25lkp@intel.com/
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> Changes in v2:
>  - None.
> 
>  drivers/net/wireless/wl3501.h    | 22 ++++++++++++----------
>  drivers/net/wireless/wl3501_cs.c |  4 ++--
>  2 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl3501.h b/drivers/net/wireless/wl3501.h
> index ef9d605d8c88..774d8cac046d 100644
> --- a/drivers/net/wireless/wl3501.h
> +++ b/drivers/net/wireless/wl3501.h
> @@ -389,16 +389,18 @@ struct wl3501_join_req {
>  	u16			    probe_delay;
>  	u8			    timestamp[8];
>  	u8			    local_time[8];
> -	u16			    beacon_period;
> -	u16			    dtim_period;
> -	u16			    cap_info;
> -	u8			    bss_type;
> -	u8			    bssid[ETH_ALEN];
> -	struct iw_mgmt_essid_pset   ssid;
> -	struct iw_mgmt_ds_pset	    ds_pset;
> -	struct iw_mgmt_cf_pset	    cf_pset;
> -	struct iw_mgmt_ibss_pset    ibss_pset;
> -	struct iw_mgmt_data_rset    bss_basic_rset;
> +	struct {
> +		u16			    beacon_period;
> +		u16			    dtim_period;
> +		u16			    cap_info;
> +		u8			    bss_type;
> +		u8			    bssid[ETH_ALEN];
> +		struct iw_mgmt_essid_pset   ssid;
> +		struct iw_mgmt_ds_pset	    ds_pset;
> +		struct iw_mgmt_cf_pset	    cf_pset;
> +		struct iw_mgmt_ibss_pset    ibss_pset;
> +		struct iw_mgmt_data_rset    bss_basic_rset;
> +	} req;
>  };
>  
>  struct wl3501_join_confirm {
> diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
> index e149ef81d6cc..399d3bd2ae76 100644
> --- a/drivers/net/wireless/wl3501_cs.c
> +++ b/drivers/net/wireless/wl3501_cs.c
> @@ -590,7 +590,7 @@ static int wl3501_mgmt_join(struct wl3501_card *this, u16 stas)
>  	struct wl3501_join_req sig = {
>  		.sig_id		  = WL3501_SIG_JOIN_REQ,
>  		.timeout	  = 10,
> -		.ds_pset = {
> +		.req.ds_pset = {
>  			.el = {
>  				.id  = IW_MGMT_INFO_ELEMENT_DS_PARAMETER_SET,
>  				.len = 1,
> @@ -599,7 +599,7 @@ static int wl3501_mgmt_join(struct wl3501_card *this, u16 stas)
>  		},
>  	};
>  
> -	memcpy(&sig.beacon_period, &this->bss_set[stas].beacon_period, 72);
> +	memcpy(&sig.req, &this->bss_set[stas].beacon_period, sizeof(sig.req));

If not, then probably something like this should be added to make sure
nothing unexpected happens to change structure sizes:

BUILD_BUG_ON(sizeof(sig.req) != 72);

>  	return wl3501_esbq_exec(this, &sig, sizeof(sig));
>  }
>  
> -- 
> 2.27.0
> 

-- 
Kees Cook
