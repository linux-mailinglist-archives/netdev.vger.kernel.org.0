Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3836BFB7B
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 17:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCRQSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 12:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCRQST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 12:18:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14092241CD
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 09:18:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3DF2B8087F
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 16:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E6DC433EF;
        Sat, 18 Mar 2023 16:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679156294;
        bh=0sp9nB8WMIYFymL5QG9kFHYSPgsej4USJc3ZonvqLWY=;
        h=Subject:From:To:Cc:Date:From;
        b=N81DMfKXGoeySmf0coLHzirxMj9zRk1PjJE6ttFHplT+1p0C478GpGAh3khXIdtAA
         zmiX4mKkSOq3pVXZ/rKX/teYo//f7vW5g9mC1ameFaxP5fY3QMSUHRuNIrcLdjYz6q
         Nh3q7LM5fNqoaXjDuzTq63sJVGRr5NVaOtiROukkC3zCd008DfGmZAfcwpVhDsNRNH
         hQVNcHCvK+uLctGhWVR98Ug2SNV3D/NJljEZ8Rj9CMmo6XjeUPqV6rcBZoAAvjJKQ2
         X29bxgrQesO9K+UiSewWq49iO5D6vgi13pqRnxcaawidQK3NY2V4gnk+9YsxHFuyh8
         sNm+QzsevFONA==
Subject: [PATCH v7 0/2] Another crack at a handshake upcall mechanism
From:   Chuck Lever <cel@kernel.org>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
        john.haxby@oracle.com
Date:   Sat, 18 Mar 2023 12:18:12 -0400
Message-ID: <167915594811.91792.15722842400657376706.stgit@manet.1015granger.net>
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

Here is v7 of a series to add generic support for transport layer
security handshake on behalf of kernel socket consumers (user space
consumers use a security library directly, of course). A summary of
the purpose of these patches is archived here:

https://lore.kernel.org/netdev/1DE06BB1-6BA9-4DB4-B2AA-07DE532963D6@oracle.com/

v7 again has considerable churn, for two reasons:

- I incorporated more C code generated from the YAML spec, and
- I moved net/tls/tls_handshake.c to net/handshake/

Other significant changes are listed below.

The full patch set to support SunRPC with TLSv1.3 is available in
the topic-rpc-with-tls-upcall branch here, based on net-next/main:

https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git

This patch set includes support for in-transit confidentiality and
peer authentication for both the Linux NFS client and server.

A user space handshake agent for TLSv1.3 to go along with the kernel
patches is available in the "netlink-v7" branch here:

https://github.com/oracle/ktls-utils

---

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

Chuck Lever (2):
      net/handshake: Create a NETLINK service for handling handshake requests
      net/tls: Add kernel APIs for requesting a TLSv1.3 handshake


 Documentation/netlink/specs/handshake.yaml | 124 ++++++
 Documentation/networking/index.rst         |   1 +
 Documentation/networking/tls-handshake.rst | 217 +++++++++++
 MAINTAINERS                                |  10 +
 include/net/handshake.h                    |  43 +++
 include/trace/events/handshake.h           | 159 ++++++++
 include/uapi/linux/handshake.h             |  72 ++++
 net/Kconfig                                |   5 +
 net/Makefile                               |   1 +
 net/handshake/Makefile                     |  11 +
 net/handshake/genl.c                       |  58 +++
 net/handshake/genl.h                       |  24 ++
 net/handshake/handshake.h                  |  82 ++++
 net/handshake/netlink.c                    | 316 ++++++++++++++++
 net/handshake/request.c                    | 307 +++++++++++++++
 net/handshake/tlshd.c                      | 417 +++++++++++++++++++++
 net/handshake/trace.c                      |  20 +
 17 files changed, 1867 insertions(+)
 create mode 100644 Documentation/netlink/specs/handshake.yaml
 create mode 100644 Documentation/networking/tls-handshake.rst
 create mode 100644 include/net/handshake.h
 create mode 100644 include/trace/events/handshake.h
 create mode 100644 include/uapi/linux/handshake.h
 create mode 100644 net/handshake/Makefile
 create mode 100644 net/handshake/genl.c
 create mode 100644 net/handshake/genl.h
 create mode 100644 net/handshake/handshake.h
 create mode 100644 net/handshake/netlink.c
 create mode 100644 net/handshake/request.c
 create mode 100644 net/handshake/tlshd.c
 create mode 100644 net/handshake/trace.c

--
Chuck Lever

