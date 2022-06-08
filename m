Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EEF543788
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244564AbiFHPej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244500AbiFHPef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:34:35 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B514D43AE2
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:34:08 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id e184so37121534ybf.8
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 08:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zwaOg0v+LS5lJPRAqgeypP/Y8OpoKTps9ME8AQzY9yY=;
        b=cdS+m5mjlllB8E00wiMO7TPvS4XlWhncaVWc0nfzqcDdMka0zwSIeVHn09oHhbLqG2
         ZNw7H/c6rcnqq1qtENPaXfHfkhDQWhDY14cn7tk1I/KntivXsTwaOnDvHYLP7XiKTVoJ
         lJHKmlFVZoJ+ooCoZuz16RX4wvLRbOqfushN+8MCaKsD9bJiEMDimRo9WwvVCbIrkyKg
         IYnThb3jxhlVZXReYpqUq94CLffvtUIJryZrthc5Zi4Va5ARIwO/eurGGfkKdTHtJeHl
         sFRRwWdeGBhym0xrQcgTzStCQPzVi0DeccAk/kCNGad40NMyU+cefqL88XmfIN/JbIym
         TH8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zwaOg0v+LS5lJPRAqgeypP/Y8OpoKTps9ME8AQzY9yY=;
        b=yToKFlJqXmE2K8bhdWPfSeZrJoXhHvZ7feazo7gfHq6pdCS2dgck1HwKrh8u2ZjRgV
         CkrVmLos8mal6gFaGB3pKTVJAj0wNs5Tz/ohBSGmsalTEBvEt52pl+ePBaQUzWGPNVoJ
         k/6fGF/cupc5lCQ1RFD3fsQ3xDmhj3uobrrqT3/c/CT5hyO4gjbj9HWk/ZSbEuCrQrUb
         TQi88l8x77EBqtL65tUR/IrVSdJ5ne78PkHEXzcC1i+Pn7MzZ+FqWHvm+Rfm2JO5mYj2
         rIlnRgURDPTiCuv9AbozclJ+1qHL4AFhm/2Fso979GAT4JCE0crUxzM3K4gHvQp47l7e
         jt3Q==
X-Gm-Message-State: AOAM531gteHAWbcYGCUDPCxc1uRuT3b1vZOQ+kdJDhVkjPQBRIgQjBhn
        frOLGDRlCwixiX4KaXajoXpd0IcytgE8OAlwu9MQ/A==
X-Google-Smtp-Source: ABdhPJw7LBk5nIc8Ywm4xee3EF7vXV2w9g4Eybv3/NaMTe3+fmxqs6oR9sErU2lOx29CKb7ylJ99ySo87A7hyC+80kQ=
X-Received: by 2002:a25:d649:0:b0:65c:9e37:8bb3 with SMTP id
 n70-20020a25d649000000b0065c9e378bb3mr36654912ybg.387.1654702447381; Wed, 08
 Jun 2022 08:34:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220608135105.146452-1-soenke.huster@eknoes.de>
In-Reply-To: <20220608135105.146452-1-soenke.huster@eknoes.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Jun 2022 08:33:56 -0700
Message-ID: <CANn89iJ2gf4JfU8KZUYFSA8KgS-gEjhBZtX9WvUmWv2c8kPkJQ@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: RFCOMM: Use skb_trim to trim checksum
To:     Soenke Huster <soenke.huster@eknoes.de>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Wed, Jun 8, 2022 at 6:51 AM Soenke Huster <soenke.huster@eknoes.de> wrote:
>
> Use the skb helper instead of direct manipulation. This fixes the
> following page fault, when connecting my Android phone:
>
>     BUG: unable to handle page fault for address: ffffed1021de29ff
>     #PF: supervisor read access in kernel mode
>     #PF: error_code(0x0000) - not-present page
>     RIP: 0010:rfcomm_run+0x831/0x4040 (net/bluetooth/rfcomm/core.c:1751)
>
> Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
> ---
>  net/bluetooth/rfcomm/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
> index 7324764384b6..7360e905d045 100644
> --- a/net/bluetooth/rfcomm/core.c
> +++ b/net/bluetooth/rfcomm/core.c
> @@ -1747,8 +1747,8 @@ static struct rfcomm_session *rfcomm_recv_frame(struct rfcomm_session *s,
>         type = __get_type(hdr->ctrl);
>
>         /* Trim FCS */
> -       skb->len--; skb->tail--;
> -       fcs = *(u8 *)skb_tail_pointer(skb);
> +       skb_trim(skb, skb->len - 1);
> +       fcs = *(skb->data + skb->len);
>

Hmmm... I do not see any difference before/after in term of memory
dereference to get fcs.

I think you should give more details on how exactly the bug triggers.
