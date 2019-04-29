Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0C1EA68
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbfD2Sqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:46:39 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:34362 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728964AbfD2Sqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 14:46:37 -0400
Received: by mail-it1-f196.google.com with SMTP id z17so672051itc.1
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 11:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=zPcXJBZtHPkyLXBBEkW4Wj44Gc+0aPV7+ts0kMk+dYA=;
        b=VO3N8GXkYc+nr+bbgYUiHqUScG1rGUFkwN284jo8r24Wqogk1a+68z0c7tumD/qoLs
         NdLuECmMl5RjjalVb0x16cmZ6LSUvvDruEHgEZYFRHCtSH24rlMIJAm2IlvXgQkoN5T1
         TszY7e367g2bzp+sxJb811Sr3gi+11aOkyEoy5EeJeqMEdYowO8OCtJAc8jdkbZPabUN
         DIsPRaGdwuMJuKyKlCHM94PprOrN4Wn+ERb5dvJiH3WpiVLgj0oEsTtpF0CSteP8/qJx
         ba5LM/5baSssMNPZbt/0E9CUwmZOj9u1RdSguTdrv/wN2cAIK0NpBlUaNGy+A11AmNIV
         gSww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zPcXJBZtHPkyLXBBEkW4Wj44Gc+0aPV7+ts0kMk+dYA=;
        b=GxeMlNUcXJaMaKdN/44iXj++5pVdx4KNDnKnJjp7t4ii6ZondOouuqyu22qaxxQdLZ
         adDPxU0dMmtPXk2aig0RNkEiO2np7QTiEv98J0ZEjdccBmjrlh/zy89aKWvm0d+Wd7XB
         PnUXFHdQhXXBQmqy7IoJk7jNpzUdzjPTb/ltuBahZTpR2PrOY88v1Qfd2aY/GFzLkjlR
         OZLkBX6B2UjH2zTFE3Eu2H2KhaNDjilIKFtOMmDy5bvVm0jICOI7JEXv+1MmO5a534sL
         634nxGTox0QvT/LHral06O7qoV/kE+GsGdu16QCwFWOcaRVhbIfj4+CKSm/0T77ME1d+
         msGQ==
X-Gm-Message-State: APjAAAUwgnXEbtO4G2vyuDmEgn7vY82Y2U06uJNOb/WmJzl01PbrsoJK
        Im7WAgXqxdCIUO8Yp4A/9n4W3ul9f78=
X-Google-Smtp-Source: APXvYqyAr8A0D6BD15M5BwQqxMbvIG+dbdimOmaY6u7mjJfPXdlnxfWB+ItzelVokU+c8keMq/QWRQ==
X-Received: by 2002:a24:df84:: with SMTP id r126mr428839itg.113.1556563595720;
        Mon, 29 Apr 2019 11:46:35 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id f129sm181645itf.4.2019.04.29.11.46.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 11:46:34 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH v7 net-next 0/6] exthdrs: Make ext. headers & options useful - Part I
Date:   Mon, 29 Apr 2019 11:46:10 -0700
Message-Id: <1556563576-31157-1-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extension headers are the mechanism of extensibility for the IPv6
protocol, however to date they have only seen limited deployment.
The reasons for that are because intermediate devices don't handle
them well, and there haven't really be any useful extension headers
defined. In particular, Destination and Hop-by-Hop options have
not been deployed to any extent.

The landscape may be changing as there are now a number of serious
efforts to define and deploy extension headers. In particular, a number
of uses for Hop-by-Hop Options are currently being proposed, Some of
these are from router vendors so there is hope that they might start
start to fix their brokenness. These proposals include IOAM, Path MTU,
Firewall and Service Tickets, SRv6, CRH, etc.

Assuming that IPv6 extension headers gain traction, that leaves a
noticeable gap in IPv4 support. IPv4 options have long been considered a
non-starter for deployment. An alternative being proposed is to enable
use of IPv6 options with IPv4 (draft-herbert-ipv4-eh-00).

This series of patch sets endeavours to make extension headers and
related options useful and easy to use. The following items will be
addressed:

  - Reorganize extension header files
  - Allow registration of TLV handlers
  - Elaborate on the TLV tables to include more characteristics
  - Add a netlink interface to set TLV parameters (such as
    alignment requirements, authorization to send, etc.)
  - Enhance validation of TLVs being sent. Validation is strict
    (unless overridden by admin) following that sending clause
    of the robustness principle
  - Allow non-privileged users to set Hop-by-Hop and Destination
    Options if authorized by the admin
  - Add an API that allows individual Hop-by-Hop and Destination
    Options to be set or removed for a connected socket. The
    backend end enforces permissions on what TLVs may be set and
    merges set TLVs per following the rules in the TLV parameter table
    (for instance, TLV parameters include a preferred sending order
    that merging adheres to)
  - Add an infrastructure to allow Hop-by-Hop and Destination Options
    to be processed in the context of a connected socket
  - Support for some of the aforementioned options
  - Enable IPv4 extension headers

------

In this series:

- Create exhdrs_options.c. Move options specific processing to this
  file from exthdrs.c (for RA, Jumbo, Calipso, and HAO).
- Create exthdrs_common.c. This holds generic exthdr and TLV related
  functions that are not IPv6 specific. These functions will also be
  used with IPv4 extension headers.
- Allow modules to register TLV handlers for Destination and HBH
  options.
- Add parameters block to TLV type entries that describe characteristics
  related to the TLV. For the most part, these encode rules about
  sending each TLV (TLV alignment requirements for instance).
- Add a netlink interface to manage parameters in the TLV table.
- Add validation of HBH and Destination Options that are set on a
  socket or in ancillary data in sendmsg. The validation applies the
  rules that are encoded in the TLV parameters.
- TLV parameters includes permissions that may allow non-privileged
  users to set specific TLVs on a socket HBH options or Destination
  options. Strong validation can be enabled for this to constrain
  what the non-privileged user is able to do.

v2:

- Don't rename extension header files with IPv6 specific code before
  code for IPv4 extension headers is present
- Added patches for creating TLV parameters and validation

v3:

- Fix kbuild errors. Ensure build and operation when IPv6 is disabled.

v4:

- Remove patch that consolidated option cases in option cases in
  ip6_datagram_send_ctl per feedback

v5:

- Add signoffs.

v6:

- Fix init_module issue from kuild.
  Reported-by: kbuild test robot <lkp@intel.com>

v7:

- Create exthdrs_common.c. Use this file for for generic functions that
  apply to IPv6 and IPv4 extension headers. Don't touch exthdr_core.c
  to preserve the semantics that that file contains functions that are
  needed when IPv6 (or IPv4 extension headers) is not enabled.
- A few other minor fixes and cleanup.
- Answered David Ahern's question about why use generic netlink instead
  of rtnetlink.

Tested:

Set Hop-by-Hop options on TCP/UDP socket and verified to be functional.

Tom Herbert (6):
  exthdrs: Create exthdrs_options.c
  exthdrs: Move generic EH functions to exthdrs_common.c
  exthdrs: Registration of TLV handlers and parameters
  exthdrs: Add TX parameters
  ip6tlvs: Add netlink interface
  ip6tlvs: Validation of TX Destination and Hop-by-Hop options

 include/net/ipv6.h         |  130 ++++++
 include/uapi/linux/in6.h   |   49 ++
 net/ipv6/Kconfig           |    4 +
 net/ipv6/Makefile          |    3 +-
 net/ipv6/datagram.c        |   51 +-
 net/ipv6/exthdrs.c         |  394 ++--------------
 net/ipv6/exthdrs_common.c  | 1097 ++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/exthdrs_options.c |  345 ++++++++++++++
 net/ipv6/ipv6_sockglue.c   |   39 +-
 9 files changed, 1710 insertions(+), 402 deletions(-)
 create mode 100644 net/ipv6/exthdrs_common.c
 create mode 100644 net/ipv6/exthdrs_options.c

-- 
2.7.4

