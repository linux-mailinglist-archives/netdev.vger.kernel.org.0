Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99A8312495F
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfLROW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:22:58 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38137 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfLROW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 09:22:58 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so2505566wrh.5;
        Wed, 18 Dec 2019 06:22:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=PHzGUvVP8gQcYAoL9L+uoV5KatVEVFDCa4ZXtb+5JGo=;
        b=T0u+UAqiC4lp6o39z0J4nzD1noUtybY5ozJ+1vYpoaD7tyeiauPNaAjcFjDH/ig1/3
         3Z200ROgRjWUSn2uYAAnsHNlc1hUTaWNQy6b4g2c3ju3VM8DtxE3+Vy2SZX4Syc8ZaWd
         BuRyPyZ7X8wEfMDrOwWNC/6900lJCBnbwH3zgPvgZFgmluOhCnqw1AgjxrggwoYK3D+k
         sL996mai/MVD+uLIxWfNhdiXxkP+qs6PaYffsQlbjEU6sLItslUTVQrGq81peEYkPwRf
         0oVtEGq2ADD8jUAxlMfaUE0lwhz+43fD6BXyhktPUmTzwmtutDw9ATrL0Y1q9SzN8GGT
         aQaw==
X-Gm-Message-State: APjAAAWw/2IqPgZKJwITZk7P2j0iP6GFH7n0WJw0hVxUvy3BNQDwivwK
        9kLVh96RATTchfa3K7QcFCsZsgtfE3IhSA==
X-Google-Smtp-Source: APXvYqwFB1TI0ds5UbOMxeJ1h87AI0McF/LwNvO9iiRWJBVfTb6UmoaYqVXbHM5+tB2oWZeCmlfxuQ==
X-Received: by 2002:a5d:528e:: with SMTP id c14mr3322561wrv.308.1576678975758;
        Wed, 18 Dec 2019 06:22:55 -0800 (PST)
Received: from Omicron ([217.76.31.1])
        by smtp.gmail.com with ESMTPSA id o194sm2678610wme.45.2019.12.18.06.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 06:22:55 -0800 (PST)
Date:   Wed, 18 Dec 2019 15:22:54 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     bpf@vger.kernel.org
Cc:     paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next 0/3] Single-cpu updates for per-cpu maps
Message-ID: <cover.1576673841.git.paul.chaignon@orange.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, userspace programs have to update the values of all CPUs at
once when updating per-cpu maps.  This limitation prevents the update of a
single CPU's value without the risk of missing concurrent updates on other
CPU's values.

The first patch allows userspace to update the value of a specific CPU in
per-cpu maps.  The second and last patches add test cases and support in
bpftool respectively.

Paul Chaignon (3):
  bpf: Single-cpu updates for per-cpu maps
  selftests/bpf: Tests for single-cpu updates of per-cpu maps
  bpftool: Support single-cpu updates for per-cpu maps

 include/uapi/linux/bpf.h                      |  4 ++
 kernel/bpf/arraymap.c                         | 19 +++--
 kernel/bpf/hashtab.c                          | 49 +++++++------
 kernel/bpf/local_storage.c                    | 16 +++--
 kernel/bpf/syscall.c                          | 17 +++--
 .../bpf/bpftool/Documentation/bpftool-map.rst | 13 ++--
 tools/bpf/bpftool/bash-completion/bpftool     |  2 +-
 tools/bpf/bpftool/map.c                       | 70 ++++++++++++++-----
 tools/include/uapi/linux/bpf.h                |  4 ++
 tools/testing/selftests/bpf/test_maps.c       | 34 ++++++++-
 10 files changed, 168 insertions(+), 60 deletions(-)

-- 
2.24.0

