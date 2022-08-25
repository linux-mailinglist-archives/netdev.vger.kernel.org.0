Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B5E5A1587
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241453AbiHYPYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 11:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241555AbiHYPYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:24:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A56B9593;
        Thu, 25 Aug 2022 08:24:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B57F6B82A11;
        Thu, 25 Aug 2022 15:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22748C433C1;
        Thu, 25 Aug 2022 15:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661441037;
        bh=sON7qE29bK4Ro9h/8W2PALwkURUKcC7gjelIJNXhLfE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=l8aLeuGVk1nw3OH/D7ZZyWecCgXTM/AQXApgEzsf0LzDRSVs0QKDtLHMD+idjEW6c
         m/Et4ZXJyAe0FsbzYdGm9rtun0CwUu6Hn8MnJcaL8dbT4cTdUI2WzauFvI+LnYuI6T
         kqhBM2liFxDKZfWVUV+f+aiO86kSfv+dUw8dgMIPOKn6wBr1FAvmUEOQ0gLYt8jQ90
         TAjmPQNoIiXD/HJnO4fwJHlpZHa74InNOGEDW6UflR2QjpYd1pjdYDaq0LVbc1R2k/
         H/523UaQuYxyfDNu53FSl8XR2OfMN5e7twB9jG+8kBS6HyPbpBmQivLNpb1StbVzT/
         +HrtkQpH1/6GQ==
Message-ID: <6c0c312c-5b95-6650-e002-0ba76bbdd854@kernel.org>
Date:   Thu, 25 Aug 2022 08:23:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH v2 1/3] ipv4: Namespaceify route/error_cost knob
Content-Language: en-US
To:     cgel.zte@gmail.com, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linl@vger.kernel.org, xu.xin16@zte.com.cn,
        Yunkai Zhang <zhang.yunkai@zte.com.cn>
References: <20220824020051.213658-1-xu.xin16@zte.com.cn>
 <20220824020343.213715-1-xu.xin16@zte.com.cn>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220824020343.213715-1-xu.xin16@zte.com.cn>
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

On 8/23/22 7:03 PM, cgel.zte@gmail.com wrote:
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 795cbe1de912..b022ae749640 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -118,7 +118,6 @@ static int ip_rt_max_size;
>  static int ip_rt_redirect_number __read_mostly	= 9;
>  static int ip_rt_redirect_load __read_mostly	= HZ / 50;
>  static int ip_rt_redirect_silence __read_mostly	= ((HZ / 50) << (9 + 1));
> -static int ip_rt_error_cost __read_mostly	= HZ;
>  static int ip_rt_error_burst __read_mostly	= 5 * HZ;
>  
>  static int ip_rt_gc_timeout __read_mostly	= RT_GC_TIMEOUT;
> @@ -949,6 +948,7 @@ static int ip_error(struct sk_buff *skb)
>  	SKB_DR(reason);
>  	bool send;
>  	int code;
> +	int error_cost;

can be moved to below where it is needed
>  
>  	if (netif_is_l3_master(skb->dev)) {
>  		dev = __dev_get_by_index(dev_net(skb->dev), IPCB(skb)->iif);
> @@ -1002,11 +1002,13 @@ static int ip_error(struct sk_buff *skb)
>  	if (peer) {

to here and then name it ip_rt_error_cost and you don't need to
		int ip_rt_error_cost = READ_ONCE(net->ipv4.ip_rt_error_cost);

make changes to the algorithm.

Also, why not ip_rt_error_burst as well? part of the same algorithm.

