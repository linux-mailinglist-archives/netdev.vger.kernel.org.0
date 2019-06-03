Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE6C330D4
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 15:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbfFCNTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 09:19:16 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:38434 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfFCNTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 09:19:16 -0400
Received: by mail-lj1-f172.google.com with SMTP id o13so16157287lji.5
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 06:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3gu1j9RhXlTqQguks8O7Dvrlo91jcb2ezpz6/2M5UY4=;
        b=TK6+IuLy+cm5YkxH5+7ENAAEpCagNcCjRlL8cj2m0UBV7AK6XhESa2q7nDtJHU/ghw
         9cx7wy+rEmMiQYQprtRluwz+or5BXml1u7GZbq4BAcF28lssdSMa+AkHRma0KpU43OnN
         bRtZDVmB9e3H9rGtyj8Dhgk+EfcgRTjYoKKJVvikH2YEAD3Cpq1Vatzymxha8hVMGTeY
         kk4XRRz60MwmOfqDnjacZxD/CNhercvH5z8j7ktDSTlpsz7fUC6fsmVTmLHUI9l/qz2G
         4J1nbqtiV49//vOnBcLaFAS+l0iaHlI5D1xY5z3rSToGNaz/uQJc48Qb+tIY/KXcuzi+
         rvyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3gu1j9RhXlTqQguks8O7Dvrlo91jcb2ezpz6/2M5UY4=;
        b=C1OyCNqZT2p4bOyXccouW2gBj20BLCOG0P5zgArA2TkX5K+iyMrbx9Fvkl0axLcxM2
         7f5/sxyskvxUzwZy82PwHaQFxCqh9QVm0rzkrrK08E7GaMs/3AzrAjTo4IaNDO1q043g
         Fzn+zuIiDdTsna7n8Ua2npgTBFtYbu8X24DkuLe0DasEgFo6YI39tEja4vOBu+ViyRll
         4U2VE9Np9yC9fGDytbAj9SC5MjgGRmgaUhSak3ifCVxm/e4LG+u46N3PeAuvvWuFih4G
         m9mTqGT/JpZNuXEPdXX874WmMYVeseqxMaFkLVhOQRMk/mmf1eqdnUNiAHqlYfYrQT7K
         pLDQ==
X-Gm-Message-State: APjAAAX+g/fl8kseVbckGE2rHMvAnpzsniO1OikALyKOtdJw5qyyC6bF
        YGZ10U2o4BFzlx7WVTzrCIs=
X-Google-Smtp-Source: APXvYqzswHcl9tpcP4CEdvLyGcAEdp2U7FhD/2WEpX2Nl7GUk2w6DvJKnvHbM0lE6u4GV26jZAOjaw==
X-Received: by 2002:a2e:9919:: with SMTP id v25mr9668699lji.191.1559567953842;
        Mon, 03 Jun 2019 06:19:13 -0700 (PDT)
Received: from localhost.localdomain (host-185-93-94-143.ip-point.pl. [185.93.94.143])
        by smtp.gmail.com with ESMTPSA id 20sm577808ljf.21.2019.06.03.06.19.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 03 Jun 2019 06:19:13 -0700 (PDT)
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
X-Google-Original-From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        jonathan.lemon@gmail.com, songliubraving@fb.com
Subject: [RFC PATCH bpf-next 0/4] libbpf: xsk improvements
Date:   Mon,  3 Jun 2019 15:19:03 +0200
Message-Id: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.16.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
This set contains fixes for libbpf's AF_XDP support. For patches 1-3 please
have a look at commit messages, 4th patch needs a bit more discussion.

Patch 4 tries to address the issue of dangling xsksocks in case when there were
many instances of those running on a particular interface and one of them got
removed. The case is that we don't keep an information about how many entries
are currently used in eBPF maps, so there's a need for having an external
counter, or we could just be traversing the map via
bpf_map_get_next_key/bpf_map_lookup_elem syscall combination, but IMHO that's a
no-go since the maps used in libbpf's xsk get preallocated entries. The count
of entries is equal to number of HW queues present on a working interface,
which means many unnecessary operations as CPUs are getting more and more cores
and normally NICs are allocating HW queue per CPU core.

For xsk counter we could have for example additional entry in qidconf_map, but
that map is removed in Jonathan's patches, so that's not an option. The
resolution I gave a shot is to have a pinned map with a single entry. Further
reasoning is included in commit message of fourth patch.

Thanks!

Maciej Fijalkowski (4):
  libbpf: fill the AF_XDP fill queue before bind() call
  libbpf: check for channels.max_{t,r}x in xsk_get_max_queues
  libbpf: move xdp program removal to libbpf
  libbpf: don't remove eBPF resources when other xsks are present

 samples/bpf/xdpsock_user.c |  48 ++++--------------
 tools/lib/bpf/xsk.c        | 124 +++++++++++++++++++++++++++++++++++++++------
 tools/lib/bpf/xsk.h        |   1 +
 3 files changed, 120 insertions(+), 53 deletions(-)

-- 
2.16.1

