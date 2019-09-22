Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF44BA059
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 05:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfIVDNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 23:13:47 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:56261 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbfIVDNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 23:13:47 -0400
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
        (Authenticated sender: pshelar@ovn.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 0B9B420000B
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 03:13:43 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id v10so7260124vsc.7
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 20:13:43 -0700 (PDT)
X-Gm-Message-State: APjAAAVR62cMzuVhNaCLB+plODtHO32Qo8Tu5vVfVr2dbLcyfTjZxtZg
        iiL9TdZz+EvP/L+jMtMQn5GhyznIcDaZ6MQmhGY=
X-Google-Smtp-Source: APXvYqyN+Dm874jrS57R9SCAkYko4VrfsMLd7LgVSr23ogFIVYBW6IH9ImUI7bXZGigJPOYPoHnu8jTW8M8AK3wW6dQ=
X-Received: by 2002:a67:b646:: with SMTP id e6mr6397092vsm.93.1569122020676;
 Sat, 21 Sep 2019 20:13:40 -0700 (PDT)
MIME-Version: 1.0
References: <1568734808-42628-1-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1568734808-42628-1-git-send-email-xiangxia.m.yue@gmail.com>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Sat, 21 Sep 2019 20:17:00 -0700
X-Gmail-Original-Message-ID: <CAOrHB_DONiJ7Z41xAm5DhkjcrXDrgu6XNpscw1qf592wdMH5bg@mail.gmail.com>
Message-ID: <CAOrHB_DONiJ7Z41xAm5DhkjcrXDrgu6XNpscw1qf592wdMH5bg@mail.gmail.com>
Subject: Re: [PATCH net] net: openvswitch: fix possible memleak on create
 vport fails
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Hillf Danton <hdanton@sina.com>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Taehee Yoo <ap420073@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 21, 2019 at 8:07 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> If we register a net device which name is not valid
> (dev_get_valid_name), register_netdevice will return err
> codes and will not run dev->priv_destructor. The memory
> will leak. This patch adds check in ovs_vport_free and
> set the vport NULL.
>
> Fixes: 309b66970ee2 ("net: openvswitch: do not free vport if register_netdevice() is failed.")
> Cc: Taehee Yoo <ap420073@gmail.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
>  net/openvswitch/vport-internal_dev.c | 8 ++------
>  net/openvswitch/vport.c              | 9 +++++++++
>  2 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
> index d2437b5..074c43f 100644
> --- a/net/openvswitch/vport-internal_dev.c
> +++ b/net/openvswitch/vport-internal_dev.c
> @@ -159,7 +159,6 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
>         struct internal_dev *internal_dev;
>         struct net_device *dev;
>         int err;
> -       bool free_vport = true;
>
>         vport = ovs_vport_alloc(0, &ovs_internal_vport_ops, parms);
>         if (IS_ERR(vport)) {
> @@ -190,10 +189,8 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
>
>         rtnl_lock();
>         err = register_netdevice(vport->dev);
> -       if (err) {
> -               free_vport = false;
> +       if (err)
>                 goto error_unlock;
> -       }
>
>         dev_set_promiscuity(vport->dev, 1);
>         rtnl_unlock();
> @@ -207,8 +204,7 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
>  error_free_netdev:
>         free_netdev(dev);
>  error_free_vport:
> -       if (free_vport)
> -               ovs_vport_free(vport);
> +       ovs_vport_free(vport);
>  error:
>         return ERR_PTR(err);
>  }
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 3fc38d1..281259a 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -157,11 +157,20 @@ struct vport *ovs_vport_alloc(int priv_size, const struct vport_ops *ops,
>   */
>  void ovs_vport_free(struct vport *vport)
>  {
> +       /* We should check whether vport is NULL.
> +        * We may free it again, for example in internal_dev_create
> +        * if register_netdevice fails, vport may have been freed via
> +        * internal_dev_destructor.
> +        */
> +       if (unlikely(!vport))
> +               return;
> +
>         /* vport is freed from RCU callback or error path, Therefore
>          * it is safe to use raw dereference.
>          */
>         kfree(rcu_dereference_raw(vport->upcall_portids));
>         kfree(vport);
> +       vport = NULL;
>  }
>  EXPORT_SYMBOL_GPL(ovs_vport_free);
>
> --

There is already patch a patch to fix this memory leak.
https://patchwork.ozlabs.org/patch/1144316/
Can you or Hillf post it on netdev list?

Thanks.
