Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A57028576C
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 05:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgJGDzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 23:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGDzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 23:55:31 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB415C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 20:55:31 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n9so527460pgf.9
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 20:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0aHJzV4+ZSQABylhycjqAClix+sMrNfpkuiDZfkonKE=;
        b=eKoRAIcYG/1rV8sWw7siS6lG8/8FqAAEWgJUa6l8c73SxeIl4MiIWQ+A/aO/ufeQ3c
         tO6gK6YVYFk+ZJK8GSt+VeqV6ZImzzYHUm7h3z9bbPZPF4rabnRRQB4kh1zycIeP8k2/
         6x17AOTV6CfqHvs6oC4/4iMVQ478we3c+weaGByzxuvuCLpvDPEAQDhlZJyVBZO5xP5I
         1p/5QkweUWyPNQ0gc2m9gmarH2EPlZS3IOCdMTzTE5X6h7ofqSFnRlP5EgS6Wtx5c8uz
         BumJYeIhvoeB4k93YnFZX1cSkyTqAXo8h3ayqWdhpac4EQ2+Xq33xVPv1tsyDEqrAT8G
         vLWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0aHJzV4+ZSQABylhycjqAClix+sMrNfpkuiDZfkonKE=;
        b=AQmJS+hX2QUGxAVfpr/vj3zD590A4d5Tc4Jdfz4xFKiUDqlyHMAI1RPQmM3fvz+R/4
         1LfEvEYHJWiCTb/q4dLDLup4FeK8/Px04ub07/upPddTLVmITC2YegmzXAxXBynuVUT8
         BDrNVTGGQCp2Tt7ry71B6IawSbR/mfBo1kbXmkxO/f3oq7KE2MEjWQCKFHaK2c5GLULC
         eYYVQHV3gH4nVeonRnWcKSO5REjMPsYwmSSPFDXeWHQdUBe50APmX1v5FPvs2gVqVCfs
         P8HK4ukWpUquo8DMZhJWPmI2k+s/boOjEkOeWB0EwWzse6zXeoQ7yHTljXu3f0ki6/nH
         HbFw==
X-Gm-Message-State: AOAM533tdOcBu3MmPbXJTfeR779PG0fHtL3Ed39qTcVshxWsjYUuYbNi
        bfteos12jGhyE1I0EYTT3aPgt7uRbrY0HQ==
X-Google-Smtp-Source: ABdhPJz4ABnwNcuhRvwU1WZIbr5jHXwE84Q+mgH4BBsQ1gEnWDQPtTsJBvyE/XVuFzYE4xYnhXTaQg==
X-Received: by 2002:aa7:8d4c:0:b029:150:f692:4129 with SMTP id s12-20020aa78d4c0000b0290150f6924129mr1147824pfe.11.1602042931146;
        Tue, 06 Oct 2020 20:55:31 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d12sm748246pgd.93.2020.10.06.20.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 20:55:30 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 0/2] IPv6: reply ICMP error with fragment doesn't contain all headers
Date:   Wed,  7 Oct 2020 11:55:00 +0800
Message-Id: <20201007035502.3928521-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
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
 net/ipv6/ip6_input.c        | 20 +++++++++++++++++++-
 3 files changed, 32 insertions(+), 2 deletions(-)

-- 
2.25.4

