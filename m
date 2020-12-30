Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A9A2E7732
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 09:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgL3Iri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 03:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgL3Iri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 03:47:38 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5993DC061799;
        Wed, 30 Dec 2020 00:46:58 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id f9so9361922pfc.11;
        Wed, 30 Dec 2020 00:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=4hCJ1uMJpAFhFUoq0+DB5gxgdyiGzPgLXZHVoajEEEA=;
        b=PHm5ofpjbWbsoLGYwa9L10tOUovyRO/uI6H5ddbo36wgCesQ7mcCy2z3oBMiUEaf3/
         5Mc0kNcQk8jyewpciwrxPxJ5bgppu2LydQFqLUieJPndZtHr/bgH4raxv0RX+7sdlxcp
         38BDnO6xoVzWIMbVYYfKNNUw0KSMSMraT0jur/NJB+YPnqXsvcXZMQB7wc3p+DXjkf0B
         sg44yNm4lr6KHxZ/Cy+1db3DgaR3CNCnOETlOnJgPgwD3XAlN86C/9iO17DVM8XwRq4o
         nZFvz/KntWpSba/IddB2VFM9A3Fjklaem/GsXSV03N+GgkLCWEBVyTYTcu5YFK+hWfqJ
         dpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=4hCJ1uMJpAFhFUoq0+DB5gxgdyiGzPgLXZHVoajEEEA=;
        b=NvML41CRfy7AohAAnzgeu9f/p6sUmLp/r86HU7/YnhiXJ85XdVVkHQJBUPPihuQ1Uh
         nJ7NhdLCpmDi4q6H+v6X4Aa7K7phg0sVpklBDMItugDn06rds8cCY8D2IdJL+KLtceVJ
         UpEBx+27dBVGlsFo+pGwZ8CwdKw874NfbkqC/l91BLniPZ4xQXlbaoW/x43i97RD2yvm
         OsCvjtVGLfBvlKSz+VgQJkSgpcseO4D3GMLkJPr6Osi+ZcYkrPxtD61kE686pUP4gyee
         to34sqR8i28OpXywNGZuRJ4tGx/809wj0U0Ox2piDEf/SaUod+dSoeCdiYH+BQ5QUTbL
         +1MA==
X-Gm-Message-State: AOAM531bc4WTg1l8ewXIJDKWrDAHAZsg73N6cNUyHz/G5nFYkIXfaOdC
        3oChq0mDgFQo5Qj3aVUbJgfjXIgbJw==
X-Google-Smtp-Source: ABdhPJwcsakYdfFcFOfWAxfpjWtQAy1hsG9kYylK6U1z+W9dz0HstcNWGR26ZyKh7ZHxUq2BPHRlyw==
X-Received: by 2002:a63:8f4c:: with SMTP id r12mr51411688pgn.311.1609318017913;
        Wed, 30 Dec 2020 00:46:57 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id 22sm41936113pfn.190.2020.12.30.00.46.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Dec 2020 00:46:57 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Allow user to set metric on default route learned via Router Advertisement.
Date:   Wed, 30 Dec 2020 00:46:43 -0800
Message-Id: <1609318004-12709-1-git-send-email-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow user to set metric on default route learned via Router Advertisement.
Not: RFC 4191 does not say anything for metric for IPv6 default route.

Fix:
For IPv4, default route is learned via DHCPv4 and user is allowed to change
metric using config etc/network/interfaces. But for IPv6, default route can
be learned via RA, for which, currently a fixed metric value 1024 is used.

Ideally, user should be able to configure metric on default route for IPv6
similar to IPv4. This fix adds sysctl for the same.

Logs:
----------------------------------------------------------------
For IPv4:
----------------------------------------------------------------

Config in etc/network/interfaces
----------------------------------------------------------------
```
auto eth0
iface eth0 inet dhcp
    metric 4261413864
```

IPv4 Kernel Route Table:
----------------------------------------------------------------
```
$ sudo route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         172.11.44.1     0.0.0.0         UG    -33553432 0        0 eth0
```

FRR Table, if default route is learned via routing protocol too.
----------------------------------------------------------------
```
# show ip route 
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, P - PIM, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
       > - selected route, * - FIB route

S>* 0.0.0.0/0 [20/0] is directly connected, eth0, 00:00:03
K   0.0.0.0/0 [254/1000] via 172.21.47.1, eth0, 6d08h51m
```

----------------------------------------------------------------
i.e. User can prefer Default Router learned via Routing Protocol, 
Similar behavior is not possible for IPv6, without this fix.


----------------------------------------------------------------
After fix [for IPv6]:
----------------------------------------------------------------
```
sudo sysctl -w net.ipv6.conf.eth0.net.ipv6.conf.eth0.accept_ra_defrtr_metric=0x770003e9
```

IP monitor:
----------------------------------------------------------------
```
default via fe80::be16:65ff:feb3:ce8e dev eth0 proto ra metric 1996489705  pref high
```

Kernel IPv6 routing table
----------------------------------------------------------------
```
Destination                    Next Hop                   Flag Met Ref Use If
::/0                           fe80::be16:65ff:feb3:ce8e  UGDAe 1996489705 0    
 0 eth0
```

FRR Routing Table, if default route is learned via routing protocol.
----------------------------------------------------------------
# show ipv6 route 
Codes: K - kernel route, C - connected, S - static, R - RIPng,
       O - OSPFv3, I - IS-IS, B - BGP, N - NHRP, T - Table,
       v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
       > - selected route, * - FIB route

S>* ::/0 [20/0] is directly connected, eth0, 00:00:06
K   ::/0 [119/1001] via fe80::be16:65ff:feb3:ce8e, eth0, 6d07h43m
----------------------------------------------------------------

Praveen Chaudhary (1):
  Allow user to set metric on default route learned via Router
    Advertisement.

 Documentation/networking/ip-sysctl.rst |  8 ++++++++
 include/linux/ipv6.h                   |  1 +
 include/net/ip6_route.h                |  3 ++-
 include/uapi/linux/ipv6.h              |  1 +
 include/uapi/linux/sysctl.h            |  1 +
 net/ipv6/addrconf.c                    | 10 ++++++++++
 net/ipv6/ndisc.c                       | 15 +++++++++++----
 net/ipv6/route.c                       |  8 +++++---
 8 files changed, 39 insertions(+), 8 deletions(-)

-- 
2.7.4

