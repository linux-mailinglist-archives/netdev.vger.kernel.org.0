Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45FAB97B84
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 15:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbfHUN4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 09:56:07 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42526 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729178AbfHUN4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 09:56:06 -0400
Received: by mail-lf1-f66.google.com with SMTP id s19so1860501lfb.9
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 06:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ns8DMZPv6k41odjlM7JpWe0K8lZfRzmbTNvhbQqLO6M=;
        b=UwFslZE4tfWGGrwIEsnuWx112ARxg6tXyJybleO8UEuBLzXxo2Al0iHPEdTBMUuBoA
         KAtltPmBrf2n/Jz3eYXoNHFlt+XPCKKGu2LBCgqO4oy1BN7hqKD7f3sb3HAfeivEBUzM
         u3hYJS+9VjHsbCDG9zEwSBabIVGIF3+f5gB2838CEHN6xEdDObSES81y2Q1ohMHZdr0Y
         KaB29Rk0vwno2fgdXu3NKeIjwcZnV56npuyuVCUcR2261sZFQ4ff8CH4HKYdfXCKPXB2
         V/7sDro3nbPCRaHLj86lCCSDTigg5FXwWjUsOHELdQ5bKeMiROrN2xfJuvIxTavwCBL4
         I6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ns8DMZPv6k41odjlM7JpWe0K8lZfRzmbTNvhbQqLO6M=;
        b=hX625ILbImO/4sa7JATfAmNbICjmcwVa5crJ57+ALW82rpn28peT6bJ1mlNiZi9OYN
         R6+y/MUN9JZ8og6UgmCGrdWGU85ZGkyzno95fzKHcWsgC8CuZP3GZzK2KYY8fCReTFv1
         f6uOHUXkNnDCv8WVvT/pUiQhzC3oAihRbuinlyWgJxaQymfwRCJXZukEqnS0AkOlgCFH
         vSf5D4kJaQjImrtFfp68TIKJajQ58FL2JgSDhKXYlZy/bmQBiGR4APC5yi9BeVH4KnUp
         Gc8ye+qpE9TXAjNKZ6IJzpCwrrr80OgF65mugXtojyCWt88I95HH1Jock6KgDBJC6BM3
         SqJw==
X-Gm-Message-State: APjAAAW5yARE04T3s5miTC/H06/oEP/x6eHcMQ9gO3dsnFbOi4zQwCxu
        ZvULyXdakUT5R1/PekPzEksCCrP4ECkHuWpBrZ57Yc27
X-Google-Smtp-Source: APXvYqx+2nDGmqkxIIjquCYAPQe7evBFQp3UZFfKGHFPXmJPcwj5jGSuWmbrs4GcissOzk+vz7nINTFINWkY3x9UsTM=
X-Received: by 2002:a19:f007:: with SMTP id p7mr3491773lfc.24.1566395763652;
 Wed, 21 Aug 2019 06:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190821134547.96929-1-jeffv@google.com>
In-Reply-To: <20190821134547.96929-1-jeffv@google.com>
From:   Jeffrey Vander Stoep <jeffv@google.com>
Date:   Wed, 21 Aug 2019 15:55:52 +0200
Message-ID: <CABXk95A7EwpBd1Snek9gvZRGKNsgD7q4cCmHp8xwQ93_gDx-Gg@mail.gmail.com>
Subject: Re: [PATCH 1/2] rtnetlink: gate MAC address with an LSM hook
To:     netdev@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 3:45 PM Jeff Vander Stoep <jeffv@google.com> wrote:
>
> MAC addresses are often considered sensitive because they are
> usually unique and can be used to identify/track a device or
> user [1].
>
> The MAC address is accessible via the RTM_NEWLINK message type of a
> netlink route socket[2]. Ideally we could grant/deny access to the
> MAC address on a case-by-case basis without blocking the entire
> RTM_NEWLINK message type which contains a lot of other useful
> information. This can be achieved using a new LSM hook on the netlink
> message receive path. Using this new hook, individual LSMs can select
> which processes are allowed access to the real MAC, otherwise a
> default value of zeros is returned. Offloading access control
> decisions like this to an LSM is convenient because it preserves the
> status quo for most Linux users while giving the various LSMs
> flexibility to make finer grained decisions on access to sensitive
> data based on policy.
>
> [1] https://adamdrake.com/mac-addresses-udids-and-privacy.html
> [2] Other access vectors like ioctl(SIOCGIFHWADDR) are already covered
> by existing LSM hooks.
>
> Signed-off-by: Jeff Vander Stoep <jeffv@google.com>
> ---
>  include/linux/lsm_hooks.h |  8 ++++++++
>  include/linux/security.h  |  6 ++++++
>  net/core/rtnetlink.c      | 12 ++++++++++--
>  security/security.c       |  5 +++++
>  4 files changed, 29 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index df1318d85f7d..dfcb2e11ff43 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -728,6 +728,12 @@
>   *
>   * Security hooks for Netlink messaging.
>   *
> + * @netlink_receive
> + *     Check permissions on a netlink message field before populating it.
> + *     @sk associated sock of task receiving the message.
> + *     @skb contains the sk_buff structure for the netlink message.
> + *     Return 0 if the data should be included in the message.
> + *
>   * @netlink_send:
>   *     Save security information for a netlink message so that permission
>   *     checking can be performed when the message is processed.  The security
> @@ -1673,6 +1679,7 @@ union security_list_options {
>         int (*sem_semop)(struct kern_ipc_perm *perm, struct sembuf *sops,
>                                 unsigned nsops, int alter);
>
> +       int (*netlink_receive)(struct sock *sk, struct sk_buff *skb);
>         int (*netlink_send)(struct sock *sk, struct sk_buff *skb);
>
>         void (*d_instantiate)(struct dentry *dentry, struct inode *inode);
> @@ -1952,6 +1959,7 @@ struct security_hook_heads {
>         struct hlist_head sem_associate;
>         struct hlist_head sem_semctl;
>         struct hlist_head sem_semop;
> +       struct hlist_head netlink_receive;
>         struct hlist_head netlink_send;
>         struct hlist_head d_instantiate;
>         struct hlist_head getprocattr;
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 5f7441abbf42..46b5af6de59e 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -382,6 +382,7 @@ int security_getprocattr(struct task_struct *p, const char *lsm, char *name,
>                          char **value);
>  int security_setprocattr(const char *lsm, const char *name, void *value,
>                          size_t size);
> +int security_netlink_receive(struct sock *sk, struct sk_buff *skb);
>  int security_netlink_send(struct sock *sk, struct sk_buff *skb);
>  int security_ismaclabel(const char *name);
>  int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
> @@ -1162,6 +1163,11 @@ static inline int security_setprocattr(const char *lsm, char *name,
>         return -EINVAL;
>  }
>
> +static inline int security_netlink_receive(struct sock *sk, struct sk_buff *skb)
> +{
> +       return 0;
> +}
> +
>  static inline int security_netlink_send(struct sock *sk, struct sk_buff *skb)
>  {
>         return 0;
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 1ee6460f8275..7d69fcb8d22e 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1650,8 +1650,16 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
>                 goto nla_put_failure;
>
>         if (dev->addr_len) {
> -               if (nla_put(skb, IFLA_ADDRESS, dev->addr_len, dev->dev_addr) ||
> -                   nla_put(skb, IFLA_BROADCAST, dev->addr_len, dev->broadcast))
> +               if (skb->sk && security_netlink_receive(skb->sk, skb)) {
> +                       if (!nla_reserve(skb, IFLA_ADDRESS, dev->addr_len))
> +                               goto nla_put_failure;


Is populating the field with zeros the right approach or should I just
omit it entirely?
Even though this change will only impact LSM users I would still like to
minimize the potential for breakage of userspace processes. Returning the same
packet size and format seems like the least fragile thing to do.


>
> +
> +               } else {
> +                       if (nla_put(skb, IFLA_ADDRESS, dev->addr_len,
> +                                   dev->dev_addr))
> +                               goto nla_put_failure;
> +               }
> +               if (nla_put(skb, IFLA_BROADCAST, dev->addr_len, dev->broadcast))
>                         goto nla_put_failure;
>         }
>
> diff --git a/security/security.c b/security/security.c
> index 250ee2d76406..35c5929921b2 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1861,6 +1861,11 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
>         return -EINVAL;
>  }
>
> +int security_netlink_receive(struct sock *sk, struct sk_buff *skb)
> +{
> +       return call_int_hook(netlink_receive, 0, sk, skb);
> +}
> +
>  int security_netlink_send(struct sock *sk, struct sk_buff *skb)
>  {
>         return call_int_hook(netlink_send, 0, sk, skb);
> --
> 2.23.0.rc1.153.gdeed80330f-goog
>
