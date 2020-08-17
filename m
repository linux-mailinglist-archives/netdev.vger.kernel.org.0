Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F94424776D
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732756AbgHQTs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732769AbgHQTsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 15:48:39 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5CBC06134A
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 12:48:37 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id c10so8324349pjn.1
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 12:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W/QCwiSnTEO13wgX75lDPlG5RmKP/R2S9uafXZLpRO0=;
        b=UZMS8z7lBaBA4LaD7Ohc3gxbh3X0rGAieTpTrrDzaTy+L/gk/lug1xgLnT6Smuoqgy
         CHwvwC1+iVsaCi7JVANoAoODFUU1FJ8zXIuuSAZC1c3zP9Ppej9evmz4cKmc9teJMKuJ
         YXU186IAT+sMfmef2ecFE4SzXZGPKU6LCfYIk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W/QCwiSnTEO13wgX75lDPlG5RmKP/R2S9uafXZLpRO0=;
        b=R2yS9nWK61V/SyYP7TsegMFwQgzN1AVaDxcqL7KiZVeSZ/JSZyqzVj7NBfS9fPd2yz
         UePkXTLOqqS4kXtl7X02Bx5Cy6K8LKbgpv1ze6f4V3nBXTyln2D2kzstt/3eCUZn23l+
         isj9m0Vp5/Rw5lQjomncXLzhyDKp2jACl2VThgVDzMeyaPf8mDOqe6bS5lV5wL4up8HE
         GReW9gpqRlfw6RQyD2S7ezyRWafAZPHFKS0PraUoBYsypuAC0wemPmCEVFymxCQWyiZW
         Yid3xJTqiBQoUQeRlPi7Phc5tJxpinxpkEgV8h1CPtvzr9JYLRTHRsbMuTBPNa2sW51V
         Av+w==
X-Gm-Message-State: AOAM5310JB+s66Ws0YIDjRG2fMxzILqBkhrIyft/J7HWtm2Cl+aFf4U6
        ZUZa2YiJvYJE6hSI2dgYN6dN9g==
X-Google-Smtp-Source: ABdhPJwZjwvbowwXe6l+/LTbIcm9qla8iNV/iD/KGyHP8Hful5P2qYDZAoSGXyDA4rfCIhlfdBeTKA==
X-Received: by 2002:a17:902:246:: with SMTP id 64mr12417474plc.70.1597693716088;
        Mon, 17 Aug 2020 12:48:36 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s8sm21663342pfc.122.2020.08.17.12.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 12:48:35 -0700 (PDT)
Date:   Mon, 17 Aug 2020 12:48:34 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Allen Pais <allen.cryptic@gmail.com>, jdike@addtoit.com,
        richard@nod.at, anton.ivanov@cambridgegreys.com, 3chas3@gmail.com,
        stefanr@s5r6.in-berlin.de, airlied@linux.ie, daniel@ffwll.ch,
        sre@kernel.org, James.Bottomley@HansenPartnership.com,
        kys@microsoft.com, deller@gmx.de, dmitry.torokhov@gmail.com,
        jassisinghbrar@gmail.com, shawnguo@kernel.org,
        s.hauer@pengutronix.de, maximlevitsky@gmail.com, oakad@yahoo.com,
        ulf.hansson@linaro.org, mporter@kernel.crashing.org,
        alex.bou9@gmail.com, broonie@kernel.org, martyn@welchs.me.uk,
        manohar.vanga@gmail.com, mitch@sfgoth.com, davem@davemloft.net,
        kuba@kernel.org, linux-um@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hyperv@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-s390@vger.kernel.org,
        linux-spi@vger.kernel.org, devel@driverdev.osuosl.org,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] block: convert tasklets to use new tasklet_setup() API
Message-ID: <202008171246.80287CDCA@keescook>
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
 <20200817091617.28119-2-allen.cryptic@gmail.com>
 <b5508ca4-0641-7265-2939-5f03cbfab2e2@kernel.dk>
 <202008171228.29E6B3BB@keescook>
 <161b75f1-4e88-dcdf-42e8-b22504d7525c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161b75f1-4e88-dcdf-42e8-b22504d7525c@kernel.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 12:44:34PM -0700, Jens Axboe wrote:
> On 8/17/20 12:29 PM, Kees Cook wrote:
> > On Mon, Aug 17, 2020 at 06:56:47AM -0700, Jens Axboe wrote:
> >> On 8/17/20 2:15 AM, Allen Pais wrote:
> >>> From: Allen Pais <allen.lkml@gmail.com>
> >>>
> >>> In preparation for unconditionally passing the
> >>> struct tasklet_struct pointer to all tasklet
> >>> callbacks, switch to using the new tasklet_setup()
> >>> and from_tasklet() to pass the tasklet pointer explicitly.
> >>
> >> Who came up with the idea to add a macro 'from_tasklet' that is just
> >> container_of? container_of in the code would be _much_ more readable,
> >> and not leave anyone guessing wtf from_tasklet is doing.
> >>
> >> I'd fix that up now before everything else goes in...
> > 
> > As I mentioned in the other thread, I think this makes things much more
> > readable. It's the same thing that the timer_struct conversion did
> > (added a container_of wrapper) to avoid the ever-repeating use of
> > typeof(), long lines, etc.
> 
> But then it should use a generic name, instead of each sub-system using
> some random name that makes people look up exactly what it does. I'm not
> huge fan of the container_of() redundancy, but adding private variants
> of this doesn't seem like the best way forward. Let's have a generic
> helper that does this, and use it everywhere.

I'm open to suggestions, but as things stand, these kinds of treewide
changes end up getting whole-release delays because of the need to have
the API in place for everyone before patches to do the changes can be
sent to multiple maintainers, etc.

-- 
Kees Cook
