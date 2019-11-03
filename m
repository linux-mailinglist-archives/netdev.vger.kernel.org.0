Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E18DEED256
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 07:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfKCGrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 01:47:46 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:42525 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKCGrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 01:47:45 -0500
X-Originating-IP: 209.85.222.51
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
        (Authenticated sender: pshelar@ovn.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id B0F9CC0003
        for <netdev@vger.kernel.org>; Sun,  3 Nov 2019 06:47:44 +0000 (UTC)
Received: by mail-ua1-f51.google.com with SMTP id k11so1405852ual.10
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 23:47:44 -0700 (PDT)
X-Gm-Message-State: APjAAAUZLV7PHGPlVhUfHlHulkBz8vArm4ReLSUe6cQ4BiXGKNUFCjgZ
        BQdbBdBN1XO71HoMASD3iVWxlWPWYVpzG8JH7Ac=
X-Google-Smtp-Source: APXvYqz6Wdq0M3DnFpgBuCv563fuOIv8G7oCtPQ7jroFrwBLoW/wOLzdc4xk8FAHromvT057xB24SBFLkCMk+QWS52o=
X-Received: by 2002:ab0:6994:: with SMTP id t20mr9226051uaq.124.1572763663495;
 Sat, 02 Nov 2019 23:47:43 -0700 (PDT)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com> <1572618234-6904-6-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1572618234-6904-6-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 2 Nov 2019 23:47:32 -0700
X-Gmail-Original-Message-ID: <CAOrHB_CkZJ+w3LvUyzUZRgnFa1JnkkKY85XsjEMvXD4geAzW4g@mail.gmail.com>
Message-ID: <CAOrHB_CkZJ+w3LvUyzUZRgnFa1JnkkKY85XsjEMvXD4geAzW4g@mail.gmail.com>
Subject: Re: [PATCH net-next v6 05/10] net: openvswitch: optimize flow-mask
 looking up
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 1, 2019 at 7:24 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The full looking up on flow table traverses all mask array.
> If mask-array is too large, the number of invalid flow-mask
> increase, performance will be drop.
>
> One bad case, for example: M means flow-mask is valid and NULL
> of flow-mask means deleted.
>
> +-------------------------------------------+
> | M | NULL | ...                  | NULL | M|
> +-------------------------------------------+
>
> In that case, without this patch, openvswitch will traverses all
> mask array, because there will be one flow-mask in the tail. This
> patch changes the way of flow-mask inserting and deleting, and the
> mask array will be keep as below: there is not a NULL hole. In the
> fast path, we can "break" "for" (not "continue") in flow_lookup
> when we get a NULL flow-mask.
>
>          "break"
>             v
> +-------------------------------------------+
> | M | M |  NULL |...           | NULL | NULL|
> +-------------------------------------------+
>
> This patch don't optimize slow or control path, still using ma->max
> to traverse. Slow path:
> * tbl_mask_array_realloc
> * ovs_flow_tbl_lookup_exact
> * flow_mask_find
>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> ---
Acked-by: Pravin B Shelar <pshelar@ovn.org>
