Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57605B5FC4
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiILSF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiILSFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:05:25 -0400
X-Greylist: delayed 601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Sep 2022 11:05:22 PDT
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74D227DDA;
        Mon, 12 Sep 2022 11:05:19 -0700 (PDT)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 28CHGubU031029
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 12 Sep 2022 19:16:57 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next v2 0/3] seg6: add NEXT-C-SID support for SRv6 End behavior
Date:   Mon, 12 Sep 2022 19:16:16 +0200
Message-Id: <20220912171619.16943-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Segment Routing (SR) architecture is based on loose source routing.
A list of instructions, called segments, can be added to the packet headers to
influence the forwarding and processing of the packets in an SR enabled
network.
In SRv6 (Segment Routing over IPv6 data plane) [1], the segment identifiers
(SIDs) are IPv6 addresses (128 bits) and the segment list (SID List) is carried
in the Segment Routing Header (SRH). A segment may correspond to a "behavior"
that is executed by a node when the packet is received.
The Linux kernel currently supports a large subset of the behaviors described
in [2] (e.g., End, End.X, End.T and so on).

Some SRv6 scenarios (i.e.: traffic-engineering, fast-rerouting, VPN, mobile
network backhaul, etc.) may require a large number of segments (i.e. up to 15).
Therefore, reducing the size of the SID List is useful to minimize the impact
on MTU (Maximum Transfer Unit) and to enable SRv6 on legacy hardware devices
with limited processing power that can suffer from long IPv6 headers.

Draft-ietf-spring-srv6-srh-compression [3] extends the SRv6 architecture by
providing different mechanisms for the efficient representation (i.e.
compression) of the SID List. 

The NEXT-C-SID mechanism described in [3] offers the possibility of encoding
several SRv6 segments within a single 128 bit SID address. Such a SID address
is called a Compressed SID Container. In this way, the length of the SID List
can be drastically reduced. In some cases, the SRH can be omitted, as the IPv6
Destination Address can carry the whole Segment List, using its compressed
representation.

The NEXT-C-SID mechanism relies on the "flavors" framework defined in [2].
The flavors represent additional operations that can modify or extend a subset
of the existing behaviors. 

In this patchset we extend the SRv6 Subsystem in order to support the
NEXT-C-SID mechanism.

In details the patchset is made of:
 - patch 1/3: add netlink_ext_ack support in parsing SRv6 behavior attributes;
 - patch 2/3: add NEXT-C-SID support for SRv6 End behavior;
 - patch 3/3: add selftest for NEXT-C-SID in SRv6 End behavior.

The corresponding iproute2 patch for supporting the NEXT-C-SID in SRv6 End
behavior is provided in a separated patchset.

Comments, improvements and suggestions are always appreciated.

Thank you all,
Andrea

[1] - https://datatracker.ietf.org/doc/html/rfc8754
[2] - https://datatracker.ietf.org/doc/html/rfc8986
[3] - https://datatracker.ietf.org/doc/html/draft-ietf-spring-srv6-srh-compression 

v1 -> v2:
 - rename misleading variable names and macros, using the suffix '_bits' instead
   of '_len', e.g. 'lcblock_len'->'lcblock_bits';
 - remove unnecessary cast operations;
 - get rid of the 'yoda-style' syntax;
 - fix check for default C-SID configuration at compilation time;
 - add selftest for NEXT-C-SID in SRv6 End behavior.

 Thanks to Paolo Abeni for reviewing v1.

Andrea Mayer (3):
  seg6: add netlink_ext_ack support in parsing SRv6 behavior attributes
  seg6: add NEXT-C-SID support for SRv6 End behavior
  selftests: seg6: add selftest for NEXT-C-SID flavor in SRv6 End
    behavior

 include/uapi/linux/seg6_local.h               |   24 +
 net/ipv6/seg6_local.c                         |  379 +++++-
 tools/testing/selftests/net/Makefile          |    1 +
 .../net/srv6_end_next_csid_l3vpn_test.sh      | 1145 +++++++++++++++++
 4 files changed, 1530 insertions(+), 19 deletions(-)
 create mode 100755 tools/testing/selftests/net/srv6_end_next_csid_l3vpn_test.sh

-- 
2.20.1

