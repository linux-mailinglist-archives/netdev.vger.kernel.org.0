Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7D83ABCC4
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhFQTcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbhFQTcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 15:32:19 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92908C0617A6
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 12:30:10 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id h12so3471923plf.4
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 12:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hrorq9wqViQmhGOFFkZLIlBQLP9XRCmNAgszGBG5cNM=;
        b=UjhBFmj53egtMyJ00ZkClVrgAfvnWzTHeO08/1NVtWDVFp8yUJq6gbvTejf1cL8coa
         ObV+c50VD3mJAHyHt3uHFnS5r9Zpd7tJaP8Te3HYKJ3f9URNkPVzJ2Uq6wIJFO3kCGKR
         m4ob7/oHFin0TmKke8zNIXawcadc37nU0tdnQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hrorq9wqViQmhGOFFkZLIlBQLP9XRCmNAgszGBG5cNM=;
        b=ntvZ0R64BwD1VXv51UyIH820Znmx2Bi6w3cTHKschBkgX3SPHdNFIkgZdZVZzpEXYl
         GyVT5P9nH3fNXXeJQLANrB0SiHM0jWOBJ166J3Pbo4ArxPLmswKMPKLgiwPjk0Zzj3z7
         4cVHm8eoay0zrN1caFYcApL7aJ3BhcRot6mv1P7sCWNf5/3ypd0oRPveuowHnoHrLYBc
         O2x+23wjssZWpqjtCb+WlMaJxJvEWG6P3MAarlZnHe6AQzcrfHw4kzAbJXY36bbhwJkX
         OdVZ2xd1BAovaGcOLh38ORjIwUaEJI81MEYF94BPNRo3ikDdbLVjfyR3UVleNZycpXeb
         lJfg==
X-Gm-Message-State: AOAM533xfB6/51Z/26AGh1M8ZEXO/opmgVD0Vb0F+ni2WvIciMy/wP60
        nDrN896J7ctFr6ThqrUgHbkCRA==
X-Google-Smtp-Source: ABdhPJwtWc5aurHGuviL31BSdk7TdiEElg8wfkdeWP/DnCBN+SPkw5EaYw3o2oW7ePgTHEHPnG8XEg==
X-Received: by 2002:a17:90a:9f81:: with SMTP id o1mr17428279pjp.96.1623958209933;
        Thu, 17 Jun 2021 12:30:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t12sm6112590pfc.133.2021.06.17.12.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 12:30:09 -0700 (PDT)
Date:   Thu, 17 Jun 2021 12:30:08 -0700
From:   Kees Cook <keescook@chromium.org>
To:     netdev@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] mac80211: Recast pointer for trailing memcpy()
Message-ID: <202106171229.824139CA76@keescook>
References: <20210617042709.2170111-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617042709.2170111-1-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 09:27:09PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring array fields.
> 
> Give memcpy() a specific source pointer type so it can correctly
> calculate the bounds of the copy.

Hmpf, please ignore this patch; sorry for the noise. This fix got
mis-tested on my end and does not solve the problem I was trying to solve.
I will return with a v2. :)

-- 
Kees Cook
