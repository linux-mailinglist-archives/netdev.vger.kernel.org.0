Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9399B6DD
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 21:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390531AbfHWTOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 15:14:51 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35413 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbfHWTOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 15:14:51 -0400
Received: by mail-pf1-f194.google.com with SMTP id d85so7072914pfd.2
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 12:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=B9VmngRYJu7qLesF4v8jht9jZ5Cg3o5hkMjsUO5D7FQ=;
        b=RqzSAwvk9t9xVRHdT3f02yEh5nEYev7Z05/Y8fFae0cujwYp7SXiGWkFMlvje8NzSy
         L92te6YQXoUBlRg3eWEJQG/dMn9F24jEx/AwK12SzirF+TSXVB+lzYhy/+Ec5RQweCPz
         AsXEKy2BmxIX9+eo9oBm6X68gunM30iEPi6RB6uXi8pPXTPtEae+WxgQKYz/GK/yOQLQ
         Ze4qWQGTPQfrF4yfl4U30zDvzWYTQb883+07WKJvY/kLpjrihidBwzMQvjIZTAS+2i7u
         FvnNW9Ifom/XZte168EZmYYdkKKqyvZxtTGnl/tRHvrFC1cxX0BPsm8O9K7Bh3wZ4LZ7
         pWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=B9VmngRYJu7qLesF4v8jht9jZ5Cg3o5hkMjsUO5D7FQ=;
        b=S0u0zklwie/toYeRGZgAi4GkankfsE8z9mO6C6eo0gwy/of9DVB6rCC8U81wkQNkMM
         op4ZkdZSw+ltxIgER5p3t/iTmpwosM6f7vZTgZzFdfphzQXgq9J7KNDFTUdgg3WYVmCI
         jVsZzCL4AGq2f0ZZ8vVJGQg3h9voDuuyDR9UtqOvMdDKK8i6RAZzWGxXU4n9IEAYowfr
         2TsRpmB98jw6UCO5XLqQm+0kjTpkQM1DaezkN3/POYfUs7fn9ejwqPh5tSk6e2cNyXuN
         g3p+jYYv4wOwoJpTTe4jOSW9NyoYZLCbz3u1/cekU0/zyfzjR97HRYEl+nBlejSj40V7
         ZV3w==
X-Gm-Message-State: APjAAAV1MiBJanlYk+ZnQl+8qK6d3fLoIZG/CsTWCGA/JJd0WBW4GuNL
        znTIG4i1bVkTw7LGweJ6zyDShw==
X-Google-Smtp-Source: APXvYqxwlVSl02FmeOT199z60B6YgA35J12dxuhvV51TroiPV1ioPj9BoPmIgCwQZOMlCERUnpRIgA==
X-Received: by 2002:a17:90a:9a90:: with SMTP id e16mr6993904pjp.71.1566587690087;
        Fri, 23 Aug 2019 12:14:50 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id i6sm3146252pfo.16.2019.08.23.12.14.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 23 Aug 2019 12:14:49 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [PATCH v4 net-next 0/7] ipv6: Extension header infrastructure
Date:   Fri, 23 Aug 2019 12:13:56 -0700
Message-Id: <1566587643-16594-1-git-send-email-tom@herbertland.com>
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

