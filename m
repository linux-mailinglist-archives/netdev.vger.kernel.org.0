Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9E6672D72
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 01:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjASAgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 19:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjASAgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 19:36:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8A7589BA;
        Wed, 18 Jan 2023 16:36:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A56EB81F8F;
        Thu, 19 Jan 2023 00:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8062AC433D2;
        Thu, 19 Jan 2023 00:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674088578;
        bh=120/X2fXh8+yscE4P6H9VYzZecc9ndfRsf4eAAqIKy0=;
        h=From:To:Cc:Subject:Date:From;
        b=AEH8npp9XuC2RJe5Shytn6S+XU/lRfyVRrRkfeL6sIBERwBFWg8osCUKnGO8lSgrM
         SD0IPcjWYp/1QI1SzK6j63rSCsk0hInJasLY57OSOqhuisWe/xTXl5Vl0fTmHLgPk1
         040w7ZmRrtIwSXST//FYEDryQnntUQ6nN0iJIw+MRo1aDUTZTsbKmtwe4gL7o063hP
         8XYZEn5S/C2UsedX/XpggAtsdXcsNAOnXa5R8Qooqze5lg9z5RQ8F6e1xk9S0Grmmm
         Yps+0X5P0Kj3yL/E71Mb13b18S5JxSN8h+zC/n5NEJj1AdpSg4UibavoZFZVgeFPIo
         uSG0rjKxNMByg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 0/8] Netlink protocol specs
Date:   Wed, 18 Jan 2023 16:36:05 -0800
Message-Id: <20230119003613.111778-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
v2: https://lore.kernel.org/all/20220930023418.1346263-1-kuba@kernel.org/

Jakub Kicinski (8):
  docs: add more netlink docs (incl. spec docs)
  netlink: add schemas for YAML specs
  net: add basic C code generators for Netlink
  netlink: add a proto specification for FOU
  net: fou: regenerate the uAPI from the spec
  net: fou: rename the source for linking
  net: fou: use policy and operation tables generated from the spec
  tools: ynl: add a completely generic client

 Documentation/core-api/index.rst              |    1 +
 Documentation/core-api/netlink.rst            |   99 +
 Documentation/netlink/genetlink-c.yaml        |  318 +++
 Documentation/netlink/genetlink-legacy.yaml   |  346 +++
 Documentation/netlink/genetlink.yaml          |  284 ++
 Documentation/netlink/specs/fou.yaml          |  128 +
 .../userspace-api/netlink/c-code-gen.rst      |  107 +
 .../netlink/genetlink-legacy.rst              |   96 +
 Documentation/userspace-api/netlink/index.rst |    5 +
 Documentation/userspace-api/netlink/specs.rst |  422 +++
 MAINTAINERS                                   |    3 +
 include/uapi/linux/fou.h                      |   54 +-
 net/ipv4/Makefile                             |    1 +
 net/ipv4/fou-nl.c                             |   48 +
 net/ipv4/fou-nl.h                             |   25 +
 net/ipv4/{fou.c => fou_core.c}                |   47 +-
 tools/net/ynl/samples/cli.py                  |   47 +
 tools/net/ynl/samples/ynl.py                  |  534 ++++
 tools/net/ynl/ynl-gen-c.py                    | 2376 +++++++++++++++++
 tools/net/ynl/ynl-regen.sh                    |   30 +
 20 files changed, 4903 insertions(+), 68 deletions(-)
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
 create mode 100755 tools/net/ynl/samples/cli.py
 create mode 100644 tools/net/ynl/samples/ynl.py
 create mode 100755 tools/net/ynl/ynl-gen-c.py
 create mode 100755 tools/net/ynl/ynl-regen.sh

-- 
2.39.0

