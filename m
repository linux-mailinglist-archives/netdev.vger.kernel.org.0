Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CC93F3056
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241382AbhHTP5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241239AbhHTP5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 11:57:09 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF34C061760
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 08:56:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j1so7588413pjv.3
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 08:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C3a7vVBUf0KW7MXt4FnTeXqGlzkeA3TVHAyOaxNZlwQ=;
        b=mWy+dsfzuC4WR7e/bELnLc1DBewBd+6uqLCiUlPpSL/hR3JFjiFZGkc64dOnkcT9C9
         qDMRqhN9IlO5CQXHcgzIx3Y2JRqX6MsEMYyUkp08whfolpRdd2uxh73eqsjx32WZPMfY
         SPWC7Ec8QNUjnKmK0pksWV2GR2YpxIveB+TMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C3a7vVBUf0KW7MXt4FnTeXqGlzkeA3TVHAyOaxNZlwQ=;
        b=TOxX/ao5wSKRP1/+9bStCRR3/v2PPAtALyvtNd0fSZGKqYZnIsZRpinq9OEFs3a7A+
         rs8AfE9GPqCDfcizigAut9LmlSxIbGPSPcnG03nwYqyzRSvQpaDCH+KL7sazYCdjC2rZ
         F4Rs/s6H9K05BOIJiZ2W2iCNhlJvJNMc7KRs8fpSKetv7hOSb3nySo3wmTpKBWU2ot+5
         7/i7VMNZbi67eLTYpvYg5xv5I7nJzndCtTeUE04hueWfufr71tgxYv2b0zAfadip5Uaw
         UwoEJAbQM6ZUYeodMZ6ak49A8AQ2d4DpvQcfv/yynAXuKsY1Ll+2HE34+8jNitT0oEvg
         vekg==
X-Gm-Message-State: AOAM533h9xEI9ZbaQAWslMCGtcia9GqAGbhIiYEZ4zobFhYYBKOIaPps
        iyuhIzgFM0R+xsX3YqU1ObwaFQ==
X-Google-Smtp-Source: ABdhPJyhg05jtv2sdt7XrLbWPk8JBbrR41kaovvHCcwZtOZ4P7Cf6Qg2VrCTEpx9+rp1igwyJ9xLVA==
X-Received: by 2002:a17:902:f704:b029:11a:cdee:490 with SMTP id h4-20020a170902f704b029011acdee0490mr17049722plo.37.1629474990741;
        Fri, 20 Aug 2021 08:56:30 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 21sm7304926pfh.103.2021.08.20.08.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 08:56:30 -0700 (PDT)
Date:   Fri, 20 Aug 2021 08:56:29 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-kernel@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 56/63] RDMA/mlx5: Use struct_group() to zero struct
 mlx5_ib_mr
Message-ID: <202108200856.E0E8711CB@keescook>
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-57-keescook@chromium.org>
 <20210819122716.GP543798@ziepe.ca>
 <202108190916.7CC455DA@keescook>
 <20210819164757.GS543798@ziepe.ca>
 <202108191106.1956C05A@keescook>
 <20210820123400.GW543798@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820123400.GW543798@ziepe.ca>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 09:34:00AM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 19, 2021 at 11:14:37AM -0700, Kees Cook wrote:
> 
> > Which do you mean? When doing the conversions I tended to opt for
> > struct_group() since it provides more robust "intentionality". Strictly
> > speaking, the new memset helpers are doing field-spanning writes, but the
> > "clear to the end" pattern was so common it made sense to add the helpers,
> > as they're a bit less disruptive. It's totally up to you! :)
> 
> Well, of the patches you cc'd to me only this one used the struct
> group..

Understood. I've adjusted this for v3. Thanks!

-- 
Kees Cook
