Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF559295550
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 01:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507288AbgJUXq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 19:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507283AbgJUXq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 19:46:27 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9094BC0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 16:46:25 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o7so2452151pgv.6
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 16:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TmQP6v1B8+/tLLxrFpMrrvi5YYx2Cgo1Q1V8lX9wCpg=;
        b=Ye5ZUzA8ULWh7+72dKcjo021B5wfIpPIjBZHf4T0IlWzexHh9IGpIgEfgYKUycsN++
         OMRXTVifteoX9sHYgJYrE9BfueoTgC5tye2p0qA9yNlMTwCGySXvzoqDMRKOPvbEWOPa
         P8btVLBF8pHER7y6ATLlAXQQdMVcIHgYa/kgs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TmQP6v1B8+/tLLxrFpMrrvi5YYx2Cgo1Q1V8lX9wCpg=;
        b=Z/b1umLGCTo8TLjsLnnK3/DHbmox+jESRrZqpsToQIPwZPGuQdIInYdJqN/u2lYWap
         z7y63ZK6DCNV09mA+gcIDwlaNRJI4CYAMk1nzZipBLiUJ7VDXzu+z++3VEeBKg6/Actt
         6e/EiMSGUT7NP8CQYrckGIo/CN11FleJHL3zjsyO+dP+V2k09/dJUImn7t84a3PoHer4
         RXViRAPdPFsygdoDJ/tnqRSGnkvkErbat5FIbQgUu7LksNGCRmPr2mZJWJxbieFRmrPO
         9ywV72JkW5bRLYF6EIbxjTYSl6vMaKIqW1OCt6a3H/DXzaIVxeQYmcBjYY1ylcl0LRQw
         q8Ng==
X-Gm-Message-State: AOAM5307JeBBKmU035VGwPftPsPmboVoH3h7oR03oMwBCrDMNLyZ3X28
        gi+3HlBflglbp/PjqtLP2GTa3g==
X-Google-Smtp-Source: ABdhPJzfmxGcecuNR/Int5rEj8keHJDgbQujEogTC7Raf5VSD+STg8stH24xHynfrW1Pt0KwpZuYiQ==
X-Received: by 2002:a65:4483:: with SMTP id l3mr51203pgq.96.1603323985144;
        Wed, 21 Oct 2020 16:46:25 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w17sm3314764pga.16.2020.10.21.16.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 16:46:24 -0700 (PDT)
Date:   Wed, 21 Oct 2020 16:46:23 -0700
From:   Kees Cook <keescook@chromium.org>
To:     laniel_francis@privacyrequired.com
Cc:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [RFC][PATCH v3 1/3] Fix unefficient call to memset before memcpu
 in nla_strlcpy.
Message-ID: <202010211646.28D4C5642@keescook>
References: <20201020164707.30402-1-laniel_francis@privacyrequired.com>
 <20201020164707.30402-2-laniel_francis@privacyrequired.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020164707.30402-2-laniel_francis@privacyrequired.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 06:47:05PM +0200, laniel_francis@privacyrequired.com wrote:
> From: Francis Laniel <laniel_francis@privacyrequired.com>
> 
> Before this commit, nla_strlcpy first memseted dst to 0 then wrote src into it.
> This is inefficient because bytes whom number is less than src length are written
> twice.
> 
> This patch solves this issue by first writing src into dst then fill dst with
> 0's.
> Note that, in the case where src length is higher than dst, only 0 is written.
> Otherwise there are as many 0's written to fill dst.
> 
> For example, if src is "foo\0" and dst is 5 bytes long, the result will be:
> 1. "fooGG" after memcpy (G means garbage).
> 2. "foo\0\0" after memset.
> 
> Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>

Looks good! (If there are future versions of this series, I think you
can drop the RFC part...)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
