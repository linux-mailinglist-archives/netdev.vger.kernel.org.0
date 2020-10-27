Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB87529A2AF
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 03:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392786AbgJ0C3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 22:29:01 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:37565 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729249AbgJ0C3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 22:29:01 -0400
Received: by mail-pl1-f181.google.com with SMTP id b12so3330252plr.4
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 19:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V9hY/hW3qODOdvbaB6VAC9KlZNtZBrOl2rIEHyTtF2U=;
        b=Gglg8NlWNuTsHQR2jCWlAEBxFv4uLq8u8uapXUZS0kjd7JeDKVz++NVHPKmeXy3jd8
         0O3JKFBH01eTDPGHnkt3erNkUoVHOhtnuV+s4VocsBkeqc82sqeLBvS7ZO2ZbRsu2rqn
         ZagILPt5VQjUaxEXA0bYOqDUEZuFZiz8PVGNiPxDEy7SEEfwU5zcmhZrkNDgLSDSokz+
         PNEF+wLtkxa2LVJq0Lk7rof1cc6nv3wVWZ7xLfY4D29e4yxhXPfUiLQw64MPgNYZjhID
         zfCNMnU7bCr+vghtGZ6wiEbImjSqAURdb+EDBzoEwAJR8T7YoamA39dR0RPaiDXhAbjQ
         bvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V9hY/hW3qODOdvbaB6VAC9KlZNtZBrOl2rIEHyTtF2U=;
        b=s8bqUQYScq60+qLvE5BQQZ/jjbaI7mVRao0BcMO5lipApxWdzu4Q9OXExCm0euDDST
         ZC72KrpBnJv5Z1x/P03SscOHM+1YoXCKu18xtaYGFn7H0/+FzudCh3EZ4aR+ZYZ4KmGI
         hI7jhjQ2AoIV73mXZyT8of51QQOlodvWi6eUFwfQN7F9TPgNI7z7APbKMrHiMLNUMmYF
         PIDrxN4vKhLAk71sdhfceJn2nBG6QRSVyjXoK0pufJU9LgG0zr8wQ8NmcqB6//0IJLZU
         znI9zfleoVPQu3CJ6ja6ckCtVH3re4ThAEkTusFvIdllDa/8cVxL19qxxDY0MxZaMnyt
         kvcA==
X-Gm-Message-State: AOAM530o1g1L8c+d001tD1FHfresbhlDXbJ8yreDbL4w86c/HAcl5cj9
        hRwvhLuVEKrgkdxg2UxSaLXO9oIljWE81wi/
X-Google-Smtp-Source: ABdhPJyk5elxcP+6+AurF+kPXaqoacdvmHFmkyerZ0NPG/ES5ctOh9yuH2+6AFR/O5wj9SBXy25dDA==
X-Received: by 2002:a17:90a:e518:: with SMTP id t24mr247638pjy.116.1603765740224;
        Mon, 26 Oct 2020 19:29:00 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o10sm5066131pgp.16.2020.10.26.19.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 19:28:59 -0700 (PDT)
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
Subject: [PATCHv5 net 0/2] IPv6: reply ICMP error if fragment doesn't contain all headers
Date:   Tue, 27 Oct 2020 10:28:31 +0800
Message-Id: <20201027022833.3697522-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201026072926.3663480-1-liuhangbin@gmail.com>
References: <20201026072926.3663480-1-liuhangbin@gmail.com>
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

