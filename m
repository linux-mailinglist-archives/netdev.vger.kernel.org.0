Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA26416155A
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgBQPBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:01:15 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32993 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729315AbgBQPBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:01:14 -0500
Received: by mail-wr1-f68.google.com with SMTP id u6so20173998wrt.0
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 07:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=R1Wb8OZVkW70mXQwZ5kATGqI9CWwbUmW2cw4txcctCI=;
        b=jOsfRhcDBm342ZXGbDIAovyopZ/NZ19LqCw823UTw8yeBv6SELreG/irUx8N9k9Wec
         2LjaCadH5M6qKI83bTUlJCMAqCkwWZleFK7ICQbDr159qq7k8+NiRtpdfLzzzUgKH4hm
         rZvnvRnIIqjcfzGsMXlN/ns8qWgfm3mNesovYowUOwhbwWM0av2adUlEXkwn8aOKItiv
         3WPcCcrW+r0Je6AK48keWiATHq51QCoU0omEzkJ/1DFWEr7KgyhGIIxJDtoTuS0zCGlz
         hr82hJGaH4ZD+h1qswoMj5gWDbSKLTlclzyJuZPEuXKU/+z9KYbEt9oj1MjpQ+XV9BRK
         2wnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=R1Wb8OZVkW70mXQwZ5kATGqI9CWwbUmW2cw4txcctCI=;
        b=DeDzilhzhsfuDVkYCXtsvfHw56IP9u7Og1T4c8y3MnVi8+pbZEgKs3zCEo+pzDqIbl
         3Q+4vypwnhy+3g2ecVIt3yXE/d+7zp/GwNfIzva8Dyie/XUptmcbaGaLe66TA254umRz
         3SMLBRNW1qP5GqKgERbDcQLCZdUcjiGZzaTc5Nlzd6Q7xcd2tHqSfIBC3yQ2SA5jB3YH
         u6rUrgKea+ETcTBZxF4WYuZ8Qbf+PLGIGJceUSFnYtp4VtWmoAKPLIbRFvPu5OMiiXJh
         NsOfpdOK78JAN73Wffmpah8HVzulJ6C5qq+qbT2iInOgvuvkDaolCQgIJtBa3eOSjj7E
         ax+Q==
X-Gm-Message-State: APjAAAX30T3La5lc81NSs8/SPQtZyYFHPbbxy3wcV4iJ8MC6AAGYqmp3
        KbQf+ZkM7MZoS6uggehhi4A=
X-Google-Smtp-Source: APXvYqyC2r63JnImLolVSIraUskY5LpTSgtYi+xrNFBvrTp2829qhjwbez4WBCO3qRHaI4MWEkQKWQ==
X-Received: by 2002:a5d:51ce:: with SMTP id n14mr22990319wrv.426.1581951672275;
        Mon, 17 Feb 2020 07:01:12 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id b11sm1373173wrx.89.2020.02.17.07.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 07:01:11 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next] net: mscc: ocelot: Workaround to allow traffic to CPU in standalone mode
Date:   Mon, 17 Feb 2020 17:00:58 +0200
Message-Id: <20200217150058.5586-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Ocelot switches have what is, in my opinion, a design flaw: their
DSA header is in front of the Ethernet header, which means that they
subvert the DSA master's RX filter, which for all practical purposes,
either needs to be in promiscuous mode, or the OCELOT_TAG_PREFIX_LONG
needs to be used for extraction, which makes the switch add a fake DMAC
of ff:ff:ff:ff:ff:ff so that the DSA master accepts the frame.

The issue with this design, of course, is that the CPU will be spammed
with frames that it doesn't want to respond to, and there isn't any
hardware offload in place by default to drop them.

What is being done in the VSC7514 Ocelot driver is a process of
selective whitelisting. The "MAC address" of each Ocelot switch net
device, with all VLANs installed on that port, is being added as a FDB
entry towards PGID_CPU.

PGID_CPU is is a multicast set containing only BIT(cpu). I don't know
why it was chosen to be a multicast PGID (59) and not simply the unicast
one of this port, but it doesn't matter. The point is that the the CPU
port is special, and frames are "copied" to the CPU, disregarding the
source masks (third PGID lookup), if BIT(cpu) is found to be set in the
destination masks (first PGID lookup).

Frames that match the FDB will go to PGID_CPU by virtue of the DEST_IDX
from the respective MAC table entry, and frames that don't will go to
PGID_UC or PGID_MC, by virtue of the FLD_UNICAST, FLD_BROADCAST etc
settings for flooding. And that is where the distinction is made:
flooded frames will be subject to the third PGID lookup, while frames
that are whitelisted to the PGID_CPU by the MAC table aren't.

So we can use this mechanism to simulate an RX filter, given that we are
subverting the DSA master's implicit one, as mentioned in the first
paragraph. But this has some limitations:

- In Ocelot each net device has its own MAC address. When simulating
  this with MAC table entries, it will practically result in having N
  MAC addresses for each of the N front-panel ports (because FDB entries
  are not per source port). A bit strange, I think.

- In DSA we don't have the infrastructure in place to support this
  whitelisting mechanism. Calling .port_fdb_add on the CPU port for each
  slave net device dev_addr isn't, in itself, hard. The problem is with
  the VLANs that this port is part of. We would need to keep a duplicate
  list of the VLANs from the bridge, plus the ones added from 8021q, for
  each port. And we would need reference counting on each MAC address,
  such that when a front-panel port changes its MAC address and we need
  to delete the old FDB entry, we don't actually delete it if the other
  front-panel ports are still using it. Not to mention that this FDB
  entry would have to be added on the whole net of upstream DSA switches.

- Cascading a different DSA switch that has tags before the Ethernet
  header would not possibly work if we rely on the whitelisting
  mechanism exclusively.

So... it's complicated. What this patch does is to simply allow frames
to be flooded to the CPU, which is anyway what the Ocelot driver is
doing after removing the bridge from the net devices, see this snippet
from ocelot_bridge_stp_state_set:

    /* Apply FWD mask. The loop is needed to add/remove the current port as
     * a source for the other ports.
     */
    for (p = 0; p < ocelot->num_phys_ports; p++) {
            if (p == ocelot->cpu || (ocelot->bridge_fwd_mask & BIT(p))) {
                    (...)
            } else {
                    /* Only the CPU port, this is compatible with link
                     * aggregation.
                     */
                    ocelot_write_rix(ocelot,
                                     BIT(ocelot->cpu),
                                     ANA_PGID_PGID, PGID_SRC + p);
            }

Otherwise said, the ocelot driver itself is already not self-coherent,
since immediately after probe time, and immediately after removal from a
bridge, it behaves in different ways, although the front panel ports are
standalone in both cases.

While standalone traffic _does_ work for the Felix DSA wrapper after
enslaving and removing the ports from a bridge, this patch makes
standalone traffic work at probe time too, with the caveat that even
irrelevant frames will get processed by software, making it more
susceptible to potential denial of service.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 86d543ab1ab9..94d39ccea017 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2297,6 +2297,18 @@ void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
 			 enum ocelot_tag_prefix injection,
 			 enum ocelot_tag_prefix extraction)
 {
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		/* Disable old CPU port and enable new one */
+		ocelot_rmw_rix(ocelot, 0, BIT(ocelot->cpu),
+			       ANA_PGID_PGID, PGID_SRC + port);
+		if (port == cpu)
+			continue;
+		ocelot_rmw_rix(ocelot, BIT(cpu), BIT(cpu),
+			       ANA_PGID_PGID, PGID_SRC + port);
+	}
+
 	/* Configure and enable the CPU port. */
 	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, cpu);
 	ocelot_write_rix(ocelot, BIT(cpu), ANA_PGID_PGID, PGID_CPU);
-- 
2.17.1

