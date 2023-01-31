Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31C768221F
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjAaCeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjAaCeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:34:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DA5360BC;
        Mon, 30 Jan 2023 18:34:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9879FB818C2;
        Tue, 31 Jan 2023 02:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA1BC4339B;
        Tue, 31 Jan 2023 02:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675132439;
        bh=AZHHuDBuAI5h6ELge/xoV1CEJ2rX/3xkkO9zAmCdBJQ=;
        h=From:To:Cc:Subject:Date:From;
        b=tfqdz0LqvhH3Y3Pnko+VBlQejKm+jU/jgc9/55ATX0B736pou6RaoK8pGIPLftTyH
         QzsQE7UHPaJXRjkfW6xdZMsjrMrJCht1SJcuVzZc3jc3J8wNqH/CjTatun2hJqSU+a
         d9kkxDno170NOYW9PmZ/iIWjelCtfjemCE+L/sKIAPyBmn7fEKha3Utuoupjq5v38i
         oRlldhTOmL/8skqYfz2bIXkLNd8bgSRHHuUr/ytOaj8HlI5oJYXGzBneccWFcOKj2D
         9CCJ1f/z9WXYVSwZ+vUaImu1yyuK2FN2ff0TwJu+ChNtFb8T/8/TuFye1/iv1sEiCF
         yMZCsRehW+S6w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        sdf@google.com, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 00/14] tools: ynl: more docs and basic ethtool support
Date:   Mon, 30 Jan 2023 18:33:40 -0800
Message-Id: <20230131023354.1732677-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

v2:
 - spelling fixes (patch 11)
 - always use python3 (new patch 14)

Jakub Kicinski (14):
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
  tools: net: use python3 explicitly

 Documentation/netlink/genetlink-c.yaml        |   4 +-
 Documentation/netlink/genetlink-legacy.yaml   |  11 +-
 Documentation/netlink/genetlink.yaml          |   4 +-
 Documentation/netlink/specs/ethtool.yaml      | 392 ++++++++++++++++++
 .../netlink/genetlink-legacy.rst              |  82 ++++
 Documentation/userspace-api/netlink/index.rst |   1 +
 .../userspace-api/netlink/intro-specs.rst     |  80 ++++
 Documentation/userspace-api/netlink/specs.rst |   3 +
 tools/net/ynl/{samples => }/cli.py            |  17 +-
 tools/net/ynl/lib/__init__.py                 |   7 +
 tools/net/ynl/lib/nlspec.py                   | 310 ++++++++++++++
 tools/net/ynl/{samples => lib}/ynl.py         | 192 +++++----
 tools/net/ynl/ynl-gen-c.py                    | 262 ++++++------
 13 files changed, 1109 insertions(+), 256 deletions(-)
 create mode 100644 Documentation/netlink/specs/ethtool.yaml
 create mode 100644 Documentation/userspace-api/netlink/intro-specs.rst
 rename tools/net/ynl/{samples => }/cli.py (76%)
 create mode 100644 tools/net/ynl/lib/__init__.py
 create mode 100644 tools/net/ynl/lib/nlspec.py
 rename tools/net/ynl/{samples => lib}/ynl.py (79%)

-- 
2.39.1

