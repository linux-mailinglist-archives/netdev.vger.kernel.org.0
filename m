Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995ED298766
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 08:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769474AbgJZH3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 03:29:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46817 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1769470AbgJZH3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 03:29:46 -0400
Received: by mail-pf1-f195.google.com with SMTP id y14so5694270pfp.13
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 00:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V9hY/hW3qODOdvbaB6VAC9KlZNtZBrOl2rIEHyTtF2U=;
        b=utB+EIfZ9p3658WPKCf2yVaXbQGxYLpvBfVMEbgNcAeX5+KIh9ywPRYDYvVpGNx+dn
         RNpiYcbjbuQhoTHH7QJj3J0XzClsiEkeQH9CWS8SoUdCfm7srujwM4O4xQi9s7xQd14A
         TJteEdPOpcUQMuRIk+P37vYrgJnNtUZPPdIsU0Bjf4qH02vd4pAmMo1mAscS8OgKAO92
         7OZHbbo/pyk2rr7NLcRnPYVS8zYcanUYaKn0hgGgaVn0VImCNrsdB2yfQYORNyE9Cv5z
         dv4l61PdcbvMOGc9yEMxspulytTLs8oRe7Sa6iPc4mD2bcnerBwXkW49v+Vcz/H+Zz2H
         B6ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V9hY/hW3qODOdvbaB6VAC9KlZNtZBrOl2rIEHyTtF2U=;
        b=Kzywqf4mJbz0N0h34Fx5MYuYu6mEDY8tWyK0mR71lmxjGw8hBm1ViV3+NLSzGiRWdj
         k8zuL3ojDi5QfYIa4Zeop+3v1f3WJJ0BjX6ICk5AQaBoXHEl+r98RdZ9+jxqLBa7lAfu
         KIgnx9HGEM2fFKQ/81L/RyjvM76bOH0q4lAE6s5JT3qeC1q899lrqodgwm4Iuj92Ywqg
         WIpNX2BAj/spjh4ZndGr1dhVT+JlSQwDmzSBMP/A8kPFQknYucKoFNbcqgBA8MSAwvmY
         KOfrVkgBjrG9yC3kSE6bOD/SvqAygzKMcIqV1nwMyFMB1heMLL8jSFk8NOSxzkPpC782
         MDDQ==
X-Gm-Message-State: AOAM533NWBuxINCJAwLiFfMBdfWRftI/arbN4h/ycnp7BsU0JXaN+RSN
        XrLJ64qW6NEr8qNFHl09rxkQs4JnwCNG9F1t
X-Google-Smtp-Source: ABdhPJyeQiweGzc1lRrOUaHetUz2M+INof/Wvis2FZAEWOYBo2o1s4vHwLEFOE5/9iAy50PPlJ+csA==
X-Received: by 2002:a63:9508:: with SMTP id p8mr15008804pgd.189.1603697385228;
        Mon, 26 Oct 2020 00:29:45 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v24sm9766547pgi.91.2020.10.26.00.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 00:29:44 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv4 net 0/2] IPv6: reply ICMP error if fragment doesn't contain all headers
Date:   Mon, 26 Oct 2020 15:29:24 +0800
Message-Id: <20201026072926.3663480-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201023064347.206431-1-liuhangbin@gmail.com>
References: <20201023064347.206431-1-liuhangbin@gmail.com>
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
 net/ipv6/icmp.c             |  8 +++++++-
 net/ipv6/reassembly.c       | 33 ++++++++++++++++++++++++++++++++-
 3 files changed, 40 insertions(+), 2 deletions(-)

-- 
2.25.4

