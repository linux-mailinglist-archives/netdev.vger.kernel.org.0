Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414D722F3D0
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 17:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbgG0PZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 11:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbgG0PZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 11:25:07 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B20C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 08:25:07 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id p8so1059664vsm.12
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 08:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A5h4dypQhPAc0R/aU8Jwb6K0bgrXHrhCmVpPhAKripM=;
        b=GisZaL/7Qt/4OjXysuizXCWvCY3p1qfFDe7GTYtN6774paQlFXk1sOL4YBhwGvhDFU
         cT+GekNpNgnFKGGYc6AW0/sD8qKtEkytq6gMN39s1auq4EgpGqd9p3KnVnw7OS+Be19h
         YHo2E/Kt0/rRuSjADKIk8dNKzz5St/T4Kg5pO0JULgpHxyhXYGt0RFxK8kUaD+KjAcVf
         Y4lpiJaqKXIAPio1hC9LwbEREw/kgi0dIBEELGejInujCKFdvLtQ502nSEl+L7pT5GqK
         DVjmS9vY+Qt+pFsDctNpXljnVqvkKLNMGZygHqGkMtDtUCLZ9H9O4g99dmdFrNBlP3QU
         u0eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A5h4dypQhPAc0R/aU8Jwb6K0bgrXHrhCmVpPhAKripM=;
        b=HAfyDGE+e7ssHSDdPeVuyYWCLRCV4o89+wH3Yx1+tlnIkG0rOuvgixmOU1KRf9quow
         vkEM28wk5nhGzS21+QyMsjQHg2K2jZO4mSv8yTiREiaZbQebmpyXVemWpBWRlxpTZTz+
         nFlAo8ZTO0ZGW6yxB6cYjQPxp1vMevLPC0MDLsixbKqC7si0ey5fiTTEb4cc2j406y6i
         bfkZGClWzeapoAjiFP/kei0fcTdEw5CF7c83yk/XTj3WBHiV/wO1Oa9K3nefhDur7+87
         pRzEXYifUx1SaTuBNYYjbI9EbUsEuIsB8w88vteRBIed6eSbn12w+XlDk43h/od5kNuo
         4Huw==
X-Gm-Message-State: AOAM531rf+L7q4wIQ8hsD2YpnsiGXzvAizudxGiLWQZVCtYKv0b/AG5D
        neUVK2Kb84F5md6Ym4abiBWCPRH33lhmqdgxEmiJcrfo
X-Google-Smtp-Source: ABdhPJzahywUOVgaAe4ka/clyzKJjIQuNO4hvefSXQ8Avtu2tf2Hrh0WZuiAiMchxhzpMuFKNuv8sYLPhg6/8z9Od+c=
X-Received: by 2002:a05:6102:201b:: with SMTP id p27mr2418135vsr.145.1595863506821;
 Mon, 27 Jul 2020 08:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com> <20200727052846.4070247-9-jonathan.lemon@gmail.com>
In-Reply-To: <20200727052846.4070247-9-jonathan.lemon@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jul 2020 08:24:55 -0700
Message-ID: <CANn89i+AZ9PnRssWpiE5zj41V1=85Jcy80Rtbp7mLjp73Y71Pw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 08/21] skbuff: add a zc_netgpu bitflag
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        borisp@mellanox.com, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:20 AM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> This could likely be moved elsewhere.  The presence of the flag on
> the skb indicates that one of the fragments may contain zerocopy
> RX data, where the data is not accessible to the cpu.

Why do we need yet another flag in skb exactly ?

Please define what means "data not accessible to the cpu" ?

This kind of change is a red flag for me.
