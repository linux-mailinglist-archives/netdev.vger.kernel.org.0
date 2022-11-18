Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE858630520
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbiKRXw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236941AbiKRXvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:51:13 -0500
Received: from mx0a-003ede02.pphosted.com (mx0a-003ede02.pphosted.com [205.220.169.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54545A8164
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 15:26:53 -0800 (PST)
Received: from pps.filterd (m0286615.ppops.net [127.0.0.1])
        by mx0b-003ede02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AIMvP8w006190
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 15:26:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=getcruise.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=ppemail;
 bh=bWpKgOkneiZicWYDrgFgoa/g0SjBiC94+UFTlEGlKUs=;
 b=slhOlaKbvA2otOqn0SZYMkB2pKkMSfRvB9GzffLXTCK67fdGZ212Rn968XFAF4vAfXlq
 x9CquqOfM14T4xgGvGV+hJOVWOv8XTVMAIhW6/kcWqxxiP2xfXa3kYalux4ju0bBO/xI
 NJIJyJVgmb13jkYQE2MX4VqFUn43r52ACrUqvqKBEo9pils7KAP37XvU+5ez2jCDObaj
 JrNl5CIcBrDYddkRG7C43507D4jHxyONt3vJxGc7QqYqduGzBvKctHypszOeyNiTz2fC
 XXFePYIyeQnLq68GcYPsVIRdJB2zo+IcmgqOu68MNwfgAEDNwGpXZpOMX01BXfTxRR+R 3Q== 
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
        by mx0b-003ede02.pphosted.com (PPS) with ESMTPS id 3kx0pegs9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 15:26:53 -0800
Received: by mail-pf1-f199.google.com with SMTP id z19-20020a056a001d9300b0056df4b6f421so3854113pfw.4
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 15:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=getcruise.com; s=google;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bWpKgOkneiZicWYDrgFgoa/g0SjBiC94+UFTlEGlKUs=;
        b=nicPVcFrLoBbu9Y2UonpGJGCad/3eU4xGXuDtpj6Z2PXteNoZ+0VpPEsZQRFgT/Zdq
         IfzAb4XFNflO46/lS5keNOwobUgMSxjvPV2G48FsAti1xPccOBwLFfPcy7rF5K8x7+1p
         0EZ3aYBrIOYbEOQXHf2Hnoyi5XjER0ahZDXzFieBKGsKiX31Ky0BHRQZdCiAy/D4vs2O
         H1v8ssoT0OWIBr+ea8UIJi0Ihyyc/21epRlluXIl/4H9CG3XBsYLVvRbGwcjPePfQALb
         O4ZT2e28yW/DorbQC87vVEJGvam72uDoaV+6DUq+kononNlDYzTXBLgm5dekGaVD3ieB
         Qx5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bWpKgOkneiZicWYDrgFgoa/g0SjBiC94+UFTlEGlKUs=;
        b=dmiFnwatuOsU3ubyxFsmvDxAs+bXJDbhZlWsxn17zJTYdp0qyHM1GItzkPfdkyv7qP
         QgaoZGWms6RYocwl3030K9W83dXi80XG1QQx452k61lo/NW0FFqFkeXmBjWaP5quk+EA
         RSL4poiBv2q+1/zEAbBSEdCe9abuULNYpbNde3tkeyM4myP+FrBNvkfv5xQKUAVel8iC
         2MxPCohqXZveAmRqE9gF5KZgcblb8GN/ObssXSLY+Xy9+sCHmGwXzY3jZpRe8+WcxIW2
         e3kXosH80mAR6d25oCLj9CJzT8GeYj69s3TSDUwIBKsGOzfU5A3A/u3st8VRrNIgCYTj
         zdTA==
X-Gm-Message-State: ANoB5pmgSBcIMBVpCgBli6EwHct/rzFepgRngjG8Su2hUwvZXc8vgOHr
        5eZU44paqL7d1R6eEh9p1tZzwljgpkm5WSmNFitYFFsb3Qp4jtSMY/2NSutA+XOZUW/+lDu5yge
        9kzNSMh84mEyEaXRW
X-Received: by 2002:a17:90b:2501:b0:213:2173:f431 with SMTP id ns1-20020a17090b250100b002132173f431mr15625472pjb.201.1668814009020;
        Fri, 18 Nov 2022 15:26:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6be0MaXUpaqA3apCD/6yNDEkINfFx/5zbH5l0+iEazoU5txhyaLkxFDu44u8X4lX3S7RZkcg==
X-Received: by 2002:a17:90b:2501:b0:213:2173:f431 with SMTP id ns1-20020a17090b250100b002132173f431mr15625354pjb.201.1668814006431;
        Fri, 18 Nov 2022 15:26:46 -0800 (PST)
Received: from 9RTVDW2-DT.corp.robot.car ([128.177.102.6])
        by smtp.gmail.com with ESMTPSA id x12-20020a17090300cc00b0016d773aae60sm4236491plc.19.2022.11.18.15.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 15:26:45 -0800 (PST)
From:   Steve Williams <steve.williams@getcruise.com>
To:     netdev@vger.kernel.org
Cc:     Steve Williams <steve.williams@getcruise.com>
Subject: [PATCH net-next] net/hanic: Add the hanic network interface for high availability links
Date:   Fri, 18 Nov 2022 15:26:39 -0800
Message-Id: <20221118232639.13743-1-steve.williams@getcruise.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-GUID: aSx6iOB7rCduIHakZe3hdz6Z8P4OhA3p
X-Proofpoint-ORIG-GUID: aSx6iOB7rCduIHakZe3hdz6Z8P4OhA3p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-18_08,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0 priorityscore=1501
 clxscore=1015 mlxlogscore=999 phishscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211180139
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a virtual device that implements support for 802.1cb R-TAGS
and duplication and deduplication. The hanic nic itself is not a device,
but enlists ethernet nics to act as parties in a high-availability
link. Outbound packets are duplicated and tagged with R-TAGs, then
set out the enlisted links. Inbound packets with R-TAGs have their
R-TAGs removed, and duplicates are dropped to complete the link. The
algorithm handles links being completely disconnected, sporadic packet
loss, and out-of-order arrivals.

To the extent possible, the link is self-configuring: It detects and
brings up streams as R-TAG'ed packets are detected, and creates streams
for outbound packets unless explicitly filtered to skip tagging.
---
 Documentation/networking/hanic.rst |  351 ++++++++++
 Documentation/networking/index.rst |    1 +
 MAINTAINERS                        |    6 +
 drivers/net/Kconfig                |   17 +
 drivers/net/Makefile               |    1 +
 drivers/net/hanic/Makefile         |   15 +
 drivers/net/hanic/hanic_dev.c      | 1006 ++++++++++++++++++++++++++++
 drivers/net/hanic/hanic_filter.c   |  172 +++++
 drivers/net/hanic/hanic_main.c     |  109 +++
 drivers/net/hanic/hanic_netns.c    |   58 ++
 drivers/net/hanic/hanic_priv.h     |  408 +++++++++++
 drivers/net/hanic/hanic_protocol.c |  350 ++++++++++
 drivers/net/hanic/hanic_streams.c  |  161 +++++
 drivers/net/hanic/hanic_sysfs.c    |  672 +++++++++++++++++++
 14 files changed, 3327 insertions(+)
 create mode 100644 Documentation/networking/hanic.rst
 create mode 100644 drivers/net/hanic/Makefile
 create mode 100644 drivers/net/hanic/hanic_dev.c
 create mode 100644 drivers/net/hanic/hanic_filter.c
 create mode 100644 drivers/net/hanic/hanic_main.c
 create mode 100644 drivers/net/hanic/hanic_netns.c
 create mode 100644 drivers/net/hanic/hanic_priv.h
 create mode 100644 drivers/net/hanic/hanic_protocol.c
 create mode 100644 drivers/net/hanic/hanic_streams.c
 create mode 100644 drivers/net/hanic/hanic_sysfs.c

diff --git a/Documentation/networking/hanic.rst b/Documentation/networking/hanic.rst
new file mode 100644
index 000000000000..16b04247b0b0
--- /dev/null
+++ b/Documentation/networking/hanic.rst
@@ -0,0 +1,351 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============
+HANIC DRIVER
+============
+
+Copyright |copy| 2022 Cruise LLC
+
+OVERVIEW
+========
+
+The hanic driver creates a virtual network interface that implements
+the high availability protocol 802.1cb, with vector matching. The
+idea is to create a hanic NIC, then enlist a pair of physical NIC
+devices to act at the redundant ports. The hanic NIC replaces the
+enlisted ports, and handles duplication and R-TAGS (outbound) and
+de-duplication and removing R-TAGS (inbound).
+
+The current implementation assumes that all outbound unicast traffic
+is to be R-TAGed and duplicated, so there is no need to define
+outbound streams explicitly. Arriving traffic that includes R-TAGs
+automatically call themselves out as 802.1cb traffic, so inbound
+streams don't need to be explicitly defined either.
+
+Inbound traffic that does not have an R-TAG is assumed to not be
+redundant, and is simply passed up the network stack.
+
+Broadcast Packets
+=================
+
+Outbound broadcast and multicast traffic is either sent out a single
+(prime or second mode) or duplicated without R-TAGS and sent out all
+the enlisted ports (flood mode). The appropriate mode depends on
+network topology. Broadcast packets are never R-TAGed by the hanic
+driver.
+
+Broadcast packets cannot be R-TAGed by the hanic driver, because there
+is not enough information in the stream identification process to
+properly identify a stream context for the R-TAG sequence
+number.
+
+Consider the example of a source MAC-A and destination MAC-B. MAC-A
+can send unicast packets to MAC-B and also broadcast packets to
+MAC-x. MAC-A identifies the outbound stream (and thus the scope for
+the R-TAG sequence number) by using the target address, so
+MAC-A-to-MAC-x is one stream, and MAC-A-to-MAC-B is a different
+stream.
+
+On the receiving (B) side, the hanic driver uses the source address to
+identify the stream. (The destination address is the host itself.)
+Thus, MAC-A-to-MAC-B and MAC-A-to-MAC-x map to the same
+stream. Now the R-TAGs don't match and the link breaks.
+
+A work-around would be to use both the source and destination MAC
+addresses, but that's beyond the scope of the 802.1cb standard, so
+other devices will not be able to communicate with the hanic
+driver. Therefore, broadcast (and multicast) packets cannot be
+R-TAGed.
+
+Special multicast handling
+==========================
+
+By default, multicast packets (outbound) are treated as broadcast
+packets, and are not R-TAGed. Their disposition follows the broadcast
+packet disposition setting.
+
+However, one can request that multicast packets be R-TAGed and
+replicated. Set the multicast_rtag setting, and multicast packets
+will be handled the same as unicast packets. This should only work
+if by design the network knows that will only be one source nic
+for any packets with a given multicast group. (There may obviously
+still be multiple receivers). If this constraint is true, then the
+objection in the broadcast case that the stream cannot be uniquely
+identified no longer applies, and R-TAGed multicast packets will
+work fine.
+
+If the multicast_rtag flag is set, it is still possible to set some
+multicast groups to avoid tagging by using the vlan and vmac filters
+to set the disposition.
+
+Special ARP handling
+====================
+
+ARP requests are broadcast, so are not R-TAGed. ARP replies, on the
+other hand, are unicast and can theoretically be R-TAGed. However,
+hanic detects outbound ARP replies and handles them based on the
+arp_rtag configuration flag. If this flag is set to 1, then ARP
+response packets are R-TAGed; if this flag is set to 0 (the default)
+they are sent out the primary port (prime mode), secondary port
+(second mode) or all the enlisted ports (flood mode), without R-TAGs.
+
+It is unlikely that the ARP requestor matching an ARP reply is an
+802.1CB protected stream, and even if it is, it should still be able
+to receive an untagged ARP reply packet. That's certainly the case
+with hanic. Thus, the default for arp_rtag is 0, and this is probably
+the best choice if the remotes are all hanic implementations. If the
+network requires all packets to be R-TAGed, set arp_rtag to 1 to force
+arp resposes to be R-TAGed. A hanic implementation will be able to
+understand and work with R-TAGed and not R-TAGed ARP responses, no
+matter how it is configured to handle outbound ARP replies.
+
+Output R-TAG filter
+===================
+
+In a realistic system, some destinations do not support 802.1cb,
+or don't need it. The hanic driver has a means to call out these
+destinations by vlan or by mac and vlan together. For example, if
+all the destinations on vlan=11 (0x000b) should not receive r-TAG'ed
+packets, then that can be arranged like so::
+
+  $ echo 000b: prime > /sys/class/net/\<nic\>/hanic/filters_vlan
+
+If you need to be more selective, then you can use the vmac filter
+to suppress tags::
+
+  $ echo 01:23:45:56:89:ab-000b: prime > /sys/class/net/<nic>/hanic/filter_vmac
+
+This filter does not affect inbound traffic, since the driver can
+already tell if a packet is R-TAG'ed and handle it appropriately.
+
+Creating interfaces
+===================
+
+The way to create interfaces is with a command like this::
+
+  $ echo +hanic0 > /sys/class/net/hanic_interfaces
+
+It is also possible to destroy interfaces thusly::
+
+  $ echo -hanic0 > /sys/class/net/hanic_interfaces
+
+
+Enlisting other ethernet ports to an interface
+==============================================
+
+The standard IP commands can be used to do the enlistment, like so::
+
+  $ ip link set sandlan0a master hanic0
+  $ ip link set sandlan0b master hanic0
+
+These commands enlist the sandlan0a and sandlan0b interfaces to the
+hanic0 interface. Interfaces remain enlisted until they are
+unregistered, or until the hanic interface is destroyed.
+
+The first NIC added to the hanic device is the prime NIC. This is
+the NIC that is used for broadcast and multicast traffic, unless the
+broadcast_port mode is changed to "flood".
+
+The default MAC address for the hanic NIC is that of the prime NIC,
+but the user mode may explicitly set the MAC address. Wherever the MAC
+address comes from, all the NICs are compelled to take on the MAC
+address of the master, so that they receive packets destined for the
+master.
+
+When a NIC is released, it is given the MAC address that it had when it
+was first enlisted, but NICs are not typically released.
+
+
+VLANS
+=====
+
+Hanic understands 802.1Q VLANs. Create hanic protected VLANs by
+starting with a regular hanic NIC (e.g. hanic0) and linking a VLAN
+like so::
+
+  $ ip link add link hanic0 name hanic0.11 type vlan id 11
+
+The hanic0.11 appears to the user like any other NIC, but it is linked
+to the hanic protocol; the hanic module will recognize packets going
+through this VLAN and handle the parts of the protocol that need VLAN
+awareness.
+
+It appears to the user that the VLAN is on top of the hanic driver,
+but the packets out and in will have the 802.1Q tags before the
+802.1cb R-TAGs, as expected. This works out because the Linux vlan
+module reaches around into the header to mark the tags. More
+correctly, one says that hanic0.11 is "linked" to hanic0, and not
+stacked.
+
+The statistics for vlan NICs (e.g. hanic0.11 above) are kept by the
+hanic driver and made available via the underlying interface (hanic0).
+So the hanic interface streams and statistics for the hanic lan and
+all bound vlans are found in the /sys/class/net/hanic0/hanic/ directory.
+
+SYSFS interface
+===============
+
+* /sys/class/net/hanic_interfaces [rw]
+
+Read this file to get the hanic interfaces that exist. Write this file
+to create or destroy hanic interfaces.
+
+* /sys/class/net/<nic>/hanic/broadcast_port [rw]
+
+Read this file to find out how outbound broadcast (and multicast)
+packets are handled. If the value is "flood", then the packets are
+sent out all the NICs. Otherwise, the value is the number for the port
+that is used for broadcast.
+
+* /sys/class/net/<nic>/hanic/arp_rtag [rw] (bool)
+
+Normally, ARP response packets are not R-TAG'ed an are instead
+disposed out the broadcast port. If this flag is set to 1, the ARP
+packet is instead R-TAG'ed. This will create a destination stream if
+needed, R-TAGs will be inserted to the outbound ARP response, and the
+packet will be sent redundantly.
+
+* /sys/class/net/<nic>/hanic/multicast_rtag [rw] (bool)
+
+Normally, multicast packets are not R-TAG'ed and are instead
+disposed out the broadcast port. If this flag is set to 1, multicast
+packets are instead R-TAG'ed. This will create a destination stream if
+needed, R-TAGs will be inserted to the outbound packet, and the
+packet will be sent redundantly.
+
+* /sys/class/net/<nic>/hanic/ports [r]
+
+Read this file to see the NICs bound to the hanic device, one port
+per line.
+
+* /sys/class/net/<nic>/hanic/stream-xx:xx:xx:xx:xx:xx-vvvv [r]
+
+There is a file like this for every active stream, which contains
+802.1cb stream specific statistics. The file name is made up from
+the mac address (6 bytes) and a vlan id (2 bytes). A vlan of 0 means
+no vlan at all.
+
+* /sys/class/net/<nic>/hanic/filter_vlan [rw]
+
+This contains vlan filters. Each line is the format::
+
+  vvvv: mode
+
+where vvvv is the vlan in hex, and mode is the port to use. Outbound
+packets that match this vlan are sent out this port without replication
+and 802.1cb outbound processing is skipped. (This does not affect inbound
+traffic.) The valid modes are:
+
+| Mode   | Meaning                           |
+| +---   | +------                           |
+| none   | Remove from the filter            |
+| <N>    | Send untagged out port <N>        |
+| flood  | Send untagged out all the ports   |
+
+* /sys/class/net/\<nic\>/hanic/filter_vmac [rw]
+
+This contains vlan filters. Each line is the format:
+
+  xx:xx:xx:xx:xx:xx-vvvv: mode
+
+where xx..xx is the target mac address and vvvv is the vlan in
+hex; and mode is the port to use. Outbound packets that match
+this vlan are sent out this port without replication and 802.1cb
+outbound processing is skipped. (This does not affect inbound
+traffic.) The valid modes are:
+
+| Mode   | Meaning                           |
+| +---   | +------                           |
+| none   | Remove from the filter            |
+| <N>    | Send untagged out port <N>        |
+| flood  | Send untagged out all the ports   |
+
+* /sys/class/net/\<nic\>/hanic/jiffies_per_hanic_tick [r]
+
+This is the period, measured in Linux Jiffies, of the 802.1cb timer.
+The TicksPerSecond described in IEEE Std 802.1CB-2017 section 7.4.3.2.5
+is a frequency, and is (HZ / jiffies_per_hanic_tick).
+
+* /sys/class/net/\<nic\>/hanic/ticks_per_reset [rw]
+
+This is the hanic equivalent of frerSeqRcvyResetMSec. It is the number
+of hanic ticks of inactivity before deciding to reset the vector recovery
+algorithm. The frerSeqRcvyResetMSec value can be calculated as::
+
+  frerSeqRcvyResetMSec = (1000.0*jiffies_per_hanic_tick*ticks_per_reset)/HZ
+
+This value can be written to set the set the ticks_per_reset (and thus
+change the frerSeqRcvyResetMSec value) so long as this value is 2 or
+more. This implies that there is a minimum value defined by the HZ of
+the Linux/CPU combination and other compile time constants. For ARM,
+with HZ=250, jiffies_per_hanic_tick==2, so frerSeqRcvyResetMSec>=16.
+(The default is much larger.)
+
+* /sys/class/net/\<nic\>/hanic/test_drop_packet_in
+
+Inject faults by dropping input packets from some port. Write to this
+file the port number and the number of packets to drop. For example,
+to tell port 1 to drop the next 5 input packets::
+
+  % echo 1 5 > test_drop_packet_in
+
+To cancel any further packet drops, replace the number with 0::
+
+  % echo 1 0 > test_drop_packet_in
+
+Read the file to see how many drops remain for all the ports::
+
+  % cat test_prop_packet_in
+  0 0
+  1 5
+  2 0
+  3 0
+
+* /sys/class/net/\<nic\>/hanic/test_drop_packet_out
+
+Inject faults by dropping output packets to some port. Write to this
+file the port number and the number of packets to drop. For example,
+to tell port 1 to drop the next 5 output packets::
+
+  % echo 1 5 > test_drop_packet_out
+
+This fault injection only affects packets that are replicated. So for
+example packets that are routed through one port or the other via
+filters are immune to this fault injection.
+
+To cancel any further packet drops, replace the number with 0::
+
+  % echo 1 0 > test_drop_packet_out
+
+Read the file to see how many drops remain for all the ports::
+
+  % cat test_prop_packet_out
+  * 0
+  0 0
+  1 5
+  2 0
+  3 0
+
+As a special case, one can also request that _all_ replicated packets
+are dropped. This would test the remote's ability to detect or at least
+cope with lost packets. Invoke this feature by setting the ' * ' port to
+drop packets::
+
+  % echo '* 1' > test_drop_packet_out
+  % cat test_prop_packet_out
+  * 1
+  0 0
+  1 0
+  2 0
+  3 0
+
+The R-TAG sequence number for the fully dropped packet will be counted
+as if it was transmitted, so the loss of packets will be reflected in the
+R-TAG value of the packet that does get transmitted.
+
+Notes
+=====
+
+The IPv6 protocol engine has some implicit multicast packets that
+are generated, in the range 33:33:xx:xx:xx:xx. These are not R-TAGed
+outbound, even when multicast_rtag is enabled.
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 4f2d1f682a18..4c5df4e7da1e 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -56,6 +56,7 @@ Contents:
    generic_netlink
    gen_stats
    gtp
+   hanic
    ila
    ioam6-sysctl
    ipddp
diff --git a/MAINTAINERS b/MAINTAINERS
index 14ee1c72d01a..b59f8c11cee4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8960,6 +8960,12 @@ Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
 F:	drivers/media/usb/hackrf/
 
+HANIC NET DEVICE
+M:	Steve Williams <steve.williams@getcruise.com>
+S:	Maintained
+F:	Documentation/networking/hanic.rst
+F:	drivers/net/hanic/
+
 HANTRO VPU CODEC DRIVER
 M:	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
 M:	Philipp Zabel <p.zabel@pengutronix.de>
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 9e63b8c43f3e..8cc990921032 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -631,4 +631,21 @@ config NETDEV_LEGACY_INIT
 	  Drivers that call netdev_boot_setup_check() should select this
 	  symbol, everything else no longer needs it.
 
+config HANIC
+       tristate "Cruise High Availability NIC driver"
+       depends on INET
+       help
+         Support for the HANIC module. This driver creates virtual
+	 devices that enlist physical NIC interfaces and combines
+	 them to implement the IEEE 802.1cb frame replication and
+	 elimination protocol, without any special hardware support.
+
+config HANIC_FAULT_INJECTION
+       bool "Enable fault injection interfaces for the hanic driver"
+       depends on HANIC
+       help
+       Include with the HANIC module support for fault injection.
+       This is a debug aid that allows testers to introduce faults
+       in the form of dropped packets.
+
 endif # NETDEVICES
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 6ce076462dbf..d6b1ec66f3cf 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -89,3 +89,4 @@ thunderbolt-net-y += thunderbolt.o
 obj-$(CONFIG_USB4_NET) += thunderbolt-net.o
 obj-$(CONFIG_NETDEVSIM) += netdevsim/
 obj-$(CONFIG_NET_FAILOVER) += net_failover.o
+obj-$(CONFIG_HANIC) += hanic/
diff --git a/drivers/net/hanic/Makefile b/drivers/net/hanic/Makefile
new file mode 100644
index 000000000000..ba209987c06d
--- /dev/null
+++ b/drivers/net/hanic/Makefile
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# Copyright (c) 2020 Cruise, LLC
+# Auther: steve.williams@getcruise.com
+
+
+obj-$(CONFIG_HANIC) += hanic.o
+
+hanic-objs := hanic_main.o \
+	hanic_dev.o \
+	hanic_filter.o \
+	hanic_netns.o \
+	hanic_protocol.o \
+	hanic_streams.o \
+	hanic_sysfs.o
diff --git a/drivers/net/hanic/hanic_dev.c b/drivers/net/hanic/hanic_dev.c
new file mode 100644
index 000000000000..9e35fed8d5ed
--- /dev/null
+++ b/drivers/net/hanic/hanic_dev.c
@@ -0,0 +1,1006 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 Cruise LLC
+ * Author: Steve Williams <steve.williams@getcruise.com>
+ */
+
+#include "hanic_priv.h"
+
+#include <linux/version.h>
+#include <linux/if_arp.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/rtnetlink.h>
+#include <linux/if_vlan.h>
+#include <linux/rwlock.h>
+
+/* The interface for dev_open changed at version 5.0.0.
+ */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 0, 0)
+#define DEV_OPEN(eport) dev_open((eport), 0)
+#else
+#define DEV_OPEN(eport) dev_open((eport))
+#endif
+
+/* The default value for ARP_RTAG can be 0 (do not R-TAG) or
+ * 1 (R-TAG arp responses). The value can be set at run time
+ * per interface through the sysfs API.
+ */
+#define ARP_RTAG_DEFAULT 0
+
+/* The default value for MULTICAST_RTAG can be 0 (do not R-TAG)
+ * or 1 (R-TAG multicast packets). The value can be set at run
+ * time per interface through the sysfs API.
+ */
+#define MULTICAST_RTAG_DEFAULT 0
+
+/* Find the R-TAG in the output stream. Also, while we're at it, find
+ * any VLAN tag (802.1Q) and extract the VLAN.
+ *
+ * R-TAG without 802.1Q VLAN tag:
+ *    +---------+---------+---------+-----------+---- . . .
+ *    | d d d d | d d s s | s s s s | f1 c1 0 0 | x x . . .
+ *    +---------+---------+---------+-----------+---- . . .
+ *
+ * R-TAG with 802.1Q VLAN tag:
+ *    +---------+---------+---------+-----------+-----------+---- . . .
+ *    | d d d d | d d s s | s s s s | 81 00 v v | f1 c1 0 0 | x x . . .
+ *    +---------+---------+---------+-----------+-----------+---- . . .
+ */
+static unsigned char *find_header_rtag(const struct sk_buff *skb,
+				       uint16_t *vlan)
+{
+	unsigned char *dp = skb_mac_header(skb);
+
+	/* R-TAG without VLAN tag. */
+	if (test_net2bytes(dp + 12, ETH_P_RTAG)) {
+		*vlan = 0;
+		return dp + 12;
+	}
+
+	/* R-TAG with VLAN tag. */
+	if (test_net2bytes(dp + 12, ETH_P_8021Q) &&
+	    test_net2bytes(dp + 16, ETH_P_RTAG)) {
+		*vlan = ((dp[14] << 8) + dp[15]) & VLAN_VID_MASK;
+		return dp + 16;
+	}
+
+	/* No R-TAG */
+	*vlan = 0;
+	return 0;
+}
+
+/* This is a table of all the hanic interfaces that exist. */
+static struct list_head hanic_devs_list;
+static rwlock_t hanic_devs_mutex;
+
+/* Add the device to a global table of hanic devices. */
+static void add_dev_to_list(struct net_device *dev)
+{
+	struct hanic_priv *xsp = netdev_priv(dev);
+
+	write_lock(&hanic_devs_mutex);
+	list_add_tail(&xsp->devs_list, &hanic_devs_list);
+	write_unlock(&hanic_devs_mutex);
+}
+
+static int hanic_open(struct net_device *dev)
+{
+	int idx;
+	struct hanic_priv *xsp = netdev_priv(dev);
+
+	xsp->rx_packets = 0;
+	xsp->tx_packets = 0;
+	xsp->rx_bytes = 0;
+	xsp->tx_bytes = 0;
+	xsp->rx_dropped = 0;
+	xsp->tx_dropped = 0;
+
+	netif_start_queue(dev);
+
+	/* Make sure the ports are open as well. */
+	for (idx = 0; idx < HANIC_PORT_MAX; idx += 1) {
+		int rc;
+		struct net_device *port = xsp->ports[idx].sl_dev;
+
+		if (port == 0)
+			continue;
+
+		rc = DEV_OPEN(port);
+		if (rc < 0) {
+			netdev_warn(dev,
+				    "Error (errno=%d) bringing up port %s.\n",
+				    -rc, port->name);
+		}
+	}
+
+	return 0;
+}
+
+static int hanic_stop(struct net_device *dev)
+{
+	int idx;
+	struct hanic_priv *xsp = netdev_priv(dev);
+
+	for (idx = 0; idx < HANIC_PORT_MAX; idx += 1) {
+		struct net_device *port = xsp->ports[idx].sl_dev;
+
+		if (port == 0)
+			continue;
+		dev_close(port);
+	}
+
+	netif_stop_queue(dev);
+	return 0;
+}
+
+/* Is the packet an ARP protocol packet? Look in the ethertype field
+ * of the buffer for the ethertype. If it's ETH_P_ARP, it's an ARP
+ * packet. Otherwise, it is not.
+ */
+static inline int packet_is_arp(struct sk_buff *skb)
+{
+	const unsigned char *dp = skb_mac_header(skb);
+
+	if (test_net2bytes(dp + 12, ETH_P_ARP))
+		return 1;
+
+	return 0;
+}
+
+/* An outbound packet is not taggable if it is a broadcast packet, or
+ * if it is a multicast packet. Broadcast packets don't suffer R-TAGs
+ * well, and multicast packets mostly behave like broadcast packets.
+ *
+ * However, if the administrator can make some guarantees about
+ * multicast groups, then we can allow multicast packets to be
+ * tagged. That situation is flagged by the multicast_rtag flag.
+ *
+ * Is the packet a broadcast/multicast packet? IEEE 802 MAC
+ * addresses can be quickly tested for this feature by looking at the
+ * LSB of the first octet of the MAC address. If the bit is set, it is
+ * multicast or broadcast.
+ */
+static inline int packet_broadcast(struct sk_buff *skb, struct net_device *dev)
+{
+	struct hanic_priv *xsp = netdev_priv(dev);
+
+	/* Not broadcast/multicast? */
+	if (likely(is_unicast_ether_addr(skb_mac_header(skb))))
+		return 0;
+
+	/* if multicast_rtag==0, then multicast is treated like broadcast. */
+	if (xsp->multicast_rtag == 0)
+		return 1;
+
+	if (is_broadcast_ether_addr(skb_mac_header(skb)))
+		return 1;
+
+	/* Treat IPv6 multicast addresses as broadcast. */
+	if (test_net2bytes(skb_mac_header(skb), 0x3333))
+		return 1;
+
+	return 0;
+}
+
+static unsigned char *try_insert_rtag(struct sk_buff *skb,
+				      struct net_device *dev, uint16_t *vlan,
+				      hanic_packet_disposition_t *disposition)
+{
+	struct hanic_priv *xsp = netdev_priv(dev);
+	struct hanic_filter_item *filter;
+	unsigned char *rtag;
+	unsigned char *dp;
+	size_t prefix_len;
+
+	/* Don't R-TAG broadcast packets.
+	 * It should be impossible to see broadcast packets, but
+	 * certain error handling paths may allow them through, so
+	 * program defensively.
+	 */
+	if (packet_broadcast(skb, dev)) {
+		*disposition = xsp->broadcast_disp;
+		return NULL;
+	} else if (xsp->arp_rtag == 0 && packet_is_arp(skb)) {
+		*disposition = xsp->broadcast_disp;
+		return NULL;
+	}
+
+	/* Figure out how big the MAC header is, also accounting
+	 * for the VLAN tag, if present. (We also need that vlan
+	 * value.)
+	 */
+	dp = skb_mac_header(skb);
+	prefix_len = 12;
+	*vlan = 0;
+	if (test_net2bytes(dp + prefix_len, ETH_P_8021Q)) {
+		*vlan = get_unaligned_be16(dp + prefix_len + 2) & VLAN_VID_MASK;
+		prefix_len += 4;
+	}
+
+	/* Test the vlan and destination mac address to see if the
+	 * filter is suppressing the R-TAG for this packet. If the
+	 * filter is present, then use the stored disposition, and
+	 * signal to the caller that no R-TAG will happen here.
+	 */
+	*disposition = HANIC_DISP_FLOOD;
+	filter = hanic_test_filter_vlan(xsp, *vlan);
+	if (filter == NULL)
+		filter = hanic_test_filter_vmac(xsp, dp, *vlan);
+
+	if (filter) {
+		*disposition = filter->disposition;
+		return NULL;
+	}
+
+	/* Shift the prefix (the ethernet mac and possible vlan tag)
+	 * forward to make room for the R-TAG, and write a stub R-TAG
+	 * in place. Don't bother with the R-TAG contents, the caller
+	 * will fill that in.
+	 */
+	dp = skb_push(skb, RTAG_HLEN);
+	if (dp == 0) {
+		netdev_warn(dev, "%s: Error inserting prefix bytes.\n",
+			    __func__);
+		return NULL;
+	}
+
+	memmove(dp, dp + RTAG_HLEN, prefix_len);
+	skb->mac_header -= RTAG_HLEN;
+
+	rtag = dp + prefix_len;
+	put_unaligned_be16(ETH_P_RTAG, rtag);
+
+	/* Clean up the skb */
+	skb_reset_mac_header(skb);
+	skb_reset_mac_len(skb);
+
+	return rtag;
+}
+
+/* At this point, the skb is tagged as necessary and ready to flood
+ * out all the network ports.
+ */
+static int dev_queue_flood(struct sk_buff *skb, struct net_device *dev)
+{
+	struct hanic_priv *xsp = netdev_priv(dev);
+	int idx;
+
+	/* Special case: If we are injecting flood faults, then this
+	 * packet is meant to be dropped. Free the skb without sending
+	 * any packets at all.
+	 */
+	if (unlikely(test_drop_flood_out(xsp))) {
+		net_info_ratelimited(
+			"%s: FAULT INJECTION: Drop output packet on all ports.\n",
+			dev->name);
+		dev_kfree_skb(skb);
+		return 0;
+	}
+
+	/* Deliver packet clones through all the enlisted ports. */
+	for (idx = 0; idx < xsp->ports_count; idx += 1) {
+		struct net_device *port = xsp->ports[idx].sl_dev;
+		struct sk_buff *skb2;
+
+		/* Fault injection: inject output fault. */
+		if (unlikely(test_drop_packet_out(xsp, idx))) {
+			net_info_ratelimited(
+				"%s: FAULT INJECTION: Drop output packet on port %d (%s).\n",
+				dev->name, idx, port->name);
+			continue;
+		}
+
+		skb2 = skb_clone(skb, GFP_ATOMIC);
+		if (skb2 == 0) {
+			net_warn_ratelimited(
+				"%s: Replication failed on transmit.\n",
+				dev->name);
+			continue;
+		}
+		skb2->dev = port;
+		dev_queue_xmit(skb2);
+	}
+
+	/* No longer need the skb. */
+	dev_kfree_skb(skb);
+
+	return 0;
+}
+
+/* Start transmit -- The skb already contains a fully formatted
+ * packet, we just need to deliver it to the "wire". In this case,
+ * that means handing it over to enlisted ports for transmit. All the
+ * ports get a copy of the buffer to transmit so that they can run in
+ * parallel.
+ *
+ * If the destination is broadcast or multicast, then possibly handle
+ * the packet differently.
+ */
+static int do_hanic_start_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct hanic_priv *xsp = netdev_priv(dev);
+	struct hanic_stream_item *stream;
+	unsigned char *rtag;
+	uint16_t use_seq_num;
+	uint16_t outbound_vlan;
+	hanic_packet_disposition_t disposition;
+
+	/* If there are no enlisted ports, drop the packet. */
+	if (unlikely(xsp->ports_count <= 0)) {
+		xsp->tx_dropped += 1;
+		net_info_ratelimited(
+			"%s: No enlisted ports to transmit packet.\n",
+			dev->name);
+		return 0;
+	}
+
+	/* Count the packets and data. Don't count the duplicates. */
+	xsp->tx_packets += 1;
+	xsp->tx_bytes += skb->len;
+
+	/* If the packet is broadcast (or multicast) and we are not
+	 * flooding, then use the broadcast_disp to guide our choice
+	 * of an enlisted port. Do this handling early so that we
+	 * do not waste effort checking for tags.
+	 */
+	if (packet_broadcast(skb, dev)) {
+		if (hanic_disp_is_flood(xsp->broadcast_disp))
+			return dev_queue_flood(skb, dev);
+
+		skb->dev = hanic_disp_port(xsp, xsp->broadcast_disp);
+		dev_queue_xmit(skb);
+		return 0;
+	}
+
+	/* Look for an existing R-TAG. If it is not present, check if
+	 * we need to add it. It is possible for the R-TAG to already
+	 * be present if this is a retransmit. (Think TCP.) Also
+	 * figure out the disposition. Normally, these packets will be
+	 * flooded out, but if there is a filter, the try_insert_rtag
+	 * will set a more specific disposition.
+	 */
+	disposition = HANIC_DISP_FLOOD;
+	rtag = find_header_rtag(skb, &outbound_vlan);
+	if (rtag == NULL)
+		rtag = try_insert_rtag(skb, dev, &outbound_vlan, &disposition);
+
+	/* No R-TAG? Then this is a non-replicated packet. Depending
+	 * on the disposition configuration, send this out a single
+	 * port, or flood it to all the enlisted ports.
+	 */
+	if (rtag == NULL) {
+		if (hanic_disp_is_flood(disposition))
+			return dev_queue_flood(skb, dev);
+
+		skb->dev = hanic_disp_port(xsp, disposition);
+		dev_queue_xmit(skb);
+		return 0;
+	}
+
+	/* Do the final fixup of the R-TAG, if it is present. The
+	 * try_insert_rtag function installed the R-TAG, but as a stub
+	 * for the sequence number. Here, we put the proper seqno
+	 * value into the header. This is done here to catch
+	 * retransmissions of packets.
+	 */
+	if (rtag) {
+		unsigned char *dp = skb_mac_header(skb);
+		unsigned long flags;
+
+		spin_lock_irqsave(&xsp->stream_table_lock, flags);
+		stream = hanic_map_stream(xsp, dp, outbound_vlan);
+		if (stream) {
+			use_seq_num = stream->out_seq_num++;
+			stream->stats.tx_send += 1;
+			spin_unlock_irqrestore(&xsp->stream_table_lock, flags);
+
+			/* rtag[0]:rtag[1] is ETH_P_RTAG */
+			put_unaligned_be16(0, rtag + 2);
+			put_unaligned_be16(use_seq_num, rtag + 4);
+
+		} else {
+			spin_unlock_irqrestore(&xsp->stream_table_lock, flags);
+			net_info_ratelimited("%s: R-TAG on outbound packet "
+					     "with no matching stream.\n",
+					     dev->name);
+		}
+	}
+
+	return dev_queue_flood(skb, dev);
+}
+
+static int hanic_start_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	int rc;
+
+	read_lock(&hanic_devs_mutex);
+	rc = do_hanic_start_xmit(skb, dev);
+	read_unlock(&hanic_devs_mutex);
+	return rc;
+}
+
+/* Set the mac address of the hanic device. If that works, then set
+ * the mac address of all the enlisted ports as well so that they
+ * follow the master.
+ */
+static int hanic_set_mac_address(struct net_device *dev, void *addr)
+{
+	int idx;
+	struct hanic_priv *xsp = netdev_priv(dev);
+	int rc = eth_mac_addr(dev, addr);
+
+	if (rc < 0)
+		return rc;
+
+	read_lock(&hanic_devs_mutex);
+
+	/* Set the enlisted ports to the masters new address. */
+	for (idx = 0; idx < HANIC_PORT_MAX; idx += 1) {
+		struct net_device *port = xsp->ports[idx].sl_dev;
+
+		if (port == NULL)
+			continue;
+
+		port->netdev_ops->ndo_set_mac_address(port, addr);
+	}
+
+	read_unlock(&hanic_devs_mutex);
+
+	return rc;
+}
+
+/* Enlist a port. This can be called as a Network Device Operation (ndo)
+ * in response to commands like this:
+ *
+ *    ip link set <port> master <dev>
+ */
+static int hanic_add_port(struct net_device *dev, struct net_device *port,
+			  struct netlink_ext_ack *extack)
+{
+	int port_idx;
+	struct hanic_priv *xsp = netdev_priv(dev);
+
+	if (dev == port) {
+		NL_SET_ERR_MSG(extack, "Cannot enlist port to itself.");
+		netdev_info(dev, "Cannot enlist port to itself.\n");
+		return -EPERM;
+	}
+
+	if (port->flags & IFF_UP) {
+		NL_SET_ERR_MSG(extack, "Cannot enlist port while it is up.");
+		netdev_info(dev, "Cannot enlist %s while it is up.\n",
+			    port->name);
+		return -EPERM;
+	}
+
+	if (port->flags & IFF_SLAVE) {
+		NL_SET_ERR_MSG(extack, "Interface is already enlisted.");
+		netdev_info(dev, "Interface %s is already enlisted.\n",
+			    port->name);
+		return -EPERM;
+	}
+
+	/*
+	 * This prevents enslaving other masters, which could lead to
+	 * locking messes.
+	 */
+	if (port->flags & IFF_MASTER) {
+		NL_SET_ERR_MSG(extack, "Interface is already a master.");
+		netdev_info(dev, "Interface %s is a master.\n", port->name);
+		return -EPERM;
+	}
+
+	if (port->type != ARPHRD_ETHER) {
+		NL_SET_ERR_MSG(extack, "Sorry, only Ethernet ports supported.");
+		netdev_info(dev, "Sorry, expecting %s to be Ethernet.\n",
+			    port->name);
+		return -EINVAL;
+	}
+
+	if (netdev_is_rx_handler_busy(port)) {
+		NL_SET_ERR_MSG(extack,
+			       "Interface is busy and cannot be enlisted.");
+		netdev_info(dev,
+			    "Interface %s is busy and cannot be enlisted.\n",
+			    port->name);
+		return -EBUSY;
+	}
+
+	if (port->netdev_ops->ndo_set_mac_address == 0) {
+		NL_SET_ERR_MSG(
+			extack,
+			"Sorry, enlisted port must support setting MAC address.\n");
+		netdev_info(
+			dev,
+			"Sorry, enlisted port %s doesn't support set_mac_address.\n",
+			port->name);
+		return -EINVAL;
+	}
+
+	if (unlikely(dev->addr_len != port->addr_len)) {
+		NL_SET_ERR_MSG(extack, "Strange addr_len?\n");
+		netdev_info(dev, "Port %s address format mismatch\n",
+			    port->name);
+		return -EINVAL;
+	}
+
+	write_lock(&hanic_devs_mutex);
+
+	if (xsp->ports_count >= HANIC_PORT_MAX) {
+		write_unlock(&hanic_devs_mutex);
+		NL_SET_ERR_MSG(extack, "Too many enlisted ports");
+		netdev_info(dev, "Too many enlisted ports.\n");
+		return -EINVAL;
+	}
+
+	port_idx = xsp->ports_count++;
+
+	port->flags |= IFF_SLAVE;
+
+	/* Save the port identity for when it is released. */
+	xsp->ports[port_idx].sl_dev = port;
+	xsp->ports[port_idx].ha_dev = dev;
+	memcpy(xsp->ports[port_idx].sl_save_addr, port->dev_addr,
+	       port->addr_len);
+	init_port_fault_injection(xsp, port_idx);
+
+	if (port_idx == 0) {
+		struct sockaddr use_addr;
+
+		/* First enlisted port, so take on that port's identity. */
+		use_addr.sa_family = AF_UNSPEC;
+		memcpy(use_addr.sa_data, port->dev_addr, port->addr_len);
+		eth_mac_addr(dev, &use_addr);
+
+		/* Take on this port's hw features. */
+		dev->features = port->features;
+		dev->hw_features = port->hw_features;
+		dev->max_mtu = port->max_mtu - RTAG_HLEN;
+		dev->min_mtu = port->min_mtu;
+		dev->mtu = dev->max_mtu;
+
+	} else {
+		int rc;
+		struct sockaddr use_addr;
+
+		/* Newly enlisted ports take on the identity of the master. */
+
+		use_addr.sa_family = AF_UNSPEC;
+		memcpy(use_addr.sa_data, dev->dev_addr, dev->addr_len);
+
+		rc = port->netdev_ops->ndo_set_mac_address(port, &use_addr);
+		if (rc < 0) {
+			netdev_info(dev, "Error (rc=%d) setting %s MAC.\n", rc,
+				    port->name);
+		}
+
+		/* New port constrains master's features. */
+		dev->hw_features &= port->hw_features;
+		if (dev->max_mtu > (port->max_mtu - RTAG_HLEN))
+			dev->max_mtu = port->max_mtu - RTAG_HLEN;
+		if (dev->min_mtu < port->min_mtu)
+			dev->min_mtu = port->min_mtu;
+		if (dev->mtu > dev->max_mtu)
+			dev->mtu = dev->max_mtu;
+	}
+
+	hanic_add_protocol_to_port(xsp, port_idx);
+
+	write_unlock(&hanic_devs_mutex);
+
+	/* If I (the master) am UP, then open the enlisted port. */
+	if (dev->flags & IFF_UP) {
+		int rc;
+
+		rc = DEV_OPEN(port);
+		if (rc < 0) {
+			netdev_warn(dev,
+				    "Error (errno=%d) bringing up port %s.\n",
+				    -rc, port->name);
+		}
+	}
+
+	return 0;
+}
+
+/* Delete an enlisted port.
+ * This unbinds the device from the hanic device.
+ * This might be called as an NDO operation, or directly by cleanup
+ * functions internal to the driver. When a port is released, give
+ * its identity back.
+ *
+ * ** MUST be locked by caller **
+ */
+static int do_hanic_del_port(struct net_device *dev, struct net_device *port)
+{
+	struct hanic_priv *xsp = netdev_priv(dev);
+	struct sockaddr use_addr;
+	int port_idx;
+
+	for (port_idx = 0; port_idx < xsp->ports_count; port_idx += 1) {
+		if (xsp->ports[port_idx].sl_dev == port)
+			break;
+	}
+
+	if (port_idx >= xsp->ports_count) {
+		netdev_info(dev, "Interface %s is not enlisted to me.\n",
+			    port->name);
+		return -ENODEV;
+	}
+
+	/* If the port is UP when I remove it, then bring it down. */
+	if ((port->flags & IFF_UP) == IFF_UP)
+		dev_close(port);
+
+	hanic_remove_protocol_from_port(xsp, port_idx);
+
+	port->flags &= ~IFF_SLAVE;
+	xsp->ports[port_idx].sl_dev = 0;
+	xsp->ports[port_idx].ha_dev = 0;
+
+	/* Give the released port its old identity back. */
+	use_addr.sa_family = AF_UNSPEC;
+	memcpy(use_addr.sa_data, xsp->ports[port_idx].sl_save_addr,
+	       dev->addr_len);
+	port->netdev_ops->ndo_set_mac_address(port, &use_addr);
+
+	/* Decrement port count and shift the top of the
+	 * table down to fill the hole.
+	 */
+	xsp->ports_count -= 1;
+	if (xsp->ports_count > port_idx)
+		xsp->ports[port_idx] = xsp->ports[xsp->ports_count];
+
+	xsp->ports[xsp->ports_count].sl_dev = 0;
+	xsp->ports[xsp->ports_count].ha_dev = 0;
+
+	/* If this was the prime port, then find a new prime port. */
+	if (port_idx == 0) {
+		if (xsp->ports_count == 0) {
+			netdev_info(dev, "Ran out of enlisted ports.\n");
+		} else {
+			netdev_info(dev, "Switch prime port from %s to %s.\n",
+				    port->name, xsp->ports[0].sl_dev->name);
+		}
+	}
+
+	return 0;
+}
+
+/* ** Must NOT be locked by caller ** */
+static int hanic_del_port(struct net_device *dev, struct net_device *port)
+{
+	int rc;
+
+	write_lock(&hanic_devs_mutex);
+	rc = do_hanic_del_port(dev, port);
+	write_unlock(&hanic_devs_mutex);
+	return rc;
+}
+
+static void hanic_get_stats64(struct net_device *dev,
+			      struct rtnl_link_stats64 *storage)
+{
+	struct hanic_priv *xsp = netdev_priv(dev);
+
+	storage->rx_packets = xsp->rx_packets;
+	storage->tx_packets = xsp->tx_packets;
+	storage->rx_bytes = xsp->rx_bytes;
+	storage->tx_bytes = xsp->tx_bytes;
+	storage->rx_dropped = xsp->rx_dropped;
+	storage->tx_dropped = xsp->tx_dropped;
+}
+
+static const struct net_device_ops hanic_netdev_ops = {
+	.ndo_open = hanic_open,
+	.ndo_stop = hanic_stop,
+	.ndo_start_xmit = hanic_start_xmit,
+	.ndo_set_mac_address = hanic_set_mac_address,
+	.ndo_add_slave = hanic_add_port,
+	.ndo_del_slave = hanic_del_port,
+	.ndo_get_stats64 = hanic_get_stats64
+};
+
+static const struct header_ops hanic_header_ops = {
+	.create = eth_header,
+	.parse = eth_header_parse,
+};
+
+/* The kernel calls this to initialize each device. This is a basic
+ * initialization, where I set up the common properties of the
+ * device. Think of it as the constructor.
+ */
+static void hanic_init(struct net_device *dev)
+{
+	struct hanic_priv *xsp;
+	struct sockaddr use_addr;
+	int idx;
+
+	/* Basic setup. This device is kinda like ethernet. */
+	ether_setup(dev);
+
+	dev->flags |= IFF_MASTER;
+
+	dev->netdev_ops = &hanic_netdev_ops;
+	dev->header_ops = &hanic_header_ops;
+	/* Reserve space for an R-TAG. */
+	dev->hard_header_len += 8;
+
+	/* Initialize MAC address for this device. */
+	use_addr.sa_family = AF_PACKET;
+	use_addr.sa_data[0] = 0x22;
+	use_addr.sa_data[1] = 0x01;
+	use_addr.sa_data[2] = 0x02;
+	use_addr.sa_data[3] = 0x03;
+	use_addr.sa_data[4] = 0x04;
+	use_addr.sa_data[5] = 0x05;
+	eth_mac_addr(dev, &use_addr);
+
+	dev->min_mtu = 0;
+	dev->max_mtu = 0;
+	dev->mtu = 0;
+
+	/* Initialize some key parts of the priv structure. */
+	xsp = netdev_priv(dev);
+	xsp->dev = dev;
+	INIT_LIST_HEAD(&xsp->devs_list);
+	xsp->ports_count = 0;
+	xsp->broadcast_disp = HANIC_DISP_FLOOD;
+	xsp->arp_rtag = ARP_RTAG_DEFAULT;
+	xsp->multicast_rtag = MULTICAST_RTAG_DEFAULT;
+	for (idx = 0; idx < HANIC_PORT_MAX; idx += 1) {
+		xsp->ports[idx].sl_dev = 0;
+		xsp->ports[idx].ha_dev = 0;
+	}
+
+	hash_init(xsp->filter_by_vlan_table);
+	hash_init(xsp->filter_by_vmac_table);
+	hash_init(xsp->stream_table);
+	spin_lock_init(&xsp->stream_table_lock);
+	xsp->ticks_per_reset = TICKS_PER_RESET;
+	init_hanic_fault_injection(xsp);
+
+	/* Attach the sysfs attributes to this device. */
+	hanic_device_sysfs(xsp);
+}
+
+/* Create a hanic interface device from the name pattern. */
+int hanic_dev_alloc(const char *name_pattern)
+{
+	int rc;
+	struct net_device *dev;
+
+	dev = alloc_netdev(sizeof(struct hanic_priv), name_pattern,
+			   NET_NAME_ENUM, hanic_init);
+	if (dev == 0) {
+		pr_warn("hanic: Unable to allocate hanic device.\n");
+		return -ENOMEM;
+	}
+
+	/* Ready. Register the device. */
+	rc = register_netdev(dev);
+	if (rc < 0) {
+		free_netdev(dev);
+		return rc;
+	}
+
+	add_dev_to_list(dev);
+
+	return 0;
+}
+
+/* This hanic device is interested in things that happen to enlisted
+ * ports, so this function is registered with the netdev notifier to
+ * be notified when things happen. Filter out the events that are not
+ * interesting.
+ */
+int hanic_dev_netdevice_event(struct net_device *edev, unsigned long event)
+{
+	struct hanic_priv *xsp = 0;
+	int port_idx = -1;
+	struct list_head *cur = 0;
+
+	/* I'm only interested in things that happen to IFF_SLAVE. */
+	if ((edev->flags & IFF_SLAVE) == 0)
+		return NOTIFY_OK;
+
+	/* We might be manipulating the enlisted ports of a device, so
+	 * make sure we are write-locked.
+	 */
+	write_lock(&hanic_devs_mutex);
+
+	/* OK, the event device is somebody's IFF_SIAVE. Is it one of mine? */
+	list_for_each (cur, &hanic_devs_list) {
+		int idx;
+
+		xsp = list_entry(cur, struct hanic_priv, devs_list);
+
+		for (idx = 0; idx < HANIC_PORT_MAX; idx += 1) {
+			if (xsp->ports[idx].sl_dev == edev) {
+				port_idx = idx;
+				break;
+			}
+		}
+
+		if (port_idx >= 0)
+			break;
+	}
+
+	/* Nope, not one of my enlisted ports. */
+	if (port_idx < 0) {
+		write_unlock(&hanic_devs_mutex);
+		return NOTIFY_OK;
+	}
+
+	switch (event) {
+	case NETDEV_UNREGISTER:
+		netdev_info(xsp->dev, "Releasing %s, which is unregistering.\n",
+			    xsp->ports[port_idx].sl_dev->name);
+		do_hanic_del_port(xsp->dev, xsp->ports[port_idx].sl_dev);
+		break;
+	default:
+		break;
+	}
+
+	write_unlock(&hanic_devs_mutex);
+	return NOTIFY_OK;
+}
+
+/* Perform cleanup on the hanic device to make it ready to be
+ * unregistered and freed. Note this includes removing in from
+ * the hanic_devs_list. That means it must be locked.
+ */
+static void do_cleanup_dev(struct net_device *dev)
+{
+	int idx;
+	struct hanic_priv *xsp = netdev_priv(dev);
+
+	/* delete the enlisted ports. */
+	for (idx = 0; idx < HANIC_PORT_MAX; idx += 1) {
+		if (xsp->ports[idx].sl_dev)
+			do_hanic_del_port(dev, xsp->ports[idx].sl_dev);
+	}
+
+	/* Clean up the filters tables. */
+	hanic_filters_clear(xsp);
+	/* Clean up the stream table */
+	hanic_map_stream_clear(xsp);
+
+	list_del(&xsp->devs_list);
+}
+
+/* Given the name of a hanic interface, delete that interface. Find it
+ * in the device table, clean it up, and free it.
+ */
+static int do_dev_free_byname(const char *name)
+{
+	struct list_head *cur;
+	struct net_device *dev;
+	struct hanic_priv *xsp;
+
+	for (cur = hanic_devs_list.next; cur != &hanic_devs_list;
+	     cur = cur->next) {
+		xsp = list_entry(cur, struct hanic_priv, devs_list);
+		dev = xsp->dev;
+		if (strcmp(dev->name, name) == 0)
+			break;
+	}
+	if (cur == &hanic_devs_list)
+		return -ENODEV;
+
+	do_cleanup_dev(dev);
+	unregister_netdev(dev);
+	free_netdev(dev);
+	return 0;
+}
+
+/* Wrap the dev_free_byname in the approprate locks. We need to hold
+ * the hanic_devs_mutex because we are manipulating the devs list, and
+ * we need the rtnl_lock() because we will be manipulating kernel
+ * network devices.
+ */
+int hanic_dev_free_byname(const char *name)
+{
+	int rc;
+
+	rtnl_lock();
+	write_lock(&hanic_devs_mutex);
+	rc = do_dev_free_byname(name);
+	write_unlock(&hanic_devs_mutex);
+	rtnl_unlock();
+	return rc;
+}
+
+/* Initialize the device tables and any global variables related to
+ * hanic. This is called by the module init. No actual devices are
+ * created here, that happens later when the user requests that they
+ * be created.
+ */
+int hanic_dev_init(void)
+{
+	rwlock_init(&hanic_devs_mutex);
+	INIT_LIST_HEAD(&hanic_devs_list);
+	return 0;
+}
+
+/* Release all the hanic devices. This is called when the module is
+ * being unloaded.
+ */
+void hanic_dev_release_all(void)
+{
+	struct hanic_priv *xsp;
+	struct net_device *dev;
+
+	/* Scan the entire table of existing interfaces, looking for
+	 * devices to release.
+	 */
+	write_lock(&hanic_devs_mutex);
+	while ((xsp = list_first_entry_or_null(&hanic_devs_list,
+					       struct hanic_priv, devs_list))) {
+		dev = xsp->dev;
+		/* Amongst other things, this removes dev from the
+		 * hanic_devs_list.
+		 */
+		rtnl_lock();
+		do_cleanup_dev(dev);
+		rtnl_unlock();
+		unregister_netdev(dev);
+		free_netdev(dev);
+	}
+	write_unlock(&hanic_devs_mutex);
+}
+
+ssize_t hanic_dev_show_interfaces(char *buf, size_t len)
+{
+	struct list_head *cur;
+	struct hanic_priv *xsp;
+	struct net_device *dev;
+	ssize_t res = 0;
+	int rc;
+
+	read_lock(&hanic_devs_mutex);
+	list_for_each (cur, &hanic_devs_list) {
+		xsp = list_entry(cur, struct hanic_priv, devs_list);
+		dev = xsp->dev;
+
+		rc = snprintf(buf, len, "%s\n", dev->name);
+		if (rc >= len) {
+			buf += len;
+			res += len;
+			len = 0;
+			break;
+		} else {
+			buf += rc;
+			res += rc;
+			len -= rc;
+		}
+	}
+	read_unlock(&hanic_devs_mutex);
+
+	return res;
+}
+
+/* This function is called at regular intervals to check for protocol
+ * timeouts. Scan the streams of all the devices.
+ */
+void hanic_dev_protocol_tick(void)
+{
+	struct list_head *cur;
+	struct hanic_priv *xsp;
+	struct hanic_stream_item *stream;
+	unsigned long flags;
+	int idx;
+
+	read_lock_irqsave(&hanic_devs_mutex, flags);
+	list_for_each (cur, &hanic_devs_list) {
+		xsp = list_entry(cur, struct hanic_priv, devs_list);
+		/* Scan the streams in the NIC. */
+		spin_lock(&xsp->stream_table_lock);
+		hash_for_each (xsp->stream_table, idx, stream, stream_table) {
+			hanic_stream_protocol_tick(xsp, stream);
+		}
+		spin_unlock(&xsp->stream_table_lock);
+	}
+	read_unlock_irqrestore(&hanic_devs_mutex, flags);
+}
diff --git a/drivers/net/hanic/hanic_filter.c b/drivers/net/hanic/hanic_filter.c
new file mode 100644
index 000000000000..cc6bf25ab8b6
--- /dev/null
+++ b/drivers/net/hanic/hanic_filter.c
@@ -0,0 +1,172 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 Cruise LLC
+ * Author: Steve Williams <steve.williams@getcruise.com>
+ */
+
+/* Each hanic device keeps a map of filters that prevent matching
+ * streams from being replicatedl
+ */
+#include "hanic_priv.h"
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+
+/* keep a kmem_cache of the filter items. This is not for speed, since
+ * allocation and release of these items is rare and happens in human
+ * time. This is mostly about convenience.
+ */
+static struct kmem_cache *hanic_filter_pool;
+
+static inline struct hanic_filter_item *alloc_filter_item(gfp_t flags)
+{
+	return kmem_cache_alloc(hanic_filter_pool, flags);
+}
+
+static inline void free_filter_item(struct hanic_filter_item *item)
+{
+	kmem_cache_free(hanic_filter_pool, item);
+}
+
+/* The _test_ functions. */
+struct hanic_filter_item *hanic_test_filter_vlan(struct hanic_priv *xsp,
+						 uint16_t vlan)
+{
+	struct hanic_filter_item *cur;
+
+	hash_for_each_possible (xsp->filter_by_vlan_table, cur, filter_table,
+				vlan) {
+		if (vlan == cur->vlan)
+			return cur;
+	}
+
+	return NULL;
+}
+
+struct hanic_filter_item *hanic_test_filter_vmac(struct hanic_priv *xsp,
+						 const uint8_t *mac,
+						 uint16_t vlan)
+{
+	const uint64_t key = stream_item_key(mac, vlan);
+	struct hanic_filter_item *cur;
+
+	hash_for_each_possible (xsp->filter_by_vmac_table, cur, filter_table,
+				key) {
+		if (key == stream_item_key(cur->mac, cur->vlan))
+			return cur;
+	}
+
+	return NULL;
+}
+
+/* The _set_ functions. */
+struct hanic_filter_item *hanic_set_filter_vlan(struct hanic_priv *xsp,
+						uint16_t vlan)
+{
+	struct hanic_filter_item *filt = 0;
+
+	filt = hanic_test_filter_vlan(xsp, vlan);
+	if (filt)
+		return filt;
+
+	filt = alloc_filter_item(GFP_ATOMIC);
+	if (filt == 0)
+		return NULL;
+
+	memset(filt->mac, 0, sizeof(filt->mac));
+	filt->vlan = vlan;
+	filt->disposition = HANIC_DISP_DEFAULT;
+	hash_add(xsp->filter_by_vlan_table, &filt->filter_table, vlan);
+
+	return filt;
+}
+
+struct hanic_filter_item *
+hanic_set_filter_vmac(struct hanic_priv *xsp, const uint8_t *mac, uint16_t vlan)
+{
+	const uint64_t key = stream_item_key(mac, vlan);
+	struct hanic_filter_item *filt = 0;
+
+	filt = hanic_test_filter_vmac(xsp, mac, vlan);
+	if (filt)
+		return filt;
+
+	filt = alloc_filter_item(GFP_ATOMIC);
+	if (filt == 0)
+		return NULL;
+
+	memcpy(filt->mac, mac, sizeof(filt->mac));
+	filt->vlan = vlan;
+	filt->disposition = HANIC_DISP_DEFAULT;
+	hash_add(xsp->filter_by_vmac_table, &filt->filter_table, key);
+
+	return filt;
+}
+
+/* The _clr_ functions. */
+void hanic_clr_filter_vlan(struct hanic_priv *xsp, uint16_t vlan)
+{
+	struct hanic_filter_item *filt = hanic_test_filter_vlan(xsp, vlan);
+
+	if (filt == 0)
+		return;
+
+	hash_del(&filt->filter_table);
+	free_filter_item(filt);
+}
+
+void hanic_clr_filter_vmac(struct hanic_priv *xsp, const uint8_t *mac,
+			   uint16_t vlan)
+{
+	struct hanic_filter_item *filt = hanic_test_filter_vmac(xsp, mac, vlan);
+
+	if (filt == 0)
+		return;
+
+	hash_del(&filt->filter_table);
+	free_filter_item(filt);
+}
+
+/* This function is used to remove all the filter items for the
+ * device. This is used to clean the device out.
+ */
+void hanic_filters_clear(struct hanic_priv *xsp)
+{
+	int idx;
+	struct hanic_filter_item *cur;
+	struct hlist_node *tmp;
+
+	/* Clean up the filter tables */
+	hash_for_each_safe (xsp->filter_by_vlan_table, idx, tmp, cur,
+			    filter_table) {
+		hash_del(&cur->filter_table);
+		free_filter_item(cur);
+	}
+
+	hash_for_each_safe (xsp->filter_by_vmac_table, idx, tmp, cur,
+			    filter_table) {
+		hash_del(&cur->filter_table);
+		free_filter_item(cur);
+	}
+}
+
+int hanic_filters_init(void)
+{
+	hanic_filter_pool = kmem_cache_create(
+		"hanic_filter_item", sizeof(struct hanic_filter_item), 0, 0, 0);
+	if (hanic_filter_pool == 0) {
+		pr_info("hanic_init_module: Unable to allocate hanic filter pool\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void hanic_filters_remove(void)
+{
+	kmem_cache_destroy(hanic_filter_pool);
+}
diff --git a/drivers/net/hanic/hanic_main.c b/drivers/net/hanic/hanic_main.c
new file mode 100644
index 000000000000..fd054a33cb6b
--- /dev/null
+++ b/drivers/net/hanic/hanic_main.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 Cruise LLC
+ * Author: Steve Williams <steve.williams@getcruise.com>
+ */
+
+#include "hanic_priv.h"
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+
+MODULE_LICENSE("GPL");
+
+static struct delayed_work hanic_protocol_clock;
+
+/* Keep the timer going.
+ * And deliver the tick to the devices.
+ * The dwork pointer should be pointing to hanic_protocol_clock.
+ */
+static void hanic_protocol_tick(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+
+	if (unlikely(dwork != &hanic_protocol_clock))
+		pr_warn("%s: Unexpected work struct? Ignoring.\n", __func__);
+	else
+		schedule_delayed_work(dwork, JIFFIES_PER_HANIC_TICK);
+	hanic_dev_protocol_tick();
+}
+
+static int do_netdevice_event(struct notifier_block *self, unsigned long event,
+			      void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	return hanic_dev_netdevice_event(dev, event);
+}
+
+static struct notifier_block hanic_netdevice_notifier = {
+	.notifier_call = do_netdevice_event
+};
+
+/* Called by the kernel to initialize the driver. */
+static int hanic_init_module(void)
+{
+	int rc;
+
+	rc = hanic_streams_init();
+	if (rc < 0) {
+		pr_info("%s: streams_init failed.\n", __func__);
+		return rc;
+	}
+
+	rc = hanic_filters_init();
+	if (rc < 0) {
+		pr_info("%s: filters_init failed.\n", __func__);
+		hanic_streams_remove();
+		return rc;
+	}
+
+	rc = hanic_dev_init();
+	if (rc < 0) {
+		pr_info("%s: dev_init failed.\n", __func__);
+		hanic_filters_remove();
+		hanic_streams_remove();
+		return rc;
+	}
+
+	rc = hanic_init_netns();
+	if (rc < 0) {
+		pr_info("%s: init_netns failed.\n", __func__);
+		hanic_filters_remove();
+		hanic_streams_remove();
+		return rc;
+	}
+
+	register_netdevice_notifier(&hanic_netdevice_notifier);
+
+	pr_info("%s: HANIC_TICKS_PER_SECOND=%d, "
+		"TICKS_PER_RESET=%d (JIFFIES_PER_HANIC_TICK=%d, HZ=%d)\n",
+		__func__, HANIC_TICKS_PER_SECOND, TICKS_PER_RESET,
+		JIFFIES_PER_HANIC_TICK, HZ);
+
+	INIT_DELAYED_WORK(&hanic_protocol_clock, hanic_protocol_tick);
+	schedule_delayed_work(&hanic_protocol_clock, JIFFIES_PER_HANIC_TICK);
+
+	return 0;
+}
+
+/* Remove the mess that is (was) the device driver. Leave no trace. */
+static void hanic_remove_module(void)
+{
+	/* Stop the protocol timer clock. */
+	cancel_delayed_work(&hanic_protocol_clock);
+
+	unregister_netdevice_notifier(&hanic_netdevice_notifier);
+	hanic_dev_release_all();
+	hanic_remove_netns();
+	hanic_filters_remove();
+	hanic_streams_remove();
+}
+
+module_init(hanic_init_module);
+module_exit(hanic_remove_module);
diff --git a/drivers/net/hanic/hanic_netns.c b/drivers/net/hanic/hanic_netns.c
new file mode 100644
index 000000000000..03c2fb0646f9
--- /dev/null
+++ b/drivers/net/hanic/hanic_netns.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 Cruise LLC
+ * Author: Steve Williams <steve.williams@getcruise.com>
+ */
+
+/* This handles the netns aspects of the hanic device[s]. */
+
+#include "hanic_priv.h"
+
+#include <net/net_namespace.h>
+#include <net/netns/generic.h>
+
+unsigned int hanic_net_id __read_mostly;
+
+/* These are operations that control the hanic presence within net scopes.
+ */
+
+static int __net_init hanic_net_init(struct net *net)
+{
+	int rc;
+	struct hanic_netns *xnp = net_generic(net, hanic_net_id);
+
+	xnp->net = net;
+	rc = hanic_init_sysfs(xnp);
+	return rc;
+}
+
+static void __net_exit hanic_net_exit(struct net *net)
+{
+	struct hanic_netns *xnp = net_generic(net, hanic_net_id);
+	hanic_remove_sysfs(xnp);
+}
+
+static struct pernet_operations hanic_net_ops = {
+	.init = hanic_net_init,
+	.exit = hanic_net_exit,
+	.id = &hanic_net_id,
+	.size = sizeof(struct hanic_netns),
+};
+
+int hanic_init_netns(void)
+{
+	int rc;
+
+	rc = register_pernet_subsys(&hanic_net_ops);
+	if (rc) {
+		pr_info("hanic: Unable to register pernet subsystem.\n");
+		return rc;
+	}
+
+	return 0;
+}
+
+void hanic_remove_netns(void)
+{
+	unregister_pernet_subsys(&hanic_net_ops);
+}
diff --git a/drivers/net/hanic/hanic_priv.h b/drivers/net/hanic/hanic_priv.h
new file mode 100644
index 000000000000..6ef3e2742b2a
--- /dev/null
+++ b/drivers/net/hanic/hanic_priv.h
@@ -0,0 +1,408 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __hanic_priv_H
+#define __hanic_priv_H
+/*
+ * Copyright (c) 2020 Cruise LLC
+ * Author: Steve Williams <steve.williams@getcruise.com>
+ */
+
+#include <linux/atomic.h>
+#include <linux/device.h>
+#include <linux/netdevice.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/hashtable.h>
+#include <asm/unaligned.h>
+
+/* Protocol number for the 802.1cb R-TAG */
+#define ETH_P_RTAG 0xf1c1
+
+/* This is the size of the RTAG. */
+#define RTAG_HLEN 6
+
+#define SEQ_HISTORY_LENGTH 256
+
+/* This defines the granularity of the 802.1cb timer. The standard
+ * requires that this be at least 100/sec.
+ */
+#define HANIC_TICKS_PER_SECOND 100
+
+/* Calculate the delay (in jiffies) between HANIC clock ticks:
+ *
+ *  HZ = jiffies/sec
+ *  HTPS = Hanic ticks/sec
+ *
+ *  HZ/HTPS = (jiffies/sec) / (hanic ticks/sec)
+ *	    = (jiffies/sec) * (sec/hanic ticks)
+ *	    = jiffies / hanic tick
+ *
+ * Realistic systems have a HZ values from 100 to maybe 1000, so this
+ * timer is not going to be super accurate. That doesn't matter
+ * much, but we absolutely do NOT want JIFFIES_PER_HANIC_TICK to round
+ * down to zero, so saturate it at 1.
+ */
+#define JIFFIES_PER_HANIC_TICK                                                 \
+	(((HZ) < (HANIC_TICKS_PER_SECOND)) ?                                   \
+		 1 :                                                           \
+		 ((HZ) / (HANIC_TICKS_PER_SECOND)))
+
+/* Calculate the msec/hanic tick (this value is only used to caluclate
+ * the default TICKS_PER_RESET from the compile time default reset time):
+ *
+ * HZ = jiffies/sec
+ * JIFFIES_PER_HANIC_TICK = jiffies/tick
+ * S/tick = JIFFIES_PER_HANIC_TICK / HZ
+ *	  = (jiffies/tick) / (jiffies/sec)
+ *
+ * ms/tick = 1000 * S/tick
+ *	   = 1000 * JIFFIES_PER_HANIC_TICK / HZ
+ */
+#define MSEC_PER_HANIC_TICK (1000 * JIFFIES_PER_HANIC_TICK / HZ)
+
+/* This is the default value for the frerSeqRcvyResetMSec value as
+ * defined in 802.1cb. This value must be at least 2 timer ticks.
+ */
+#define HANIC_SEQ_RCVY_RESET_MSEC 3000
+
+/* This many protocol ticks of idleness triggers a reset. Note that
+ * this value must be >=2 for reasonable driver behavior. This is the
+ * default value for the per-device tick_per_reset, which can be set
+ * on demand.
+ */
+#define TICKS_PER_RESET                                                        \
+	((HANIC_SEQ_RCVY_RESET_MSEC < 2 * MSEC_PER_HANIC_TICK) ?               \
+		 2 :                                                           \
+		 (HANIC_SEQ_RCVY_RESET_MSEC / MSEC_PER_HANIC_TICK))
+
+/* There are up to this many port devices. */
+#define HANIC_PORT_MAX 4
+
+struct hanic_priv;
+struct hanic_stream_item;
+
+/* Hanic-specific parts of the net device structure. */
+
+/* Type and functions for selecting packet disposition. This is used
+ * for selecting where to send broadcast packets, or untagged packets,
+ * etc.
+ *
+ * The packet disposition can be FLOOD, or the number for a port to
+ * use. If flood, the hanic_disp_is_flood() function returns
+ * true. Otherwise, the hanic_disp_port() function returns the
+ * net_device for the output port to use.
+ */
+typedef int hanic_packet_disposition_t;
+
+#define HANIC_DISP_FLOOD (-1)
+#define HANIC_DISP_DEFAULT (0)
+
+/* The hash functions need a 64bit numeric key, so generate one from
+ * the key that we really want to use.
+ *
+ * This function assumes the mac address is ETH_ALEN (6) bytes, and
+ * the vlan id is 2 bytes. Thus we can use the mac and vlan as a 64bit
+ * key. (Note: This is not the hash function. This is an integral key
+ * that can be hashed by the hashtable infrastructure.)
+ */
+static inline uint64_t stream_item_key(const uint8_t mac[ETH_ALEN],
+				       uint16_t vlan)
+{
+	int idx;
+	uint64_t key;
+
+	key = mac[0];
+	for (idx = 1; idx < ETH_ALEN; idx += 1) {
+		key <<= 8;
+		key |= mac[idx];
+	}
+	key <<= 16;
+	key |= vlan;
+	return key;
+}
+
+/* Each remote that we talk to (or that talks to us) has one of these
+ * entries. The entry represents the stream out and the stream in. In
+ * any case, the item contains the persistent variables needed for the
+ * stream.
+ *
+ * Instances of this object should be protected by the
+ * xsp->stream_table_mutex lock.
+ */
+#define HANIC_OOO_MAX_STRIDE 32
+#define STREAM_ATTR_NAME_LEN 32
+struct hanic_stream_item_stats {
+	unsigned long tx_send;
+	unsigned long rx_rogue_packets;
+	unsigned long rx_passed[HANIC_PORT_MAX];
+	unsigned long rx_dropped_duplicates[HANIC_PORT_MAX];
+	unsigned long rx_seq_recovery_resets;
+	unsigned long rx_out_of_order[HANIC_OOO_MAX_STRIDE];
+};
+struct hanic_stream_item {
+	struct hlist_node stream_table;
+	/* The key */
+	uint8_t mac[ETH_ALEN];
+	uint16_t vlan;
+	/* Out stream state. */
+	uint16_t out_seq_num;
+	/* In stream state. */
+	char take_any; /* flag */
+	uint16_t recov_seq_num;
+	char seq_space[SEQ_HISTORY_LENGTH];
+	int seq_space_ptr;
+	unsigned int in_reset_timer;
+	/* 802.1cb Statictics */
+	struct hanic_stream_item_stats stats;
+	/* Attribute handle */
+	char attr_name[STREAM_ATTR_NAME_LEN];
+	struct device_attribute attr;
+};
+
+extern struct hanic_stream_item *
+hanic_map_stream(struct hanic_priv *xsp, const void *mac, uint16_t vlan);
+extern void hanic_map_stream_clear(struct hanic_priv *xsp);
+
+extern void hanic_stream_protocol_tick(struct hanic_priv *xsp,
+				       struct hanic_stream_item *stream);
+extern int hanic_streams_init(void);
+extern void hanic_streams_remove(void);
+
+/* The hanic filter is a way to select the disposition for packets
+ * based on vlan or vlan and mac address. Normally, outbound backets
+ * are R-TAG'ed and processed. But if an item matches a filter_item,
+ * then it is either flooded out or sent out a single port.
+ *
+ * There are 2 filters: the vlan filter and the vmac filter. The
+ * vlan matches packets by vlan only, and the vmac filter matches
+ * packets using vlan and mac. In either case, the _test_ functions
+ * return a filter item if the item matches a filter set, or returns a
+ * null pointer if the key doesn't match.
+ *
+ * The _set_ functions match a filter by key if it exists, or creates
+ * a new filter item if the key doesn't exist. If a _set_ function
+ * returns null, then there is a malloc error.
+ *
+ * The _clr_ functions clear the key from the table.
+ */
+struct hanic_filter_item {
+	struct hlist_node filter_table;
+	/* The key */
+	uint8_t mac[ETH_ALEN];
+	uint16_t vlan;
+	/* How to handle matching items */
+	hanic_packet_disposition_t disposition;
+};
+
+extern struct hanic_filter_item *hanic_test_filter_vlan(struct hanic_priv *xsp,
+							uint16_t vlan);
+extern struct hanic_filter_item *hanic_test_filter_vmac(struct hanic_priv *xsp,
+							const uint8_t *mac,
+							uint16_t vlan);
+extern struct hanic_filter_item *hanic_set_filter_vlan(struct hanic_priv *xsp,
+						       uint16_t vlan);
+extern struct hanic_filter_item *hanic_set_filter_vmac(struct hanic_priv *xsp,
+						       const uint8_t *mac,
+						       uint16_t vlan);
+extern void hanic_clr_filter_vlan(struct hanic_priv *xsp, uint16_t vlan);
+extern void hanic_clr_filter_vmac(struct hanic_priv *xsp, const uint8_t *mac,
+				  uint16_t vlan);
+extern void hanic_filters_clear(struct hanic_priv *xsp);
+extern int hanic_filters_init(void);
+extern void hanic_filters_remove(void);
+
+/* This is information about an enlisted port. There are multiple port
+ * devices bound to each hanic device.
+ */
+struct hanic_port_info {
+	struct net_device *sl_dev;
+	/* Saved address for enlisted port. */
+	unsigned char sl_save_addr[MAX_ADDR_LEN];
+	/* Back pointer */
+	struct net_device *ha_dev;
+#if defined(CONFIG_HANIC_FAULT_INJECTION)
+	/* Fault injection/debug state */
+	atomic_t test_drop_packet_in;
+	atomic_t test_drop_packet_out;
+#endif
+};
+
+/* Information about the hanic device. */
+struct hanic_priv {
+	/* Back pointer to the net_device. */
+	struct net_device *dev;
+	/* My position in the devs_list. */
+	struct list_head devs_list;
+	/* Enlisted ports */
+	struct hanic_port_info ports[HANIC_PORT_MAX];
+	int ports_count;
+	hanic_packet_disposition_t broadcast_disp;
+	bool arp_rtag;
+	bool multicast_rtag;
+	/* Filter tables */
+	DECLARE_HASHTABLE(filter_by_vlan_table, 4);
+	DECLARE_HASHTABLE(filter_by_vmac_table, 8);
+	/* table of streams */
+	DECLARE_HASHTABLE(stream_table, 8);
+	spinlock_t stream_table_lock;
+	/* Reset timer to use in each stream. */
+	unsigned int ticks_per_reset;
+	/* Statistics. */
+	unsigned long rx_packets;
+	unsigned long rx_bytes;
+	unsigned long rx_dropped;
+	unsigned long tx_packets;
+	unsigned long tx_bytes;
+	unsigned long tx_dropped;
+#if defined(CONFIG_HANIC_FAULT_INJECTION)
+	/* Fault injection/debug state */
+	atomic_t test_drop_flood_out;
+#endif
+};
+
+#if defined(CONFIG_HANIC_FAULT_INJECTION)
+static inline void init_hanic_fault_injection(struct hanic_priv *xsp)
+{
+	atomic_set(&xsp->test_drop_flood_out, 0);
+}
+
+static inline void init_port_fault_injection(struct hanic_priv *xsp,
+					     int port_idx)
+{
+	atomic_set(&xsp->ports[port_idx].test_drop_packet_in, 0);
+	atomic_set(&xsp->ports[port_idx].test_drop_packet_out, 0);
+}
+
+static inline int test_drop_flood_out(struct hanic_priv *xsp)
+{
+	int val;
+
+	val = atomic_dec_if_positive(&xsp->test_drop_flood_out);
+	if (unlikely(val > 0))
+		return 1;
+
+	return 0;
+}
+
+static inline int test_drop_packet_out(struct hanic_priv *xsp, int port_idx)
+{
+	int val;
+
+	val = atomic_dec_if_positive(
+		&xsp->ports[port_idx].test_drop_packet_out);
+	if (unlikely(val > 0))
+		return 1;
+
+	return 0;
+}
+
+static inline int test_drop_packet_in(struct hanic_priv *xsp, int port_idx)
+{
+	int val;
+
+	val = atomic_dec_if_positive(&xsp->ports[port_idx].test_drop_packet_in);
+	if (unlikely(val > 0))
+		return 1;
+
+	return 0;
+}
+
+#else
+static inline void init_hanic_fault_injection(struct hanic_priv *xsp)
+{
+}
+
+static inline void init_port_fault_injection(struct hanic_priv *xsp,
+					     int port_idx)
+{
+}
+
+static inline int test_drop_flood_out(struct hanic_priv *xsp)
+{
+	return 0;
+}
+
+static inline int test_drop_packet_out(struct hanic_priv *xsp, int port_idx)
+{
+	return 0;
+}
+
+static inline int test_drop_packet_in(struct hanic_priv *xsp, int port_idx)
+{
+	return 0;
+}
+#endif
+
+/* These functions use a disposition value to select a port to use. If
+ * the disposition is FLOOD, then the hanic_disp_is_flood() function
+ * returns true. Otherwise, the hanic_disp_port can be used to select
+ * the net_device to use.
+ */
+static inline int hanic_disp_is_flood(hanic_packet_disposition_t pd)
+{
+	return pd < 0;
+}
+
+static inline struct net_device *hanic_disp_port(struct hanic_priv *xsp,
+						 hanic_packet_disposition_t pd)
+{
+	if (pd < 0)
+		return xsp->ports[0].sl_dev;
+	if (pd >= HANIC_PORT_MAX)
+		return xsp->ports[0].sl_dev;
+	if (xsp->ports[pd].sl_dev == NULL)
+		return xsp->ports[0].sl_dev;
+
+	return xsp->ports[pd].sl_dev;
+}
+
+/* Per-namespace aspects of the hanic driver. */
+struct hanic_netns {
+	struct net *net;
+	struct class_attribute class_attr_hanic_interfaces;
+};
+
+/* Create device. */
+extern int hanic_dev_init(void);
+extern int hanic_dev_alloc(const char *name_pattern);
+extern int hanic_dev_free_byname(const char *name);
+extern void hanic_dev_release_all(void);
+
+/* protocol handling. */
+extern void hanic_add_protocol_to_port(struct hanic_priv *xsp, int port_idx);
+extern void hanic_remove_protocol_from_port(struct hanic_priv *xsp,
+					    int port_idx);
+
+/* Events about devices in the system. */
+extern int hanic_dev_netdevice_event(struct net_device *dev,
+				     unsigned long event);
+
+/* Ticks of the protocol clock. */
+extern void hanic_dev_protocol_tick(void);
+
+/* sysfs show interfaces. */
+extern ssize_t hanic_dev_show_interfaces(char *buf, size_t len);
+
+/* Namespace specific functions. */
+extern int hanic_init_netns(void);
+extern void hanic_remove_netns(void);
+
+/* sysfs functions */
+extern int hanic_init_sysfs(struct hanic_netns *xnp);
+extern void hanic_remove_sysfs(struct hanic_netns *xnp);
+extern void hanic_device_sysfs(struct hanic_priv *xsp);
+extern int hanic_sysfs_add_attr(struct hanic_priv *xsp, struct attribute *attr);
+extern void hanic_sysfs_rem_attr(struct hanic_priv *xsp,
+				 struct attribute *attr);
+extern ssize_t hanic_stream_show(struct device *d,
+				 struct device_attribute *attr, char *buf);
+
+/* Return TRUE if the 16bit (2 byte) val matches the value pointed
+ * to by ptr. The value in memory is assumed to be big-endian (network
+ * byte order) and is not expected to be aligned.
+ */
+static inline int test_net2bytes(const unsigned char *ptr, uint16_t val)
+{
+	return get_unaligned_be16(ptr) == val;
+}
+
+#endif
diff --git a/drivers/net/hanic/hanic_protocol.c b/drivers/net/hanic/hanic_protocol.c
new file mode 100644
index 000000000000..7ab51e0e8908
--- /dev/null
+++ b/drivers/net/hanic/hanic_protocol.c
@@ -0,0 +1,350 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 Cruise LLC
+ * Author: Steve Williams <steve.williams@getcruise.com>
+ */
+
+#include "hanic_priv.h"
+#include <linux/netdevice.h>
+#include <linux/if_vlan.h>
+#include <linux/printk.h>
+
+/* The seq_space is a bool array from 0 to SEQ_HISTORY_LENGTH-1. Each
+ * entry represents a past packet, with higher indices being farther
+ * into the past.
+ *
+ * The cell at seq_space[seq_space_ptr] is TRUE by design.
+ *
+ * Logically, recov_seq_num points to the cell as seq_space_ptr, so
+ * that cell should be true, unless take_any==0
+ *
+ * NOTE: Entering this function, -SEQ_HISTORY_LENGTH < delta < 0
+ * The algorithm already knows that seq_space[seq_space_ptr] == 1, and
+ * that is the case if delta==0.
+ */
+static int test_and_set_seq_space(struct hanic_stream_item *stream, int delta)
+{
+	int offset = -delta;
+	int ptr = (stream->seq_space_ptr + offset) % SEQ_HISTORY_LENGTH;
+
+	if (stream->seq_space[ptr])
+		return 1;
+
+	stream->seq_space[ptr] = 1;
+	return 0;
+}
+
+/* Shift the sequence space array a positive amount. This is done
+ * in response to a new packet arriving from the future. This shift
+ * moves "now" to the future defined by the arriving packet.
+ *
+ * A positive delta decrements the seq_space_ptr, since per the
+ * test_and_set_seq_space, the "past" is a positive index.
+ *
+ * NOTE: Entering this function, 0 < delta < SEQ_HISTORY_LENGTH
+ */
+static void shift_seq_space(struct hanic_stream_item *stream, int delta)
+{
+	int idx;
+	int new_ptr = stream->seq_space_ptr - delta;
+
+	if (new_ptr < 0)
+		new_ptr += SEQ_HISTORY_LENGTH;
+
+	/* Set time to "now", an note that the "now" packet has
+	 * arrived at least once.
+	 */
+	stream->seq_space_ptr = new_ptr;
+	stream->seq_space[new_ptr] = 1;
+
+	/* Clear cells in the past that we might have skipped. */
+	for (idx = 1; idx < delta; idx += 1) {
+		int ptr = (new_ptr + idx) % SEQ_HISTORY_LENGTH;
+
+		stream->seq_space[ptr] = 0;
+	}
+}
+
+/* Rewrite the MAC header to elide the R-TAG protocol header. This is
+ * done so that the kernel can re-interpret the packet using the
+ * encapsulated protocols.
+ */
+static struct sk_buff *rewrite_rtag_header(struct sk_buff *skb)
+{
+	int mac_len;
+
+	/* Pull the R-TAG data, and the next sequence number,
+	 * out of the payload.
+	 */
+	skb_pull_rcsum(skb, RTAG_HLEN);
+
+	/* Rewrite the R-TAG out of the MAC header. */
+	mac_len = skb->data - skb_mac_header(skb);
+
+	/* Move all the mac header, except the protocol number,
+	 * forward. In the trivial case, mac_len==20, and the
+	 * result works like this:
+	 *
+	 * a0:a1:a2:a3:a4:a5 b0:b1:b2:b3:b4:b5 f1:c1:ss:ss:ss:ss 08:00 ...
+	 * .. .. .. .. .. .. a0:a1:a2:a3:a4:a5 b0:b1:b2:b3:b4:b5 08:00 ...
+	 *
+	 * Notice how the memmove tosses the first ethertype,
+	 * which is the RTAG protocol number, but preserves the
+	 * nested ethertype, which is the payload packet
+	 * protocol (i.e. IP).
+	 */
+	memmove(skb_mac_header(skb) + RTAG_HLEN, skb_mac_header(skb),
+		mac_len - RTAG_HLEN - 2);
+	skb->mac_header += 6;
+
+	/* Clean up the skb */
+	skb_reset_network_header(skb);
+	skb_reset_transport_header(skb);
+	skb_reset_mac_len(skb);
+
+	return skb;
+}
+
+/* The 802.1cb R-TAG protocol uses duplication to guarantee
+ * delivery, so it is the job of this protocol handler to de-duplicate
+ * the stream of packets. To aid in that task, the remote includes in
+ * the duplicated packets an R-TAG that contains a 16bit sequence
+ * number. Two packets that are duplicates will arrive in a similar
+ * time with the same sequence number.
+ *
+ * To detect duplicates, we keep track of which sequence numbers were
+ * recently (within SEQ_HISTORY_LENGTH packets) received. If a sequence
+ * number has been recently received, it is a duplicate and can be
+ * quietly dropped. If the packet has not been received yet, and is
+ * greater then any other packet sequence numbers, then shift the
+ * sliding window of sequence numbers, and this packet becomes the new
+ * definition of "recent".
+ *
+ * If an arriving packet has a sequence number far outside the
+ * expected range, then this is some sort of rogue packet. Drop it.
+ *
+ * This function will return RX_HANDLER_ANOTHER if the packet is to be
+ * accepted (likely including so packet edits) or RX_HANDLER_CONSUMED
+ * if the packet had been dropped.
+ *
+ * If the packet arrives with an 802.1Q VLAN tag, then the caller will
+ * have already stripped it out and interpreted it.
+ */
+static rx_handler_result_t run_rtag_protocol(struct net_device *dev,
+					     struct net_device *port,
+					     int port_idx,
+					     struct sk_buff **pskb)
+{
+	struct hanic_priv *xsp = netdev_priv(dev);
+	struct sk_buff *skb = *pskb;
+	uint8_t *rtag;
+	uint16_t vlan_id = 0;
+	uint16_t rtag_seq;
+	uint16_t next_proto;
+	const uint8_t *saddr;
+	struct hanic_stream_item *stream;
+	unsigned long flags;
+
+	/* Grab the source mac address from the ethernet header.
+	 * Or if this is a multicast packet to me, then use that as
+	 * the stream identifier address, since the source address
+	 * must not be conflated with unicast addresses from the same
+	 * source.
+	 */
+	if (unlikely(is_multicast_ether_addr(skb_mac_header(skb))))
+		saddr = skb_mac_header(skb);
+	else
+		saddr = skb_mac_header(skb) + ETH_ALEN;
+
+	/* If this packet is coming in through a VLAN, get the VLAN id
+	 * for matching streams. Note that the kernel network
+	 * infrastructure has already elided (and interpreted) the
+	 * 802.1Q tag, so these functions are the only lasting clue
+	 * that this packet was on a VLAN.
+	 */
+	if (skb_vlan_tag_present(skb))
+		vlan_id = skb_vlan_tag_get_id(skb);
+
+	spin_lock_irqsave(&xsp->stream_table_lock, flags);
+	stream = hanic_map_stream(xsp, saddr, vlan_id);
+	if (unlikely(stream == 0)) {
+		spin_unlock_irqrestore(&xsp->stream_table_lock, flags);
+		net_warn_ratelimited(
+			"%s: Failed to locate or allocate stream map.\n",
+			dev->name);
+		return RX_HANDLER_ANOTHER;
+	}
+
+	/* Fault Injection:
+	 * If this packet is to be dropped as some sort of injected
+	 * fault, then drop it without a message. We do this fault
+	 * injection here so that it only effects R-TAG'ed packets.
+	 */
+	if (unlikely(test_drop_packet_in(xsp, port_idx))) {
+		spin_unlock_irqrestore(&xsp->stream_table_lock, flags);
+		consume_skb(skb);
+		return RX_HANDLER_CONSUMED;
+	}
+
+	/* The R-TAG protocol header (other then the ethernet
+	 * tag itself) is 4 bytes (octets) that together make up
+	 * the frame replication sequence number:
+	 *
+	 * f1:c1:rr:rr:ss:ss:pp:pp
+	 *
+	 * f1:c1 is the Ethertype
+	 * rr:rr is 16 bits (2 octets) of reserved
+	 * ss:ss is 16 bits (2 octets) of sequence number.
+	 * pp:pp is the next protocol number.
+	 *
+	 * The lower level processing stripped off the f1:c1
+	 * and put that into the protocol member of the skb, so
+	 * the skb->data points to the first octet of rr:rr.
+	 */
+	rtag = skb->data;
+	rtag_seq = (rtag[2] << 8);
+	rtag_seq |= rtag[3];
+	next_proto = (rtag[4] << 8);
+	next_proto |= rtag[5];
+
+	if (stream->take_any) {
+		/* take_any is set. The stream has been reset. */
+		stream->stats.rx_passed[port_idx] += 1;
+		stream->take_any = 0;
+		stream->recov_seq_num = rtag_seq;
+		stream->seq_space[stream->seq_space_ptr] = 1;
+
+	} else {
+		uint16_t tmp = rtag_seq - stream->recov_seq_num;
+		int delta;
+		int sign = (tmp & 0x8000) ? -1 : 1;
+
+		tmp *= sign;
+		delta = sign * tmp;
+
+		if ((delta >= SEQ_HISTORY_LENGTH) ||
+		    (delta <= -SEQ_HISTORY_LENGTH)) {
+			stream->stats.rx_rogue_packets += 1;
+			spin_unlock_irqrestore(&xsp->stream_table_lock, flags);
+			consume_skb(skb);
+			net_info_ratelimited("%s[%s]: Rogue packet from "
+					     "%02x:%02x:%02x:%02x:%02x:%02x. "
+					     "(delta=%d)\n",
+					     dev->name, port->name, saddr[0],
+					     saddr[1], saddr[2], saddr[3],
+					     saddr[4], saddr[5], delta);
+			return RX_HANDLER_CONSUMED;
+
+		} else if (delta == 0) {
+			/* Match duplicate. The best kind. */
+			stream->stats.rx_dropped_duplicates[port_idx] += 1;
+			spin_unlock_irqrestore(&xsp->stream_table_lock, flags);
+			consume_skb(skb);
+			return RX_HANDLER_CONSUMED;
+
+		} else if ((delta < 0) &&
+			   test_and_set_seq_space(stream, delta)) {
+			/* Duplicate of a packet from the recent past. */
+			stream->stats.rx_dropped_duplicates[port_idx] += 1;
+			spin_unlock_irqrestore(&xsp->stream_table_lock, flags);
+			consume_skb(skb);
+			return RX_HANDLER_CONSUMED;
+
+		} else if (delta > 0) {
+			/* Future packet. */
+			stream->stats.rx_passed[port_idx] += 1;
+			stream->recov_seq_num = rtag_seq;
+			shift_seq_space(stream, delta);
+			if (delta > 1) {
+				if (delta > HANIC_OOO_MAX_STRIDE)
+					delta = HANIC_OOO_MAX_STRIDE;
+				delta -= 1;
+				stream->stats.rx_out_of_order[delta] += 1;
+			}
+
+		} else {
+			/* Non-duplicate from recent past. This
+			 * can happen if packets are out of order.
+			 */
+			stream->stats.rx_passed[port_idx] += 1;
+		}
+	}
+
+	/* A packet has been accepted by the protocol,
+	 * so reset the reset timer.
+	 */
+	stream->in_reset_timer = xsp->ticks_per_reset;
+
+	spin_unlock_irqrestore(&xsp->stream_table_lock, flags);
+
+	skb->protocol = cpu_to_be16(next_proto);
+	*pskb = rewrite_rtag_header(skb);
+	return RX_HANDLER_ANOTHER;
+}
+
+/* The packet handler is attached to the enlisted device, with the
+ * rx_handler_data set to the hanic_port_info within the master
+ * device. The handler looks at the packet and decides how to process
+ * it. The hanic_port_info contains a back-pointer to the master
+ * device, and this information can be used to calculate the port_idx
+ * of the port within the hanic port set.
+ *
+ * When this handler is called, the ethernet header (dst, src, proto)
+ * are already extracted and interpreted. However, if we detect the
+ * R-TAG protocol, then we will rewrite the header and reinterpret it
+ * so that the payload protocol  is invoked.
+ */
+
+static rx_handler_result_t hanic_packet_handler(struct sk_buff **pskb)
+{
+	struct sk_buff *skb = *pskb;
+	struct hanic_port_info *ports = skb->dev->rx_handler_data;
+	struct net_device *dev = ports->ha_dev;
+	struct net_device *port = skb->dev;
+	struct hanic_priv *xsp = netdev_priv(dev);
+	int port_idx = ports - xsp->ports;
+	uint16_t proto = be16_to_cpu(skb->protocol);
+	rx_handler_result_t res = RX_HANDLER_ANOTHER;
+
+	/* 802.1cb R-TAG is present. Extract it from the packet and
+	 * remake the packet without it. This includes setting the
+	 * payload protocol number.
+	 */
+	if (proto == ETH_P_RTAG) {
+		res = run_rtag_protocol(dev, port, port_idx, pskb);
+		skb = *pskb;
+	}
+
+	/* If one of the protocol handlers consumed the packet, then
+	 * escape now.
+	 */
+	if (res != RX_HANDLER_ANOTHER)
+		return res;
+
+	/* Steal the packet from the enlisted port and claim it for the master. */
+	skb->dev = dev;
+	xsp->rx_packets += 1;
+	xsp->rx_bytes += skb->len;
+	return RX_HANDLER_ANOTHER;
+}
+
+void hanic_add_protocol_to_port(struct hanic_priv *xsp, int port_idx)
+{
+	int rc;
+	struct net_device *port = xsp->ports[port_idx].sl_dev;
+
+	rc = netdev_rx_handler_register(port, hanic_packet_handler,
+					xsp->ports + port_idx);
+	if (rc < 0) {
+		netdev_info(
+			xsp->dev,
+			"%s: Error (errno=%d) registering packet handler for %s.\n",
+			__func__, -rc, port->name);
+	}
+}
+
+void hanic_remove_protocol_from_port(struct hanic_priv *xsp, int port_idx)
+{
+	struct net_device *port = xsp->ports[port_idx].sl_dev;
+	netdev_rx_handler_unregister(port);
+}
diff --git a/drivers/net/hanic/hanic_streams.c b/drivers/net/hanic/hanic_streams.c
new file mode 100644
index 000000000000..7b27991968d9
--- /dev/null
+++ b/drivers/net/hanic/hanic_streams.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 Cruise LLC
+ * Author: Steve Williams <steve.williams@getcruise.com>
+ */
+
+/* Each hanic device keeps a map of streams in order to hold protocol
+ * state. Each stream is identified by the remote MAC address and the
+ * vlan id.
+ */
+#include "hanic_priv.h"
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+
+static void hanic_stream_reset_statistics(struct hanic_stream_item *stream)
+{
+	int idx;
+
+	stream->stats.tx_send = 0;
+	stream->stats.rx_rogue_packets = 0;
+	for (idx = 0; idx < HANIC_PORT_MAX; idx += 1) {
+		stream->stats.rx_passed[idx] = 0;
+		stream->stats.rx_dropped_duplicates[idx] = 0;
+	}
+	stream->stats.rx_seq_recovery_resets = 0;
+	for (idx = 0; idx < HANIC_OOO_MAX_STRIDE; idx += 1)
+		stream->stats.rx_out_of_order[idx] = 0;
+}
+
+static void hanic_stream_in_reset(struct hanic_stream_item *stream)
+{
+	int idx;
+
+	stream->take_any = 1;
+	stream->recov_seq_num = 0;
+	stream->in_reset_timer = 0;
+	stream->seq_space_ptr = 0;
+	for (idx = 0; idx < SEQ_HISTORY_LENGTH; idx += 1)
+		stream->seq_space[idx] = 0;
+}
+
+static struct kmem_cache *hanic_stream_pool;
+
+static inline struct hanic_stream_item *alloc_stream_item(gfp_t flags)
+{
+	return kmem_cache_alloc(hanic_stream_pool, flags);
+}
+
+static inline void free_stream_item(struct hanic_stream_item *item)
+{
+	kmem_cache_free(hanic_stream_pool, item);
+}
+
+/* Look for the stream in the stream table. If it is not there, create
+ * it and initialize it.
+ *
+ * NOTE: The caller is responsible for holding the stream_table_lock.
+ */
+struct hanic_stream_item *hanic_map_stream(struct hanic_priv *xsp,
+					   const void *mac, uint16_t vlan)
+{
+	struct hanic_stream_item *stream = 0;
+	struct hanic_stream_item *cur;
+	uint64_t stream_key = stream_item_key(mac, vlan);
+
+	hash_for_each_possible (xsp->stream_table, cur, stream_table,
+				stream_key) {
+		if (stream_key == stream_item_key(cur->mac, cur->vlan)) {
+			stream = cur;
+			break;
+		}
+	}
+
+	if (stream == 0) {
+		stream = alloc_stream_item(GFP_ATOMIC);
+		if (stream == 0)
+			return 0;
+
+		memcpy(stream->mac, mac, ETH_ALEN);
+		stream->vlan = vlan;
+		stream->out_seq_num = 0;
+		hanic_stream_in_reset(stream);
+		hanic_stream_reset_statistics(stream);
+		/* build up attribute. */
+		sysfs_attr_init(&stream->attr);
+		snprintf(stream->attr_name, sizeof(stream->attr_name),
+			 "stream-%02x:%02x:%02x:%02x:%02x:%02x-%04x",
+			 stream->mac[0], stream->mac[1], stream->mac[2],
+			 stream->mac[3], stream->mac[4], stream->mac[5], vlan);
+		stream->attr.attr.name = stream->attr_name;
+		stream->attr.attr.mode = 0444;
+		stream->attr.show = hanic_stream_show;
+		stream->attr.store = 0;
+		/* Add to tables. */
+		hash_add(xsp->stream_table, &stream->stream_table, stream_key);
+		hanic_sysfs_add_attr(xsp, &stream->attr.attr);
+		net_info_ratelimited("%s: Created new %s.\n", xsp->dev->name,
+				     stream->attr_name);
+	}
+
+	return stream;
+}
+
+void hanic_map_stream_clear(struct hanic_priv *xsp)
+{
+	int idx;
+	struct hanic_stream_item *cur;
+	struct hlist_node *tmp;
+
+	/* Clean up the stream table */
+	hash_for_each_safe (xsp->stream_table, idx, tmp, cur, stream_table) {
+		hanic_sysfs_rem_attr(xsp, &cur->attr.attr);
+		hash_del(&cur->stream_table);
+		free_stream_item(cur);
+	}
+}
+
+/* The input streams have a protocol timer. If no packets are received
+ * after some number of protocol ticks, then reset the state
+ * machine. This is done to recover from broken protocol
+ * synchronizations.
+ *
+ * NOTE: The caller already holds the hanic_devs_mutex lock, and the
+ *       xsp->stream_table_lock.
+ */
+void hanic_stream_protocol_tick(struct hanic_priv *xsp,
+				struct hanic_stream_item *stream)
+{
+	if (stream->in_reset_timer == 0)
+		return;
+
+	if (stream->in_reset_timer > 1) {
+		stream->in_reset_timer -= 1;
+		return;
+	}
+
+	hanic_stream_in_reset(stream);
+	stream->stats.rx_seq_recovery_resets += 1;
+}
+
+int hanic_streams_init(void)
+{
+	hanic_stream_pool = kmem_cache_create(
+		"hanic_stream_item", sizeof(struct hanic_stream_item), 0, 0, 0);
+	if (hanic_stream_pool == 0) {
+		pr_info("hanic_init_module: Unable to allocate hanic stream pool\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void hanic_streams_remove(void)
+{
+	kmem_cache_destroy(hanic_stream_pool);
+}
diff --git a/drivers/net/hanic/hanic_sysfs.c b/drivers/net/hanic/hanic_sysfs.c
new file mode 100644
index 000000000000..39ee229cfab6
--- /dev/null
+++ b/drivers/net/hanic/hanic_sysfs.c
@@ -0,0 +1,672 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 Cruise LLC
+ * Author: Steve Williams <steve.williams@getcruise.com>
+ */
+
+#include "hanic_priv.h"
+
+#include <linux/netdevice.h>
+#include <linux/sysfs.h>
+
+#define HANIC_DEV_ATTRIBUTES 1023
+
+/* Show a list of all the interfaces that exist. */
+static ssize_t hanic_show_interfaces(struct class *cls,
+				     struct class_attribute *attr, char *buf)
+{
+	return hanic_dev_show_interfaces(buf, PAGE_SIZE);
+}
+
+#define str_of(x) #x
+#define str_of_value(x) str_of(x)
+
+/* Add/delete interfaces as requested by the user. The command format
+ * is super simple:
+ *
+ *   +<name-pattern> to create an interface
+ *   -<name> to delete an interface
+ *
+ * The <name-pattern> make include an %d which will receive an
+ * interface number or some such, but it doesn't have to.
+ */
+static ssize_t hanic_store_interfaces(struct class *cls,
+				      struct class_attribute *attr,
+				      const char *buffer, size_t count)
+{
+	int rc;
+	char command_code;
+	char ifname[IFNAMSIZ + 1];
+
+	rc = sscanf(buffer, "%c%" str_of_value(IFNAMSIZ) "s", &command_code,
+		    ifname);
+	if (rc < 2) {
+		pr_info("hanic: Command format: [+-]<ifname>\n");
+		return -ENODEV;
+	}
+
+	switch (command_code) {
+	case '+':
+		rc = hanic_dev_alloc(ifname);
+		if (rc < 0)
+			return rc;
+		break;
+
+	case '-':
+		rc = hanic_dev_free_byname(ifname);
+		break;
+
+	default:
+		pr_info("hanic: command_code=%c, ifname=%s\n", command_code,
+			ifname);
+		break;
+	}
+
+	return count;
+}
+
+/* class attribute for hanic_interfaces file.  This ends up in /sys/class/net */
+static const struct class_attribute class_attr_hanic_interfaces = {
+	.attr = {
+		.name = "hanic_interfaces",
+		.mode = 0644,
+	},
+	.show = hanic_show_interfaces,
+	.store = hanic_store_interfaces,
+};
+
+int hanic_init_sysfs(struct hanic_netns *xns)
+{
+	int rc;
+
+	xns->class_attr_hanic_interfaces = class_attr_hanic_interfaces;
+	sysfs_attr_init(&xns->class_attr_sandlan_interfaces.attr);
+
+	rc = netdev_class_create_file_ns(&xns->class_attr_hanic_interfaces,
+					 xns->net);
+	if (rc < 0)
+		pr_info("hanic_create_sysfs: Unable to create class file.\n");
+
+	return rc;
+}
+
+void hanic_remove_sysfs(struct hanic_netns *xns)
+{
+	netdev_class_remove_file_ns(&xns->class_attr_hanic_interfaces,
+				    xns->net);
+}
+
+/* Show the ports in the current bond. */
+static ssize_t ports_show(struct device *d, struct device_attribute *attr,
+			  char *buf)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	int res = 0;
+	int idx;
+
+	for (idx = 0; idx < HANIC_PORT_MAX; idx += 1) {
+		struct net_device *port = xsp->ports[idx].sl_dev;
+
+		if (port == 0)
+			continue;
+		res += sprintf(buf + res, "%d: %s\n", idx, port->name);
+	}
+	return res;
+}
+static DEVICE_ATTR_RO(ports);
+
+/* Show the JIFFIES_PER_HANIC_TICK. This value can be converted to
+ * TicksPerSecond with the formula HZ/JIFFIES_PER_HANIC_TICK.
+ *
+ * The TicksPerSecond value is as defined in:
+ *   IEEE Std 802.1CB-2017
+ *   7.4.3.2.5 TicksPerSecond
+ *
+ * But the JIFFIES_PER_HANIC_TICK is what's actually used internally.
+ */
+static ssize_t jiffies_per_hanic_tick_show(struct device *d,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	ssize_t res = 0;
+
+	res += snprintf(buf, PAGE_SIZE, "%u\n", JIFFIES_PER_HANIC_TICK);
+	return res;
+}
+
+static DEVICE_ATTR_RO(jiffies_per_hanic_tick);
+
+static ssize_t ticks_per_reset_show(struct device *d,
+				    struct device_attribute *attr, char *buf)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	ssize_t res = 0;
+
+	res += snprintf(buf, PAGE_SIZE, "%u\n", xsp->ticks_per_reset);
+	return res;
+}
+
+static ssize_t ticks_per_reset_store(struct device *d,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	int rc;
+	unsigned int val;
+
+	rc = sscanf(buf, " %u", &val);
+	if (rc < 1)
+		return count;
+
+	if (val < 2)
+		val = 2;
+	xsp->ticks_per_reset = val;
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(ticks_per_reset);
+
+static ssize_t broadcast_port_show(struct device *d,
+				   struct device_attribute *attr, char *buf)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	int res = 0;
+
+	if (hanic_disp_is_flood(xsp->broadcast_disp))
+		res += sprintf(buf + res, "flood\n");
+	else
+		res += sprintf(buf + res, "%d\n", xsp->broadcast_disp);
+
+	return res;
+}
+
+/* Convert a string to a disposition number. This takes the various
+ * forms that a user might enter.
+ *
+ * Note that "prime" and "second" are legacy values there for
+ * compatibility.
+ */
+static hanic_packet_disposition_t string_to_disposition(const char *text)
+{
+	int rc;
+	int res;
+
+	if (strcmp(text, "prime") == 0)
+		return 0;
+
+	if (strcmp(text, "second") == 0)
+		return 1;
+
+	if (strcmp(text, "flood") == 0)
+		return -1;
+
+	rc = kstrtoint(text, 10, &res);
+	if (rc < 0)
+		return 0;
+	else if (res >= HANIC_PORT_MAX)
+		return 0;
+	else
+		return res;
+}
+
+static ssize_t broadcast_port_store(struct device *d,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	int rc;
+#define CMD_SIZE 63
+	char command[CMD_SIZE + 1];
+
+	rc = sscanf(buf, " %" str_of_value(CMD_SIZE) "s", command);
+	if (rc < 1)
+		return count;
+
+	xsp->broadcast_disp = string_to_disposition(command);
+	return count;
+}
+
+static DEVICE_ATTR_RW(broadcast_port);
+
+static ssize_t arp_rtag_show(struct device *d, struct device_attribute *attr,
+			     char *buf)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	int res = 0;
+
+	res += sprintf(buf, "%d\n", xsp->arp_rtag);
+
+	return res;
+}
+
+static ssize_t arp_rtag_store(struct device *d, struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	int rc;
+	bool val;
+
+	rc = kstrtobool(buf, &val);
+	if (rc)
+		return count;
+
+	xsp->arp_rtag = val;
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(arp_rtag);
+
+static ssize_t multicast_rtag_show(struct device *d,
+				   struct device_attribute *attr, char *buf)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	int res = 0;
+
+	res += sprintf(buf, "%d\n", xsp->multicast_rtag);
+
+	return res;
+}
+
+static ssize_t multicast_rtag_store(struct device *d,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	int rc;
+	bool val;
+
+	rc = kstrtobool(buf, &val);
+	if (rc)
+		return count;
+
+	xsp->multicast_rtag = val;
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(multicast_rtag);
+
+static ssize_t filter_vlan_show(struct device *d, struct device_attribute *attr,
+				char *buf)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	struct hanic_filter_item *cur;
+	int res = 0;
+	int rem = PAGE_SIZE;
+	int bkt;
+
+	hash_for_each (xsp->filter_by_vlan_table, bkt, cur, filter_table) {
+		int rc;
+
+		if (hanic_disp_is_flood(cur->disposition)) {
+			rc = snprintf(buf, rem, "%04x: flood\n", cur->vlan);
+		} else {
+			rc = snprintf(buf, rem, "%04x: %d\n", cur->vlan,
+				      cur->disposition);
+		}
+		buf += rc;
+		res += rc;
+		rem -= rc;
+		if (rem <= 32)
+			break;
+	}
+
+	return res;
+}
+
+static ssize_t filter_vmac_show(struct device *d, struct device_attribute *attr,
+				char *buf)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	struct hanic_filter_item *cur;
+	int res = 0;
+	int rem = PAGE_SIZE;
+	int bkt;
+
+	hash_for_each (xsp->filter_by_vmac_table, bkt, cur, filter_table) {
+		int rc = snprintf(
+			buf, rem,
+			"%02x:%02x:%02x:%02x:%02x:%02x-%04x: ", cur->mac[0],
+			cur->mac[1], cur->mac[2], cur->mac[3], cur->mac[4],
+			cur->mac[5], cur->vlan);
+
+		buf += rc;
+		res += rc;
+		rem -= rc;
+
+		if (hanic_disp_is_flood(cur->disposition))
+			rc = snprintf(buf, rem, "flood\n");
+		else
+			rc = snprintf(buf, rem, "%d\n", cur->disposition);
+
+		buf += rc;
+		res += rc;
+		rem -= rc;
+		if (rem <= 40)
+			break;
+	}
+
+	return res;
+}
+
+static ssize_t filter_vlan_store(struct device *d,
+				 struct device_attribute *attr, const char *buf,
+				 size_t count)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	struct hanic_filter_item *filter;
+	int rc;
+	int vlan;
+#define CMD_SIZE 63
+	char command[CMD_SIZE + 1];
+
+	rc = sscanf(buf, " %x: %" str_of_value(CMD_SIZE) "s", &vlan, command);
+	if (rc < 2)
+		return count;
+
+	if (strcmp(command, "none") == 0) {
+		hanic_clr_filter_vlan(xsp, vlan);
+		return count;
+	}
+
+	filter = hanic_set_filter_vlan(xsp, vlan);
+	filter->disposition = string_to_disposition(command);
+
+	return count;
+}
+
+static ssize_t filter_vmac_store(struct device *d,
+				 struct device_attribute *attr, const char *buf,
+				 size_t count)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	struct hanic_filter_item *filter;
+	int rc;
+	int vlan;
+	int imac[6];
+	uint8_t mac[6];
+#define CMD_SIZE 63
+	char command[CMD_SIZE + 1];
+
+	rc = sscanf(buf, " %x:%x:%x:%x:%x:%x-%x: %" str_of_value(CMD_SIZE) "s",
+		    imac + 0, imac + 1, imac + 2, imac + 3, imac + 4, imac + 5,
+		    &vlan, command);
+	if (rc < 8)
+		return count;
+
+	for (rc = 0; rc < 6; rc += 1)
+		mac[rc] = imac[rc];
+
+	if (strcmp(command, "none") == 0) {
+		hanic_clr_filter_vmac(xsp, mac, vlan);
+		return count;
+	}
+
+	filter = hanic_set_filter_vmac(xsp, mac, vlan);
+	filter->disposition = string_to_disposition(command);
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(filter_vlan);
+static DEVICE_ATTR_RW(filter_vmac);
+
+#if defined(CONFIG_HANIC_FAULT_INJECTION)
+static ssize_t test_drop_packet_in_show(struct device *d,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	ssize_t res = 0;
+	int idx;
+
+	for (idx = 0; idx < HANIC_PORT_MAX; idx += 1) {
+		struct net_device *port = xsp->ports[idx].sl_dev;
+		int val;
+
+		if (port == NULL)
+			continue;
+
+		val = atomic_read(&xsp->ports[idx].test_drop_packet_in);
+		if (val > 0)
+			val -= 1;
+
+		res += sprintf(buf + res, "%d %d\n", idx, val);
+	}
+
+	return res;
+}
+
+static ssize_t test_drop_packet_in_store(struct device *d,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	unsigned int val1;
+	int val2;
+	int rc;
+
+	rc = sscanf(buf, "%u %d", &val1, &val2);
+	if (rc != 2)
+		return count;
+
+	if (val1 >= HANIC_PORT_MAX)
+		return count;
+
+	/* NOTE: Since this value is tested with an
+	 * atomic_dec_if_positive function, the tester will always see
+	 * one less then this value, so increment it to be sure we get
+	 * the correct count of drops. Also account for that in the
+	 * _show method.
+	 */
+	if (val2 <= 0)
+		val2 = 0;
+	else
+		val2 += 1;
+
+	if (xsp->ports[val1].sl_dev == NULL)
+		return count;
+
+	atomic_set(&xsp->ports[val1].test_drop_packet_in, val2);
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(test_drop_packet_in);
+#endif
+
+#if defined(CONFIG_HANIC_FAULT_INJECTION)
+static ssize_t test_drop_packet_out_show(struct device *d,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	ssize_t res = 0;
+	int idx;
+	int val;
+
+	val = atomic_read(&xsp->test_drop_flood_out);
+	if (val > 0)
+		val -= 1;
+
+	res += scnprintf(buf + res, PAGE_SIZE - res, "* %d\n", val);
+
+	for (idx = 0; idx < HANIC_PORT_MAX; idx += 1) {
+		struct net_device *port = xsp->ports[idx].sl_dev;
+
+		if (port == NULL)
+			continue;
+
+		val = atomic_read(&xsp->ports[idx].test_drop_packet_out);
+		if (val > 0)
+			val -= 1;
+
+		res += scnprintf(buf + res, PAGE_SIZE - res, "%d %d\n", idx,
+				 val);
+	}
+
+	return res;
+}
+
+/* The atomic_dec_if_positive returns true fewer times than the actual
+ * value of the atomic variable, so correct for that fence-post error
+ * by calculating an appropriate set value.
+ */
+static int count_to_use_for_atomic_value(int val)
+{
+	if (val <= 0)
+		return 0;
+	else
+		return val + 1;
+}
+
+static ssize_t test_drop_packet_out_store(struct device *d,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	unsigned int val1;
+	int val2;
+	int rc;
+
+	rc = sscanf(buf, "* %u", &val2);
+	if (rc == 1) {
+		val2 = count_to_use_for_atomic_value(val2);
+		atomic_set(&xsp->test_drop_flood_out, val2);
+		return count;
+	}
+
+	rc = sscanf(buf, "%u %u", &val1, &val2);
+	if (rc != 2)
+		return count;
+
+	if (val1 >= HANIC_PORT_MAX)
+		return count;
+
+	if (xsp->ports[val1].sl_dev == NULL)
+		return count;
+
+	val2 = count_to_use_for_atomic_value(val2);
+	atomic_set(&xsp->ports[val1].test_drop_packet_out, val2);
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(test_drop_packet_out);
+#endif
+
+static struct attribute *per_hanic_attrs[HANIC_DEV_ATTRIBUTES + 1] = {
+	&dev_attr_ports.attr,
+	&dev_attr_broadcast_port.attr,
+	&dev_attr_arp_rtag.attr,
+	&dev_attr_multicast_rtag.attr,
+	&dev_attr_jiffies_per_hanic_tick.attr,
+	&dev_attr_ticks_per_reset.attr,
+	&dev_attr_filter_vlan.attr,
+	&dev_attr_filter_vmac.attr,
+#if defined(CONFIG_HANIC_FAULT_INJECTION)
+	&dev_attr_test_drop_packet_in.attr,
+	&dev_attr_test_drop_packet_out.attr,
+#endif
+	NULL
+};
+
+static const struct attribute_group hanic_group = {
+	.name = "hanic",
+	.attrs = per_hanic_attrs,
+};
+
+void hanic_device_sysfs(struct hanic_priv *xsp)
+{
+	xsp->dev->sysfs_groups[0] = &hanic_group;
+}
+
+/* The functions below allow the rest of the driver to add or remove
+ * attribute files to the group for the device. These are used to
+ * create attribute nodes for streams, or other dynamic aspects of
+ * the device operation.
+ */
+int hanic_sysfs_add_attr(struct hanic_priv *xsp, struct attribute *attr)
+{
+	return sysfs_add_file_to_group(&xsp->dev->dev.kobj, attr,
+				       hanic_group.name);
+}
+
+void hanic_sysfs_rem_attr(struct hanic_priv *xsp, struct attribute *attr)
+{
+	sysfs_remove_file_from_group(&xsp->dev->dev.kobj, attr,
+				     hanic_group.name);
+}
+
+/* Show statistics for the stream. Specifically, get the
+ * hanic_stream_item that contains this attribute.
+ *
+ * Note that we want to hold the stream_table_mutex while extracting
+ * the statistics because they may be updated asynchronously. This
+ * also prevents the stream being deleted while getting the stats.
+ */
+ssize_t hanic_stream_show(struct device *d, struct device_attribute *attr,
+			  char *buf)
+{
+	struct net_device *dev = to_net_dev(d);
+	struct hanic_priv *xsp = netdev_priv(dev);
+	struct hanic_stream_item *stream;
+	struct hanic_stream_item_stats stats;
+	int res = 0;
+	int rc, idx;
+	unsigned long flags;
+	const char *tmp;
+
+	/* Get the statistics out of the stream. */
+	spin_lock_irqsave(&xsp->stream_table_lock, flags);
+	stream = container_of(attr, struct hanic_stream_item, attr);
+	stats = stream->stats;
+	spin_unlock_irqrestore(&xsp->stream_table_lock, flags);
+
+	rc = sprintf(buf, "tx_send=%lu rx_rogue=%lu", stats.tx_send,
+		     stats.rx_rogue_packets);
+	res += rc;
+	buf += rc;
+	for (idx = 0; idx < HANIC_PORT_MAX; idx += 1) {
+		rc = sprintf(buf, " rx_cb_pass[%d]=%lu rx_cb_dup[%d]=%lu", idx,
+			     stats.rx_passed[idx], idx,
+			     stats.rx_dropped_duplicates[idx]);
+		res += rc;
+		buf += rc;
+	}
+	rc = sprintf(buf, " rx_seq_recovery_resets=%lu",
+		     stats.rx_seq_recovery_resets);
+	res += rc;
+	buf += rc;
+
+	tmp = " rx_ooo=";
+	for (idx = 0; idx < HANIC_OOO_MAX_STRIDE; idx += 1) {
+		rc = sprintf(buf, "%s%lu", tmp, stats.rx_out_of_order[idx]);
+		tmp = ",";
+		res += rc;
+		buf += rc;
+	}
+
+	rc = sprintf(buf, "\n");
+	res += rc;
+	return res;
+}
-- 
2.38.1


-- 


*Confidentiality Note:* We care about protecting our proprietary 
information, confidential material, and trade secrets. This message may 
contain some or all of those things. Cruise will suffer material harm if 
anyone other than the intended recipient disseminates or takes any action 
based on this message. If you have received this message (including any 
attachments) in error, please delete it immediately and notify the sender 
promptly.
