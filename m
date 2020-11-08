Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232AA2AAD8B
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 22:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgKHVOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 16:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHVOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 16:14:41 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5D0C0613D2
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 13:14:40 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4CTn254pfZzQky8;
        Sun,  8 Nov 2020 22:14:37 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604870075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VYAfNXju+1xGJXwrids7jHFvlToacpeUSsJEGtGxAZU=;
        b=HSe5FIMVnyNuGd9KhqSltxRrK43hmxVyP8Q8r6B4UKOjYwbBP89rBXQrxOq2elkdbh+ekX
        9whg5X2GClTzd/2GPgEgEZ39QBPgHcGq/G6I9QLHQEfFypEf648KNRJxltdAUnDGDCCraO
        woobPmIGW6grB8UWAuWJwCkgEieaItjgU/VCrJcH/lJG/pIxEYJB0e/lrQ9Lg0QZZDHBeo
        FCYidgPBe+WWiytaPphsUEE5PzI+lhkERl2zDdNd8odAQRSxSKIYD488NXQotSZ5tE1Hsk
        Rpbkzvc7tzdZhkQsA+TJ5gdw7uk7V7ZFPK391wGBEYfu1GNqT2wrTIP+1X0mGQ==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id 63CIuP8hxSrv; Sun,  8 Nov 2020 22:14:33 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v4 00/11] Add a tool for configuration of DCB
Date:   Sun,  8 Nov 2020 22:14:05 +0100
Message-Id: <cover.1604869679.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.70 / 15.00 / 15.00
X-Rspamd-Queue-Id: 468361721
X-Rspamd-UID: 1ddbe5
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

    # dcb -j ets show dev eni1np1 | jq '.tc_bw[2]'
    37

The patchset proceeds as follows:

- Many tools in iproute2 have an option to work in batch mode, where the
  commands to run are given in a file. The code to handle batching is
  largely the same independent of the tool in question. In patch #1, add a
  helper to handle the batching, and migrate individual tools to use it.

- A number of configuration options come in a form of an on-off switch.
  This in turn can be considered a special case of parsing one of a given
  set of strings. In patch #2, extract helpers to parse one of a number of
  strings, on top of which build an on-off parser.

  Currently each tool open-codes the logic to parse the on-off toggle. A
  future patch set will migrate instances of this code over to the new
  helpers.

- The on/off toggles from previous list item sometimes need to be dumped.
  While in the FP output, one typically wishes to maintain consistency with
  the command line and show actual strings, "on" and "off", in JSON output
  one would rather use booleans. This logic is somewhat annoying to have to
  open-code time and again. Therefore in patch #3, add a helper to do just
  that.

- The DCB tool is built on top of libmnl. Several routines will be
  basically the same in DCB as they are currently in devlink. In patches
  #4-#6, extract them to a new module, mnl_utils, for easy reuse.

- Much of DCB is built around arrays. A syntax similar to the iplink_vlan's
  ingress-qos-map / egress-qos-map is very handy for describing changes
  done to such arrays. Therefore in patch #7, extract a helper,
  parse_mapping(), which manages parsing of key-value arrays. In patch #8,
  fix a buglet in the helper, and in patch #9, extend it to allow setting
  of all array elements in one go.

- In patch #10, add a skeleton of "dcb", which contains common helpers and
  dispatches to subtools for handling of individual objects. The skeleton
  is empty as of this patch.

  In patch #11, add "dcb_ets", a module for handling of specifically DCB
  ETS objects.

  The intention is to gradually add handlers for at least PFC, APP, peer
  configuration, buffers and rates.

[1] https://github.com/Mellanox/mlnx-tools/tree/master/ofed_scripts

v4:
- Patch #10:
    - Drop all the FILE* arguments that were passed around unnecessarily
    - Change dcb_parse_mapping() to make it more general
    - Rename dcb_print_array_num() to dcb_print_array_u8()
- Patch #11:
    - Drop all the FILE* arguments that were passed around unnecessarily
    - Emit ets-cap in FP as "ets-cap", not "ets_cap"

v3:
- Patch #2:
    - Have parse_on_off() return a boolean. [David Ahern]
- Patch #3:
    - Rename to print_on_off(). [David Ahern]
    - Move over to json_print.c and make it a variant of print_bool().
      Convert RDMA tool over to print_on_off(). [Leon Romanovsky]
- Patch #10:
    - Fix help output to show the arguments as they are, so -p and
      --pretty, not -[p]retty, which is inaccurate.
- Patch #11:
    - Formatting tweaks in the man page

v2:
- A new function, print_on_off_bool(), has been introduced for showing
  on-off toggles in both FP and JSON modes.
  [Jakub Kicinski, Stephen Hemminger]

- This prompted refactoring in several existing files, and pushed the
  number of patches in the set too high. The cleanup patches have therefore
  been moved out to another patchset, which will follow after this one.

- When dumping JSON, format keys so that they are valid jq identifiers.
  E.g. "tc_tsa" instead of "tc-tsa". Additionally, do not dump arrays as
  objects with string indices, but as true arrays. This allows for more
  natural access to individual items, e.g.:
    # dcb ets -j show dev eth0 | jq '.tc_tsa[3]'
  Instead of:
    # dcb ets -j show dev eth0 | jq '.["tc-tsa"]["3"]'

- Patch #4:
  - Add SPDX-License-Identifier

- Patch #7:
  - In parse_qos_mapping(), propagate return value from addattr_l()
    [Roman Mashak]

Petr Machata (11):
  Unify batch processing across tools
  lib: Add parse_one_of(), parse_on_off()
  lib: json_print: Add print_on_off()
  lib: Extract from devlink/mnlg a helper, mnlu_socket_open()
  lib: Extract from devlink/mnlg a helper, mnlu_msg_prepare()
  lib: Extract from devlink/mnlg a helper, mnlu_socket_recv_run()
  lib: Extract from iplink_vlan a helper to parse key:value arrays
  lib: parse_mapping: Update argc, argv on error
  lib: parse_mapping: Recognize a keyword "all"
  Add skeleton of a new tool, dcb
  dcb: Add a subtool for the DCB ETS object

 Makefile             |   2 +-
 bridge/bridge.c      |  38 +---
 dcb/Makefile         |  24 +++
 dcb/dcb.c            | 416 +++++++++++++++++++++++++++++++++++++++++
 dcb/dcb.h            |  43 +++++
 dcb/dcb_ets.c        | 435 +++++++++++++++++++++++++++++++++++++++++++
 devlink/Makefile     |   2 +-
 devlink/devlink.c    |  41 +---
 devlink/mnlg.c       |  93 ++-------
 include/json_print.h |   1 +
 include/mnl_utils.h  |  11 ++
 include/utils.h      |  11 ++
 ip/ip.c              |  46 +----
 ip/iplink_vlan.c     |  36 ++--
 ip/ipmacsec.c        |  52 ++----
 lib/Makefile         |   2 +-
 lib/json_print.c     |  34 +++-
 lib/mnl_utils.c      | 110 +++++++++++
 lib/utils.c          | 103 ++++++++++
 man/man8/dcb-ets.8   | 185 ++++++++++++++++++
 man/man8/dcb.8       | 114 ++++++++++++
 rdma/dev.c           |   2 +-
 rdma/rdma.c          |  38 +---
 rdma/rdma.h          |   1 -
 rdma/res-cq.c        |   2 +-
 rdma/utils.c         |   5 -
 tc/tc.c              |  38 +---
 27 files changed, 1561 insertions(+), 324 deletions(-)
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

