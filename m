Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063B97E1CC
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732761AbfHASAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:00:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731844AbfHASAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:00:18 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 91B9914D553;
        Thu,  1 Aug 2019 18:00:17 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-21.brq.redhat.com [10.40.200.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA3D060BE0;
        Thu,  1 Aug 2019 18:00:12 +0000 (UTC)
Received: from [10.10.10.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 92FF331256FD1;
        Thu,  1 Aug 2019 20:00:11 +0200 (CEST)
Subject: [net v1 PATCH 0/4] net: fix regressions for generic-XDP
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     xdp-newbies@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        brandon.cazander@multapplied.net,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Date:   Thu, 01 Aug 2019 20:00:11 +0200
Message-ID: <156468229108.27559.2443904494495785131.stgit@firesoul>
In-Reply-To: <20190731211211.GA87084@multapplied.net>
References: <20190731211211.GA87084@multapplied.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 01 Aug 2019 18:00:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks to Brandon Cazander, who wrote a very detailed bug report that
even used perf probe's on xdp-newbies mailing list, we discovered that
generic-XDP contains some regressions when using bpf_xdp_adjust_head().

First issue were that my selftests script, that use bpf_xdp_adjust_head(),
by mistake didn't use generic-XDP any-longer. That selftest should have
caught the real regression introduced in commit 458bf2f224f0 ("net: core:
support XDP generic on stacked devices.").

To verify this patchset fix the regressions, you can invoked manually via:

  cd tools/testing/selftests/bpf/
  sudo ./test_xdp_vlan_mode_generic.sh
  sudo ./test_xdp_vlan_mode_native.sh

Link: https://www.spinics.net/lists/xdp-newbies/msg01231.html
Fixes: 458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
Reported by: Brandon Cazander <brandon.cazander@multapplied.net>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

---

Jesper Dangaard Brouer (4):
      bpf: fix XDP vlan selftests test_xdp_vlan.sh
      selftests/bpf: add wrapper scripts for test_xdp_vlan.sh
      selftests/bpf: reduce time to execute test_xdp_vlan.sh
      net: fix bpf_xdp_adjust_head regression for generic-XDP


 net/core/dev.c                                     |   15 ++++-
 tools/testing/selftests/bpf/Makefile               |    3 +
 tools/testing/selftests/bpf/test_xdp_vlan.sh       |   57 ++++++++++++++++----
 .../selftests/bpf/test_xdp_vlan_mode_generic.sh    |    9 +++
 .../selftests/bpf/test_xdp_vlan_mode_native.sh     |    9 +++
 5 files changed, 75 insertions(+), 18 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_xdp_vlan_mode_generic.sh
 create mode 100755 tools/testing/selftests/bpf/test_xdp_vlan_mode_native.sh

--
