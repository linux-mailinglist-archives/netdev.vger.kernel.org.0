Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D061C505CAE
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346423AbiDRQwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239529AbiDRQwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:52:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61281329BE;
        Mon, 18 Apr 2022 09:49:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2ECC612DF;
        Mon, 18 Apr 2022 16:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0057C385A1;
        Mon, 18 Apr 2022 16:49:23 +0000 (UTC)
Subject: [PATCH RFC 0/5] Implement a TLS handshake upcall
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:49:22 -0400
Message-ID: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few upper-layer (storage) protocols that want to have a
full TLS implementation available in the Linux kernel.

The Linux kernel currently has an implementation of the TLS record
protocol, known as kTLS. However it does not have a complete TLS
implementation because it has no implementation of the TLS handshake
protocol. In-kernel storage protocols need both to use TLS properly.

In the long run, our preference is to have a TLS handshake
implementation in the kernel. However, it appears that would take a
long time and there is some desire to avoid adding to the Linux
kernel's "attack surface" without good reasons. So in the meantime
we've created a prototype handshake implementation that calls out to
user space where the actual handshake can be done by an existing
library implementation of TLS.

The prototype serves several purposes, including:

- Proof of concept: can a handshake upcall actually be implemented?

- Scaffold to enable prototyping upper-layer protocol support for TLS:
  Is there any demand for in-kernel TLS?

- Performance impact of always-on encryption with both software and
  hardware kTLS

- Understanding what features, if any, an upcall handshake cannot
  provide

The prototype currently supports client-side PSK and anonymous
x.509 ClientHello. We would like some feedback on the approach
before proceeding with ServerHello and mutual x.509 authentication.


User agent: https://github.com/oracle/ktls-utils

Who will use this implementation?
--------------------------------

This series implements only the upcall. I plan to post a second
series that shows how it can be used to implement the RPC-with-TlS
standard: https://datatracker.ietf.org/doc/draft-ietf-nfsv4-rpc-tls/

https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git topic-rpc-with-tls

Dr. Hannes Reinecke has a series that implements NVMe-TLS here:

https://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git tls-upcall.v4

We are also working with a few developers in the CIFS community
who are interested in SMB-over-QUIC. QUICv1 (RFC 9000) uses the
TLSv1.3 handshake protocol, and we hope they can leverage this
prototype capability when QUIC comes to the Linux kernel.

---

Chuck Lever (4):
      net: Add distinct sk_psock field
      net/tls: Add an AF_TLSH address family
      net/tls: Add support for PF_TLSH (a TLS handshake listener)
      net/tls: Add observability for AF_TLSH sockets

Hannes Reinecke (1):
      tls: build proto after context has been initialized


 .../networking/tls-in-kernel-handshake.rst    |  103 ++
 include/linux/skmsg.h                         |    2 +-
 include/linux/socket.h                        |    5 +-
 include/net/sock.h                            |    7 +-
 include/net/tls.h                             |   15 +
 include/net/tlsh.h                            |   22 +
 include/uapi/linux/tls.h                      |   16 +
 net/core/skmsg.c                              |    6 +-
 net/core/sock.c                               |    4 +-
 net/socket.c                                  |    1 +
 net/tls/Makefile                              |    2 +-
 net/tls/af_tlsh.c                             | 1078 +++++++++++++++++
 net/tls/tls_main.c                            |   13 +-
 net/tls/trace.c                               |    3 +
 net/tls/trace.h                               |  355 ++++++
 security/selinux/hooks.c                      |    4 +-
 security/selinux/include/classmap.h           |    4 +-
 .../perf/trace/beauty/include/linux/socket.h  |    4 +-
 18 files changed, 1631 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/networking/tls-in-kernel-handshake.rst
 create mode 100644 include/net/tlsh.h
 create mode 100644 net/tls/af_tlsh.c

--
Chuck Lever

