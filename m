Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D2F257520
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 10:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgHaIO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 04:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgHaIO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 04:14:58 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD3FC061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 01:14:58 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z1so1509404wrt.3
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 01:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XPHP1vdzdeNPRMRQXPb8lsqTbCUBpimeTHFdfkrU2rw=;
        b=hA9DEplQuKSwmaHI4EAx+hWbxEHEAJphtT9XhMT+WKb9AiYD5BvmUFtV5WSFmngLqQ
         rHLc4HNQKuS+/xPTa86jzfQUCU8iyOSb3CYjwtDKDRnCI/iR+TYyW+AxF8F7YKjhch2v
         Bi8vM4VZKjVG+CXeBp+IXp1nxiu/Ul/3NxY57Z03vJIQ3IurtLUyZFS90qJfMapu4T3J
         C/MPFe8Je8RXcub+X0CfbqnNEjjauEzbIWwoY7F6++6lYjaCmUGai9gXmAVg8MtQtPty
         ztXbeGe8qVauSLNLcS9NO0SAq+EIgKjpcqWIfqtYDSgTnCu9bxp0wgYGrO8SDvkWiqie
         Cbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XPHP1vdzdeNPRMRQXPb8lsqTbCUBpimeTHFdfkrU2rw=;
        b=FM8S4/j3KZARNAgPUT1jxnS0i+cFwV9Aji6Fgg0oq0ChQyROpbwdoGOV98bnOMS2q1
         78JMLTac1xmythk/pq1qnQAcYQ0DoqBP9mSLdPMmPuTrRh7rOl9VIZtLMX2CetnQZROd
         AdD7gD0chDhH1pob+QTtWC1jUQyukMM2cEq6P1NDvb4oLkqf/PdHlLKhZGXKT2rAH/j2
         i439s3PbvbjtAQ8sBePlP7DuWZBGLOWAecUtsl8U1xcqV8v8x3vmU0YSJQithzUfsJqU
         gYHBXHK4N3glRhDA8W3C6/WHcQM1GeBEVu5Aw3STxlX14m5dmNNqM+aP3fy27cT5anAp
         5QPw==
X-Gm-Message-State: AOAM533tIyFxHAvMV2lGgOF+pPsDw+7WEUrQXKUvznFPpIJ4idpVioeO
        WTVrJ/rse8lxHUEdQHz1zqg=
X-Google-Smtp-Source: ABdhPJzMLFknDEDrnnZDhdYFkTS4ZigNaFKh4obc4Cv93z/GoKrGdJLLyRG4GWZLTwu8QRknzoe8KQ==
X-Received: by 2002:a5d:4fcc:: with SMTP id h12mr474887wrw.199.1598861692435;
        Mon, 31 Aug 2020 01:14:52 -0700 (PDT)
Received: from [192.168.8.147] ([37.164.5.65])
        by smtp.gmail.com with ESMTPSA id c8sm11145868wrm.62.2020.08.31.01.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 01:14:51 -0700 (PDT)
Subject: Re: [net] tipc: fix using smp_processor_id() in preemptible
To:     Tuong Lien <tuong.t.lien@dektech.com.au>, davem@davemloft.net,
        jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
References: <20200829193755.9429-1-tuong.t.lien@dektech.com.au>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f81eafce-e1d1-bb18-cb70-cfdf45bb2ed0@gmail.com>
Date:   Mon, 31 Aug 2020 10:14:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200829193755.9429-1-tuong.t.lien@dektech.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/29/20 12:37 PM, Tuong Lien wrote:
> The 'this_cpu_ptr()' is used to obtain the AEAD key' TFM on the current
> CPU for encryption, however the execution can be preemptible since it's
> actually user-space context, so the 'using smp_processor_id() in
> preemptible' has been observed.
> 
> We fix the issue by using the 'get/put_cpu_ptr()' API which consists of
> a 'preempt_disable()' instead.
> 
> Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")

Have you forgotten ' Reported-by: syzbot+263f8c0d007dc09b2dda@syzkaller.appspotmail.com' ?

> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
> ---
>  net/tipc/crypto.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
> index c38babaa4e57..7c523dc81575 100644
> --- a/net/tipc/crypto.c
> +++ b/net/tipc/crypto.c
> @@ -326,7 +326,8 @@ static void tipc_aead_free(struct rcu_head *rp)
>  	if (aead->cloned) {
>  		tipc_aead_put(aead->cloned);
>  	} else {
> -		head = *this_cpu_ptr(aead->tfm_entry);
> +		head = *get_cpu_ptr(aead->tfm_entry);
> +		put_cpu_ptr(aead->tfm_entry);

Why is this safe ?

I think that this very unusual construct needs a comment, because this is not obvious.

This really looks like an attempt to silence syzbot to me.

>  		list_for_each_entry_safe(tfm_entry, tmp, &head->list, list) {
>  			crypto_free_aead(tfm_entry->tfm);
>  			list_del(&tfm_entry->list);
> @@ -399,10 +400,15 @@ static void tipc_aead_users_set(struct tipc_aead __rcu *aead, int val)
>   */
>  static struct crypto_aead *tipc_aead_tfm_next(struct tipc_aead *aead)
>  {
> -	struct tipc_tfm **tfm_entry = this_cpu_ptr(aead->tfm_entry);
> +	struct tipc_tfm **tfm_entry;
> +	struct crypto_aead *tfm;
>  
> +	tfm_entry = get_cpu_ptr(aead->tfm_entry);
>  	*tfm_entry = list_next_entry(*tfm_entry, list);
> -	return (*tfm_entry)->tfm;
> +	tfm = (*tfm_entry)->tfm;
> +	put_cpu_ptr(tfm_entry);

Again, this looks suspicious to me. I can not explain why this would be safe.

> +
> +	return tfm;
>  }
>  
>  /**
> 
