Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A514492EE9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 21:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349060AbiARUBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 15:01:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53736 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349050AbiARUBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 15:01:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA2FA60F56
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 20:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEFBC340EC;
        Tue, 18 Jan 2022 20:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642536098;
        bh=4yvxrGEChV8sIDc7MrCrqxsIAsGOKsogFxxnTtJS1Yw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i3B7TPp5rDGCAxyUd+CrS18tmlsQ1jOZNZ2xuCyLoc8mwRMqyOP3neExw7QlHnaNu
         PlPjNYvTL1wvSc+HwKcmjG8H/MP93jd01N2i4nXS+J/iNiLdbu6JpVFKqzfH17C0se
         I1AUxpr1QecoJzoAOLutQ1B43SoehBzg83j341g8Jiwxvsa5M9Nc/mJf+2oK7O8j3E
         S8GllOXeZhqX8W3x+4DuQCnkBlvmxsJIEcpMzsKOBb09rGN8O61bhepHJMJ8xIyeuL
         g4eEneddJySHgfBgHVgT9AkeO44GeUQK89shjrLtSDf6HdGROi/3dvsOvKBKVgZVRn
         IzVaqnIATFh8g==
Date:   Tue, 18 Jan 2022 12:01:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denys Fedoryshchenko <denys.f@collabora.com>
Cc:     netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH ethtool-next] features: add --json support
Message-ID: <20220118120136.020e6bc9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <266fbaa6b59bbbee6f216f46f3641fdcc3032bd0.camel@collabora.com>
References: <266fbaa6b59bbbee6f216f46f3641fdcc3032bd0.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Jan 2022 13:31:00 +0200 Denys Fedoryshchenko wrote:
> Normal text output remain as before, adding json to make ethtool 
> more machine friendly.

For the review it's useful to see the outputs in the commit message,
please add (you can trim it down to just a handful of features if 
it's long).

> Signed-off-by: Denys Fedoryshchenko <denys.f@collabora.com>

> diff --git a/ethtool.c b/ethtool.c
> index 064bc69..c4905f0 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -5729,6 +5729,7 @@ static const struct option args[] = {
>  		.opts	= "-k|--show-features|--show-offload",
>  		.func	= do_gfeatures,
>  		.nlfunc	= nl_gfeatures,
> +		.json	= true,
>  		.help	= "Get state of protocol offload and other features"
>  	},
>  	{
> diff --git a/netlink/features.c b/netlink/features.c
> index 2a0899e..cbe3edc 100644
> --- a/netlink/features.c
> +++ b/netlink/features.c
> @@ -77,13 +77,23 @@ static void dump_feature(const struct feature_results *results,
>  	}
>  
>  	if (!feature_on(results->hw, idx) || feature_on(results->nochange, idx))
> -		suffix = " [fixed]";
> +		suffix = "[fixed]";
>  	else if (feature_on(results->active, idx) !=
>  		 feature_on(results->wanted, idx))
>  		suffix = feature_on(results->wanted, idx) ?
> -			" [requested on]" : " [requested off]";
> -	printf("%s%s: %s%s\n", prefix, name,
> +			"[requested on]" : "[requested off]";
> +
> +	if (is_json_context()) {
> +		char *name_suffix = malloc(strlen(name)+strlen("-opt")+1);
> +
> +		sprintf(name_suffix, "%s-opt", name);
> +		print_bool(PRINT_JSON, name, NULL, feature_on(results->active, idx));
> +		print_string(PRINT_JSON, name_suffix, NULL, suffix);

Maybe it's better to make each feature an object with
wanted/active/nochange etc attributes?

> +		free(name_suffix);
> +	} else {
> +		printf("%s%s: %s %s\n", prefix, name,
>  	       feature_on(results->active, idx) ? "on" : "off", suffix);

nit: please re-align the continuation line to start after the '(' on the
line above.

> +	}
>  }
>  
>  /* this assumes pattern contains no more than one asterisk */
> @@ -153,9 +163,14 @@ int dump_features(const struct nlattr *const *tb,
>  					feature_on(results.active, j);
>  			}
>  		}
> -		if (n_match != 1)
> -			printf("%s: %s\n", off_flag_def[i].long_name,
> +		if (n_match != 1) {
> +			if (is_json_context()) {
> +				print_bool(PRINT_JSON, off_flag_def[i].long_name, NULL, flag_value);
> +			} else {
> +				printf("%s: %s\n", off_flag_def[i].long_name,
>  			       flag_value ? "on" : "off");
> +			}
> +		}
>  		if (n_match == 0)
>  			continue;
>  		for (j = 0; j < results.count; j++) {
> @@ -210,8 +225,10 @@ int features_reply_cb(const struct nlmsghdr *nlhdr, void *data)
>  
>  	if (silent)
>  		putchar('\n');
> -	printf("Features for %s:\n", nlctx->devname);
> +	open_json_object(NULL);
> +	print_string(PRINT_ANY, "ifname", "Features for %s:\n", nlctx->devname);
>  	ret = dump_features(tb, feature_names);
> +	close_json_object();
>  	return (silent || !ret) ? MNL_CB_OK : MNL_CB_ERROR;
>  }
>  
> @@ -232,9 +249,14 @@ int nl_gfeatures(struct cmd_context *ctx)
>  	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_FEATURES_GET,
>  				      ETHTOOL_A_FEATURES_HEADER,
>  				      ETHTOOL_FLAG_COMPACT_BITSETS);
> +

nit: this new line looks spurious

>  	if (ret < 0)
>  		return ret;

..perhaps add a new line here

> -	return nlsock_send_get_request(nlsk, features_reply_cb);
> +	new_json_obj(ctx->json);
> +	ret = nlsock_send_get_request(nlsk, features_reply_cb);
> +

.. but not here

> +	delete_json_obj();

.. and add one here?

> +	return ret;
>  }
>  
>  /* FEATURES_SET */

Thanks!!
