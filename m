Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9A75A8BA4
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiIACwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiIACwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:52:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DE9161DF2
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 19:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20D5161DD2
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 02:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43038C433D6;
        Thu,  1 Sep 2022 02:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662000763;
        bh=ujNP13VcDoxALFgaVqzeiCkljDq+K/1hQaTlGeT4xR8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=d4Fvqa2v/jEpDEYLhU+ujnzN739LZIRBBwFoVlzpzNt5JfaZNmWiY9kCQMLrnwnty
         NIhyHTbhzPX6LCZNtfWu4txY8Ze0tcMCHNU2Tqoxuv9mVV5MZmzEZ6r60TZUEG8cm+
         wxy8JxaItpsgoHWLMhXJxqlajeiSAPCcsJV08NK9PgkNcVRjIC1+8aQVZiUYAzmBmy
         0weq9HeWekZmWQmoq8jiwFtobl0SULevrg6M50L8698pma2iUfc25A/J7EjxYS1XN2
         eTotah4bwVU3IFom8n+voqd98XGgaE2JjEhLdfg5qZ1bUe794OdfGsThmVNA4JQyrb
         jPHzIHNrgoZsg==
Message-ID: <07bc7668-3107-bea2-58e0-75a77af57f7c@kernel.org>
Date:   Wed, 31 Aug 2022 20:52:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH main v2 1/2] macsec: add extended packet number (XPN)
 support
Content-Language: en-US
To:     Emeel Hakim <ehakim@nvidia.com>, sd@queasysnail.net
Cc:     tariqt@nvidia.com, raeds@nvidia.com, netdev@vger.kernel.org
References: <20220824091752.25414-1-ehakim@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220824091752.25414-1-ehakim@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/22 3:17 AM, Emeel Hakim wrote:
> @@ -174,14 +181,34 @@ static int parse_sa_args(int *argcp, char ***argvp, struct sa_desc *sa)
>  
>  	while (argc > 0) {
>  		if (strcmp(*argv, "pn") == 0) {
> -			if (sa->pn != 0)
> +			if (sa->pn.pn32 != 0)

pn64 to cover the entire range? ie., pn and xpn on the same command line.

>  				duparg2("pn", "pn");
>  			NEXT_ARG();
> -			ret = get_u32(&sa->pn, *argv, 0);
> +			ret = get_u32(&sa->pn.pn32, *argv, 0);
>  			if (ret)
>  				invarg("expected pn", *argv);
> -			if (sa->pn == 0)
> +			if (sa->pn.pn32 == 0)
>  				invarg("expected pn != 0", *argv);
> +		} else if (strcmp(*argv, "xpn") == 0) {
> +			if (sa->pn.pn64 != 0)
> +				duparg2("xpn", "xpn");
> +			NEXT_ARG();
> +			ret = get_u64(&sa->pn.pn64, *argv, 0);
> +			if (ret)
> +				invarg("expected pn", *argv);
> +			if (sa->pn.pn64 == 0)
> +				invarg("expected pn != 0", *argv);
> +			sa->xpn = true;
> +		} else if (strcmp(*argv, "salt") == 0) {
> +			unsigned int len;
> +
> +			NEXT_ARG();
> +			if (!hexstring_a2n(*argv, sa->salt, MACSEC_SALT_LEN,
> +					   &len))
> +				invarg("expected salt", *argv);
> +		} else if (strcmp(*argv, "ssci") == 0) {
> +			NEXT_ARG();
> +			ret = get_u32(&sa->ssci, *argv, 0);

that can fail, so check ret and throw an error message

>  		} else if (strcmp(*argv, "key") == 0) {
>  			unsigned int len;
>  

...


> @@ -1388,6 +1458,14 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
>  				return ret;
>  			addattr8(n, MACSEC_BUFLEN,
>  				 IFLA_MACSEC_OFFLOAD, offload);
> +		} else if (strcmp(*argv, "xpn") == 0) {
> +			NEXT_ARG();
> +			int i;
> +
> +			i = parse_on_off("xpn", *argv, &ret);

drop the 'i' and just
xpn = parse_on_off("xpn", *argv, &ret);

besides you have i as an int when xpn is bool and parse_on_off returns a
bool.

