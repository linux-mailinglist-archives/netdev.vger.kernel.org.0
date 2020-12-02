Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18F32CBAB5
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 11:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729488AbgLBKkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 05:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgLBKkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 05:40:08 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE9CC0613D4;
        Wed,  2 Dec 2020 02:39:28 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id s30so3793737lfc.4;
        Wed, 02 Dec 2020 02:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rmi5uoHn4FiDE0+Jf3x4dz0BuGjH/Co3mzu066ynub8=;
        b=owLVngT84dhH3qUVnYK2B5R1buqFjDeL8JxqlglxIrBjOuKBcgWxuEMh7XVd/BxZ6l
         9HCCSOPiu8sx4kz5Ax61J32lvUvGw3Pk3RmoZu7VFwg7+1hZKpZ39BcERBJGd4v6Da5z
         /3JSOH/VsZbQ3w2BpzJztZ03R1HYEmk4T8nYwYJCjJN1bgo9WNtJm0vS+0s16+BiAZu/
         1GoFnVDlE1d27Tdyb+Yb6tInsJJCJXcFFm/6UYHWpsHwei1O+72oKAzBnYeVgJlOlDY0
         3cgOl055IeXjkOSVfDZ+9pIJSoVbRskgA2isULchLW8K7zdYaGGcBIHIGzBKn7dvZAnE
         3dnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rmi5uoHn4FiDE0+Jf3x4dz0BuGjH/Co3mzu066ynub8=;
        b=qEQD+ZzwublQBG2vhP0qwu9qvh6K9M1eP7fjRsnr8OqahG7wgmsvKA9ETBnRWwATXS
         4FBd8ue+oyjTrn7WFlpxhqNs42sGlh5UZFNrvqz7xQ5JGZUFyVxKhLw5UrzkmlwVqYRR
         SIuJh6AnjmUM/iMKPGSB4P7o2hlj88qHD7P3/m/mukDCdEFKQ+nwKijhIofMNCqErPRs
         zNDRxNiZ4HdMv3DmjGfesMrRrm2+WbmjLi9WMMSVQzv/RrQjtP2M4gFnObPqVtlqbTjy
         KJM5zjvpl18vGvfUVZ/cRDqfF0D242Z6eq/wB1w7sBmFR1BdeoTm+p2Wa9Egny+MVxi9
         vlAA==
X-Gm-Message-State: AOAM5324+khVriE7/+TXMMAaVfkcIC5sO15GiyhyInXb+SNlaAOhWMNk
        X6LPiAcxHaQU3g0isa4q15ydp5FJpn5TjWeB
X-Google-Smtp-Source: ABdhPJzgRFyFirLqr+NfTd668cgoGXYwiQx1doh3xF0KPe0OyMxy4Pi1zcOrNNKOttutPDjpn3Vo7w==
X-Received: by 2002:a05:6512:3048:: with SMTP id b8mr987245lfb.421.1606905566716;
        Wed, 02 Dec 2020 02:39:26 -0800 (PST)
Received: from localhost.localdomain (host-89-229-233-64.dynamic.mm.pl. [89.229.233.64])
        by smtp.gmail.com with ESMTPSA id q13sm354236lfp.2.2020.12.02.02.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 02:39:26 -0800 (PST)
From:   mariusz.dudek@gmail.com
X-Google-Original-From: mariuszx.dudek@intel.com
To:     andrii.nakryiko@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, Mariusz Dudek <mariuszx.dudek@intel.com>
Subject: [PATCH v6 bpf-next 0/2] libbpf: add support for privileged/unprivileged control separation
Date:   Wed,  2 Dec 2020 11:39:21 +0100
Message-Id: <20201202103923.12447-1-mariuszx.dudek@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mariusz Dudek <mariuszx.dudek@intel.com>

This patch series adds support for separation of eBPF program
load and xsk socket creation. In for example a Kubernetes
environment you can have an AF_XDP CNI or daemonset that is 
responsible for launching pods that execute an application 
using AF_XDP sockets. It is desirable that the pod runs with
as low privileges as possible, CAP_NET_RAW in this case, 
and that all operations that require privileges are contained
in the CNI or daemonset.
	
In this case, you have to be able separate ePBF program load from
xsk socket creation.

Currently, this will not work with the xsk_socket__create APIs
because you need to have CAP_NET_ADMIN privileges to load eBPF
program and CAP_SYS_ADMIN privileges to create update xsk_bpf_maps.
To be exact xsk_set_bpf_maps does not need those privileges but
it takes the prog_fd and xsks_map_fd and those are known only to
process that was loading eBPF program. The api bpf_prog_get_fd_by_id
that looks up the fd of the prog using an prog_id and
bpf_map_get_fd_by_id that looks for xsks_map_fd usinb map_id both
requires CAP_SYS_ADMIN.

With this patch, the pod can be run with CAP_NET_RAW capability
only. In case your umem is larger or equal process limit for
MEMLOCK you need either increase the limit or CAP_IPC_LOCK capability. 
Without this patch in case of insufficient rights ENOPERM is
returned by xsk_socket__create.

To resolve this privileges issue two new APIs are introduced:
- xsk_setup_xdp_prog - loads the built in XDP program. It can
also return xsks_map_fd which is needed by unprivileged
process to update xsks_map with AF_XDP socket "fd"
- xsk_sokcet__update_xskmap - inserts an AF_XDP socket into an
xskmap for a particular xsk_socket

Usage example:
int xsk_setup_xdp_prog(int ifindex, int *xsks_map_fd)

int xsk_socket__update_xskmap(struct xsk_socket *xsk, int xsks_map_fd);

Inserts AF_XDP socket "fd" into the xskmap.

The first patch introduces the new APIs. The second patch provides
a new sample applications working as control and modification to
existing xdpsock application to work with less privileges.

This patch set is based on bpf-next commit ba0581749fec
(net, xdp, xsk: fix __sk_mark_napi_id_once napi_id error)

Since v5
- fixed sample/bpf/xdpsock_user.c to resolve merge conflicts

Since v4
- sample/bpf/Makefile issues fixed

Since v3:
- force_set_map flag removed
- leaking of xsk struct fixed
- unified function error returning policy implemented

Since v2:
- new APIs moved itto LIBBPF_0.3.0 section
- struct bpf_prog_cfg_opts removed 
- loading own eBPF program via xsk_setup_xdp_prog functionality removed

Since v1:
- struct bpf_prog_cfg improved for backward/forward compatibility
- API xsk_update_xskmap renamed to xsk_socket__update_xskmap
- commit message formatting fixed

Mariusz Dudek (2):
  libbpf: separate XDP program load with xsk socket creation
  samples/bpf: sample application for eBPF load and socket creation
    split

 samples/bpf/Makefile            |   4 +-
 samples/bpf/xdpsock.h           |   8 ++
 samples/bpf/xdpsock_ctrl_proc.c | 187 ++++++++++++++++++++++++++++++++
 samples/bpf/xdpsock_user.c      | 146 +++++++++++++++++++++++--
 tools/lib/bpf/libbpf.map        |   2 +
 tools/lib/bpf/xsk.c             |  92 ++++++++++++++--
 tools/lib/bpf/xsk.h             |   5 +
 7 files changed, 425 insertions(+), 19 deletions(-)
 create mode 100644 samples/bpf/xdpsock_ctrl_proc.c

-- 
2.20.1

