Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CC73E31C6
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 00:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245532AbhHFWad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 18:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245512AbhHFWac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 18:30:32 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649CDC0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 15:30:16 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id i10so9006943pla.3
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 15:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6t4R3/clPInEWqQYAYEqGtfb7Px8wNaCjYlpj80+2H8=;
        b=KzU0uWQel4rrqucZdeNEFegtyMHl2eu1JNNVShfFEqSIZQRwT9iIriyUSrEtpZic3k
         xGxqvfScDKAIukCjdhuRPVuxXq1bn5BBIFzAWjRZHxpKhDPQbRw8G6JLb+nhuFX04iXD
         dzpXkbjuO3UPaRbJ37MGU7vlcPgt8zRMN2W2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6t4R3/clPInEWqQYAYEqGtfb7Px8wNaCjYlpj80+2H8=;
        b=Mq/ixKNUOXQuwI5J+Xf0rE6AnkHk5KdhHJJpDzbIlvybW77GXSR6ZIx1jc86jXgh/E
         5/8NcZ+Ue4ChxzGN0lR2bKhdGYgt7WCuQd1ztDaTixIXnC/0AKjA2+3Nf/Xu1hLOC3X7
         2QfwF17eEC0N3Qj5MbvquWZyBZin6ceoGgLIyIKNA1FH0GXERt8TsOw2BVXTLHytVira
         XNAUM8snOMnMOKxeBH9qY2Cn6EcjqaxoGpFY3GjbcnigGnECUIv7Q17KTB0iHhxpHvjK
         ADw2ud/XfLjlvOX8ktLeh3WGOXong1iJq+838CZvmhy6g2ZQwx1GaXRQFZLLIH3gq6lR
         CyJA==
X-Gm-Message-State: AOAM531S4VhaVtAOZbm0PDl6/t3TUveyvsLbBNr2NmVv7iXGTIxZAQgz
        yfWTbUS6FJ3CVQiYCWjleL11ZQ==
X-Google-Smtp-Source: ABdhPJzJNM8Y2Fq8MMmxSifX6jMF7S2TiaF1k771cOv/hwziioYA+1qaKgY1XfHH80q4W3Y3DA4Nvw==
X-Received: by 2002:a62:3342:0:b029:3b7:6395:a93 with SMTP id z63-20020a6233420000b02903b763950a93mr6951533pfz.71.1628289015923;
        Fri, 06 Aug 2021 15:30:15 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 2sm4058945pfe.37.2021.08.06.15.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 15:30:15 -0700 (PDT)
Date:   Fri, 6 Aug 2021 15:30:14 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] ipw2x00: Avoid field-overflowing memcpy()
Message-ID: <202108061529.07216CBF7@keescook>
References: <20210806200855.2870554-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806200855.2870554-1-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 01:08:55PM -0700, Kees Cook wrote:
> -	if (element_info == NULL)
> +	if (!element_info || info_element || info_element->len != size - 2)
>  		return -1;
> -	if (info_element == NULL)
> -		return -1;

Gah, a let a typo in. (should be !info_element.) v2 coming...

-- 
Kees Cook
