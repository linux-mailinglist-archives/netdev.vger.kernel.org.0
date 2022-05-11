Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5A8523B90
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 19:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241216AbiEKRad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 13:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243285AbiEKRac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 13:30:32 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C072317E0
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 10:30:31 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2f7ca2ce255so29400247b3.7
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 10:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cghg16ufuQBLEvNuh0Nb/eQltKZiUL09EytQ2yuKV38=;
        b=XqS+igim3PLUgUyQV5m2TjzdGyrNcDAhVz3VGs82QjxLn7qwTRDtLCtsPORJe8auZC
         iXwSMCGpPv93XbD8Olj0WstKSZkz8Syuw8UrWlVpJQfIRJ8ETEcSnpCJ+E/V8gpBAJrI
         tpVQn+OVJwMj0FlhtLlX/aadKNMcYayRNeVI7ESB7BpBXSLTpx0UCbSGjR86itFHOauu
         HfvuyGVw47fWErxDDJmI2BTBl3OXDyR7RQT8VzTPL1i1C+VHiWRkQmQNjlP6VAqz8kmC
         N9jiZPVvsUZ3ogCWQ02Yl3StGPoyV2ob9aFJUG/xYJqDwvDt+q8FR6ZlY2tvNzpLO6Iq
         d5CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cghg16ufuQBLEvNuh0Nb/eQltKZiUL09EytQ2yuKV38=;
        b=iv5IjE7vppsLoteor3lW6M+AHESODzdZ2bfmYO9OEQA23GvlMq70ODnoGkLbUMNNIS
         Fzf3R4zOn+9cdnwTazHAX0ROPmI2AmaHssAUjczvv/kh+xWKSvCOWIRwB1ftibw3/grq
         AJ7tla0RQQT3Hlo/XxulzJeWYrukwgYFF40/80EfWbs08HlLIt6k9e5OxlB9Dkut2hKm
         wdkUo3AA91rFMwIn/Qe4eo2brbDEtsebr7iu3qBjc0oV38KmtWHezGkK0QDArr3cQQSW
         zySR38w44EbSOMxDLNqLprWPBSmMYjCeyycFsdL+wwIhB6bWa1gVZkrtieZhNpCZwnoC
         3wAA==
X-Gm-Message-State: AOAM531ZR5fbaHyMnJAJhfv5HR1F71jzaDjn1ztFsPbTv+VWOytb4Zby
        vpy+HD2nn3fUGynbIu9CY7bXQIu0d0Dt54E7HBAdpQ==
X-Google-Smtp-Source: ABdhPJw+vcfZJKo+HArRsFlknkC730cl9n9Hd4LPX3tLSwP1FbpVhg0pw/5N3za6ZTVMvT9Nk4qubCCCDqTxXj/0qsA=
X-Received: by 2002:a81:5603:0:b0:2f8:3187:f37a with SMTP id
 k3-20020a815603000000b002f83187f37amr25237461ywb.255.1652290230239; Wed, 11
 May 2022 10:30:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220511172305.1382810-1-kuba@kernel.org>
In-Reply-To: <20220511172305.1382810-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 11 May 2022 10:30:19 -0700
Message-ID: <CANn89iLqE1XUvb1nt1vU_YtHqmeqPqVTDrn=FSGFx4FUm2ajNw@mail.gmail.com>
Subject: Re: [PATCH net-next] skbuff: replace a BUG_ON() with the new DEBUG_NET_WARN_ON_ONCE()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Menglong Dong <imagedong@tencent.com>
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

On Wed, May 11, 2022 at 10:23 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Very few drivers actually have Kconfig knobs for adding
> -DDEBUG. 8 according to a quick grep, while there are
> 93 users of skb_checksum_none_assert(). Switch to the
> new DEBUG_NET_WARN_ON_ONCE() to catch bad skbs.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
