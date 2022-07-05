Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30362566472
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 10:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiGEH5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 03:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiGEH5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 03:57:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F09E13DD2
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 00:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657007843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4XBDh+zEGZ5o8UoLa4apznuCuZsaSPIlgF8wyp0KnIE=;
        b=USyDPH6nSSUdN+Y8ccHfL4h+iL9lDxz4Ci8IfgLkVSaebZiH4xTgeJUZdkJNm6V8cl+Vqb
        WFYy1eEjgYHWu4bjIBq5MuMCuckULZxfUTTmBHuux32jBUgE3bZMqmgOBHVhAC0mUWod4y
        MvgYX+Tmyuwt5udRPDVv/lJijX28Flo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-LdeO78MvNZOMqZOdOBG1NQ-1; Tue, 05 Jul 2022 03:57:19 -0400
X-MC-Unique: LdeO78MvNZOMqZOdOBG1NQ-1
Received: by mail-wr1-f72.google.com with SMTP id q12-20020adfab0c000000b0021d6dcb51e8so681058wrc.13
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 00:57:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4XBDh+zEGZ5o8UoLa4apznuCuZsaSPIlgF8wyp0KnIE=;
        b=gjYR/8WnxMg55IiG0fbNEjAjWIp4xsYZh8a7sj+9mC3gHnAVI2/3M+rDvtGaRdrjIS
         wSb7TjLQH+zz3ZyBsD0Z7slAOZdSlDxC4n34/0LILWjEEoth49OxEGO3e0FvpkX75SYO
         jyZSUIwvvzCrqFkzgvRtry5Ru6FiNo5dhGBM9S85Z04H4fLl1evcS6LPrcIyQk4RDZzg
         iVbvkK02yGYT1QdHOb+L+Ao4PGM7p5dW0M3eXEZg7/1lxo6ewI89Oi6VkHFtfv/ORnrF
         G4xvuDyOf0uJ07mmV5uOtCjcof6BnKc8dv7tZr0+3fAjf2vKM3wrOhrgFGV3efgzKo/k
         ikMw==
X-Gm-Message-State: AJIora9NF61DOuFmbtHo0UtsrW6JF+v0OwdKaX9kSVVQAtuxJ0fBdbRS
        bEKQuCRvCwrXalUKroStqXZtwLMnDSHMfs757x1zJBwpQdzB3JczYezhaPqp18+gy7tTmOwr/PG
        Gekwr748EKAupOhag
X-Received: by 2002:a5d:4b87:0:b0:21d:7019:80c6 with SMTP id b7-20020a5d4b87000000b0021d701980c6mr3246010wrt.234.1657007838739;
        Tue, 05 Jul 2022 00:57:18 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1srZ5SgK6E6X/MdfrwnMv5KGU1tZEV2rfNlBcEfHAkMazjJ9cSQP1jpGmMWi0WEfAfQaOVapg==
X-Received: by 2002:a5d:4b87:0:b0:21d:7019:80c6 with SMTP id b7-20020a5d4b87000000b0021d701980c6mr3245999wrt.234.1657007838565;
        Tue, 05 Jul 2022 00:57:18 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-106-148.dyn.eolo.it. [146.241.106.148])
        by smtp.gmail.com with ESMTPSA id l3-20020a1c7903000000b003a04962ad3esm18896002wme.31.2022.07.05.00.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 00:57:18 -0700 (PDT)
Message-ID: <8d19ca4c115784346ad30f8581ee93436f1f3043.camel@redhat.com>
Subject: Re: [PATCH net-next] net/mlx5: fix 32bit build
From:   Paolo Abeni <pabeni@redhat.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Date:   Tue, 05 Jul 2022 09:57:17 +0200
In-Reply-To: <20220705073928.22icbhqtc4gvak6j@sx1>
References: <ecb00ddd1197b4f8a4882090206bd2eee1eb8b5b.1657005206.git.pabeni@redhat.com>
         <20220705073928.22icbhqtc4gvak6j@sx1>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-05 at 00:39 -0700, Saeed Mahameed wrote:
> On 05 Jul 09:17, Paolo Abeni wrote:
> > We can't use the division operator on 64 bits integers, that breaks
> > 32 bits build. Instead use the relevant helper.
> > 
> > Fixes: 6ddac26cf763 ("net/mlx5e: Add support to modify hardware flow meter parameters")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> 
> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> sorry for the mess. I sent v2 too soon, forgot to squash the 2nd fix to it.

No problems, it happens. 

Unless someone raises some concerns soon, I'm going to merge this one
well before the usual 24h staging time, to keep PW and the tree okish.

Cheers,

Paolo

