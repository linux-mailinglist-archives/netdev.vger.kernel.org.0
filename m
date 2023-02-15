Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B76697E0D
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 15:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjBOOJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 09:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjBOOJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 09:09:56 -0500
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC99113E2;
        Wed, 15 Feb 2023 06:09:53 -0800 (PST)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 31FDlD5J003217
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Feb 2023 14:47:13 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next 0/3] seg6: add PSP flavor support for SRv6 End behavior
Date:   Wed, 15 Feb 2023 14:46:56 +0100
Message-Id: <20230215134659.7613-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Segment Routing for IPv6 (SRv6 in short) [1] is the instantiation of the
Segment Routing (SR) [2] architecture on the IPv6 dataplane. 
In SRv6, the segment identifiers (SID) are IPv6 addresses and the segment list
(SID List) is carried in the Segment Routing Header (SRH). A segment may be
bound to a specific packet processing operation called "behavior". The RFC8986
[3] defines and standardizes the most common/relevant behaviors for network
operators, e.g., End, End.X and End.T and so on.

The RFC8986 also introduces the "flavors" framework aiming to modify or extend
the capabilities of SRv6 End, End.X and End.T behaviors. Specifically, these
behaviors support the following flavors (either individually or in
combinations):
 - Penultimate Segment Pop (PSP);
 - Ultimate Segment Pop (USP);
 - Ultimate Segment Decapsulation (USD).

Such flavors enable an End/End.X/End.T behavior to pop the SRH on the
penultimate/ultimate SR endpoint node listed in the SID List or to perform a
full decapsulation.

Currently, the Linux kernel supports a large subset of behaviors described in
RFC8986, including the End, End.X and End.T. However, PSP, USP and USD flavors
have not yet been implemented.

In this patchset, we extend the SRv6 subsystem to implement the PSP flavor in
the SRv6 End behavior. To accomplish this task, we leverage the flavor
framework previously introduced by another patchset required for supporting the
efficient representation of the SID List through the NEXT-C-SID mechanism [4].

In details, the patchset is made of:
 - patch 1/3: seg6: factor out End lookup nexthop processing to a dedicated 
              function
 - patch 2/3: seg6: add PSP flavor support for SRv6 End behavior
 - patch 3/3: selftests: seg6: add selftest for PSP flavor in SRv6 End 
              behavior

From the user space perspective, we do not need to change the iproute2 code to
support the PSP flavor. However, we provide the man page for the PSP flavor in
a separate patch.

Comments, improvements and suggestions are always appreciated.

Thank you all,
Andrea

[1] - RFC8754: https://datatracker.ietf.org/doc/html/rfc8754
[2] - RFC8402: https://datatracker.ietf.org/doc/html/rfc8402
[3] - RFC8986: https://datatracker.ietf.org/doc/html/rfc8986
[4] - https://datatracker.ietf.org/doc/html/draft-ietf-spring-srv6-srh-compression

Andrea Mayer (3):
  seg6: factor out End lookup nexthop processing to a dedicated function
  seg6: add PSP flavor support for SRv6 End behavior
  selftests: seg6: add selftest for PSP flavor in SRv6 End behavior

 net/ipv6/seg6_local.c                         | 352 ++++++-
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/srv6_end_flavors_test.sh    | 869 ++++++++++++++++++
 3 files changed, 1213 insertions(+), 9 deletions(-)
 create mode 100755 tools/testing/selftests/net/srv6_end_flavors_test.sh

-- 
2.20.1

