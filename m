Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF9B210BE1
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 19:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfEARR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 13:17:28 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33779 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfEARR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 13:17:28 -0400
Received: by mail-lj1-f193.google.com with SMTP id f23so16061322ljc.0;
        Wed, 01 May 2019 10:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tb3e5ndhy+yPYfLxxwqvS+VC2wvQfTcibV/Zpc10t8Q=;
        b=M6re7UiwzFF81SnvukKzpOhzXOVMusmPCGgYLA0vFDmgKc+WjzPpsG9q2me+FOZrUK
         55erpX71KWunJAh5MXpnVoW4KxPWQGbCyN5+w1hn40qIVvC5eB43ErBvrZ6wZok/vbW2
         uqt5PrFvhVhjXPAmxCQqhXHwTxNHbeFIBlBN6yIYd+u28S3DVPnVgxnvssnM6Hq6zdeO
         RlOFuVTYCwZ35nTLZaW4TNexXJgIIVNq0xkMrH4KJ4TKgkGUCPcvIZK+ij5J5Azffzi3
         ByDC3sOmKjns6h5AyldOQrlX5a3jBmNHO8jLwJede/8NuAZBXQfyC5Vye7LxkT5YPkaZ
         cZvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tb3e5ndhy+yPYfLxxwqvS+VC2wvQfTcibV/Zpc10t8Q=;
        b=PBhR8+om3Eq+SQowSnWesTVw2lF1PskkC/ix665qCLtgBlJ8n/+WMbRg6ULRMqd9mW
         frUmJXOFpV4mY1uSMA682UxCidiJ2ixW6T4fn/YjPYpG8hya09THndZflnfZvykxaNBk
         yGnjXS9XOba8MSL5Sv8ax1PNGHnmDaQDlk5OkXZxtWaAq/7kSL/ILh6uzNP8+vnH2Y1h
         rfr46GvhqMF0EZqQnuu9iii3WqbWSyyzyV4rjO68f915rOUydOJtMX0mPX9GD1iBDmv8
         6OiZy3DWae0uwM8L+zaxF6SJL3IZv1MOoiVZPfV9sv9fERClIqehVQYAS1ZNVNNfovF3
         aVFQ==
X-Gm-Message-State: APjAAAUtcasoZ1R46zI3ky3SExtCRTzFEwv1GoUZqzuqOAVun4bFxFJ/
        bk1kVyUEACNtZCFntyFXcIn1ZZjF/MD6E/5UrKc=
X-Google-Smtp-Source: APXvYqwQLXbgeLz+rgT79Zp142ymbrEJCJe2sY3bjwnPhirtV576CfqsSAvz58YD9Q1Mw/IiKthO54oGaz/Ho4ZoktY=
X-Received: by 2002:a2e:92ce:: with SMTP id k14mr16778740ljh.83.1556731045705;
 Wed, 01 May 2019 10:17:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190501134158.15307-1-colin.king@canonical.com>
In-Reply-To: <20190501134158.15307-1-colin.king@canonical.com>
From:   Yi-Hung Wei <yihung.wei@gmail.com>
Date:   Wed, 1 May 2019 10:17:15 -0700
Message-ID: <CAG1aQhLQ5kLV4TuYU0fwTviDoaZmryyZ+kWbsj=Bdo+CxFXQtA@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH][next] openvswitch: check for null pointer
 return from nla_nest_start_noflag
To:     Colin King <colin.king@canonical.com>
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 1, 2019 at 6:42 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> The call to nla_nest_start_noflag can return null in the unlikely
> event that nla_put returns -EMSGSIZE.  Check for this condition to
> avoid a null pointer dereference on pointer nla_reply.
>
> Addresses-Coverity: ("Dereference null return value")
> Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/openvswitch/conntrack.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index c4128082f88b..333ec5f298fe 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -2175,6 +2175,10 @@ static int ovs_ct_limit_cmd_get(struct sk_buff *skb, struct genl_info *info)
>                 return PTR_ERR(reply);
>
>         nla_reply = nla_nest_start_noflag(reply, OVS_CT_LIMIT_ATTR_ZONE_LIMIT);
> +       if (!nla_reply) {
> +               err = -EMSGSIZE;
> +               goto exit_err;
> +       }
>
>         if (a[OVS_CT_LIMIT_ATTR_ZONE_LIMIT]) {
>                 err = ovs_ct_limit_get_zone_limit(
> --
Thanks for the bug fix.  Should it be on net rather than net-next?

Acked-by: Yi-Hung Wei <yihung.wei@gmail.com>
