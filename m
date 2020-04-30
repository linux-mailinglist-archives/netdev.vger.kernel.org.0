Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4CB1C0953
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgD3Vcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:32:47 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:49795 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgD3Vcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:32:47 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M2w0K-1jTBOd0Rhs-003PJb; Thu, 30 Apr 2020 23:32:23 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jeremy Sowden <jeremy@azazel.net>,
        Li RongQing <lirongqing@baidu.com>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jules Irenge <jbi.octave@gmail.com>,
        Dirk Morris <dmorris@metaloft.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH 06/15] netfilter: conntrack: avoid gcc-10 zero-length-bounds warning
Date:   Thu, 30 Apr 2020 23:30:48 +0200
Message-Id: <20200430213101.135134-7-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200430213101.135134-1-arnd@arndb.de>
References: <20200430213101.135134-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:8Sp1zqk0kvXNuoj2OkQlE/ujFJe7AlEDhxnJ66L0VukuMY/xxYi
 +JgvA3BEJVInn94lFMseSuPlDxRS/GL/oaTPplGHTZvnLqo7E/MijvoRxlN0VmpEU2lISm0
 lE2g9NCgBPAiDai9y5MKBi5xa6BaV6duj4paBSzna762U2aagG+uxR3tmKxRzdadqKwZsQP
 sTKb8dOBMg6yReMFaqH6w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:VNz0tYWZTqk=:UsDGslkgNI5fdFKkPvadEp
 6mtBxc23aMctyVNSUmtxjmYVlBSip2tqZUVeWE3owPBMOAzBA5KaIipnOc4+0PpR/FzETZXhO
 /k094E//vxZnfTOZxqwMe+rNEuL0uTQol7g1+JVqrOgBs2tl/5LVpo9uSRvLzyXzdq2Ih5x0s
 jy/nvLF4ZaFqgffe/1Ij5wy0qGZizKErNItmS1jZA6GqPUe99IR4qVP7GSRFnoVuCGHIOkZOs
 BQT/QITf4RXgOM09POIWx1EiXMaeET75PoUV7WQXZZyFvQl3GSfxdSsR0njRL/iQlQOJUUKE9
 HQ46qhkyrNPeO9/5HNrtbsMadFiSghd5C7WtARl2/ebqhQY5u14yK2gX5RvTwKjC/msY4V8Ma
 2EiUu4H49OIhOMwK25KYdEKkBe4iS8YAYY6HfBsYZMw8UPWtFchtX4QaTouIA3PJerFzR134x
 UXcMBdnxLcwasMRYHXnRcWyBFuFOH52QC4NhpI4q3L4IkIRLoXfg3sHIbH/H6qhI+OEwFKzIS
 w5wNzOrgxrviDDsIdTsyVYONKT7Art9WABh/fydx/FW/BGuc87HioQ0GUfFWI2bZRfpBVA4gc
 f3CFLH2Cykr1Tkom3EUXjDWcZSBSW2905QaeE4oDK2EzR+hRbUHN40VCs9rEp1amdToMv4w1e
 CxpXRZvYI3iG3prMVih9ujBWabjb9AN6M6Bh9N69PBEboD2TQAz0fF9+0BhaU4f0h+gt5PFEg
 zcJRCivnsDG1XWjKDrp4p7GKd5RRj8vZDIuQuj5eq8x9vUwrxFnvSCdj5F9dgU1Ze5PBO1AAt
 Ei0a3eb1reZbx2wTQbnlgmpLvtKHD8vLmD5ZgRjMFVANTbDmUk=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc-10 warns around a suspicious access to an empty struct member:

net/netfilter/nf_conntrack_core.c: In function '__nf_conntrack_alloc':
net/netfilter/nf_conntrack_core.c:1522:9: warning: array subscript 0 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[0]'} [-Wzero-length-bounds]
 1522 |  memset(&ct->__nfct_init_offset[0], 0,
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from net/netfilter/nf_conntrack_core.c:37:
include/net/netfilter/nf_conntrack.h:90:5: note: while referencing '__nfct_init_offset'
   90 |  u8 __nfct_init_offset[0];
      |     ^~~~~~~~~~~~~~~~~~

The code is correct but a bit unusual. Rework it slightly in a way that
does not trigger the warning, using an empty struct instead of an empty
array. There are probably more elegant ways to do this, but this is the
smallest change.

Fixes: c41884ce0562 ("netfilter: conntrack: avoid zeroing timer")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/net/netfilter/nf_conntrack.h | 2 +-
 net/netfilter/nf_conntrack_core.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 9f551f3b69c6..90690e37a56f 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -87,7 +87,7 @@ struct nf_conn {
 	struct hlist_node	nat_bysource;
 #endif
 	/* all members below initialized via memset */
-	u8 __nfct_init_offset[0];
+	struct { } __nfct_init_offset;
 
 	/* If we were expected by an expectation, this will be it */
 	struct nf_conn *master;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c4582eb71766..0173398f4ced 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1519,9 +1519,9 @@ __nf_conntrack_alloc(struct net *net,
 	ct->status = 0;
 	ct->timeout = 0;
 	write_pnet(&ct->ct_net, net);
-	memset(&ct->__nfct_init_offset[0], 0,
+	memset(&ct->__nfct_init_offset, 0,
 	       offsetof(struct nf_conn, proto) -
-	       offsetof(struct nf_conn, __nfct_init_offset[0]));
+	       offsetof(struct nf_conn, __nfct_init_offset));
 
 	nf_ct_zone_add(ct, zone);
 
-- 
2.26.0

