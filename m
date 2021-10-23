Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEF7438569
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 22:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhJWUy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 16:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhJWUyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 16:54:21 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1758CC061764
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 13:52:02 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d3so466278wrh.8
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 13:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AaRP1yAQcBg5RKINDiXstAs+5xph0D/DaEzHGq5RVU8=;
        b=3QfHMzTQK0ah4FrP5siqtXuK2B46dd+mQsYWH+pkr3hCsRJRsAWLCWo974DCKpmAVG
         cXeEQu9eGwvh+LfkUXEeOjltQcG+2YVgD+bxG1QG+r0VK24Uh7O0qdjUGyU199gXe/jr
         Zu2WGcZFwfswZcrzWBO9CD9FnNz4VRzX5bkKgCNJpCyfTIoGdYNR84pJd/PEJxx0V7XO
         fJBCzoOH9/LwJ5/1rRaDNrA+stZgt1cJUucKcZAN4zPRpe+4jtLY4T9xWfgeSkNX8+P4
         BbHw4m1RzbRqWVSI4fXbpuPIe2yjJZNsg/ZSndRpDyrcOz1qhX9SMI3UMRnKrGLfXb+W
         x+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AaRP1yAQcBg5RKINDiXstAs+5xph0D/DaEzHGq5RVU8=;
        b=ktV3ECCFdmppYYZIPAVUy/O/QBMLXHvHED92SGwWp9J/m4PuOa4vcGNeYxQuuhqudA
         7lSFnENYYHCknZood2CwCo8P/dqtrzTMvKLEGgSFo3xDctlLCuKJG0XtMg+asSI9xfis
         fRGvKucw6FNf1UCR0W9m0xy9R9NdD5FdPH5An/te/T+t9NlPMnpxrLHh2fQHGKVt8Isx
         qzGfFreunFmOW2PYofpGl9WG0Q9nqxoeossAC2tYidXexFJeDim8h49xctfxnV3IjrmS
         dHSTKI7YhXoPqeezwuC3bfPOSaKdmwIVw/TvhYJ1B1YOCohnP6FylO1OuSoN915ugmS0
         tfdg==
X-Gm-Message-State: AOAM531kPZoKABcfa4uc+n7MaTo+HEQQbMQaGRcNHLtKcBBoVqO0re/0
        rArSisWiYpBqh9Tq0afwxKUdEg==
X-Google-Smtp-Source: ABdhPJw/+1ApVlFhPuytPu69ePYgfQLDPEd94hMT6Yh5y1YqKFX3kZBMBRxe7+J6igZ9axVkwYtmaw==
X-Received: by 2002:a5d:67cd:: with SMTP id n13mr10189971wrw.86.1635022320741;
        Sat, 23 Oct 2021 13:52:00 -0700 (PDT)
Received: from localhost.localdomain ([149.86.74.50])
        by smtp.gmail.com with ESMTPSA id u16sm13555398wmc.21.2021.10.23.13.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 13:52:00 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 0/5] bpftool: Switch to libbpf's hashmap for referencing BPF objects
Date:   Sat, 23 Oct 2021 21:51:49 +0100
Message-Id: <20211023205154.6710-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When listing BPF objects, bpftool can print a number of properties about
items holding references to these objects. For example, it can show pinned
paths for BPF programs, maps, and links; or programs and maps using a given
BTF object; or the names and PIDs of processes referencing BPF objects. To
collect this information, bpftool uses hash maps (to be clear: the data
structures, inside bpftool - we are not talking of BPF maps). It uses the
implementation available from the kernel, and picks it up from
tools/include/linux/hashtable.h.

This patchset converts bpftool's hash maps to a distinct implementation
instead, the one coming with libbpf. The main motivation for this change is
that it should ease the path towards a potential out-of-tree mirror for
bpftool, like the one libbpf already has. Although it's not perfect to
depend on libbpf's internal components, bpftool is intimately tied with the
library anyway, and this looks better than depending too much on (non-UAPI)
kernel headers.

The first two patches contain preparatory work on the Makefile and on the
initialisation of the hash maps for collecting pinned paths for objects.
Then the transition is split into several steps, one for each kind of
properties for which the collection is backed by hash maps.

v2:
  - Move hashmap cleanup for pinned paths for links from do_detach() to
    do_show().
  - Handle errors on hashmap__append() (in three of the patches).
  - Rename bpftool_hash_fn() and bpftool_equal_fn() as hash_fn_for_key_id()
    and equal_fn_for_key_id(), respectively.
  - Add curly braces for hashmap__for_each_key_entry() { } in
    show_btf_plain() and show_btf_json(), where the flow was difficult to
    read.

Quentin Monnet (5):
  bpftool: Remove Makefile dep. on $(LIBBPF) for $(LIBBPF_INTERNAL_HDRS)
  bpftool: Do not expose and init hash maps for pinned path in main.c
  bpftool: Switch to libbpf's hashmap for pinned paths of BPF objects
  bpftool: Switch to libbpf's hashmap for programs/maps in BTF listing
  bpftool: Switch to libbpf's hashmap for PIDs/names references

 tools/bpf/bpftool/Makefile |  12 ++--
 tools/bpf/bpftool/btf.c    | 132 +++++++++++++++++--------------------
 tools/bpf/bpftool/common.c |  50 ++++++++------
 tools/bpf/bpftool/link.c   |  45 ++++++++-----
 tools/bpf/bpftool/main.c   |  17 +----
 tools/bpf/bpftool/main.h   |  54 +++++++--------
 tools/bpf/bpftool/map.c    |  45 ++++++++-----
 tools/bpf/bpftool/pids.c   |  90 ++++++++++++++-----------
 tools/bpf/bpftool/prog.c   |  45 ++++++++-----
 9 files changed, 262 insertions(+), 228 deletions(-)

-- 
2.30.2

