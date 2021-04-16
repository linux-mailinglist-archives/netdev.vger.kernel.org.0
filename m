Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A575C3628F0
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 21:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243897AbhDPTyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 15:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236363AbhDPTyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 15:54:04 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1874CC061756
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 12:53:38 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso9960576pjg.2
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 12:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4QdNLxtMyGBXnzcuFRJGiRcHb2u3OpFrU/9Q6DJdtHM=;
        b=XzsdTPW17a3D0CPunlZ/4Z5f/H9FiCbcKc7JSo7yT/4tvhMDg88Uy9/DpphB0gFPyN
         WZwYxeCI7knl4QLYflLQLThv9/rAjYkTJHWNifKWZOeDMqeAW/KK2+XPusnBD3GpPWqv
         vfePIE7jYmbgRh3hZsK+hEL+IYHJZ2tS82dcA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4QdNLxtMyGBXnzcuFRJGiRcHb2u3OpFrU/9Q6DJdtHM=;
        b=n34pkIg6XQ6PiZZt/dsgtRRYG/MiC+L0Z3TjrSO3ageYlUgxpN5zQG+PYodtnSlMg3
         6X1blkBnMrW9UBIGHVc884fwUaCYPOP2OWJTJwE6xGhiWIUx9xUCripV38ykhRejQcTW
         iIc3xg+xdfjUnJxtjLWBdqmmhSbETmbBJODcvo51/vS3R92ZJ1iXxUXBledPiMXL1XyT
         YHX6deggqFQnaqCDkPpfcg5bEs1Z2z6FsImh/F904vEdc0woYo0msCRuKe3Q2AB+wdaP
         LHdoV+gABFAmwlNpd5bKFKNOL1GvceO68so16tkZNPKsQVQuCr/lgsg7ooDk81AhQQ8C
         ss6w==
X-Gm-Message-State: AOAM533FjlltGAhKRqhp8IkNdXmWrkgthHo09VynN8wGYbFTocSoyjs2
        Z5s2xklAF9y4VkhZm15LiA0eUg==
X-Google-Smtp-Source: ABdhPJyOi0Hh1KaoxJrDOCHEREwQAXtTICn1Y0/lFNXgtHYCnfD5JLKmsk3YmfHUaTA/Thzsnhgwog==
X-Received: by 2002:a17:902:8604:b029:e6:60ad:6921 with SMTP id f4-20020a1709028604b02900e660ad6921mr11346580plo.15.1618602817589;
        Fri, 16 Apr 2021 12:53:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j10sm3733203pga.5.2021.04.16.12.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 12:53:37 -0700 (PDT)
Date:   Fri, 16 Apr 2021 12:53:36 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] sctp: Fix out-of-bounds warning in
 sctp_process_asconf_param()
Message-ID: <202104161249.D889C975D9@keescook>
References: <20210416191236.GA589296@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416191236.GA589296@embeddedor>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 02:12:36PM -0500, Gustavo A. R. Silva wrote:
> Fix the following out-of-bounds warning:
> 
> net/sctp/sm_make_chunk.c:3150:4: warning: 'memcpy' offset [17, 28] from the object at 'addr' is out of the bounds of referenced subobject 'v4' with type 'struct sockaddr_in' at offset 0 [-Warray-bounds]
> 
> This helps with the ongoing efforts to globally enable -Warray-bounds
> and get us closer to being able to tighten the FORTIFY_SOURCE routines
> on memcpy().
> 
> Link: https://github.com/KSPP/linux/issues/109
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Yup!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
