Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B16E2509A7
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 21:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgHXTxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 15:53:00 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:57803 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgHXTw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 15:52:58 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 34338963;
        Mon, 24 Aug 2020 19:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=kZvBC3dKvagzKtx7Cpr3Owe93hg=; b=fmZ45a
        WLGPXX7mTFvmO1DTdmGEpdVbS16eUwsVbYaA0RKoD0OQlKNW3iAE2LdGdwnOgPl1
        z/VvPz6Wk1viJjsrjgXaHzGGx0o7Y1zGQotHXULkBq+J/rm1Q/kFmkhRJQx+Mvjj
        Tc5gyEs+ER/5hle544oVB/j9kmFNtZK9je9z1CWWkVye98UYWJtHecmlkvgGWmdR
        dCniT2wVOe8SZ2ulzBDmLnD+l1ZeLineez+8ahfKjGCQfhRnW3THeMcokx53Ab8O
        997GDHRQeWjzpCjwEUYkapBwfM/O39TCXhMNgNwAovUtM65RdLxxml20I4lg08bm
        q/8c4APyeZptT56A==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b7dcdd6e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 24 Aug 2020 19:25:58 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id b16so10023260ioj.4;
        Mon, 24 Aug 2020 12:52:57 -0700 (PDT)
X-Gm-Message-State: AOAM530yGqMviITJ8VeU4HBOOVGhFQJcmWsK3psWz8zWR99D1uC0JUqq
        Vlli+hfqpxe2RsmDvE6oTqa+4e5kQwScuDYVb70=
X-Google-Smtp-Source: ABdhPJyGlMk0PQmZ7wJPjtSmTV7irbslSCugeo+bQKmO1S9GTyH6J4Hk9lS3Vb7PjtOCLedDtpgt+A+fFRLtj7aCPnk=
X-Received: by 2002:a05:6602:15c3:: with SMTP id f3mr6378056iow.25.1598298776630;
 Mon, 24 Aug 2020 12:52:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200824141519.GA223008@mwanda>
In-Reply-To: <20200824141519.GA223008@mwanda>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 24 Aug 2020 21:52:45 +0200
X-Gmail-Original-Message-ID: <CAHmME9r9TazDujfSL3sM98QHZWEQxD99bTdHK+d8vFNOi+H_ZA@mail.gmail.com>
Message-ID: <CAHmME9r9TazDujfSL3sM98QHZWEQxD99bTdHK+d8vFNOi+H_ZA@mail.gmail.com>
Subject: Re: [bug report] net: WireGuard secure network tunnel
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     bpf@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 4:15 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hello Jason A. Donenfeld,
>
> The patch e7096c131e51: "net: WireGuard secure network tunnel" from
> Dec 9, 2019, leads to the following static checker warning:
>
>         net/core/dev.c:10103 netdev_run_todo()
>         warn: 'dev->_tx' double freed
>
> net/core/dev.c
>  10071          /* Wait for rcu callbacks to finish before next phase */
>  10072          if (!list_empty(&list))
>  10073                  rcu_barrier();
>  10074
>  10075          while (!list_empty(&list)) {
>  10076                  struct net_device *dev
>  10077                          = list_first_entry(&list, struct net_device, todo_list);
>  10078                  list_del(&dev->todo_list);
>  10079
>  10080                  if (unlikely(dev->reg_state != NETREG_UNREGISTERING)) {
>  10081                          pr_err("network todo '%s' but state %d\n",
>  10082                                 dev->name, dev->reg_state);
>  10083                          dump_stack();
>  10084                          continue;
>  10085                  }
>  10086
>  10087                  dev->reg_state = NETREG_UNREGISTERED;
>  10088
>  10089                  netdev_wait_allrefs(dev);
>  10090
>  10091                  /* paranoia */
>  10092                  BUG_ON(netdev_refcnt_read(dev));
>  10093                  BUG_ON(!list_empty(&dev->ptype_all));
>  10094                  BUG_ON(!list_empty(&dev->ptype_specific));
>  10095                  WARN_ON(rcu_access_pointer(dev->ip_ptr));
>  10096                  WARN_ON(rcu_access_pointer(dev->ip6_ptr));
>  10097  #if IS_ENABLED(CONFIG_DECNET)
>  10098                  WARN_ON(dev->dn_ptr);
>  10099  #endif
>  10100                  if (dev->priv_destructor)
>  10101                          dev->priv_destructor(dev);
>                                 ^^^^^^^^^^^^^^^^^^^^^^^^^
> The wg_destruct() functions frees "dev".
>
>  10102                  if (dev->needs_free_netdev)
>                             ^^^^^
> Use after free.
>
>  10103                          free_netdev(dev);
>  10104
>  10105                  /* Report a network device has been unregistered */
>  10106                  rtnl_lock();
>  10107                  dev_net(dev)->dev_unreg_count--;
>  10108                  __rtnl_unlock();
>  10109                  wake_up(&netdev_unregistering_wq);
>  10110
>  10111                  /* Free network device */
>  10112                  kobject_put(&dev->dev.kobj);
>  10113          }
>  10114  }
>
> regards,
> dan carpenter

I actually recall a patch ~3 years ago from DaveM trying to make
netdev tear down semantics a bit cleaner, by distinguishing between
the case when netdevs free their own dev and when they don't. I'm not
sure whether wireguard should set needs_free_netdev or not, but I
vaguely remember reasoning about that a long time ago and deciding,
"no". However, branching on dev->needs_free_netdev seems like it must
be a UaF always in the case where needs_free_netdev is false, since in
that case, the destructor should free it (I think). I'll send a patch,
and see if DaveM likes that, or if he'd prefer I just set
needs_free_netdev in wireguard and remove the free_netdev call in
wg_destruct.

Thanks for the report.

Jason
