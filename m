Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066056A2246
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 20:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjBXTTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 14:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjBXTTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 14:19:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C79664E0D
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 11:19:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98D4161968
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 19:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E63C4339C;
        Fri, 24 Feb 2023 19:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677266354;
        bh=WfkQh6PGzxmfTGhMOK+PEzZMnjbWA71u59ymcVEZhZc=;
        h=Subject:From:To:Cc:Date:From;
        b=MOsJx8j8YqrWtOHB20giuULOFlyrRyDQ1WO5WKo/kYJsBOEkMuOCTHuq2kI4tWNHS
         VmroqNVb0+PMK96fTPxuA5TU/R9bFYvH6ovSOo8KLpQOaOoh3ytfRVtMhIrGscAY//
         BZMCOtkcYLb0yBIUWaUQxEkmbA2QZbRv9Ab1CrD2i8c/txXoC0aBHrJfUCZSGsI5pq
         Wuya+sFPt1Mk33ZjlPIV3LT2mLCv1LCNcO83JB8fRJrRiMaGf98r3OoM5QJuHkl5nV
         CDNhOEyNgHLL3kDK2yqg7H8dny/JJ18zg3+q4xaDAvnztr1RoQxxaqFuAERu16cj11
         BnlfJ51PurMcw==
Subject: [PATCH v5 0/2] Another crack at a handshake upcall mechanism
From:   Chuck Lever <cel@kernel.org>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev
Date:   Fri, 24 Feb 2023 14:19:12 -0500
Message-ID: <167726551328.5428.13732817493891677975.stgit@91.116.238.104.host.secureserver.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi-

Here is v5 of a series to add generic support for transport layer
security handshake on behalf of kernel socket consumers (user space
consumers use a security library directly, of course). A summary of
the purpose of these patches is archived here:

https://lore.kernel.org/netdev/1DE06BB1-6BA9-4DB4-B2AA-07DE532963D6@oracle.com/

For v5, I've created a YAML spec that describes the HANDSHAKE
netlink protocol. Some simplifications were necessary to make the
protocol fit within the YAML schema. I was not able to get
multi-attr working for the remote-peerid attribute, so that has been
postponed to v6.

The socket "accept" mechanism has been replaced with something more
like "dup(2)", and we no longer rely on the DONE operation to close
the accepted file descriptor. Hopefully this clarifies error and
timeout handling as well as handshake_req lifetime.

The full patch set to support SunRPC with TLSv1.3 is available in
the topic-rpc-with-tls-upcall branch here, based on net-next/main:

  https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git

A user space handshake agent for TLSv1.3 to go along with the kernel
patches is available in the "netlink" branch here:

  https://github.com/oracle/ktls-utils

Enjoy your weekend!

---

Changes since v4:
- Rebased onto net-next/main
- Replaced req reference counting with ->sk_destruct
- CMD_ACCEPT now does the equivalent of a dup(2) rather than an
  accept(2)
- CMD_DONE no longer closes the user space socket endpoint
- handshake_req_cancel is now tested and working
- Added a YAML specification for the netlink upcall protocol, and
  simplified the protocol to fit the YAML schema
- Added an initial set of tracepoints

Changes since v3:
- Converted all netlink code to use Generic Netlink
- Reworked handshake request lifetime logic throughout
- Global pending list is now per-net
- On completion, return the remote's identity to the consumer

Changes since v2:
- PF_HANDSHAKE replaced with NETLINK_HANDSHAKE
- Replaced listen(2) / poll(2) with a multicast notification service
- Replaced accept(2) with a netlink operation that can return an
  open fd and handshake parameters
- Replaced close(2) with a netlink operation that can take arguments

Changes since RFC:
- Generic upcall support split away from kTLS
- Added support for TLS ServerHello
- Documentation has been temporarily removed while API churns

---

Chuck Lever (2):
      net/handshake: Create a NETLINK service for handling handshake requests
      net/tls: Add kernel APIs for requesting a TLSv1.3 handshake


 Documentation/netlink/specs/handshake.yaml | 136 +++++++
 Documentation/networking/index.rst         |   1 +
 Documentation/networking/tls-handshake.rst | 146 +++++++
 include/net/handshake.h                    |  45 +++
 include/net/net_namespace.h                |   5 +
 include/net/sock.h                         |   1 +
 include/net/tls.h                          |  27 ++
 include/trace/events/handshake.h           | 159 ++++++++
 include/uapi/linux/handshake.h             |  65 ++++
 net/Makefile                               |   1 +
 net/handshake/Makefile                     |  11 +
 net/handshake/handshake.h                  |  41 ++
 net/handshake/netlink.c                    | 341 +++++++++++++++++
 net/handshake/request.c                    | 246 ++++++++++++
 net/handshake/trace.c                      |  17 +
 net/tls/Makefile                           |   2 +-
 net/tls/tls_handshake.c                    | 423 +++++++++++++++++++++
 17 files changed, 1666 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/netlink/specs/handshake.yaml
 create mode 100644 Documentation/networking/tls-handshake.rst
 create mode 100644 include/net/handshake.h
 create mode 100644 include/trace/events/handshake.h
 create mode 100644 include/uapi/linux/handshake.h
 create mode 100644 net/handshake/Makefile
 create mode 100644 net/handshake/handshake.h
 create mode 100644 net/handshake/netlink.c
 create mode 100644 net/handshake/request.c
 create mode 100644 net/handshake/trace.c
 create mode 100644 net/tls/tls_handshake.c

--
Chuck Lever

