Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE4C5A7E23
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbiHaNAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiHaNAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:00:08 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45B4183B0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:00:07 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id y17so3809548qvr.5
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=8+8d3he1FK9Y+3M+KYUat4q11gRrHGBx+wtWcx3xYIE=;
        b=Hsvg6z3y9IEq3tVNuTEyK4G9eqq1HRJqNje4RPJaZwqoPTEvwYIbcAz/6sMPTZwP5z
         63hivda8A8tzdJLgPn4hxH6P9EbQsSLHLcQwQ+xrVyYVRGMljEJHSzqqpbJ3TyapouWB
         CkP7ykZjarSFqtEDN+lxpHXJ5z6IAAok9wCsx65m3qLp9Yp/bUxMOUHEqSCUplQOOQxt
         CxWFDZotGfVWtNA7aE6nGhztfoE7g4rCbXA+5b2uVvptCUp9cl25nDnssuUqKtm1G94P
         hEH0UlFTZ6mLesFHoWnYdsIxeE+FAm8EZSNo5D4Jt0X5N8PNxMXhMd9wy7Ez/sz1TctB
         pwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=8+8d3he1FK9Y+3M+KYUat4q11gRrHGBx+wtWcx3xYIE=;
        b=6noRPw0wkkJMosBH8AYHp1jBUkPS/XVd1jktE7UpECp7sL6eUh5hw1hfrgrpvQVUNs
         6ipwpoyuGF6cwE9qNand9Me9kNh9U4w3Wm1oPhKEi9/37FxUgolyYY2sexoWmn1Fvpqz
         IiYnW32Utsnvr8+v6RAMiAYONSa9ywV/Mzr49HsHPpOVz49YV4jh4qN7rLjin+RAlod0
         KJTxRnoy9pN0jLaMrYNFSESONIgoqox0oaKwtRPrUXUCDbIAMbBMxqZRl6bj7793HVZP
         GdhoZNNaah92KyviUDwK2k/WDrOXkhNOwyDdV7tZ+w/+CZHo179dzietoMQSQfomjANz
         Cfew==
X-Gm-Message-State: ACgBeo3eT8ENt+Pijx5hlt/lyB30doiJ1Pqu/wbimIsRVR6gsGOnoBtr
        LD7pQ+4EyDctqfIyheENqU1TfXckgJ0bXTBMzZtJ3w==
X-Google-Smtp-Source: AA6agR6jqeJahp/R7c63bb5b6A2FbNfWeFcACJm8KE+aV35j0QTPcqwlsShOQLhNoucGtmPMn+rnQKvRe4danwnwZuQ=
X-Received: by 2002:a05:6214:1c47:b0:474:8d1e:f432 with SMTP id
 if7-20020a0562141c4700b004748d1ef432mr19380866qvb.94.1661950806804; Wed, 31
 Aug 2022 06:00:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220830185656.268523-1-eric.dumazet@gmail.com> <20220830185656.268523-3-eric.dumazet@gmail.com>
In-Reply-To: <20220830185656.268523-3-eric.dumazet@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 31 Aug 2022 08:59:50 -0400
Message-ID: <CADVnQyn+SU9FM1uRM1U-t1eUGd_q2M6FS3n+71Kbmhy9OD=f2w@mail.gmail.com>
Subject: Re: [PATCH net 2/2] tcp: make global challenge ack rate limitation
 per net-ns and default disabled
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Jason Baron <jbaron@akamai.com>,
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

On Tue, Aug 30, 2022 at 2:57 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Because per host rate limiting has been proven problematic (side channel
> attacks can be based on it), per host rate limiting of challenge acks ideally
> should be per netns and turned off by default.
>
> This is a long due followup of following commits:
>
> 083ae308280d ("tcp: enable per-socket rate limiting of all 'challenge acks'")
> f2b2c582e824 ("tcp: mitigate ACK loops for connections as tcp_sock")
> 75ff39ccc1bd ("tcp: make challenge acks less predictable")
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jason Baron <jbaron@akamai.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---

Acked-by: Neal Cardwell <ncardwell@google.com>

Looks great. Thanks, Eric!

neal
