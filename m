Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27428293275
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389611AbgJTA6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgJTA6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:58:50 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD14C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:58:50 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4CFZxy2V5SzKmTX;
        Tue, 20 Oct 2020 02:58:46 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603155523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NVVDB19Fbecx7gqSdFWMuufrz4Tj5iG83rrYRKFh2cA=;
        b=T/VJYyQfPzsUdVuQndc891CdArA7FmGhpZxK4PxGKrlPqD5743LPqmacLYfEuqZpKNxwyE
        qHmeA5snX2VKGZICz1KeZQjRsu/qVxhox8RezUOFO1U2X8HWYAUMe6qyDIQE1RRTpS5WR6
        /MxpdFRT7ORqjJ+OS8jXhSzUqdOUMaF+fRDorFKAgjsra201thGSdA/7Dyt5REzr3Y125H
        RPTypKZ46/SVV29EqemizDyS7ZqqRBG+KPnDiBkszuMaou9A6ss8olNpZHX5pCEVcycNOA
        MBwGk56gFMGlD40dXiIjVY234At9OtbQL0w28dSExOBm1e75w/1cn5dgOVyriA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id yChxJSY9mCUZ; Tue, 20 Oct 2020 02:58:41 +0200 (CEST)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 00/15] Add a tool for configuration of DCB
Date:   Tue, 20 Oct 2020 02:58:08 +0200
Message-Id: <cover.1603154867.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.65 / 15.00 / 15.00
X-Rspamd-Queue-Id: 7444615
X-Rspamd-UID: 8855ff
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Linux DCB interface allows configuration of a broad range of
hardware-specific attributes, such as TC scheduling, flow control, per-port
buffer configuration, TC rate, etc.

Currently a common libre tool for configuration of DCB is OpenLLDP. This
suite contains a daemon that uses Linux DCB interface to configure HW
according to the DCB TLVs exchanged over an interface. The daemon can also
be controlled by a client, through which the user can adjust and view the
configuration. The downside of using OpenLLDP is that it is somewhat
heavyweight and difficult to use in scripts, and does not support
extensions such as buffer and rate commands.

For access to many HW features, one would be perfectly fine with a
fire-and-forget tool along the lines of "ip" or "tc". For scripting in
particular, this would be ideal. This author is aware of one such tool,
mlnx_qos from Mellanox OFED scripts collection[1].

The downside here is that the tool is very verbose, the command line
language is awkward to use, it is not packaged in Linux distros, and
generally has the appearance of a very vendor-specific tool, despite not
being one.

This patchset addresses the above issues by providing a seed of a clean,
well-documented, easily usable, extensible fire-and-forget tool for DCB
configuration:

    # dcb ets set dev eni1np1 \
                  tc-tsa all:strict 0:ets 1:ets 2:ets \
		  tc-bw all:0 0:33 1:33 2:34

    # dcb ets show dev eni1np1 tc-tsa tc-bw
    tc-tsa 0:ets 1:ets 2:ets 3:strict 4:strict 5:strict 6:strict 7:strict
    tc-bw 0:33 1:33 2:34 3:0 4:0 5:0 6:0 7:0

    # dcb ets set dev eni1np1 tc-bw 1:30 2:37

    # dcb -j ets show dev eni1np1 | jq '.["tc-bw"]["2"]'
    37

The patchset proceeds as follows:

- Many tools in iproute2 have an option to work in batch mode, where the
  commands to run are given in a file. The code to handle batching is
  largely the same independent of the tool in question. In patch #1, add a
  helper to handle the batching, and migrate individual tools to use it.

- A number of configuration options come in a form of an on-off switch.
  This in turn can be considered a special case of parsing one of a given
  set of strings. Currently each tool open-codes the logic to parse the
  on-off toggle. And on top of the on-off parsing, tools have logic to set
  or unset a flag according to the keyword parsed.

  In patches #2-#7, extract helpers to parse one of a number of strings, on
  top of which build an on-off parser, on top of which build a flag set /
  unset handler. Then migrate all known instances of this code over to the
  new helpers.

- The DCB tool is built on top of libmnl. Several routines will be
  basically the same in DCB as they are currently in devlink. In patches
  #8-#10, extract them to a new module, mnl_utils, for easy reuse.

- Much of DCB is built around arrays. A syntax similar to the iplink_vlan's
  ingress-qos-map / egress-qos-map is very handy for describing changes
  done to such arrays. Therefore in patch #11, extract a helper,
  parse_mapping(), which manages parsing of key-value arrays. In patch #12,
  fix a buglet in the helper, and in patch #13, extend it to allow setting
  of all array elements in one go.

- In patch #14, add a skeleton of "dcb", which contains common helpers and
  dispatches to subtools for handling of individual objects. The skeleton
  is empty as of this patch.

  In patch #15, add "dcb_ets", a module for handling of specifically DCB
  ETS objects.

The intention is to gradually add handlers for at least PFC, APP, peer
configuration, buffers and rates.

[1] https://github.com/Mellanox/mlnx-tools/tree/master/ofed_scripts

Petr Machata (15):
  Unify batch processing across tools
  lib: Add parse_one_of(), parse_on_off()
  bridge: link: Port over to parse_on_off()
  lib: Add parse_flag_on_off(), set_flag()
  ip: iplink: Convert to use parse_on_off(), parse_flag_on_off()
  ip: iplink_vlan: Port over to parse_flag_on_off()
  ip: iplink_bridge_slave: Port over to parse_on_off()
  lib: Extract from devlink/mnlg a helper, mnlu_socket_open()
  lib: Extract from devlink/mnlg a helper, mnlu_msg_prepare()
  lib: Extract from devlink/mnlg a helper, mnlu_socket_recv_run()
  lib: Extract from iplink_vlan a helper to parse key:value arrays
  lib: parse_mapping: Update argc, argv on error
  lib: parse_mapping: Recognize a keyword "all"
  Add skeleton of a new tool, dcb
  dcb: Add a subtool for the DCB ETS object

 Makefile                 |   2 +-
 bridge/bridge.c          |  38 +---
 bridge/link.c            |  79 ++++---
 dcb/Makefile             |  24 +++
 dcb/dcb.c                | 379 +++++++++++++++++++++++++++++++++
 dcb/dcb.h                |  36 ++++
 dcb/dcb_ets.c            | 450 +++++++++++++++++++++++++++++++++++++++
 devlink/Makefile         |   2 +-
 devlink/devlink.c        |  41 +---
 devlink/mnlg.c           |  93 ++------
 include/mnl_utils.h      |  11 +
 include/utils.h          |  21 ++
 ip/ip.c                  |  46 +---
 ip/iplink.c              | 182 ++++++----------
 ip/iplink_bridge_slave.c |  12 +-
 ip/iplink_vlan.c         |  86 +++-----
 ip/ipmacsec.c            |  52 +----
 lib/Makefile             |   2 +-
 lib/mnl_utils.c          | 115 ++++++++++
 lib/utils.c              | 114 ++++++++++
 man/man8/dcb-ets.8       | 185 ++++++++++++++++
 man/man8/dcb.8           | 114 ++++++++++
 rdma/rdma.c              |  38 +---
 tc/tc.c                  |  38 +---
 24 files changed, 1652 insertions(+), 508 deletions(-)
 create mode 100644 dcb/Makefile
 create mode 100644 dcb/dcb.c
 create mode 100644 dcb/dcb.h
 create mode 100644 dcb/dcb_ets.c
 create mode 100644 include/mnl_utils.h
 create mode 100644 lib/mnl_utils.c
 create mode 100644 man/man8/dcb-ets.8
 create mode 100644 man/man8/dcb.8

-- 
2.25.1

