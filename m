Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650EA532752
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 12:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbiEXKRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 06:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiEXKRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 06:17:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31A00819A0
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 03:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653387456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CF5JW0Tl5bNXHNKC2w6ZO3hcs2dXeiNOL7Kl4K0qJxs=;
        b=EejYL1Xa4EkmiI3UQQzdykB14IU8Dk/xZJiKpViLv6i/3RAigiMvp3jIJVRzGD3SlL8muz
        ZgvGQuV2XGCVg2wgPk3xfilFqVBFmfAyHmKTKpJ4Jcu3tcK1N5IFyTAvoVJg57wYRO1eJu
        Yk/D5qnZHW1eb2+mSiX0+P1Ny+mPrhI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-UnwHiQRSOhuQTEgjbRmU8w-1; Tue, 24 May 2022 06:17:35 -0400
X-MC-Unique: UnwHiQRSOhuQTEgjbRmU8w-1
Received: by mail-qv1-f70.google.com with SMTP id j2-20020a0cfd42000000b0045ad9cba5deso12965501qvs.5
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 03:17:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CF5JW0Tl5bNXHNKC2w6ZO3hcs2dXeiNOL7Kl4K0qJxs=;
        b=uYpqWJCMvVOZ4IewpNZYR5kBw+kAfFy1bDjgOeXRz0sw6/SpC2cP3s52MP04e0IpTV
         8Ecxpl4RM57YnMAlPT2V086Xy6C3uw3m1a303HGnBStAVZBiWg40XkQss3SsjFbPQxNK
         0lWJSrrqq3a1NVf4RU99ETKdhgw9SVdTCki+e1Yfmq6kGzaKEoBLT6FugzPQaw1VYQ5i
         aB8MPACMFHbBdNuXKRt/Ixhp8y38UqFwiu6v0nLu8lsSdOEfutBCkJIvLW4Aar4b9prg
         UKe/OI+H4eW8iGGM0PvqfhBMJnD7kSXbQjuNx60cjaZMN4/deBEg5w+/hXTRMl40lmkX
         qPog==
X-Gm-Message-State: AOAM532lLHUeIdiU0w7ZW+lsSd9mq9LlkBEPbhPfA4ta/nO1SdXMn5lL
        AA60H6t66uKdP4IO4XjMr6ISIO07/eylgOkxFHyMb/dlRNjXH+wUd/mkrNpATu+R+muPFa2DCVl
        OwHPbuYGO9/FGd1ph
X-Received: by 2002:a05:6214:11e2:b0:461:c856:136e with SMTP id e2-20020a05621411e200b00461c856136emr20382636qvu.70.1653387454705;
        Tue, 24 May 2022 03:17:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxemu9sdj0x0PpEAPHoVAY+5sPIcgCKYghVpHb4BemDDETw5n16USaWrrbW65tjVZYaKM6ohw==
X-Received: by 2002:a05:6214:11e2:b0:461:c856:136e with SMTP id e2-20020a05621411e200b00461c856136emr20382623qvu.70.1653387454484;
        Tue, 24 May 2022 03:17:34 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id l84-20020a37a257000000b0069fc13ce1f9sm5831727qke.42.2022.05.24.03.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 03:17:33 -0700 (PDT)
Message-ID: <02fb40768abee44b3fe4268189449df327787972.camel@redhat.com>
Subject: Re: [PATCH net-next v2 0/2] sfc: simplify mtd partitions list
 handling
From:   Paolo Abeni <pabeni@redhat.com>
To:     =?ISO-8859-1?Q?=CD=F1igo?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org
Date:   Tue, 24 May 2022 12:17:30 +0200
In-Reply-To: <20220524062243.9206-1-ihuguet@redhat.com>
References: <20220524062243.9206-1-ihuguet@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-05-24 at 08:22 +0200, Íñigo Huguet wrote:
> Simplify the mtd list handling to make more clear how it works and avoid
> potential future problems.
> 
> Tested: module load and unload in a system with Siena and EF10 cards
> installed, both modules sfc and sfc_siena.
> 
> v2:
> * Dropped patch fixing memory leak, already fixed in net
> * Apply changes also in new siena driver
> 
> Íñigo Huguet (2):
>   sfc: simplify mtd partitions list handling
>   sfc/siena: simplify mtd partitions list handling
> 
>  drivers/net/ethernet/sfc/ef10.c             | 12 ++++--
>  drivers/net/ethernet/sfc/efx.h              |  4 +-
>  drivers/net/ethernet/sfc/efx_common.c       |  3 --
>  drivers/net/ethernet/sfc/mtd.c              | 42 ++++++++-------------
>  drivers/net/ethernet/sfc/net_driver.h       |  9 +++--
>  drivers/net/ethernet/sfc/siena/efx.h        |  4 +-
>  drivers/net/ethernet/sfc/siena/efx_common.c |  3 --
>  drivers/net/ethernet/sfc/siena/mtd.c        | 42 ++++++++-------------
>  drivers/net/ethernet/sfc/siena/net_driver.h |  9 +++--
>  drivers/net/ethernet/sfc/siena/siena.c      | 12 ++++--
>  10 files changed, 66 insertions(+), 74 deletions(-)
> 
net-next is currently closed. Please wait untill it reopens and re-
post.

thanks!

Paolo

