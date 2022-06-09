Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84A8545084
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344362AbiFIPSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344425AbiFIPSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:18:35 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A4449F3E
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 08:18:34 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id j6so21314260pfe.13
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 08:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hfg/Ht6IXJkSqZsPEEqm5CiDSwSKaGYC6LLAELPZi94=;
        b=En+CCd1iCY0GZuNGBHtC/kVf1nUNuECLxJu7L6T3o0XZ+UFA3WCr5lbIMfI/9qks54
         gI/5vJ6wRH6G5rabXdhEl0R1ThSzRy5uH0wSZvjJV8Gnh4uDyI2jIfhnMHWeZM254gSa
         Cpp8t+fz69g+76OLmSPJRKLjNiEJ+ZtRUCvCXHWCYKBiR/Fx4Syw00wDlLz4o2gOrPmC
         LEhzCBmfMHYf35j60WHLdMgGg0Db0NPWiJ108lXDOa7bj8yXtidiJqlx99MLAR4rfr3j
         jN16SbKqwxvSRVVT6QNmXDNVg3VJU+LNxTJwU6FaX7cVRJyMnl7njOF71cvB3Dkm4KA8
         lgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hfg/Ht6IXJkSqZsPEEqm5CiDSwSKaGYC6LLAELPZi94=;
        b=i79mrrimHYe+g3nwwaI+CR2+3mMxCKpH4k4qKIR8beaS+reXvCmYo9giymTSMi34zg
         nG1FyYU2xXeGB2C9cNfs+e1UeJ3TA2+3L2h5TRiGJmMtD2uHjK0ErPMZPPfSudUwoKjQ
         vck2EcC/iKNk7AjuobrDHO1E3JFlaIs3LaQC21K605El2pKJiQCTDBQVkAoYOJMOicu+
         7GjSXEpZ8q8oyBnQ/t8YSxvanJOoebJ1qu9yln+etMV3UrljhgKpGTP0NJCgq+BIiVcG
         9GwhooU5ECq/EG6MAGL33iVfqxxOwZ+yPPdv6jeSlYs/f4B80zFt9ar3sQmM2vuIEKed
         HjTA==
X-Gm-Message-State: AOAM5329t/w1BxWubCazf1Tppsbup9XEi8wCN7XxMtQKxet7Tn/JyOT1
        HD+Jcjzk0Tcdk8zBXrJwO+MAv53H2QVmDptvYKPQfw==
X-Google-Smtp-Source: ABdhPJwychN9+Ua3xu7+MTFUSRrt+1QcylCZqUp6ykDm0pqKWhSqAADkDxfZ/PmsBv5qz+5ZTXRqEHI74rK4MG9Kr8o=
X-Received: by 2002:a63:86c3:0:b0:3fd:9c06:ee37 with SMTP id
 x186-20020a6386c3000000b003fd9c06ee37mr20711557pgd.357.1654787913771; Thu, 09
 Jun 2022 08:18:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com> <20220609063412.2205738-6-eric.dumazet@gmail.com>
In-Reply-To: <20220609063412.2205738-6-eric.dumazet@gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 9 Jun 2022 08:18:22 -0700
Message-ID: <CALvZod7kjOhUmsebMVtAvB-uvfXzEewXWiQ8xu+eH8mvAD6jMA@mail.gmail.com>
Subject: Re: [PATCH net-next 5/7] net: fix sk_wmem_schedule() and
 sk_rmem_schedule() errors
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 11:34 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> If sk->sk_forward_alloc is 150000, and we need to schedule 150001 bytes,
> we want to allocate 1 byte more (rounded up to one page),
> instead of 150001 :/
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
