Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1954612AF6C
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 23:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfLZWwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 17:52:00 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:39491 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfLZWwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 17:52:00 -0500
Received: by mail-pl1-f180.google.com with SMTP id g6so8029970plp.6
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 14:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=GigugV2MBtH392fqQRLEMGlCcat75+jn16wnIldFsG4=;
        b=eLnREMU0LwhtPRpAyHX7SBR0T6xeyp7APZ2Yv8wbXr8FtVwi64/UQQktaAOOA2t5to
         ubLk++K0c45DoKjdLQvPV3yDbgwHY+i+SQOVi97HlAEsslnu/UDUR1MMqdm+JOA8qDr7
         PByU4YWE0fN4Fbz5USJvzRhAikddEuK5lSJ9NVMfUJQP+2ffwB2k84ks5oNu8UewEBtX
         F0BiCKqLXlpuo0MGt6j/imFOuSS6fV7WF1iaO3eye86K5dsjexZjIaBvmUAg2u7DOh0u
         NzvsA3Ggz0s0DlSCuE560i6f2tqXF9uA7SwKMIG0hRBUOZkHdXfFtOqtfie3fx1KbGsw
         WSog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GigugV2MBtH392fqQRLEMGlCcat75+jn16wnIldFsG4=;
        b=EUB4vvJjxIzyBrq5EHuXSQmGxJcgZbDtVbzhAblGQxY8NxIKKX1evkSflfgQbFfL7e
         lll3acl86uKdfZQuviR4AmyClDmrbI6Ovt5sZEvNr72q3zZyUa07Fhy6vIG2+Iw0oMPa
         1clP00zjZyp3VnVwMf7Nfw+hGk4jDcuBRho9nTTwWEZ8dpkVE2WSbpXO7lM+Qb8OjOw+
         GNfWww2ITrqoWn6YCmLQyNIp2bjE2H9mA++QaWLBkfKCRKg66fiN8aOmbNEBSYJtN1jh
         0fwDD//jRV/nKzH689KT663dGZ8j13YXmohaYWBFHXuRx26j0yp+0B0wL9r/I0A+xqKt
         5WLA==
X-Gm-Message-State: APjAAAW94QvvRR7cDuwU0FAdfZhNB3kyPnfV74A8OBjurZMahVZwnHBA
        o+ibSxObFKkdLVMXHTBmVhDWVN3VVbQ=
X-Google-Smtp-Source: APXvYqzwzupCDVe4tJ/H0098HmiISGQsNi94TiPDvHTNuagvS0tR3T/bZ2UM7swOYERibkr+zKZTMA==
X-Received: by 2002:a17:90a:b30b:: with SMTP id d11mr22104404pjr.22.1577400719512;
        Thu, 26 Dec 2019 14:51:59 -0800 (PST)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id z13sm11884601pjz.15.2019.12.26.14.51.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 26 Dec 2019 14:51:58 -0800 (PST)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        simon.horman@netronome.com, willemdebruijn.kernel@gmail.com
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [PATCH v8 net-next 0/9] ipv6: Extension header infrastructure
Date:   Thu, 26 Dec 2019 14:51:29 -0800
Message-Id: <1577400698-4836-1-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fundamental rationale here is to make various TLVs, in particular
Hop-by-Hop and Destination options, usable, robust, scalable, and
extensible to support emerging functionality.

Specifically, this patch set:

1) Allow modules to register support for Hop-by-Hop and Destination
options. This is useful for development and deployment of new options.
2) Allow non-privileged users to set Hop-by-Hop and Destination
options for their packets or connections. This is especially useful
for options like Path MTU and IOAM options where the information in
the options is both sourced and sinked by the application. The
alternative to this would be to create more side interfaces so that
the option can be enabled via the kernel-- such side interfaces would
be overkill IMO.
3) In conjunction with #2, validation of the options being set by an
application is done. The validation for non-privileged users is
purposely strict, but even in the case of privileged user validation
is useful to disallow allow application from sending gibberish (for
instance, now a TLV could be created with a length exceeding the bound
of the extension header).
4) Consolidate various TLV mechanisms. Segment routing should be able
to use the same TLV parsing function, as should UDP options when they
come into the kernel.
5) Option lookup on receive is O(1) instead of list scan.

Subsequent patch sets will include:

6) Allow setting specific (Hop-by-Hop and Destination) options on a
socket. This would also allow some options to be set by application
and some might be set by kernel.
7) Allow options processing to be done in the context of a socket.
This will be useful for FAST and PMTU options.
8) Allow experimental IPv6 options in the same way that experimental
TCP options are allowed.
9) Support a robust means of extension header insertion. Extension
header insertion is a controversial mechanism that some router vendors
are insisting upon (see ongoing discussion in 6man list). The way they
are currently doing it breaks the stack (particularly ICMP and the way
networks are debugged), with proper support we can at least mitigate the
effects of the problems being created by extension header insertion.
10) Support IPv4 extension headers. This again attempts to address
some horrendous and completely non-robust hacks that are currently
being perpetuated by some router vendors. For instance, some middlebox
implementations are currently insert into TCP or UDP payload their own
data with the assumption that a peer device will restore correct data.
If they ever miss fixing up the payload then we now have systematic
silent data corruption (IMO, this is very dangerous in a large scale
deployment!). We can offer a better approach...

Changes in this patch set:

  - Reorganize extension header files to separate out common
    API components
  - Create common TLV handler that will can be used in other use
    cases (e.g. segment routing TLVs, UDP options)
  - Allow registration of TLV handlers
  - Elaborate on the TLV tables to include more characteristics
  - Add a netlink interface to set TLV parameters (such as
    alignment requirements, authorization to send, etc.)
  - Enhance validation of TLVs being sent. Validation is strict
    (unless overridden by admin) following that sending clause
    of the robustness principle
  - Allow non-privileged users to set Hop-by-Hop and Destination
    Options if authorized by the admin

v2:
  - Fix build errors from missing include file.

v3:
  - Fix kbuild issue for ipv6_opt_hdr declared inside parameter list
    in ipeh.h

v4:
  - Resubmit

v5:
  - Fix reverse christmas tree issue

v6:
  - Address comments from Simon Horman
  - Remove new EXTHDRS Kconfig symbol, just use IPV6 for now
  - Split out introduction of parse_error for TLV parsing loop into its
    own patch
  - Fix drop counters in HBH and destination options processing
  - Add extack error messages in netlink code
  - Added range of permissions in include/uapi/linux/ipeh.h
  - Check that min data length is <= max data length when setting
    TLV attributes

v7:
  - Fix incorrect index in checking for nonzero padding
  - Use dev_net(skb->dev) in all cases of __IP6_INC_STATS for hopopts
    and destopts (addresses comment from Willem de Bruijin)

v8:
  - Elaborate on justification for patches in the summary commit log

Tom Herbert (9):
  ipeh: Fix destopts counters on drop
  ipeh: Create exthdrs_options.c and ipeh.h
  ipeh: Move generic EH functions to exthdrs_common.c
  ipeh: Generic TLV parser
  ipeh: Add callback to ipeh_parse_tlv to handle errors
  ip6tlvs: Registration of TLV handlers and parameters
  ip6tlvs: Add TX parameters
  ip6tlvs: Add netlink interface
  ip6tlvs: Validation of TX Destination and Hop-by-Hop options

 include/net/ipeh.h         |  209 ++++++++
 include/net/ipv6.h         |   12 +-
 include/uapi/linux/in6.h   |    6 +
 include/uapi/linux/ipeh.h  |   53 ++
 net/dccp/ipv6.c            |    2 +-
 net/ipv6/Makefile          |    3 +-
 net/ipv6/calipso.c         |    6 +-
 net/ipv6/datagram.c        |   51 +-
 net/ipv6/exthdrs.c         |  514 ++-----------------
 net/ipv6/exthdrs_common.c  | 1216 ++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/exthdrs_options.c |  342 +++++++++++++
 net/ipv6/ipv6_sockglue.c   |   39 +-
 net/ipv6/raw.c             |    2 +-
 net/ipv6/tcp_ipv6.c        |    2 +-
 net/ipv6/udp.c             |    2 +-
 net/l2tp/l2tp_ip6.c        |    2 +-
 net/sctp/ipv6.c            |    2 +-
 17 files changed, 1942 insertions(+), 521 deletions(-)
 create mode 100644 include/net/ipeh.h
 create mode 100644 include/uapi/linux/ipeh.h
 create mode 100644 net/ipv6/exthdrs_common.c
 create mode 100644 net/ipv6/exthdrs_options.c

-- 
2.7.4

