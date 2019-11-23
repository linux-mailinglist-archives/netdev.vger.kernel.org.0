Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F01107E7C
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 14:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKWNTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 08:19:17 -0500
Received: from bmailout2.hostsharing.net ([83.223.78.240]:49227 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfKWNTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 08:19:16 -0500
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Nov 2019 08:19:16 EST
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 6FD66280237DB;
        Sat, 23 Nov 2019 14:11:08 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 2C22070E406; Sat, 23 Nov 2019 14:11:08 +0100 (CET)
Date:   Sat, 23 Nov 2019 14:11:08 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next,RFC 0/5] Netfilter egress hook
Message-ID: <20191123131108.dlnrbutabh5i55ix@wunner.de>
References: <cover.1572528496.git.lukas@wunner.de>
 <20191107225149.5t4sg35b5gwuwawa@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107225149.5t4sg35b5gwuwawa@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 11:51:49PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Oct 31, 2019 at 02:41:00PM +0100, Lukas Wunner wrote:
> > Introduce a netfilter egress hook to complement the existing ingress hook.
> 
> Would you provide some numbers on the performance impact for this new
> hook?

For some reason the numbers are slightly better with this series.

Could be caused by the __always_inline in patch 4, I'd have to compare
the disassembly to confirm this hunch.


* Without this patch:
  Result: OK: 34205373(c34202809+d2564) usec, 100000000 (60byte,0frags)
  2923517pps 1403Mb/sec (1403288160bps) errors: 0

* With this patch:
  Result: OK: 34106013(c34103172+d2841) usec, 100000000 (60byte,0frags)
  2932034pps 1407Mb/sec (1407376320bps) errors: 0


* Without this patch + tc egress:
  Result: OK: 37848652(c37846140+d2511) usec, 100000000 (60byte,0frags)
  2642102pps 1268Mb/sec (1268208960bps) errors: 0

* With this patch + tc egress:
  Result: OK: 37784817(c37782026+d2791) usec, 100000000 (60byte,0frags)
  2646565pps 1270Mb/sec (1270351200bps) errors: 0


* With this patch + nft egress:
  Result: OK: 43911936(c43908932+d3003) usec, 100000000 (60byte,0frags)
  2277285pps 1093Mb/sec (1093096800bps) errors: 0


Tested on a bare-metal Core i7-3615QM, each measurement was performed
twice to verify that the numbers are stable.

Commands to perform a measurement:
modprobe pktgen
echo "add_device lo@3" > /proc/net/pktgen/kpktgend_3
samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh -i 'lo@3' -n 100000000

Commands for testing tc egress:
tc qdisc add dev lo clsact
tc filter add dev lo egress protocol ip prio 1 u32 match ip dst 4.3.2.1/32

Commands for testing nft egress:
nft add table netdev t
nft add chain netdev t co \{ type filter hook egress device lo priority 0 \; \}
nft add rule netdev t co ip daddr 4.3.2.1/32 drop

All testing was performed on the loopback interface to avoid distorting
measurements by the packet handling in the low-level Ethernet driver.
This required the following small patch:


diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index bb99152..020c825 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2003,8 +2003,8 @@ static int pktgen_setup_dev(const struct pktgen_net *pn,
 		return -ENODEV;
 	}
 
-	if (odev->type != ARPHRD_ETHER) {
-		pr_err("not an ethernet device: \"%s\"\n", ifname);
+	if (odev->type != ARPHRD_ETHER && odev->type != ARPHRD_LOOPBACK) {
+		pr_err("not an ethernet or loopback device: \"%s\"\n", ifname);
 		err = -EINVAL;
 	} else if (!netif_running(odev)) {
 		pr_err("device is down: \"%s\"\n", ifname);
