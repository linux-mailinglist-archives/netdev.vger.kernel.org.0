Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF78668597
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240516AbjALViP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240310AbjALVhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:37:20 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8B8625E9
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 13:29:34 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id s13-20020a17090a6e4d00b0022900843652so3439088pjm.1
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 13:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yHr4mGIAzi7wg8958gZUEGNwge8S+sX45P6Tgt/E5r4=;
        b=HHdWsEzxGrkgu+uL+CQ4R/wNZ2NIiQ5VYww46ieX847Ez5euQ73f9KtinIEm6SbxbL
         v/31/EcIvMBpCu6joqQuFun6Y4NWIY5Wy3iFZsFJ3acuDNR6ZNZs4lb5MJYcsUW2vPg6
         vtfttrasZG8/l5Yu0CG6dYIczY1lF3QH9S5+nplzHwCpqwrofzWItK6pVXejxoSZPDfH
         uP4SSzDYoYHOgVBl6gYGUkXDkXNtV58cO+lJIhQjIsGlPsbe42LDYnPOQ/eRw83fPir0
         wtyQb10D01T6fGOW3su8AUop/8paSnET4Oeioe+m9GSamcJpnsmtaG707FNzTTJ1Ku+E
         Q/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yHr4mGIAzi7wg8958gZUEGNwge8S+sX45P6Tgt/E5r4=;
        b=PRJWUvpy/ettnIHvOkfYqkhxSIp8IIC87VQjaCVewAdOtCisCBhj4V/Xu3Ox2NPEJE
         SYDCQTQrwwW5JyH7IgF36xP3bts95QpPaqIZaISTYI8efq+zopngSOcgzsHW0AqmKeqW
         fm2QLIJJ2bFCZIayreI/AZWG1Xl0F38FWjfTLI/g+sveo0/yrMvAAEyHiNzR3BaZKBdo
         acV8soTAsxBgQQxW0Eotx20QjG975JZGhka+GjT2bbdzdGcdXAxuG6Oj7gL5WziEk8zV
         b/qFf5WDYpc/VypCnSNks+rwXu0A3qswQLfPVylNf/B3uNrvdUn7ZbRTrDBA2dDOKmvy
         JDOA==
X-Gm-Message-State: AFqh2kqcCFEHJv4Ej00mntRaGnT87K21kF/We1V6qo/74cgPoHgzT/FQ
        za0AUb1lI8bxrZhBzjkHMmM8CpN7n4iqHlsPTYA=
X-Google-Smtp-Source: AMrXdXuO3AkL5rq42o5fZAel8rQnvlJJYrUHLI30OiYSY7Ct7WZxFoZMI+YoyhH8H7sQFuV58phowq/ixvQCz1BXwac=
X-Received: by 2002:a17:90a:19d2:b0:229:8a:df21 with SMTP id
 18-20020a17090a19d200b00229008adf21mr379684pjj.141.1673558974208; Thu, 12 Jan
 2023 13:29:34 -0800 (PST)
MIME-Version: 1.0
References: <20230112105440.1786799-1-vladimir.oltean@nxp.com>
 <0031e545f7f26a36a213712480ed6d157d0fc47a.camel@gmail.com> <20230112185355.yltldjsbxe66q54w@skbuf>
In-Reply-To: <20230112185355.yltldjsbxe66q54w@skbuf>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 12 Jan 2023 13:29:21 -0800
Message-ID: <CAKgT0UfnRceCA__HkpVnONO_AAp+wt+1GC2b6-vNk8oPh6aV9g@mail.gmail.com>
Subject: Re: [PATCH net] net: enetc: avoid deadlock in enetc_tx_onestep_tstamp()
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Y . b . Lu" <yangbo.lu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 10:54 AM Vladimir Oltean
<vladimir.oltean@nxp.com> wrote:
>
> On Thu, Jan 12, 2023 at 09:48:40AM -0800, Alexander H Duyck wrote:
> > Looking at the patch this fixes I had a question. You have the tx_skbs
> > in the enet_ndev_priv struct and from what I can tell it looks like you
> > support multiple Tx queues. Is there a risk of corrupting the queue if
> > multiple Tx queues attempt to request the onestep timestamp?
>
> void skb_queue_tail(struct sk_buff_head *list, struct sk_buff *newsk)
> {
>         unsigned long flags;
>
>         spin_lock_irqsave(&list->lock, flags);
>         __skb_queue_tail(list, newsk);
>         spin_unlock_irqrestore(&list->lock, flags);
> }

So yet another layer of locking. As I said you could spare yourself
some cycles by moving this to a per queue list rather than a global
one. With that you could use the Tx lock to protect the list instead
of having to have the Tx lock and the queue lock.

> > Also I am confused. Why do you clear the TSTAMP_IN_PROGRESS flag in
> > enetc_tx_onestep_timestamp before checking the state of the queue?
>
> Because when enetc_tx_onestep_timestamp() is called, the one-step
> timestamping process is no longer in progress - which is what we need to
> know. The resource that needs serialized access is the MAC-wide
> ENETC_PM0_SINGLE_STEP register. So from enetc_start_xmit() and until
> enetc_clean_tx_ring(), there can only be one one-step Sync message in
> flight at a time.
>
> > It seems like something you should only be clearing once the queue is
> > empty.
>
> The flag tracks what it says: whether there's a one-step timestamp in
> progress. If no TS is in progress and a Sync message must be
> timestamped, the flag will be set but the skb will not be queued.
> It will be timestamped right away.
>
> The queue is there to ensure that Sync messages sent in a burst are
> eventually all sent (and timestamped). Each TX confirmation will
> schedule the work item again.
>
> By taking netif_tx_lock[_bh](), enetc_tx_onestep_tstamp() ensures that
> it has priority in sending the skbs already queued up in &priv->tx_skbs,
> over those coming from ndo_start_xmit -> enetc_xmit(). Not only that,
> but if enetc_tx_onestep_tstamp() doesn't clear TSTAMP_IN_PROGRESS before
> calling enetc_start_xmit(), this is a PEBKAC, because the skb will end
> up being queued right back into &priv->tx_skbs again, rather than ever
> getting sent. Keeping the netif_tx_lock() held ensures that the
> TSTAMP_IN_PROGRESS bit will remain unset enough for our own queued skb
> to make forward progress in enetc_start_xmit().

Yeah, what I realized is that I was looking at the "fixes" patch and
not the current code. I missed the patch "enetc: fix locking for
one-step timestamping packet transfer". It fixes the issue by moving
the test_and_set_bit_lock, but is still dependent on a global lock to
prevent anything else from taking the bit when we attempt a transmit.

So essentially we have to completely disable the Tx path in order to
make sure we don't race against any other Tx thread while we clear and
set the ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS flag.

Not pretty, but it addresses the issue it says it does.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>


One other question I had. How do you handle the event that
enetc_start_xmit returns NETDEV_TX_BUSY or causes the packet to go
down the drop_packet_err path?
