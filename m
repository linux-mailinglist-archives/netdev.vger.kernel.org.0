Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1644C6D50E6
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbjDCSqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbjDCSp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:45:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4F810A
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 11:45:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88C0B626C4
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 18:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64545C433D2;
        Mon,  3 Apr 2023 18:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680547556;
        bh=mSBd0D7Efh2Xul3bW3lXknsW5Wle0LSn9/zEsNyyLe8=;
        h=Subject:From:To:Cc:Date:From;
        b=NmOlHwyaRL7WYn+ErGPvK5kGeiNlwbDD1N+I4Wpn7oXy6nUc0qy9UpDeY7qi48oX3
         Puan/T/lNuCTuUT6B5bUs+TY7jyKh0XpMo3Ijtiwz60GSibsve+1oKdDaa/tix8EWz
         NW5r8wowQJfKgXw4iJqnRbCJMAcR5RSrCiH+6TNSzqVDt3k2LbbEgdvqOxjs1X1Hx0
         2mdPM38fmz667mIf7rOI4pdXjp5vFF5Of2UaZtZ//UhOfi/9Mko00CU4yH5ju6vP/6
         trHm2K/f2gwFT8BIRARI+TTX+kCR9CLv9O8grtROAmklpNF7EMY24EfVV61HwtpMjd
         OFrnsdXo6jD2w==
Subject: [PATCH v8 0/4] Another crack at a handshake upcall mechanism
From:   Chuck Lever <cel@kernel.org>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        borisp@nvidia.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
        john.haxby@oracle.com
Date:   Mon, 03 Apr 2023 14:45:54 -0400
Message-ID: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi-

Here is v8 of a series to add generic support for transport layer
security handshake on behalf of kernel socket consumers (user space
consumers use a security library directly, of course). A summary of
the purpose of these patches is archived here:

https://lore.kernel.org/netdev/1DE06BB1-6BA9-4DB4-B2AA-07DE532963D6@oracle.com/

The full patch set to support SunRPC with TLSv1.3 is available in
the topic-rpc-with-tls-upcall branch here, based on net-next/main:

https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git

This patch set includes support for in-transit confidentiality and
peer authentication for both the Linux NFS client and server.

A user space handshake agent for TLSv1.3 to go along with the kernel
patches is available in the "main" branch here:

https://github.com/oracle/ktls-utils

---

Major changes since v7:
- Addressed Paolo's v7 review comments
- Added initial set of Kunit tests for the handshake API
- Included an NFS server patch to add new TLS_RECORD_TYPE values

Major changes since v6:
- YAML spec and generated artifacts are now under dual license
- Addressed Jakub's v6 review comments
- Implemented a memory-sensitive limit on the number of pending
  handshake requests
- Implemented upcall support for multiple peer identities

Major changes since v5:
- Added a "timeout" attribute to the handshake netlink protocol
- Removed the GnuTLS-specific "priorities" attribute
- Added support for keyrings to restrict access to keys
- Simplified the kernel consumer TLS handshake API
- The handshake netlink protocol can handle multiple peer IDs or
  certificates in the ACCEPT and DONE operations, though the
  implementation does not yet support it.

Major changes since v4:
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

Chuck Lever (4):
      net/handshake: Create a NETLINK service for handling handshake requests
      net/handshake: Add a kernel API for requesting a TLSv1.3 handshake
      net/handshake: Add Kunit tests for the handshake consumer API
      SUNRPC: Recognize control messages in server-side TCP socket code


 Documentation/netlink/specs/handshake.yaml | 124 +++++
 Documentation/networking/index.rst         |   1 +
 Documentation/networking/tls-handshake.rst | 217 +++++++++
 MAINTAINERS                                |  11 +
 include/net/handshake.h                    |  43 ++
 include/net/tls.h                          |   2 +
 include/trace/events/handshake.h           | 159 +++++++
 include/trace/events/sunrpc.h              |  39 ++
 include/uapi/linux/handshake.h             |  73 +++
 net/Kconfig                                |  20 +
 net/Makefile                               |   1 +
 net/handshake/Makefile                     |  13 +
 net/handshake/genl.c                       |  58 +++
 net/handshake/genl.h                       |  24 +
 net/handshake/handshake.h                  |  81 ++++
 net/handshake/kunit-test.c                 | 523 +++++++++++++++++++++
 net/handshake/netlink.c                    | 327 +++++++++++++
 net/handshake/request.c                    | 344 ++++++++++++++
 net/handshake/tlshd.c                      | 417 ++++++++++++++++
 net/handshake/trace.c                      |  20 +
 net/sunrpc/svcsock.c                       |  49 +-
 21 files changed, 2544 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/netlink/specs/handshake.yaml
 create mode 100644 Documentation/networking/tls-handshake.rst
 create mode 100644 include/net/handshake.h
 create mode 100644 include/trace/events/handshake.h
 create mode 100644 include/uapi/linux/handshake.h
 create mode 100644 net/handshake/Makefile
 create mode 100644 net/handshake/genl.c
 create mode 100644 net/handshake/genl.h
 create mode 100644 net/handshake/handshake.h
 create mode 100644 net/handshake/kunit-test.c
 create mode 100644 net/handshake/netlink.c
 create mode 100644 net/handshake/request.c
 create mode 100644 net/handshake/tlshd.c
 create mode 100644 net/handshake/trace.c

--
Chuck Lever

