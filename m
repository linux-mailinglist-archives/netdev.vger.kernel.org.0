Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DBB442210
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 21:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhKAU5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 16:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhKAU5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 16:57:24 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D97C061764;
        Mon,  1 Nov 2021 13:54:50 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id b4so11184112pgh.10;
        Mon, 01 Nov 2021 13:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pZqr5rTlcaug9563wNJYd77L6h7Hk2gF965+CXNB47w=;
        b=Ni5w9wTyiPsaYcO7fKFpzBdoI1bm1lqTRPi/F3tDeEc9LRFV4vfZj0qxXTCUmeCbLA
         X5/63FZkBpzBJWmg+ArJLti1r/FFv1BawCzOKfDmg5CgkL9mm0/sL61K1UJBa32+u/v3
         HMifwPe2araTOCO8kjvrX1A/FhYW0AlqfwaqmXEKn23xVf+k41Ty+TKhXuN1N2ATRoqh
         gODj2DgLpz6M2pO0REWlcfr6KahTMab1YX67/x7OWsZxZzZPBrJNYbKcdsJ8sTxnUW5Z
         O2s2z8E13iE0kN/1SAc1xgFjPfVjj5T/Z5NOkAl+E1dszJzBkuMoRxYOceOfnJQayiq7
         1iaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pZqr5rTlcaug9563wNJYd77L6h7Hk2gF965+CXNB47w=;
        b=UG1f2sR3yDmq+ptw1IeoFzVpronyGmxiU31HvKs5LKkhsyZYWsPSBf+CD9P9quMNVl
         vt0++5Nx2Gl0AVmuxdbmNsSqKSTFzwdRSplMo+Ac+RGFeSgQJq41swQHQ65k8EaD08I/
         VCLZS6VRK51EWdYwmzSGdMSSfLCFuZd0rWoN/1KH60otO/psdQPfD7ApLG0SKfs0myO5
         wuV6RkJYJpMcMUgmtTNJ7BsZEtHX4gVFmTI/mkvjEBesIhPzMXfcbKwCmYv9E4AZcJze
         E52cxBKT7YSJxXYb4Oo9KjrAglWF2uX8so5JTjQ0OIDMYgDiITngXrexT9xMeS2XmL/4
         X0bg==
X-Gm-Message-State: AOAM530bmg6kshv8aKfQCSoJ+icLhWmoIKjV1eCelsKQxLxhQ0kGw2Xj
        KT3pMTvJCJuR+Zoed1qoUwa30UuWrqc=
X-Google-Smtp-Source: ABdhPJyRqX1y8LIgmxGmLlN6ZqygsWwwckwgCo2+I1Hp5UFPHWWYdV0jTemV/m/Gw5TCgObqByhAQw==
X-Received: by 2002:a05:6a00:244e:b0:47b:7dbf:e23d with SMTP id d14-20020a056a00244e00b0047b7dbfe23dmr31701851pfj.34.1635800089195;
        Mon, 01 Nov 2021 13:54:49 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id o19sm11358069pfu.56.2021.11.01.13.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 13:54:48 -0700 (PDT)
Subject: Re: [PATCH v2 11/25] tcp: authopt: Implement Sequence Number
 Extension
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1635784253.git.cdleonard@gmail.com>
 <6097ec24d87efc55962a1bfac9441132f0fc4206.1635784253.git.cdleonard@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <07987e29-87a0-9a09-bdf0-b5e385d9c55f@gmail.com>
Date:   Mon, 1 Nov 2021 13:54:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6097ec24d87efc55962a1bfac9441132f0fc4206.1635784253.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/21 9:34 AM, Leonard Crestez wrote:
> Add a compute_sne function which finds the value of SNE for a certain
> SEQ given an already known "recent" SNE/SEQ. This is implemented using
> the standard tcp before/after macro and will work for SEQ values that
> are without 2^31 of the SEQ for which we know the SNE.

>  }
> +void __tcp_authopt_update_rcv_sne(struct tcp_sock *tp, struct tcp_authopt_info *info, u32 seq);
> +static inline void tcp_authopt_update_rcv_sne(struct tcp_sock *tp, u32 seq)
> +{
> +	struct tcp_authopt_info *info;
> +
> +	if (static_branch_unlikely(&tcp_authopt_needed)) {
> +		rcu_read_lock();
> +		info = rcu_dereference(tp->authopt_info);
> +		if (info)
> +			__tcp_authopt_update_rcv_sne(tp, info, seq);
> +		rcu_read_unlock();
> +	}
> +}
> +void __tcp_authopt_update_snd_sne(struct tcp_sock *tp, struct tcp_authopt_info *info, u32 seq);
> +static inline void tcp_authopt_update_snd_sne(struct tcp_sock *tp, u32 seq)
> +{
> +	struct tcp_authopt_info *info;
> +
> +	if (static_branch_unlikely(&tcp_authopt_needed)) {
> +		rcu_read_lock();
> +		info = rcu_dereference(tp->authopt_info);
> +		if (info)
> +			__tcp_authopt_update_snd_sne(tp, info, seq);
> +		rcu_read_unlock();
> +	}
> +}
>

I would think callers of these helpers own socket lock,
so no rcu_read_lock()/unlock() should be needed.

Perhaps instead
rcu_dereference_protected(tp->authopt_info, lockdep_sock_is_held(sk)); 


