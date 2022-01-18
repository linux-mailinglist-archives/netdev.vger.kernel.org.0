Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703E6492167
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 09:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbiARIlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 03:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344683AbiARIlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 03:41:09 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7918C06161C
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 00:41:08 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id g12so1339165ybh.4
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 00:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RFkYsmyKXVxPgy1SNKAFnzRSO2aG6JX2VOeyMG/TA8Y=;
        b=XP8NwWLgL+XCYb0wC9m2BK/1T8Shj1KIZKM0l+yLNIJg2YkgI5EPN62q5BVBLToJLc
         Ulz0z+cLA1JJmL4x5lRXrMnuaq0cM9IzlaWPg+dEFWf5iSUWhNV0ErVnTCRfVKQWeMEn
         B9d3O8nIy1fm6PiQpekozB/aizCJ1rhaXrsAnY2sb43xGFPY8RtRACrusxpLgpoGAV3O
         Gs/Rg+/r85jjc086VJOoOJfY7TQlDC2yg2GWX6HY6+DR4a0teunNQylw+bgjIsYaxHNu
         +e22FNU2/edLcaSxfpAmAcFpVXPyz4s1/dBZWmyxziytmV/Dvca9qTfUgJWt1x0rdlP1
         2P7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RFkYsmyKXVxPgy1SNKAFnzRSO2aG6JX2VOeyMG/TA8Y=;
        b=UdLvMdGBpuW61FXiXjvQFwOu3xTWRXU8BRDhuyyoNjSrr9Jf/z4NRqBrvgPCB24Dz0
         V5WjanriObchqkPS12oxDVvRJxTk+rlpl4E5AxMK42vcV1GkC/EbRBLseQuFa52gebIm
         /0NjDUJcLTQ0MjyxiV7ze5zLMBe8twBd1LaLGHgQK4/jDp4A16L3qwZpVUKbff3OrH1I
         74gQ4UDTO8IJgnQnYqLjP+9SdM5J5zTjf/rxlVaOKk3DinILglU/tV2EO4B7FYGE6duu
         phhmx7SE6lFdZXkjinr0YiehyPO+kpGQq5UcO0ox0fb3mzauZnIEI1WBsO+BPymPWC3T
         bfhw==
X-Gm-Message-State: AOAM531YAbtrBE5j/pN+uiiMTZfEiJMPnTgplsb92L+PngsHY7a8o8zX
        8TnmbWWr++Ng0RaiBaourLDkSBANf7FLyQ+dOazvVbh+drM=
X-Google-Smtp-Source: ABdhPJyrH1erOmQucbY+yL2P4kCN0PoStEu3D/B7MVpijeSb2GvJKCtvD40QfpN496HFdMwF/xY2AIxMstEKexTjiyY=
X-Received: by 2002:a25:b683:: with SMTP id s3mr30498921ybj.293.1642495267198;
 Tue, 18 Jan 2022 00:41:07 -0800 (PST)
MIME-Version: 1.0
References: <20220118070029.1157324-1-liu3101@purdue.edu>
In-Reply-To: <20220118070029.1157324-1-liu3101@purdue.edu>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 18 Jan 2022 00:40:56 -0800
Message-ID: <CANn89iJevGzP5r6sPXpX=pSxPJWZQHjKKYekZpFTG9xEq50pMg@mail.gmail.com>
Subject: Re: [PATCH net] net: fix information leakage in /proc/net/ptype
To:     Congyu Liu <liu3101@purdue.edu>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, rsanger@wand.net.nz,
        Wang Hai <wanghai38@huawei.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        jiapeng.chong@linux.alibaba.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 11:01 PM Congyu Liu <liu3101@purdue.edu> wrote:
>
> In one net namespace, after creating a packet socket without binding
> it to a device, users in other net namespaces can observe the new
> `packet_type` added by this packet socket by reading `/proc/net/ptype`
> file. I believe this is minor information leakage as packet socket is
> namespace aware.
>
> Add a function pointer in `packet_type` to retrieve the net namespace
> of corresponding packet socket. In `ptype_seq_show`, if this
> function pointer is not NULL, use it to determine if certain ptype
> should be shown.
>
> Signed-off-by: Congyu Liu <liu3101@purdue.edu>
> ---
>  include/linux/netdevice.h |  1 +
>  net/core/net-procfs.c     |  3 ++-
>  net/packet/af_packet.c    | 18 ++++++++++++++++++
>  3 files changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 3213c7227b59..72d3601850c5 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2548,6 +2548,7 @@ struct packet_type {
>                                               struct net_device *);
>         bool                    (*id_match)(struct packet_type *ptype,
>                                             struct sock *sk);
> +       struct net              *(*get_net) (struct packet_type *ptype);
>         void                    *af_packet_priv;
>         struct list_head        list;
>  };

Patch looks fine, but the question is:

Can an af_packet socket created in netns A can be moved to netns B later ?

As the answer is probably no, it seems we could simply add a 'struct
net'  pointer
 in 'struct packet type', no need for a function.

Thanks.
