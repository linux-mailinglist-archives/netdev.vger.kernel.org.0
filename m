Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14ABB128595
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 00:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfLTXjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 18:39:18 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:40198 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfLTXjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 18:39:17 -0500
Received: by mail-pf1-f180.google.com with SMTP id q8so6056211pfh.7
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 15:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=Vf3Bo/w2DMGELrRPhmngdku+4mZnW82yk0RNt+cOstA=;
        b=Zg2ZLYQ4pORIhFiFQgwMzXJZZ3uUDu+JPpB2+uyS4Nyt4bzjeVtxCF1N66sKYOSrum
         tgddoHeQWZbrU5kTJWZTMztITPntOTXlEbbyFfz1L2IS+PzfUnFXVwLQ7U1sPzyDdPRj
         hhHioTfPGfjC6QrIZQm1DIus0vGhh/tvJzO+wEZwXdQIRPGLI+zPrDwhTOpkMhM5yA1y
         1gYOcbbgjYLsdUyIjab9q/diA+NPXK8zmi/3rfkGCLmNHaSTomxL08mOTKR/XT+p4zy8
         4PxdCfofa7jDqfUzmP3iSb1J/HcfbuiAqZwIG4XHuTL7TJV7kLZRUQiQoS5ZqhKdezYm
         E/bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Vf3Bo/w2DMGELrRPhmngdku+4mZnW82yk0RNt+cOstA=;
        b=MPTyuBeaxuHKzUi2dJk4MUGPuf3j/p7tUjBKXSI1JbApkTSq83/xHmYINzTzUQiem4
         Bh+6PnTJrEKVMH9RT/cO8wn1s6aJ9vzG80PSgRuA9m0DXE1vWSHBJ8tT0eZxBOXexZxC
         Z3RxP8QGcojjDxyFt5juFp7bAZIkjNFn0FmSfrimZK1eiIpsgzUhmn9MWWsaG86ti73Z
         LVL1tyMs9oiIfbN54TEHjOS914qjs9RfFy6QJ/kPcy/JVJkijxYg3mzzwsvRsGofqfeh
         De4+xpjefFK0cFE+QVvoShqJv2CBCif57JM+4tQ51Age2JLDE4kPhsyVW94hMsapx5Qi
         LPJw==
X-Gm-Message-State: APjAAAVatFIxZ6ocWN3JY1fgOZslJlEsJCibtL6lsm0x8U3CeY5/EEbj
        jeoMens8z9+H0O21U8K0xA3WzrU5EgE=
X-Google-Smtp-Source: APXvYqyfkPF7w9Qe0fHfUia/msIyXj+z3gbZKpImmNSqezvmsNXfzGfclOsiCuGanJpg8G5D09YbYA==
X-Received: by 2002:a62:14c4:: with SMTP id 187mr17590890pfu.96.1576885157175;
        Fri, 20 Dec 2019 15:39:17 -0800 (PST)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id 207sm14833555pfu.88.2019.12.20.15.39.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 15:39:16 -0800 (PST)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        simon.horman@netronome.com
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [PATCH v6 net-next 0/9] ipv6: Extension header infrastructure
Date:   Fri, 20 Dec 2019 15:38:35 -0800
Message-Id: <1576885124-14576-1-git-send-email-tom@herbertland.com>
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
    (unless overridden by admin) following the sending clause
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

Tom Herbert (9):
  ipeh: Fix destopts and hopopts counters on drop
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
 net/ipv6/exthdrs.c         |  504 ++----------------
 net/ipv6/exthdrs_common.c  | 1212 ++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/exthdrs_options.c |  342 +++++++++++++
 net/ipv6/ipv6_sockglue.c   |   39 +-
 net/ipv6/raw.c             |    2 +-
 net/ipv6/tcp_ipv6.c        |    2 +-
 net/ipv6/udp.c             |    2 +-
 net/l2tp/l2tp_ip6.c        |    2 +-
 net/sctp/ipv6.c            |    2 +-
 17 files changed, 1938 insertions(+), 511 deletions(-)
 create mode 100644 include/net/ipeh.h
 create mode 100644 include/uapi/linux/ipeh.h
 create mode 100644 net/ipv6/exthdrs_common.c
 create mode 100644 net/ipv6/exthdrs_options.c

-- 
2.7.4

