Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3637E2933DC
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 06:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391487AbgJTEO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 00:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391478AbgJTEO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 00:14:56 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54F0C0613CE;
        Mon, 19 Oct 2020 21:14:55 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id f5so273823qvx.6;
        Mon, 19 Oct 2020 21:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Doa5MN9UVqAi2ZBrxUM6vlz/cuBDGnQg9D05ebwmrCg=;
        b=beGRlKaAtJmvndCmbfAvOcBZJmTc7go7JN24RumXXIvY0P/rWFLs/N+fbycTBdOA3F
         7lvaPqJvuyVQVuJ/VLpq6zjUro2GF97ydpeC80mdDCDLp/qyjRo0U4oC44hZ36h9t9AO
         cM8JuxMbthxoPel8+LJBjE+1i06JZpIHrMNUY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Doa5MN9UVqAi2ZBrxUM6vlz/cuBDGnQg9D05ebwmrCg=;
        b=NeiBJXgz6nMaJNWqSWKfrFEHkTPlectgag96J8G1CEqZCnZhHxUcqnqfLCZ7nZ2cBh
         l4DnLWl654YItCyOdfxKdfcvcK8J/JbXFAXT2D/Qkfgi1GhssJ6mCVUaGC7hCNP2bVNX
         qbfbLlg5asHHy54fCMzAbNi9zMB8DVsG0sY+lFauuAyznNJy4Z1oTZnNMRYkeEIOyVXA
         M4wel5eHNLFmup+zI5lEY+GFZg6WhdS3IyWy00ZO2L8zvrgTmZx3gANIqXDsQdoPlYtm
         e/xyO1iaYDKNsb7NdY91s86Gxqb93FzxVwThUSDj1TKiDgrbSGG5TaF05yIyLvQWRmx5
         EUew==
X-Gm-Message-State: AOAM531qE17cBpX5eRiCmZWCbDUeSnFymg7OBwyxxH5lVtnLhXpxOQab
        LahhDXe/PFEvjBliwGOZN6BVFEPwbuPCklq3MlM=
X-Google-Smtp-Source: ABdhPJywZAPmDv8rfDMsC6fQughlNzS16j6qH9Ov4ukKgR4TWEzP5SWO12PW/etRHRc/w4udSafZKWBKeFcmTuGCALY=
X-Received: by 2002:ad4:54e9:: with SMTP id k9mr1327596qvx.18.1603167295058;
 Mon, 19 Oct 2020 21:14:55 -0700 (PDT)
MIME-Version: 1.0
References: <20201019085717.32413-1-dylan_hung@aspeedtech.com> <20201019085717.32413-5-dylan_hung@aspeedtech.com>
In-Reply-To: <20201019085717.32413-5-dylan_hung@aspeedtech.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 20 Oct 2020 04:14:42 +0000
Message-ID: <CACPK8Xc8NSBzN+LnZ=b5t7ODjLg9B6m2WDdR-C9SRWaDEXwOtQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] ftgmac100: Restart MAC HW once
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 at 08:57, Dylan Hung <dylan_hung@aspeedtech.com> wrote:
>
> The interrupt handler may set the flag to reset the mac in the future,
> but that flag is not cleared once the reset has occured.
>
> Fixes: 10cbd6407609 ("ftgmac100: Rework NAPI & interrupts handling")
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> Signed-off-by: Joel Stanley <joel@jms.id.au>

Reviewed-by: Joel Stanley <joel@jms.id.au>

> ---
>  drivers/net/ethernet/faraday/ftgmac100.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index 0c67fc3e27df..57736b049de3 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1326,6 +1326,7 @@ static int ftgmac100_poll(struct napi_struct *napi, int budget)
>          */
>         if (unlikely(priv->need_mac_restart)) {
>                 ftgmac100_start_hw(priv);
> +               priv->need_mac_restart = false;
>
>                 /* Re-enable "bad" interrupts */
>                 ftgmac100_write(FTGMAC100_INT_BAD, priv->base + FTGMAC100_OFFSET_IER);
> --
> 2.17.1
>
