Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828B467D0D0
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbjAZQCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbjAZQCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:02:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AFE45BD7
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:02:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D1E2618AC
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E964EC433EF;
        Thu, 26 Jan 2023 16:02:09 +0000 (UTC)
Subject: [PATCH v2 0/3] Another crack at a handshake upcall mechanism
From:   Chuck Lever <chuck.lever@oracle.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        kolga@netapp.com, jmeneghi@redhat.com, bcodding@redhat.com,
        jlayton@redhat.com
Date:   Thu, 26 Jan 2023 11:02:08 -0500
Message-ID: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub-

Second version of a hybrid listen/accept/netlink upcall mechanism.
This one tries to address a few more of your requests from last
year, and it introduces support for basic server-side upcalls.

These patches are the netdev piece only. The full series, which adds
client and server RPC-with-TLS implementations, can be found in the
topic-rpc-with-tls-upcall branch here:

https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git

The third patch below demonstrates how to set up handshake support
for a kernel transport security layer protocol by adding handshake
support to kTLS.

A sample user space handshake daemon is available here:

   https://github.com/oracle/ktls-utils

The "main" branch contains the latest changes that are required to
operate with the kernel patches presented in this email.

---

Changes since RFC:
- Documentation temporarily removed while code churns
- Split the handshake mechanism away from kTLS
- Added a default TLS priorities string
- Added support for ServerHello

Chuck Lever (3):
      net: Add an AF_HANDSHAKE address family
      net/handshake: Add support for PF_HANDSHAKE
      net/tls: Support AF_HANDSHAKE in kTLS


 include/linux/socket.h                        |   4 +-
 include/net/handshake.h                       |  31 +
 include/net/sock.h                            |   2 +
 include/net/tls.h                             |  16 +
 include/trace/events/handshake.h              | 328 +++++++
 include/uapi/linux/handshake.h                |  73 ++
 net/Makefile                                  |   1 +
 net/core/sock.c                               |   2 +-
 net/handshake/Makefile                        |   7 +
 net/handshake/af_handshake.c                  | 838 ++++++++++++++++++
 net/handshake/handshake.h                     |  33 +
 net/handshake/netlink.c                       | 187 ++++
 net/handshake/trace.c                         |  20 +
 net/socket.c                                  |   1 +
 net/tls/Makefile                              |   2 +-
 net/tls/tls_handshake.c                       | 385 ++++++++
 security/selinux/hooks.c                      |   4 +-
 security/selinux/include/classmap.h           |   4 +-
 .../perf/trace/beauty/include/linux/socket.h  |   4 +-
 19 files changed, 1936 insertions(+), 6 deletions(-)
 create mode 100644 include/net/handshake.h
 create mode 100644 include/trace/events/handshake.h
 create mode 100644 include/uapi/linux/handshake.h
 create mode 100644 net/handshake/Makefile
 create mode 100644 net/handshake/af_handshake.c
 create mode 100644 net/handshake/handshake.h
 create mode 100644 net/handshake/netlink.c
 create mode 100644 net/handshake/trace.c
 create mode 100644 net/tls/tls_handshake.c

--
Chuck Lever

