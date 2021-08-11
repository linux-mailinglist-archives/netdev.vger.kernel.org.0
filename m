Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933D33E996F
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 22:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbhHKUOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 16:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHKUOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 16:14:23 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0ADC061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 13:13:59 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id k65so6961439yba.13
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 13:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u+HEwVE2h6EoXNkQ9h0qH6PYXrhFQild+sFaHXOY9kI=;
        b=XMxA2B/D7RDRfSgA8nxbJElMjvXuarvNNnxSWpgAMLGLtTw2f4D3Zf1gGWdVmn8ZZN
         iJrIhJns9KCW2FIAVUh11DIg0Y276EecZbvi9HpE9SC9Fdcqz01nLTkRY2/A4D8LSVPh
         SDa3wJfFz4Jiv6TPQ6tV4mTvemuNU839Wzhug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u+HEwVE2h6EoXNkQ9h0qH6PYXrhFQild+sFaHXOY9kI=;
        b=VZDoJK/iqeAOi5UIUf+hplYbpA8+bccnmBQpPutAaljX+3qRFoszIllt/KqU4HNVma
         lh8PATCKYjg/to1JtY14rZmlyQb4+yV3s1i9Kp2bTm7tN9Y59FFgYIUXjvIQbCTcFCsQ
         AiJOl1p11+kaDLCfFq5hyLd2LEbnIZfNZKBPXG5/Bim3wNaHrrAkqYkNGUIlkmMqW9fY
         j3BuHBEMyCd+eNQwghTA3ghmtLTI4CDUoDWlkzW8joKdHByk2lSySQwlsZm/Vs4CxNJ2
         XFmeHDTFBewQ11+QacFUnjmUySi7VbCuUV6jCcteayylfVsfvPpmttPjSkIl3HwOQ0NB
         G73Q==
X-Gm-Message-State: AOAM530qFARU5gJ97j1fJBhpsEPFyiLUDnG3Ysvj1vY1aqHlIGOd1A3J
        UBzHKf3QHR7NqXIAoQ6ZqcNw3V9x2eLPurU09v3f3w==
X-Google-Smtp-Source: ABdhPJwTJe8JT59DUTqZKNtqmV/D6pYWLYyNPMNcEZ002/haODay4E4hPF7oVM80OPrFTTAYvi7phY05y668+LuwclA=
X-Received: by 2002:a25:65c4:: with SMTP id z187mr291934ybb.400.1628712838924;
 Wed, 11 Aug 2021 13:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210811193239.3155396-1-kuba@kernel.org> <20210811193239.3155396-2-kuba@kernel.org>
In-Reply-To: <20210811193239.3155396-2-kuba@kernel.org>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Wed, 11 Aug 2021 13:13:22 -0700
Message-ID: <CAKOOJTzO+QCZevo=LikLE-0tpkCZUWM3=zS3dpTbQS4dNtzhAQ@mail.gmail.com>
Subject: Re: [PATCH net 1/4] bnxt: don't lock the tx queue from napi poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Jeffrey Huang <huangjw@broadcom.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Andrew Gospodarek <gospo@broadcom.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 12:32 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> We can't take the tx lock from the napi poll routine, because
> netpoll can poll napi at any moment, including with the tx lock
> already held.
>
> It seems that the tx lock is only protecting against the disable
> path, appropriate barriers are already in place to make sure
> cleanup can safely run concurrently with start_xmit. I don't see
> any other reason why 'stopped && avail > thresh' needs to be
> re-checked under the lock.
>
> Remove the tx lock and use synchronize_net() to make sure
> closing the device does not race we restarting the queues.
> Annotate accesses to dev_state against data races.
>
> Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 865fcb8cf29f..07827d6b0fec 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -730,15 +730,10 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
>          */
>         smp_mb();
>
> -       if (unlikely(netif_tx_queue_stopped(txq)) &&
> -           (bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh)) {
> -               __netif_tx_lock(txq, smp_processor_id());
> -               if (netif_tx_queue_stopped(txq) &&
> -                   bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh &&
> -                   txr->dev_state != BNXT_DEV_STATE_CLOSING)
> -                       netif_tx_wake_queue(txq);
> -               __netif_tx_unlock(txq);
> -       }
> +       if (netif_tx_queue_stopped(txq) &&

Probably worth retaining the unlikely() that the original outer check had.

> +           bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh &&
> +           READ_ONCE(txr->dev_state) != BNXT_DEV_STATE_CLOSING)
> +               netif_tx_wake_queue(txq);
>  }
>
>  static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
> @@ -9264,9 +9259,11 @@ void bnxt_tx_disable(struct bnxt *bp)
>         if (bp->tx_ring) {
>                 for (i = 0; i < bp->tx_nr_rings; i++) {
>                         txr = &bp->tx_ring[i];
> -                       txr->dev_state = BNXT_DEV_STATE_CLOSING;
> +                       WRITE_ONCE(txr->dev_state, BNXT_DEV_STATE_CLOSING);
>                 }
>         }
> +       /* Make sure napi polls see @dev_state change */
> +       synchronize_net();
>         /* Drop carrier first to prevent TX timeout */
>         netif_carrier_off(bp->dev);
>         /* Stop all TX queues */
> @@ -9280,8 +9277,10 @@ void bnxt_tx_enable(struct bnxt *bp)
>
>         for (i = 0; i < bp->tx_nr_rings; i++) {
>                 txr = &bp->tx_ring[i];
> -               txr->dev_state = 0;
> +               WRITE_ONCE(txr->dev_state, 0);
>         }
> +       /* Make sure napi polls see @dev_state change */
> +       synchronize_net();
>         netif_tx_wake_all_queues(bp->dev);
>         if (bp->link_info.link_up)
>                 netif_carrier_on(bp->dev);
> --
> 2.31.1

Regards,
Edwin Peer
