Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498E933A6DE
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 17:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbhCNQsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 12:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbhCNQsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 12:48:10 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6B0C061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 09:48:10 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id w34so17983010pga.8
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 09:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QzmnN9dSEK2/lfNu+k2p/JA98nhyz9TDI37U7LtAAsI=;
        b=T5z1rWUh5tvaKubmu3WqPEaDZ/YhTOEGlAKEfKkr6YgrcRUYwLApG9y7ZQ3HRUyMkB
         dVNPthUJUZ39h/rZTEGB9jlteju2wkW9edwwoqXJFWvxMv6R2yJ8yadGThnYn3zlTbaY
         ftmg6WhCRcGKRZrU/CxNFd/dfD0Zvexf3D29RU6MxMeXdt1grt3ISWT7tVZthx7jpoJQ
         FiHLHDKiTjaQFnBemnJYDwvsQtx5yjw3p+HS9IT4QoHjfEswUqfsoplIiaZOrpiGaJA2
         HHP545eV6LabR251zUUn8Dt4ec8H8VT/ULxgv75dspxmw0anoQanZvL8Q2hl/ZD7nkLX
         rfEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QzmnN9dSEK2/lfNu+k2p/JA98nhyz9TDI37U7LtAAsI=;
        b=L0KHFHE2olyckjy/9bv4MXCYlKGh8a92EAUJme5wknHYiNq6RUHskrjmjlX3RZL31T
         JbockrOwnN2UdR/Y9ybbW8XsgxqD9+J6w0whkdUIkCFCFPM5ZOxhwRbw1W0Frv9pOzFN
         /jcAXkcdpuAgGSx/Og8bITEso08muOfPebFHJbgvNI6HR7KHgwpq8ESLshWfygaol0NV
         mBV7NXQx61EMozGGe8kRtlVWru9gSAGd4Y5K1H5FR04DVkpJkny9GSZO9VzU3Asma6Fm
         8ueMRwaFrksfTC3/9y1ghJOJBaepAwYGYoJHB+sJJli/12BGnXY36WN2QdqTJ6OIy0uC
         23+Q==
X-Gm-Message-State: AOAM531KjhfRFCx+iwc/iENXLpsagDb/Oj+cSvk9M0xxaH2UbJxEr23D
        9prfZcO39rX9S550/acdkOw=
X-Google-Smtp-Source: ABdhPJwhj3xhyhxitOTR/KHG6TNncm3Eqwka304dqN+PBHu0wkzALe6uvyVpaOir8Tu4jmmHTsRl6Q==
X-Received: by 2002:a65:6a02:: with SMTP id m2mr19410575pgu.443.1615740490164;
        Sun, 14 Mar 2021 09:48:10 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:ed7e:5608:ecd4:c342])
        by smtp.googlemail.com with ESMTPSA id z2sm10857363pfa.121.2021.03.14.09.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 09:48:09 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH V4 net-next 0/5] add support for RFC 8335 PROBE
Date:   Sun, 14 Mar 2021 09:48:07 -0700
Message-Id: <cover.1615738431.git.andreas.a.roeseler@gmail.com>
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

Andreas Roeseler (5):
  icmp: add support for RFC 8335 PROBE
  ICMPV6: add support for RFC 8335 PROBE
  net: add sysctl for enabling RFC 8335 PROBE messages
  net: add support for sending RFC 8335 PROBE messages
  icmp: add response to RFC 8335 PROBE messages

 include/net/netns/ipv4.h    |   1 +
 include/uapi/linux/icmp.h   |  42 +++++++++++
 include/uapi/linux/icmpv6.h |   3 +
 net/ipv4/icmp.c             | 145 ++++++++++++++++++++++++++++++++----
 net/ipv4/ping.c             |   4 +-
 net/ipv4/sysctl_net_ipv4.c  |   9 +++
 6 files changed, 188 insertions(+), 16 deletions(-)

-- 
2.17.1

