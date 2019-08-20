Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E9D95DB6
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 13:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbfHTLrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 07:47:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49774 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfHTLrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 07:47:49 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BF7CBC08EC01
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 11:47:48 +0000 (UTC)
Received: by mail-ed1-f69.google.com with SMTP id x40so4002158edm.4
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 04:47:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tmhQ+PPG27Zm5vMSN1m6PIsu4l0aG9ZHhqIHeZ54iD0=;
        b=M1AdaQTPRzS1awlkDu3TUGjFO1MC3OOgHvNX+++mkb/kB5bWXXKvRsP6MoqN1zrntV
         h0YbiPDFnG9ou4sxSolTiSNOiFvPX2WC1/xTLTu2bNuVny4R4wGv+HpJX4/Y7czlvmee
         Y7ibEwae3hJnsQxEv6haLfpi40W3NCFGyZXu7H3+zFEEqr2re0y3/j1YoixDOUBLymL/
         ZjxsZGashZEHOH2cJp4F790ieEjz2Kc4TN7VRpfwPk+0qiA+SAx2Fn5jUTHRhC1usyy9
         M2v7n1IYNE89vrhnab4eQoA5SWsH2bMFwZMI4KnyvTTvQWlGmOaCTYH8hPiT0labou3s
         Hslw==
X-Gm-Message-State: APjAAAVyzl+NH0MlQTVAjwTOI+4gzZx8DbDDOUl6yZXs1yYTCOFoxbUJ
        xmYAYEgjD5WTYc+5SJBegw2XLL2n+sJE7IS3kpuVuQH0oT4th0dZ1ElyIf3sGkMi1jeoc19ACgr
        FCuRuIJ1RiKrvewo3
X-Received: by 2002:a17:906:5789:: with SMTP id k9mr8179671ejq.56.1566301667476;
        Tue, 20 Aug 2019 04:47:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzdm372vNavz02gj6Zcl/KfjpJUZKVgG6O9Ssv+/oI5u+vkkmTueDJ4uipbt5fiPZWK2dlezw==
X-Received: by 2002:a17:906:5789:: with SMTP id k9mr8179649ejq.56.1566301667227;
        Tue, 20 Aug 2019 04:47:47 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id um15sm2569004ejb.27.2019.08.20.04.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 04:47:46 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E8D81181CE4; Tue, 20 Aug 2019 13:47:45 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
Date:   Tue, 20 Aug 2019 13:47:01 +0200
Message-Id: <20190820114706.18546-1-toke@redhat.com>
X-Mailer: git-send-email 2.22.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iproute2 uses its own bpf loader to load eBPF programs, which has
evolved separately from libbpf. Since we are now standardising on
libbpf, this becomes a problem as iproute2 is slowly accumulating
feature incompatibilities with libbpf-based loaders. In particular,
iproute2 has its own (expanded) version of the map definition struct,
which makes it difficult to write programs that can be loaded with both
custom loaders and iproute2.

This series seeks to address this by converting iproute2 to using libbpf
for all its bpf needs. This version is an early proof-of-concept RFC, to
get some feedback on whether people think this is the right direction.

What this series does is the following:

- Updates the libbpf map definition struct to match that of iproute2
  (patch 1).
- Adds functionality to libbpf to support automatic pinning of maps when
  loading an eBPF program, while re-using pinned maps if they already
  exist (patches 2-3).
- Modifies iproute2 to make it possible to compile it against libbpf
  without affecting any existing functionality (patch 4).
- Changes the iproute2 eBPF loader to use libbpf for loading XDP
  programs (patch 5).


As this is an early PoC, there are still a few missing pieces before
this can be merged. Including (but probably not limited to):

- Consolidate the map definition struct in the bpf_helpers.h file in the
  kernel tree. This contains a different, and incompatible, update to
  the struct. Since the iproute2 version has actually been released for
  use outside the kernel tree (and thus is subject to API stability
  constraints), I think it makes the most sense to keep that, and port
  the selftests to use it.

- The iproute2 loader supports automatically populating map-in-map
  definitions on load. This needs to be added to libbpf as well. There
  is an implementation of this in the selftests in the kernel tree,
  which will have to be ported (related to the previous point).

- The iproute2 port needs to be completed; this means at least
  supporting TC eBPF programs as well, figuring out how to deal with
  cBPF programs, and getting the verbose output back to the same state
  as before the port. Also, I guess the iproute2 maintainers need to ACK
  that they are good with adding a dependency on libbpf.

- Some of the code added to libbpf in patch 2 in this series include
  code derived from iproute2, which is GPLv2+. So it will need to be
  re-licensed to be usable in libbpf. Since `git blame` indicated that
  the original code was written by Daniel, I figure he can ACK that
  relicensing before applying the patches :)


Please take a look at this series and let me know if you agree
that this is the right direction to go. Assuming there's consensus that
it is, I'll focus on getting the rest of the libbpf patches ready for
merging. I'll send those as a separate series, and hold off on the
iproute2 patches until they are merged; but for this version I'm
including both in one series so it's easier to see the context.

-Toke


libbpf:
Toke Høiland-Jørgensen (3):
  libbpf: Add map definition struct fields from iproute2
  libbpf: Add support for auto-pinning of maps with reuse on program
    load
  libbpf: Add support for specifying map pinning path via callback

 tools/lib/bpf/libbpf.c | 205 +++++++++++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf.h |  18 ++++
 2 files changed, 214 insertions(+), 9 deletions(-)

iproute2:
Toke Høiland-Jørgensen (2):
  iproute2: Allow compiling against libbpf
  iproute2: Support loading XDP programs with libbpf

 configure          |  16 +++++
 include/bpf_util.h |   6 +-
 ip/ipvrf.c         |   4 +-
 lib/bpf.c          | 148 ++++++++++++++++++++++++++++++++++++---------
 4 files changed, 142 insertions(+), 32 deletions(-)


-- 
2.22.1

