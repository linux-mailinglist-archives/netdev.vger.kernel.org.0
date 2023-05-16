Return-Path: <netdev+bounces-3079-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A41F07055D7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C5BC2810D7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA753112B;
	Tue, 16 May 2023 18:18:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701E1171CA
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 18:18:55 +0000 (UTC)
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A046A271B
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:18:52 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-517bdc9e81dso7802251a12.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684261132; x=1686853132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pq51/Winy9tdcJdkE3nX1hb1YAR26qiq1QbsKMiUQjw=;
        b=AuNGp7s324pQNR2JPDgYdg7zfF+tEhSJf0t28tdXYYYMmv/8pBaVhUHtuA+q1FrMW3
         GMEecbPpxUfA178sTXMsn1KyAXESzSdPtK8bOSNFMllkT+3myhspkehizpQ7//V4/VoP
         F+ZU5Of6qzXcmAeTdYreTpyPTLR67UyOHb9x4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684261132; x=1686853132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pq51/Winy9tdcJdkE3nX1hb1YAR26qiq1QbsKMiUQjw=;
        b=fvj6pEe5DGrMMIlctlL0ZvBXbHK7TZigqchtluuYX+n024JE9OzIExe5s5ZAewS/tA
         tF5yHp8ow2tKeRzaiUoe81sUJShMMi0J6+JOUY5WL0krgSID1/wfCC37Uqp6Gp93PG0d
         n58wXoklBxfxX1YUv//ImBo04km5DIHvv0n8A12tSkXJA21KiO+JTB5DDzOsSmiD1+E1
         Qtoasg0pHMbAxbdufqtOH24jWf/f+TmrEbQ7Yqt7j1M+fIKhpZT19/FTdPvyfgkWN+Fu
         fZWhyvb1GEs+MhyjWmyT8Z11n+lTGrmGdKJwIg9J/8CnpLcrgFCWnrDyXAIw1ecD6Pn6
         NwmA==
X-Gm-Message-State: AC+VfDxBxahnDz6Ft5Pahi8HjePqeNBTyswlWEXBvXp5+2W6rwTu30mC
	s9Mz8yfFO8C9lVZq/HW3mYQ9AA==
X-Google-Smtp-Source: ACHHUZ7zQa6U94ltPkX3/irOR0s/5miFSFka1PrbPo9jaHvLLlTA+6024nF3xbiAQB4c1NJ6cN+qqQ==
X-Received: by 2002:a05:6a20:914f:b0:106:ff3c:be9b with SMTP id x15-20020a056a20914f00b00106ff3cbe9bmr3263460pzc.7.1684261132182;
        Tue, 16 May 2023 11:18:52 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id z24-20020a63e558000000b0050a0227a4bcsm13895907pgj.57.2023.05.16.11.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 11:18:51 -0700 (PDT)
Date: Tue, 16 May 2023 11:18:51 -0700
From: Kees Cook <keescook@chromium.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	mlxsw@nvidia.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] mlxfw: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <202305161118.86AD596@keescook>
References: <ZGKGiBxP0zHo6XSK@work>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGKGiBxP0zHo6XSK@work>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 01:22:48PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations alone in structs with the new DECLARE_FLEX_ARRAY()
> helper macro.
> 
> This helper allows for flexible-array members alone in structs.
> 
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/285
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

