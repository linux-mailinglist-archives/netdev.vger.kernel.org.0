Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD085A2311
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiHZIcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343655AbiHZIci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:32:38 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EA8D4F62
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:32:37 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z6so1083179lfu.9
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc;
        bh=whIFQOhtEwkaxyVIOBIsuBVRmzcDd9uMyC0fMfZtn3o=;
        b=rJ4cDz4EeZd+3kpdN2X+kI2php9ywC5GrXqCYpAHdmi61z3E1vWbrO4EtHPr4uvgXn
         YP19hWCdjR7tIsP+VOkWGiCbCQ5Z56v0krOyJFJrz8BcGQSQjHJrE0dH+E9MwtW4wcDS
         kewv3++Zr2/BFOqIuKzW+o272B4V6GzsW3Zns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc;
        bh=whIFQOhtEwkaxyVIOBIsuBVRmzcDd9uMyC0fMfZtn3o=;
        b=iGlwVsREEeREHGVodzvVp6ZcZhbOY4wFxGHYXcjSLBiDUzcCIj2REG1QVC1Iyo+ibs
         7NtghsO1X86Pdi8SYleIUzzUZFMY7GeFxEAEqGEzq33faWriLEykPY4g96bA2eYBy+6A
         eo3fsYBO02TvfhhZjuaDR+OElydsg4dd6QK5wDf3gaIyC4miDPEUOTBn7e7uzh8yTbS+
         SKkhaj7rZ8XZK9felWr+/Lm2bebyyFPIqTclxAWUW2ps5JuqtWnGflhf6g3iEDghCcLh
         MYggNk/1hsQ3mIJnOZiTTNZif3wnpoGaFfJX0qWM9zP84aQx8J6RMEFOW+2PEiwZUAE+
         hjIA==
X-Gm-Message-State: ACgBeo2ZUN+jT9P1YZib9hVxg0sX1C4Rolc05zjIgu73zCGbWlnbwwP+
        Xb6ljV9GE3ksTqJ0u65QYA4wQg==
X-Google-Smtp-Source: AA6agR5bgSBabyrKS3NHz0tnfOYPbkExZlJsqUyBngNp+rioY0Mtu5AVhdNt+IoY8hDIfGaJVVaA8Q==
X-Received: by 2002:a05:6512:228a:b0:492:b7cd:9599 with SMTP id f10-20020a056512228a00b00492b7cd9599mr2015038lfu.625.1661502755044;
        Fri, 26 Aug 2022 01:32:35 -0700 (PDT)
Received: from cloudflare.com (79.191.57.8.ipv4.supernova.orange.pl. [79.191.57.8])
        by smtp.gmail.com with ESMTPSA id u26-20020ac258da000000b00493050d6bcesm303821lfo.122.2022.08.26.01.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 01:32:34 -0700 (PDT)
References: <20220823101459.211986-1-jakub@cloudflare.com>
 <97b1225e848caf6034aa68ef8bc6ded3823a8149.camel@redhat.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Parkin <tparkin@katalix.com>,
        Haowei Yan <g1042620637@gmail.com>
Subject: Re: [PATCH net v3] l2tp: Serialize access to sk_user_data with
 sk_callback_lock
Date:   Fri, 26 Aug 2022 10:32:22 +0200
In-reply-to: <97b1225e848caf6034aa68ef8bc6ded3823a8149.camel@redhat.com>
Message-ID: <87ilmf9zha.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 12:23 PM +02, Paolo Abeni wrote:
> hello,
>
> On Tue, 2022-08-23 at 12:14 +0200, Jakub Sitnicki wrote:
>> sk->sk_user_data has multiple users, which are not compatible with each
>> other. Writers must synchronize by grabbing the sk->sk_callback_lock.
>> 
>> l2tp currently fails to grab the lock when modifying the underlying tunnel
>> socket. Fix it by adding appropriate locking.
>> 
>> We don't to grab the lock when l2tp clears sk_user_data, because it happens
>> only in sk->sk_destruct, when the sock is going away.
>
> l2tp can additionally clears sk_user_data in sk->sk_prot->close() via 
> udp_lib_close() -> sk_common_release() -> sk->sk_prot->destroy() -> 
> udp_destroy_sock() -> up->encap_destroy() -> l2tp_udp_encap_destroy().
>
> That still happens at socket closing time, but when network has still
> access to the sock itself. It should be safe as the other sk_user_data
> users touch it only via fd, but perhaps a 'better safe the sorry'
> approach could be relevant there?

Fair point. Let me add that.
