Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B1C66E8B4
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 22:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjAQVq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 16:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjAQVoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 16:44:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9DE70C4C
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 12:07:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0E1D6153B
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 20:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FFDC433EF;
        Tue, 17 Jan 2023 20:07:56 +0000 (UTC)
Subject: [PATCH RFC 0/3] Another crack at a handshake upcall mechanism
From:   Chuck Lever <chuck.lever@oracle.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        kolga@netapp.com, jmeneghi@redhat.com
Date:   Tue, 17 Jan 2023 15:07:55 -0500
Message-ID: <167398534919.5631.3008767788631058826.stgit@91.116.238.104.host.secureserver.net>
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

I've addressed the thing you liked least about last year's handshake
upcall attempt: gathering the handshake parameters from socket
options. That is now done instead via a generic netlink service.
I'm a rank netlink amateur, so any guidance there is helpful.

Probably the next step is to divorce AF_TLSH from net/tls and make
it general so that other security protocols can make use of it.

A sample user space handshake daemon is available here:

   https://github.com/oracle/ktls-utils

The "main" branch has patches that add a netlink client to replace
the use of getsockopt(3).

---

Chuck Lever (3):
      net/tls: Add an AF_TLSH address family
      net/tls: Add support for PF_TLSH (a TLS handshake listener)
      net/tls: Create a fixed TLS handshake API


 Documentation/networking/index.rst            |    1 +
 .../networking/tls-in-kernel-handshake.rst    |  123 ++
 include/linux/socket.h                        |    4 +-
 include/net/sock.h                            |    3 +
 include/net/tls.h                             |   12 +
 include/net/tlsh.h                            |   25 +
 include/uapi/linux/tls.h                      |   43 +
 net/core/sock.c                               |    4 +-
 net/socket.c                                  |    1 +
 net/tls/Makefile                              |    3 +-
 net/tls/af_tlsh.c                             | 1266 +++++++++++++++++
 net/tls/tls.h                                 |   15 +
 net/tls/tls_handshake.c                       |   89 ++
 net/tls/tls_main.c                            |   19 +-
 net/tls/trace.c                               |    3 +
 net/tls/trace.h                               |  341 +++++
 security/selinux/hooks.c                      |    4 +-
 security/selinux/include/classmap.h           |    4 +-
 .../perf/trace/beauty/include/linux/socket.h  |    4 +-
 19 files changed, 1957 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/networking/tls-in-kernel-handshake.rst
 create mode 100644 include/net/tlsh.h
 create mode 100644 net/tls/af_tlsh.c
 create mode 100644 net/tls/tls_handshake.c

--
Chuck Lever

