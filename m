Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E354843BEA7
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 02:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbhJ0A4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 20:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbhJ0A4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 20:56:41 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2931C061570
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 17:54:16 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso798643pjb.1
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 17:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AZZfYvGwkg3nwWqA/abdbx0UHUemCKF136uh2Mq//oM=;
        b=ToZS0eSXJX7ZgbB8JVwZTsEqp3eLsSOZePaoTUiLHP0PhX3cchPpwvGTRGdJyjlo8M
         GKGQlSHYPRm/rxHDUBqti+nckvS40gwIONARojW9VEoo68nY9+jWlXssBXub8Z9Kpkqw
         r8Vfbx7KY0LzoSHDg/dc/T8fgOTBfMRIGdpWjeMin1TKFzzQQ9mB7XKyhCpKXDyjt9IM
         2gTsSjFZq0xQiaKlNi4SNFYpoq1Dwl8TA8WD1N0vf7IW/ccb5+ptgL5uQcQK39Myyb+W
         wBQjuR/svRkSI9+awpz4oj1Hfg2xgRIu7VHmbEbpc1rQGhvexDvnQ05W2eFMNH0xCEYA
         RF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AZZfYvGwkg3nwWqA/abdbx0UHUemCKF136uh2Mq//oM=;
        b=HkudK50A2JG71X1KGlK1P2+Kl16OvNHarrx4w5PnH0suhlBKGeyZks5uXGHCCLc6sG
         0hbRVBCanorEFVRgv8XyRkrVzIP5YLJcRvKFOrNs4+oDnh+bm+6pTx+Z98DKI35Oy9+O
         PxNBc/CtBu7/CnHrSmzDdUmBmLezsqR2kC2nnj3r8LjqJSGpuUetolYgsHoNSWkNRlm8
         x6qN6FADP1/1JIqu9cZm2VX1SoXlTk6FXa1oTXuXqBZXefw0gbf6YjR5ZgZocIqeL7/h
         E35Yf4Yp6Ly+K4U40Ae+BaFb+H2QoHK/6c724E6ZU2E53iELgb2hpjQnTdZR6WemEsYI
         02rA==
X-Gm-Message-State: AOAM531ovATl7Bo9bFlNdap3gzOyge1J8UMCdRnqqceaxziTatPsWpMR
        FD3HZtocOdHnnXUJRHgPR/0=
X-Google-Smtp-Source: ABdhPJxOP4ks5uLhmMjCVmBR2pc9XIFKa7LwLr7QlexMyqni/iMVmiMsFQN7ZJYHPS2yc6TSqJEfzg==
X-Received: by 2002:a17:90a:2c02:: with SMTP id m2mr2328312pjd.109.1635296056211;
        Tue, 26 Oct 2021 17:54:16 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id t11sm8678837pgi.73.2021.10.26.17.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 17:54:15 -0700 (PDT)
Subject: Re: [PATCH net-next v3 04/17] mptcp: Add handling of outgoing MP_JOIN
 requests
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org
Cc:     Peter Krystad <peter.krystad@linux.intel.com>,
        eric.dumazet@gmail.com, Florian Westphal <fw@strlen.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
References: <20200327214853.140669-1-mathew.j.martineau@linux.intel.com>
 <20200327214853.140669-5-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bbbc234b-c597-7294-f044-d90317c6798d@gmail.com>
Date:   Tue, 26 Oct 2021 17:54:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20200327214853.140669-5-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/27/20 2:48 PM, Mat Martineau wrote:
> From: Peter Krystad <peter.krystad@linux.intel.com>
> 
> Subflow creation may be initiated by the path manager when
> the primary connection is fully established and a remote
> address has been received via ADD_ADDR.
> 
> Create an in-kernel sock and use kernel_connect() to
> initiate connection.
> 
> Passive sockets can't acquire the mptcp socket lock at
> subflow creation time, so an additional list protected by
> a new spinlock is used to track the MPJ subflows.
> 
> Such list is spliced into conn_list tail every time the msk
> socket lock is acquired, so that it will not interfere
> with data flow on the original connection.
> 
> Data flow and connection failover not addressed by this commit.
> 
> Co-developed-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Peter Krystad <peter.krystad@linux.intel.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---

...

> +/* MP_JOIN client subflow must wait for 4th ack before sending any data:
> + * TCP can't schedule delack timer before the subflow is fully established.
> + * MPTCP uses the delack timer to do 3rd ack retransmissions
> + */
> +static void schedule_3rdack_retransmission(struct sock *sk)
> +{
> +	struct inet_connection_sock *icsk = inet_csk(sk);
> +	struct tcp_sock *tp = tcp_sk(sk);
> +	unsigned long timeout;
> +
> +	/* reschedule with a timeout above RTT, as we must look only for drop */
> +	if (tp->srtt_us)
> +		timeout = tp->srtt_us << 1;

srtt_us is in usec/8 units.

> +	else
> +		timeout = TCP_TIMEOUT_INIT;

TCP_TIMEOUT_INIT is in HZ units.


> +
> +	WARN_ON_ONCE(icsk->icsk_ack.pending & ICSK_ACK_TIMER);
> +	icsk->icsk_ack.pending |= ICSK_ACK_SCHED | ICSK_ACK_TIMER;
> +	icsk->icsk_ack.timeout = timeout;

Usually, we have to use jiffies as well...

> +	sk_reset_timer(sk, &icsk->icsk_delack_timer, timeout);
> +}
> +
> 

I wonder if this delack_timer ever worked.

What about this fix ?

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 422f4acfb3e6d6d41f6f5f820828eaa40ffaa6b9..9f5edcf562c9f98539256074b8f587c0a64a8693 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -434,12 +434,13 @@ static void schedule_3rdack_retransmission(struct sock *sk)
 
        /* reschedule with a timeout above RTT, as we must look only for drop */
        if (tp->srtt_us)
-               timeout = tp->srtt_us << 1;
+               timeout = usecs_to_jiffies(tp->srtt_us >> (3-1));
        else
                timeout = TCP_TIMEOUT_INIT;
 
        WARN_ON_ONCE(icsk->icsk_ack.pending & ICSK_ACK_TIMER);
        icsk->icsk_ack.pending |= ICSK_ACK_SCHED | ICSK_ACK_TIMER;
+       timeout += jiffies;
        icsk->icsk_ack.timeout = timeout;
        sk_reset_timer(sk, &icsk->icsk_delack_timer, timeout);
 }


