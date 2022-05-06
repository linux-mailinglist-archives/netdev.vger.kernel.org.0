Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A067F51CF23
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388395AbiEFDCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 23:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234102AbiEFDC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 23:02:29 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B87A5C84A
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 19:58:48 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id h10so10759698ybc.4
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 19:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7bwhUbFdldso/blhEy2kXCpuEiKqutJto64pyAynAuc=;
        b=e1q8kdrujEp/qAEH7OJVJ4YIturNOr2qpuDXiUazfxq2EO+Ov4r1Wv2FvnhLlGGLfl
         EO8d1xCB1yKQVE8TM+yClh6wPm3ineGg2QEQrdIO6TDJ9rAzQF7uubBQJjYi6MGW/YpV
         eLdK37Xhpaz9quag3auAkaFN86jKpm6l+ery6gFj1Cu5D4C+1ebDj5tL0xRCEW4XazYU
         /64LTHiMrSzMXpAfITRk9ur0oKnh3Iwq/TzxIEPESrqPpFIDHz4wZwE1SQVv6T+UnIvl
         1oZkKnE+CBbAidXRqgFc+496oehC4ablMr4igFNHs2LrAZ4nuOVYDaQaFZiPNEoTcR9y
         2XMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7bwhUbFdldso/blhEy2kXCpuEiKqutJto64pyAynAuc=;
        b=FfoujRwd7RXUe6EPtkms6BZIpPPbQQS3yuFa6GHXSRi0oeq9DYBtdYd+7XfMLTbNIr
         nkN9jkkEXFFGnvZ7drvT90mJyLjJ3MG3fDnaYbaRZli2K382VWI/1uuA1lhKytxq9pvV
         6c4ioKX+jc9OcKRBUQNej0T/68EpP7eWsYtMv1OVbB770xljw/eb7Skyg6G+EeJ8eX/a
         irnzH6zf/FX37ZS8ivsTgrfLNis2P+NvnDxbQFi/vx2eEx08rXCRrPlzPDnDz2iMgJ5d
         rRWPL87d2dX7XGXMXnHLsilYTc7RRThTdxjr/Mkiqg6lq+ZiMcQBNwmwUeo+MBKLrdmP
         ZOcw==
X-Gm-Message-State: AOAM5332ZYuwaxJB9ANqPZRCNiPgU/5nG9kmOYzZmFDS2yQSy0ULU3RW
        ESGyV9r/UAE//NxbgjCpZiiLDTdgeK93ahG3i3rO7w==
X-Google-Smtp-Source: ABdhPJy1It9M8QFw/Anwi/tN1tC/xt3gPx1Lm963DmHWDESwImsMPTP/v6O6THBnzu4qYMhzGMBSzDCxkD3SVEnCdcs=
X-Received: by 2002:a05:6902:1007:b0:649:7745:d393 with SMTP id
 w7-20020a056902100700b006497745d393mr849738ybt.407.1651805927307; Thu, 05 May
 2022 19:58:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220506025134.794537-1-kuba@kernel.org>
In-Reply-To: <20220506025134.794537-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 5 May 2022 19:58:36 -0700
Message-ID: <CANn89i+n+GSvOiLkMHGE6ExeOkYLDs4Sy4BR-yopZrw3Z1yv1g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: disambiguate the TSO and GSO limits
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
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

On Thu, May 5, 2022 at 7:51 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> This series separates the device-reported TSO limitations
> from the user space-controlled GSO limits. It used to be that
> we only had the former (HW limits) but they were named GSO.
> This probably lead to confusion and letting user override them.
>
> The problem came up in the BIG TCP discussion between Eric and
> Alex, and seems like something we should address.
>
> Targeting net-next because (a) nobody is reporting problems;
> and (b) there is a tiny but non-zero chance that some actually
> wants to lift the HW limitations.
>
> Jakub Kicinski (4):
>   net: add netif_inherit_tso_max()
>   net: don't allow user space to lift the device limits
>   net: make drivers set the TSO limit not the GSO limit
>   net: move netif_set_gso_max helpers
>

Very nice, thanks Jakub.

BIT TCP patch series looks much nicer after this series, I will post
v3 when your series is merged.

Reviewed-by: Eric Dumazet <edumazet@google.com>
