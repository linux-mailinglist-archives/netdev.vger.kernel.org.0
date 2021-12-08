Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C75446D87D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhLHQiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237168AbhLHQh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:37:58 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7A9C0698E1;
        Wed,  8 Dec 2021 08:34:19 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id v22so2682632qtx.8;
        Wed, 08 Dec 2021 08:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fZ+UEDFWYDtdt3RuvVkF5d4dwCHaHV08LnSRgVmg96g=;
        b=kC18tGS9OVnQ4GsU2iqaZc8wonlJNXITmUAwmpIDecalLYKYDO8BhejF+vMfDxbIPg
         uG5HzvepnyHGMLP0PjrXj3nOYEz5gKBMsXfxyNP0xWAt7TfE31qalzZ6m7lCr6TrC9hV
         2/kak8bsqgzECu4QiGBQn2lA6rHdK1YDEZxC3OAtaTlETUMQPB++qP/IIPPZEm/yIuBh
         6Q0OLxYKMnCXvJxyaKUvfkIwy1bADYAs47A1a8fWj4minRMY91YocOZ4sC2WH3z7wqDg
         NXYMxAdBulE+40b7/mBXEie5nRonA38byXjjFY67q+eHy6raNUV1D0ShwLMAqzrTljNd
         +nGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fZ+UEDFWYDtdt3RuvVkF5d4dwCHaHV08LnSRgVmg96g=;
        b=rmv5okPF6NuNBgNP0EnwQVI+PIdG+xAhTrNwWVpInKxOqRJelWOxqe8fKO0NT3yQu7
         JwG9f41xo1eBaGdYVqN/3WPQEscwlV9WLpMt96V2ZO3N1D7mfQu8emtPmzbGrf3cFcq6
         EVn1Pf0yANMJxuOg9qs70pYiCJnmksxk6xC/2xYCrv+wGe8R7cBlowW1LAyXg2lKSC2K
         /9+/A1McCKujny43a3cwqG5yU7w+4+GEQit0/jer8KKJ+lNMcCuXbPjoE0TEXCK6286V
         4kEQfZ272EKWgP+bWiBHurg2EC05pExDAou6Mb78SNZmnZONvBPwj+4CJymHVt8rmfEP
         7wYA==
X-Gm-Message-State: AOAM530rl6CUaGZgmvDE1ZdH862zSIQZx/NsAy5BRpJTOkpdkKWSJfWu
        kU7K4axO4Ix9duN3kJ4/8A==
X-Google-Smtp-Source: ABdhPJwfzyCoo0JWr0aR/jswcgdniTZNQNZdO9ujbOUSBwmWi45SoDsOISsYpub7w66iHWH4hod/OA==
X-Received: by 2002:a05:622a:1114:: with SMTP id e20mr9196019qty.279.1638981258952;
        Wed, 08 Dec 2021 08:34:18 -0800 (PST)
Received: from ICIPI.localdomain ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id q11sm1916226qtw.26.2021.12.08.08.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 08:34:18 -0800 (PST)
Date:   Wed, 8 Dec 2021 11:34:14 -0500
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Andrea Righi <andrea.righi@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Stefano Salsano <stefano.salsano@uniroma2.it>
Subject: Re: [PATCH] ipv6: fix NULL pointer dereference in ip6_output()
Message-ID: <20211208163414.GA747@ICIPI.localdomain>
References: <20211206163447.991402-1-andrea.righi@canonical.com>
 <cfedb3e3-746a-d052-b3f1-09e4b20ad061@gmail.com>
 <20211208012102.844ec898c10339e99a69db5f@uniroma2.it>
 <a20d6c2f-f64f-b432-f214-c1f2b64fdf81@gmail.com>
 <20211208105113.GE30918@breakpoint.cc>
 <d6cacd7d-732c-4fad-576d-a7e9d9ca9537@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6cacd7d-732c-4fad-576d-a7e9d9ca9537@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 08:46:37AM -0700, David Ahern wrote:
> On 12/8/21 3:51 AM, Florian Westphal wrote:
> > David Ahern <dsahern@gmail.com> wrote:
> >> On 12/7/21 5:21 PM, Andrea Mayer wrote:
> >>> +        IP6CB(skb)->iif = skb->skb_iif;
> >>>          [...]
> >>>
> >>> What do you think?
> >>>
> >>
> >> I like that approach over the need for a fall back in core ipv6 code.
> > 
> > What if the device is removed after ->iif assignment and before dev lookup?
> > 
> 
> good point. SR6 should make sure the iif is not cleared, and the
> fallback to the skb->dev is still needed in case of delete.

Thanks for the explanation. I was thinking that ->iif can safely be
assumed to be valid. Florian's point that device can be removed is a
good one. My bad for not putting the check and thanks for fixing.
