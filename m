Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B03467F4A7
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 05:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjA1EcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 23:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjA1EcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 23:32:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC2A7AE61
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 20:32:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6276B821EF
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C04CC4339B;
        Sat, 28 Jan 2023 04:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674880339;
        bh=LQPVIGul3NCBKAcya7FNOp6sNuWnbwyO07vDZReGCCI=;
        h=From:To:Cc:Subject:Date:From;
        b=LVeVrSSchdfeKq9HkmpP14dKvHA8l1kVBkQDmLH8ZzSnjzQl1MCkMRqIX1mhlRvQm
         7A62xIg01NDVoTRdDt5Mf0YEQg9i/hg1Boosi3kuWKNBPklfHq+/vudKe89gqKxCfB
         YMX0l2eufRmcN5pT//BU9RQN0kMsM1YNyAM2SWFkBdlKqqtKQNsVTP/lNzhRMzvDuu
         MMc3K5F1ivU7suM8Yj9/XbizjzzN7U3sSejJxFhY3MimhQAXDma9so2nV/CCl9vYEU
         LhAJLjnr0zg4RWvHJsh9ns5Scr0NHbgU2fotgu3HSC8f9+2NbbAPOY5n7kE7Mi4+HC
         DZqJdoGEtC87w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/13] tools: ynl: more docs and basic ethtool support
Date:   Fri, 27 Jan 2023 20:32:04 -0800
Message-Id: <20230128043217.1572362-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
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

I got discouraged from supporting ethtool in specs, because
generating the user space C code seems a little tricky.
The messages are ID'ed in a "directional" way (to and from
kernel are separate ID "spaces"). There is value, however,
in having the spec and being able to for example use it
in Python.

After paying off some technical debt - add a partial
ethtool spec. Partial because the header for ethtool is almost
a 1000 LoC, so converting in one sitting is tough. But adding
new commands should be trivial now.

Last but not least I add more docs, I realized that I've been
sending a similar "instructions" email to people working on
new families. It's now intro-specs.rst.

Jakub Kicinski (13):
  tools: ynl-gen: prevent do / dump reordering
  tools: ynl: move the cli and netlink code around
  tools: ynl: add an object hierarchy to represent parsed spec
  tools: ynl: use the common YAML loading and validation code
  tools: ynl: add support for types needed by ethtool
  tools: ynl: support directional enum-model in CLI
  tools: ynl: support multi-attr
  tools: ynl: support pretty printing bad attribute names
  tools: ynl: use operation names from spec on the CLI
  tools: ynl: load jsonschema on demand
  netlink: specs: finish up operation enum-models
  netlink: specs: add partial specification for ethtool
  docs: netlink: add a starting guide for working with specs

 Documentation/netlink/genetlink-c.yaml        |   4 +-
 Documentation/netlink/genetlink-legacy.yaml   |  11 +-
 Documentation/netlink/genetlink.yaml          |   4 +-
 Documentation/netlink/specs/ethtool.yaml      | 392 ++++++++++++++++++
 .../netlink/genetlink-legacy.rst              |  82 ++++
 Documentation/userspace-api/netlink/index.rst |   1 +
 .../userspace-api/netlink/intro-specs.rst     |  80 ++++
 Documentation/userspace-api/netlink/specs.rst |   3 +
 tools/net/ynl/{samples => }/cli.py            |  15 +-
 tools/net/ynl/lib/__init__.py                 |   7 +
 tools/net/ynl/lib/nlspec.py                   | 310 ++++++++++++++
 tools/net/ynl/{samples => lib}/ynl.py         | 192 +++++----
 tools/net/ynl/ynl-gen-c.py                    | 260 ++++++------
 13 files changed, 1107 insertions(+), 254 deletions(-)
 create mode 100644 Documentation/netlink/specs/ethtool.yaml
 create mode 100644 Documentation/userspace-api/netlink/intro-specs.rst
 rename tools/net/ynl/{samples => }/cli.py (78%)
 create mode 100644 tools/net/ynl/lib/__init__.py
 create mode 100644 tools/net/ynl/lib/nlspec.py
 rename tools/net/ynl/{samples => lib}/ynl.py (79%)

-- 
2.39.1

