Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05FE511F4E
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241779AbiD0Qj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243455AbiD0QjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:39:24 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7ACEE0DF;
        Wed, 27 Apr 2022 09:36:11 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 23RGZsbM003755;
        Wed, 27 Apr 2022 18:35:54 +0200
Date:   Wed, 27 Apr 2022 18:35:54 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     kernel test robot <lkp@intel.com>
Cc:     netdev@vger.kernel.org, kbuild-all@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net 1/7] secure_seq: return the full 64-bit of the siphash
Message-ID: <20220427163554.GA3746@1wt.eu>
References: <20220427065233.2075-2-w@1wt.eu>
 <202204271705.VrWNPv7n-lkp@intel.com>
 <20220427100714.GC1724@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427100714.GC1724@1wt.eu>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 12:07:14PM +0200, Willy Tarreau wrote:
> On Wed, Apr 27, 2022 at 05:56:41PM +0800, kernel test robot wrote:
> > Hi Willy,
> > 
> > I love your patch! Yet something to improve:
> > 
> > [auto build test ERROR on net/master]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Willy-Tarreau/insufficient-TCP-source-port-randomness/20220427-145651
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git 71cffebf6358a7f5031f5b208bbdc1cb4db6e539
> > config: i386-randconfig-r026-20220425 (https://download.01.org/0day-ci/archive/20220427/202204271705.VrWNPv7n-lkp@intel.com/config)
> > compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
> > reproduce (this is a W=1 build):
> >         # https://github.com/intel-lab-lkp/linux/commit/01b26e522b598adf346b809075880feab3dcdc08
> >         git remote add linux-review https://github.com/intel-lab-lkp/linux
> >         git fetch --no-tags linux-review Willy-Tarreau/insufficient-TCP-source-port-randomness/20220427-145651
> >         git checkout 01b26e522b598adf346b809075880feab3dcdc08
> >         # save the config file
> >         mkdir build_dir && cp config build_dir/.config
> >         make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash
> > 
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> > 
> > All errors (new ones prefixed by >>):
> > 
> >    ld: net/ipv4/inet_hashtables.o: in function `__inet_hash_connect':
> > >> inet_hashtables.c:(.text+0x187d): undefined reference to `__umoddi3'
> 
> Argh! indeed, we spoke about using div_u64_rem() at the beginning and
> that one vanished over time. Will respin it.

I fixed it, built it for i386 and x86_64, tested it on x86_64 and confirmed
that it still does what I need. The change is only this:

-       offset = (READ_ONCE(table_perturb[index]) + (port_offset >> 32)) % remaining;
+       div_u64_rem(READ_ONCE(table_perturb[index]) + (port_offset >> 32), remaining, &offset);

I'll send a v2 series in a few hours if there are no more comments.

Willy
