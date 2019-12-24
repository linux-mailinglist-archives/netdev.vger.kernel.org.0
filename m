Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C410C12A3B5
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 18:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfLXR4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 12:56:13 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:37625 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbfLXR4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 12:56:12 -0500
Received: by mail-pl1-f177.google.com with SMTP id c23so8693896plz.4
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 09:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ELEwT1ByLkYG+jRVU1LEpm7OI9vNVp1/DX6tN+FKbu0=;
        b=dYuJFQ/UAkfo/3t5BCtK4Ybp+teY3BkIK6/rNMtHA2LOz50o6yND1+lQee6lkit1Oy
         m8+RtxK3Mm33Nss2d0ppOCCdiVRkR5mEgV7FqjHYrJH/ZiIuEudS2yx2bmtmHHoMFrxP
         G/NSNfkXZUoeksThyIs5M8DCGp/HJMV89mTZ+k83UzXa6NWe2dfsH8H99J+4IgSqhcls
         vIkd9/h12lLDqv7qIKOlE32vjDRDPyORgFjwQAJXxwh9VuZoFvrTDMYIGyXWWV6qRzn3
         TYOaiAQdm/qorVqtcM5MGlD6XSIwh5jgtkhQySJUa6sOIxW7BEd88v0wa39RWV+gj9xM
         MNbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ELEwT1ByLkYG+jRVU1LEpm7OI9vNVp1/DX6tN+FKbu0=;
        b=cHsX7gLVt1W4JtM1h0oqGtiwhYgnu+ufHDhk69yh9zeUabWg3Ff3n0xKJ9NWfHXa5X
         mQBlZOK34BqlOB0H0MLaKW0isIfIHofgH59fOP1ZLpovRjAAA0gxtoKXb60+StAvK/If
         gmgarJ7BxcQP4LnFpNWYwvsxJC+Od/1ye+WkP6hnRfXm03s/7PIN9LpxqJHjapdkdcmc
         OECEhi6FlvKabjkIASw+mMM4ydbw+NrJHIoJ8YL9nDevtl465fG1pw5er8hboqVUOK18
         8Jwfgd/O10B1qEJuPSJIoxvdRGTjGBZw6X+aRT6ZOjkJW/dTHot043yuK0XkH4s+xYTr
         ttFA==
X-Gm-Message-State: APjAAAW5l4sZT4YFySpjLcHF6NnIwCe7+vQKFBog1oQUPLwHY5JvgGuV
        N8VeXKgWRIpqf/7E28QPUVkX2A==
X-Google-Smtp-Source: APXvYqwdLCIGuf064FeNUfOnkAlIdvirlo3p+bJS7R+Easc4zTNQw4pxK+hyDtPEiXy0BYefcYCylg==
X-Received: by 2002:a17:90a:ac02:: with SMTP id o2mr7374880pjq.93.1577210170784;
        Tue, 24 Dec 2019 09:56:10 -0800 (PST)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id l22sm4410433pjc.0.2019.12.24.09.56.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 24 Dec 2019 09:56:10 -0800 (PST)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        simon.horman@netronome.com, willemdebruijn.kernel@gmail.com
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [PATCH v7 net-next 0/9] ipv6: Extension header infrastructure
Date:   Tue, 24 Dec 2019 09:55:39 -0800
Message-Id: <1577210148-7328-1-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset improves the IPv6 extension header infrastructure
to make extension headers more usable and scalable.

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

