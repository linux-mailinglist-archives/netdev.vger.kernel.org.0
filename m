Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A5129AC28
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 13:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751255AbgJ0Mdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 08:33:37 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35193 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbgJ0Mdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 08:33:36 -0400
Received: by mail-pg1-f194.google.com with SMTP id f38so718040pgm.2
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 05:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V9hY/hW3qODOdvbaB6VAC9KlZNtZBrOl2rIEHyTtF2U=;
        b=RtT0cZmQ6OBeZGO+l1Ex53MQ+PCgXij/u73M48jayYAQnfexVPHUx2dDPmmmePEiuk
         klKRdk30VONEKCE8tIVIbHyPSbbzLVCW/vBODu+TVCprS4Rj+zDthbpGMAgBMORNLKFh
         uj0AY8Q3LEVcD6QkFtSBq1YH2DWtvR5Hl8Ru8JlI21GimqqJ2J4yQSyqYGO4e7Apwnrn
         xORQB4BmaA+RrWXGb8yqnhNv99HhGc+Y9PJ7A0rAn3sk0LuxwGBfPbvZfIu9BDQ7xSYD
         LHi3YGlsINla2kju1TknR912RxvHiQoM+g2WaE0GQeSki9csZ9U2XhdbDwUwTBxiLNrZ
         h1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V9hY/hW3qODOdvbaB6VAC9KlZNtZBrOl2rIEHyTtF2U=;
        b=I05G/hYXqHn3zDygG0PQDg9bbU5mcu0tNEoEaMLt6mcl95ocVV5tsu1vPD2FZgCBaC
         GaqdEky0P3uvfWUHrG7kSVpYcBe22LnNieJs5cRieujQ/OshCbDMYNFKYsAN+ZBfuh4K
         iIkqplUG3TRSATuQjkdZfW4hL84LpS81k17Hqd6a6NVAzvBImwtrkbKwjPf1OFiP/xn3
         84GlZ6agi0S+JW7pZDmNCdlGQt7bLZsp0CZyaWa0ZwORS81xwSy1y8jWjRGSeOzoyoFG
         HCD2tbrXSZgZ5BnO6FXD9sYPJmDJ77/kbW0NY79eTw/8J9/p2gzuXZaWb/U1hzMUa/2Z
         XEEA==
X-Gm-Message-State: AOAM531XqMfzr7iRhQ/gnGVDDFZ7fdsql7ViyVoJJH9P0Cwxolo7oine
        dM0cBi14enG+Vvxst8JUw3BCM7IFMPtGLR/0
X-Google-Smtp-Source: ABdhPJypfSWfdNu51uh+1wg/V2FfrSmNB48ZxosZy8WDxpuheaMWoMHihZPNwT4d4UghGmJA7FoEJw==
X-Received: by 2002:a62:e811:0:b029:164:4551:926c with SMTP id c17-20020a62e8110000b02901644551926cmr887395pfi.27.1603802014327;
        Tue, 27 Oct 2020 05:33:34 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q189sm2251231pfc.94.2020.10.27.05.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 05:33:33 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Georg Kohmann <geokohma@cisco.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv6 net 0/2] IPv6: reply ICMP error if fragment doesn't contain all headers
Date:   Tue, 27 Oct 2020 20:33:11 +0800
Message-Id: <20201027123313.3717941-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201027022833.3697522-1-liuhangbin@gmail.com>
References: <20201027022833.3697522-1-liuhangbin@gmail.com>
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

