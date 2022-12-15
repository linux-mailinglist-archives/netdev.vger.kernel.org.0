Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E7964DE8F
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiLOQ0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiLOQ0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:26:17 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B36C32BA8;
        Thu, 15 Dec 2022 08:24:17 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so3259754pjp.1;
        Thu, 15 Dec 2022 08:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tGefUBr2W7spPXd7S1x7+HWVOufLLWK4DpNQYScL5OA=;
        b=Ybv58xGsPBeXaxrgXi6jw3ExfitRffCWCJwF6G/RAQvCJ1vuZr2locJEdbIaFhkpU2
         ReC6ksP6uEI7p7Wry56dFus/OWN0GGDoAuQYfAd/FisSQ75ICvU+gW12AG+k10JyexuK
         tsph9cHf6BZ86ifuzGvN7x9VYnY4niWqNZkCFJrxJbRmHlhS/uIODJXXH7s41zIYhlCK
         gctkPXYqM2L7a7Gk1d1VD6HgkgxNmVdMSZXjxc8J+MvHDYZVxzu6fTGAaFKnftsffltU
         bIgzNaQo1xMPWZGX8oyKL9D5Dk069kbXFufjguSfXPvj6bBq4iyMYVvoYoXfdrbMQLKR
         iffA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tGefUBr2W7spPXd7S1x7+HWVOufLLWK4DpNQYScL5OA=;
        b=UKxTOXYMP2N/17D+pHDcX6yZYKhuJCujQtqMrxoC4WYIKkdBwApKTNc01x5wQMgwPW
         SCdJMdQ0DdPNQJos7N5R8HEPhnt0dHHfu1Yh7IBNLsvPndQd748SYcOlaR/OnA956Kfn
         0/qnjB/WtfdmGQYonn2ea4gFAK0zAe798L8FMowX6cn4SYmXoATdFQxXM3VmrKvRdz0J
         nmkxCv4a6MfKWQelC9ymvnIFkXz5HdCz/HA3Pt2FN10hDfyerYRRNhZR0I6xtcOsV833
         i3vfhA0zhdcVnYGM9AkYDk7qdokwQ65s4zhYz3U6nbIjWCy+8x9lUSPY7kTphF8zZfIw
         DaJA==
X-Gm-Message-State: ANoB5pkLk9XJB5E8DJS1MkUTcok71mnMP7snlERu6iH6Ke2VsFkoiBgh
        yGL39twJLGQ83FwE3ndWtb0=
X-Google-Smtp-Source: AA0mqf4nhSRttIqIJW9eXbFyJJfJt/mem/BjV2lPyHjtO+C2rdJOiCmEAoVhGyQtTRAdXuVIUG4bBA==
X-Received: by 2002:a17:903:2448:b0:189:f277:3830 with SMTP id l8-20020a170903244800b00189f2773830mr43351194pls.68.1671121456998;
        Thu, 15 Dec 2022 08:24:16 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id b4-20020a170902d50400b00182a9c27acfsm4002897plg.227.2022.12.15.08.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 08:24:16 -0800 (PST)
Message-ID: <7211782676442c6679d8a016813fd62d44cbebad.camel@gmail.com>
Subject: Re: [PATCH net-next v2 1/1] net: neigh: persist proxy config across
 link flaps
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     David Decotigny <decot+git@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        David Decotigny <ddecotig@google.com>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
Date:   Thu, 15 Dec 2022 08:24:15 -0800
In-Reply-To: <20221214232059.760233-1-decot+git@google.com>
References: <20221214232059.760233-1-decot+git@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-12-14 at 15:20 -0800, David Decotigny wrote:
> From: David Decotigny <ddecotig@google.com>
>=20
> Without this patch, the 'ip neigh add proxy' config is lost when the
> cable or peer disappear, ie. when the link goes down while staying
> admin up. When the link comes back, the config is never recovered.
>=20
> This patch makes sure that such an nd proxy config survives a switch
> or cable issue.
>=20
> Signed-off-by: David Decotigny <ddecotig@google.com>
>=20
>=20
> ---
> v1: initial revision
> v2: same as v1, except rebased on top of latest net-next, and includes "n=
et-next" in the description
>=20
>  net/core/neighbour.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index f00a79fc301b..f4b65bbbdc32 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -426,7 +426,10 @@ static int __neigh_ifdown(struct neigh_table *tbl, s=
truct net_device *dev,
>  {
>  	write_lock_bh(&tbl->lock);
>  	neigh_flush_dev(tbl, dev, skip_perm);
> -	pneigh_ifdown_and_unlock(tbl, dev);
> +	if (skip_perm)
> +		write_unlock_bh(&tbl->lock);
> +	else
> +		pneigh_ifdown_and_unlock(tbl, dev);
>  	pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL,
>  			   tbl->family);
>  	if (skb_queue_empty_lockless(&tbl->proxy_queue))

This seems like an agressive approach since it applies to all entries
in the table, not just the permenant ones like occurs in
neigh_flush_dev.

I don't have much experience in this area of the code but it seems like
you would specifically be wanting to keep only the permanant entries.
Would it make sense ot look at rearranging pneigh_ifdown_and_unlock so
that the code functioned more like neigh_flush_dev where it only
skipped the permanant entries when skip_perm was set?


