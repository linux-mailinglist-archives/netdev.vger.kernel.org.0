Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5132C1321
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 19:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgKWSbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 13:31:01 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:41920 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728631AbgKWSbA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 13:31:00 -0500
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0ANITqge016939
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Nov 2020 19:29:53 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next v3 0/8] seg6: add support for SRv6 End.DT4/DT6 behavior
Date:   Mon, 23 Nov 2020 19:28:48 +0100
Message-Id: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset provides support for the SRv6 End.DT4 and SRv6 End.DT6 (VRF mode)
behavior.

The SRv6 End.DT4 is used to implement multi-tenant IPv4 L3 VPN. It decapsulates
the received packets and performs IPv4 routing lookup in the routing table of
the tenant. The SRv6 End.DT4 Linux implementation leverages a VRF device. The
SRv6 End.DT4 is defined in the SRv6 Network Programming [1].

The Linux kernel already offers an implementation of the SRv6 End.DT6
behavior which permits IPv6 L3 VPNs over SRv6 networks. This new
implementation of DT6 is based on the same VRF infrastructure already
exploited for implementing the SRv6 End.DT4 behavior. The aim of the new
SRv6 End.DT6 in VRF mode consists in simplifying the construction of IPv6
L3 VPN services in the multi-tenant environment.
Currently, the two SRv6 End.DT6 implementations (legacy and VRF mode)
coexist seamlessly and can be chosen according to the context and the user
preferences.

- Patch 1 is needed to solve a pre-existing issue with tunneled packets
  when a sniffer is attached;

- Patch 2 improves the management of the seg6local attributes used by the
  SRv6 behaviors;

- Patch 3 adds support for optional attributes in SRv6 behaviors;

- Patch 4 introduces two callbacks used for customizing the
  creation/destruction of a SRv6 behavior;

- Patch 5 is the core patch that adds support for the SRv6 End.DT4
  behavior;

- Patch 6 introduces the VRF support for SRv6 End.DT6 behavior;

- Patch 7 adds the selftest for SRv6 End.DT4 behavior;

- Patch 8 adds the selftest for SRv6 End.DT6 (VRF mode) behavior;

- Patch 9 adds the vrftable attribute for End.DT4/DT6 behaviors in iproute2.

I would like to thank David Ahern for his support during the development of
this patchset.

Comments, suggestions and improvements are very welcome!

Thanks,
Andrea Mayer

v3
 notes about the build bot:
  - apparently the ',' (comma) in the subject prefix confused the build bot.
    Removed the ',' in favor of ' ' (space). 
    
    Thanks to David Ahern and Konstantin Ryabitsev for shedding light on this
    fact.
    Thanks also to Nathan Chancellor for trying to build the patchset v2 by
    simulating the bot issue.

 add new patch for iproute2:
  - [9/9] seg6: add support for vrftable attribute in End.DT4/DT6 behaviors

 add new patch:
  -  [8/9] selftests: add selftest for the SRv6 End.DT6 (VRF) behavior

 add new patch:
  - [6/9] seg6: add VRF support for SRv6 End.DT6 behavior

 add new patch:
  - [3/9] seg6: add support for optional attributes in SRv6 behaviors

 selftests: add selftest for the SRv6 End.DT4 behavior
  - keep David Ahern's review tag since the code wasn't changed. Thanks to David  
    Ahern for his review.

 seg6: add support for the SRv6 End.DT4 behavior
  - remove useless error in seg6_end_dt4_build();
  - remove #ifdef/#endif stubs for DT4 when CONFIG_NET_L3_MASTER_DEV is not
    defined;
  - fix coding style.

    Thanks to Jakub Kicinski for his review and for all his suggestions.

 seg6: add callbacks for customizing the creation/destruction of a behavior
  - remove typedef(s) slwt_{build/destroy}_state_t;
  - fix coding style: remove empty lines, trivial comments and rename labels in
    the seg6_local_build_state() function.
    
    Thanks to Jakub Kicinski for his review and for all his suggestions.

 seg6: improve management of behavior attributes
  - remove defensive programming approach in destroy_attr_srh(),
    destroy_attr_bpf() and destroy_attrs();
  - change the __destroy_attrs() function signature, renaming the 'end' argument    
    'parsed_max'. Now, the __destroy_attrs() keeps only the 'parsed_max' and
    'slwt' arguments.
    
    Thanks to Jakub Kicinski for his review and for all his suggestions.

 vrf: add mac header for tunneled packets when sniffer is attached
  - keep David Ahern's review tag since the code wasn't changed. 
    
    Thanks to Jakub Kicinski for pointing it out and David Ahern for his review.

v2
 no changes made: resubmitted after false build report.

v1
 improve comments;

 add new patch 2/5 titled: seg6: improve management of behavior attributes

 seg6: add support for the SRv6 End.DT4 behavior
  - remove the inline keyword in the definition of fib6_config_get_net().

 selftests: add selftest for the SRv6 End.DT4 behavior
  - add check for the vrf sysctl

[1] https://tools.ietf.org/html/draft-ietf-spring-srv6-network-programming

Andrea Mayer (8):
  vrf: add mac header for tunneled packets when sniffer is attached
  seg6: improve management of behavior attributes
  seg6: add support for optional attributes in SRv6 behaviors
  seg6: add callbacks for customizing the creation/destruction of a
    behavior
  seg6: add support for the SRv6 End.DT4 behavior
  seg6: add VRF support for SRv6 End.DT6 behavior
  selftests: add selftest for the SRv6 End.DT4 behavior
  selftests: add selftest for the SRv6 End.DT6 (VRF) behavior

 drivers/net/vrf.c                             |  78 ++-
 include/uapi/linux/seg6_local.h               |   1 +
 net/ipv6/seg6_local.c                         | 593 +++++++++++++++++-
 .../selftests/net/srv6_end_dt4_l3vpn_test.sh  | 494 +++++++++++++++
 .../selftests/net/srv6_end_dt6_l3vpn_test.sh  | 502 +++++++++++++++
 5 files changed, 1649 insertions(+), 19 deletions(-)
 create mode 100755 tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
 create mode 100755 tools/testing/selftests/net/srv6_end_dt6_l3vpn_test.sh

Paolo Lungaroni (1):
  seg6: add support for vrftable attribute in End.DT4/DT6 behaviors

 include/uapi/linux/seg6_local.h |  1 +
 ip/iproute_lwtunnel.c           | 19 ++++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

-- 
2.20.1

