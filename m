Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989A74B7B8A
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 01:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244921AbiBPACU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 19:02:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237647AbiBPACU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 19:02:20 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3A5DEA3
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 16:02:09 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id p19so1015003ybc.6
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 16:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VU6RzRKetHqvcqsoUjSmZSWRHlHeM6krU98bTFBkwLI=;
        b=R2xX+tcV4IJT65+bLSXcFJe0+dw+GWzZwfwfzAG7alxcTgGBTVMN8915TvDX/JqKId
         jwRRW1vxrsVZ4Fo7i327PEMqDmqDDt7p8cEnYpxmIL8OVYG9WMlOu755JsS2HEpX02DT
         dmV7ZzbnBqP4R4K7h2cqwErdT4kZU1SNbRU2szuJ3eTjORawH4g4MvW4joSybBDMxJlh
         FUIjyuQsMfSvYL/H0dPgI8BbMGPzvz9YKZzzkVek9nhd4hW0lGTqYGSeZN9QuWmX1GCj
         yKgo24YN3VlweWkjJGT7v2wL0LEYnHZH1+wOgQc/+G0Rz1T82h7PWdCdePfq6V/4JFUa
         ilRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VU6RzRKetHqvcqsoUjSmZSWRHlHeM6krU98bTFBkwLI=;
        b=gXg+TFSn2aA+sM9uTppbqe7fWI7RyDnXHpDYgAHaFMDxyfX+Bvv0sjSmKRvJAR51Hz
         /ZayrZxsuW2WzcHLUy3NAJgU1nzmyzgWmzAI2T53keoYThHzQLne8oOKADZAhRUF7C3I
         Q16Gr8iyncyAJkYA3K1ZSFHWEU5oiNCBfPqxg7r6TcnhObKE3/rIlipHl8Q0Oehgn/Jl
         OL25bkbKLng5+9J58KHwck0CzB/Y2wd1YmK1bC62WKaHIXgNjk+uRKT4lag7fESx4lYp
         jCM8CMVUIuJokKltlQxtPIFsxr7D9zImjWZ+jD+1HIvwRH+cLo/ieeJJ7zYa3TkvIr/a
         JSQQ==
X-Gm-Message-State: AOAM531b20P9iJtdLtyd3f8FqsfFy750UXvG/XNXMc8aRpxauvzxcimR
        A76lHu66tdPSvnoW8kjVOZ6c0IjhLVyb0wg+mLS0hA==
X-Google-Smtp-Source: ABdhPJyaFTIwuY9HPJWvNWdzua4j1yep9lvMLYYb39VZMXy5R5TaD+NjMzI/mnafm22HgvR6t4zEcJT5vPI8534qRDI=
X-Received: by 2002:a25:be8a:0:b0:608:67d7:22fe with SMTP id
 i10-20020a25be8a000000b0060867d722femr88404ybk.336.1644969728359; Tue, 15 Feb
 2022 16:02:08 -0800 (PST)
MIME-Version: 1.0
References: <20220215225310.3679266-1-kuba@kernel.org> <20220215225310.3679266-2-kuba@kernel.org>
In-Reply-To: <20220215225310.3679266-2-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Feb 2022 16:01:56 -0800
Message-ID: <CANn89iL+rTkCH18M+iKryu+7vd4fLDmOgVmnWdbJLbFdu_dxBg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: allow out-of-order netdev unregistration
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Xin Long <lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 2:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Sprinkle for each loops to allow netdevices to be unregistered
> out of order, as their refs are released.
>
> This prevents problems caused by dependencies between netdevs
> which want to release references in their ->priv_destructor.
> See commit d6ff94afd90b ("vlan: move dev_put into vlan_dev_uninit")
> for example.
>
> Eric has removed the only known ordering requirement in
> commit c002496babfd ("Merge branch 'ipv6-loopback'")
> so let's try this and see if anything explodes...
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>

SGTM, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
