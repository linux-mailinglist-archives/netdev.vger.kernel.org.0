Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0695E78A0
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 12:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiIWKrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 06:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiIWKrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 06:47:05 -0400
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5E9109774;
        Fri, 23 Sep 2022 03:47:04 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id u16-20020a05600c211000b003b5152ebf09so482595wml.5;
        Fri, 23 Sep 2022 03:47:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=C9Ixt7ZPmjv3wabGBTiF81Yt9jGnlGxSuwbQ49syOEg=;
        b=zeW5tSZTIkAUgXO6MoEHpqjbIw4TGFZltn6KaJxHfZzca+AjRuW5blWGwNUk3luqb2
         BCwEFh6+iHS0PQ2br9mg+Gh0FQWRSYiZ6r/VhoFf2FqgMXDw7Ke0bb3Z5lBC1N9OaWyY
         2tFliFguCaJKdVfsY1jLx+wOtKee0W18iMbXf7/1jT5i8u443kKCEGSTTvnWvFPovAg0
         ACr7R8RaMCld2OYwhWhf3opSjie/BHLHDnisVdI1l2fftuv0CNvdB8OhfTdkM6qo9REa
         Ltsg5PJgT6KFta5lDW28GJw7TAkIXctc8hsW4dnD0w/1Hy5emJY+8YjXIlo0qEXPAIbo
         6GCg==
X-Gm-Message-State: ACrzQf2UCQOo85TMYskV6R+7UKjm0q4V2PfXFJVdqXW5FyaTfM/n1uVT
        NggKW6rBvlIoOlDD3BeQIX4=
X-Google-Smtp-Source: AMsMyM58sinn3dOD8Ey7/0k7+hRpfbrgHSF5AozbhZNVJTKa3qZA7sr92yRjb4LPdGvjsnF2Q7YodA==
X-Received: by 2002:a05:600c:35c5:b0:3b4:bf50:f84a with SMTP id r5-20020a05600c35c500b003b4bf50f84amr5289326wmq.22.1663930023269;
        Fri, 23 Sep 2022 03:47:03 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id fc15-20020a05600c524f00b003a5537bb2besm2381730wmb.25.2022.09.23.03.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 03:47:02 -0700 (PDT)
Date:   Fri, 23 Sep 2022 10:47:00 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     cgel.zte@gmail.com
Cc:     wei.liu@kernel.org, paul@xen.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] xen-netback: use kstrdup instead of open-coding it
Message-ID: <Yy2OpADjx2L7WF7A@liuwe-devbox-debian-v2>
References: <20220921021617.217784-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921021617.217784-1-chi.minghao@zte.com.cn>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 02:16:17AM +0000, cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> use kstrdup instead of open-coding it.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>

Acked-by: Wei Liu <wei.liu@kernel.org>
