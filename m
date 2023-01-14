Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843AD66A892
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 03:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjANCPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 21:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjANCPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 21:15:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9865C8BAB8
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 18:15:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 402DCB81AA1
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 02:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CADEC433D2;
        Sat, 14 Jan 2023 02:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673662540;
        bh=UOKXu8oksYAHuWDR8QICqDOVERhtvTpdBR+QZ9Hoe7E=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qwXROUzHd0rjd0hxsVbttYcD5/JPiCtMG6EUO/kCjgo3pciI+ZHQy66HWREJzvRrL
         b6IaXeGrXaH5dv10XQ+2DWTcbFvYYMS+FlNmnXr9P3jIeGxDwHSS6xVIT9KK6JYwOF
         6LPr+K92QHDOOmyAs7hQWw/nZpM3Buq+ruEy7cUn6JjN4LhPXfDHQum/jMg/nYgKcK
         /yiYIbbx1Ih+An7vChl1eaaPIY/YFQi8Fuf5GXE4zY2J9IwlR05ecb85j9Ieat2DVK
         zGdOI77VttaGQCWdDrSChYq5twTU0CHquAuIW8E/KggHUlCqMytdeN5hKpj9NyfMlt
         bm15rO/YW+Afw==
Message-ID: <267de46f-d661-fd9d-a5f6-15bc4d40ae86@kernel.org>
Date:   Fri, 13 Jan 2023 19:15:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH iproute2-next 2/2] tc: add new attr TCA_EXT_WARN_MSG
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
 <20230113034617.2767057-1-liuhangbin@gmail.com>
 <20230113034617.2767057-2-liuhangbin@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230113034617.2767057-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/23 8:46 PM, Hangbin Liu wrote:
> diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
> index 33a6665e..a84602b4 100644
> --- a/tc/tc_qdisc.c
> +++ b/tc/tc_qdisc.c
> @@ -346,6 +346,12 @@ int print_qdisc(struct nlmsghdr *n, void *arg)
>  			print_nl();
>  		}
>  	}
> +
> +	if (tb[TCA_EXT_WARN_MSG]) {
> +		print_string(PRINT_ANY, "Warn", "%s ", rta_getattr_str(tb[TCA_EXT_WARN_MSG]));
> +		print_nl();
> +	}
> +

given the repetition with the WARN_MSG, how about a helper in tc_util.c


