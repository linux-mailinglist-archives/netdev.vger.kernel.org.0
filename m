Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C652526BA4
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 22:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384272AbiEMUft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 16:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384271AbiEMUfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 16:35:47 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A10618387
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 13:35:46 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id r11so17214555ybg.6
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 13:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Y19VY5IjO5fHmcCkVatm3M9gHAr7uM58mL5LtXXwgU=;
        b=Ry8xJ7ZuDfssVYBz5E6p3Y3kTv6ZuL00dYxJkmkp5YxV03Erx00Jqq7jICH9NLfQcJ
         K4sdmOn1ruelGFEvIz/rBhpuorXIH9PKd3nQ3C+Htw0uWEf51gdA9AlXe60Bn4qnDzne
         nr6hnm0TXXmgTyTvhI8uxKIVnEJhr61gWEYJlhFWvb7aiNcL7ZMTLo4Nw9oc4xxA+UiM
         T1sk8UReFbyuYckNSGxj/okQEK1BBfsiVsWyurGWjthJYV1yTv6oDLsiViu+sD0Rm/n2
         6kbKSc+1XMJ13MkA71cqVxSlV5AZWZwkQvt9e4mNBb0woRdp8TaxY3ya0qBkjSGQY5fZ
         SSsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Y19VY5IjO5fHmcCkVatm3M9gHAr7uM58mL5LtXXwgU=;
        b=YSiHwyQWCn6mEtV6WtmmTn87+BuM4CykWxpaBbHgK8iEapu0u/T4avLJcgFax/AWPl
         uZJJoNFMy7asjp8dnYKFLAenV66SeE2tXo9IFwzijFf68ep6dssBrg3frHGVNM2KSpC5
         lOWOryMABWLDnfiTRSyx9tdZUBY+B3B1Ie4dNMghsxfDjVDCAQ+k5Ln2oGUCRx65ausz
         CBCycV/pH9DoBrGdo58zOvthQNjgwg3ys3JumKeuJv5WUQqVr+KvgHA5cgTcG2asREI+
         zU9GO2uAwrkwhhsPm+83HBy/2jWYy6ZM5Sv0FsSqJNyhsHxRIvZyxv2EcMtsgYN9DNtB
         HbyQ==
X-Gm-Message-State: AOAM532ol5pnzKjVVdT7G4rmgfERkNYDdr8SAFn0BBBK0yt+fwEgZoWj
        156FZPjHVhtbma0cM1Q6RqGXhMQ7Ad4o7NJPWZxxow==
X-Google-Smtp-Source: ABdhPJypnAWDOEQUvFtetMIz41XNV7drFrUOKnn/b4XVD39yUMttz3hXnn/bjZ5katYcnl0AhHPtamFyMgjhEansMAA=
X-Received: by 2002:a25:1f85:0:b0:64b:a5fc:e881 with SMTP id
 f127-20020a251f85000000b0064ba5fce881mr3798336ybf.514.1652474145485; Fri, 13
 May 2022 13:35:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220511151431.780120-1-vladimir.oltean@nxp.com> <20220511151431.780120-2-vladimir.oltean@nxp.com>
In-Reply-To: <20220511151431.780120-2-vladimir.oltean@nxp.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 13 May 2022 22:35:34 +0200
Message-ID: <CACRpkdaiUHcVmUVKF51O1HXhT+OFsivru2AZTkdUUELGwW39+g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] net: dsa: tag_rtl4_a: __skb_put_padto() can
 never fail
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 5:14 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> One of the purposes of the central dsa_realloc_skb() is to ensure that
> the skb has a geometry which does not need to be adjusted by tagging
> protocol drivers for most cases. This includes making sure that the skb
> is not cloned (otherwise pskb_expand_head() is called).
>
> So there is no reason why __skb_put_padto() is going to return an error,
> otherwise it would have returned the error in dsa_realloc_skb().
>
> Use the simple eth_skb_pad() which passes "true" to "free_on_error"
> (which does not matter) and save a conditional in the TX data path.
> With this, also remove the uninformative comment.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

This looks correct to me!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
