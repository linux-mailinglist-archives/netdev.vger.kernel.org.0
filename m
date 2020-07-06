Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15960215F24
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbgGFTAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbgGFTAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:00:36 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BB5C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 12:00:36 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id dm12so17702022qvb.9
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 12:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cgc2aGSMcE4uE38jwbP8aUlB6C5htK7sM9vaPdzRikA=;
        b=Y95q57fcMIEAJG99/iJP4CkvIUw8ZHiziEq1gAPGq01oepZ0YIGzSKREOKTBrToUYc
         6TVB/yBE4ggOWehj9XzCFXCwcoyivxgq+ylO3F603MXNLRxo5NYZhwlaZq/KQsQ5PmIi
         8aKy22BtiJcF7ZRlA7BYIru+hegNP7WAcqBts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cgc2aGSMcE4uE38jwbP8aUlB6C5htK7sM9vaPdzRikA=;
        b=g3IqS4ZUxEi8Dh29VVREl5OjDkdFumAlbReN4eoLXykHqdFHt4E77W4LhCUQ8zxV+R
         a1CARew+QiDAp6hUXgZNeHzkuQ8abex7BouwhlbUlMPgFiuAFImpMWSDh5vu+2J7Jiy7
         0Lwq2qCe9EYAn27e0puEgEuldvknxnWPCxPFTwRNdReqw3+YnUF5/gQe9tHj5lt2faf+
         pchrJOKt2jDI/i4ljlDBhF0aLGkisfgTOj1/6PGMq0rCc1egoX3VLMqwcIQkfVF64Ksw
         j2hzZsEAcNhrCphrgnw/3Y63YTfCe5ZSQ4hIAqLBnog/sr57PM5mjsOMubRUY8yY9pn3
         OEvw==
X-Gm-Message-State: AOAM532hJvVybuIyKecPXnFDSPIOfJI8iRUR94QqYuqqOXuS60R3HGCK
        TEQLhFsVYRZSFqsV1vCCm3Mkv0ONdduw2/V5NHM8Vw==
X-Google-Smtp-Source: ABdhPJz4lLtx+COEY87kjke8VfCUDrCbvavTnMwFbMSeFgbBkweNefKlza8xoM+3w1ZJB+sUewbIH6+FPS52LoR/ZUg=
X-Received: by 2002:a05:6214:1927:: with SMTP id es7mr40431538qvb.166.1594062035596;
 Mon, 06 Jul 2020 12:00:35 -0700 (PDT)
MIME-Version: 1.0
References: <1593987732-1336-1-git-send-email-michael.chan@broadcom.com>
 <1593987732-1336-7-git-send-email-michael.chan@broadcom.com> <20200706115228.317e9915@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200706115228.317e9915@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 6 Jul 2020 12:00:24 -0700
Message-ID: <CACKFLimkfy974T7OPk5vuKq8fL3JHF4yWrr+xMq0EQ5vq6-d+Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3 6/8] bnxt_en: Implement ethtool -X to set
 indirection table.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 6, 2020 at 11:52 AM Jakub Kicinski <kuba@kernel.org> wrote:
> Maybe let me just type out what I had in mind:
>
> unsigned int bnxt_max_rss_ring(bp)
> {
>         int i, tbl_size, max_ring;
>
>         if (!bp->rss_indir_tbl)
>                 return 0;
>
>         max_ring = 0;
>         tbl_size = bnxt_get_rxfh_indir_size(dev);
>         for (i = 0; i < tbl_size; i++)
>                 max_ring = max(max_ring, bp->rss_indir_tbl[i]);
>
>         return max_ring;
> }
>
> Then:
>
>         if (rx_rings != bp->rx_nr_rings) {
>                 netdev_warn(bp->dev, "Able to reserve only %d out of %d requested RX rings\n",
>                             rx_rings, bp->rx_nr_rings);
>
>                 if (netif_is_rxfh_configured(bp->dev) &&
>                     rx_rings < bnxt_max_rss_ring(bp)) {
>                         netdev_err(bp->dev, "RSS table entries reverting to default\n");
>                         bp->dev->priv_flags &= ~IFF_RXFH_CONFIGURED;
>                 }
>         }

OK Got it.  You want to reset the RSS map only when absolutely necessary.
