Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0AFACB196
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730899AbfJCV63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:58:29 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44133 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfJCV63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:58:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id q21so2565343pfn.11
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 14:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=nmoX23EXR9+zByNRzA6tGv1/B1GYLW/CsBr5hwKMS2I=;
        b=wFYCXXGBI18hoIOL66MBZKtrOTvFFaMEnZK01D7n2h1hcTNxQdKR843wjQq7zZsWMa
         C2FfocwfRKSLU3nUj1aZHQ7Uvqe/uvaKhc/eF52q9S/p+W0HzfPHk70XAW7wp2TMb1kY
         ZU/KA8m4rCLJxMavNjWRiS8T8Z15qy7zHY8L1/XoM8JUTMiGdHxJ0xzfMepC2NJuHqoD
         6ReLYpeLlQfWDBsGbljCQglbRv70mXXll8opqkMh41vdDu0fSkPZ2+aIZ5O3xZGZHDSa
         HmlL2yXL8CjHnrIknn8AgMm4h4jv7IsffTbBfnQvgtCBjlBBMHvdySS/H33gWDJX5gnf
         L8zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nmoX23EXR9+zByNRzA6tGv1/B1GYLW/CsBr5hwKMS2I=;
        b=YroXotuy3tuYc41n/XX03Mn6ngwO8AilgZDDIk5LcVt7VxR7SMaapVHfyJTZoqArbD
         /wCGEFVgtjlu1w+qDcNj9xZAbjJHWORXyKlGj5dS5NYUWrk3Iws5fJNiS8RDHnP/pEea
         dPwFrria/A5dJWZQExjvFPyQsPCNTJBqWCnKJSH66KLcOzdMA9T+nTi9vGFjzA83VLGj
         wNNVGrd0T2V5VCFswyv3f0SAXU2QgSeKukN8soonsl+K+UeJ6D4CQh7oFr4bC+DrHl+O
         5Y6q47hnh6dOi01/4mwBrgfzkQsGPCYcTkTCaHRJs9aiknNjJGxHwENEv2STA34JdKk+
         rI9g==
X-Gm-Message-State: APjAAAW9Uw15/gPvxVDpjQkqQoHV4b/R7czRCQ10Ui3R1UG4zjwO1vUG
        AoVu4E2iIoZVOKIt8kvtiAq9FlAGENIbyQ==
X-Google-Smtp-Source: APXvYqwxsbd1VGp3FPMT0RG9d5Ix3ss/6VK/4Vq6fZ3d4pnObfgCehJN+WGUVbiW9n3VBQWE6o4gFQ==
X-Received: by 2002:a62:1e82:: with SMTP id e124mr13423442pfe.136.1570139906997;
        Thu, 03 Oct 2019 14:58:26 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id r18sm3889905pfc.3.2019.10.03.14.58.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 03 Oct 2019 14:58:26 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [PATCH v5 net-next 0/7] ipv6: Extension header infrastructure
Date:   Thu,  3 Oct 2019 14:57:57 -0700
Message-Id: <1570139884-20183-1-git-send-email-tom@herbertland.com>
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

Tom Herbert (7):
  ipeh: Create exthdrs_options.c and ipeh.h
  ipeh: Move generic EH functions to exthdrs_common.c
  ipeh: Generic TLV parser
  ip6tlvs: Registration of TLV handlers and parameters
  ip6tlvs: Add TX parameters
  ip6tlvs: Add netlink interface
  ip6tlvs: Validation of TX Destination and Hop-by-Hop options

 include/net/ipeh.h         |  208 ++++++++
 include/net/ipv6.h         |   12 +-
 include/uapi/linux/in6.h   |    6 +
 include/uapi/linux/ipeh.h  |   53 ++
 net/dccp/ipv6.c            |    2 +-
 net/ipv6/Kconfig           |    4 +
 net/ipv6/Makefile          |    3 +-
 net/ipv6/calipso.c         |    6 +-
 net/ipv6/datagram.c        |   51 +-
 net/ipv6/exthdrs.c         |  505 ++-----------------
 net/ipv6/exthdrs_common.c  | 1158 ++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/exthdrs_options.c |  342 +++++++++++++
 net/ipv6/ipv6_sockglue.c   |   39 +-
 net/ipv6/raw.c             |    2 +-
 net/ipv6/tcp_ipv6.c        |    2 +-
 net/ipv6/udp.c             |    2 +-
 net/l2tp/l2tp_ip6.c        |    2 +-
 net/sctp/ipv6.c            |    2 +-
 18 files changed, 1881 insertions(+), 518 deletions(-)
 create mode 100644 include/net/ipeh.h
 create mode 100644 include/uapi/linux/ipeh.h
 create mode 100644 net/ipv6/exthdrs_common.c
 create mode 100644 net/ipv6/exthdrs_options.c

-- 
2.7.4

