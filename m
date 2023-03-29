Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147946CD990
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjC2MsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjC2MsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:48:17 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613DB4201
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:48:10 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id cn12so62768669edb.4
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1680094089;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=7svhg9T74QRpWygHfah5JSXZ/H+9sO7+4EoAiQjiTz4=;
        b=m0VEpaU3Je25SEllE0R+65kcr98U7llLg2ERTWKlEDM1j4JP194c5yEgKScpYc37SL
         J5bNF9+Jw+Ka7Io2wpVT+e9KCW8jbrKWmxNkgLByGFaID0PFs7d5+gGU23XH7ZlOcU+T
         xLoOyLi9Ve8PZMAQRMtsgHiLWZxpMlpVS7R1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680094089;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7svhg9T74QRpWygHfah5JSXZ/H+9sO7+4EoAiQjiTz4=;
        b=dEu3nAFrnFPF4g8tYX0rvVATMRtH6b3SpM7FDRHdPbETXpCbsUUcg7DHPHCr+BXJSx
         Ystybvh7LOyRcvXjqUWZFw54JUj2x2IPR1WkDTaR25cRqTr4X6fQZpmI9Fkz2iMu+gQv
         RwBm0E33eScctKLt8ajsI1R+kzJwS1P99QDlwIoR/bYrrIk8tyBaC9Jf4bwk6e6oE/zm
         riW1Rzm5CKC9t2ouKyHdY5IFBhtrxd0Q7p+0Yd0J5Ai5G8pcaip1jBAX3p85osTEqrz/
         +rX0SZs5vctVruk4P7Uj6zNbMNU8vI1iS3D3+oDi8r9dMTtkWMCH3SbFStkUIyuz542Q
         aCJw==
X-Gm-Message-State: AAQBX9d41qHgIAie04JSjq/df1hkmwImwijRWmPRx7uete/6OuUbabWQ
        z241zUtnlOFK/CwqPs8xXnDtTA==
X-Google-Smtp-Source: AKy350aXr21bG7Scab3iNddFptSyVkyQJ0K1+wjFk2IBi4IMBneYrOQzwp9MxAjWw9agXYXZfBEOPw==
X-Received: by 2002:a05:6402:2c6:b0:4fd:236f:7d4d with SMTP id b6-20020a05640202c600b004fd236f7d4dmr18585985edx.18.1680094088874;
        Wed, 29 Mar 2023 05:48:08 -0700 (PDT)
Received: from cloudflare.com (79.184.147.137.ipv4.supernova.orange.pl. [79.184.147.137])
        by smtp.gmail.com with ESMTPSA id i20-20020a508714000000b004fc649481basm17187466edb.58.2023.03.29.05.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 05:48:08 -0700 (PDT)
References: <20230327175446.98151-1-john.fastabend@gmail.com>
 <20230327175446.98151-4-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     cong.wang@bytedance.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        ast@kernel.org, andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v2 03/12] bpf: sockmap, improved check for empty queue
Date:   Wed, 29 Mar 2023 14:24:17 +0200
In-reply-to: <20230327175446.98151-4-john.fastabend@gmail.com>
Message-ID: <87zg7vbu60.fsf@cloudflare.com>
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
> We noticed some rare sk_buffs were stepping past the queue when system was
> under memory pressure. The general theory is to skip enqueueing
> sk_buffs when its not necessary which is the normal case with a system
> that is properly provisioned for the task, no memory pressure and enough
> cpu assigned.
>
> But, if we can't allocate memory due to an ENOMEM error when enqueueing
> the sk_buff into the sockmap receive queue we push it onto a delayed
> workqueue to retry later. When a new sk_buff is received we then check
> if that queue is empty. However, there is a problem with simply checking
> the queue length. When a sk_buff is being processed from the ingress queue
> but not yet on the sockmap msg receive queue its possible to also recv
> a sk_buff through normal path. It will check the ingress queue which is
> zero and then skip ahead of the pkt being processed.
>
> Previously we used sock lock from both contexts which made the problem
> harder to hit, but not impossible.
>
> To fix also check the 'state' variable where we would cache partially
> processed sk_buff. This catches the majority of cases. But, we also
> need to use the mutex lock around this check because we can't have both
> codes running and check sensibly. We could perhaps do this with atomic
> bit checks, but we are already here due to memory pressure so slowing
> things down a bit seems OK and simpler to just grab a lock.
>
> To reproduce issue we run NGINX compliance test with sockmap running and
> observe some flakes in our testing that we attributed to this issue.
>
> Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> Tested-by: William Findlay <will@isovalent.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

I've got an idea to try, but it'd a bigger change.

skb_dequeue is lock, skb_peek, skb_unlink, unlock, right?

What if we split up the skb_dequeue in sk_psock_backlog to publish the
change to the ingress_skb queue only once an skb has been processed?

static void sk_psock_backlog(struct work_struct *work)
{
        ...
        while ((skb = skb_peek_locked(&psock->ingress_skb))) {
                ...
                skb_unlink(skb, &psock->ingress_skb);
        }
        ...
}

Even more - if we hold off the unlinking until an skb has been fully
processed, that perhaps opens up the way to get rid of keeping state in
sk_psock_work_state. We could just skb_pull the processed data instead.

It's just an idea and I don't want to block a tested fix that LGTM so
consider this:

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
