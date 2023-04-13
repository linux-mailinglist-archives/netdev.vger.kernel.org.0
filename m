Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39AE6E0E01
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDMNGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjDMNGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:06:36 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A52F9ECB
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 06:06:28 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id q23so27774733ejz.3
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 06:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1681391187; x=1683983187;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=pbA132ZTxFMmd4gH7ayJTiUjuR7bW8K5R/39kGlGoyo=;
        b=rpd0J7+KyBTs/v1P6ImEUVYk9NzcZqW1JbwpSJniT0VY92fjxDAEJmVFJ0MYkqsz4m
         v4LiETVmaOHLPW3BQdlLGcXZliO/HNFA5c/72DDeDJIXoe1Wtk0q4dnlGeC8GOZahpBv
         VrLNjBQmj3CaSJYK4uVL7/pDww6VyBCqINNlE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681391187; x=1683983187;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pbA132ZTxFMmd4gH7ayJTiUjuR7bW8K5R/39kGlGoyo=;
        b=JAYviYJQ8DQttlrfXFoy6sCe9XfXt8PHhDYKTT8PUsduewH4vMoQykpGaoI91whH/n
         ErC8wyeRqY0kNEZVjZCTN1vorj60xOAWjEIAHeDpqytByVpAQ1qn8ajssBeVT9aPHNjl
         2ZFIf9vf2xt2tDst6GYsypgE3q5psIoqXkM72Suw0d/AZAwL1rObAQgLWauepbsYAQIv
         xAAj9DAjXQCKgCmne1zehfvC5RohIurWZWasxFiI4LFEGWPaewgDNkbsUo+w5fv1nytI
         zY9aSdwP0r2H9igu0pBfCjoWI5g2gebIcIT8kqheOl0rMJylanYZG7nWGyRE0eEt/MBr
         J/DQ==
X-Gm-Message-State: AAQBX9cnB+3Ch4bem8474DoDvA5xbhx3OUfPK3Cj4ngx63nvdWDXUNwG
        ORR26MX2WvlojaGZH+qpwR81zQ==
X-Google-Smtp-Source: AKy350bO3OaeaNPjrERyKBdVQIOQXoe+axGQ4BhweLBG9WYBfWNyp4PyjG9dnbIqj00J9jxL5iUvgw==
X-Received: by 2002:a17:907:238d:b0:94e:83d3:1b51 with SMTP id vf13-20020a170907238d00b0094e83d31b51mr1702389ejb.23.1681391186878;
        Thu, 13 Apr 2023 06:06:26 -0700 (PDT)
Received: from cloudflare.com (79.191.181.173.ipv4.supernova.orange.pl. [79.191.181.173])
        by smtp.gmail.com with ESMTPSA id vf18-20020a170907239200b0094be906a155sm958911ejb.130.2023.04.13.06.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 06:06:26 -0700 (PDT)
References: <20230407171654.107311-1-john.fastabend@gmail.com>
 <20230407171654.107311-7-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v6 06/12] bpf: sockmap, wake up polling after data copy
Date:   Thu, 13 Apr 2023 15:00:02 +0200
In-reply-to: <20230407171654.107311-7-john.fastabend@gmail.com>
Message-ID: <87cz48gcdq.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 10:16 AM -07, John Fastabend wrote:
> When TCP stack has data ready to read sk_data_ready() is called. Sockmap
> overwrites this with its own handler to call into BPF verdict program.
> But, the original TCP socket had sock_def_readable that would additionally
> wake up any user space waiters with sk_wake_async().
>
> Sockmap saved the callback when the socket was created so call the saved
> data ready callback and then we can wake up any epoll() logic waiting
> on the read.
>
> Note we call on 'copied >= 0' to account for returning 0 when a FIN is
> received because we need to wake up user for this as well so they
> can do the recvmsg() -> 0 and detect the shutdown.
>
> Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

One observation. On the happy path, we will be hitting the recently
introduced sk_data_ready tracepoint [1] twice. However, we have the
caller IP there, so we can differentiate.

[1] 40e0b0908142 ("net/sock: Introduce trace_sk_data_ready()")

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
