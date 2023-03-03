Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF186A9F8F
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 19:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjCCSv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 13:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjCCSv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 13:51:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF053595
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 10:51:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9335618C4
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 18:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B226CC433D2;
        Fri,  3 Mar 2023 18:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677869486;
        bh=PeTm9K2ENSvWhMsJWkB/4kYIZli70PVBGxGg8gctn7Y=;
        h=Subject:From:To:Cc:Date:From;
        b=Ni04ldu2NH2Ju/+gqXrjbwQ9Myjglpjn5MpG0klTxS4AIceMYNzVn+j67/P4rz82L
         KzWRHjoJKRze3mzh9uD2xSzhnXW7OGtdpCWvJfSz4zkcqcHM/YdlyTLYqYVIMz3hWA
         /131aPp4cqSEJR0T9eV1rmp24zwHeGY6q6+x8TYmo/3GpkbWc0rjB35qGimgiZGsH0
         0Xbk2tdoPtQWIbZ+w5T7SDPNXcQuYOo6zmZHdJi4IeZYAdgootpZZxKAe/7WEDlcNE
         biOemTUr44bi3CidaZw0M8ha+qOUmHldVFhUDbgLB8UzL3VZeYlSwLjZd4sLEqkoJX
         TH8DUrARvnaqg==
Subject: [PATCH v6 0/2] Another crack at a handshake upcall mechanism
From:   Chuck Lever <cel@kernel.org>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
        john.haxby@oracle.com
Date:   Fri, 03 Mar 2023 13:51:24 -0500
Message-ID: <167786872946.7199.12490725847535629441.stgit@91.116.238.104.host.secureserver.net>
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

Here is v6 of a series to add generic support for transport layer
security handshake on behalf of kernel socket consumers (user space
consumers use a security library directly, of course). A summary of
the purpose of these patches is archived here:

https://lore.kernel.org/netdev/1DE06BB1-6BA9-4DB4-B2AA-07DE532963D6@oracle.com/

For v6, I've simplified the kernel TLS consumer API and added a few
new attributes to the handshake netlink protocol. Also featured is
the use of keyrings to restrict access to keying material. The
consumer TLS API documentation has been updated to reflect these
changes. This version also contains numerous bugfixes.

The full patch set to support SunRPC with TLSv1.3 is available in
the topic-rpc-with-tls-upcall branch here, based on net-next/main:

 https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git

A user space handshake agent for TLSv1.3 to go along with the kernel
patches is available in the "netlink" branch here:

 https://github.com/oracle/ktls-utils

---

Changes since v5:
- Added a "timeout" attribute to the handshake netlink protocol
- Removed the GnuTLS-specific "priorities" attribute
- Added support for keyrings to restrict access to keys
- Simplified the kernel consumer TLS handshake API
- The handshake netlink protocol can handle multiple peer IDs or
  certificates in the ACCEPT and DONE operations, though the
  implementation does not yet support it.

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


 Documentation/netlink/specs/handshake.yaml | 139 ++++++++
 Documentation/networking/index.rst         |   1 +
 Documentation/networking/tls-handshake.rst | 219 ++++++++++++
 include/net/handshake.h                    |  46 +++
 include/net/net_namespace.h                |   5 +
 include/net/sock.h                         |   1 +
 include/net/tls.h                          |  29 ++
 include/trace/events/handshake.h           | 159 +++++++++
 include/uapi/linux/handshake.h             |  73 ++++
 net/Makefile                               |   1 +
 net/handshake/Makefile                     |  11 +
 net/handshake/handshake.h                  |  41 +++
 net/handshake/netlink.c                    | 346 ++++++++++++++++++
 net/handshake/request.c                    | 246 +++++++++++++
 net/handshake/trace.c                      |  17 +
 net/tls/Makefile                           |   2 +-
 net/tls/tls_handshake.c                    | 391 +++++++++++++++++++++
 17 files changed, 1726 insertions(+), 1 deletion(-)
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

