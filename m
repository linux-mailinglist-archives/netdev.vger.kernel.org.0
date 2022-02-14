Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE2F4B400A
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 04:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239803AbiBNDGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 22:06:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235542AbiBNDGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 22:06:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D1D50E20;
        Sun, 13 Feb 2022 19:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=3Um984TSioo1FxOqxiPNeNkunSiMQ7UXyF8BW2l0yBg=; b=cF+Y0lRNV31LgjsVu6Cf2SVR1X
        hCBQ5Gfv3q/TBlIFjjcUPiMRaIEby3XQp8XPOs63JSE1KUq0ui0YfsctWkPT/BGicdC9ve7NDLb4m
        JNBLL207Loe3x4LRtoMz+WUJDWBOQNpug7uEvogCWks8JQJJ74rPnVUixMJmQALp9HgtsWoeydWK8
        +YNbgrOuXITTcmdtMAd4tt8gEBPsL77gP2atjSBPt37Vxij6zXMJSMugBKxFsRYG9/xCfBIuaDTW2
        H5WtFsD6xjUpzUE27dd469nOzJtfFG//GRKTbOclQmtG/P4v3J+SFGMd2eVmOF8eVuh6gwdnp8OGu
        wxY5KPLg==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nJRgV-00CUbz-P5; Mon, 14 Feb 2022 03:05:52 +0000
Message-ID: <7390f20d-e679-6fc3-62cb-95850871561d@infradead.org>
Date:   Sun, 13 Feb 2022 19:05:47 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] ipv4: add description about martian source
Content-Language: en-US
To:     cgel.zte@gmail.com, davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Yunkai <zhang.yunkai@zte.com.cn>
References: <20220214030123.1716223-1-zhang.yunkai@zte.com.cn>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220214030123.1716223-1-zhang.yunkai@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 2/13/22 19:01, cgel.zte@gmail.com wrote:
> From: Zhang Yunkai <zhang.yunkai@zte.com.cn>
> 
> When multiple containers are running in the environment and multiple
> macvlan network port are configured in each container, a lot of martian
> source prints will appear after martian_log is enabled.

Does it need to use one of the printk_ratelimited() calls?
or are they all unique?

> Such as:
> IPv4: martian source 173.254.95.16 from 173.254.100.109,
> on dev eth0
> ll header: 00000000: ff ff ff ff ff ff 40 00 ad fe 64 6d
> 08 06        ......@...dm..
> IPv4: martian source 173.254.95.16 from 173.254.100.109,
> on dev eth1
> ll header: 00000000: ff ff ff ff ff ff 40 00 ad fe 64 6d
> 08 06        ......@...dm..
> 
> There is no description of this kind of source in the RFC1812.
> 
> Signed-off-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
> ---
>  net/ipv4/fib_frontend.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index 4d61ddd8a0ec..3564308e849a 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -436,6 +436,9 @@ int fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
>  		if (net->ipv4.fib_has_custom_local_routes ||
>  		    fib4_has_custom_rules(net))
>  			goto full_check;
> +		/* Within the same container,it is regarded as a martian source,

Please add a space after the comma:         , it is

> +		 * and the same host but different containers are not.
> +		 */
>  		if (inet_lookup_ifaddr_rcu(net, src))
>  			return -EINVAL;
>  

-- 
~Randy
