Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEBB348037
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 19:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237384AbhCXSRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 14:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237203AbhCXSRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 14:17:35 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E437C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:17:35 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id x207so1000481oif.1
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KbvflVMZzwcLj8vmecOmXlC8mSUdTGg1t8qpbKkz7R8=;
        b=TleVmUCj5LeYiSCcBtqVF6YvKOAR2JgWoMBRKwIQ5g408ZWgPm0/SDCkw3g2hJdiyB
         1eqexu/cd86py6QKPrSB0j46/IVYd/YlcduoBukYh53Z5toEkVL44hKNbtO1ymXlc63a
         GFcpv4OtVYh1hnERtXaFQksIocLYxxzyr9v67MjnWNAzqPt/sZ8vyu40sJ/pr/eJIkix
         Ah/WqTjYCtrbFWH/5jT3CawyxmfbcFUAUa2B72C6LawrVRtonENRAT4+JVBGhHGvWYQH
         0dYxkxWI4wlNzTR8bevdzCyHFTbIV5WhtMf2pOjk5l5RHRm1KAjEt6Jj35j5dkV12LY1
         2lvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KbvflVMZzwcLj8vmecOmXlC8mSUdTGg1t8qpbKkz7R8=;
        b=px4e516KGL/sy3MZdgwFSMGl9eqlApnbRMkarq80yerG/2Y26SrS6eEx4tdd48gdd3
         UCV9wA5jyMAhQRHgAPa+CO0V+GBRBGK2mKwPiAbO+hO8osEkF0Oax0oEpSI3LNMiLPqX
         gisXSHVlf3oW8uUyIXnZ5o5MAWUjd1MrmzIqdLHSVQ75/fWnx09zlofdYo/iinSfRYR7
         OdbvB4OK6aebzv7V+RtpeeVraU5UtunG3HuGbDTQ0iGeL6XoMA0SF7J2cXPNCOThV/zm
         YCa45+FvNxS2uBF3xlrtFUwJ9jN3I8uV4G04VmX1X7OrQ5LmvoS4Qn1n0DV1b7Y4T5/L
         IxZA==
X-Gm-Message-State: AOAM531va91d1Wr0vK/I6NUQOjIvdbNUuFw47fmVcjkWjqGk215eivJo
        qZmSY9kh2sSjBgRffMtXKgM1QuPs06c=
X-Google-Smtp-Source: ABdhPJzc5gezI9CfoDvmAiLRU/FKrLFtxU4NF7VDRGkyDIsZx4iweNrtpnBhBl5tkJBG61vYw4qiow==
X-Received: by 2002:a05:6808:10c5:: with SMTP id s5mr3241605ois.58.1616609854631;
        Wed, 24 Mar 2021 11:17:34 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:abb9:79f4:f528:e200])
        by smtp.googlemail.com with ESMTPSA id l71sm555845oib.30.2021.03.24.11.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 11:17:34 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V5 0/6] add support for RFC 8335 PROBE
Date:   Wed, 24 Mar 2021 11:17:31 -0700
Message-Id: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
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
to accommodate PROBE types, and adds functionality to respond to PROBE
requests.

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
 - Use rcu_dereference when accessing i6_ptr in net_device
 - Add ipv6_find_dev into ipv6_stub for use in icmp.c

Andreas Roeseler (6):
  icmp: add support for RFC 8335 PROBE
  ICMPV6: add support for RFC 8335 PROBE
  net: add sysctl for enabling RFC 8335 PROBE messages
  net: add support for sending RFC 8335 PROBE messages
  ipv6: add ipv6_dev_find to stubs
  icmp: add response to RFC 8335 PROBE messages

 include/net/ipv6_stubs.h    |   2 +
 include/net/netns/ipv4.h    |   1 +
 include/uapi/linux/icmp.h   |  42 ++++++++++++
 include/uapi/linux/icmpv6.h |   3 +
 net/ipv4/icmp.c             | 127 ++++++++++++++++++++++++++++++++----
 net/ipv4/ping.c             |   4 +-
 net/ipv4/sysctl_net_ipv4.c  |   9 +++
 net/ipv6/addrconf_core.c    |   7 ++
 net/ipv6/af_inet6.c         |   1 +
 9 files changed, 182 insertions(+), 14 deletions(-)

-- 
2.17.1

