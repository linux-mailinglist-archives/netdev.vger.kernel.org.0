Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA5C3C337B
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 09:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhGJHcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 03:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhGJHcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 03:32:31 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE305C0613DD;
        Sat, 10 Jul 2021 00:29:46 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id l24so17463596edr.11;
        Sat, 10 Jul 2021 00:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Dh72EK5/SiBR8KllN0qdcxlDb8Yo3mwu0VvIG7FbaQ=;
        b=LE0Sl+w9F4cSsBo7FXAOGX3qh+jKFMWCwJEUrpFXg4yYAZHS319uYULD+w0XSEO3hs
         N/enlJhmljGwIRmoGg1vKiYBbaaLM7L5TwEz9aAzJJDUqU6k2+lhpwSbBTxC/m3KbQVc
         K//Nl1GNzFcfVpmJ5uvydYxE1szm+PgqZggs32dk9CdGLJS1/0lkegN40VmB3IMW4vhV
         UrgxnDCmBSoHTpmgKcZx5cKDzo9vUquzjWGdT1oLrHr+7nHHHAbyMGAserwa8Cjcy8o/
         vrQcZ/XTWBeABPDQ7TowavBhAzciCicELs+1iyDljLst6lxbAefiYc8S5ZPNPcBcT2dS
         TkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Dh72EK5/SiBR8KllN0qdcxlDb8Yo3mwu0VvIG7FbaQ=;
        b=Pp9BQSW8+Z6nbqakoGSftFfcV/rywQXSN2v56seWZRCC5dnVxF2gZNJ8pjG2o1RF7q
         SZFGXqeoYIP6hu3LjkU2RnPEm2sXB7H7F5HBs3EwdqdhKrNLuCyIAIe851ww4UoM1L4O
         NCppSVWj+6GH31GTk42CT7MQuPpGDeVKxniVwdm/q1vWoz+Erjncpkaq7Uzqzmk7y7sy
         4uQNbz5CzHDGPD1Fx9/sqlJTxCjj9BVy/tHUxkR26u9zCrM1QIumgIpfPEnhlYuP7Ooy
         cDmrTfpwjFEz0OQIfMtIbHd+SkkDkqYRLUmjrfLADObxFqLP3JywONdZBI+jS1Qqei9f
         FDyQ==
X-Gm-Message-State: AOAM533uM6ntv7b5e8RwnI27AqAiGGc3cIoOXw2eJZRfvrifqGdFGOj+
        Arfpe22adHR8jReFa++YOiuBqqugwcFx3hfFpaI=
X-Google-Smtp-Source: ABdhPJymGtBFX5ZyugF1Tt11f6RgkZcMDgjthoIIWOKIBs1HvxOIXVx6WNapqXNLKsE5fUJRBD2vIfpmIhdmSaiNW7k=
X-Received: by 2002:a05:6402:5114:: with SMTP id m20mr52905547edd.174.1625902185185;
 Sat, 10 Jul 2021 00:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1625900431.git.paskripkin@gmail.com> <cec894625531da243df3a9f05466b83e107e50d7.1625900431.git.paskripkin@gmail.com>
In-Reply-To: <cec894625531da243df3a9f05466b83e107e50d7.1625900431.git.paskripkin@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Sat, 10 Jul 2021 15:29:19 +0800
Message-ID: <CAD-N9QWcOv0s4uzPW0kGk70tpkCjorQCKpa3RrtbxyMmSW5b=Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: cipso: fix memory leak in cipso_v4_doi_free
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 3:10 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> When doi_def->type == CIPSO_V4_MAP_TRANS doi_def->map.std should
> be freed to avoid memory leak.
>
> Fail log:
>
> BUG: memory leak
> unreferenced object 0xffff88801b936d00 (size 64):
> comm "a.out", pid 8478, jiffies 4295042353 (age 15.260s)
> hex dump (first 32 bytes):
> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00 00 00 00 15 b8 12 26 00 00 00 00 00 00 00 00  .......&........
> backtrace:
> netlbl_cipsov4_add (net/netlabel/netlabel_cipso_v4.c:145 net/netlabel/netlabel_cipso_v4.c:416)
> genl_family_rcv_msg_doit (net/netlink/genetlink.c:741)
> genl_rcv_msg (net/netlink/genetlink.c:783 net/netlink/genetlink.c:800)
> netlink_rcv_skb (net/netlink/af_netlink.c:2505)
> genl_rcv (net/netlink/genetlink.c:813)
>
> Fixes: b1edeb102397 ("netlabel: Replace protocol/NetLabel linking with refrerence
> counts")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>  net/ipv4/cipso_ipv4.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> index bfaf327e9d12..e0480c6cebaa 100644
> --- a/net/ipv4/cipso_ipv4.c
> +++ b/net/ipv4/cipso_ipv4.c
> @@ -472,6 +472,7 @@ void cipso_v4_doi_free(struct cipso_v4_doi *doi_def)
>                 kfree(doi_def->map.std->lvl.local);
>                 kfree(doi_def->map.std->cat.cipso);
>                 kfree(doi_def->map.std->cat.local);
> +               kfree(doi_def->map.std);
>                 break;
>         }
>         kfree(doi_def);
> --

Hi Paval,

this patch is already merged by Paul. See [1] for more details.

[1] https://lore.kernel.org/netdev/CAHC9VhQZVOmy7n14nTSRGHzwN-y=E_JTUP+NpRCgD8rJN5sOGA@mail.gmail.com/T/

> 2.32.0
>
