Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA27D47BB32
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 08:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbhLUHiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 02:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbhLUHiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 02:38:14 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9AFC061574;
        Mon, 20 Dec 2021 23:38:14 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id c2so10934493pfc.1;
        Mon, 20 Dec 2021 23:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4WJN5x47c2hA8Pz3pc9Mz+OwlZnBuT0a0E+7cAGIaqQ=;
        b=VaYpL5rhQ4WiEv1nDr6Au8Nhz+WWgb3OdeRb3u/QSI+dTHpgRRJFwDHbvfgS8T08vt
         Ce5Sggl5uc4g4vsDP9ZV9rLDUlPTGK+nF4Y6AgGU/fWPv39eVpdO0pgiC6SzmhyJIVN0
         GqG38IuMNLv7X2JiXne//6436nnQ3tY/Ip8V2nduFr0cfYZhvD7GPJk0Jol+7MhCqWAF
         cGURXRFfo6t5FTczNXhywwincexTXWKEFoHZqjsdmPvL8Oy9v5qmiggwHjpA1NLcpfIq
         liJdYO3q075Ssq1Wg/UUsanPh+z1cEIKKArZqaAFmNTW0xpDDJNra1I7cF9SbJp9fEXy
         8a0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4WJN5x47c2hA8Pz3pc9Mz+OwlZnBuT0a0E+7cAGIaqQ=;
        b=E6ZRsceWrVo4RcP+J7U9mEklzA/kozMDk6Y4QYwL/yPhZbIb33oHUOE9W+MAU92mvz
         oT0v95j7hcMrbObGm9uPOxCDrdCX8LcGVYquLV+iF9eCPfUzjEybr+yxKQJ1Fw2jDCV8
         6QBKvMNitHcW5ksdy1j+ttSwtmsaQW4uJwZfAH6gyGisTSWn5Nn25Gxxq2zhT1rD56/J
         AxPqzDg3d39H0H8MqV6SMtFvSpRhp/QJE1YBNgYCLqd9Y1Tb0WNT1lDWmmAs1BTNtHV0
         0oRix7guCF2Z/+Y4k6Bv7QcP/tO863E5cZOAcvySLNAZOt6tGdwszRB7nR/0IrJR8nPK
         MAag==
X-Gm-Message-State: AOAM531ll9ydIn1zPVpU678WbEayIvADWDTH7gA1VkeIaal108Zo4GGJ
        dckPUZ6Fmv+vL9KPM7I1a6mtjg9FLkJlTB3qrGY=
X-Google-Smtp-Source: ABdhPJys9XnsSj4ZHt+YFFhMaKjAJNOSyEgA9FapOhvgEZ/OD4dmx1QGws2NiFaeCtXqW8HuZBS7SEJAULqxri0eOmU=
X-Received: by 2002:a63:1b0a:: with SMTP id b10mr1881078pgb.183.1640072293580;
 Mon, 20 Dec 2021 23:38:13 -0800 (PST)
MIME-Version: 1.0
References: <20211216135958.3434-1-maciej.fijalkowski@intel.com> <20211216135958.3434-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20211216135958.3434-3-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 21 Dec 2021 08:38:02 +0100
Message-ID: <CAJ8uoz1T1MSg-T0pRSLkywrFZ+xUJkwkEL6jd-vmKFp0fd3oMg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/4] ice: xsk: avoid potential dead AF_XDP Tx processing
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 12:38 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Commit 9610bd988df9 ("ice: optimize XDP_TX workloads") introduced
> @next_dd and @next_rs to ice_tx_ring struct. Currently, their state is
> not restored in ice_clean_tx_ring(), which was not causing any troubles
> as the XDP rings are gone after we're done with XDP prog on interface.
>
> For upcoming usage of mentioned fields in AF_XDP, this might expose us
> to a potential dead Tx side. Scenario would look like following (based
> on xdpsock):
>
> - two xdpsock instances are spawned in Tx mode
> - one of them is killed
> - XDP prog is kept on interface due to the other xdpsock still running
>   * this means that XDP rings stayed in place
> - xdpsock is launched again on same queue id that was terminated on
> - @next_dd and @next_rs setting is bogus, therefore transmit side is
>   broken
>
> To protect us from the above, restore the default @next_rs and @next_dd
> values when cleaning the Tx ring.

Thank you Maciej.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
> index bc3ba19dc88f..0f3f92ce8a95 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -172,6 +172,8 @@ void ice_clean_tx_ring(struct ice_tx_ring *tx_ring)
>
>         tx_ring->next_to_use = 0;
>         tx_ring->next_to_clean = 0;
> +       tx_ring->next_dd = ICE_TX_THRESH - 1;
> +       tx_ring->next_rs = ICE_TX_THRESH - 1;
>
>         if (!tx_ring->netdev)
>                 return;
> --
> 2.33.1
>
