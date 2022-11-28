Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660A263AB50
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiK1Ol5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbiK1Ola (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:41:30 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1369E1D315;
        Mon, 28 Nov 2022 06:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669646490; x=1701182490;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MSh9uVp2zwjD3iNzMDF4CLgvmRLyaxXitI4MRNVQLcs=;
  b=cQAIenddmwOgdR9zR3Fg4R5Xoc7sfxmFsFFhja+JoqO/3EpUkJbeLns4
   3bb09KjihnWx5oHAHcpGJV9aeem2yvmbFJMbFfwDbN7Cw7Wa+zn6Dt4Uf
   eoxzwK6eZIryPueprC0vqHoYHjPJBSrJGDZxJawvlTIHVp5PeKFGY58FR
   E393OmLTluOLVlpd1EilQ5CNDIPx7suuqfPhJLH0S3ngDAKXO9lR+L7/5
   mEqKF+f++c75+YAqYlH+tcikghD/Cc03RJAKN91N2P+oDnB6emFccpxIe
   SzOKMCH8R6G5wyKMy0CfAvtN/akP78MaraUAVt8AiFZ9OfnMiMnwz1jZL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="376988503"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="376988503"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 06:41:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="749411853"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="749411853"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 28 Nov 2022 06:41:26 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2ASEfPu2018253;
        Mon, 28 Nov 2022 14:41:25 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, UNGLinuxDriver@microchip.com,
        casper.casan@gmail.com
Subject: Re: [PATCH net-next] net: microchip: vcap: Change how the rule id is generated
Date:   Mon, 28 Nov 2022 15:40:42 +0100
Message-Id: <20221128144042.2097491-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221128142959.8325-1-horatiu.vultur@microchip.com>
References: <20221128142959.8325-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Mon, 28 Nov 2022 15:29:59 +0100

> Currently whenever a new rule id is generated, it picks up the next
> number bigger than previous id. So it would always be 1, 2, 3, etc.
> When the rule with id 1 will be deleted and a new rule will be added,
> it will have the id 4 and not id 1.
> In theory this can be a problem if at some point a rule will be added
> and removed ~0 times. Then no more rules can be added because there
> are no more ids.
> 
> Change this such that when a new rule is added, search for an empty
> rule id starting with value of 1 as value 0 is reserved.
> 
> Fixes: c9da1ac1c212 ("net: microchip: sparx5: Adding initial tc flower support for VCAP API")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/ethernet/microchip/vcap/vcap_api.c | 7 +------
>  drivers/net/ethernet/microchip/vcap/vcap_api.h | 1 -
>  2 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> index b50d002b646dc..b65819f3a927f 100644
> --- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> +++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> @@ -974,17 +974,12 @@ static u32 vcap_next_rule_addr(u32 addr, struct vcap_rule_internal *ri)
>  /* Assign a unique rule id and autogenerate one if id == 0 */
>  static u32 vcap_set_rule_id(struct vcap_rule_internal *ri)
>  {
> -	u32 next_id;
> -
>  	if (ri->data.id != 0)
>  		return ri->data.id;
>  
> -	next_id = ri->vctrl->rule_id + 1;
> -
> -	for (next_id = ri->vctrl->rule_id + 1; next_id < ~0; ++next_id) {
> +	for (u32 next_id = 1; next_id < ~0; ++next_id) {
>  		if (!vcap_lookup_rule(ri->vctrl, next_id)) {

Or you can simply use IDA/IDR/XArray which takes care of all this :)


>  			ri->data.id = next_id;
> -			ri->vctrl->rule_id = next_id;
>  			break;
>  		}
>  	}
> diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.h b/drivers/net/ethernet/microchip/vcap/vcap_api.h
> index ca4499838306f..689c7270f2a89 100644
> --- a/drivers/net/ethernet/microchip/vcap/vcap_api.h
> +++ b/drivers/net/ethernet/microchip/vcap/vcap_api.h
> @@ -268,7 +268,6 @@ struct vcap_operations {
>  
>  /* VCAP API Client control interface */
>  struct vcap_control {
> -	u32 rule_id; /* last used rule id (unique across VCAP instances) */
>  	struct vcap_operations *ops;  /* client supplied operations */
>  	const struct vcap_info *vcaps; /* client supplied vcap models */
>  	const struct vcap_statistics *stats; /* client supplied vcap stats */
> -- 
> 2.38.0

Thanks,
Olek
