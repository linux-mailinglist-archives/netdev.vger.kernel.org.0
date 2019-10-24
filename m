Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6125E3390
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 15:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502382AbfJXNLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 09:11:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502375AbfJXNLk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 09:11:40 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8CE52C0568FD
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 13:11:40 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id l184so1264029wmf.6
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 06:11:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=PAejp8l76RHaTyUKRg9ZexROX6ZjX1qWgzEtWv6KLrM=;
        b=bg04lSJZFN/Mj0f0Y6BbRNIoxEdHULacxblAE6w5TEY1PSuNE5o4itWmmAeiQUGF2t
         zxqSayvPYNDf/sBcv7lLYLkF8XO5Y/tj6jQ8EA51Nx4o+lfPm7IU26rieckL/C1XsVz+
         Y6VgYz2AqAIzVG+nKL8fy8c5QWv21t/72yOe/B5j9R5LQR1reBv97PXKQhgStyysSOaD
         snF9ywiwNZbIpp+2PrSTeo05Gqmlok9vzY2k5yvXDhalHWprw6GSdOdHHg9DoUdIuH+R
         Ii/SLLUQ2DNd0OQb9hFK696UMZiNg7wbeotxtkXuV3UsVCVwRyHssEcOQOwCJmMPCPga
         Rhyg==
X-Gm-Message-State: APjAAAUFuTWX3lKbMNPZpelV2MBY6VV2QGRS+VbQTjfMfYhJkbYd3q8C
        PK6cb7Q1nU7C4VkxRu8XwLhFV+WlqbehXEjFyI2BJ0YSh3E3jJQw4l7rb98M3cOuSZt/BG9zn1b
        8ZP03SmCevfmxR12e
X-Received: by 2002:adf:eed2:: with SMTP id a18mr4092793wrp.273.1571922699023;
        Thu, 24 Oct 2019 06:11:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwSUanx3+3wNzwpFqslVcnf4zuZ4ncS5JdP6tsKVmSoKAKNQua72qSZmzqmtr2k/j657uHL8g==
X-Received: by 2002:adf:eed2:: with SMTP id a18mr4092781wrp.273.1571922698793;
        Thu, 24 Oct 2019 06:11:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id m7sm27606536wrv.40.2019.10.24.06.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:11:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 86F121804B1; Thu, 24 Oct 2019 15:11:37 +0200 (CEST)
Subject: [PATCH bpf-next v2 0/4] libbpf: Support automatic pinning of maps
 using 'pinning' BTF attribute
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 24 Oct 2019 15:11:37 +0200
Message-ID: <157192269744.234778.11792009511322809519.stgit@toke.dk>
User-Agent: StGit/0.20
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support to libbpf for reading 'pinning' settings from BTF-based
map definitions. It introduces a new bpf_object__pin_maps_opts() function which
accepts options with the new options struct definition style. This allows the
caller to configure the pinning path, and to use both old-style "forced pinning"
where all defined maps are pinned, and the new pinning that is based on the BTF
attribute.

The actual semantics of the pinning is similar to the iproute2 "PIN_GLOBAL"
setting, and the eventual goal is to move the iproute2 implementation to be
based on libbpf and the functions introduced in this series.

Changelog:

v2:
  - Drop patch that adds mounting of bpffs
  - Only support a single value of the pinning attribute
  - Add patch to fixup error handling in reuse_fd()
  - Implement the full automatic pinning and map reuse logic on load

---

Toke Høiland-Jørgensen (4):
      libbpf: Fix error handling in bpf_map__reuse_fd()
      libbpf: Store map pin path and status in struct bpf_map
      libbpf: Support configurable pinning of maps from BTF annotations
      libbpf: Add option to auto-pin maps when opening BPF object


 tools/lib/bpf/bpf_helpers.h |    6 +
 tools/lib/bpf/libbpf.c      |  379 +++++++++++++++++++++++++++++++++++++------
 tools/lib/bpf/libbpf.h      |   33 ++++
 tools/lib/bpf/libbpf.map    |    6 +
 4 files changed, 366 insertions(+), 58 deletions(-)

