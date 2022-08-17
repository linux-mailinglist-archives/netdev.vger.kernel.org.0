Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1063B597146
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240167AbiHQOgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240189AbiHQOf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:35:59 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392489A99E
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 07:35:47 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id j8so24864434ejx.9
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 07:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc;
        bh=aVUHgTU3ELH/Cj//SmmUAzrq9SwsvLtf9/3TUqjHnnk=;
        b=RM49JwsGG95/FmLd6xPwYkNsclfRBTcZl/R322aVArZjKPi36f/JKVDbKbTxgyNt1g
         jJUUU78s57f0RdJugfBJyiBD8sKts6AKMJTq5EZC9E19gXBUlRWL3qh3WXD4R3MbdpPY
         wH9blooYuLki6Yhhqj31Ji8XtslWfz4zKZjYI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc;
        bh=aVUHgTU3ELH/Cj//SmmUAzrq9SwsvLtf9/3TUqjHnnk=;
        b=lMFxoxhQsHWGVcYJGbe2O4TT83WIqPcZH2/b9phDx4LlG4MgvPwGQAz7K1liJ1TAwh
         OWuyPBqxDDWtqWioccdwBizTngej7gXEKEucE5xQqZDtQb6FoFb3WBV8vkcKZiOucYsu
         NByk6ypEpL1/yRniO3wsQsXCEUJnnIvWvs1IdjKmOW/DPCT+r8YG4RQeBl5XBp9CxbXg
         VT38KI7rWczIm4FDdiP7zL9YYsddeZgablTJ7t0bLU6UedRviEbOdjzmyaKC+2GKIWH0
         g6pvORXcIcJ8lVqG9I+qYkK2+lj58FoTxwLQajKnCzKO8eVqZPxgjGBQ0fEGb1SVAssW
         AOig==
X-Gm-Message-State: ACgBeo3uefeMAEAuAi6AKJXLmMZciff5+2TMe1sLrqevW+NYKkRn/RS2
        hh/QFjmyhxJjpTaiD10yCenRWZlKukEwGw==
X-Google-Smtp-Source: AA6agR7qpXOhIlQN7aASmyD4gGnSgNbWWvlmJrfTsHfKhrfCB0sPxGDsPwqXr7VTw1pjAZ+gCq+QBw==
X-Received: by 2002:a17:907:2cc9:b0:730:93c8:4177 with SMTP id hg9-20020a1709072cc900b0073093c84177mr15904051ejc.494.1660746945359;
        Wed, 17 Aug 2022 07:35:45 -0700 (PDT)
Received: from cloudflare.com (79.184.200.53.ipv4.supernova.orange.pl. [79.184.200.53])
        by smtp.gmail.com with ESMTPSA id x19-20020aa7cd93000000b0043cb1a83c9fsm10796654edv.71.2022.08.17.07.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 07:35:44 -0700 (PDT)
References: <20220815130107.149345-1-jakub@cloudflare.com>
 <20220816184150.78d6e3e3@kernel.org>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Haowei Yan <g1042620637@gmail.com>,
        Tom Parkin <tparkin@katalix.com>
Subject: Re: [PATCH net v2] l2tp: Serialize access to sk_user_data with sock
 lock
Date:   Wed, 17 Aug 2022 16:33:33 +0200
In-reply-to: <20220816184150.78d6e3e3@kernel.org>
Message-ID: <87edxfvsxs.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 06:41 PM -07, Jakub Kicinski wrote:
> On Mon, 15 Aug 2022 15:01:07 +0200 Jakub Sitnicki wrote:
>> sk->sk_user_data has multiple users, which are not compatible with each
>> other. To synchronize the users, any check-if-unused-and-set access to the
>> pointer has to happen with sock lock held.
>> 
>> l2tp currently fails to grab the lock when modifying the underlying tunnel
>> socket. Fix it by adding appropriate locking.
>> 
>> We don't to grab the lock when l2tp clears sk_user_data, because it happens
>> only in sk->sk_destruct, when the sock is going away.
>
> Note to other netdev maintainers that based on the discussion about 
> the reuseport locking it's unclear whether we shouldn't also take 
> the callback lock...

You're right. reuseport_array, psock, and kcm protect sk_user_data with
the callback lock, not the sock lock. Need to fix it.
