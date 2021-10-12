Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D158342AFC6
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 00:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhJLWrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 18:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhJLWrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 18:47:10 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB3EC061570;
        Tue, 12 Oct 2021 15:45:07 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id z15so604607qvj.7;
        Tue, 12 Oct 2021 15:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UB0FzdGahcZ/l2MY8TB+GokWnB79j38+awN2OfnaO/Q=;
        b=LcfudLXN6HQWE0aY2xGsAF/8weSXlQQsY4xxKu6MZnfjAtEuugJG6bRyEhhCn25rnk
         iHtv+oMtEja0+Ad2adDnQ/EA5Lf/l91/PVY8ef79Xv2QZczxTlLOGkADd5GlD72SIBTc
         LcrJ3INNWwvqJEXp6fRxbfbQ94CpEqjCsKS2U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UB0FzdGahcZ/l2MY8TB+GokWnB79j38+awN2OfnaO/Q=;
        b=QaT2gtYSJrkk3gtDUh8Lai5scQEAmZno85Q/KAPH/bhy1SdZjakJJbIkiF2jZfjOW3
         LbSCTgM0oRuZsPA1tuXd6KjzyOoKHX+XVSeuBAmQ9NgCLVJmwX2BrpDUtcp9BC27xBj8
         BDRKQWSFyiHGXyPRGshGkIthBXXU34WzE4eUQ4yhZQhuUhjjnVcaoEoWCrB9+3RbCs+9
         KjUJf+mnNtU6vdWDpUbHCDjYmsoTbmBgRKuRpFUa69X1iH+qisk18QDGjh9FMgStiBQ/
         l5tL28XJqSVT6ZBxHYI5QpiaCKjnZAReU+f4hUhLKfz9HpGq2LGMAYGFhDGz6kOBe85Y
         ttjw==
X-Gm-Message-State: AOAM532KczTAEr66zELhUMCK3wPUKM4qyX5BQX3ZauzHVkvOX5SUsXcg
        zXuH5PZ4EFMI3wE6ZKTZA0KZLeRj+/9MRzy+Zm1zDjSb
X-Google-Smtp-Source: ABdhPJwdwg2qSLzUdtrTctTwZKvWb4MQibvHrqcgJytR74M9tC4QY151Jz7EyAyfvKBrwpu8/yilNdMssEM59AByd7c=
X-Received: by 2002:ad4:5de9:: with SMTP id jn9mr33494860qvb.41.1634078706757;
 Tue, 12 Oct 2021 15:45:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211012062240.GA5761@gmail.com>
In-Reply-To: <20211012062240.GA5761@gmail.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 12 Oct 2021 22:44:54 +0000
Message-ID: <CACPK8XcJudWoKgXORvRzGAbtBwHm3a56RULriVABfERZgNgt9w@mail.gmail.com>
Subject: Re: [PATCH] net: ncsi: Adding padding bytes in the payload
To:     Kumar Thangavel <kumarthangavel.hcl@gmail.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Networking <netdev@vger.kernel.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        Amithash Prasad <amithash@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        velumanit@hcl.com, patrickw3@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 at 06:23, Kumar Thangavel
<kumarthangavel.hcl@gmail.com> wrote:
>
> Update NC-SI command handler (both standard and OEM) to take into
> account of payload paddings in allocating skb (in case of payload
> size is not 32-bit aligned).
>
> The checksum field follows payload field, without taking payload
> padding into account can cause checksum being truncated, leading to
> dropped packets.

Can you help us review this by pointing out where this is described in
the NCSI spec?

We've been running this code for a number of years now and I wonder
why this hasn't been a problem so far.

Cheers,

Joel

>
> Signed-off-by: Kumar Thangavel <thangavel.k@hcl.com>
>
> ---
>  net/ncsi/ncsi-cmd.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
> index ba9ae482141b..4625fc935603 100644
> --- a/net/ncsi/ncsi-cmd.c
> +++ b/net/ncsi/ncsi-cmd.c
> @@ -214,11 +214,19 @@ static int ncsi_cmd_handler_oem(struct sk_buff *skb,
>         struct ncsi_cmd_oem_pkt *cmd;
>         unsigned int len;
>
> +       /* NC-SI spec requires payload to be padded with 0
> +        * to 32-bit boundary before the checksum field.
> +        * Ensure the padding bytes are accounted for in
> +        * skb allocation
> +        */
> +
> +       unsigned short payload = ALIGN(nca->payload, 4);
> +
>         len = sizeof(struct ncsi_cmd_pkt_hdr) + 4;
> -       if (nca->payload < 26)
> +       if (payload < 26)
>                 len += 26;
>         else
> -               len += nca->payload;
> +               len += payload;
>
>         cmd = skb_put_zero(skb, len);
>         memcpy(&cmd->mfr_id, nca->data, nca->payload);
> @@ -272,6 +280,7 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
>         struct net_device *dev = nd->dev;
>         int hlen = LL_RESERVED_SPACE(dev);
>         int tlen = dev->needed_tailroom;
> +       int payload;
>         int len = hlen + tlen;
>         struct sk_buff *skb;
>         struct ncsi_request *nr;
> @@ -281,14 +290,18 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
>                 return NULL;
>
>         /* NCSI command packet has 16-bytes header, payload, 4 bytes checksum.
> +        * Payload needs padding so that the checksum field follwoing payload is
> +        * aligned to 32bit boundary.
>          * The packet needs padding if its payload is less than 26 bytes to
>          * meet 64 bytes minimal ethernet frame length.
>          */
>         len += sizeof(struct ncsi_cmd_pkt_hdr) + 4;
> -       if (nca->payload < 26)
> +
> +       payload = ALIGN(nca->payload, 4);
> +       if (payload < 26)
>                 len += 26;
>         else
> -               len += nca->payload;
> +               len += payload;
>
>         /* Allocate skb */
>         skb = alloc_skb(len, GFP_ATOMIC);
> --
> 2.17.1
>
