Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCF948C466
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 14:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353380AbiALNHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 08:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353370AbiALNHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 08:07:01 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4231FC06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 05:07:01 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id m6so6141672ybc.9
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 05:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QoQdoesDidCN5z4K1TfE/oxDwd8GfagNFE2hl9gCHOY=;
        b=YhqAIMI3bQS2DPsI1p3C/hZfHN6j8oHqaHz8ABgNnBi+A3CzOif+9IGVT3TavEHthK
         0kcKHkXdx8mGzUXPCMH0dd7TS6Mm8bhJzmu8eyez+xjrokNS+ssqsKe7Vydkm6d+h5/s
         sNmKgbQcjRaMPptDhSlaFwJ7PoP1M5+1V7VLLmW7RIBbhVw6XL8WHaARqJgQKYUYefNr
         nx64uE5pN5zsLq9hay4bA0npqLsZojvrUSkUNAxLtqLhNmle3ORTw4XnbrjNBeYBJk0C
         qM0RFZCodnxU1GCo4q6vazFBScmyiNIMUDKEC7KijculYg3imJMMxBh7RPWOMY1yrL32
         vC6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QoQdoesDidCN5z4K1TfE/oxDwd8GfagNFE2hl9gCHOY=;
        b=NJeoH29VpqeSeueqcSqIqytdi+mYulDfGfcCumtuHwE3GCthZg3ymwQBF+bIIOAqJp
         izkBTo1sf0A0EaYsUIUY3WAcD4JcycDTs+0N3n8R5K5WFhu9WJXHdXvM6s/8ryngxgdV
         u0JVBMfTlVzh6XSt9GyHujvjX8dmGrUdoqkGu6GPyuwKSWr9xYJsmIujB0yldGvAj2H1
         oxfg8/rak4UrTUP8u02g8ABytBjgyR3YT3z1dCuJ4yZpUZ/OIOFg6+G3lNjaLlCBz1YJ
         cxG/XY/IK/BUvq1QDMUJbgKLH23mM/dTSenDaRlLAtTaEZIwQfX/equQ6dwepPdNDvsg
         OuRw==
X-Gm-Message-State: AOAM530Y90hGc5J+FdjUAyN6WGPrrq6r06uVMQk/WWQSPeoWyLOLs20N
        849olnGfC8/MdPOx7mqvIweZGaDaFSIsqKuH6ugtfA==
X-Google-Smtp-Source: ABdhPJz+ScqSGCOyGak1a/45rr2pSio2pjaIRkXzqJnCCQuiDBdUAnQi+WLbTRrSaiUB1RPBEOT0S7itC0kxed0O2mI=
X-Received: by 2002:a25:2d64:: with SMTP id s36mr12584693ybe.277.1641992820194;
 Wed, 12 Jan 2022 05:07:00 -0800 (PST)
MIME-Version: 1.0
References: <20220112102805.488510-1-maximmi@nvidia.com>
In-Reply-To: <20220112102805.488510-1-maximmi@nvidia.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 Jan 2022 05:06:49 -0800
Message-ID: <CANn89iL4RLjcJH8s4HAUoSa4cxAztkhx-4rsUZ2xwY8tYbPcCg@mail.gmail.com>
Subject: Re: [PATCH] sch_api: Don't skip qdisc attach on ingress
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tariq Toukan <tariqt@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 2:28 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> The attach callback of struct Qdisc_ops is used by only a few qdiscs:
> mq, mqprio and htb. qdisc_graft() contains the following logic
> (pseudocode):
>
>     if (!qdisc->ops->attach) {
>         if (ingress)
>             do ingress stuff;
>         else
>             do egress stuff;
>     }
>     if (!ingress) {
>         ...
>         if (qdisc->ops->attach)
>             qdisc->ops->attach(qdisc);
>     } else {
>         ...
>     }
>
> unregister_netdevice: waiting for lo to become free. Usage count = 2
>
> This commit addresses the issue by running "do ingress stuff" in the
> ingress flow even in the attach callback is present, which is fine,
> because attach isn't going to be called afterwards.
>
> The bug was found by syzbot and reported by Eric.
>
> Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reported-by: Eric Dumazet <edumazet@google.com>
> ---

Thanks for fixing this issue.

Reviewed-by: Eric Dumazet <edumazet@google.com>
