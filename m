Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A304AA667
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379154AbiBEERT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 23:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiBEERT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 23:17:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52020C061346;
        Fri,  4 Feb 2022 20:17:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C62D460C09;
        Sat,  5 Feb 2022 04:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED1CC340E8;
        Sat,  5 Feb 2022 04:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644034637;
        bh=5B0zzt47TZJh1dllxNrRqDgAts6rZBFb72hDo7VDMiE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lYpw0Nf+qJoAIxX5PIPmanWcvtpMFysREj3DEqX3e5oXINGxBPLVBhp/2T+PfVlmc
         adO8Yf201TdV85BQF+x7bTp5z33d2Bu1b+riq9ay6vExSN8TjoEC79JZ4rFVIWj/MS
         RUxesmDuk0IlPjR9QvUI4mv8qef8rjmkSP7cW5s+XxwBTEKLpArPP/21t+OKrOTev6
         bl6s8vEFrknHZfJQPzzkRhKP1BA7P7Bn8S29TxHoc7wjxLmjMp2roTyk2etlhaJ4Bz
         cN43usqWkR6xrlmERr7gB1alE/tSIPPZ4toFxIn5TniEd8xGdJR+f/64TWM10IcgI+
         VsmihyugcZ82w==
Date:   Fri, 4 Feb 2022 20:17:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@toke.dk>
Subject: Re: [PATCH net-next v2 2/3] net: dev: Makes sure netif_rx() can be
 invoked in any context.
Message-ID: <20220204201715.44f48f4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204201259.1095226-3-bigeasy@linutronix.de>
References: <20220204201259.1095226-1-bigeasy@linutronix.de>
        <20220204201259.1095226-3-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Feb 2022 21:12:58 +0100 Sebastian Andrzej Siewior wrote:
> +int __netif_rx(struct sk_buff *skb)
> +{
> +	int ret;
> +
> +	trace_netif_rx_entry(skb);
> +	ret = netif_rx_internal(skb);
> +	trace_netif_rx_exit(ret);
> +	return ret;
> +}

Any reason this is not exported? I don't think there's anything wrong
with drivers calling this function, especially SW drivers which already
know to be in BH. I'd vote for roughly all of $(ls drivers/net/*.c) to
get the same treatment as loopback.
