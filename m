Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94922F6ADB
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbhANTWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729921AbhANTWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 14:22:36 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC07CC061757
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 11:21:55 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id v184so1471977wma.1
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 11:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yoBKqmxECo5TZjsaPrlrADanJOS8g5VDMzzQPzlMK2k=;
        b=WcRwmSASeF1C62I+RmvsgYoUAVU8m0aQnCXTsiArgucO7t2ukRqT4lt0lrdjt/fE/N
         psZFDOqpUdy77btPEd8Ewii/MCAr4irtWNq4KI5PhtsKOcYjr6AZ6AAWmiUba0bvbLsp
         plZtlatodNuL+HXLVutV/yAGAbmvub4K5VsHZDV8kF5FddDjmPIhPHBJeXp9TNwmFoyg
         BUfZTJw3FhMZ3+2pRuOqlCH2F8amfkIv4FAMlF9jAn7GiA/8gYkSIf5fCO4LPqWAZ/xU
         vCr/6pkyAx/7X+UuDB1h3lBfbewFqXMOM4phK5rAd/XweK9ekXDr5Ej15M2b3UMNBCMj
         PKbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yoBKqmxECo5TZjsaPrlrADanJOS8g5VDMzzQPzlMK2k=;
        b=rNQmY17N/TViJTHsw+eBifXzFjTKFejlDUNIN2ADoNoKbYz2dMcDc5ZCVtbw5v3oSj
         2wpfpUOCl5o9MTqoeIq/8A1XmsELdPN0S+Xc5zamgcazClqsWXLMicURzGK0qsG4dXFx
         Y+odY23pyVPHPVL2qVPBMMTVh+kVj+Qem9U4f8qptBoLX7C7ADLj71c0BpThu2tulgai
         6Bkg2BxxC7KZGoNRCA8BceVL0AJCYvbutHm65BWhzfhUvkRv9yy3tBAM9CBoIoIINsg2
         KWDGh8EPYGMnf5zX5HJLDlnYaZeOB6Fa/KrxxkooG7BwyPMeMrIkfvPNchI1z0sLM2UE
         W1Pw==
X-Gm-Message-State: AOAM531olKYUipPG+6Ok/OoSqty//xCcxkfnKUiaeWfDiKcwriMNBkZe
        q7Jymg4Gh+cmYuvD8ASohKlY/k7Fjk0=
X-Google-Smtp-Source: ABdhPJwe/FiAs5+FQyBSSMMGDzWyObAR0oJ7ZOWsNtChU1x1N0hrCtgnuAUkcM+2MhvotVERC3v1hw==
X-Received: by 2002:a1c:3286:: with SMTP id y128mr5298896wmy.104.1610652114541;
        Thu, 14 Jan 2021 11:21:54 -0800 (PST)
Received: from [192.168.1.101] ([37.166.145.83])
        by smtp.gmail.com with ESMTPSA id q7sm4927667wmq.0.2021.01.14.11.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 11:21:53 -0800 (PST)
Subject: Re: [PATCH net] mptcp: fix locking in mptcp_disconnect()
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <f818e82b58a556feeb71dcccc8bf1c87aafc6175.1610638176.git.pabeni@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9cf07f1b-c013-adfc-15b4-58902095cf07@gmail.com>
Date:   Thu, 14 Jan 2021 20:21:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <f818e82b58a556feeb71dcccc8bf1c87aafc6175.1610638176.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/14/21 4:37 PM, Paolo Abeni wrote:
> tcp_disconnect() expects the caller acquires the sock lock,
> but mptcp_disconnect() is not doing that. Add the missing
> required lock.
> 
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Fixes: 76e2a55d1625 ("mptcp: better msk-level shutdown.")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/mptcp/protocol.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index 81faeff8f3bb..f998a077c7dd 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -2646,8 +2646,13 @@ static int mptcp_disconnect(struct sock *sk, int flags)
>  	struct mptcp_sock *msk = mptcp_sk(sk);
>  
>  	__mptcp_flush_join_list(msk);
> -	mptcp_for_each_subflow(msk, subflow)
> -		tcp_disconnect(mptcp_subflow_tcp_sock(subflow), flags);
> +	mptcp_for_each_subflow(msk, subflow) {
> +		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
> +
> +		lock_sock(ssk);
> +		tcp_disconnect(ssk, flags);
> +		release_sock(ssk);
> +	}

Reviewed-by: Eric Dumazet <edumazet@google.com>

Note that for loops like this one, calling non blocking functions,
you could use lock_sock_fast()

(Probably does not matter in slow path)

