Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA1C58332C
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 21:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbiG0TMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 15:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbiG0TLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 15:11:55 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC0665D59;
        Wed, 27 Jul 2022 11:55:23 -0700 (PDT)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 26RIsnCD027831
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 27 Jul 2022 20:54:50 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Anton Makarov <anton.makarov11235@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next v5 0/4] seg6: add support for SRv6 Headend Reduced 
Date:   Wed, 27 Jul 2022 20:54:04 +0200
Message-Id: <20220727185408.7077-1-andrea.mayer@uniroma2.it>
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

This patchset adds support for SRv6 Headend behavior with Reduced
Encapsulation. It introduces the H.Encaps.Red and H.L2Encaps.Red versions
of the SRv6 H.Encaps and H.L2Encaps behaviors, according to RFC 8986 [1].

In details, the patchset is made of:
 - patch 1/4: add support for SRv6 H.Encaps.Red behavior;
 - Patch 2/4: add support for SRv6 H.L2Encaps.Red behavior;
 - patch 2/4: add selftest for SRv6 H.Encaps.Red behavior;
 - patch 3/4: add selftest for SRv6 H.L2Encaps.Red behavior.

The corresponding iproute2 patch for supporting SRv6 H.Encaps.Red and
H.L2Encaps.Red behaviors is provided in a separated patchset.

[1] - https://datatracker.ietf.org/doc/html/rfc8986

V4 -> v5:
 - Fix skb checksum for SRH Reduced encapsulation/insertion;

 - Improve selftests by: 
      i) adding a random suffix to network namespaces;
     ii) creating net devices directly into network namespaces;
    iii) using trap EXIT command to properly clean up selftest networks.

 Thanks to Paolo Abeni.

v3 -> v4:
 - Add selftests to the Makefile, thanks to Jakub Kicinski.

v2 -> v3:
 - Keep SRH when HMAC TLV is present;

 - Split the support for H.Encaps.Red and H.L2Encaps.Red behaviors in two
   patches (respectively, patch 1/4 and patch 2/4);

 - Add selftests for SRv6 H.Encaps.Red and H.L2Encaps.Red.

v1 -> v2:
 - Fixed sparse warnings;

 - memset now uses sizeof() instead of hardcoded value;

 - Removed EXPORT_SYMBOL_GPL.

Andrea Mayer (4):
  seg6: add support for SRv6 H.Encaps.Red behavior
  seg6: add support for SRv6 H.L2Encaps.Red behavior
  selftests: seg6: add selftest for SRv6 H.Encaps.Red behavior
  selftests: seg6: add selftest for SRv6 H.L2Encaps.Red behavior

 include/uapi/linux/seg6_iptunnel.h            |   2 +
 net/ipv6/seg6_iptunnel.c                      | 140 ++-
 tools/testing/selftests/net/Makefile          |   2 +
 .../net/srv6_hencap_red_l3vpn_test.sh         | 879 ++++++++++++++++++
 .../net/srv6_hl2encap_red_l2vpn_test.sh       | 821 ++++++++++++++++
 5 files changed, 1842 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/net/srv6_hencap_red_l3vpn_test.sh
 create mode 100755 tools/testing/selftests/net/srv6_hl2encap_red_l2vpn_test.sh

-- 
2.20.1

