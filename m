Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249A24D2480
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 23:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350008AbiCHWwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 17:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbiCHWwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 17:52:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CC94EF4A;
        Tue,  8 Mar 2022 14:51:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B69561185;
        Tue,  8 Mar 2022 22:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F307C340EB;
        Tue,  8 Mar 2022 22:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646779896;
        bh=Bh7Qn9WLvAm/XvtyjjDG+yCZjMwP/qRWgfw7xqZkuIQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bXimZJ/uR+EnEDhpBQwA2ECliX10g1BlEZbswpDzmGCyAewwu8zHiAwC2zcTrbMnV
         L7ff2C5F9m/dyh7iyEP00Tim7x/G5CIcI0CjB4zBPpuielh5SI47SfW1brDd4JN2iA
         cI2FPTfeJgsbWCOh1zb+J4XmkIssc6gDBH+7CmmeOGLPkYHtaervbgS9BzMrbe997J
         9HKvADlTKm3VpjVi6c5k4PqKVUQMRsYubffcN6DQ822oi0dyRuKobZuwDk1N/TJm01
         MVimR1YnK4Uz4/hgxabV3mkjr6Y5LYEx2AK3k8Z8Ku/EQINZUITefwe4Z2CEAVfAGK
         cXIDBCPJO9IYQ==
Message-ID: <d1b25466-6f83-591e-39a6-8fdbd56846fb@kernel.org>
Date:   Tue, 8 Mar 2022 15:51:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v3 net-next] net-core: add rx_otherhost_dropped counter
Content-Language: en-US
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Brian Vazquez <brianvv@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffreyji <jeffreyji@google.com>
References: <20220308212531.752215-1-jeffreyjilinux@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220308212531.752215-1-jeffreyjilinux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/22 2:25 PM, Jeffrey Ji wrote:
> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> index 95f7bb052784..8b87ea99904b 100644
> --- a/net/ipv4/ip_input.c
> +++ b/net/ipv4/ip_input.c
> @@ -451,6 +451,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
>  	 * that it receives, do not try to analyse it.
>  	 */
>  	if (skb->pkt_type == PACKET_OTHERHOST) {
> +		atomic_long_inc(&skb->dev->rx_otherhost_dropped);
>  		drop_reason = SKB_DROP_REASON_OTHERHOST;
>  		goto drop;
>  	}
> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index 5b5ea35635f9..5624c937f87f 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -150,6 +150,7 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>  	struct inet6_dev *idev;
>  
>  	if (skb->pkt_type == PACKET_OTHERHOST) {
> +		atomic_long_inc(&skb->dev->rx_otherhost_dropped);
>  		kfree_skb(skb);
>  		return NULL;
>  	}

that's an expensive packet counter for a common path (e.g., hosting
environments).
