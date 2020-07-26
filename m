Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6570822DE9F
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 13:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgGZLjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 07:39:51 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:32814
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbgGZLju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 07:39:50 -0400
X-IronPort-AV: E=Sophos;i="5.75,398,1589234400"; 
   d="scan'208";a="355309542"
Received: from palace.rsr.lip6.fr (HELO palace.lip6.fr) ([132.227.105.202])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/AES256-SHA256; 26 Jul 2020 13:39:47 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-media@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] drop unnecessary list_empty
Date:   Sun, 26 Jul 2020 12:58:25 +0200
Message-Id: <1595761112-11003-1-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The various list iterators are able to handle an empty list.
The only effect of avoiding the loop is not initializing some
index variables.
Drop list_empty tests in cases where these variables are not
used.

The semantic patch that makes these changes is as follows:
(http://coccinelle.lip6.fr/)

<smpl>
@@
expression x,e;
iterator name list_for_each_entry;
statement S;
identifier i;
@@

-if (!(list_empty(x))) {
   list_for_each_entry(i,x,...) S
- }
 ... when != i
? i = e

@@
expression x,e;
iterator name list_for_each_entry_safe;
statement S;
identifier i,j;
@@

-if (!(list_empty(x))) {
   list_for_each_entry_safe(i,j,x,...) S
- }
 ... when != i
     when != j
(
  i = e;
|
? j = e;
)

@@
expression x,e;
iterator name list_for_each;
statement S;
identifier i;
@@

-if (!(list_empty(x))) {
   list_for_each(i,x) S
- }
 ... when != i
? i = e

@@
expression x,e;
iterator name list_for_each_safe;
statement S;
identifier i,j;
@@

-if (!(list_empty(x))) {
   list_for_each_safe(i,j,x) S
- }
 ... when != i
     when != j
(
  i = e;
|
? j = e;
)

// -------------------

@@
expression x,e;
statement S;
identifier i;
@@

-if (!(list_empty(x)))
   list_for_each_entry(i,x,...) S
 ... when != i
? i = e

@@
expression x,e;
statement S;
identifier i,j;
@@

-if (!(list_empty(x)))
   list_for_each_entry_safe(i,j,x,...) S
 ... when != i
     when != j
(
  i = e;
|
? j = e;
)

@@
expression x,e;
statement S;
identifier i;
@@

-if (!(list_empty(x)))
   list_for_each(i,x) S
 ... when != i
? i = e

@@
expression x,e;
statement S;
identifier i,j;
@@

-if (!(list_empty(x)))
   list_for_each_safe(i,j,x) S
 ... when != i
     when != j
(
  i = e;
|
? j = e;
)
</smpl>

---

 drivers/media/pci/saa7134/saa7134-core.c                      |   14 ++---
 drivers/media/usb/cx231xx/cx231xx-core.c                      |   16 ++----
 drivers/media/usb/tm6000/tm6000-core.c                        |   24 +++-------
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c |   13 ++---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c    |    5 --
 drivers/net/ethernet/sfc/ptp.c                                |   20 +++-----
 drivers/net/wireless/ath/dfs_pattern_detector.c               |   15 ++----
 sound/soc/intel/atom/sst/sst_loader.c                         |   10 +---
 sound/soc/intel/skylake/skl-pcm.c                             |    8 +--
 sound/soc/intel/skylake/skl-topology.c                        |    5 --
 10 files changed, 53 insertions(+), 77 deletions(-)
