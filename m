Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7A949D5BD
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbiAZWxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiAZWxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:53:32 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6542C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:53:32 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id g9-20020a17090a67c900b001b4f1d71e4fso1022182pjm.4
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jmylYnPW0itqk7X3kALZZJzsAaqdNt+3di958skR0YI=;
        b=PHqUwsaNVoleX6lM8/jK8bmNbOWlq2er+xvJuFqzw6iPanil4hooAU8qxSxIqs3gnx
         yD9wnS+rsC5aOFii+X674igUsl6mXFK8bCd/0xiCKcYur8FlJGVHBVZctdKSCdJgYe1x
         5UnYTJIOx7UZVbzQCFMMs6OhpI24L0xOF/rR4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jmylYnPW0itqk7X3kALZZJzsAaqdNt+3di958skR0YI=;
        b=vzDdvE0amkrfJQcFHpfMria2UfdrwG2aMbHL7jGp1gnR2EwdDq+0yDSuu+0PRAMW21
         xlGOv61dO+g43HaxJxeeM/6pMy0JbjAN1hc4ZVUtdvMZWa49yGewpRbSBdZ8mB2hQgn8
         Yre3TW5Tm0KCX478WZbIwAzJbd5FiBgJcMuN/Qj8K0GTaZgTaeNEbt6bNnS2TUojlFp/
         xVyxTQZPOx+RYqFiaxNUEthaLiI1Y2+ppo4NNM8QkHMknistgo0DlS2ayEB1L4EQWpAg
         DbX9dhr2qG7tqgTP6oR+pXiUtegSEunl+WLWhRzTmbSfP20x5Pi3pQ3C6aGnSXCRyPIY
         izlg==
X-Gm-Message-State: AOAM532E3FycWUbvrZT9Wg5hQZgO+kbnSPfsvpPORh3jPaPH8EUNU0kD
        1C5ohMa8n9WKJSxmXbrKMscYuA==
X-Google-Smtp-Source: ABdhPJz0naa97lzLP+/kLQLkxJiIfooOGk727zm3c6gKvGHG1g4Up7tKbetD2ZS99Jox6VBbC04MAw==
X-Received: by 2002:a17:90b:3852:: with SMTP id nl18mr10993180pjb.228.1643237612205;
        Wed, 26 Jan 2022 14:53:32 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b14sm3246409pfm.17.2022.01.26.14.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 14:53:31 -0800 (PST)
Date:   Wed, 26 Jan 2022 14:53:31 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH RESEND] net/mlx5e: Use struct_group() for memcpy() region
Message-ID: <202201261452.97A809BE9C@keescook>
References: <20220124172242.2410996-1-keescook@chromium.org>
 <20220126212854.6gxffia7vj6cbtbh@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126212854.6gxffia7vj6cbtbh@sx1>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 01:28:54PM -0800, Saeed Mahameed wrote:
> On 24 Jan 09:22, Kees Cook wrote:
> > In preparation for FORTIFY_SOURCE performing compile-time and run-time
> > field bounds checking for memcpy(), memmove(), and memset(), avoid
> > intentionally writing across neighboring fields.
> > 
> > Use struct_group() in struct vlan_ethhdr around members h_dest and
> > h_source, so they can be referenced together. This will allow memcpy()
> > and sizeof() to more easily reason about sizes, improve readability,
> > and avoid future warnings about writing beyond the end of h_dest.
> > 
> > "pahole" shows no size nor member offset changes to struct vlan_ethhdr.
> > "objdump -d" shows no object code changes.
> > 
> > Cc: Saeed Mahameed <saeedm@nvidia.com>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: netdev@vger.kernel.org
> > Cc: linux-rdma@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> > Since this results in no binary differences, I will carry this in my tree
> > unless someone else wants to pick it up. It's one of the last remaining
> > clean-ups needed for the next step in memcpy() hardening.
> > ---
> 
> applied to net-next-mlx5

Thanks! How often does net-next-mlx5 flush into net-next?

-- 
Kees Cook
