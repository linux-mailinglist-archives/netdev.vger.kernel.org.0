Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1CE4180C4E
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgCJX1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:27:06 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:46324 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgCJX1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:27:05 -0400
Received: by mail-pl1-f174.google.com with SMTP id w12so142108pll.13;
        Tue, 10 Mar 2020 16:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vqu372+wyYGU1//RGQIbr/u5Pxw1Th01BZ7JHYVPhmk=;
        b=VLnNhw1ZQN8qAWeFKtcJSQ0XwYIsMeOj+SGTkRpxbp7UFlETXuJ5y3N4mO2fkkdRoG
         BO0vdvfDaQLEK/c3RSMrUo31IV/iG5/QV6XbFV4YLWbicTIE3c5IXsmmog7SxntnBHe2
         pJUsmIXbKEhedxOnuCfEiCXoGMwe+TIDF/U5a6ckt/clbEp/yrXrYRo+FbYiZn8VfBAG
         QfbyarNwsKheFFNSFlXXftixTHgk2GKRF21Lma00c+hPKs90yV3qi855hBlZZDKR0iQT
         u35OVrYigS4sM88BvpAM145ca9sjLzM2XCwMl2egVAdcyGyx6AOy+R4eykou55pNz8D9
         jpvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vqu372+wyYGU1//RGQIbr/u5Pxw1Th01BZ7JHYVPhmk=;
        b=LPQt0erFVjqmbxz6W1+Sdj6qmS9n9OWszWrTsOl/UcZDaraMV2wYQpUkoQMP01Hg1x
         yDTs/Bij+R04we0nY7z2oJMRwqWcSZLTUrue1xPA6mWnwvBfyqB08FWMoKtk1/fZGCTr
         gBo7wWIIGc9uZoURZPsshkqpXrhQr/dyuqYcTUixTb20WC6OnnfM3t04ELnYUsBxCwWz
         n4Lvys37CQYTAFflJ4a0B1zWH+2+hBycIWhcAUg1y8d4GSItLjEt3RsvMD7UWTB1xyk9
         eiv1GOyzisYz70M9fD0Zsu1dXqCTcP9d9zPpToSKoFUdxKbptbjKihqOBFoYTZeB3uHY
         m11w==
X-Gm-Message-State: ANhLgQ0ML3H/7VONXLSD0WRvtMzsXG/cPrUui9aOsyrHh8poqVeYefqS
        /mICy1MjWB0odU5rl3PKew==
X-Google-Smtp-Source: ADFU+vv2B22P0AW554ggcflQZLZC6ukTGa1MiiJEEz3QKSXhQVgAxnrKQFIbvaAKA7VzJewXJpZpuQ==
X-Received: by 2002:a17:90a:9501:: with SMTP id t1mr383872pjo.108.1583882824240;
        Tue, 10 Mar 2020 16:27:04 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id x6sm48263668pfi.83.2020.03.10.16.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 16:27:03 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 0/2] Refactor perf_event sample user program with libbpf bpf_link
Date:   Wed, 11 Mar 2020 08:26:45 +0900
Message-Id: <20200310232647.27777-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, some samples are using ioctl for enabling perf_event and
attaching BPF programs to this event. However, the bpf_program__attach
of libbpf(using bpf_link) is much more intuitive than the previous
method using ioctl.

bpf_program__attach_perf_event manages the enable of perf_event and
attach of BPF programs to it, so there's no neeed to do this
directly with ioctl.

In addition, bpf_link provides consistency in the use of API because it
allows disable (detach, destroy) for multiple events to be treated as
one bpf_link__destroy.

To refactor samples with using this libbpf API, the bpf_load in the
samples were removed and migrated to libbbpf. Because read_trace_pipe
is used in bpf_load, multiple samples cannot be migrated to libbpf,
this function was moved to trace_helpers.

Changes in v2:
 - check memory allocation is successful
 - clean up allocated memory on error

Daniel T. Lee (2):
  samples: bpf: move read_trace_pipe to trace_helpers
  samples: bpf: refactor perf_event user program with libbpf bpf_link

 samples/bpf/Makefile                        |  8 +--
 samples/bpf/bpf_load.c                      | 20 ------
 samples/bpf/bpf_load.h                      |  1 -
 samples/bpf/sampleip_user.c                 | 76 ++++++++++++++-------
 samples/bpf/trace_event_user.c              | 63 ++++++++++++-----
 samples/bpf/tracex1_user.c                  |  1 +
 samples/bpf/tracex5_user.c                  |  1 +
 tools/testing/selftests/bpf/trace_helpers.c | 23 +++++++
 tools/testing/selftests/bpf/trace_helpers.h |  1 +
 9 files changed, 125 insertions(+), 69 deletions(-)

-- 
2.25.1

