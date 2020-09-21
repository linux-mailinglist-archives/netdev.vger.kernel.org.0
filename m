Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98C7272365
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgIUMNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgIUMNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 08:13:16 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F76C0613CF
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:16 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l15so11338190wmh.1
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=53WhTmXREjGqlEXM0BLaZc51eAV3CGtA+VHhtiGHfTs=;
        b=BeY1St9bX8a68dzI8DyEQHNenRoMPJRXDOBWiB1pYCbDQ41MSwnWdfjYvCeWKe6o2a
         1zmH7Vxes1S506P3pUsHTKChEY7VsxdzNDM1b2D3iphKlpDTIDpC5oA4yd0xt/4xXE09
         6ohwFM2P2D9tfJRHqN89mdB8I/aKfeLHZerOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=53WhTmXREjGqlEXM0BLaZc51eAV3CGtA+VHhtiGHfTs=;
        b=kFKyd88Ky3yoLj9VYUfaTEyLY4v4VWvcDt2XOaO8CVdAHdDYC2dPx4hhhUFqcg1pmr
         OpIagwudTxB12TS4Fep6NuYgA8DAIbcbWRcBidC//M4xfL4BUeFhig981s02VIyR4p31
         OIFijiWNgaCAfFZVk7mpRNZPQZ13rBZaGu3AEt0rxDzyGFNibF+d307jf/s/KOv8fPvP
         3n8b3p9pybzgYfzcyUKF83ErnNIY24o2IdLjhJfL0iYaOFxWQURkqrDFrQTu5dqPBKDu
         9LYRnPST2B3hV80jhHUcCWFjUELa+xI16enLoJSk5m/KdN4SgUnrFCXba2j4o5FvnEv0
         UGEA==
X-Gm-Message-State: AOAM5317lueWcNgtGnx18bdWRFSch0WacG98BGrOJfr03mHN7eArAWzI
        JYsRgpreVUfk8WkmHcf/HZnBAtcgdE8ZUw==
X-Google-Smtp-Source: ABdhPJyVYez7NJ5qwpelifySbPRVulkQktg9kr5/8tS8hp90rV6JWtUi0IxOtxfZz6FKb4SfzzVtJA==
X-Received: by 2002:a05:600c:283:: with SMTP id 3mr30671872wmk.110.1600690394707;
        Mon, 21 Sep 2020 05:13:14 -0700 (PDT)
Received: from antares.lan (5.4.6.2.d.5.3.3.f.8.1.6.b.2.d.8.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:8d2b:618f:335d:2645])
        by smtp.gmail.com with ESMTPSA id t15sm18466557wmj.15.2020.09.21.05.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 05:13:13 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH RESEND bpf-next v4 00/11] Make check_func_arg type checks table driven
Date:   Mon, 21 Sep 2020 13:12:16 +0100
Message-Id: <20200921121227.255763-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm not sure why, but I missed sending the patchset to netdev@ last
week. I guess that is why it's slipped through the cracks.

Changes in v4:
- Output the desired type on BTF ID mismatch (Martin)

Changes in v3:
- Fix BTF_ID_LIST_SINGLE if BTF is disabled (Martin)
- Drop incorrect arg_btf_id in bpf_sk_storage.c (Martin)
- Check for arg_btf_id in check_func_proto (Martin)
- Drop incorrect PTR_TO_BTF_ID from fullsock_types (Martin)
- Introduce btf_seq_file_ids in bpf_trace.c to reduce duplication

Changes in v2:
- Make the series stand alone (Martin)
- Drop incorrect BTF_SET_START fix (Andrii)
- Only support a single BTF ID per argument (Martin)
- Introduce BTF_ID_LIST_SINGLE macro (Andrii)
- Skip check_ctx_reg iff register is NULL
- Change output of check_reg_type slightly, to avoid touching tests

Original cover letter:

Currently, check_func_arg has this pretty gnarly if statement that
compares the valid arg_type with the actualy reg_type. Sprinkled
in-between are checks for register_is_null, to short circuit these
tests if we're dealing with a nullable arg_type. There is also some
code for later bounds / access checking hidden away in there.

This series of patches refactors the function into something like this:

   if (reg_is_null && arg_type_is_nullable)
     skip type checking

   do type checking, including BTF validation

   do bounds / access checking

The type checking is now table driven, which makes it easy to extend
the acceptable types. Maybe more importantly, using a table makes it
easy to provide more helpful verifier output (see the last patch).

Lorenz Bauer (11):
  btf: make btf_set_contains take a const pointer
  bpf: check scalar or invalid register in check_helper_mem_access
  btf: Add BTF_ID_LIST_SINGLE macro
  bpf: allow specifying a BTF ID per argument in function protos
  bpf: make BTF pointer type checking generic
  bpf: make reference tracking generic
  bpf: make context access check generic
  bpf: set meta->raw_mode for pointers close to use
  bpf: check ARG_PTR_TO_SPINLOCK register type in check_func_arg
  bpf: hoist type checking for nullable arg types
  bpf: use a table to drive helper arg type checks

 include/linux/bpf.h            |  21 +-
 include/linux/btf_ids.h        |   8 +
 kernel/bpf/bpf_inode_storage.c |   8 +-
 kernel/bpf/btf.c               |  15 +-
 kernel/bpf/stackmap.c          |   5 +-
 kernel/bpf/verifier.c          | 338 ++++++++++++++++++---------------
 kernel/trace/bpf_trace.c       |  15 +-
 net/core/bpf_sk_storage.c      |   8 +-
 net/core/filter.c              |  31 +--
 net/ipv4/bpf_tcp_ca.c          |  19 +-
 tools/include/linux/btf_ids.h  |   8 +
 11 files changed, 239 insertions(+), 237 deletions(-)

-- 
2.25.1

