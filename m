Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01508ED34
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 01:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbfD2XP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 19:15:27 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:35178 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728565AbfD2XP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 19:15:27 -0400
Received: by mail-it1-f193.google.com with SMTP id l140so564034itb.0
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 16:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=jBpV63M4+a3027Yx0ul3BIS+9iC9VKtyJRYfdTAwgM4=;
        b=BsTZvI84C3Cjyc2p41ntxdZbIBmfZgwA0P68xGY6UiPZ6Il+OS/egdfCFhnPzCea/p
         aNsLAy/dc5AL98etDmbsw5sIrG4BTg0/MBSIGowlnS4LO7NzJaUpD9vjexxrzpMHB9hz
         OksZ3TCZMygAPQQv8wwSl8Io8Js2vWrzlvIfDkq9U9LPZwmUQB9YMDEQjdLhiVDHpRtZ
         WSVDmJ8EHFVzYjnHXF4b+XLqVd3E5J9ALhMlYb7cxjn2i2HxP4tC7GolXOONBwgtRuLL
         tIzyaRkhJhmig+1ykoMDtsTaqTP2965SAwGox1Rx5byCvpQQ4XRnhBLZ8NV60/S07VKV
         cHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jBpV63M4+a3027Yx0ul3BIS+9iC9VKtyJRYfdTAwgM4=;
        b=iSEfAjEK4zsUF0wiSc8ftjVvc3pauvOF0NRU+g3R0+L4lF46Xp7vdOQtHKG4SbqK74
         BDbgaxvSNiSyD5F9uxnNlJyly6gyJVLuZUw4poMEoUSx3QIBXedUF/ldn2LpxjSoFTcS
         pglmYvm9U4/FELDfxBP1hNTx78N/Otj4Hlstexc+J9YxN6QahZB0R7jnVjrnju93VufN
         flQhpPtsOAwnOFNyHwNFRRMmt7vIH3oHtoTxFBzSG7gpSB4dg+9Fvv5yOyb2s3hXosg0
         smk3pK913BehxLj60R8GHxHwKv9uJeNAuBNnW6Kr1TSjfS0RWmbJK46RcUjhYt1/x8th
         c9yw==
X-Gm-Message-State: APjAAAXXR/j6F5LGn8MSqdYNin+RlIksB7du2Wq7LDFRTs4GzNv82eAx
        Ix69mjIxxuSUi0ctOHT5xOcjcg==
X-Google-Smtp-Source: APXvYqy8Ls49nUxNhJY0Q6ukqWObt2qPHDF4EXgW1FeYanw6Z8BSYXCq/WWqLeR9huKHu1lSxd9qQQ==
X-Received: by 2002:a24:7a8b:: with SMTP id a133mr1335697itc.118.1556579725791;
        Mon, 29 Apr 2019 16:15:25 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id n184sm490654itc.28.2019.04.29.16.15.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 16:15:25 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH v9 net-next 0/6] exthdrs: Make ext. headers & options useful - Part I
Date:   Mon, 29 Apr 2019 16:15:11 -0700
Message-Id: <1556579717-1554-1-git-send-email-tom@quantonium.net>
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

v8:

- Don't explicitly set fields to zero when initializing TLV paramter
  structures.

v9:

- Don't send extra patches in v8.

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
 net/ipv6/datagram.c        |   51 ++-
 net/ipv6/exthdrs.c         |  394 ++--------------
 net/ipv6/exthdrs_common.c  | 1093 ++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/exthdrs_options.c |  345 ++++++++++++++
 net/ipv6/ipv6_sockglue.c   |   39 +-
 9 files changed, 1706 insertions(+), 402 deletions(-)
 create mode 100644 net/ipv6/exthdrs_common.c
 create mode 100644 net/ipv6/exthdrs_options.c

-- 
2.7.4

