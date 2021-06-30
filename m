Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11C43B7FE2
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 11:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhF3JX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 05:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbhF3JX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 05:23:57 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C66C06175F
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 02:21:28 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id h6so2312069ljl.8
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 02:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=0bgZwa4+MDdMGBtJ8KpBWEqd1dAeuKVVmAXrR5/PinE=;
        b=EEHK0RGTk3ViFVH1QaQoJEyzNlOU12OwZ/tm20dS8E9AHeybmvaFsZJLfahN5/wuaQ
         2UTghkPXBmKqYnHrSAgNh4mY5GnsaWYuCE4+1RJsOG44GfhpmStOoPrigjU6EDSKTwzN
         0uRXiQ3+tm5ndNZkJ7Zcu9MDZP+XO4o5VC6ys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=0bgZwa4+MDdMGBtJ8KpBWEqd1dAeuKVVmAXrR5/PinE=;
        b=j7l/Wgdl6fZpYCmaPHXhb8Zcf9vS4Z+waLYXdQEY10a7wd/FXXkHAJjgXsE981iFHE
         O5P3OMVJceYkyAJRWYQ0sMfFPA//ofJ0TPxJYRalmANj55grpR71v3s9qA+GSd/SMtng
         DXJGEyxL2N6xM4unQMtV+J27U20aKIv8Q+VqZCqWUk056ClbtAVXp/7P9xYD7+j8V9R8
         OWC9KwZ9JbRIusMwE8P9tEeMxNmJYfeIfkVqv7wpLNwbtZZrpcvx90A9rGsjcmHnk4Qa
         QzLs5k4DHDJhyKnkyZgC4C3lAqy+8rEu7KMl2CjmPB8u1ye2MTWTwya/hFIGKMigQurc
         tHrA==
X-Gm-Message-State: AOAM5338/6wMIpnjWo11FENhAygbSqnn0A+JzxdCQcQiQmjlGWDXtt0v
        cjLw5/3KBSo7NmdeSZe3Kk9+kw==
X-Google-Smtp-Source: ABdhPJyFBzQBHwTVCQ+0nwODrze7uFbsDwv47P6JzI3uSnqJBwH6MAcX1twT4v1dfepFo2H2jrOl7w==
X-Received: by 2002:a2e:a78d:: with SMTP id c13mr7442575ljf.0.1625044887228;
        Wed, 30 Jun 2021 02:21:27 -0700 (PDT)
Received: from cloudflare.com (79.191.58.233.ipv4.supernova.orange.pl. [79.191.58.233])
        by smtp.gmail.com with ESMTPSA id i130sm1866108lfd.304.2021.06.30.02.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 02:21:26 -0700 (PDT)
References: <20210629062029.13684-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf] skmsg: check sk_rcvbuf limit before queuing to
 ingress_skb
In-reply-to: <20210629062029.13684-1-xiyou.wangcong@gmail.com>
Date:   Wed, 30 Jun 2021 11:21:25 +0200
Message-ID: <878s2rso6i.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 08:20 AM CEST, Cong Wang wrote:

[...]

> @@ -854,7 +854,8 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
>  		return -EIO;
>  	}
>  	spin_lock_bh(&psock_other->ingress_lock);
> -	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
> +	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED) ||
> +	    atomic_read(&sk_other->sk_rmem_alloc) > sk_other->sk_rcvbuf) {
>  		spin_unlock_bh(&psock_other->ingress_lock);
>  		skb_bpf_redirect_clear(skb);
>  		sock_drop(from->sk, skb);
> @@ -930,7 +931,8 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
>  		}
>  		if (err < 0) {
>  			spin_lock_bh(&psock->ingress_lock);
> -			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
> +			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED) &&
> +			    atomic_read(&sk_other->sk_rmem_alloc) <= sk_other->sk_rcvbuf) {
>  				skb_queue_tail(&psock->ingress_skb, skb);
>  				schedule_work(&psock->work);
>  				err = 0;

I belive access to sk_rcvbuf should be annotated with READ_ONCE (for
KCSAN's sake) as we don't lock the egress socket. See 8265792bf887 [1]
("net: silence KCSAN warnings around sk_add_backlog() calls") for
guidance.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8265792bf8871acc2d00fd03883d830e2249d395
