Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEA797DA2
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfHUOwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:52:24 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46922 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbfHUOwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 10:52:24 -0400
Received: by mail-lf1-f66.google.com with SMTP id n19so1989973lfe.13
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 07:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m8OGikSaixqjK3WQyg4Bx+X3Tn+Ncmz++j77OuBZpB8=;
        b=jhz/MUKY7uKeRcjzaFm99i3aj30dsqg1xL+hv0uZ9ik82O9Fu4SHAUT8Royrnr28+2
         kFhhKdUJ5rGbTWAfNWG4Q37IsvLP/njEvRWqSXlor8/nSuE/NF5nNHgwYva03MZU+7AQ
         CGDlCmKtdV1LJrWz813dxmiWnZJFimjzhQ/xdJfA7bzTZnAAqx9Rvmx8I6rQMFfjtDl/
         BDsyplCMvRevY760csFUWAr511mzEj3IEDks1q9QzM5mS1YuZ8k0rq4r26vMGHrMTQyb
         79qUcV+YV+xIIjRusPGcfRZJwVqRF9E+mmDUTkoD93L9WKU9tyffDGGN9V77Jw/DeP1e
         ewiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m8OGikSaixqjK3WQyg4Bx+X3Tn+Ncmz++j77OuBZpB8=;
        b=rRzXYQoxh0DfL32w+3tETc81UBRZBWA5RvPWhkxllwKgspu6MaKCeLRm2yYD0BJ1Ad
         KmONjDRcXnj662FVzfwqMnPujdG/qwID+eHWWOabmcfd1l8hCJWWypX4IIWtFFjIF9Px
         zychC+FNx+EsAe2k2vzqGvdv3My8TuKQ9XuYPDpEwQaEAnJRFMu4M6782c1PYPE0QntO
         JQ6D54oFakNf2b6h7e/WuN0ig8yTaZVDHPsJTEo1tFWb1wOLrFHmJnRsbDKYouvGydZm
         LJALSJbEE0IIc5cl5orW5Mmo7r4+nEaj+L7tTo1GYP3u3eY6HZjGlnBgVjwG0iWLp0wq
         Ub4A==
X-Gm-Message-State: APjAAAVVqDRWoP/hHV/k+5qQ5iIDgnkOhKPRSoKuVLfnTMOeEbfkSV3S
        9Gdv/ttvWw40MymemOkmUL6dyHCk9hkwLZHI4jDX0g==
X-Google-Smtp-Source: APXvYqwXkjJ71QGo/C5SHs/4Wb4AWSDFNiG2/fXJvqweCXxS5V0iugevJZ2A1evWvFhNO00DNUuCfVrPvQzzfQ0s+GA=
X-Received: by 2002:ac2:545b:: with SMTP id d27mr19174978lfn.36.1566399140675;
 Wed, 21 Aug 2019 07:52:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190821134547.96929-1-jeffv@google.com> <e8f9e1ae-f9e4-987f-eb76-ebde8af4f4db@schaufler-ca.com>
In-Reply-To: <e8f9e1ae-f9e4-987f-eb76-ebde8af4f4db@schaufler-ca.com>
From:   Jeffrey Vander Stoep <jeffv@google.com>
Date:   Wed, 21 Aug 2019 16:52:09 +0200
Message-ID: <CABXk95DnL5EbGzY7UF2VJ0Lo+bavHPVA-1fXN_xUyfS5WQXCuQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] rtnetlink: gate MAC address with an LSM hook
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     netdev@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>,
        selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 4:34 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> On 8/21/2019 6:45 AM, Jeff Vander Stoep wrote:
> > MAC addresses are often considered sensitive because they are
> > usually unique and can be used to identify/track a device or
> > user [1].
> >
> > The MAC address is accessible via the RTM_NEWLINK message type of a
> > netlink route socket[2]. Ideally we could grant/deny access to the
> > MAC address on a case-by-case basis without blocking the entire
> > RTM_NEWLINK message type which contains a lot of other useful
> > information. This can be achieved using a new LSM hook on the netlink
> > message receive path. Using this new hook, individual LSMs can select
> > which processes are allowed access to the real MAC, otherwise a
> > default value of zeros is returned. Offloading access control
> > decisions like this to an LSM is convenient because it preserves the
> > status quo for most Linux users while giving the various LSMs
> > flexibility to make finer grained decisions on access to sensitive
> > data based on policy.
>
> Is the MAC address the only bit of skb data that you might
> want to control with MAC? ( Sorry, couldn't help it ;) )
> Just musing, but might it make more sense to leave the core
> code unmodified and clear the MAC address in the skb inside
> the LSM? If you did it that way you could address any other
> data you want to control using the same hook. I would hate
> to see separate LSM hooks for each of several bits of data.
> On the other hand, I wouldn't want you to violate any layering
> policies in the networking code. That would be wrong.

I considered that approach, but having the LSM modifying the skb
like that without the networking code's knowledge did seem like a layering
violation, and fragile. It's also different than how LSM hooks typically
operate - generally they return decisions and the calling code is
responsible for taking appropriate action.

I'm currently only interested in the MAC, but this approach can be extended
to other fields. The selinux patch just splits up the read permission into two
levels, privileged and unprivileged which is consistent with how netlink
audit sockets are handled.



>
> >
> > [1] https://adamdrake.com/mac-addresses-udids-and-privacy.html
> > [2] Other access vectors like ioctl(SIOCGIFHWADDR) are already covered
> > by existing LSM hooks.
> >
> > Signed-off-by: Jeff Vander Stoep <jeffv@google.com>
> > ---
> >  include/linux/lsm_hooks.h |  8 ++++++++
> >  include/linux/security.h  |  6 ++++++
> >  net/core/rtnetlink.c      | 12 ++++++++++--
> >  security/security.c       |  5 +++++
> >  4 files changed, 29 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> > index df1318d85f7d..dfcb2e11ff43 100644
> > --- a/include/linux/lsm_hooks.h
> > +++ b/include/linux/lsm_hooks.h
> > @@ -728,6 +728,12 @@
> >   *
> >   * Security hooks for Netlink messaging.
> >   *
> > + * @netlink_receive
> > + *   Check permissions on a netlink message field before populating it.
> > + *   @sk associated sock of task receiving the message.
> > + *   @skb contains the sk_buff structure for the netlink message.
> > + *   Return 0 if the data should be included in the message.
> > + *
> >   * @netlink_send:
> >   *   Save security information for a netlink message so that permission
> >   *   checking can be performed when the message is processed.  The security
> > @@ -1673,6 +1679,7 @@ union security_list_options {
> >       int (*sem_semop)(struct kern_ipc_perm *perm, struct sembuf *sops,
> >                               unsigned nsops, int alter);
> >
> > +     int (*netlink_receive)(struct sock *sk, struct sk_buff *skb);
> >       int (*netlink_send)(struct sock *sk, struct sk_buff *skb);
> >
> >       void (*d_instantiate)(struct dentry *dentry, struct inode *inode);
> > @@ -1952,6 +1959,7 @@ struct security_hook_heads {
> >       struct hlist_head sem_associate;
> >       struct hlist_head sem_semctl;
> >       struct hlist_head sem_semop;
> > +     struct hlist_head netlink_receive;
> >       struct hlist_head netlink_send;
> >       struct hlist_head d_instantiate;
> >       struct hlist_head getprocattr;
> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index 5f7441abbf42..46b5af6de59e 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h
> > @@ -382,6 +382,7 @@ int security_getprocattr(struct task_struct *p, const char *lsm, char *name,
> >                        char **value);
> >  int security_setprocattr(const char *lsm, const char *name, void *value,
> >                        size_t size);
> > +int security_netlink_receive(struct sock *sk, struct sk_buff *skb);
> >  int security_netlink_send(struct sock *sk, struct sk_buff *skb);
> >  int security_ismaclabel(const char *name);
> >  int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
> > @@ -1162,6 +1163,11 @@ static inline int security_setprocattr(const char *lsm, char *name,
> >       return -EINVAL;
> >  }
> >
> > +static inline int security_netlink_receive(struct sock *sk, struct sk_buff *skb)
> > +{
> > +     return 0;
> > +}
> > +
> >  static inline int security_netlink_send(struct sock *sk, struct sk_buff *skb)
> >  {
> >       return 0;
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > index 1ee6460f8275..7d69fcb8d22e 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -1650,8 +1650,16 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
> >               goto nla_put_failure;
> >
> >       if (dev->addr_len) {
> > -             if (nla_put(skb, IFLA_ADDRESS, dev->addr_len, dev->dev_addr) ||
> > -                 nla_put(skb, IFLA_BROADCAST, dev->addr_len, dev->broadcast))
> > +             if (skb->sk && security_netlink_receive(skb->sk, skb)) {
> > +                     if (!nla_reserve(skb, IFLA_ADDRESS, dev->addr_len))
> > +                             goto nla_put_failure;
> > +
> > +             } else {
> > +                     if (nla_put(skb, IFLA_ADDRESS, dev->addr_len,
> > +                                 dev->dev_addr))
> > +                             goto nla_put_failure;
> > +             }
> > +             if (nla_put(skb, IFLA_BROADCAST, dev->addr_len, dev->broadcast))
> >                       goto nla_put_failure;
> >       }
> >
> > diff --git a/security/security.c b/security/security.c
> > index 250ee2d76406..35c5929921b2 100644
> > --- a/security/security.c
> > +++ b/security/security.c
> > @@ -1861,6 +1861,11 @@ int security_setprocattr(const char *lsm, const char *name, void *value,
> >       return -EINVAL;
> >  }
> >
> > +int security_netlink_receive(struct sock *sk, struct sk_buff *skb)
> > +{
> > +     return call_int_hook(netlink_receive, 0, sk, skb);
> > +}
> > +
> >  int security_netlink_send(struct sock *sk, struct sk_buff *skb)
> >  {
> >       return call_int_hook(netlink_send, 0, sk, skb);
>
