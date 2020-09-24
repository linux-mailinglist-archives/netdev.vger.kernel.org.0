Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299672764E7
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgIXAKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:10:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:10957 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbgIXAKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 20:10:35 -0400
IronPort-SDR: 8JPAvLVr7pGYvsdBS0mehX3gk/69ByzyMBOXeZtuI6mfiwyQTVlDD7X5gR7nKqlGxEMg1uaS9i
 qlMETBPnA0wQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="161126065"
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="161126065"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 17:10:33 -0700
IronPort-SDR: 6Y2Ft/7jUwjOWPBkZV5H5em7Eg3Uxqo6nVIP8mnqHPRJYb8HDJJ8ExfRcBrr6kF/dSxKCG/4eM
 RV+Q4/yiGxsQ==
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="290975965"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.23.95]) ([10.212.23.95])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 17:10:33 -0700
Subject: Re: [PATCH ethtool-next 2/5] pause: add --json support
To:     Jakub Kicinski <kuba@kernel.org>, mkubecek@suse.cz
Cc:     netdev@vger.kernel.org
References: <20200915235259.457050-1-kuba@kernel.org>
 <20200915235259.457050-3-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <3edc444e-ac89-a17b-3092-f91e8523cfa3@intel.com>
Date:   Wed, 23 Sep 2020 17:10:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200915235259.457050-3-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/15/2020 4:52 PM, Jakub Kicinski wrote:
> No change in normal text output:
> 
>  # ./ethtool  -a eth0
> Pause parameters for eth0:
> Autonegotiate:	on
> RX:		on
> TX:		on
> RX negotiated: on
> TX negotiated: on
> 
> JSON:
> 
>  # ./ethtool --json -a eth0
> [ {
>         "ifname": "eth0",
>         "autonegotiate": true,
>         "rx": true,
>         "tx": true,
>         "negotiated": {
>             "rx": true,
>             "tx": true
>         }
>     } ]


Makes sense, we report all of these as a single dictionary with
key-values. Putting negotiated as a subsection seems reasonable as well.
I guess we could split this so that tx and rx have their own section.
but I think this is good.

This looks good to me.

Reviewed-by: Jacob Keller <jacob.e.keller@gmail.com>

> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  netlink/netlink.h | 12 ++++++++++--
>  netlink/pause.c   | 45 +++++++++++++++++++++++++++++++++++----------
>  2 files changed, 45 insertions(+), 12 deletions(-)
> 
> diff --git a/netlink/netlink.h b/netlink/netlink.h
> index dd4a02bcc916..4916d25ed5c0 100644
> --- a/netlink/netlink.h
> +++ b/netlink/netlink.h
> @@ -106,9 +106,17 @@ static inline const char *u8_to_bool(const struct nlattr *attr)
>  		return "n/a";
>  }
>  
> -static inline void show_bool(const struct nlattr *attr, const char *label)
> +static inline void show_bool(const char *key, const char *fmt,
> +			     const struct nlattr *attr)
>  {
> -	printf("%s%s\n", label, u8_to_bool(attr));
> +	if (is_json_context()) {
> +		if (attr) {
> +			print_bool(PRINT_JSON, key, NULL,
> +				   mnl_attr_get_u8(attr));
> +		}
> +	} else {
> +		print_string(PRINT_FP, NULL, fmt, u8_to_bool(attr));

Ok. The change from label to fmt makes sense because we now pass a
format string instead of a label, and we use print_string instead of printf.

> +	}
>  }
>  
>  /* misc */
> diff --git a/netlink/pause.c b/netlink/pause.c
> index 7b6b3a1d2c10..30ecdccb15eb 100644
> --- a/netlink/pause.c
> +++ b/netlink/pause.c
> @@ -72,8 +72,16 @@ static int pause_autoneg_cb(const struct nlmsghdr *nlhdr, void *data)
>  		else if (peer.pause)
>  			tx_status = true;
>  	}
> -	printf("RX negotiated: %s\nTX negotiated: %s\n",
> -	       rx_status ? "on" : "off", tx_status ? "on" : "off");
> +
> +	if (is_json_context()) {
> +		open_json_object("negotiated");
> +		print_bool(PRINT_JSON, "rx", NULL, rx_status);
> +		print_bool(PRINT_JSON, "tx", NULL, tx_status);
> +		close_json_object();
> +	} else {
> +		printf("RX negotiated: %s\nTX negotiated: %s\n",
> +		       rx_status ? "on" : "off", tx_status ? "on" : "off");
> +	}
>  

Why not use print_string here like show_bool did?

>  	return MNL_CB_OK;
>  }
> @@ -121,21 +129,34 @@ int pause_reply_cb(const struct nlmsghdr *nlhdr, void *data)
>  		return err_ret;
>  
>  	if (silent)
> -		putchar('\n');
> -	printf("Pause parameters for %s:\n", nlctx->devname);
> -	show_bool(tb[ETHTOOL_A_PAUSE_AUTONEG], "Autonegotiate:\t");
> -	show_bool(tb[ETHTOOL_A_PAUSE_RX], "RX:\t\t");
> -	show_bool(tb[ETHTOOL_A_PAUSE_TX], "TX:\t\t");
> +		print_nl();
> +
> +	open_json_object(NULL);
> +
> +	print_string(PRINT_ANY, "ifname", "Pause parameters for %s:\n",
> +		     nlctx->devname);
> +

Ah, nice, so this prints based on the current format and will just print
the ifname instead of showing the format string. Neat.

> +	show_bool("autonegotiate", "Autonegotiate:\t%s\n",
> +		  tb[ETHTOOL_A_PAUSE_AUTONEG]);
> +	show_bool("rx", "RX:\t\t%s\n", tb[ETHTOOL_A_PAUSE_RX]);
> +	show_bool("tx", "TX:\t\t%s\n", tb[ETHTOOL_A_PAUSE_TX]);
> +
>  	if (!nlctx->is_monitor && tb[ETHTOOL_A_PAUSE_AUTONEG] &&
>  	    mnl_attr_get_u8(tb[ETHTOOL_A_PAUSE_AUTONEG])) {
>  		ret = show_pause_autoneg_status(nlctx);
>  		if (ret < 0)
> -			return err_ret;
> +			goto err_close_dev;
>  	}
>  	if (!silent)
> -		putchar('\n');
> +		print_nl();
> +
> +	close_json_object();
>  
>  	return MNL_CB_OK;
> +
> +err_close_dev:
> +	close_json_object();
> +	return err_ret;
>  }
>  
>  int nl_gpause(struct cmd_context *ctx)
> @@ -156,7 +177,11 @@ int nl_gpause(struct cmd_context *ctx)
>  				      ETHTOOL_A_PAUSE_HEADER, 0);
>  	if (ret < 0)
>  		return ret;
> -	return nlsock_send_get_request(nlsk, pause_reply_cb);
> +
> +	new_json_obj(ctx->json);
> +	ret = nlsock_send_get_request(nlsk, pause_reply_cb);
> +	delete_json_obj();
> +	return ret;
>  }
>  
>  /* PAUSE_SET */
> 
