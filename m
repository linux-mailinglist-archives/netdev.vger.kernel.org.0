Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8C930E29
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfEaMdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:33:11 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42452 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfEaMdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 08:33:10 -0400
Received: by mail-qk1-f196.google.com with SMTP id b18so6095405qkc.9;
        Fri, 31 May 2019 05:33:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=tr1mxKsxyqiyw16MKVtN4SogXZGxHYJtMdTR2Kg/Wm8=;
        b=oLFrSaYhnYJPO6u1NoOqP43hJCO4JgOGMMP1GPnJxIQZoKZSxnC1nNIhjly1npY262
         ycw0gpGbwGDFuu9dyCkamKMHwgycKhV5TYYCcIc2hjOs9AXS2aSlUo9BojWYy1U/SUFH
         +LhF7udN2r4g0l6uP/xRz8S9OK8hhaVdiu+rLlWdCSwn+N9c4fzKNlhmdX8MFNhGLmgM
         v3ppoUGy7zkBxaMIisSOk29KoU88opyom4LbPi4iIQj6XoFJWN6gO+k4XhbeNpSTNdXa
         TZy6LfwMDW2kf+HM7o/bDvWqIequme8pFeBOwtXl2/B2vwsAHT91smLvHQL2ewCmvov5
         K3XA==
X-Gm-Message-State: APjAAAXDDn91ERRI9TcsR4gsUHGjOvedap8jmzA5l4FZt7tgDvBfs1ZS
        CRCdgMK90EAUDVtucENLmsanCgVi3CPaHdJajDzj30Vb0pc=
X-Google-Smtp-Source: APXvYqww0iSNNjp5QYk8CUp7vFd8BR1OgMqPqPagT0yHjC6gerKWbSmLaT8BWbxZftShrOtpD2uy66MJcpD1UScgIqQ=
X-Received: by 2002:a05:620a:16c1:: with SMTP id a1mr8166567qkn.269.1559305988593;
 Fri, 31 May 2019 05:33:08 -0700 (PDT)
MIME-Version: 1.0
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 31 May 2019 14:32:52 +0200
Message-ID: <CAK8P3a1JvZNQ7oTLkAe8hA5qkU4=_Jwch=dqUgk2Qe1vR1SAsg@mail.gmail.com>
Subject: [GIT PULL net-next, resend] isdn: deprecate non-mISDN drivers
To:     Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Greg KH <greg@kroah.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        isdn4linux@listserv.isdn4linux.de, Paul Bolle <pebolle@tiscali.nl>,
        Holger Schurig <holgerschurig@googlemail.com>,
        Tilman Schmidt <tilman@imap.cc>,
        gigaset307x-common@lists.sourceforge.net,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Birger Harzenetter <WIMPy@yeti.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[resending, rebased on top of today's net-next]

The following changes since commit 7b3ed2a137b077bc0967352088b0adb6049eed20:

  Merge branch '100GbE' of
git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue
(2019-05-30 15:17:05 -0700)

are available in the Git repository at:

 https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git
tags/isdn-removal

for you to fetch changes up to 6d97985072dc270032dc7a08631080bfd6253e82:

  isdn: move capi drivers to staging (2019-05-31 11:17:41 +0200)

----------------------------------------------------------------
isdn: deprecate non-mISDN drivers

When isdn4linux came up in the context of another patch series, I
remembered that we had discussed removing it a while ago.

It turns out that the suggestion from Karsten Keil wa to remove I4L
in 2018 after the last public ISDN networks are shut down. This has
happened now (with a very small number of exceptions), so I guess it's
time to try again.

We currently have three ISDN stacks in the kernel: the original
isdn4linux (with the hisax driver), the newer CAPI (with four drivers),
and finally the mISDN stack (supporting roughly the same hardware as
hisax).

As far as I can tell, anyone using ISDN with mainline kernel drivers in
the past few years uses mISDN, and this is typically used for voice-only
PBX installations that don't require a public network.

The older stacks support additional features for data networks, but those
typically make no sense any more if there is no network to connect to.

My proposal for this time is to kill off isdn4linux entirely, as it seems
to have been unusable for quite a while. This code has been abandoned
for many years and it does cause problems for treewide maintenance as
it tends to do everything that we try to stop doing.
Birger Harzenetter mentioned that is is still using i4l in order to
make use of the 'divert' feature that is not part of mISDN, but has
otherwise moved on to mISDN for normal operation, like apparently
everyone else.

CAPI in turn is not quite as obsolete, but two of the drivers (avm
and hysdn) don't seem to be used at all, while another one (gigaset)
will stop being maintained as Paul Bolle is no longer able to
test it after the network gets shut down in September.
All three are now moved into drivers/staging to let others speak
up in case there are remaining users.
This leaves Bluetooth CMTP as the only remaining user of CAPI, but
Marcel Holtmann wishes to keep maintaining it.

For the discussion on version 1, see [2]
Unfortunately, Karsten Keil as the maintainer has not participated in
the discussion.

      Arnd

[1] https://patchwork.kernel.org/patch/8484861/#17900371
[2] https://listserv.isdn4linux.de/pipermail/isdn4linux/2019-April/thread.html

----------------------------------------------------------------

Arnd Bergmann (5):
      isdn: gigaset: remove i4l support
      isdn: remove hisax driver
      isdn: remove isdn4linux
      isdn: hdlc: move into mISDN
      isdn: move capi drivers to staging

 Documentation/isdn/HiSax.cert                      |   96 -
 Documentation/isdn/INTERFACE                       |  759 ----
 Documentation/isdn/INTERFACE.fax                   |  163 -
 Documentation/isdn/README                          |  599 ----
 Documentation/isdn/README.FAQ                      |   26 -
 Documentation/isdn/README.HiSax                    |  659 ----
 Documentation/isdn/README.audio                    |  138 -
 Documentation/isdn/README.concap                   |  259 --
 Documentation/isdn/README.diversion                |  127 -
 Documentation/isdn/README.fax                      |   45 -
 Documentation/isdn/README.gigaset                  |   36 +-
 Documentation/isdn/README.hfc-pci                  |   41 -
 Documentation/isdn/README.syncppp                  |   58 -
 Documentation/isdn/README.x25                      |  184 -
 Documentation/isdn/syncPPP.FAQ                     |  224 --
 Documentation/process/changes.rst                  |   16 +-
 MAINTAINERS                                        |   22 +-
 drivers/isdn/Kconfig                               |   51 -
 drivers/isdn/Makefile                              |    6 -
 drivers/isdn/capi/Kconfig                          |   29 +-
 drivers/isdn/capi/Makefile                         |    2 +
 drivers/isdn/capi/capidrv.c                        | 2525 -------------
 drivers/isdn/capi/capidrv.h                        |  140 -
 drivers/isdn/divert/Makefile                       |   10 -
 drivers/isdn/divert/divert_init.c                  |   82 -
 drivers/isdn/divert/divert_procfs.c                |  336 --
 drivers/isdn/divert/isdn_divert.c                  |  846 -----
 drivers/isdn/divert/isdn_divert.h                  |  132 -
 drivers/isdn/gigaset/i4l.c                         |  695 ----
 drivers/isdn/hardware/Kconfig                      |    8 -
 drivers/isdn/hardware/Makefile                     |    1 -
 drivers/isdn/hardware/mISDN/Kconfig                |    7 +-
 drivers/isdn/hardware/mISDN/Makefile               |    2 +
 drivers/isdn/{i4l => hardware/mISDN}/isdnhdlc.c    |    2 +-
 .../isdn/hardware/mISDN/isdnhdlc.h                 |    0
 drivers/isdn/hardware/mISDN/netjet.c               |    2 +-
 drivers/isdn/hisax/Kconfig                         |  423 ---
 drivers/isdn/hisax/Makefile                        |   60 -
 drivers/isdn/hisax/amd7930_fn.c                    |  794 -----
 drivers/isdn/hisax/amd7930_fn.h                    |   37 -
 drivers/isdn/hisax/arcofi.c                        |  131 -
 drivers/isdn/hisax/arcofi.h                        |   27 -
 drivers/isdn/hisax/asuscom.c                       |  423 ---
 drivers/isdn/hisax/avm_a1.c                        |  307 --
 drivers/isdn/hisax/avm_a1p.c                       |  267 --
 drivers/isdn/hisax/avm_pci.c                       |  904 -----
 drivers/isdn/hisax/avma1_cs.c                      |  162 -
 drivers/isdn/hisax/bkm_a4t.c                       |  358 --
 drivers/isdn/hisax/bkm_a8.c                        |  433 ---
 drivers/isdn/hisax/bkm_ax.h                        |  119 -
 drivers/isdn/hisax/callc.c                         | 1792 ----------
 drivers/isdn/hisax/config.c                        | 1993 -----------
 drivers/isdn/hisax/diva.c                          | 1282 -------
 drivers/isdn/hisax/elsa.c                          | 1245 -------
 drivers/isdn/hisax/elsa_cs.c                       |  218 --
 drivers/isdn/hisax/elsa_ser.c                      |  659 ----
 drivers/isdn/hisax/enternow_pci.c                  |  420 ---
 drivers/isdn/hisax/fsm.c                           |  161 -
 drivers/isdn/hisax/fsm.h                           |   61 -
 drivers/isdn/hisax/gazel.c                         |  691 ----
 drivers/isdn/hisax/hfc4s8s_l1.c                    | 1584 ---------
 drivers/isdn/hisax/hfc4s8s_l1.h                    |   89 -
 drivers/isdn/hisax/hfc_2bds0.c                     | 1078 ------
 drivers/isdn/hisax/hfc_2bds0.h                     |  128 -
 drivers/isdn/hisax/hfc_2bs0.c                      |  591 ---
 drivers/isdn/hisax/hfc_2bs0.h                      |   60 -
 drivers/isdn/hisax/hfc_pci.c                       | 1755 ---------
 drivers/isdn/hisax/hfc_pci.h                       |  235 --
 drivers/isdn/hisax/hfc_sx.c                        | 1517 --------
 drivers/isdn/hisax/hfc_sx.h                        |  196 -
 drivers/isdn/hisax/hfc_usb.c                       | 1608 ---------
 drivers/isdn/hisax/hfc_usb.h                       |  208 --
 drivers/isdn/hisax/hfcscard.c                      |  261 --
 drivers/isdn/hisax/hisax.h                         | 1352 -------
 drivers/isdn/hisax/hisax_cfg.h                     |   66 -
 drivers/isdn/hisax/hisax_debug.h                   |   80 -
 drivers/isdn/hisax/hisax_fcpcipnp.c                | 1024 ------
 drivers/isdn/hisax/hisax_fcpcipnp.h                |   58 -
 drivers/isdn/hisax/hisax_if.h                      |   66 -
 drivers/isdn/hisax/hisax_isac.c                    |  895 -----
 drivers/isdn/hisax/hisax_isac.h                    |   46 -
 drivers/isdn/hisax/hscx.c                          |  277 --
 drivers/isdn/hisax/hscx.h                          |   41 -
 drivers/isdn/hisax/hscx_irq.c                      |  294 --
 drivers/isdn/hisax/icc.c                           |  680 ----
 drivers/isdn/hisax/icc.h                           |   72 -
 drivers/isdn/hisax/ipac.h                          |   29 -
 drivers/isdn/hisax/ipacx.c                         |  913 -----
 drivers/isdn/hisax/ipacx.h                         |  162 -
 drivers/isdn/hisax/isac.c                          |  681 ----
 drivers/isdn/hisax/isac.h                          |   70 -
 drivers/isdn/hisax/isar.c                          | 1910 ----------
 drivers/isdn/hisax/isar.h                          |  222 --
 drivers/isdn/hisax/isdnl1.c                        |  930 -----
 drivers/isdn/hisax/isdnl1.h                        |   32 -
 drivers/isdn/hisax/isdnl2.c                        | 1839 ----------
 drivers/isdn/hisax/isdnl2.h                        |   25 -
 drivers/isdn/hisax/isdnl3.c                        |  594 ----
 drivers/isdn/hisax/isdnl3.h                        |   42 -
 drivers/isdn/hisax/isurf.c                         |  305 --
 drivers/isdn/hisax/ix1_micro.c                     |  316 --
 drivers/isdn/hisax/jade.c                          |  305 --
 drivers/isdn/hisax/jade.h                          |  134 -
 drivers/isdn/hisax/jade_irq.c                      |  238 --
 drivers/isdn/hisax/l3_1tr6.c                       |  932 -----
 drivers/isdn/hisax/l3_1tr6.h                       |  164 -
 drivers/isdn/hisax/l3dss1.c                        | 3227 -----------------
 drivers/isdn/hisax/l3dss1.h                        |  124 -
 drivers/isdn/hisax/l3ni1.c                         | 3182 -----------------
 drivers/isdn/hisax/l3ni1.h                         |  136 -
 drivers/isdn/hisax/lmgr.c                          |   50 -
 drivers/isdn/hisax/mic.c                           |  235 --
 drivers/isdn/hisax/netjet.c                        |  985 -----
 drivers/isdn/hisax/netjet.h                        |   69 -
 drivers/isdn/hisax/niccy.c                         |  380 --
 drivers/isdn/hisax/nj_s.c                          |  294 --
 drivers/isdn/hisax/nj_u.c                          |  258 --
 drivers/isdn/hisax/q931.c                          | 1513 --------
 drivers/isdn/hisax/s0box.c                         |  260 --
 drivers/isdn/hisax/saphir.c                        |  296 --
 drivers/isdn/hisax/sedlbauer.c                     |  873 -----
 drivers/isdn/hisax/sedlbauer_cs.c                  |  209 --
 drivers/isdn/hisax/sportster.c                     |  267 --
 drivers/isdn/hisax/st5481.h                        |  529 ---
 drivers/isdn/hisax/st5481_b.c                      |  380 --
 drivers/isdn/hisax/st5481_d.c                      |  780 ----
 drivers/isdn/hisax/st5481_init.c                   |  221 --
 drivers/isdn/hisax/st5481_usb.c                    |  659 ----
 drivers/isdn/hisax/tei.c                           |  465 ---
 drivers/isdn/hisax/teleint.c                       |  334 --
 drivers/isdn/hisax/teles0.c                        |  364 --
 drivers/isdn/hisax/teles3.c                        |  498 ---
 drivers/isdn/hisax/teles_cs.c                      |  201 --
 drivers/isdn/hisax/telespci.c                      |  349 --
 drivers/isdn/hisax/w6692.c                         | 1085 ------
 drivers/isdn/hisax/w6692.h                         |  184 -
 drivers/isdn/i4l/Kconfig                           |  129 -
 drivers/isdn/i4l/Makefile                          |   20 -
 drivers/isdn/i4l/isdn_audio.c                      |  711 ----
 drivers/isdn/i4l/isdn_audio.h                      |   44 -
 drivers/isdn/i4l/isdn_bsdcomp.c                    |  930 -----
 drivers/isdn/i4l/isdn_common.c                     | 2368 ------------
 drivers/isdn/i4l/isdn_common.h                     |   47 -
 drivers/isdn/i4l/isdn_concap.c                     |   99 -
 drivers/isdn/i4l/isdn_concap.h                     |   11 -
 drivers/isdn/i4l/isdn_net.c                        | 3198 -----------------
 drivers/isdn/i4l/isdn_net.h                        |  151 -
 drivers/isdn/i4l/isdn_ppp.c                        | 3046 ----------------
 drivers/isdn/i4l/isdn_ppp.h                        |   41 -
 drivers/isdn/i4l/isdn_tty.c                        | 3756 --------------------
 drivers/isdn/i4l/isdn_tty.h                        |  120 -
 drivers/isdn/i4l/isdn_ttyfax.c                     | 1123 ------
 drivers/isdn/i4l/isdn_ttyfax.h                     |   17 -
 drivers/isdn/i4l/isdn_v110.c                       |  625 ----
 drivers/isdn/i4l/isdn_v110.h                       |   29 -
 drivers/isdn/i4l/isdn_x25iface.c                   |  332 --
 drivers/isdn/i4l/isdn_x25iface.h                   |   30 -
 drivers/isdn/isdnloop/Makefile                     |    6 -
 drivers/isdn/isdnloop/isdnloop.c                   | 1528 --------
 drivers/isdn/isdnloop/isdnloop.h                   |  112 -
 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/isdn/Kconfig                       |   12 +
 drivers/staging/isdn/Makefile                      |    8 +
 drivers/staging/isdn/TODO                          |   22 +
 .../{isdn/hardware => staging/isdn}/avm/Kconfig    |    0
 .../{isdn/hardware => staging/isdn}/avm/Makefile   |    0
 .../{isdn/hardware => staging/isdn}/avm/avm_cs.c   |    0
 .../{isdn/hardware => staging/isdn}/avm/avmcard.h  |    0
 drivers/{isdn/hardware => staging/isdn}/avm/b1.c   |    0
 .../{isdn/hardware => staging/isdn}/avm/b1dma.c    |    0
 .../{isdn/hardware => staging/isdn}/avm/b1isa.c    |    0
 .../{isdn/hardware => staging/isdn}/avm/b1pci.c    |    0
 .../{isdn/hardware => staging/isdn}/avm/b1pcmcia.c |    0
 drivers/{isdn/hardware => staging/isdn}/avm/c4.c   |    0
 .../{isdn/hardware => staging/isdn}/avm/t1isa.c    |    0
 .../{isdn/hardware => staging/isdn}/avm/t1pci.c    |    0
 drivers/{ => staging}/isdn/gigaset/Kconfig         |    9 -
 drivers/{ => staging}/isdn/gigaset/Makefile        |   10 +-
 drivers/{ => staging}/isdn/gigaset/asyncdata.c     |    0
 drivers/{ => staging}/isdn/gigaset/bas-gigaset.c   |    0
 drivers/{ => staging}/isdn/gigaset/capi.c          |    0
 drivers/{ => staging}/isdn/gigaset/common.c        |    0
 drivers/{ => staging}/isdn/gigaset/dummyll.c       |    0
 drivers/{ => staging}/isdn/gigaset/ev-layer.c      |    0
 drivers/{ => staging}/isdn/gigaset/gigaset.h       |    0
 drivers/{ => staging}/isdn/gigaset/interface.c     |    0
 drivers/{ => staging}/isdn/gigaset/isocdata.c      |    0
 drivers/{ => staging}/isdn/gigaset/proc.c          |    0
 drivers/{ => staging}/isdn/gigaset/ser-gigaset.c   |    0
 drivers/{ => staging}/isdn/gigaset/usb-gigaset.c   |    0
 drivers/{ => staging}/isdn/hysdn/Kconfig           |    0
 drivers/{ => staging}/isdn/hysdn/Makefile          |    0
 drivers/{ => staging}/isdn/hysdn/boardergo.c       |    0
 drivers/{ => staging}/isdn/hysdn/boardergo.h       |    0
 drivers/{ => staging}/isdn/hysdn/hycapi.c          |    0
 drivers/{ => staging}/isdn/hysdn/hysdn_boot.c      |    0
 drivers/{ => staging}/isdn/hysdn/hysdn_defs.h      |    0
 drivers/{ => staging}/isdn/hysdn/hysdn_init.c      |    0
 drivers/{ => staging}/isdn/hysdn/hysdn_net.c       |    0
 drivers/{ => staging}/isdn/hysdn/hysdn_pof.h       |    0
 drivers/{ => staging}/isdn/hysdn/hysdn_procconf.c  |    0
 drivers/{ => staging}/isdn/hysdn/hysdn_proclog.c   |    0
 drivers/{ => staging}/isdn/hysdn/hysdn_sched.c     |    0
 drivers/{ => staging}/isdn/hysdn/ince1pc.h         |    0
 include/linux/concap.h                             |  112 -
 include/linux/isdn.h                               |  473 ---
 include/linux/isdn_divertif.h                      |   35 -
 include/linux/isdn_ppp.h                           |  194 -
 include/linux/isdnif.h                             |  505 ---
 include/linux/wanrouter.h                          |   11 -
 include/uapi/linux/isdn.h                          |  144 -
 include/uapi/linux/isdn_divertif.h                 |   31 -
 include/uapi/linux/isdn_ppp.h                      |   68 -
 include/uapi/linux/isdnif.h                        |   57 -
 include/uapi/linux/wanrouter.h                     |   18 -
 216 files changed, 107 insertions(+), 83884 deletions(-)
 delete mode 100644 Documentation/isdn/HiSax.cert
 delete mode 100644 Documentation/isdn/INTERFACE
 delete mode 100644 Documentation/isdn/INTERFACE.fax
 delete mode 100644 Documentation/isdn/README
 delete mode 100644 Documentation/isdn/README.FAQ
 delete mode 100644 Documentation/isdn/README.HiSax
 delete mode 100644 Documentation/isdn/README.audio
 delete mode 100644 Documentation/isdn/README.concap
 delete mode 100644 Documentation/isdn/README.diversion
 delete mode 100644 Documentation/isdn/README.fax
 delete mode 100644 Documentation/isdn/README.hfc-pci
 delete mode 100644 Documentation/isdn/README.syncppp
 delete mode 100644 Documentation/isdn/README.x25
 delete mode 100644 Documentation/isdn/syncPPP.FAQ
 delete mode 100644 drivers/isdn/capi/capidrv.c
 delete mode 100644 drivers/isdn/capi/capidrv.h
 delete mode 100644 drivers/isdn/divert/Makefile
 delete mode 100644 drivers/isdn/divert/divert_init.c
 delete mode 100644 drivers/isdn/divert/divert_procfs.c
 delete mode 100644 drivers/isdn/divert/isdn_divert.c
 delete mode 100644 drivers/isdn/divert/isdn_divert.h
 delete mode 100644 drivers/isdn/gigaset/i4l.c
 delete mode 100644 drivers/isdn/hardware/Kconfig
 rename drivers/isdn/{i4l => hardware/mISDN}/isdnhdlc.c (99%)
 rename include/linux/isdn/hdlc.h =>
drivers/isdn/hardware/mISDN/isdnhdlc.h (100%)
 delete mode 100644 drivers/isdn/hisax/Kconfig
 delete mode 100644 drivers/isdn/hisax/Makefile
 delete mode 100644 drivers/isdn/hisax/amd7930_fn.c
 delete mode 100644 drivers/isdn/hisax/amd7930_fn.h
 delete mode 100644 drivers/isdn/hisax/arcofi.c
 delete mode 100644 drivers/isdn/hisax/arcofi.h
 delete mode 100644 drivers/isdn/hisax/asuscom.c
 delete mode 100644 drivers/isdn/hisax/avm_a1.c
 delete mode 100644 drivers/isdn/hisax/avm_a1p.c
 delete mode 100644 drivers/isdn/hisax/avm_pci.c
 delete mode 100644 drivers/isdn/hisax/avma1_cs.c
 delete mode 100644 drivers/isdn/hisax/bkm_a4t.c
 delete mode 100644 drivers/isdn/hisax/bkm_a8.c
 delete mode 100644 drivers/isdn/hisax/bkm_ax.h
 delete mode 100644 drivers/isdn/hisax/callc.c
 delete mode 100644 drivers/isdn/hisax/config.c
 delete mode 100644 drivers/isdn/hisax/diva.c
 delete mode 100644 drivers/isdn/hisax/elsa.c
 delete mode 100644 drivers/isdn/hisax/elsa_cs.c
 delete mode 100644 drivers/isdn/hisax/elsa_ser.c
 delete mode 100644 drivers/isdn/hisax/enternow_pci.c
 delete mode 100644 drivers/isdn/hisax/fsm.c
 delete mode 100644 drivers/isdn/hisax/fsm.h
 delete mode 100644 drivers/isdn/hisax/gazel.c
 delete mode 100644 drivers/isdn/hisax/hfc4s8s_l1.c
 delete mode 100644 drivers/isdn/hisax/hfc4s8s_l1.h
 delete mode 100644 drivers/isdn/hisax/hfc_2bds0.c
 delete mode 100644 drivers/isdn/hisax/hfc_2bds0.h
 delete mode 100644 drivers/isdn/hisax/hfc_2bs0.c
 delete mode 100644 drivers/isdn/hisax/hfc_2bs0.h
 delete mode 100644 drivers/isdn/hisax/hfc_pci.c
 delete mode 100644 drivers/isdn/hisax/hfc_pci.h
 delete mode 100644 drivers/isdn/hisax/hfc_sx.c
 delete mode 100644 drivers/isdn/hisax/hfc_sx.h
 delete mode 100644 drivers/isdn/hisax/hfc_usb.c
 delete mode 100644 drivers/isdn/hisax/hfc_usb.h
 delete mode 100644 drivers/isdn/hisax/hfcscard.c
 delete mode 100644 drivers/isdn/hisax/hisax.h
 delete mode 100644 drivers/isdn/hisax/hisax_cfg.h
 delete mode 100644 drivers/isdn/hisax/hisax_debug.h
 delete mode 100644 drivers/isdn/hisax/hisax_fcpcipnp.c
 delete mode 100644 drivers/isdn/hisax/hisax_fcpcipnp.h
 delete mode 100644 drivers/isdn/hisax/hisax_if.h
 delete mode 100644 drivers/isdn/hisax/hisax_isac.c
 delete mode 100644 drivers/isdn/hisax/hisax_isac.h
 delete mode 100644 drivers/isdn/hisax/hscx.c
 delete mode 100644 drivers/isdn/hisax/hscx.h
 delete mode 100644 drivers/isdn/hisax/hscx_irq.c
 delete mode 100644 drivers/isdn/hisax/icc.c
 delete mode 100644 drivers/isdn/hisax/icc.h
 delete mode 100644 drivers/isdn/hisax/ipac.h
 delete mode 100644 drivers/isdn/hisax/ipacx.c
 delete mode 100644 drivers/isdn/hisax/isac.c
 delete mode 100644 drivers/isdn/hisax/isac.h
 delete mode 100644 drivers/isdn/hisax/isar.c
 delete mode 100644 drivers/isdn/hisax/isar.h
 delete mode 100644 drivers/isdn/hisax/isdnl1.c
 delete mode 100644 drivers/isdn/hisax/isdnl1.h
 delete mode 100644 drivers/isdn/hisax/isdnl2.c
 delete mode 100644 drivers/isdn/hisax/isdnl2.h
 delete mode 100644 drivers/isdn/hisax/isdnl3.c
 delete mode 100644 drivers/isdn/hisax/isdnl3.h
 delete mode 100644 drivers/isdn/hisax/isurf.c
 delete mode 100644 drivers/isdn/hisax/ix1_micro.c
 delete mode 100644 drivers/isdn/hisax/jade.c
 delete mode 100644 drivers/isdn/hisax/jade.h
 delete mode 100644 drivers/isdn/hisax/jade_irq.c
 delete mode 100644 drivers/isdn/hisax/l3_1tr6.c
 delete mode 100644 drivers/isdn/hisax/l3_1tr6.h
 delete mode 100644 drivers/isdn/hisax/l3dss1.c
 delete mode 100644 drivers/isdn/hisax/l3dss1.h
 delete mode 100644 drivers/isdn/hisax/l3ni1.c
 delete mode 100644 drivers/isdn/hisax/l3ni1.h
 delete mode 100644 drivers/isdn/hisax/lmgr.c
 delete mode 100644 drivers/isdn/hisax/mic.c
 delete mode 100644 drivers/isdn/hisax/netjet.c
 delete mode 100644 drivers/isdn/hisax/netjet.h
 delete mode 100644 drivers/isdn/hisax/niccy.c
 delete mode 100644 drivers/isdn/hisax/nj_s.c
 delete mode 100644 drivers/isdn/hisax/nj_u.c
 delete mode 100644 drivers/isdn/hisax/q931.c
 delete mode 100644 drivers/isdn/hisax/s0box.c
 delete mode 100644 drivers/isdn/hisax/saphir.c
 delete mode 100644 drivers/isdn/hisax/sedlbauer.c
 delete mode 100644 drivers/isdn/hisax/sedlbauer_cs.c
 delete mode 100644 drivers/isdn/hisax/sportster.c
 delete mode 100644 drivers/isdn/hisax/st5481.h
 delete mode 100644 drivers/isdn/hisax/st5481_b.c
 delete mode 100644 drivers/isdn/hisax/st5481_d.c
 delete mode 100644 drivers/isdn/hisax/st5481_init.c
 delete mode 100644 drivers/isdn/hisax/st5481_usb.c
 delete mode 100644 drivers/isdn/hisax/tei.c
 delete mode 100644 drivers/isdn/hisax/teleint.c
 delete mode 100644 drivers/isdn/hisax/teles0.c
 delete mode 100644 drivers/isdn/hisax/teles3.c
 delete mode 100644 drivers/isdn/hisax/teles_cs.c
 delete mode 100644 drivers/isdn/hisax/telespci.c
 delete mode 100644 drivers/isdn/hisax/w6692.c
 delete mode 100644 drivers/isdn/hisax/w6692.h
 delete mode 100644 drivers/isdn/i4l/Kconfig
 delete mode 100644 drivers/isdn/i4l/Makefile
 delete mode 100644 drivers/isdn/i4l/isdn_audio.c
 delete mode 100644 drivers/isdn/i4l/isdn_audio.h
 delete mode 100644 drivers/isdn/i4l/isdn_bsdcomp.c
 delete mode 100644 drivers/isdn/i4l/isdn_common.c
 delete mode 100644 drivers/isdn/i4l/isdn_common.h
 delete mode 100644 drivers/isdn/i4l/isdn_concap.c
 delete mode 100644 drivers/isdn/i4l/isdn_concap.h
 delete mode 100644 drivers/isdn/i4l/isdn_net.c
 delete mode 100644 drivers/isdn/i4l/isdn_net.h
 delete mode 100644 drivers/isdn/i4l/isdn_ppp.c
 delete mode 100644 drivers/isdn/i4l/isdn_ppp.h
 delete mode 100644 drivers/isdn/i4l/isdn_tty.c
 delete mode 100644 drivers/isdn/i4l/isdn_tty.h
 delete mode 100644 drivers/isdn/i4l/isdn_ttyfax.c
 delete mode 100644 drivers/isdn/i4l/isdn_ttyfax.h
 delete mode 100644 drivers/isdn/i4l/isdn_v110.c
 delete mode 100644 drivers/isdn/i4l/isdn_v110.h
 delete mode 100644 drivers/isdn/i4l/isdn_x25iface.c
 delete mode 100644 drivers/isdn/i4l/isdn_x25iface.h
 delete mode 100644 drivers/isdn/isdnloop/Makefile
 delete mode 100644 drivers/isdn/isdnloop/isdnloop.c
 delete mode 100644 drivers/isdn/isdnloop/isdnloop.h
 create mode 100644 drivers/staging/isdn/Kconfig
 create mode 100644 drivers/staging/isdn/Makefile
 create mode 100644 drivers/staging/isdn/TODO
 rename drivers/{isdn/hardware => staging/isdn}/avm/Kconfig (100%)
 rename drivers/{isdn/hardware => staging/isdn}/avm/Makefile (100%)
 rename drivers/{isdn/hardware => staging/isdn}/avm/avm_cs.c (100%)
 rename drivers/{isdn/hardware => staging/isdn}/avm/avmcard.h (100%)
 rename drivers/{isdn/hardware => staging/isdn}/avm/b1.c (100%)
 rename drivers/{isdn/hardware => staging/isdn}/avm/b1dma.c (100%)
 rename drivers/{isdn/hardware => staging/isdn}/avm/b1isa.c (100%)
 rename drivers/{isdn/hardware => staging/isdn}/avm/b1pci.c (100%)
 rename drivers/{isdn/hardware => staging/isdn}/avm/b1pcmcia.c (100%)
 rename drivers/{isdn/hardware => staging/isdn}/avm/c4.c (100%)
 rename drivers/{isdn/hardware => staging/isdn}/avm/t1isa.c (100%)
 rename drivers/{isdn/hardware => staging/isdn}/avm/t1pci.c (100%)
 rename drivers/{ => staging}/isdn/gigaset/Kconfig (92%)
 rename drivers/{ => staging}/isdn/gigaset/Makefile (74%)
 rename drivers/{ => staging}/isdn/gigaset/asyncdata.c (100%)
 rename drivers/{ => staging}/isdn/gigaset/bas-gigaset.c (100%)
 rename drivers/{ => staging}/isdn/gigaset/capi.c (100%)
 rename drivers/{ => staging}/isdn/gigaset/common.c (100%)
 rename drivers/{ => staging}/isdn/gigaset/dummyll.c (100%)
 rename drivers/{ => staging}/isdn/gigaset/ev-layer.c (100%)
 rename drivers/{ => staging}/isdn/gigaset/gigaset.h (100%)
 rename drivers/{ => staging}/isdn/gigaset/interface.c (100%)
 rename drivers/{ => staging}/isdn/gigaset/isocdata.c (100%)
 rename drivers/{ => staging}/isdn/gigaset/proc.c (100%)
 rename drivers/{ => staging}/isdn/gigaset/ser-gigaset.c (100%)
 rename drivers/{ => staging}/isdn/gigaset/usb-gigaset.c (100%)
 rename drivers/{ => staging}/isdn/hysdn/Kconfig (100%)
 rename drivers/{ => staging}/isdn/hysdn/Makefile (100%)
 rename drivers/{ => staging}/isdn/hysdn/boardergo.c (100%)
 rename drivers/{ => staging}/isdn/hysdn/boardergo.h (100%)
 rename drivers/{ => staging}/isdn/hysdn/hycapi.c (100%)
 rename drivers/{ => staging}/isdn/hysdn/hysdn_boot.c (100%)
 rename drivers/{ => staging}/isdn/hysdn/hysdn_defs.h (100%)
 rename drivers/{ => staging}/isdn/hysdn/hysdn_init.c (100%)
 rename drivers/{ => staging}/isdn/hysdn/hysdn_net.c (100%)
 rename drivers/{ => staging}/isdn/hysdn/hysdn_pof.h (100%)
 rename drivers/{ => staging}/isdn/hysdn/hysdn_procconf.c (100%)
 rename drivers/{ => staging}/isdn/hysdn/hysdn_proclog.c (100%)
 rename drivers/{ => staging}/isdn/hysdn/hysdn_sched.c (100%)
 rename drivers/{ => staging}/isdn/hysdn/ince1pc.h (100%)
 delete mode 100644 include/linux/concap.h
 delete mode 100644 include/linux/isdn.h
 delete mode 100644 include/linux/isdn_divertif.h
 delete mode 100644 include/linux/isdn_ppp.h
 delete mode 100644 include/linux/isdnif.h
 delete mode 100644 include/linux/wanrouter.h
 delete mode 100644 include/uapi/linux/isdn.h
 delete mode 100644 include/uapi/linux/isdn_divertif.h
 delete mode 100644 include/uapi/linux/isdn_ppp.h
 delete mode 100644 include/uapi/linux/isdnif.h
 delete mode 100644 include/uapi/linux/wanrouter.h
