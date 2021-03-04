Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D867032D786
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 17:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbhCDQTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 11:19:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:43224 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236776AbhCDQTQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 11:19:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614874710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=Ph0X5gqNyOqf6fekU+uajP+vU+Fw2ANmSMhUcr/2OiI=;
        b=qWEpdZyPx8DwPHWQW+azIsR2xbI2kUjzdYP52HHiUkY12gH15K9Pte+GP+Z2+hTMCdIZiS
        7Mn2rUXHPWDNwHyFe18eKJ5BPl3oJ2N6/5AqImYA/D7kf3ujZ0IoG4vExEtJmBbPNtWsAs
        Y4RpXjr8R3nid2iw6ulSjCPqfcuc/9g=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2F956AE05;
        Thu,  4 Mar 2021 16:18:30 +0000 (UTC)
Received: by incl.suse.cz (Postfix, from userid 1000)
        id 099E93F185; Thu,  4 Mar 2021 17:18:29 +0100 (CET)
Date:   Thu, 4 Mar 2021 17:18:28 +0100
From:   Jiri Wiesner <jwiesner@suse.com>
To:     netdev@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH net] ibmvnic: always store valid MAC address
Message-ID: <20210304161828.GA6104@incl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last change to ibmvnic_set_mac(), 8fc3672a8ad3, meant to prevent
users from setting an invalid MAC address on an ibmvnic interface
that has not been brought up yet. The change also prevented the
requested MAC address from being stored by the adapter object for an
ibmvnic interface when the state of the ibmvnic interface is
VNIC_PROBED - that is after probing has finished but before the
ibmvnic interface is brought up. The MAC address stored by the
adapter object is used and sent to the hypervisor for checking when
an ibmvnic interface is brought up.

The ibmvnic driver ignoring the requested MAC address when in
VNIC_PROBED state caused LACP bonds (bonds in 802.3ad mode) with more
than one slave to malfunction. The bonding code must be able to
change the MAC address of its slaves before they are brought up
during enslaving. The inability of kernels with 8fc3672a8ad3 to set
the MAC addresses of bonding slaves is observable in the output of
"ip address show". The MAC addresses of the slaves are the same as
the MAC address of the bond on a working system whereas the slaves
retain their original MAC addresses on a system with a malfunctioning
LACP bond.

Fixes: 8fc3672a8ad3 ("ibmvnic: fix ibmvnic_set_mac")
Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3bad762083c5..b6102ccf9b90 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1906,10 +1906,9 @@ static int ibmvnic_set_mac(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	if (adapter->state != VNIC_PROBED) {
-		ether_addr_copy(adapter->mac_addr, addr->sa_data);
+	ether_addr_copy(adapter->mac_addr, addr->sa_data);
+	if (adapter->state != VNIC_PROBED)
 		rc = __ibmvnic_set_mac(netdev, addr->sa_data);
-	}
 
 	return rc;
 }
-- 
2.26.2

