Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 900D4513AA9
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 19:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiD1RO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 13:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiD1RO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 13:14:28 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AE8B3E
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:11:12 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2f7d621d1caso59904637b3.11
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 10:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dyBQDglTeu6TYVRpB3p14HH6PV1GFeiEP+gELYWEtFo=;
        b=LkTy57l5wnwLLVw0jk2LY/KBAZs9geoiyzJwqBLpL0vnJVop5XDuAgqlMTE20Gh+W8
         e6Mqb+dfg9r9aWSPH+r5y1TYBnLLPyPA6QBjC9evGPqA4Ez46Ru6903WuwfVeKCp8Ynu
         5LRQrq45agzjbtMf8vAMeP4Xq3We8iEBaFcTfUTVZUQlvgnu4RS3kYOmAi1sMvDzCIMf
         CWflWcRcciCHrr/Uk/pAMF6TmufonaUU8XJiCbKWQAkPnuZYDwCeoVb4DC8Z71oiLy0O
         P3lMXk1DD5HaOY0isUkmY6S+lA1XVPRu8hpRvePTjh39LUdlm9uHTTSajvYwQaFNKtLO
         szpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dyBQDglTeu6TYVRpB3p14HH6PV1GFeiEP+gELYWEtFo=;
        b=s11xYu9+2VFJ6kHkROsR8B7LZQ5I2/xoyCaMjK3uJA8XiJ0eZF1QUqqmXQy50FkOTy
         1yBRk5n8HqdjRD3jLDjozOaQCrvmVgbha0arjE+0C8g6t+fJNFJ6WKa7qu8skpN4nAEU
         3StG897okOym9hXaCCLEkt6YJkfOl9fHBle8bgVv56Y7WItqzjr/ONhZm3tuVkzG0Ndp
         dxd7Di08oysvbKnsHEqtppR5lGMb42L00bppuNdUMg/4gTuCw2lhzbQ8XGIfmDPH7Mxk
         18XxAWrdd7LWGE0r1PkuwwAppWCev6F40Jp0E1O8cvDGjAiSqSRFXNs3yasZgXJkMtal
         99Kg==
X-Gm-Message-State: AOAM533NhO6NNFCvbgs31LDMimRh0ZJRcXX/RQTT41OsJzUln7KlR06I
        o2DXJ/83fEN9c6kpmS3475pcgPm09y7YakmZbhJkfw==
X-Google-Smtp-Source: ABdhPJwlgw0Nje7R3Yy45YqwkCWX5mD47YK8CvnneOFCvZ6HEoY49SFZaoSfeCXJ7R8g9A4RHk1kyFT0gs2ZcZrv8Is=
X-Received: by 2002:a0d:d80b:0:b0:2f7:c74f:7ca5 with SMTP id
 a11-20020a0dd80b000000b002f7c74f7ca5mr27715263ywe.489.1651165871905; Thu, 28
 Apr 2022 10:11:11 -0700 (PDT)
MIME-Version: 1.0
References: <1650967419-2150-1-git-send-email-yangpc@wangsu.com> <CADVnQy=0MQ-AvfJShdP9mCWHVG3cVpHXrkuw9wbzGSsXughxeg@mail.gmail.com>
In-Reply-To: <CADVnQy=0MQ-AvfJShdP9mCWHVG3cVpHXrkuw9wbzGSsXughxeg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 28 Apr 2022 10:11:00 -0700
Message-ID: <CANn89iLB5MUUc1OfnKP_1ukoSX0fmjBJUhK-u7oDnNPUeeUY6g@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix F-RTO may not work correctly when receiving DSACK
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>,
        Yuchung Cheng <ycheng@google.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 10:06 AM Neal Cardwell <ncardwell@google.com> wrote:
>

>
> Thanks for the fix and test! Both look good to me. The patch passes
> all of our team's packetdrill tests, and this new test passes as well.
>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Tested-by: Neal Cardwell <ncardwell@google.com>
>

Indeed, thank you all for a nice changelog, nice patch, and exhaustive
tests from Neal.

Reviewed-by: Eric Dumazet <edumazet@google.com>
