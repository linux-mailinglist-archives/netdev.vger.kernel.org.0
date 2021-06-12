Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176173A4D7C
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 10:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhFLIOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 04:14:33 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:43587 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFLIOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 04:14:32 -0400
Received: by mail-wm1-f43.google.com with SMTP id 3-20020a05600c0243b029019f2f9b2b8aso9904911wmj.2
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 01:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=PjfXwsPcghDr/hl25l9T5SqKcmdJcn7DVb5D0lG+L2k=;
        b=K83mv9kBveJx0y6g5THgQNZ/GY3TW8+W5q3A0ky+WF+QUzHFUyFmYtZDLQRP5NkEps
         7xJSyQiA0UETnRjpVu7utq/5vtaXS79SQPavTXlj1Eca0kw+gnd05LsSuOefk+JPSWbd
         HsPad/Jal+xcpzRNG6Fc1aZeEy666LChll78sACwyvXTA+8/lsZt5d/OITPVUytLAExT
         Lfda1WtV2KfWDQOuFQeIjnbaDaIaQZ48Vky9c5lLW2Me/Xc2/2FfW+04JmrZxcgF4YaE
         ObommooqjF0E3U+6BuMoNzgyZw/na6OSp9CeHiedL5Ii5drFM0I7xtrQA0TT1j31qhTA
         Tt9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PjfXwsPcghDr/hl25l9T5SqKcmdJcn7DVb5D0lG+L2k=;
        b=Plyzoa4lEEI1OTSyBm7eIWmtmJQObxF2plyf6yehOx+hIqY7Acwvzb5vjbuJDqCo/i
         qUijdCWIa3VBcvWpB5YUz7AAEfcOeVCGqU5CRnjlne3WMgDsaALHKtfqwGEEZ/FFt1Es
         E7c/DZNBJqotsfg7Bkf/O7b1vJXxHPVfjkj53471a6r88nTScHVN+bZdrAy54ikwSsJB
         x8g1hS9p5p975RNySpLGu9wvj0dTsvCdEqUQCcEVgLmodToBBXSVlriV/R/VjUV5aXA2
         h9caqgGhjXarm2j2NiSDaG8/ZA32/QEkkbeK70y0QR4ki2O1I9I3kdyQktTsblfkRChH
         cu1Q==
X-Gm-Message-State: AOAM5327lPNBswM4aJI6PYJ5hRjcXWzgk93xwEOSVOKHgmYZihGTunmp
        mmmTlbWNW0tBZOsaA64Kdx+NHQ==
X-Google-Smtp-Source: ABdhPJzJrrApgPsUXwQg8LBP2qiI0XIl+LgtypSWsEmqlRPm96OejWKYlzX2Zjci4g3o0lbmjbDzWw==
X-Received: by 2002:a7b:c10b:: with SMTP id w11mr23810742wmi.186.1623485479049;
        Sat, 12 Jun 2021 01:11:19 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:85ed:406e:1bc4:a268])
        by smtp.gmail.com with ESMTPSA id w13sm10619313wrc.31.2021.06.12.01.11.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Jun 2021 01:11:18 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, m.chetan.kumar@intel.com,
        johannes.berg@intel.com, leon@kernel.org, ryazanov.s.a@gmail.com,
        parav@nvidia.com, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v3 0/4] net: Add WWAN link creation support
Date:   Sat, 12 Jun 2021 10:20:53 +0200
Message-Id: <1623486057-13075-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the modern WWAN modems are able to support multiple network
contexts, allowing user to connect to different APNs (e.g. Internet,
MMS, etc...). These contexts are usually dynamically configured via
a control channel such as MBIM, QMI or AT.

Each context is naturally represented as a network link/device, and
the muxing of these links is usually vendor/bus specific (QMAP, MBIM,
intel iosm...). Today some drivers create a static collection of
netdevs at init time, some relies on VLAN link for associating a context
(cdc-mbim), some exposes sysfs attribute for dynamically creating
additional netdev (qmi_wwan add_mux attr) or relies on vendor specific
link type (rmnet) for performing the muxing... so there is no generic
way to handle WWAN links, making user side integration painful.

This series introduces a generic WWAN link management interface to the
WWAN framework, allowing user to dynamically create and remove WWAN
links through rtnetlink ('wwan' type). The underlying 'muxing' vendor
implementation is completely abstracted.

The idea is to use this interface for upcoming WWAN drivers (intel
iosm) and to progressively integrate support into existing ones
(qmi_wwan, cdc-mbim, mhi_net, etc...).


v2: - Squashed Johannes and Sergey changes
    - Added IFLA_PARENT_DEV_BUS_NAME attribute
    - reworded commit message + introduce Sergey's comment

v3: - Added basic new interface user to this series (mhi_net)
    - Moved IFLA_PARENT_DEV_NAME nla_policy introduction to right patch
    - Added cover letter
    - moved kdoc to .c file


Johannes Berg (3):
  rtnetlink: add alloc() method to rtnl_link_ops
  rtnetlink: add IFLA_PARENT_[DEV|DEV_BUS]_NAME
  wwan: add interface creation support

Loic Poulain (1):
  net: mhi_net: Register wwan_ops for link creation

 drivers/net/Kconfig          |   1 +
 drivers/net/mhi/net.c        | 123 ++++++++++++++++++----
 drivers/net/wwan/wwan_core.c | 245 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/wwan.h         |  24 +++++
 include/net/rtnetlink.h      |   8 ++
 include/uapi/linux/if_link.h |   7 ++
 include/uapi/linux/wwan.h    |  16 +++
 net/core/rtnetlink.c         |  30 +++++-
 8 files changed, 419 insertions(+), 35 deletions(-)
 create mode 100644 include/uapi/linux/wwan.h

-- 
2.7.4

