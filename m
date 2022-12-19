Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AED650B56
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 13:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbiLSMUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 07:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiLSMUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 07:20:30 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1682BC3;
        Mon, 19 Dec 2022 04:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671452429; x=1702988429;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FpYAPKna/QrtXHDcnodhTDjW1+/oAPh/VEk9ch82x9U=;
  b=a/LhDt/4td4Ts0rC+uSttX6UgkDOMorWvBZ0JHPWe1HjrONLqP5plcgQ
   YzhHxq7BybDfSHMs5ZuHLTZ26/Kq1lrbH4KVcLa5UaARixVnjhmskl6GC
   jKOBNvATD3SRvDuQUUJd/nZ0SgmFddEZlqtP1GWIT+0+DbUYxzKoUoo9Y
   AP+HRHxZuC5Zgs+6oqWxSPYWpWjykJ8W8OARz9rANSNiVnzqUPbWvcK6l
   UqmVPppQ97caqinK5lctzC5qpTGJMChPG/679cCsrpLo+KrdaWqU7Hb7H
   2xJySEQkcpPlE5ZFW67hbxQLpQ8JsNH+oQubiiylWV0XqYjywn0lDhfJt
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="405588710"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="405588710"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 04:20:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="739317797"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="739317797"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 04:20:26 -0800
Date:   Mon, 19 Dec 2022 13:20:16 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, UNGLinuxDriver@microchip.com,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: Re: [PATCH net v2] net: microchip: vcap: Fix initialization of value
 and mask
Message-ID: <Y6BXAE+tQ+X4eN2H@localhost.localdomain>
References: <20221219082215.76652-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219082215.76652-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 09:22:15AM +0100, Horatiu Vultur wrote:
> Fix the following smatch warning:
> 
> smatch warnings:
> drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c:103 vcap_debugfs_show_rule_keyfield() error: uninitialized symbol 'value'.
> drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c:106 vcap_debugfs_show_rule_keyfield() error: uninitialized symbol 'mask'.
> 
> In case the vcap field was VCAP_FIELD_U128 and the key was different
> than IP6_S/DIP then the value and mask were not initialized, therefore
> initialize them.
> 
> Fixes: 610c32b2ce66 ("net: microchip: vcap: Add vcap_get_rule")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Reviewed-by: Saeed Mahameed <saeed@kernel.org>
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
> v1->v2:
> - rebase on net
> - both the mask and value were assigned to data->u128.value, which is
>   wrong, fix this.
> ---
>  drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
> index 895bfff550d23..e0b206247f2eb 100644
> --- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
> +++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
> @@ -83,6 +83,8 @@ static void vcap_debugfs_show_rule_keyfield(struct vcap_control *vctrl,
>  		hex = true;
>  		break;
>  	case VCAP_FIELD_U128:
> +		value = data->u128.value;
> +		mask = data->u128.mask;
>  		if (key == VCAP_KF_L3_IP6_SIP || key == VCAP_KF_L3_IP6_DIP) {
>  			u8 nvalue[16], nmask[16];
>  
> -- 
> 2.38.0

Looks fine
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
