Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE433A2DA9
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhFJOFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJOFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 10:05:05 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3D3C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 07:03:09 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l7-20020a05600c1d07b02901b0e2ebd6deso6513117wms.1
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 07:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4GYLgmzJwYdicgqzVFCYd++zR6GCRkkcjYkUG80fals=;
        b=dJko7L1YiYnHtTOGVRM4xUXH9i6KXxmcWLobwX9occvsdEjy1E0y7vbUSaf1/cCL3J
         zzEQ6b0fnyBjXvz0OExUG8gl0AxlOF4ZljHcFMvq2olg1gjQpUYk5io8xr57cLFaT5vH
         U4ocPo0dkpafhi4k3k4tGB5VtfXiYIa/K4t6BMPlQ1i4H1YCo87JAofYUDn4NWZrAEJE
         nB+NHn9XqFXxsc241coRb7DO5sciUY3nCFfv5P3m4JzwMJm6KX5Uh2ptxO/Fz/BUCo7+
         Bf9391E5/hcyF1ca0hh2kbIXfVvSHbNHpGLD8GXVy+eSK0NUlglyV7VjP6U4YHAGqMdI
         Ztyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4GYLgmzJwYdicgqzVFCYd++zR6GCRkkcjYkUG80fals=;
        b=XGGYurMFRfk9yYAiaSwxmdfofyzZPD6JWaYBnr4ZSwoaQ3JZphPQw3uEmDxGSF0oP9
         fI2qfjjADI0BwwmaryVPX8hItNSvI9dMI61GJm0nVxAbrVCiCgg1AO5zHltOFSBsli78
         4cEU4zjxItqOUD94/TZ8ztkOxkF1/lGhVFODcJ+oRq/2bjXBkSS8i0wGcB0FIQdkGmff
         n742bgXRmyj6fHRpEftCbTomak+XU55Kdv1NL7ZhoYY8k0yC+SAOR8/b3vY6gRkIQAcM
         eEYrSBOowTvPYLwLdfKLTQ6YR/8PEO85q5rOah6Xw8XTKzOvWRtedXhMAkYkbJe91Wsq
         4OfA==
X-Gm-Message-State: AOAM533kh4lmC5bTfrj8pEgACjR8WmBBMfo/4lkjSjhixWc1i6CtJeQr
        b98PLWRBXLcc5ZMccwyLYUE=
X-Google-Smtp-Source: ABdhPJwP9M+2ur1horOb7pmRQhlW3s8jBTCUeUpFt6EPSIPbq7Nf/oQcX1ecfwE/Y2LVn91fyh66mg==
X-Received: by 2002:a05:600c:a01:: with SMTP id z1mr1810486wmp.77.1623333787787;
        Thu, 10 Jun 2021 07:03:07 -0700 (PDT)
Received: from [192.168.181.98] ([93.23.18.228])
        by smtp.gmail.com with ESMTPSA id n20sm3052671wmk.12.2021.06.10.07.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 07:03:07 -0700 (PDT)
Subject: Re: [PATCH net] skbuff: fix incorrect msg_zerocopy copy notifications
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, soheil@google.com,
        jonathan.lemon@gmail.com, Willem de Bruijn <willemb@google.com>,
        Talal Ahmad <talalahmad@google.com>
References: <20210609224157.1800831-1-willemdebruijn.kernel@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e9b3d5a9-96b4-f857-e9b8-82f1e3c49c1d@gmail.com>
Date:   Thu, 10 Jun 2021 16:03:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210609224157.1800831-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/10/21 12:41 AM, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> msg_zerocopy signals if a send operation required copying with a flag
> in serr->ee.ee_code.
> 
> This field can be incorrect as of the below commit, as a result of
> both structs uarg and serr pointing into the same skb->cb[].
> 
> uarg->zerocopy must be read before skb->cb[] is reinitialized to hold
> serr. Similar to other fields len, hi and lo, use a local variable to
> temporarily hold the value.
> 
> This was not a problem before, when the value was passed as a function
> argument.
> 
> Fixes: 75518851a2a0 ("skbuff: Push status and refcounts into sock_zerocopy_callback")
> Reported-by: Talal Ahmad <talalahmad@google.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---


Reviewed-by: Eric Dumazet <edumazet@google.com>

