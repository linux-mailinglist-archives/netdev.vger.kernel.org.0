Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8D269F735
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 15:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjBVO7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 09:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjBVO7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 09:59:52 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0273279BF;
        Wed, 22 Feb 2023 06:59:50 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id j2so7856221wrh.9;
        Wed, 22 Feb 2023 06:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F2uUDqCey0ejVZ2OTJ3TUOX7iol+94MW1jyw6ifdRDs=;
        b=FfifdVsUKna7DkVVqyOJ/L6GuEc5u8sbzd7oKmxHw+rLsrLJIcgkQu4eJ2Pe4DagBr
         MEP+/jXFUkzm0r/cf81Wiq4LajzXn/CzPtLc7wAsJdT61ovwv3keSAEve4pDQ+f8yyjr
         3PUnC6ELE7fa44K1WfsY5jZFePR8oro++3FDNiAixxtkgXSEJDUcOuWvKyKSGleoyeF0
         zy0jbgDsj2Mq9QWNhgwLiMsHE8A0NtQ2wkt4lawIf+0S+SRR7M8Y6r8d8/8SHMHIcXMI
         tPqj840WGod8dRNK78J23zx+BpSVB8YQbUITqSdegfMkze2NEGVU4zKJHZ6PlKWGdAzC
         XYnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F2uUDqCey0ejVZ2OTJ3TUOX7iol+94MW1jyw6ifdRDs=;
        b=iLOCKlXHw3TadPYXjlIgy3DugSPVCIOK4fA0/Gjaj+jBXyKQHyAAHxknB00S73WQqC
         BIcROsWV+6hHggUuHnHyih8jx8aT/ReBfWMq/VMFQMo5gjQFJTeiAF+iW+VDJoOCRMVl
         ikYnDkEWtrbWhGtohtUYfF1dFaldfoNzh9KgUwK/6OrmixH5SvKWu8JnQFhPsdCgExVW
         7J7D/3+XsEdhPcMNFUziQAx9pp6h9AkEX/S55NWiYdPjrPIK06Id4FvDdXLZykEDHxZb
         FcAaAF+J6GDQYzd5AHXMpT8jBroKkfit35zZhWAohwt5qgQ+dZ6kD2F/qSddymhjv6qJ
         a39Q==
X-Gm-Message-State: AO0yUKWv9o0kROJHePb83d+U3allLKcVkCpD+cKHMz89XvhKSOIT7p2S
        2ZXWunt6NsCLbL535rJHCBo=
X-Google-Smtp-Source: AK7set8X9S6SJvYAW0NF4Qt+SNHjb72WPlHcJGnuYHzukm0d7r6/w6+E/QrZBJgWpa8fjQOEnaI4jg==
X-Received: by 2002:a5d:4308:0:b0:2c5:54a7:363f with SMTP id h8-20020a5d4308000000b002c554a7363fmr8384629wrq.63.1677077989260;
        Wed, 22 Feb 2023 06:59:49 -0800 (PST)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id y16-20020a056000109000b002c596e4b3dasm7849154wrw.55.2023.02.22.06.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 06:59:48 -0800 (PST)
Date:   Wed, 22 Feb 2023 15:59:25 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, richardbgobert@gmail.com,
        alexanderduyck@fb.com, lixiaoyan@google.com,
        steffen.klassert@secunet.com, lucien.xin@gmail.com,
        ye.xingchen@zte.com.cn, iwienand@redhat.com, leon@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] gro: optimise redundant parsing of packets
Message-ID: <20230222145917.GA12590@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the IPv6 extension headers are parsed twice: first in
ipv6_gro_receive, and then again in ipv6_gro_complete.

By using the new ->transport_proto field, and also storing the size of the
network header, we can avoid parsing extension headers a second time in
ipv6_gro_complete.

The first commit frees up space in the GRO CB. The second commit reduces the
redundant parsing during the complete phase, using the freed CB space.

In addition, the second commit contains a fix for a potential problem in BIG
TCP, which is detailed in the commit message itself.

Performance tests for TCP stream over IPv6 with extension headers demonstrate rx
improvement of ~0.7%.

For the benchmarks, I used 100Gbit NIC mlx5 single-core (power management off),
turboboost off.

Typical IPv6 traffic (zero extension headers):

    for i in {1..5}; do netperf -t TCP_STREAM -H 2001:db8:2:2::2 -l 90 | tail -1; done
    # before
    131072  16384  16384    90.00    16391.20
    131072  16384  16384    90.00    16403.50
    131072  16384  16384    90.00    16403.30
    131072  16384  16384    90.00    16397.84
    131072  16384  16384    90.00    16398.00

    # after
    131072  16384  16384    90.00    16399.85
    131072  16384  16384    90.00    16392.37
    131072  16384  16384    90.00    16403.06
    131072  16384  16384    90.00    16406.97
    131072  16384  16384    90.00    16406.09

IPv6 over IPv6 traffic:

    for i in {1..5}; do netperf -t TCP_STREAM -H 4001:db8:2:2::2 -l 90 | tail -1; done
    # before
    131072  16384  16384    90.00    14791.61
    131072  16384  16384    90.00    14791.66
    131072  16384  16384    90.00    14783.47
    131072  16384  16384    90.00    14810.17
    131072  16384  16384    90.00    14806.15

    # after
    131072  16384  16384    90.00    14793.49
    131072  16384  16384    90.00    14816.10
    131072  16384  16384    90.00    14818.41
    131072  16384  16384    90.00    14780.35
    131072  16384  16384    90.00    14800.48

IPv6 traffic with varying extension headers:

    for i in {1..5}; do netperf -t TCP_STREAM -H 2001:db8:2:2::2 -l 90 | tail -1; done
    # before
    131072  16384  16384    90.00    14812.37
    131072  16384  16384    90.00    14813.04
    131072  16384  16384    90.00    14802.54
    131072  16384  16384    90.00    14804.06
    131072  16384  16384    90.00    14819.08

    # after
    131072  16384  16384    90.00    14927.11
    131072  16384  16384    90.00    14910.45
    131072  16384  16384    90.00    14917.36
    131072  16384  16384    90.00    14916.53
    131072  16384  16384    90.00    14928.88


Richard Gobert (2):
  gro: decrease size of CB
  gro: optimise redundant parsing of packets

 include/net/gro.h      | 33 ++++++++++++++++++++++++---------
 net/core/gro.c         | 18 +++++++++++-------
 net/ethernet/eth.c     | 14 +++++++++++---
 net/ipv6/ip6_offload.c | 20 +++++++++++++++-----
 4 files changed, 61 insertions(+), 24 deletions(-)

-- 
2.36.1

