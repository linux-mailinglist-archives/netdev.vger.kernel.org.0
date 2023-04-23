Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056FD6EC17F
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 19:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjDWRyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 13:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDWRyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 13:54:52 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291D310D4
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 10:54:51 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-95369921f8eso532793566b.0
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 10:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1682272489; x=1684864489;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ajc3OSoJBNJY54dtxIfH8gJgclQJ17/OnLquSrnGNHs=;
        b=aKnhENXaISvHLpuTquFn+OXkK6mk2sADL9n5xWaVwf0ERvQfoHbHWf+uuh1C+dkzIo
         6KWXVLtM/gVrF7GJzzN2vWQIsHiabNol6X/jR3q5glkK0ch2hRAea76cpiHNQ8EaeQkT
         if8h/4is2R3zcGDJ3I37WLoqn8+qPOMu8zLkQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682272489; x=1684864489;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ajc3OSoJBNJY54dtxIfH8gJgclQJ17/OnLquSrnGNHs=;
        b=k6wL4Y3ophy6zjTO/3t7Y1LWgqmqqyiKqZ4bFOGs5qv646JLTTpivN9MT+h1RmPKrR
         ZUq6eo4uLRj2vF4ZaDJT2nSMgDIOfQfm/5eQ42kCprVADE8Yu0LCmxNaDBf2U8/z9LHA
         uLv1O+bT20Da/wvz7hDgsoLCX52EYpp5A3mQkm4tXhQe6La2rKzuQVZy2ghOxxkU1Lwk
         o5FXCee6veVGgqoCkWWu+a3c9ckC5FozAJh62cuJdyNLBzn23LBw9AXsQinGjzXVC3JK
         v2vyWA6CHu/a+uzb3S22i/mgG4kJ3gdfONPL70JDO3KUUDcb/SQeQUOLK0k3lXVfYIJb
         ahng==
X-Gm-Message-State: AAQBX9dr2L5Iibg9urlHwDiW5bshu3h+Z5r8/AXwzB/TaLlTi5gtwnp/
        SBU8GK1CaHmsvDvp1sE7KZuLGc3y2AoALUgF9mTraw==
X-Google-Smtp-Source: AKy350apjWESRQzvKjFeX4OMuu62saFs+BoarRrJkYJDQ7dRJK3pY+dDKEoG0AHSGUmIE6E65Bq6Jofvwgq/cVB2Wms=
X-Received: by 2002:a17:906:7a16:b0:94e:f738:514f with SMTP id
 d22-20020a1709067a1600b0094ef738514fmr8673988ejo.13.1682272489621; Sun, 23
 Apr 2023 10:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230423075335.92597-1-kal.conley@dectris.com>
In-Reply-To: <20230423075335.92597-1-kal.conley@dectris.com>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Sun, 23 Apr 2023 19:54:38 +0200
Message-ID: <CAHApi-k1myxp5wqh4ojLKmVQyY=UG8hNT4Vk5c1V22Ua_i2kvA@mail.gmail.com>
Subject: Re: [PATCH] xsk: Use pool->dma_pages to check for DMA
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Compare pool->dma_pages instead of pool->dma_pages_cnt to check for an
> active DMA mapping. pool->dma_pages needs to be read anyway to access
> the map so this compiles to more efficient code.
>
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

I forgot to specify the target tree. This patch should be applied to bpf-next.
