Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4152C397C16
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhFAWIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:08:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39552 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234898AbhFAWIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:08:19 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 72AF6641A1;
        Wed,  2 Jun 2021 00:05:29 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 02/16] netfilter: nft_set_pipapo_avx2: Skip LDMXCSR, we don't need a valid MXCSR state
Date:   Wed,  2 Jun 2021 00:06:15 +0200
Message-Id: <20210601220629.18307-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

We don't need a valid MXCSR state for the lookup routines, none of
the instructions we use rely on or affect any bit in the MXCSR
register.

Instead of calling kernel_fpu_begin(), we can pass 0 as mask to
kernel_fpu_begin_mask() and spare one LDMXCSR instruction.

Commit 49200d17d27d ("x86/fpu/64: Don't FNINIT in kernel_fpu_begin()")
already speeds up lookups considerably, and by dropping the MCXSR
initialisation we can now get a much smaller, but measurable, increase
in matching rates.

The table below reports matching rates and a wild approximation of
clock cycles needed for a match in a "port,net" test with 10 entries
from selftests/netfilter/nft_concat_range.sh, limited to the first
field, i.e. the port (with nft_set_rbtree initialisation skipped), run
on a single AMD Epyc 7351 thread (2.9GHz, 512 KiB L1D$, 8 MiB L2$).

The (very rough) estimation of clock cycles is obtained by simply
dividing frequency by matching rate. The "cycles spared" column refers
to the difference in cycles compared to the previous row, and the rate
increase also refers to the previous row. Results are averages of six
runs.

Merely for context, I'm also reporting packet rates obtained by
skipping kernel_fpu_begin() and kernel_fpu_end() altogether (which
shows a very limited impact now), as well as skipping the whole lookup
function, compared to simply counting and dropping all packets using
the netdev hook drop (see nft_concat_range.sh for details). This
workload also includes packet generation with pktgen and the receive
path of veth.

                                      |matching|  est.  | cycles |  rate  |
                                      |  rate  | cycles | spared |increase|
                                      | (Mpps) |        |        |        |
--------------------------------------|--------|--------|--------|--------|
FNINIT, LDMXCSR (before 49200d17d27d) |  5.245 |    553 |      - |      - |
LDMXCSR only (with 49200d17d27d)      |  6.347 |    457 |     96 |  21.0% |
Without LDMXCSR (this patch)          |  6.461 |    449 |      8 |   1.8% |
-------- for reference only: ---------|--------|--------|--------|--------|
Without kernel_fpu_begin()            |  6.513 |    445 |      4 |   0.8% |
Without actual matching (return true) |  7.649 |    379 |     66 |  17.4% |
Without lookup operation (netdev drop)| 10.320 |    281 |     98 |  34.9% |

The clock cycles spared by avoiding LDMXCSR appear to be in line with CPI
and latency indicated in the manuals of comparable architectures: Intel
Skylake (CPI: 1, latency: 7) and AMD 12h (latency: 12) -- I couldn't find
this information for AMD 17h.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo_avx2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index eabdb8d552ee..1c2620923a61 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1136,8 +1136,13 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 
 	m = rcu_dereference(priv->match);
 
-	/* This also protects access to all data related to scratch maps */
-	kernel_fpu_begin();
+	/* This also protects access to all data related to scratch maps.
+	 *
+	 * Note that we don't need a valid MXCSR state for any of the
+	 * operations we use here, so pass 0 as mask and spare a LDMXCSR
+	 * instruction.
+	 */
+	kernel_fpu_begin_mask(0);
 
 	scratch = *raw_cpu_ptr(m->scratch_aligned);
 	if (unlikely(!scratch)) {
-- 
2.30.2

