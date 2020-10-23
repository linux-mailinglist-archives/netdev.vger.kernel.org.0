Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC0B2969DB
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 08:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373098AbgJWGoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 02:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373093AbgJWGoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 02:44:02 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDAAC0613CE
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 23:44:02 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r10so441288pgb.10
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 23:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fAJGy85qfcOjdWWbSLTWCUbSGLy2IP9bDFt7rP6Ji6c=;
        b=CjhrGe2nZEd/bvXbVfK5ra7MmCI4gSgkwNl1DY/JDo9lrOCbfRzyCrLfkd4E33kzZl
         rvsTGB/dFzuuljQllEOJZFTuBMKfAkQ/EIZlQ2li7NPhB9FhYmo6XzUKHnFfFJ7XPLPy
         s5kXrtI17q0YhJOK1YaxJnwkiKGJ2akrJZBySVOxwW7w0UatYkL+K0CuDAfHEWhBwn71
         OjPAsBZg16/b8mAOAPsFOeXCL+FsFXvtZsFYgRAiFSkRctgcNltSZTMRr9NduxdW7sWE
         YTUtzLFCvvY2NX94J8IfIBMcOaWhW/zYhH266M1HWBcOk1TSuAKtTsgFy5xE6YgBU5ua
         91cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fAJGy85qfcOjdWWbSLTWCUbSGLy2IP9bDFt7rP6Ji6c=;
        b=Z4T1XYO0nqk+CRV6AGr+oE07RoqzJjVofwrDXGAOBzqPU7v9ksOWtdgsuOBq2ITIRr
         X/+U/HVrbio/V9zFlXg2Pqxhpr5RZuemAXERqArCBD4jSHegwZ8VcwKYzrN9u8LIpmZv
         Lu4zxfwXMxEHboIHeo+mV/ZKMI5KVF5nFJ4d5oEs6MbICf2yFymyyP0xScAfDUNy/D5z
         1mitA910QSrq7bllRqYUfSRbuQ8rSOTw1lWaa0DiXlKyUdn62H1WrZF6Yigd3RP68En+
         WTkOxQE3KGmTkdveDlzB0jwgO+ufobW3cUuPpVf2xXcXZzGbida86OONLwQ3X68N1USe
         pRVw==
X-Gm-Message-State: AOAM533pmgAcUTyIjL46/drIkNwHu3rYAwghZiH8dccsPvtJb0Vpzkn6
        ikssKDdR/64zVrq2/cpHAJwqbaSg23A1RdII
X-Google-Smtp-Source: ABdhPJwHGYPcUBA+sxHZ5DA7zBV8UuQalFxukEAejKdXtPGgd5eHyJBvbX8Y9M+MH8ni/XL+t7KTig==
X-Received: by 2002:a65:4905:: with SMTP id p5mr843547pgs.299.1603435441541;
        Thu, 22 Oct 2020 23:44:01 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s23sm716088pgl.47.2020.10.22.23.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 23:44:01 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 net 0/2] IPv6: reply ICMP error if fragment doesn't contain all headers
Date:   Fri, 23 Oct 2020 14:43:45 +0800
Message-Id: <20201023064347.206431-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201021042005.736568-1-liuhangbin@gmail.com>
References: <20201021042005.736568-1-liuhangbin@gmail.com>
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
 net/ipv6/icmp.c             | 10 +++++++++-
 net/ipv6/reassembly.c       | 33 ++++++++++++++++++++++++++++++++-
 3 files changed, 42 insertions(+), 2 deletions(-)

-- 
2.25.4

