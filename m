Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F69456404
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbhKRU1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbhKRU1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 15:27:47 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0782BC06173E
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:24:47 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so6765595pjb.5
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CEafYW8MRPioqBfCFfvnxWXpVAk39JOdxhJVb0fOQkY=;
        b=Sw62I7t1cdcpXan5SayiXVjr/5iY+VKSj2lYRGp/j6eQqGrOxw6a+EU5F+IKg0kz8+
         JrUUjTzQ2Isahb3AaCCt15ecvJa+4HldPbAg6wOyLD2uGupXwoJu18jChqklHGYc6jNk
         v35yp61ICOlp9N5XKOWdgEzQcSepkDOcblwFU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CEafYW8MRPioqBfCFfvnxWXpVAk39JOdxhJVb0fOQkY=;
        b=P2FXMjTSsI+1RbA9ZEa1nenuLl0+/KqwzvgLkI4Vmkpkx6jfefTI46lSGy6v3lj+my
         5mlKpE7iLBx59yr1KQcs/+qg2BTcHEDKFO5yl+O1D7KD2yCCM37pbuS3MbKIiy2ZYgwC
         86TOKjcQ0pDe1u2uIxSag9GCc4nwmGHD3lLfgpILpEB3zYlFHP4KxqvrVvRE3Ha/Qiof
         xXvooWy+mO7J1vq1wOYvUOIdduZfX9gOC+QffjqWTr6k6HM/eI/U6dsDG7V1a1UOpkmo
         4eKW0FHBaqjlyzRx8SurhhVdISr3LfwrV8j+hNUM2F60FNe9Davc3IvKHJVqUYWIbMUq
         j06A==
X-Gm-Message-State: AOAM530hi6SdQ6phpV1jbuHutpYo5AKL/bw2H6w0jYBDK0UUpp4T+QmP
        MUL2ppyWnjezcXTsWeL2CI5T5w==
X-Google-Smtp-Source: ABdhPJx+qW3BdCcTIQ2RRhn4T6dCDiRVxu5WiBUgQ5rCtldmeKk2WVhbYUniT3Al+20iaaxV4a/97A==
X-Received: by 2002:a17:90a:9bc1:: with SMTP id b1mr13821277pjw.49.1637267086584;
        Thu, 18 Nov 2021 12:24:46 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k22sm433163pfi.149.2021.11.18.12.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 12:24:46 -0800 (PST)
Date:   Thu, 18 Nov 2021 12:24:45 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        wengjianfeng <wengjianfeng@yulong.com>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Allen Pais <allen.lkml@gmail.com>,
        Zheyu Ma <zheyuma97@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] mwl8k: Use struct_group() for memcpy() region
Message-ID: <202111181224.21692AAF@keescook>
References: <20211118183700.1282181-1-keescook@chromium.org>
 <147e31ef85dbbdf87d6785b6a28229de81f8af6c.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147e31ef85dbbdf87d6785b6a28229de81f8af6c.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 08:45:22PM +0100, Johannes Berg wrote:
> On Thu, 2021-11-18 at 10:37 -0800, Kees Cook wrote:
> > 
> > -	__u8 key_material[MAX_ENCR_KEY_LENGTH];
> > -	__u8 tkip_tx_mic_key[MIC_KEY_LENGTH];
> > -	__u8 tkip_rx_mic_key[MIC_KEY_LENGTH];
> > +	struct {
> > +			__u8 key_material[MAX_ENCR_KEY_LENGTH];
> > 
> 
> That got one tab too many?

Whoops! Thanks, I will adjust. :)

-- 
Kees Cook
