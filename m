Return-Path: <netdev+bounces-10501-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B4F72EBE1
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:24:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81B60280F13
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6503B8D4;
	Tue, 13 Jun 2023 19:24:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D6F17FE6
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:24:52 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913D71FF0
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:24:46 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-652a6cf1918so4573143b3a.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1686684286; x=1689276286;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hW07/KxIwpPsYdFA9lPkBZ4Xt/G7PhfjivAGs4nndnM=;
        b=QklL5AG1tnpVT2frkelZwrvdvjq6NFTrjc5Tvszw/aY/f3B3LALEwyX5gYg+7k89GF
         3cHjdzapmDZJt99ue2P72ax0cIVA9VO9+o5PHgSe42jmMAUnIiY+ghg7elKePQGvMEZ+
         oSz1rroYJAyibfzgpXQPviHZwRvqIKvQ1tbW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686684286; x=1689276286;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hW07/KxIwpPsYdFA9lPkBZ4Xt/G7PhfjivAGs4nndnM=;
        b=cXRmNfadgvt/hV28JYzserqdp/KuKXwSYeXcNbGcs/1fB+/bl+stIey0IT9m6WKbN/
         FCwnVF55WEPTUbuOlk1x8pZO4yVRZ051k9lGoub006m0ld8xQZZlUOPM0T97E0NFcKmw
         1rUztVk7jUoypj1gxuf+lxHjiUhSBl/rhDyVJYMttzgP+p0LE8THijFVZBYHzvIePDqU
         OFe6S6dniR22Ooeknq55kbvTGkh1a9OsZbtNU/W9Qd6DSZX2KMzAXBRB/8xY2Iu1oNcA
         MRDrt5yp4AzZ5GgUfVnZpjPuFZk/4maLiA/o0knIPwNzr8g6f5NSMHbBwFsM0Y9bp1lz
         5tCA==
X-Gm-Message-State: AC+VfDwjjySmF8NXDk/+opfs85v/X91/oJbkn40QKeIEoyq/NyR1OuUE
	5EZZPSQN5lo7DQCdL5Zo15lbYQ==
X-Google-Smtp-Source: ACHHUZ5nGaJQrazHitO9RBRakIkNp+QjgEC3mKbozW40uweFVPJxBHm2vmipYf4h5+/k8wqt0EJcMQ==
X-Received: by 2002:a05:6a00:1826:b0:63b:854e:8459 with SMTP id y38-20020a056a00182600b0063b854e8459mr17087049pfa.31.1686684285923;
        Tue, 13 Jun 2023 12:24:45 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a16-20020a62bd10000000b0065ecdefa57fsm8952203pff.0.2023.06.13.12.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 12:24:45 -0700 (PDT)
Date: Tue, 13 Jun 2023 12:24:45 -0700
From: Kees Cook <keescook@chromium.org>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-hardening@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH] cfg80211: cfg80211: strlcpy withreturn
Message-ID: <202306131224.338EAD654@keescook>
References: <20230612232301.2572316-1-azeemshaikh38@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612232301.2572316-1-azeemshaikh38@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 11:23:01PM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> 
> Direct replacement is safe here since WIPHY_ASSIGN is only used by
> TRACE macros and the return values are ignored.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

