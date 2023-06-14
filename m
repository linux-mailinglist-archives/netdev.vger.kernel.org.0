Return-Path: <netdev+bounces-10746-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BCE1730146
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:08:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 810891C20BC9
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2B6DF4E;
	Wed, 14 Jun 2023 14:07:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AF0101C1
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:07:35 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562FA1BE5;
	Wed, 14 Jun 2023 07:07:34 -0700 (PDT)
From: Florian Kauer <florian.kauer@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1686751653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TCMbNNv1wUCpp0eUsLbLvQKi9uBHfNttKgJxjYAeb0M=;
	b=y3apSj/1vJ6DYmeRmtuz58yggKV/HUKT/ugbiKU51svYY4S7rF0nFts3eNFdT4vrYcwIb4
	0gFFhhcWdvwGUTGZYVdzMMrHQhbN4ffJSx2y+GYO9Ql1OVwUYF2H4PvV4z3mX2DEbhdlWX
	BExwMnc4Me9dpiUusAf863WxGpSNMRsl88WWAjDLoRKfh5gOG9df7dOrl8d5Et8zTZgB3l
	vHlj8eDL3UtLgppTuUt5rYQL/bW8lr8J9zeroaaNIUs4ZP37MPZBIx34CM6CUv7grPSlx1
	eTj52atV/m9E4QcSQDjgK0q4SGarto1XZ5eKL2955mvoCwCkX6fCr9XdWkoaAQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1686751653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TCMbNNv1wUCpp0eUsLbLvQKi9uBHfNttKgJxjYAeb0M=;
	b=4wvkId7pYYzXqtq36DOtC/f7wZFtHHd/o9YUg5/t8OkzDtR3DsoCiV85Z5FybSDkQi0lzl
	5V2zDazABw5qxdCQ==
To: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Tan Tee Min <tee.min.tan@linux.intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>,
	Malli C <mallikarjuna.chilakala@intel.com>
Cc: intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kurt@linutronix.de,
	florian.kauer@linutronix.de
Subject: [PATCH net-next 4/6] igc: No strict mode in pure launchtime/CBS offload
Date: Wed, 14 Jun 2023 16:07:12 +0200
Message-Id: <20230614140714.14443-5-florian.kauer@linutronix.de>
In-Reply-To: <20230614140714.14443-1-florian.kauer@linutronix.de>
References: <20230614140714.14443-1-florian.kauer@linutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The flags IGC_TXQCTL_STRICT_CYCLE and IGC_TXQCTL_STRICT_END
prevent the packet transmission over slot and cycle boundaries.
This is important for taprio offload where the slots and
cycles correspond to the slots and cycles configured for the
network.

However, the Qbv offload feature of the i225 is also used for
enabling TX launchtime / ETF offload. In that case, however,
the cycle has no meaning for the network and is only used
internally to adapt the base time register after a second has
passed.

Enabling strict mode in this case would unneccesarily prevent
the transmission of certain packets (i.e. at the boundary of a
second) and thus interfers with the ETF qdisc that promises
transmission at a certain point in time.

Similar to ETF, this also applies to CBS offload that also should
not be influenced by strict mode unless taprio offload would be
enabled at the same time.

This fully reverts
commit d8f45be01dd9 ("igc: Use strict cycles for Qbv scheduling")
but its commit message only describes what was already implemented
before that commit. The difference to a plain revert of that commit
is that it now copes with the base_time = 0 case that was fixed with
commit e17090eb2494 ("igc: allow BaseTime 0 enrollment for Qbv")

In particular, enabling strict mode leads to TX hang situations
under high traffic if taprio is applied WITHOUT taprio offload
but WITH ETF offload, e.g. as in

    sudo tc qdisc replace dev enp1s0 parent root handle 100 taprio \
	    num_tc 1 \
	    map 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 \
	    queues 1@0 \
	    base-time 0 \
	    sched-entry S 01 300000 \
	    flags 0x1 \
	    txtime-delay 500000 \
	    clockid CLOCK_TAI
    sudo tc qdisc replace dev enp1s0 parent 100:1 etf \
	    clockid CLOCK_TAI \
	    delta 500000 \
	    offload \
	    skip_sock_check

and traffic generator

    sudo trafgen -i traffic.cfg -o enp1s0 --cpp -n0 -q -t1400ns

with traffic.cfg

    #define ETH_P_IP        0x0800

    {
      /* Ethernet Header */
      0x30, 0x1f, 0x9a, 0xd0, 0xf0, 0x0e,  # MAC Dest - adapt as needed
      0x24, 0x5e, 0xbe, 0x57, 0x2e, 0x36,  # MAC Src  - adapt as needed
      const16(ETH_P_IP),

      /* IPv4 Header */
      0b01000101, 0,   # IPv4 version, IHL, TOS
      const16(1028),   # IPv4 total length (UDP length + 20 bytes (IP header))
      const16(2),      # IPv4 ident
      0b01000000, 0,   # IPv4 flags, fragmentation off
      64,              # IPv4 TTL
      17,              # Protocol UDP
      csumip(14, 33),  # IPv4 checksum

      /* UDP Header */
      10,  0, 48, 1,   # IP Src - adapt as needed
      10,  0, 48, 10,  # IP Dest - adapt as needed
      const16(5555),   # UDP Src Port
      const16(6666),   # UDP Dest Port
      const16(1008),   # UDP length (UDP header 8 bytes + payload length)
      csumudp(14, 34), # UDP checksum

      /* Payload */
      fill('W', 1000),
    }

and the observed message with that is for example

 igc 0000:01:00.0 enp1s0: Detected Tx Unit Hang
   Tx Queue             <0>
   TDH                  <d0>
   TDT                  <f0>
   next_to_use          <f0>
   next_to_clean        <d0>
 buffer_info[next_to_clean]
   time_stamp           <ffff661f>
   next_to_watch        <00000000245a4efb>
   jiffies              <ffff6e48>
   desc.status          <1048000>

Fixes: d8f45be01dd9 ("igc: Use strict cycles for Qbv scheduling")
Signed-off-by: Florian Kauer <florian.kauer@linutronix.de>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/ethernet/intel/igc/igc_tsn.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index c6636a7264d5..63d410e7b876 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -133,8 +133,28 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 		wr32(IGC_STQT(i), ring->start_time);
 		wr32(IGC_ENDQT(i), ring->end_time);
 
-		txqctl |= IGC_TXQCTL_STRICT_CYCLE |
-			IGC_TXQCTL_STRICT_END;
+		if (adapter->taprio_offload_enable) {
+			/* If taprio_offload_enable is set we are in "taprio"
+			 * mode and we need to be strict about the
+			 * cycles: only transmit a packet if it can be
+			 * completed during that cycle.
+			 *
+			 * If taprio_offload_enable is NOT true when
+			 * enabling TSN offload, the cycle should have
+			 * no external effects, but is only used internally
+			 * to adapt the base time register after a second
+			 * has passed.
+			 *
+			 * Enabling strict mode in this case would
+			 * unneccesarily prevent the transmission of
+			 * certain packets (i.e. at the boundary of a
+			 * second) and thus interfer with the launchtime
+			 * feature that promises transmission at a
+			 * certain point in time.
+			 */
+			txqctl |= IGC_TXQCTL_STRICT_CYCLE |
+				IGC_TXQCTL_STRICT_END;
+		}
 
 		if (ring->launchtime_enable)
 			txqctl |= IGC_TXQCTL_QUEUE_MODE_LAUNCHT;
-- 
2.39.2


