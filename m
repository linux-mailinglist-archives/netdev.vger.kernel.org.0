Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8CC34DDB9
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 03:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhC3BpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 21:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbhC3BpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 21:45:13 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC27C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 18:45:12 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id s1-20020a4ac1010000b02901cfd9170ce2so1517815oop.12
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 18:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=A0dsIZyjGTBqKZuczOc3bNJTlabVbPGCl0SZPmiIhCo=;
        b=Q2z3YLcroqo91LdEmtQbcYYIKDfIaLWsjGRfFSgH8mViDsPNRc/ii5/PHVZdMM9UyA
         eVBjiTk7XzCvRizWiRL3qN0Kqzf7yVivLS5ad8Tdojx0TICtAace6SflXk2weU62NLGh
         Pf9wA5kiUgZE0rB74egHQVi0xo7tTayaaDNmLFwLeMMkNBGFpRHvuOb5GcJbx8N7ID4+
         Tv7G9trTPP4CS9TdinXrCqPyNQ3LvB99st/5gh91/DnPUy/jSJKVSvTv2eyp+mjaSuEU
         keJl6YhjRhCKfiJq8m/+ivv9vnhy/wk13Tc8knq+AeHrN3r5fEHWiANVTk+0+QZYaFWq
         F7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=A0dsIZyjGTBqKZuczOc3bNJTlabVbPGCl0SZPmiIhCo=;
        b=JvLuyj2CiIFER3BQSt9y8mE2HmYOixBLiCW+wC1K2zs1NqOhcR4gRmGIzFajkdIwZv
         eX/sy2ttvAl18OYrB72TuIWu+svdwBnOpJHXiZ7eyMcMUwc3covgca/OHvhIIuaPfLsQ
         /oxoeGpoEVumGfE2yoq3OqKseJjg/K4T3j2r8K31bR2rI60ozEB1gtgeH2EA5U2wYtNp
         cNTTzd5jIxRzDI0Sf7LyEXDu62DV86okrBrxWWGT9mH2E4J81TD4y5f8NdLDjaEGKr3z
         yak46Q6ySIW/YIcNjiZ1rpLIWORc5IaDoQ0U2m/KArZAw/Qirb0M9ictamp6knhB22mr
         pdmA==
X-Gm-Message-State: AOAM5316pv9jsiSfyxwA7rx25RZKUpDsR/4o/zu2SQ4VdwsffI+DPmB8
        HPIQGHnPFNtxUeRkMn+QBBwltSuOL6I=
X-Google-Smtp-Source: ABdhPJxy8ntQDE7XrpjixjMcQYGSezYvumT4GdE3Hs4q+1yG5pDFIHl7gGwGIeHAQNhSFws8cScDcA==
X-Received: by 2002:a4a:d05:: with SMTP id 5mr23620861oob.10.1617068711521;
        Mon, 29 Mar 2021 18:45:11 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:35b:834f:7126:8db])
        by smtp.googlemail.com with ESMTPSA id m126sm3865953oig.31.2021.03.29.18.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 18:45:11 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V6 0/6] add support for RFC 8335 PROBE
Date:   Mon, 29 Mar 2021 18:45:04 -0700
Message-Id: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The popular utility ping has several severe limitations, such as the
inability to query specific interfaces on a node and requiring
bidirectional connectivity between the probing and probed interfaces.
RFC 8335 attempts to solve these limitations by creating the new utility
PROBE which is a specialized ICMP message that makes use of the ICMP
Extension Structure outlined in RFC 4884.

This patchset adds definitions for the ICMP Extended Echo Request and
Reply (PROBE) types for both IPV4 and IPV6, adds a sysctl to enable
responses to PROBE messages, expands the list of supported ICMP messages
to accommodate PROBE types, adds ipv6_dev_find into ipv6_stubs, and adds
functionality to respond to PROBE requests.

Changes:
v1 -> v2:
 - Add AFI definitions
 - Switch to functions such as dev_get_by_name and ip_dev_find to lookup
   net devices

v2 -> v3:
Suggested by Willem de Bruijn <willemdebruijn.kernel@gmail.com>
 - Add verification of incoming messages before looking up netdev
 - Add prefix for PROBE specific defined variables
 - Use proc_dointvec_minmax with zero and one for sysctl
 - Create struct icmp_ext_echo_iio for parsing incoming packets
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
 - Include net/addrconf.h library for ipv6_dev_find

v3 -> v4:
 - Use in_addr instead of __be32 for storing IPV4 addresses
 - Use IFNAMSIZ to statically allocate space for name in
   icmp_ext_echo_iio
Suggested by Willem de Bruijn <willemdebruijn.kernel@gmail.com>
 - Use skb_header_pointer to verify fields in incoming message
 - Add check to ensure that extobj_hdr.length is valid
 - Check to ensure object payload is padded with ASCII NULL characters
   when probing by name, as specified by RFC 8335
 - Statically allocate buff using IFNAMSIZ
 - Add rcu blocking around ipv6_dev_find
 - Use __in_dev_get_rcu to access IPV4 addresses of identified
   net_device
 - Remove check for ICMPV6 PROBE types

v4 -> v5:
 - Statically allocate buff to size IFNAMSIZ on declaration
 - Remove goto probe in favor of single branch
 - Remove strict check for incoming PROBE request padding to nearest
   32-bit boundary
Reported-by: kernel test robot <lkp@intel.com>

v5 -> v6: 
 - Add documentation for icmp_echo_enable_probe sysctl
 - Remove RCU locking around ipv6_dev_find()
 - Assign iio based on ctype

Andreas Roeseler (6):
  icmp: add support for RFC 8335 PROBE
  ICMPV6: add support for RFC 8335 PROBE
  net: add sysctl for enabling RFC 8335 PROBE messages
  net: add support for sending RFC 8335 PROBE messages
  ipv6: add ipv6_dev_find to stubs
  icmp: add response to RFC 8335 PROBE messages

 Documentation/networking/ip-sysctl.rst |   6 ++
 include/net/ipv6_stubs.h               |   2 +
 include/net/netns/ipv4.h               |   1 +
 include/uapi/linux/icmp.h              |  42 ++++++++
 include/uapi/linux/icmpv6.h            |   3 +
 net/ipv4/icmp.c                        | 134 ++++++++++++++++++++++---
 net/ipv4/ping.c                        |   4 +-
 net/ipv4/sysctl_net_ipv4.c             |   9 ++
 net/ipv6/addrconf_core.c               |   7 ++
 net/ipv6/af_inet6.c                    |   1 +
 10 files changed, 195 insertions(+), 14 deletions(-)

-- 
2.17.1

