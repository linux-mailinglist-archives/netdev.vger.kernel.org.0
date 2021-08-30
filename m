Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F21D3FAF54
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 02:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbhH3AkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 20:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbhH3AkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 20:40:12 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D9FC061575
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 17:39:19 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id x4so11863761pgh.1
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 17:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UM+0FVKt0nnLPHRVMW7+l28YC68L75hOl0nrTT3AeAU=;
        b=eMcy4hisXrRk/+tj+H2V1FLo1AoaRNToUyzED3StgjwJm1r1wIhIhyd1uEqXvUtlmI
         bbmbCvXDLhk3z59mOhn9jfik50zQ8UZ/YWJbx8CyuGph+OyJ4VxeJ1x41cLNGjmTuZzS
         HenoSRkYVBKUJ+xai07WgdB/NxnObDT28zf+KUNeeoaOCNPNJnrpZjmpAPPJFbRC7qbE
         Vi48Rfcf7MU7Msil0P5WQr5XfecvQIQFoPOYpQAEOzznhnSIYcjDptZwgjCqJMNZzT/V
         QJxXO6yLvue9M0jgJoj56SFtm4G0/G+LNCGPW9FlEn+Ynq7I3v14tmL99TqsRdjwtitO
         CtIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UM+0FVKt0nnLPHRVMW7+l28YC68L75hOl0nrTT3AeAU=;
        b=eEFivh/IQC2J3Wsw8SC02xFQRd6y6a9rS170CYqOafVH7BDoricwp3PY0FwyPT43S3
         GL8pGk+4G+euz4bNdE6s5uhKwXudxz2HkBVLwq9qduFSTB1/WGS8Ss+xjKtN+xur5BCP
         eS3v3oBc9X5M8pdpNfRINljoFcvUX1j2QA9NfqrCxxAHsUq1Po3tdnazFdh8GfFiNMq2
         do8Z78K0uP6hObvF4kUeWvXyLOpx2p8TysjjO+9B9lN8I9wGMTBtZuEuk3uD3IKvC4EZ
         hLbojCUs98HTumE9o8Hdx+2OoTLqAmVpyzVgBcPmLCEKIs79/dQkZzzmJeuzmyQX/6F5
         2eQA==
X-Gm-Message-State: AOAM531R23NKP/zK24ZLCUrvH870ogJEWtLpbXwKVFjGSal3GuUOYLBO
        E35UNuocUgI0fZbukkLHm6g=
X-Google-Smtp-Source: ABdhPJwdeEdfpEcC0/98wgBbT5JkaZbK4pfPKPNIrNn9y9Lx3CzInfEeAf8uE7ovXB6oSSPFUkUBfg==
X-Received: by 2002:a63:131f:: with SMTP id i31mr19153914pgl.207.1630283959539;
        Sun, 29 Aug 2021 17:39:19 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id u4sm5916821pjm.36.2021.08.29.17.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Aug 2021 17:39:19 -0700 (PDT)
Subject: Re: [PATCH net 1/2] ipv6: make exception cache less predictible
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        Keyu Man <kman001@ucr.edu>, David Ahern <dsahern@kernel.org>,
        Wei Wang <weiwan@google.com>, Martin KaFai Lau <kafai@fb.com>
References: <20210829221615.2057201-1-eric.dumazet@gmail.com>
 <20210829221615.2057201-2-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7c8bdee5-66cf-996e-eaea-db3aee6f0d5f@gmail.com>
Date:   Sun, 29 Aug 2021 17:39:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210829221615.2057201-2-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/21 3:16 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Even after commit 4785305c05b2 ("ipv6: use siphash in rt6_exception_hash()"),
> an attacker can still use brute force to learn some secrets from a victim
> linux host.
> 
> One way to defeat these attacks is to make the max depth of the hash
> table bucket a random value.
> 
> Before this patch, each bucket of the hash table used to store exceptions
> could contain 6 items under attack.
> 
> After the patch, each bucket would contains a random number of items,
> between 6 and 10. The attacker can no longer infer secrets.
> 
> This is slightly increasing memory size used by the hash table,
> we do not expect this to be a problem.
> 
> Following patch is dealing with the same issue in IPv4.
> 
> Fixes: 35732d01fe31 ("ipv6: introduce a hash table to store dst cache")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Keyu Man <kman001@ucr.edu>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> ---
>  net/ipv6/route.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

