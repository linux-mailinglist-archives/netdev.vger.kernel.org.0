Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458995F02CA
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 04:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiI3Ce2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 22:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiI3Ce1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 22:34:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7AA121E59;
        Thu, 29 Sep 2022 19:34:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 046C6B826C8;
        Fri, 30 Sep 2022 02:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF28C433D7;
        Fri, 30 Sep 2022 02:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664505263;
        bh=CDJG0sHnm7j0RyYxIxPni09cTZWfHoHVonnlqWLv9v8=;
        h=From:To:Cc:Subject:Date:From;
        b=rX7Wd97B8T4ugW59ASHQndugT9IZs27oW3+I04qziddw2N5eJPlBcmEIRbsoluDkZ
         vxsDbpc/FbvZ4l5jn3fnWKzfR7YQgb0Ze5UTtS+kz71kqIU6jWjoi+S3C74bBnV5NZ
         vpjWRi4x4Psh5ZFnX3VFhd2AuWPSxAKv1bq0Xva9GZ6M47EDmFSfWTfTaHq3l4pI8t
         g28PCIyTuNhm1q/SLuBKKsCb1pTI2D5p5oCZAqDzNTw2qdRKtmgWgMarsSalmTIfpi
         UolmNKfcYS9RAikGVRF6Za2aYRxVBLVEnw43NO+SqqCFxzs2XbSG07GuLduu5mfqDT
         V87vITklpKg7g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net, ecree.xilinx@gmail.com,
        stephen@networkplumber.org, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/7] Netlink protocol specs
Date:   Thu, 29 Sep 2022 19:34:11 -0700
Message-Id: <20220930023418.1346263-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

I think the Netlink proto specs are far along enough to merge.
Filling in all attribute types and quirks will be an ongoing
effort but we have enough to cover FOU so it's somewhat complete.

I fully intend to continue polishing the code but at the same
time I'd like to start helping others base their work on the
specs (e.g. DPLL) and need to start working on some new families
myself.

That's the progress / motivation for merging. The RFC [1] has more
of a high level blurb, plus I created a lot of documentation, I'm
not going to repeat it here. There was also the talk at LPC [2].

[1] https://lore.kernel.org/all/20220811022304.583300-1-kuba@kernel.org/
[2] https://youtu.be/9QkXIQXkaQk?t=2562

v2:
 - update docs
 - change comment format in uAPI from // to /* */
 - rename fou.c to make linker happy

Jakub Kicinski (7):
  docs: add more netlink docs (incl. spec docs)
  netlink: add schemas for YAML specs
  net: add basic C code generators for Netlink
  netlink: add a proto specification for FOU
  net: fou: regenerate the uAPI from the spec
  net: fou: rename the source for linking
  net: fou: use policy and operation tables generated from the spec

 Documentation/core-api/index.rst              |    1 +
 Documentation/core-api/netlink.rst            |   99 +
 Documentation/netlink/genetlink-c.yaml        |  287 +++
 Documentation/netlink/genetlink-legacy.yaml   |  313 +++
 Documentation/netlink/genetlink.yaml          |  252 +++
 Documentation/netlink/specs/fou.yaml          |  128 ++
 .../userspace-api/netlink/c-code-gen.rst      |  104 +
 .../netlink/genetlink-legacy.rst              |   96 +
 Documentation/userspace-api/netlink/index.rst |    5 +
 Documentation/userspace-api/netlink/specs.rst |  410 ++++
 MAINTAINERS                                   |    3 +
 include/uapi/linux/fou.h                      |   54 +-
 net/ipv4/Makefile                             |    1 +
 net/ipv4/fou-nl.c                             |   48 +
 net/ipv4/fou-nl.h                             |   25 +
 net/ipv4/{fou.c => fou_core.c}                |   51 +-
 tools/net/ynl/ynl-gen-c.py                    | 1998 +++++++++++++++++
 tools/net/ynl/ynl-regen.sh                    |   30 +
 18 files changed, 3835 insertions(+), 70 deletions(-)
 create mode 100644 Documentation/core-api/netlink.rst
 create mode 100644 Documentation/netlink/genetlink-c.yaml
 create mode 100644 Documentation/netlink/genetlink-legacy.yaml
 create mode 100644 Documentation/netlink/genetlink.yaml
 create mode 100644 Documentation/netlink/specs/fou.yaml
 create mode 100644 Documentation/userspace-api/netlink/c-code-gen.rst
 create mode 100644 Documentation/userspace-api/netlink/genetlink-legacy.rst
 create mode 100644 Documentation/userspace-api/netlink/specs.rst
 create mode 100644 net/ipv4/fou-nl.c
 create mode 100644 net/ipv4/fou-nl.h
 rename net/ipv4/{fou.c => fou_core.c} (94%)
 create mode 100755 tools/net/ynl/ynl-gen-c.py
 create mode 100755 tools/net/ynl/ynl-regen.sh

-- 
2.37.3

