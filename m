Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD8E0CAE2D
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 20:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388585AbfJCSaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 14:30:03 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40420 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729199AbfJCSaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 14:30:03 -0400
Received: by mail-qk1-f195.google.com with SMTP id y144so3351788qkb.7;
        Thu, 03 Oct 2019 11:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xVOsopYF/M0SJfUpw8uzTPzjhSyoEQWnL9exPjNMiDw=;
        b=XLaFwylBl/MAH8vjX4IguuG9kZGDMB4N9fOgEQVAXLrT9Xl7fgwOUB+B+2EpzsmsNT
         H1bIyY1OITdXl4uaQu03SpChBfJJx5T3yuG19pFhuy3xPpcUqC95xmYRzCkHTsWl3dK6
         h68au5Ur+XNlpF9Knu+RH+2tzlt2LlOzOfpc76FZ6f7Q5UTDFre69380BcfqiOYTsW3h
         PDsPPL+BK4cmutWjd+O/Gd09cAFap6SgcJKOKVuO9F1tpP2VApBEMBJs36c66OBXZdKO
         tDrvfM7jh0//NjI4vuy/l8dnX8bxtz0NZV5IS9O22fN6NKrrJwbZjdqGFENbNJgLc3ix
         jmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xVOsopYF/M0SJfUpw8uzTPzjhSyoEQWnL9exPjNMiDw=;
        b=LrtGotheP4m5PS3g8wL+W/0dMWY/g4yBeP9Lu462hNJif6D9vQsZs0EnYNTDFp24S7
         wFb/7bIdknFlmaLUt6W8/bAgrZ6O/Dx6yZAkd1UcJADdn+A1DllzZjQG9TUS3XLUHwnS
         dXBXST7xJQeit0xVniDObjbx/Wk/UPgSDSBFsUDdh2/sf446YH59+1rDDwX0Zhx3dwss
         ALcj7+0YqP98dDcestCdrAvDF0Jn2RD+u71c4IFNBvn2KF+0I0xezKwUuPpj3SW7OwwX
         g+0Vnc3S7XRFgWWVy9YJoG+1yDOqliz8yAllisJk4RV3JQU5lDE81y+LKtSCu3Yo0L9N
         OrHw==
X-Gm-Message-State: APjAAAVuvTf7uB4lGHWLsCUfU2rkrSwz+/KoU6JiQhU3VoD4bnz4TgoS
        ZGgyJ28ajgEKPDF6tI4ikx4KEq/wh+YEIHIsSb8=
X-Google-Smtp-Source: APXvYqz/O5Lsj4kVJ/3FOK0A7IwZlqd/CiocFrOc0esp2AIU0w10PtMdgyuGNugHD4Fmy4ajdULewG+Nto5Cx55HRu8=
X-Received: by 2002:a37:a586:: with SMTP id o128mr5829769qke.147.1570127401853;
 Thu, 03 Oct 2019 11:30:01 -0700 (PDT)
MIME-Version: 1.0
References: <1569567500-20113-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
In-Reply-To: <1569567500-20113-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
From:   William Tu <u9012063@gmail.com>
Date:   Thu, 3 Oct 2019 11:29:24 -0700
Message-ID: <CALDO+SYz1NkyeJvfGr17nMHmG-grWakDhJB6cFvXKn2Zy4c5hg@mail.gmail.com>
Subject: Re: [PATCH] erspan: remove the incorrect mtu limit for erspan
To:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 11:59 PM Haishuang Yan
<yanhaishuang@cmss.chinamobile.com> wrote:
>
> erspan driver calls ether_setup(), after commit 61e84623ace3
> ("net: centralize net_device min/max MTU checking"), the range
> of mtu is [min_mtu, max_mtu], which is [68, 1500] by default.
>
> It causes the dev mtu of the erspan device to not be greater
> than 1500, this limit value is not correct for ipgre tap device.
>
> Tested:
> Before patch:
> # ip link set erspan0 mtu 1600
> Error: mtu greater than device maximum.
> After patch:
> # ip link set erspan0 mtu 1600
> # ip -d link show erspan0
> 21: erspan0@NONE: <BROADCAST,MULTICAST> mtu 1600 qdisc noop state DOWN
> mode DEFAULT group default qlen 1000
>     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 0
>
> Fixes: 61e84623ace3 ("net: centralize net_device min/max MTU checking")
> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
> ---

Thanks for the patch!
Acked-by: William Tu <u9012063@gmail.com>


>  net/ipv4/ip_gre.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index a53a543..52690bb 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -1446,6 +1446,7 @@ static void erspan_setup(struct net_device *dev)
>         struct ip_tunnel *t = netdev_priv(dev);
>
>         ether_setup(dev);
> +       dev->max_mtu = 0;
>         dev->netdev_ops = &erspan_netdev_ops;
>         dev->priv_flags &= ~IFF_TX_SKB_SHARING;
>         dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
> --
> 1.8.3.1
>
>
>
