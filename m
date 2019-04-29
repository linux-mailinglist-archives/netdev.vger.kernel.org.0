Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECF3ED23
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 01:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbfD2XEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 19:04:44 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39942 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729603AbfD2XEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 19:04:44 -0400
Received: by mail-io1-f68.google.com with SMTP id m9so4149117iok.7
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 16:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=B+Ngb4rXH6PXovTDj5p+X4ZxRy6EdDYWKDD639BxDng=;
        b=zfKvvV3w5WlaRfp/B8CbxYC+U9bXZP0vHSPujkXNK+Exg45pIp+vGqQKH8HADdyGEH
         eMccP6uPdD/WIFwvcwNVTiziafjAgKi6SkP8DlTaF9j7SuaL1KkT0o1kv/Pvbu9bsURH
         cW75QhJUR5Tn7iKIbx2Af/9lilq1KMHM1dYUvvZ7NcOV75g2d71HiGR4zFFk/VLoC/mz
         VtdddVFCHje9Xdz8aQJSNSGBrdlzfp6xqCUBF4f7oOVaYi9o+TQYZUTnkWFQACsCKrlV
         THiYB5tRNsMZujn8SqMzhRliLXajpLUtwfYhr2ezeED2y4tp8e8Wjjcz9L9Taj4j2rRu
         qlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=B+Ngb4rXH6PXovTDj5p+X4ZxRy6EdDYWKDD639BxDng=;
        b=t8dwDG2Z2CObyioQagXTlC1ZeySi1MdyTAfWRqIFBQUCY2SHwd2aVS2Pw5w0KReOPI
         nJdbV1HChD9FWrmUx0prqgqc0j51J8cxvs8wNrpayD8XW5CvP7RBaLPpBRftdRkjVAcK
         X80NHY1dWoAmkxHgIxi9nkpzfmoHzgKTwHJ6e1HQPIX1QEYxl4eUaHBUPNQVBXcY7G1V
         D7d2mjBB/ZZH/bs/QqL2t1a+E0XQhrdq8Xqlwbsq1/COa9cO8vyMGxQDw2+AEPOWabLG
         s8nCeVc6Kc8vDdD0u9VhBcYKZQxU09Q+HxqGGgP/L9vCUo6oOB26Z/u5xrI2GmPZtgZY
         svWg==
X-Gm-Message-State: APjAAAUWU4I5OJRWmhLO7WtMMm56yh5Bcp5KxryUWOhgYG4H7HqJsWKE
        39ynUZINJW3YHoeL8cZJ5Elqo6oUw9I=
X-Google-Smtp-Source: APXvYqzRtK+jUv8djgttbZFDhYTp6qXRcmlEvXLkP171PKY8YVj7uKqfe1D91t8jF5FGbdx1Bfu4Vw==
X-Received: by 2002:a5d:8e19:: with SMTP id e25mr25459635iod.139.1556579082844;
        Mon, 29 Apr 2019 16:04:42 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id y62sm340626itg.13.2019.04.29.16.04.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 16:04:42 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH v8 net-next 0/8] exthdrs: Make ext. headers & options useful - Part I
Date:   Mon, 29 Apr 2019 16:04:15 -0700
Message-Id: <1556579063-1367-1-git-send-email-tom@quantonium.net>
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

Tested:

Set Hop-by-Hop options on TCP/UDP socket and verified to be functional.

Tom Herbert (8):
  exthdrs: Move generic EH functions to exthdrs_common.c
  exthdrs: Registration of TLV handlers and parameters
  exthdrs: Add TX parameters
  ip6tlvs: Add netlink interface
  ip6tlvs: Validation of TX Destination and Hop-by-Hop options
  ipv6tlvs: opt_update function
  ipv6tlvs: Infrastructure for manipulating individual TLVs
  ipv6tlvs: API for manipuateling TLVs on a connect socket

 include/net/ipv6.h         |  147 +++-
 include/uapi/linux/in6.h   |   58 ++
 net/ipv6/Kconfig           |    4 +
 net/ipv6/Makefile          |    1 +
 net/ipv6/datagram.c        |   51 +-
 net/ipv6/exthdrs.c         |  190 +----
 net/ipv6/exthdrs_common.c  | 1682 ++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/exthdrs_options.c |  188 ++++-
 net/ipv6/ipv6_sockglue.c   |   82 ++-
 9 files changed, 2179 insertions(+), 224 deletions(-)
 create mode 100644 net/ipv6/exthdrs_common.c

-- 
2.7.4

