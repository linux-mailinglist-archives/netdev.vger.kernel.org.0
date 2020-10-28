Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94A529E0FD
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732801AbgJ2BrT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Oct 2020 21:47:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35021 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732728AbgJ2BrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 21:47:18 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kXcX5-0003Gh-9K; Wed, 28 Oct 2020 03:53:55 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id C8A435FEE7; Tue, 27 Oct 2020 20:53:53 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id C19719FAC7;
        Tue, 27 Oct 2020 20:53:53 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     LIU Yulong <i@liuyulong.me>
cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: bonding: alb disable balance for IPv6 multicast related mac
In-reply-to: <1603850163-4563-1-git-send-email-i@liuyulong.me>
References: <1603850163-4563-1-git-send-email-i@liuyulong.me>
Comments: In-reply-to LIU Yulong <i@liuyulong.me>
   message dated "Wed, 28 Oct 2020 09:56:03 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22347.1603857233.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 27 Oct 2020 20:53:53 -0700
Message-ID: <22348.1603857233@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LIU Yulong <i@liuyulong.me> wrote:

>According to the RFC 2464 [1] the prefix "33:33:xx:xx:xx:xx" is defined to
>construct the multicast destination MAC address for IPv6 multicast traffic.
>The NDP (Neighbor Discovery Protocol for IPv6)[2] will comply with such
>rule. The work steps [6] are:
>  *) Let's assume a destination address of 2001:db8:1:1::1.
>  *) This is mapped into the "Solicited Node Multicast Address" (SNMA)
>     format of ff02::1:ffXX:XXXX.
>  *) The XX:XXXX represent the last 24 bits of the SNMA, and are derived
>     directly from the last 24 bits of the destination address.
>  *) Resulting in a SNMA ff02::1:ff00:0001, or ff02::1:ff00:1.
>  *) This, being a multicast address, can be mapped to a multicast MAC
>     address, using the format 33-33-XX-XX-XX-XX
>  *) Resulting in 33-33-ff-00-00-01.
>  *) This is a MAC address that is only being listened for by nodes
>     sharing the same last 24 bits.
>  *) In other words, while there is a chance for a "address collision",
>     it is a vast improvement over ARP's guaranteed "collision".
>Kernel related code can be found at [3][4][5].
>
>The current bond alb has some leaks of such MAC ranges which will cause
>the physical world failed to determain the back tunnel of the reply
>packet during the response in a Spine-and-Leaf data center architecture.
>The basic topology looks like this:
>
>        +-------------+
>        |             |
>    +---| Border Leaf |-----+
>    |   |             |     |
>    |   +-------------+     |
>    |                       |
>    | tunnel-1              | tunnel-2
>    |                       |
>    |                       |
>+---+----+           +------+-+
>|        |           |        |
>| Leaf1  +--X-X-X-X--+  Leaf2 |  tunnel-3 will be checked to prevent loop
>|        |  tunnel-3 |        |
>+--------+           +-+------+
>         |             |
>         |             |
>         |             |
>         |             |
>         |             |
>         |             |
>         +----+   +----+
>      +--+nic1+---+nic2+---+
>      |  +----+   +----+   |
>      |       bond6        |
>      |                    |
>      |       HOST         |
>      +--------------------+

	This description is, overall, very comprehensive, and I believe
I generally understand what issue you're fixing (which seems to be a
complicated means to cause MAC flapping), although I'm unclear on a few
details, below.

	However, if you could make the ASCII art smaller I think that
would be better.

>When nic1 is sending the normal IPv6 traffic to the gateway in Border leaf,
>the nic2 (slave) will send the NS packet out periodically, automatically
>and implicitly as well. This is an example packet sending from the slave
>nic2 which will broke the traffic.

	With this patch applied, what would happen if nic2 sends the
normal IPv6 traffic from the source MAC in question (because it is
tx-balanced there), and the Neighbor Solicitation multicast then goes
out via nic1?

>  ac:1f:6b:90:5c:eb > 33:33:ff:00:00:01, ethertype 802.1Q (0x8100),
>  length 90: vlan 205, p 0, ethertype IPv6, (hlim 255,
>  next-header ICMPv6 (58) payload length: 32)
>  fe80::f816:3eff:feba:2d8c > ff02::1:ff00:1:
>  [icmp6 sum ok] ICMP6, neighbor solicitation, length 32,
>  who has 240e:980:2f00:4000::1
>  source link-address option (1), length 8 (1): fa:16:3e:ba:2d:8c
>            0x0000:  fa16 3eba 2d8c
>        0x0000:  3333 ff00 0001 ac1f 6b90 5ceb 8100 00cd
>        0x0010:  86dd 6000 0000 0020 3aff fe80 0000 0000
>        0x0020:  0000 f816 3eff feba 2d8c ff02 0000 0000
>        0x0030:  0000 0000 0001 ff00 0001 8700 14d3 0000
>        0x0040:  0000 240e 0980 2f00 4000 0000 0000 0000
>        0x0050:  0001 0101 fa16 3eba 2d8c

	And perhaps trim out the hex dump here.

>MAC "fa:16:3e:ba:2d:8c" was first learnt at Leaf1 based on the underlay
>mechanism(BGP EVPN). When this example packet was sent to Border leaf and
>replied with dst_mac "fa:16:3e:ba:2d:8c", Leaf2 will try to send packet
>back to tunnel-3 at this point dropping happens because of the loop
>defense. All the original normal IPv6 traffic will be lead to the tunnel-2
>and then drop. Link is broken now.

	Where does MAC fa:16:3e:ba:2d:8c come from?  Is this the MAC
address of the bond itself?

	Assuming that "learnt at Leaf1" means that Leaf1 knows to
forward it to bond6:nic1, why does the loop defense drop the packet if
Leaf1 is on the forwarding path?

>This patch addresses such issue by check the entire MAC range definde by
>the RFC 2464. Adding a new helper method to check the first two octets
>are the value 3333. If the dest mac is matched, no balance will be
>enabled.
>
>[1] https://tools.ietf.org/html/rfc2464#section-7
>[2] https://tools.ietf.org/html/rfc4861
>[3] linux.git/tree/include/net/if_inet6.h#n209-n221
>[4] linux.git/tree/net/ipv6/ndisc.c#n291
>[5] linux.git/tree/net/ipv6/ndisc.c#n346-n348
>[6] https://en.citizendium.org/wiki/Neighbor_Discovery
>
>Signed-off-by: LIU Yulong <i@liuyulong.me>
>---
> drivers/net/bonding/bond_alb.c | 10 ++++------
> include/linux/etherdevice.h    | 12 ++++++++++++
> 2 files changed, 16 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>index 095ea51..a4a30bd 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -24,9 +24,6 @@
> #include <net/bonding.h>
> #include <net/bond_alb.h>
> 
>-static const u8 mac_v6_allmcast[ETH_ALEN + 2] __long_aligned = {
>-	0x33, 0x33, 0x00, 0x00, 0x00, 0x01
>-};
> static const int alb_delta_in_ticks = HZ / ALB_TIMER_TICKS_PER_SEC;
> 
> #pragma pack(1)
>@@ -1422,10 +1419,11 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
> 			break;
> 		}
> 
>-		/* IPv6 uses all-nodes multicast as an equivalent to
>-		 * broadcasts in IPv4.
>+		/* IPv6 multicast destination should disable the tx-balance since
>+		 * the pyhsical world may get into a mass status which will lead
>+		 * to the IPv6 traffic broken.

	I think this comment can be simplified to simply say that IPv6
multicast destinations should not be tx-balanced, which I suspect is the
real purpose.

> 		 */
>-		if (ether_addr_equal_64bits(eth_data->h_dest, mac_v6_allmcast)) {
>+		if (is_ipv6_multicast_ether_addr(eth_data->h_dest)) {
> 			do_tx_balance = false;
> 			break;
> 		}
>diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
>index 2e5debc..c6101ab 100644
>--- a/include/linux/etherdevice.h
>+++ b/include/linux/etherdevice.h
>@@ -178,6 +178,18 @@ static inline bool is_unicast_ether_addr(const u8 *addr)
> }
> 
> /**
>+ * is_ipv6_multicast_ether_addr - Determine if the Ethernet address is for
>+ *				  IPv6 multicast (rfc2464).
>+ * @addr: Pointer to a six-byte array containing the Ethernet address
>+ *
>+ * Return true if the address is a multicast for IPv6.
>+ */
>+static inline bool is_ipv6_multicast_ether_addr(const u8 *addr)
>+{
>+	return (addr[0] & addr[1]) == 0x33;
>+}

	I don't think this does what is intended.  It will return true
for a MAC that starts with any two values whose bitwise AND is 0x33,
e.g., 0x73 0x3b.  For IPv6 multicast, the first two octets of the MAC
must be exactly 0x33 0x33.

	-J

>+
>+/**
>  * is_valid_ether_addr - Determine if the given Ethernet address is valid
>  * @addr: Pointer to a six-byte array containing the Ethernet address
>  *
>-- 
>1.8.3.1

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
