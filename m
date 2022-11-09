Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B507E622161
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 02:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiKIBnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 20:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiKIBmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 20:42:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1201267F4D
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 17:41:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3FBE6182F
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 01:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB709C433C1;
        Wed,  9 Nov 2022 01:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667958059;
        bh=ee0fSJeM4ijxxBNQH6aofK78gZ2b5Wfwu5OmosZdVyc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Psya90o33mmuXeNCdI8GoNWKEy06voSWQScMOZ2xgz+QnJTFVaQojkerHUO959FFW
         WPAyZ6SFOhQHta+V1Cc4t5W1VeAY7cMv8g1xllIcnc9LnUEbPhlUcr/9Na/3d9OZVV
         Kzz3vczBYvaHrzq+bs2qU7MXFMyU1F1tt6iv/kIyjmaivdfMm/C3Ctu7k22Ah1YyIr
         8ZsotKrS/QaILOxPIfQY7l2XWGLLFFL3OruqeG07uea54YCJ1me43ntQX8sJ8CYRlh
         o9cHWvye5DQocWKI1Ehst7+PzU+JLrl1cIIF6dDStvii+tMX1KKfCOgqS4CrrF7cwE
         /ViOcekdkMwGw==
Date:   Tue, 8 Nov 2022 17:40:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Wang Yufen <wangyufen@huawei.com>
Subject: Re: [PATCH net] net: tun: call napi_schedule_prep() to ensure we
 own a napi
Message-ID: <20221108174057.2336512c@kernel.org>
In-Reply-To: <20221107180011.188437-1-edumazet@google.com>
References: <20221107180011.188437-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Nov 2022 18:00:11 +0000 Eric Dumazet wrote:
>  		if (unlikely(headlen > skb_headlen(skb))) {
> +			WARN_ON_ONCE(1);
> +			err = -ENOMEM;
>  			dev_core_stats_rx_dropped_inc(tun->dev);
> +napi_busy:
>  			napi_free_frags(&tfile->napi);
>  			rcu_read_unlock();
>  			mutex_unlock(&tfile->napi_mutex);
> -			WARN_ON(1);
> -			return -ENOMEM;
> +			return err;
>  		}
>  
> -		local_bh_disable();
> -		napi_gro_frags(&tfile->napi);
> -		napi_complete(&tfile->napi);
> -		local_bh_enable();
> +		if (likely(napi_schedule_prep(&tfile->napi))) {
> +			local_bh_disable();
> +			napi_gro_frags(&tfile->napi);
> +			napi_complete(&tfile->napi);
> +			local_bh_enable();
> +		} else {
> +			err = -EBUSY;
> +			goto napi_busy;

This can only hit if someone else is trying to detach / napi_disable()
at the same time?

> +		}
