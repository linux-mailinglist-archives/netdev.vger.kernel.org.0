Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAD13FCA97
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 17:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbhHaPPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 11:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbhHaPPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 11:15:04 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2D5C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 08:14:09 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id r4so35685394ybp.4
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 08:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tPUwmAVFVnjBWawDBrxUxOpEnLefbnrOl2ytGj7RQLc=;
        b=WsrDpTleNrePdvioytto9LsXnwzKlFUbpJoBxkg4G4Tm1HzQ3BmVk4zpoInDNGWv9/
         LhfIKshopC1e4ZWB8EzKOW6yYyIbo62pNtXSK+ORQ5JBrQgh/Ef//5/iWDUzTYLAyu/p
         SWQyPiytO/mfuM/Zux/rePL/3D72LHpMtCfjW8VKYVTHUiHNRWs4o1gvsMXckfGZp4lG
         JrMa+pSM8W7CTWborMjXUvtyrv7O80WWW1B296v0I6cAiW6R+eXSbwjYUUQIO74iqfZY
         QUgMhM5Y7Effn/lScfszQxH/6fdCou4CU7rh4GhI37MXKD8XpX0TAiIRa6UU/2OPQJP5
         nmsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tPUwmAVFVnjBWawDBrxUxOpEnLefbnrOl2ytGj7RQLc=;
        b=SMxdzZvZz545SW9g9HRDC9Zl033BDDTcygkpaZ+5g7UEdiWVr9P3ylnn/UpXJntlT4
         yaLzqxQXqx0xikLwORCCT6v0lfkeaWCTpXXAnOrl41eO0LYrawNLiQeseYp8Xsi0M6j0
         2F2t3zCYirMgIUstFjsA9w521iUmjlKsRWENZSeaX23MMGBkGmCbxKF0efcpfZqqYJ4X
         mXOa3BK0WNPVrmbHosOZnSyVVUy3XVpVDVPAF+IxVCt5PJsSxTWRJh7G7h1eDNQMiHNt
         bDRiXy2g7W8UnubKA6A4Xy7PZjnMZYsrVlzOdlMxaG5i5P/z2ht5RP7e4RB9B+1yuORZ
         lgPw==
X-Gm-Message-State: AOAM533EuUszyfMuTu5nXAUwtzD7kVYCXfulPmQqo8RiXCkfMy4zrpsn
        qkyMb5kah9kYKzrsuv3n/yk9nwGy1XIZw2pFbTGB2A==
X-Google-Smtp-Source: ABdhPJyvk5hjS1obqXsbpcPj8ERMJjmoQVIkPG4SfWRBxn3wlbpGXKWfmnBmz7PYa8wlvgoKW4o3JMDpjfeQZ7mVhBI=
X-Received: by 2002:a25:ea51:: with SMTP id o17mr32779096ybe.253.1630422848296;
 Tue, 31 Aug 2021 08:14:08 -0700 (PDT)
MIME-Version: 1.0
References: <202108310136.TL90plMR-lkp@intel.com> <5c11c2e3-2d50-981e-623a-d43a897584f1@intel.com>
In-Reply-To: <5c11c2e3-2d50-981e-623a-d43a897584f1@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 31 Aug 2021 08:13:56 -0700
Message-ID: <CANn89i+muzNH6nEZvPmEq5pUZbq3B-ZprFrLVw8mPd2iH8BNLw@mail.gmail.com>
Subject: Re: [PATCH net 2/2] ipv4: make exception cache less predictible
To:     kernel test robot <yujie.liu@intel.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, llvm@lists.linux.dev,
        kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Keyu Man <kman001@ucr.edu>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Honestly this report seems wrong to me.

Please kernel test robot, improve your automation.

The function is only called when we know there are at least 6 items in
the list, I do not think you took this into account.

On Tue, Aug 31, 2021 at 12:48 AM kernel test robot <yujie.liu@intel.com> wr=
ote:
>
> Hi Eric,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on net/master]
>
> url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/inet-make-e=
xception-handling-less-predictible/20210830-061726
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 57f=
780f1c43362b86fd23d20bd940e2468237716
> :::::: branch date: 19 hours ago
> :::::: commit date: 19 hours ago
> config: x86_64-randconfig-c007-20210830 (attached as .config)
> compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 4b1f=
de8a2b681dad2ce0c082a5d6422caa06b0bc)
> reproduce (this is a W=3D1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sb=
in/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/0day-ci/linux/commit/adf305d00ec06cb771dc96=
0f0d7bd62d07561371
>          git remote add linux-review https://github.com/0day-ci/linux
>          git fetch --no-tags linux-review Eric-Dumazet/inet-make-exceptio=
n-handling-less-predictible/20210830-061726
>          git checkout adf305d00ec06cb771dc960f0d7bd62d07561371
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross A=
RCH=3Dx86_64 clang-analyzer
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
>
> clang-analyzer warnings: (new ones prefixed by >>)
>
>  >> net/ipv4/route.c:575:7: warning: Dereference of null pointer [clang-a=
nalyzer-core.NullDereference]
>             rt =3D rcu_dereference(fnhe->fnhe_rth_input);
>                  ^
>     net/ipv4/route.c:592:34: note: 'oldest' initialized to a null pointer=
 value
>             struct fib_nh_exception *fnhe, *oldest =3D NULL;
>                                             ^~~~~~
>     net/ipv4/route.c:594:2: note: Loop condition is true.  Entering loop =
body
>             for (fnhe_p =3D &hash->chain; ; fnhe_p =3D &fnhe->fnhe_next) =
{
>             ^
>     net/ipv4/route.c:595:10: note: Assuming the condition is false
>                     fnhe =3D rcu_dereference_protected(*fnhe_p,
>                            ^
>     include/linux/rcupdate.h:587:2: note: expanded from macro 'rcu_derefe=
rence_protected'
>             __rcu_dereference_protected((p), (c), __rcu)
>             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     include/linux/rcupdate.h:396:19: note: expanded from macro '__rcu_der=
eference_protected'
>             RCU_LOCKDEP_WARN(!(c), "suspicious rcu_dereference_protected(=
) usage"); \
>             ~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~
>     include/linux/rcupdate.h:318:8: note: expanded from macro 'RCU_LOCKDE=
P_WARN'
>                     if ((c) && debug_lockdep_rcu_enabled() && !__warned) =
{  \
>                          ^
>     net/ipv4/route.c:595:10: note: Left side of '&&' is false
>                     fnhe =3D rcu_dereference_protected(*fnhe_p,
>                            ^
>     include/linux/rcupdate.h:587:2: note: expanded from macro 'rcu_derefe=
rence_protected'
>             __rcu_dereference_protected((p), (c), __rcu)
>             ^
>     include/linux/rcupdate.h:396:2: note: expanded from macro '__rcu_dere=
ference_protected'
>             RCU_LOCKDEP_WARN(!(c), "suspicious rcu_dereference_protected(=
) usage"); \
>             ^
>     include/linux/rcupdate.h:318:11: note: expanded from macro 'RCU_LOCKD=
EP_WARN'
>                     if ((c) && debug_lockdep_rcu_enabled() && !__warned) =
{  \
>                             ^
>     net/ipv4/route.c:595:10: note: Loop condition is false.  Exiting loop
>                     fnhe =3D rcu_dereference_protected(*fnhe_p,
>                            ^
>     include/linux/rcupdate.h:587:2: note: expanded from macro 'rcu_derefe=
rence_protected'
>             __rcu_dereference_protected((p), (c), __rcu)
>             ^
>     include/linux/rcupdate.h:396:2: note: expanded from macro '__rcu_dere=
ference_protected'
>             RCU_LOCKDEP_WARN(!(c), "suspicious rcu_dereference_protected(=
) usage"); \
>             ^
>     include/linux/rcupdate.h:316:2: note: expanded from macro 'RCU_LOCKDE=
P_WARN'
>             do {                                                         =
   \
>             ^
>     net/ipv4/route.c:597:7: note: Assuming 'fnhe' is null
>                     if (!fnhe)
>                         ^~~~~
>     net/ipv4/route.c:597:3: note: Taking true branch
>                     if (!fnhe)
>                     ^
>     net/ipv4/route.c:598:4: note:  Execution continues on line 605
>                             break;
>                             ^
>     net/ipv4/route.c:605:20: note: Passing null pointer value via 1st par=
ameter 'fnhe'
>             fnhe_flush_routes(oldest);
>                               ^~~~~~
>     net/ipv4/route.c:605:2: note: Calling 'fnhe_flush_routes'
>             fnhe_flush_routes(oldest);
>             ^~~~~~~~~~~~~~~~~~~~~~~~~
>     net/ipv4/route.c:575:7: warning: Dereference of null pointer [clang-a=
nalyzer-core.NullDereference]
>             rt =3D rcu_dereference(fnhe->fnhe_rth_input);
>                  ^
>
> vim +575 net/ipv4/route.c
>
> 4895c771c7f006 David S. Miller 2012-07-17  570
> 2ffae99d1fac27 Timo Ter=C3=A4s      2013-06-27  571  static void fnhe_flu=
sh_routes(struct fib_nh_exception *fnhe)
> 2ffae99d1fac27 Timo Ter=C3=A4s      2013-06-27  572  {
> 2ffae99d1fac27 Timo Ter=C3=A4s      2013-06-27  573          struct rtabl=
e *rt;
> 2ffae99d1fac27 Timo Ter=C3=A4s      2013-06-27  574
> 2ffae99d1fac27 Timo Ter=C3=A4s      2013-06-27 @575          rt =3D rcu_d=
ereference(fnhe->fnhe_rth_input);
> 2ffae99d1fac27 Timo Ter=C3=A4s      2013-06-27  576          if (rt) {
> 2ffae99d1fac27 Timo Ter=C3=A4s      2013-06-27  577                  RCU_=
INIT_POINTER(fnhe->fnhe_rth_input, NULL);
> 95c47f9cf5e028 Wei Wang        2017-06-17  578                  dst_dev_p=
ut(&rt->dst);
> 0830106c539001 Wei Wang        2017-06-17  579                  dst_relea=
se(&rt->dst);
> 2ffae99d1fac27 Timo Ter=C3=A4s      2013-06-27  580          }
> 2ffae99d1fac27 Timo Ter=C3=A4s      2013-06-27  581          rt =3D rcu_d=
ereference(fnhe->fnhe_rth_output);
> 2ffae99d1fac27 Timo Ter=C3=A4s      2013-06-27  582          if (rt) {
> 2ffae99d1fac27 Timo Ter=C3=A4s      2013-06-27  583                  RCU_=
INIT_POINTER(fnhe->fnhe_rth_output, NULL);
> 95c47f9cf5e028 Wei Wang        2017-06-17  584                  dst_dev_p=
ut(&rt->dst);
> 0830106c539001 Wei Wang        2017-06-17  585                  dst_relea=
se(&rt->dst);
> 2ffae99d1fac27 Timo Ter=C3=A4s      2013-06-27  586          }
> 2ffae99d1fac27 Timo Ter=C3=A4s      2013-06-27  587  }
> 2ffae99d1fac27 Timo Ter=C3=A4s      2013-06-27  588
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
