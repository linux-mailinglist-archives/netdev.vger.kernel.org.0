Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D2A429EDF
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 09:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbhJLHrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 03:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234082AbhJLHrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 03:47:05 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BCAC06161C
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 00:45:04 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id z11so75220891lfj.4
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 00:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=9Q9SuO5C0iwIKXcp9Q9f5rj29mbddspWpU7SkymsaQY=;
        b=N+RkAQfRZjNhGe/LRXQX/vfUeRRe/2ocYAfu/hjDQ1EJKCLTr+8fdEi3Z9z/AskaQB
         t9mzoV3BRb0TeBGM8kJkr0UIQ2d5xwdnR2e2dRKtnO5fWj5wBY+YlABp3KFK1pkc/o3L
         5X1yO/DrMdBcEi6ImcrRk2oMH67c0wpEZFKNk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=9Q9SuO5C0iwIKXcp9Q9f5rj29mbddspWpU7SkymsaQY=;
        b=k2i9Pxjo2zFvR5iRbElAjWS1exnZLn0EEc4Q5u5uX7G+8i6za5E/DU9QiMLNsmiQsy
         6FgmhIGtvniygYlxWLbTEbx0C2VctDfpJ1NABLnOF0hRGfHJW75xxk3thmW5r6JzcCib
         T3sQdLUtIDNA9S8ilvKK6REHZxL1ailWnqVNvCDWsL1jdKcXxhVrtrABfw1v19GiJYIq
         plKWjVzchjaOaGcHhQkborpGfyP6PCItRtUJAd4zEef2rSj6jgosHNrmU0hZPT+3WfcM
         o7Ll5q9q0b7WEkBf5TKUjT3iOBWixtekCfh8UpD3w5UMu/Epwkr34Jrjvge7xHv7nE7B
         a6dQ==
X-Gm-Message-State: AOAM530Wt2U75L8UJ5Fihhrk1RLkGxmzngITJU87rM6hn0qGXY4Vk8Y1
        lFh9zeIvzN324elenK8ctzpc0w==
X-Google-Smtp-Source: ABdhPJw4KnqaR+4CKcH38sB0dURaJ7ebz4zp8Ww09NWvO0OY7hQ6buvStGWBoz+P4ZdV+If3QTNc/w==
X-Received: by 2002:a19:4409:: with SMTP id r9mr8213422lfa.683.1634024702310;
        Tue, 12 Oct 2021 00:45:02 -0700 (PDT)
Received: from cloudflare.com ([2a01:110f:480d:6f00:ff34:bf12:ef2:5071])
        by smtp.gmail.com with ESMTPSA id q12sm1092759ljg.19.2021.10.12.00.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 00:45:01 -0700 (PDT)
References: <20211008203306.37525-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [Patch bpf v4 0/4] sock_map: fix ->poll() and update selftests
In-reply-to: <20211008203306.37525-1-xiyou.wangcong@gmail.com>
Date:   Tue, 12 Oct 2021 09:45:01 +0200
Message-ID: <87y26yg002.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 10:33 PM CEST, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> This patchset fixes ->poll() for sockets in sockmap and updates
> selftests accordingly with select(). Please check each patch
> for more details.
>
> Fixes: c50524ec4e3a ("Merge branch 'sockmap: add sockmap support for unix datagram socket'")
> Fixes: 89d69c5d0fbc ("Merge branch 'sockmap: introduce BPF_SK_SKB_VERDICT and support UDP'")
> Acked-by: John Fastabend <john.fastabend@gmail.com>
>
> ---

For the series:

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
