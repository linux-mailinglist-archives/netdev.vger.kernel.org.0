Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F95505CCC
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346542AbiDRQx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346468AbiDRQxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:53:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2FB32EF9;
        Mon, 18 Apr 2022 09:51:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9195612FB;
        Mon, 18 Apr 2022 16:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5068C385A7;
        Mon, 18 Apr 2022 16:51:07 +0000 (UTC)
Subject: [PATCH RFC 00/15] Prototype implementation of RPC-with-TLS
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:51:06 -0400
Message-ID: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
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

This series implements RPC-with-TLS in the Linux kernel:

https://datatracker.ietf.org/doc/draft-ietf-nfsv4-rpc-tls/

This prototype is based on the previously posted mechanism for
providing a TLS handshake facility to in-kernel TLS consumers.

For the purpose of demonstration, the Linux NFS client is modified
to add a new mount option: xprtsec = [ none|auto|tls ] . Updates
to the nfs(5) man page are being developed separately.

The new mount option enables client administrators to require in-
transit encryption for their NFS traffic, protecting the weak
security of AUTH_SYS. An x.509 certificate is not required on the
client for this protection.

This prototype has been tested against prototype TLS-capable NFS
servers. The Linux NFS server itself does not yet have support for
RPC-with-TLS, but it is planned.

At a later time, the Linux NFS client will also get support for
x.509 authentication (for which a certificate will be required on
the client) and PSK. For this demonstration, only authentication-
less TLS (encryption-only) is supported.

---

Chuck Lever (15):
      SUNRPC: Replace dprintk() call site in xs_data_ready
      SUNRPC: Ignore data_ready callbacks during TLS handshakes
      SUNRPC: Capture cmsg metadata on client-side receive
      SUNRPC: Fail faster on bad verifier
      SUNRPC: Widen rpc_task::tk_flags
      SUNRPC: Add RPC client support for the RPC_AUTH_TLS authentication flavor
      SUNRPC: Refactor rpc_call_null_helper()
      SUNRPC: Add RPC_TASK_CORK flag
      SUNRPC: Add a cl_xprtsec_policy field
      SUNRPC: Expose TLS policy via the rpc_create() API
      SUNRPC: Add infrastructure for async RPC_AUTH_TLS probe
      SUNRPC: Add FSM machinery to handle RPC_AUTH_TLS on reconnect
      NFS: Replace fs_context-related dprintk() call sites with tracepoints
      NFS: Have struct nfs_client carry a TLS policy field
      NFS: Add an "xprtsec=" NFS mount option


 fs/nfs/client.c                 |  22 ++++
 fs/nfs/fs_context.c             |  70 ++++++++--
 fs/nfs/internal.h               |   2 +
 fs/nfs/nfs3client.c             |   1 +
 fs/nfs/nfs4client.c             |  16 ++-
 fs/nfs/nfstrace.h               |  77 +++++++++++
 fs/nfs/super.c                  |  10 ++
 include/linux/nfs_fs_sb.h       |   7 +-
 include/linux/sunrpc/auth.h     |   1 +
 include/linux/sunrpc/clnt.h     |  14 +-
 include/linux/sunrpc/sched.h    |  36 +++---
 include/linux/sunrpc/xprt.h     |  14 ++
 include/linux/sunrpc/xprtsock.h |   2 +
 include/net/tls.h               |   2 +
 include/trace/events/sunrpc.h   | 157 ++++++++++++++++++++--
 net/sunrpc/Makefile             |   2 +-
 net/sunrpc/auth.c               |   2 +
 net/sunrpc/auth_tls.c           | 117 +++++++++++++++++
 net/sunrpc/clnt.c               | 222 +++++++++++++++++++++++++++++---
 net/sunrpc/debugfs.c            |   2 +-
 net/sunrpc/xprt.c               |   3 +
 net/sunrpc/xprtsock.c           | 211 +++++++++++++++++++++++++++++-
 22 files changed, 920 insertions(+), 70 deletions(-)
 create mode 100644 net/sunrpc/auth_tls.c

--
Chuck Lever

