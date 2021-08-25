Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FF33F6D64
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 04:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236824AbhHYCTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 22:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbhHYCTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 22:19:51 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C714C061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 19:19:06 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id c17so21604912pgc.0
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 19:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eTC/uQbzVSL+Ti5t7weoDEPLp7c2RLXHEGW56znnqkA=;
        b=PlFwOe1Tkp1SxJpz8WQt4ki+KpKsP/BSqxZpV26oAc7e1fqdsHNTPl0AfrAEeC3Frv
         9QtAgjbX7fcLayPLJw/uoq3Dc0w3U4B2fY+WnuztuVsKIu4WzoIIHUvnVjxqvEeNm4eW
         OZ9N4D+yMXCHFFzt55c5fDzOmsEvmCiJ3XY2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eTC/uQbzVSL+Ti5t7weoDEPLp7c2RLXHEGW56znnqkA=;
        b=gl+Bju41myUy3fNEPX+kpa3FHTDyK3p0iQKJI0SSjzyU2JhhwVS1+H4mpGA2CrnhIp
         NsHcKWvM7Cpp/LzF4E5gMi8jpO6VZ8pvmgNWH36ikmeJBipek20RB75rcXD9ZAzk4/fp
         jT+LxDj5K1ywPQDgSknpMFjx3fghsRK9mQ4yr1JlkWHHSymt3s+w2wD670nKmPWz9hEK
         7MWWImwMwHCcAzoDSdwmsO7d4PuaFIYuP0w/XwrLRWNlYmvjcL2UALYqnoFnDUxb/VSw
         +Ze0h/p22v131bFR0GZqEyewVuDRt2BkffFZLgwLJrL8jE7E0PntOki8dBtz1ltIG3DP
         6OCw==
X-Gm-Message-State: AOAM531WoB/3XVkHqLAgo/byuTxkQT5N9jhnchojkaeAq8lgJQpaiQu1
        qxBCWTKTkORYE3oYS+9lqpIgmgKVh8pqvA==
X-Google-Smtp-Source: ABdhPJwXZ/XwTGQmMk14RkumEAjXI0fIL6/Y/w1S9H60rDTYyiUJq5+mkid+ElC+nrSr/EBJm1HsEA==
X-Received: by 2002:a65:6919:: with SMTP id s25mr39923709pgq.2.1629857945962;
        Tue, 24 Aug 2021 19:19:05 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 143sm20243706pfx.1.2021.08.24.19.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 19:19:05 -0700 (PDT)
Date:   Tue, 24 Aug 2021 19:19:04 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        aelior@marvell.com, malin1024@gmail.com,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Subject: Re: [PATCH] qede: Fix memset corruption
Message-ID: <202108241918.EA31FB40@keescook>
References: <20210824165249.7063-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824165249.7063-1-smalin@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 07:52:49PM +0300, Shai Malin wrote:
> Thanks to Kees Cook who detected the problem of memset that starting
> from not the first member, but sized for the whole struct.
> The better change will be to remove the redundant memset and to clear
> only the msix_cnt member.

Okay, thanks. It wasn't clear if this needs to be _only_ the msix_cnt
member or something else.

> 
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>

Reported-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/net/ethernet/qlogic/qede/qede_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
> index d400e9b235bf..a0f20c5337d0 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> @@ -1866,6 +1866,7 @@ static void qede_sync_free_irqs(struct qede_dev *edev)
>  	}
>  
>  	edev->int_info.used_cnt = 0;
> +	edev->int_info.msix_cnt = 0;
>  }
>  
>  static int qede_req_msix_irqs(struct qede_dev *edev)
> @@ -2419,7 +2420,6 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
>  	goto out;
>  err4:
>  	qede_sync_free_irqs(edev);
> -	memset(&edev->int_info.msix_cnt, 0, sizeof(struct qed_int_info));
>  err3:
>  	qede_napi_disable_remove(edev);
>  err2:
> -- 
> 2.22.0
> 

-- 
Kees Cook
