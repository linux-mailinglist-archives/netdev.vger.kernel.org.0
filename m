Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0686294736
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 06:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440133AbgJUEUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 00:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411910AbgJUEUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 00:20:18 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1AAC0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 21:20:18 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id p21so489565pju.0
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 21:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o6n2OPJ58nquKMSqfzMR9b8mb/o0kOk5sAPsUBVTASo=;
        b=L9d49Ia9P45T0xNs0+rh5uslx00fGJ5AftAFF3AM0S8XFtf5rWaW3LPKeZPbHkEpy/
         n/yngPIZxj1T4R8usfAVcL+TJJU97IRgrf/KO1NoarNJ+sOQ/LojCnxIylpEU7rjbiDC
         vBbTpTWrD6vR36BE6RZDin9TwDYFmtcr7I+DLmROpGSNn79GpSfVYoRYPGmaCkECXFyp
         BTQL3/S19JoH1lspUulHbeilOaqwq2hK9Sj5PUQpP+Q9E7aoQ5mGf0RNF+Tmyq/whFUN
         Odsjr8kDZPLX32b0uQ8jLp4uvZVCJFnFI9MGmbotRMiqf++PHtPh3EMK7L/nM/YuOwpS
         I8cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o6n2OPJ58nquKMSqfzMR9b8mb/o0kOk5sAPsUBVTASo=;
        b=oTaKMEy00lwHEZ1N9e9q6jAh6jrC0od50K/RegNUyAIS7aIFnLN4hurgyntWqpNMvP
         cecV1VAUR2wHO/oRLtCqi5lQ+TwSm1QKIoqxk0b2zD8kvaaYF2W8UXQEJOgyzgyWZGVb
         +qqu3j4jb/B9Zz/9jjnuRvqR0Ptr2PgsfmVSYmJctsaACc2RTVnIBcdup4l6Wd8ZQ1sC
         QuAd/ioaKRQZj9uC8Xzwmq7kC8VXg/4vQFQ/4APC0GfNhE25wJsGToi0cyehWLhlPoyA
         akbmwn7sWHvhPi98g/jBBJD9zflpBkMT0Om3HHKkmkaeqa+g9tNmboL04NXjMsHyYJ6B
         hIiA==
X-Gm-Message-State: AOAM533U4ttdUzd6A4W8gORDi5WJS6pdCtoaKVpwPz45UkeMqxlRZhgf
        qSWPpl4i7RiJN6fxU0i4b1zNnQuSUxuYDE68
X-Google-Smtp-Source: ABdhPJzRBfnB+67ilqO78CV91Q4yCM7T2QHeVvckPNAcjYY4SAwNyAiMGq5FBkXw77WUGJKPN+dSaA==
X-Received: by 2002:a17:902:c3c5:b029:d3:df24:1ffb with SMTP id j5-20020a170902c3c5b02900d3df241ffbmr1569399plj.35.1603254018064;
        Tue, 20 Oct 2020 21:20:18 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e21sm545796pfl.22.2020.10.20.21.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 21:20:17 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 0/2] IPv6: reply ICMP error with fragment doesn't contain all headers
Date:   Wed, 21 Oct 2020 12:20:03 +0800
Message-Id: <20201021042005.736568-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201007035502.3928521-1-liuhangbin@gmail.com>
References: <20201007035502.3928521-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When our Engineer run latest IPv6 Core Conformance test, test v6LC.1.3.6:
First Fragment Doesn’t Contain All Headers[1] failed. The test purpose is to
verify that the node(Linux for example) should properly process IPv6 packets
that don’t include all the headers through the Upper-Layer header.

Based on RFC 8200, Section 4.5 Fragment Header

  -  If the first fragment does not include all headers through an
     Upper-Layer header, then that fragment should be discarded and
     an ICMP Parameter Problem, Code 3, message should be sent to
     the source of the fragment, with the Pointer field set to zero.

The first patch add a definition for ICMPv6 Parameter Problem, code 3.
The second patch add a check for the 1st fragment packet to make sure
Upper-Layer header exist.

[1] Page 68, v6LC.1.3.6: First Fragment Doesn’t Contain All Headers part A, B,
C and D at https://ipv6ready.org/docs/Core_Conformance_5_0_0.pdf
[2] My reproducer:
#!/usr/bin/env python3

import sys, os
from scapy.all import *

# Test v6LC.1.3.6: First Fragment Doesn’t Contain All Headers
def send_frag_dst_opt(src_ip6, dst_ip6):
    ip6 = IPv6(src = src_ip6, dst = dst_ip6, nh = 44)

    frag_1 = IPv6ExtHdrFragment(nh = 60, m = 1)
    dst_opt = IPv6ExtHdrDestOpt(nh = 58)

    frag_2 = IPv6ExtHdrFragment(nh = 58, offset = 4, m = 1)
    icmp_echo = ICMPv6EchoRequest(seq = 1)

    pkt_1 = ip6/frag_1/dst_opt
    pkt_2 = ip6/frag_2/icmp_echo

    send(pkt_1)
    send(pkt_2)

def send_frag_route_opt(src_ip6, dst_ip6):
    ip6 = IPv6(src = src_ip6, dst = dst_ip6, nh = 44)

    frag_1 = IPv6ExtHdrFragment(nh = 43, m = 1)
    route_opt = IPv6ExtHdrRouting(nh = 58)

    frag_2 = IPv6ExtHdrFragment(nh = 58, offset = 4, m = 1)
    icmp_echo = ICMPv6EchoRequest(seq = 2)

    pkt_1 = ip6/frag_1/route_opt
    pkt_2 = ip6/frag_2/icmp_echo

    send(pkt_1)
    send(pkt_2)

if __name__ == '__main__':
    src = sys.argv[1]
    dst = sys.argv[2]
    conf.iface = sys.argv[3]
    send_frag_dst_opt(src, dst)
    send_frag_route_opt(src, dst)

Hangbin Liu (2):
  ICMPv6: Add ICMPv6 Parameter Problem, code 3 definition
  IPv6: reply ICMP error if the first fragment don't include all headers

 include/uapi/linux/icmpv6.h |  1 +
 net/ipv6/icmp.c             | 13 ++++++++++++-
 net/ipv6/reassembly.c       | 18 +++++++++++++++++-
 3 files changed, 30 insertions(+), 2 deletions(-)

-- 
2.25.4

