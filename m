Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD09D6742D1
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjAST2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjAST2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:28:52 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193988A4A
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 11:28:51 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id d62so3879394ybh.8
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 11:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cqISzIUGrl/A/ZAbqmDSIpJgNb8+FjySKE7pKuglkKY=;
        b=JBFG/rHyucmf3Gp68qWHJlS8lj34fFR2LQta1NsvCOzGoXxzqw0zyYrqEUEJ3azP6A
         wYLXICu+5A7EtnihRNVc5czsyz+x81Ov87ZA5Ac8LZMweqfrEqeGfzkL2/YFJeiA6m4N
         OYFhELmGN/bwGM6PI6kis4xRTLQr0HqHaWshDfoUH4qPYzg2kvx9uQAYHNDWOQ531vGp
         gWkN1k/L96B6v1bJ4s3UebFyEP60QCvb/PtiKU9gwlHBYBadYBgSz/VrHsM2OKpR0F1M
         CcFH5YByGj9m0MAwUfdxC9pArgBxQdYv09ZJcWkQD6fwBwZnb1WDTSMbhuYmj/peKImm
         J5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cqISzIUGrl/A/ZAbqmDSIpJgNb8+FjySKE7pKuglkKY=;
        b=14UAfQ6t+ECYlye69WQG1s0gzqD1Aq/OoajrQzpIKFuzk3vJv7cj5cQbnHIAQp8O4G
         TTet4GJ6faodDs40Z1RmrXOdU6eeG4A1FxMUWhwZe4cuRGmaogHY7XEx/8PC8BtjZ0yZ
         mInJAvde5r1JP3YU+xLb4LluclvZDaZPp7XxMs0g1W3c8wOl0nnvp7iTVzPBMpWV9GuI
         rKqNZTi0p13nqFcZAiD6OvSbBoDHptCoeutWoxcrCSpJY64rZyZV+IdXTExKygeqGAhM
         Jgkp4nbg8PHlJfSRkMT3k6m4WdJ/7ij5QRptR1dXRj0+Vq+NWyUa/lPWvFghHeJLqhVk
         jeDg==
X-Gm-Message-State: AFqh2krYU90FdAPwD8G+NuO9f68Bb/20xzoU3pcKjERK+47zZ5hMswUE
        G9xngFswUEhJGIaIGGwl5acZCqcZe0iVTxwhO3tvsg==
X-Google-Smtp-Source: AMrXdXuEfrEPy7gEwxr4o/Z9drafJvEUkMqmLIaexU9Js9sAY2EG41BUTgLfhjHCf7uLI/qQ99mu/jc/kBQ3Yp41Gfo=
X-Received: by 2002:a25:bf8e:0:b0:7d7:ec44:7cdc with SMTP id
 l14-20020a25bf8e000000b007d7ec447cdcmr1346852ybk.598.1674156529969; Thu, 19
 Jan 2023 11:28:49 -0800 (PST)
MIME-Version: 1.0
References: <20230119190028.1098755-1-morleyd.kernel@gmail.com>
In-Reply-To: <20230119190028.1098755-1-morleyd.kernel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 19 Jan 2023 20:28:38 +0100
Message-ID: <CANn89iJNZ8K7=NjwQE4TnSFgfj=2OWGnk3ozqVbPR=nXnw=56g@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix rate_app_limited to default to 1
To:     David Morley <morleyd.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Morley <morleyd@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 8:00 PM David Morley <morleyd.kernel@gmail.com> wrote:
>
> From: David Morley <morleyd@google.com>
>
> The initial default value of 0 for tp->rate_app_limited was incorrect,
> since a flow is indeed application-limited until it first sends
> data. Fixing the default to be 1 is generally correct but also
> specifically will help user-space applications avoid using the initial
> tcpi_delivery_rate value of 0 that persists until the connection has
> some non-zero bandwidth sample.
>
> Fixes: eb8329e0a04d ("tcp: export data delivery rate")
> Suggested-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: David Morley <morleyd@google.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Tested-by: David Morley <morleyd@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.
