Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0270468E312
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 22:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBGVlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 16:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBGVlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 16:41:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE2F210A
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 13:41:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B93A6123D
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 21:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3C0C433D2;
        Tue,  7 Feb 2023 21:41:07 +0000 (UTC)
Subject: [PATCH v3 0/2] Another crack at a handshake upcall mechanism
From:   Chuck Lever <chuck.lever@oracle.com>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        bcodding@redhat.com, kolga@netapp.com, jmeneghi@redhat.com
Date:   Tue, 07 Feb 2023 16:41:05 -0500
Message-ID: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi-

Here is v3 of a series to add generic support for transport layer
security handshake on behalf of kernel consumers (user space
consumers use a security library directly, of course).

This version of the series does away with the listen/poll/accept/
close design and replaces it with a full netlink implementation
that handles much of the same function.

The first patch in the series adds a new netlink family to handle
the kernel-user space interaction to request a handshake. The second
patch demonstrates how to extend this new mechanism to support a
particular transport layer security protocol (in this case,
TLSv1.3).

Of particular interest is that the user space handshake agent now
must perform a second downcall when the handshake is complete,
rather than simply closing the socket descriptor. This enables the
user space agent to pass down a session status, whether the session
was mutually authenticated, and the identity of the remote peer.
(Although these facilities are plumbed into the netlink protocol,
they have yet to be fully implemented by the kernel or the sample
user space agent below).

Certificates and pre-shared keys are made available to the user
space agent via keyrings, or the agent can use authentication
materials residing in the local filesystem.

The full patch set to support SunRPC with TLSv1.3 is available in
the topic-rpc-with-tls-upcall branch here, based on v6.1.10:

   https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git

A sample user space handshake agent with netlink support is
available in the "netlink" branch here:

   https://github.com/oracle/ktls-utils

---

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

Chuck Lever (2):
      net/handshake: Create a NETLINK service for handling handshake requests
      net/tls: Support AF_HANDSHAKE in kTLS

The use of AF_HANDSHAKE in the short description here is stale. I'll
fix that in a subsequent posting.

 include/net/handshake.h            |  37 ++
 include/net/net_namespace.h        |   1 +
 include/net/sock.h                 |   1 +
 include/net/tls.h                  |  16 +
 include/uapi/linux/handshake.h     |  95 +++++
 include/uapi/linux/netlink.h       |   1 +
 net/Makefile                       |   1 +
 net/handshake/Makefile             |  11 +
 net/handshake/netlink.c            | 320 ++++++++++++++++
 net/tls/Makefile                   |   2 +-
 net/tls/tls_handshake.c            | 583 +++++++++++++++++++++++++++++
 tools/include/uapi/linux/netlink.h |   1 +
 12 files changed, 1068 insertions(+), 1 deletion(-)
 create mode 100644 include/net/handshake.h
 create mode 100644 include/uapi/linux/handshake.h
 create mode 100644 net/handshake/Makefile
 create mode 100644 net/handshake/netlink.c
 create mode 100644 net/tls/tls_handshake.c

--
Chuck Lever

