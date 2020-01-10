Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F5F136C21
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 12:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgAJLmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 06:42:17 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36829 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727457AbgAJLmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 06:42:17 -0500
Received: by mail-pf1-f196.google.com with SMTP id x184so1031483pfb.3
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 03:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aLRT3ugfu9YaWhBnJhHE7PgMgEw2C+WSGlslyzbuQeg=;
        b=g8S3Bb1QOcdk1CNlmR1FnbVg4bi6iRakaESxi4hoyqOQ1Ln0ICWNLrfZuTIxsHB9SA
         1xzTYcSvFFwcAXXx2okTfFWnOC6fW3e+ILEDgNeEqiZWwEkPLC9bexq+snznd3pArU61
         sT65sNJfNCm+ruJMxrqH/hPrNgGUyyuCSWDtRsgmbJS99Dob2bFcMR7LgHuYSbZQ5xNQ
         vlmDGGXdI8KW3flBsrB9YutBtYbFOPC2YTbdYb9u9rwgj/BN7zRH4etsaCzOU+j3ZQZl
         q2fS4ArnDzQ6UqsaCrEoCzkjgj7bkClmazTHbfZ77Gg+x/VM8KiqzJsWWB8jQFK+WEnE
         ZfWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aLRT3ugfu9YaWhBnJhHE7PgMgEw2C+WSGlslyzbuQeg=;
        b=hdKEFOW4Ba6Nft11TozFdI3uGMbcVzd9FxPXh5E0gmI7Jwvovg/JhWsXX/yG/nddaZ
         WMm6vLiGgUE1jlO3ZYLHf5vNL0cSSroig0QOEGsBu8eQxM2E2rRIjb+Fl27wTuA+C4cI
         nRjs+4oNTUGUTo1+SkpGcTiIJMNAG9MczDaHrVhE/bb8bGTiokjUodyxO8r/K17UEEVH
         tplxA9s5t0UWoHDd7XatAc+3LXATrBMuFfKXNDh/8DKlwCLrrSXDUIeCR/zs1/W7/VfD
         Ow3m+rjwwTeVCtE+a1Z2JRqxafROzEHKyUPhTDhSfh0GjAxziXhhAoUAsJ843I1qu4Ul
         9MAA==
X-Gm-Message-State: APjAAAU1iedvePiepj8GDQaBoBtmLrQe8osqzYs3ORdmZ0P7/pFei/4F
        N+cxXtCPX7I3oPP9Wy73qKXtwRlfZvs=
X-Google-Smtp-Source: APXvYqwR/M6lX3UxJeJOJho/SXZRTvKKZ9cb7JdxEA4iz+mzHMFopcl19vp1ko/9E8OxIeweFCgpZA==
X-Received: by 2002:a62:1944:: with SMTP id 65mr3663288pfz.151.1578656536001;
        Fri, 10 Jan 2020 03:42:16 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id o19sm8848866pjr.2.2020.01.10.03.42.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 10 Jan 2020 03:42:15 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 00/17] octeontx2-pf: Add network driver for physical function
Date:   Fri, 10 Jan 2020 17:11:44 +0530
Message-Id: <1578656521-14189-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

OcteonTX2 SOC's resource virtualization unit (RVU) supports 
multiple physical and virtual functions. Each of the PF's
functionality is determined by what kind of resources are attached
to it. If NPA and NIX blocks are attached to a PF it can function
as a highly capable network device.

This patch series add a network driver for the PF. Initial set of
patches adds mailbox communication with admin function (RVU AF)
and configuration of queues. Followed by Rx and tx pkts NAPI
handler and then support for HW offloads like RSS, TSO, Rxhash etc. 
Ethtool support to extract stats, config RSS, queue sizes, queue
count is also added. 

Added documentation to give a high level overview of HW and
different drivers which will be upstreamed and how they interact.

Christina Jacob (1):
  octeontx2-pf: Add basic ethtool support

Geetha sowjanya (2):
  octeontx2-pf: Error handling support
  octeontx2-pf: Add ndo_get_stats64

Linu Cherian (1):
  octeontx2-pf: Register and handle link notifications

Sunil Goutham (13):
  octeontx2-pf: Add Marvell OcteonTX2 NIC driver
  octeontx2-pf: Mailbox communication with AF
  octeontx2-pf: Attach NIX and NPA block LFs
  octeontx2-pf: Initialize and config queues
  octeontx2-pf: Setup interrupts and NAPI handler
  octeontx2-pf: Receive packet handling support
  octeontx2-pf: Add packet transmission support
  octeontx2-pf: MTU, MAC and RX mode config support
  octeontx2-pf: Receive side scaling support
  octeontx2-pf: TCP segmentation offload support
  octeontx2-pf: ethtool RSS config support
  Documentation: net: octeontx2: Add RVU HW and drivers overview
  MAINTAINERS: Add entry for Marvell OcteonTX2 Physical Function driver

 Documentation/networking/device_drivers/index.rst  |    1 +
 .../device_drivers/marvell/octeontx2.rst           |  159 +++
 MAINTAINERS                                        |   10 +
 drivers/net/ethernet/marvell/octeontx2/Kconfig     |    7 +
 drivers/net/ethernet/marvell/octeontx2/Makefile    |    2 +
 drivers/net/ethernet/marvell/octeontx2/af/common.h |    9 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |    8 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   17 +
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   10 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 1409 ++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  615 +++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  659 +++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 1361 +++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  147 ++
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  439 ++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  863 ++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |  162 +++
 17 files changed, 5875 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/marvell/octeontx2.rst
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/Makefile
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h

-- 
2.7.4

