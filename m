Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743B86F0DBB
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 23:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344084AbjD0VVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 17:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjD0VVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 17:21:23 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828E73C07
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 14:21:22 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-5ef3ec38bb5so38666686d6.0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 14:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682630481; x=1685222481;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ghPSLn3O9manYCq7BMo6kZPb2Vk6PTlTwALbgxE4RYE=;
        b=RTMlNE7WtittIneuOvZUlFMTc2vRdlxtfXKe0dqWWbyAx3qtleEtgDUEyhNCSBRy+J
         F3Rowan5+Vz/j4/Vro7YW/q6atwTxP/us5uiQzadNUwkSyO9TKsX0M9js2skWFvbV+va
         Ao/KXIQj4KrUwrAhmysasiZryyL7JLv0mHiIFfW+EU5zAlcHgcUs8m5FsWBc6KEY1b0X
         Uz1KcuJFQM+Nbn6G3Da7cYh1O/D4ZCAFOCq+8iheHZKtfSLTMUwlVlnvoTHxzPE1dCJj
         MbfhGhNagzkvdJNBvq7iJLp1yNfwajVCsviYiFq5iURxZybRkFFB8KUUSZ1/d+J/Xh3M
         bj8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682630481; x=1685222481;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ghPSLn3O9manYCq7BMo6kZPb2Vk6PTlTwALbgxE4RYE=;
        b=T/fOHtAVjfl/yJDwP5psJUPbvtKYLrHextnb7L06skirFcZtzEvSYc32gkUCOuHBZl
         rRnZoa1bge6MerJw105i4HkKQRDxRxi1POlT9wak0nk9ZmObVijAzUIz4nHYXv7adYSO
         v5ilZJzxjYd5T8/Vs/RuqL6aE9WCQo5uXKWwO2vnxGefMxX0osSIzKhorF91FKpBSKHp
         1GXxd0dzdOzaPCG6TdVXIwKpfVLwcCS5psCC7mFyeXcaaER00Is8xOvMRcvo1jr/ALa3
         CyniwPNDQy/CDCOvAcCUrlgqGt/cmkI7y4ueBXoJlkBwJYOrbPyCluz8HJxrVzxPEGhz
         M29A==
X-Gm-Message-State: AC+VfDyf1kmzs7zRBUlSgb8Pz9xVA7a+N1dsfZIofvPmCSXbuAwayvb6
        o6dvmUJwy9HOL72/+MHh+PQ=
X-Google-Smtp-Source: ACHHUZ47NspusuiMCPI9e44lxSdpF0WQjcqS5PAUFZ0MHdh+O7w76q9LAe+sLeV7NaEqNuCr3Tiadw==
X-Received: by 2002:ad4:5f08:0:b0:56a:b623:9b09 with SMTP id fo8-20020ad45f08000000b0056ab6239b09mr5664768qvb.14.1682630481512;
        Thu, 27 Apr 2023 14:21:21 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id y5-20020a0cf145000000b005ef650b5e1csm5848281qvl.61.2023.04.27.14.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 14:21:21 -0700 (PDT)
Date:   Thu, 27 Apr 2023 17:21:20 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Xin Long <lucien.xin@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Coco Li <lixiaoyan@google.com>
Message-ID: <644ae750da711_26f41f294eb@willemb.c.googlers.com.notmuch>
In-Reply-To: <0fa1d0a7-172e-12ca-99c5-d4cf25f2bfef@kernel.org>
References: <20230427192404.315287-1-edumazet@google.com>
 <0fa1d0a7-172e-12ca-99c5-d4cf25f2bfef@kernel.org>
Subject: Re: [PATCH net] tcp: fix skb_copy_ubufs() vs BIG TCP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern wrote:
> On 4/27/23 1:24 PM, Eric Dumazet wrote:
> > David Ahern reported crashes in skb_copy_ubufs() caused by TCP tx zerocopy
> > using hugepages, and skb length bigger than ~68 KB.
> > 
> > skb_copy_ubufs() assumed it could copy all payload using up to
> > MAX_SKB_FRAGS order-0 pages.
> > 
> > This assumption broke when BIG TCP was able to put up to 512 KB per skb.
> 
> Just an FYI - the problem was triggered at 128kB.
> 
> > 
> > We did not hit this bug at Google because we use CONFIG_MAX_SKB_FRAGS=45
> > and limit gso_max_size to 180000.
> > 
> > A solution is to use higher order pages if needed.
> > 
> > Fixes: 7c4e983c4f3c ("net: allow gso_max_size to exceed 65536")
> > Reported-by: David Ahern <dsahern@kernel.org>
> > Link: https://lore.kernel.org/netdev/c70000f6-baa4-4a05-46d0-4b3e0dc1ccc8@gmail.com/T/
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Xin Long <lucien.xin@gmail.com>
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Coco Li <lixiaoyan@google.com>
> > ---
> >  net/core/skbuff.c | 20 ++++++++++++++------
> >  1 file changed, 14 insertions(+), 6 deletions(-)
> > 
> 
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Tested-by: David Ahern <dsahern@kernel.org>

Reviewed-by: Willem de Bruijn <willemb@google.com>
