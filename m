Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6CCE8EE38
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbfHOOcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:32:33 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42322 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729900AbfHOOcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 10:32:32 -0400
Received: by mail-wr1-f68.google.com with SMTP id b16so2394035wrq.9
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 07:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=VzIV3wLK5szCxEi8cwnZRCUa5jZ2PF/EyCcsUyHAR5E=;
        b=cQmKfWBZN7lmI2BBEhL0AuCpQssDt4nzWC2DZUPkmQSWE+VEop33UrjgzHtQ+ZlE7u
         xVYgbSXr64uFDlc2laydxVbs1niuoorYTc8Db4mz18iPfzRTKytPQe4YleBpHDVDjYek
         fLfbcdfH/zyjsKtXTjMH+5LG9uEucFHhax9Dq4EdKRKv1rP0mzk1urGYQZjpCrrIX67W
         xw3MpNErjwzuqpCw2AGwcjeOfza8JXb4c5IT7Cg1VtiAkiuFyqwwnuZy17772wCqAkq7
         JQmKr0co6qaF96vRSmzkTSPmyRI1VepHdkGgGdvx0sCKFIIvhis7Fo6PAEl/gzMfW69f
         728A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VzIV3wLK5szCxEi8cwnZRCUa5jZ2PF/EyCcsUyHAR5E=;
        b=YG4p6P0k8+LLtr1Tm0hkyJGKp8P5aeg7hrpex/ZBpGOysqzvQEff9p+R9BHLF3fCVs
         +HIs0eCvcz3wNPp7sLaj2gpith6Pc4iN/8qWRH68Wz3jL10IKjLzzvHYl3gBiI9Iy521
         yaYWUy7urQqbUUaL14FuBM2PL4ARTH5ks0MzRJIUp9VnPvpnDYAedd9MKt45RH+MwlRj
         /DrMjkNNvq9i+9o8ds2Ja84mPwZJ/VTOBezaPrIOrP/fgYQbAY47MDZ1Zm2AXp0zTg7h
         OpsqKsP+EFrPkLI0zq4iVcLwRHwjyVYRVbdoR1Ol1zRmv47n7Yix8K19C7gomxuVNP5P
         ljAA==
X-Gm-Message-State: APjAAAWJe4McMP8/+UzuN+Q5xyYefu14YEJ8GewPRQtHWQbhwoV9pJHR
        ZDYT0jkw0lReaOVCRycNNpAsKg==
X-Google-Smtp-Source: APXvYqxbg/i8zgboue0gyOYEzbsKK6Scl6nAmTso5Ls+s2B80n7c94kC8Co1D7hXtmC5im6RvTrr8A==
X-Received: by 2002:a05:6000:1186:: with SMTP id g6mr6026852wrx.17.1565879550622;
        Thu, 15 Aug 2019 07:32:30 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id a19sm8857463wra.2.2019.08.15.07.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 07:32:29 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf 0/6] tools: bpftool: fix printf()-like functions
Date:   Thu, 15 Aug 2019 15:32:14 +0100
Message-Id: <20190815143220.4199-1-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
Because the "__printf()" attributes were used only where the functions are
implemented, and not in header files, the checks have not been enforced on
all the calls to printf()-like functions, and a number of errors slipped in
bpftool over time.

This set cleans up such errors, and then moves the "__printf()" attributes
to header files, so that the checks are performed at all locations.

Quentin Monnet (6):
  tools: bpftool: fix arguments for p_err() in do_event_pipe()
  tools: bpftool: fix format strings and arguments for jsonw_printf()
  tools: bpftool: fix argument for p_err() in BTF do_dump()
  tools: bpftool: fix format string for p_err() in
    query_flow_dissector()
  tools: bpftool: fix format string for p_err() in
    detect_common_prefix()
  tools: bpftool: move "__printf()" attributes to header file

 tools/bpf/bpftool/btf.c            | 2 +-
 tools/bpf/bpftool/btf_dumper.c     | 8 ++++----
 tools/bpf/bpftool/common.c         | 4 ++--
 tools/bpf/bpftool/json_writer.c    | 6 ++----
 tools/bpf/bpftool/json_writer.h    | 6 ++++--
 tools/bpf/bpftool/main.c           | 2 +-
 tools/bpf/bpftool/main.h           | 4 ++--
 tools/bpf/bpftool/map_perf_ring.c  | 4 ++--
 tools/bpf/bpftool/net.c            | 2 +-
 tools/include/linux/compiler-gcc.h | 2 ++
 10 files changed, 21 insertions(+), 19 deletions(-)

-- 
2.17.1

