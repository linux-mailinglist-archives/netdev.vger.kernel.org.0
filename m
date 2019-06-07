Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68068394D2
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732134AbfFGSz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:55:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37979 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729241AbfFGSz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:55:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id v11so1616191pgl.5
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 11:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=2E9VYR6XkfxuAdQ0Z1HRXTHw3UVmtfSWQbklPpZvhfw=;
        b=sQljH9oRlLZJIj4mtznnKJX0pCeppeEI6DZJX43ixkxHhT5Z8IaZKMM7DGybHF/Ghw
         WHRs6paysCHTv5W0fdFmJwoDlsgdjsliQf89gdu15641bqEFPPsBqgsJDmqYomqsYN8Q
         JkyK1sUkJ2WDn0Ybj/3O9RFNwsK5Q2fouuIPRzEN1tovUXNZFWjxT4VKfHwpHiw1P4/1
         Ku9orRRcG1cRvQBU9B8zYeo7GUy5fXZC+HObiweGrbwzz81B0ttiqt3ypRUuG62kew08
         TAKKO1Wxh0RkWaigTj5IeLdaQjMFALEq7B/YpiwhPP1SNM8lTAh8vxJ7GfopoOkMd+oG
         G8+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2E9VYR6XkfxuAdQ0Z1HRXTHw3UVmtfSWQbklPpZvhfw=;
        b=pTUOnMRmMbPTw60IDXUftDeheRp9rZvJs9XC9AzeJ13jXi2y4+nrIi2nb8uWBFgMOw
         xX6Lj5QNaUT9fJJWDrYppj/2HGxnACgJXxuvP1RuH0K8cL3WADGQwthVRcoFR2oZ2wgw
         blc5h09FKmOE/EipMdANClTJ6Q9aHGGGPtKzvYE/O7ls87IMvxKkmcYUlRN4hzqP5xO+
         ThVzpTe06DkCUno+xDiXa0bPVnYCsPO4tHoeGQa6TlpQ+2F2ciOYJl8M9DxnjJnq/69/
         YHV5Lpy5vzLXHfmP6qzjp1jyZud3M1dSIglYe6DLr+DSvnO5+0O7n7Jc4jqUwpSdYYHq
         +H0A==
X-Gm-Message-State: APjAAAWs5HIzWi/iZXATx2wD7N+i05nDax3KkpDIuj/JWtB/lx5lIB6y
        6ptrPRyQocuXOarQ1Fli6j33IMReL8o=
X-Google-Smtp-Source: APXvYqxEAxOI+TtZOy2x+H85u1vfrvq/cDsElNcEWgsvkyRicQTl4q0tz1eJWSkgEyPTMErCKy8P0A==
X-Received: by 2002:a17:90a:be0a:: with SMTP id a10mr7070678pjs.112.1559933726881;
        Fri, 07 Jun 2019 11:55:26 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id i25sm3181933pfr.73.2019.06.07.11.55.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 07 Jun 2019 11:55:25 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [RFC v2 PATCH 0/5] seg6: Segment routing fixes
Date:   Fri,  7 Jun 2019 11:55:03 -0700
Message-Id: <1559933708-13947-1-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set includes fixes to bring the segment routing
implementation into conformance with the latest version of the
draft (draft-ietf-6man-segment-routing-header-19). Also, segment
routing receive function calls ip6_parse to properly parse TLVs
in parsing loop.

Changes include:

  - Update TLV macro definitions. Mark obsoleted TLVs as such, add
    definitions for PAD1 and PADN
  - Mark obsoleted flags as such
  - Implement parsing loop in sr_has_hmac to find HMAC TLV without
    relying on obsoleted flag
  - Parameterize ip6_parse_tlv so that it can be used for parsing
    segment routing TLVs
  - Add sysctls for segment routing TLV parsing limits
  - Segment routing receive functions call ip6_parse_tlv

Tom Herbert (5):
  seg6: Fix TLV definitions
  seg6: Obsolete unused SRH flags
  ipv6: Paramterize TLV parsing
  seg6: Add sysctl limits for segment routing header
  seg6: Leverage ip6_parse_tlv

 include/net/ipv6.h         | 31 ++++++++++-------
 include/net/netns/ipv6.h   |  2 ++
 include/net/seg6.h         |  5 +++
 include/net/seg6_hmac.h    |  2 +-
 include/uapi/linux/seg6.h  | 54 +++++++++++++++++++++++------
 net/ipv6/af_inet6.c        |  2 ++
 net/ipv6/exthdrs.c         | 84 +++++++++++++++++++++++++++++++++++++++-------
 net/ipv6/seg6_hmac.c       | 16 ++-------
 net/ipv6/seg6_local.c      | 21 ++++++++----
 net/ipv6/sysctl_net_ipv6.c | 16 +++++++++
 10 files changed, 176 insertions(+), 57 deletions(-)

-- 
2.7.4

