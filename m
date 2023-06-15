Return-Path: <netdev+bounces-11228-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89EB17320E0
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:23:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF16E281334
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 20:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5868125DF;
	Thu, 15 Jun 2023 20:22:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D6BEAFF
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 20:22:56 +0000 (UTC)
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEBC2D4C
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:22:35 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id ada2fe7eead31-43f44f5f8f2so956287137.0
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1686860555; x=1689452555;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nTDMiwhHPsAwdJFirW06ShL7Xv0zpUkZAjJMx62b6kk=;
        b=ckiPObyl5/7+AxK59NIagxkAyyLywji11RqCe9EHjlI6FyO/euo/kWgf3tEkGjFV1t
         p4DIyNplEY0DDyWDE+c0XxR6xHzzS118ddUITiQrIKQxmtaez2oz5H/z5kLs9hZTWQS9
         3rOIo3Vl4IortJLrycXDPYm4fgZ3aWx7ZzT90=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686860555; x=1689452555;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTDMiwhHPsAwdJFirW06ShL7Xv0zpUkZAjJMx62b6kk=;
        b=d6AUY2Y+TTyj4KvWG6Ud+o5A/mW0SWLjpBb734uE7faK2k4ZXG4pvSZnPZF1wVuDoc
         wuaM0gwJld5lwb8iUrRu9thbO0RHoMRy+OHLPXxn3S33FOZeLNcpFI9WQ/aNMzcLFmjV
         h1+rTonKQW1Mji+3y4YARjmhB8+QoeHGOs4KIbZXXwlT+fCbDKa6nAstoZb1QWk8ctwt
         rJy7aCqWHDwYdaRABlwNmM6cgoqRBZdq3E6feDWc1aFHWhec9jOqGiNxoODzVRYdsS4V
         bBnoWZb0IfMvv5vrJ31qNODLNvVAY4QbmGt4Qnp0SegTljPW5duFJ/NPhelBVOjVKgK4
         kjaw==
X-Gm-Message-State: AC+VfDy5MFojnqCoyDoY7ZEmCAD2TGTG7vBTflWjaIQbPsHbSO5paAZl
	kN6A5N2/jCOm2jEcA1kWLxIG4A==
X-Google-Smtp-Source: ACHHUZ7RHgjgywDAdkFR/dhfhPvezalUlxG7PfIMpiix0p1FRgfKZJjNDG5wJXECTPzCCbo6eNvcZA==
X-Received: by 2002:a67:f601:0:b0:438:e102:9c13 with SMTP id k1-20020a67f601000000b00438e1029c13mr358422vso.27.1686860554923;
        Thu, 15 Jun 2023 13:22:34 -0700 (PDT)
Received: from meerkat.local ([209.226.106.132])
        by smtp.gmail.com with ESMTPSA id z9-20020ad44149000000b0062824b0517fsm6086080qvp.67.2023.06.15.13.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 13:22:34 -0700 (PDT)
Date: Thu, 15 Jun 2023 16:22:28 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: patchwork-bot+netdevbpf@kernel.org, davem@davemloft.net, 
	netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com, dsahern@gmail.com, 
	"helpdesk@kernel.org" <helpdesk@kernel.org>
Subject: Re: [PATCH net-next v2 0/2] net: create device lookup API with
 reference tracking
Message-ID: <20230615-praying-viper-e71c8b@meerkat>
References: <20230612214944.1837648-1-kuba@kernel.org>
 <168681542074.22382.15571029013760079421.git-patchwork-notify@kernel.org>
 <20230615100021.43d2d041@kernel.org>
 <20230615-73rd-axle-trots-7e1c65@meerkat>
 <20230615131747.49e9238e@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230615131747.49e9238e@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 01:17:47PM -0700, Jakub Kicinski wrote:
> Oh, that could well be it, I did! Linus asked people to do that
> recently, I think in the -rc4 email. One of the RC emails, anyway.
> IDK how many people listened to Linus. Technically it only matters
> for maintainers who may send PRs to him, otherwise he said his diffstat
> will be different than the one in the PR.
> 
> But it's not just me:
> https://lore.kernel.org/all/168674222282.23990.8151831714077509932.git-patchwork-notify@kernel.org/
> https://lore.kernel.org/all/168661442392.10094.4616497599019441750.git-patchwork-notify@kernel.org/
> (there's a third one but it's is also Matthieu so CBA to get the lore
> link, we're just counting people.)
> 
> Could the bot try matching in histogram and non-histogram mode?

Yes, I'll see if I can teach the bot to regenerate the diff with --histogram
when there is no match.

-K

