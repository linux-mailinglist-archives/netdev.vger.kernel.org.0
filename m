Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14316D4315
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbjDCLMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjDCLMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:12:15 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4391F12073
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 04:11:49 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x3so115677688edb.10
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 04:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1680520306;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=4ZRh2XQyIvIwD7cqmGWwOTXCG6mNEaPqsaGSyOgg7i4=;
        b=n0hy6/6JIlQMRkVpsji5O/0qByX6i5cmJmOgStebSf/Eb7LsNl2kfeDqoFsJ/D9VCB
         cnM9t9ddqk5UI6NcpvgNVeEmpbszVlYJfgyK1bXOKsc2w6BF4nHV9Uzv9wYHvP5h+WFw
         wu7CJIi6A0BSWBAjUQAjdwilWZfeCFu0/jXY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680520306;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ZRh2XQyIvIwD7cqmGWwOTXCG6mNEaPqsaGSyOgg7i4=;
        b=QuoorzcMufACsFUqdddYZgsCBAoYbEN0rdbgEBNVi6X8uTyPiV1WfXDA2lmvTpiHJq
         z5vIYBzW1lIenIVH7sMalZw2KdHgMCRBoYjDCJpe3ezRO7WUTpAJ5nybZ2NihFiV+894
         kdvbhieTgDR+MulCnsA8HRO0KJWdvSkZuH0MoTZ8xflR2ZF6WLc3De7qyFiPmlaREngg
         sY4ZEr0S5hakyavBBrlJBHQxZxtGkeZVraGiYTPT21kAuappC8kIZeP9C6KeDMmnxQZ0
         CO2oZ0A+ePxS9ZOxl42+G1T53jDI2mJK6X6cgRFGQCkJ6qaglHwtj6XwQbPAsxMZTVKH
         FNvQ==
X-Gm-Message-State: AAQBX9ftVA1UgNo0E4am96UvAXeLRtqsXiBnO0lqWHm2BVPX7/CdqVBj
        KlQ1zoV8s6SOL7j4l02TqlnnwsCTDhS6FjQ9xWs=
X-Google-Smtp-Source: AKy350anEoDP359aHJUBzytOzEWbBgIfBALZFpTy999DQOdoE68VVg6Q0J8X1Xa+C+jfH1VtJQo6VA==
X-Received: by 2002:aa7:d052:0:b0:4fb:54b7:50ea with SMTP id n18-20020aa7d052000000b004fb54b750eamr34365689edo.21.1680520306197;
        Mon, 03 Apr 2023 04:11:46 -0700 (PDT)
Received: from cloudflare.com (79.184.147.137.ipv4.supernova.orange.pl. [79.184.147.137])
        by smtp.gmail.com with ESMTPSA id m30-20020a50999e000000b005027d31615dsm4090409edb.62.2023.04.03.04.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 04:11:45 -0700 (PDT)
References: <20230327175446.98151-1-john.fastabend@gmail.com>
 <20230327175446.98151-5-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     cong.wang@bytedance.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        ast@kernel.org, andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v2 04/12] bpf: sockmap, handle fin correctly
Date:   Mon, 03 Apr 2023 13:11:07 +0200
In-reply-to: <20230327175446.98151-5-john.fastabend@gmail.com>
Message-ID: <87a5zpdxu7.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 10:54 AM -07, John Fastabend wrote:
> The sockmap code is returning EAGAIN after a FIN packet is received and no
> more data is on the receive queue. Correct behavior is to return 0 to the
> user and the user can then close the socket. The EAGAIN causes many apps
> to retry which masks the problem. Eventually the socket is evicted from
> the sockmap because its released from sockmap sock free handling. The
> issue creates a delay and can cause some errors on application side.
>
> To fix this check on sk_msg_recvmsg side if length is zero and FIN flag
> is set then set return to zero. A selftest will be added to check this
> condition.
>
> Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> Tested-by: William Findlay <will@isovalent.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/ipv4/tcp_bpf.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index cf26d65ca389..3a0f43f3afd8 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c

[...]

> @@ -193,6 +211,19 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
>  	lock_sock(sk);
>  msg_bytes_ready:
>  	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
> +	/* The typical case for EFAULT is the socket was gracefully
> +	 * shutdown with a FIN pkt. So check here the other case is
> +	 * some error on copy_page_to_iter which would be unexpected.
> +	 * On fin return correct return code to zero.
> +	 */
> +	if (copied == -EFAULT) {
> +		bool is_fin = is_next_msg_fin(psock);
> +
> +		if (is_fin) {
> +			copied = 0;
> +			goto out;
> +		}
> +	}
>  	if (!copied) {
>  		long timeo;
>  		int data;

tcp_bpf_recvmsg needs a similar fix, no?
