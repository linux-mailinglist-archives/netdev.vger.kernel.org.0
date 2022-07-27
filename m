Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECBD5822B9
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiG0JHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiG0JGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:06:32 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8652647BAE
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:06:20 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id j195so9868813ybj.11
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2JA3LAcWFrVgyNzQ7tMzU8nSe9RRNefwId5LqLUrTHQ=;
        b=ezdrOVHkkyEdsd/J8XDbRmdIHm7C5TePfztuPZ1+9R7RYYYgX8fx2sv6pD+0jpkAk9
         ZU83e2CNY86ab90uImfbz3u4zZJtrKiTbuFTIGpX30JX1N1Is1ROn//mtf3OkPZRz6Yx
         1EarM9/uzIFwgKeGKawqXUYQde8F03mRUiEbrAdhxaWFH1chCR2ZuZsyAAS6mKnMJuRu
         5UMMEZIQz5Wy7DumqXoVGKwamiiMPK6l+6BJhvC42yylB4tRqobUhEPvVdTSA5um1TI5
         R7oGn4o+d1XL0SmX/RbVpAkHuMISzLyjNIJwwPmCsBUjYYyzEU92leesROlpH54OjX5c
         LBeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2JA3LAcWFrVgyNzQ7tMzU8nSe9RRNefwId5LqLUrTHQ=;
        b=RWySU6eRwW/zzxLBYywaqG+z7BGsqZKmprn63Wv6DDKEXcCqyDBWPDVdcDNoWykj46
         NXubO8v3j+hFKwE8023BuxlENblztuffvpnZ3QWfKU6xo/9qOfEn2PIp1ta+xNE5RJ6d
         CngdoU8o7Z7yTr2U1mZHF41J0rSVOzntdpD0t1SAdhCNfqH5N6Fsej7q8JQfa+pRPFww
         HW9xmD8d90eqJYcV68G4N5On/QYRO+Bt7jjkstP7Sub6FCqrwX8xLvWEc844u2u3jMV6
         WTVFGmxI3Al2JTNK5t7hC2e5Su3pKevdndMIssvGOQtH65/ZVcyrHIRrGm3S58g8SmY+
         jkBA==
X-Gm-Message-State: AJIora/V1ao55OY06fnyTJisecup8i1HgY6bzR9aOBDGVi0xcezu90u2
        QGdDVbTM2cjNDlCGO+/Sznxex5Wjg2PK6kGuJlXsJwlY3DbPtg==
X-Google-Smtp-Source: AGRyM1utHHIu+akhBwjmIFnrGj314eH11OJTAANegqIGBEFMt8iP4Tg/0hGy+lcXERizu/7pX03O+x/wsBmharnvQRw=
X-Received: by 2002:a25:e752:0:b0:671:cdb7:90fd with SMTP id
 e79-20020a25e752000000b00671cdb790fdmr485491ybh.407.1658912779195; Wed, 27
 Jul 2022 02:06:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220722103750.1938776d@kernel.org> <20220726182518.47047-1-f6bvp@free.fr>
In-Reply-To: <20220726182518.47047-1-f6bvp@free.fr>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 27 Jul 2022 11:06:08 +0200
Message-ID: <CANn89i+FBa-KLJz5xPvk3jO3Miww4Vs+qw4nPf_9SPwiWpyTWw@mail.gmail.com>
Subject: Re: [PATCH 1/1] [PATCH] net: rose: fix unregistered netdevice:
 waiting for rose0 to become free
To:     Bernard Pidoux <f6bvp@free.fr>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Duoming Zhou <duoming@zju.edu.cn>, linux-hams@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 8:25 PM Bernard Pidoux <f6bvp@free.fr> wrote:
>
> Here is the context.
>
> This patch adds dev_put(dev) in order to allow removal of rose module
> after use of AX25 and ROSE via rose0 device.
>
> Otherwise when trying to remove rose module via rmmod rose an infinite
> loop message was displayed on all consoles with xx being a random number.
>
> unregistered_netdevice: waiting for rose0 to become free. Usage count = xx
>
> unregistered_netdevice: waiting for rose0 to become free. Usage count = xx
>
> ...
>
> With the patch it is ok to rmmod rose.

But removing a net device will leave a dangling pointer, leading to UAF.

We must keep a reference and remove it when the socket is dismantled.

Also rose_dev_first() is buggy, because it leaves the rcu section
without taking first a reference on the found device.

Here is a probably not complete patch, can you give it a try ?

(Also enable CONFIG_NET_DEV_REFCNT_TRACKER=y in your .config to ease debugging)

(I can send you privately the patch, just ask me, I include it inline
here for clarity only)

Thanks.

diff --git a/include/net/rose.h b/include/net/rose.h
index 0f0a4ce0fee7cc5e125507a8fc3cfb8cb826be73..64f808eed0e15a2482e8ce010d712eef1e0b9d85
100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -131,7 +131,8 @@ struct rose_sock {
        ax25_address            source_digis[ROSE_MAX_DIGIS];
        ax25_address            dest_digis[ROSE_MAX_DIGIS];
        struct rose_neigh       *neighbour;
-       struct net_device               *device;
+       struct net_device       *device;
+       netdevice_tracker       dev_tracker;
        unsigned int            lci, rand;
        unsigned char           state, condition, qbitincl, defer;
        unsigned char           cause, diagnostic;
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index bf2d986a6bc392a9d830b1dfa7fbaa3bca969aa3..520a48999f1bf8a41d66e8a4f86606b66f2b9408
100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -192,6 +192,7 @@ static void rose_kill_by_device(struct net_device *dev)
                        rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
                        if (rose->neighbour)
                                rose->neighbour->use--;
+                       dev_put_track(rose->device, &rose->dev_tracker);
                        rose->device = NULL;
                }
        }
@@ -592,6 +593,8 @@ static struct sock *rose_make_new(struct sock *osk)
        rose->idle      = orose->idle;
        rose->defer     = orose->defer;
        rose->device    = orose->device;
+       if (rose->device)
+               dev_hold_track(rose->device, &rose->dev_tracker, GFP_ATOMIC);
        rose->qbitincl  = orose->qbitincl;

        return sk;
@@ -695,7 +698,11 @@ static int rose_bind(struct socket *sock, struct
sockaddr *uaddr, int addr_len)
        }

        rose->source_addr   = addr->srose_addr;
+       // TODO: should probably hold socket lock at this point ?
+       WARN_ON_ONCE(rose->device);
        rose->device        = dev;
+       netdev_tracker_alloc(rose->device, &rose->dev_tracker, GFP_KERNEL);
+
        rose->source_ndigis = addr->srose_ndigis;

        if (addr_len == sizeof(struct full_sockaddr_rose)) {
@@ -721,7 +728,6 @@ static int rose_connect(struct socket *sock,
struct sockaddr *uaddr, int addr_le
        struct rose_sock *rose = rose_sk(sk);
        struct sockaddr_rose *addr = (struct sockaddr_rose *)uaddr;
        unsigned char cause, diagnostic;
-       struct net_device *dev;
        ax25_uid_assoc *user;
        int n, err = 0;

@@ -778,9 +784,12 @@ static int rose_connect(struct socket *sock,
struct sockaddr *uaddr, int addr_le
        }

        if (sock_flag(sk, SOCK_ZAPPED)) {       /* Must bind first -
autobinding in this may or may not work */
+               struct net_device *dev;
+
                sock_reset_flag(sk, SOCK_ZAPPED);

-               if ((dev = rose_dev_first()) == NULL) {
+               dev = rose_dev_first();
+               if (!dev) {
                        err = -ENETUNREACH;
                        goto out_release;
                }
@@ -788,12 +797,15 @@ static int rose_connect(struct socket *sock,
struct sockaddr *uaddr, int addr_le
                user = ax25_findbyuid(current_euid());
                if (!user) {
                        err = -EINVAL;
+                       dev_put(dev);
                        goto out_release;
                }

                memcpy(&rose->source_addr, dev->dev_addr, ROSE_ADDR_LEN);
                rose->source_call = user->call;
                rose->device      = dev;
+               netdev_tracker_alloc(rose->device, &rose->dev_tracker,
+                                    GFP_KERNEL);
                ax25_uid_put(user);

                rose_insert_socket(sk);         /* Finish the bind */
@@ -1017,6 +1029,7 @@ int rose_rx_call_request(struct sk_buff *skb,
struct net_device *dev, struct ros
                make_rose->source_digis[n] = facilities.source_digis[n];
        make_rose->neighbour     = neigh;
        make_rose->device        = dev;
+       dev_hold_track(make_rose->device, &make_rose->dev_tracker, GFP_ATOMIC);
        make_rose->facilities    = facilities;

        make_rose->neighbour->use++;
