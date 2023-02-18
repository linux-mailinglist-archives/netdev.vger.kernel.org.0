Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9A969B788
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 02:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBRBlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 20:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBRBlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 20:41:24 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB956781C
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 17:41:23 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id x5so3224742plg.9
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 17:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=oogzPbvNKdlyH3pCyb8+mgn22tc6UsTxha9LEalS1lM=;
        b=YPvXP0N3nrToYLB1Q7fl1FvevE41a4CFCxXK8c1kcSrGqzz9W8TsIyvsj3QubBYkcZ
         QBO8osNDtX2TOWcOV0Mr4l/B9BSQID9E+ON8IvklVTTPGXd0dhBkR4rhV0WSV9jayTJ6
         iXvFGqEjkMfx/qXAI7BWFEOF2qtMqpY17ZObs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oogzPbvNKdlyH3pCyb8+mgn22tc6UsTxha9LEalS1lM=;
        b=RySo0ROP6khzf6EsEwUMaP9YqSB1PCD3NvWm6sxA1K/77NkI2IU35cMVJuvNEUB4Tl
         2hqMXuMZq86SwoZGiBeVWPx+NmCced4ReoOgiXiquszz5Bj+WKOcAg1wBnIAvKhIzSdM
         H2OeDs6nxEm7+b3ytzJEG/td4eSHnXtchoWs9GlM4gdyxYIg5teygi959SOI7lKB5nZ1
         eB+C+GWbi8/8NaLCbgbMNosjNlkRRhf6lPwtiA3vz644uMIej9DOXCXnOY0Bwq6z27S5
         gOSP+fGnJ/ECF6K1/sOy2L1DU6OPwfDFhSs9BkzmY3SWYaUzIQkD6BlO5SnAxGOigm1v
         +UIg==
X-Gm-Message-State: AO0yUKVxIZBqvuvjIWgsIFReFlQkPS4MkLcjKG31xj9c6+42LwsbrvKA
        B+5t+hSLCAEkpMySvkorbMltIw==
X-Google-Smtp-Source: AK7set/GoMnyoaKJSSjm8reSkvO2GPwX9UP1aWiFFm8nMPDaEFnVf1toHJCOXTTQelsay3VWmXRmKw==
X-Received: by 2002:a17:903:1111:b0:19a:9880:1750 with SMTP id n17-20020a170903111100b0019a98801750mr3447307plh.53.1676684483196;
        Fri, 17 Feb 2023 17:41:23 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id 19-20020a170902c15300b0019ac23cb6edsm2066454plj.181.2023.02.17.17.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 17:41:22 -0800 (PST)
Message-ID: <63f02cc2.170a0220.5e28e.4a53@mx.google.com>
X-Google-Original-Message-ID: <202302171740.@keescook>
Date:   Fri, 17 Feb 2023 17:41:21 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] scm: add user copy checks to put_cmsg()
References: <20230217182454.2432057-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217182454.2432057-1-edumazet@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 06:24:54PM +0000, Eric Dumazet wrote:
> This is a followup of commit 2558b8039d05 ("net: use a bounce
> buffer for copying skb->mark")
> 
> x86 and powerpc define user_access_begin, meaning
> that they are not able to perform user copy checks
> when using user_write_access_begin() / unsafe_copy_to_user()
> and friends [1]
> 
> Instead of waiting bugs to trigger on other arches,
> add a check_object_size() in put_cmsg() to make sure
> that new code tested on x86 with CONFIG_HARDENED_USERCOPY=y
> will perform more security checks.
> 
> [1] We can not generically call check_object_size() from
> unsafe_copy_to_user() because UACCESS is enabled at this point.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
