Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10D450F9C4
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348325AbiDZKKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348309AbiDZKK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:10:29 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39153203F64
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 02:33:38 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id n32-20020a05600c3ba000b00393ea7192faso1142485wms.2
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 02:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=QVmFXOUKgYe9HzYV1uXfVn9Q6oM24hbwGSBlkuukiUk=;
        b=XxAfZRH55ufxZ3xvIhLw62TEKAdSZwJPTTpE7ZAx6BN/+Z+r3OXvfqmIEuhxYd2T7P
         j6SiGN9SQ2l+wEYLeKiPK9iApIu+n9PENzikZZz2W4KJwdgBtANJrdgR52hvh01S1UHg
         rvbcVshcTHFm8kr78VMR2U4uLtQq0i70PbyOw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=QVmFXOUKgYe9HzYV1uXfVn9Q6oM24hbwGSBlkuukiUk=;
        b=SI1z5pJdQnxEqB5jPpxI0l5PB76dtfJfY/E4dfNXh9dFGFaAfToIMaK3glGVkqtDqW
         h6gZqoDoPXFkdqzLxvyRWjvMNw/dYuWijblswWP1ycuQuVpOvtxgRYh0T3H1iYAIHyZx
         JOcqMEctsim25RCNxHH8k5Jvxt+o4Qnh0SxLEFGssTB6ilQe7jw4uD9FcZCr7jQ+m9uW
         APXxW1G+UUw+WTfqKCfpxdLHmNHvIsOc5ipfU5NQEHitgpZWSAusCMavAo7yYJxtEnJ9
         Fdr7VsBRjBOP+IFRr4SOfM5uPCdoPpnfkzP7P5VN0UdqLC/95FyuP3yxIKJVp776cNv3
         q02g==
X-Gm-Message-State: AOAM5303cDuR6DiJCWEAIA4IK/dxnTq9Vjq3K7Mt0KI9iqAngHiK0ZGU
        +INsj7DCf0HixRUhjInU+9AbSA==
X-Google-Smtp-Source: ABdhPJztUrsjinJeRPI8NhkLXuhlonHUrvrOClMy0jGOzEJrh8/CdwAkeIYdU0SNc51D9oP9PLT6Hg==
X-Received: by 2002:a05:600c:354e:b0:393:ef51:c87d with SMTP id i14-20020a05600c354e00b00393ef51c87dmr5506659wmq.189.1650965616547;
        Tue, 26 Apr 2022 02:33:36 -0700 (PDT)
Received: from cloudflare.com (79.184.126.143.ipv4.supernova.orange.pl. [79.184.126.143])
        by smtp.gmail.com with ESMTPSA id f20-20020a05600c155400b00393efff7c29sm3194301wmg.19.2022.04.26.02.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 02:33:36 -0700 (PDT)
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [Patch bpf-next v1 0/4] sockmap: some performance optimizations
Date:   Tue, 26 Apr 2022 11:27:24 +0200
In-reply-to: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
Message-ID: <878rrs6vf4.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 09:10 AM -07, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> This patchset contains two optimizations for sockmap. The first one
> eliminates a skb_clone() and the second one eliminates a memset(). After
> this patchset, the throughput of UDP transmission via sockmap gets
> improved by 61%.

That's a pretty exact number ;-)

Is this a measurement from metrics collected from a production
enviroment, or were you using a synthetic benchmark?

If it was the latter, would you be able to share the tooling?

I'm looking at extending the fio net engine with sockmap support, so
that we can have a reference benchmark. It would be helpful to see which
sockmap setup scenarios are worth focusing on.

Thanks,
Jakub
