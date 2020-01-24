Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD063148412
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 12:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392053AbgAXLkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 06:40:32 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42029 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731659AbgAXLkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 06:40:32 -0500
Received: by mail-lf1-f68.google.com with SMTP id y19so892078lfl.9
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 03:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0FtJ6MlkdUyddBUzFcRR+OPGQmZ6SOcizcRhY4N8y5g=;
        b=H7F9m+jtsbzB+CI3Nr3fqV0xj5szLDh+/z4SjVgAzAwlpGQQEOJ/CYvk4Xdte7rtxs
         5GfABf37WsmS0BNydt0ZHx65l4KyjDSDOCyU4D50sgRpBsNb0QrphykWy4XuEc7dBrhP
         xdZicEqlUBXkpHsijNsUT/bK3YtpynMYyOzb0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0FtJ6MlkdUyddBUzFcRR+OPGQmZ6SOcizcRhY4N8y5g=;
        b=HbM9jg6wGM5e9p3Sty5haPPQY86t0lVOlJoZ1MhKx3Tt3e114zJcXCSDlJJyoshFFR
         rC6n+b/lK9y9zkpttd2Q/GIWl46UfyiLC2LU7pacuLQJJwl4X1p2Hbv9svW1rPMn5ZS4
         TGyhbzP1SfoeoBy73KgcgnqRwi88/eIsBYmLXynfgrnslg8TkkT4c80HihsBwB7wW5Uv
         pjVSmngz8JH6myOV0i+mZSsh+zPo4G4DAd/IQdEzi4rJKLQRIypILZEiBf/0vtB5ze0I
         UYQlRAayaklqd1igKPKM9kmIAcZy73+QVzfe+a7rwm7cgZE4Asx9xg7KvSokDpRDzETw
         WSYQ==
X-Gm-Message-State: APjAAAWjHEfnM+UeufjeyAhElIfAWL+5fkR7NnefNjTt8CVx1d9ZRhiG
        kv03IPTfBEmNeN+QN4zvXn0TJ5wBKkk=
X-Google-Smtp-Source: APXvYqzErOQdCSPkyV+v/nJqqimQLFO4/zmxqbQmm27qllVn6Gwz+FR4ElvUByJ02FzlUTB4ceRdGQ==
X-Received: by 2002:a19:c210:: with SMTP id l16mr1211806lfc.35.1579866029368;
        Fri, 24 Jan 2020 03:40:29 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s22sm2996185ljm.41.2020.01.24.03.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 03:40:28 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 0/4] net: bridge: add per-vlan state option
Date:   Fri, 24 Jan 2020 13:40:18 +0200
Message-Id: <20200124114022.10883-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This set adds the first per-vlan option - state, which uses the new vlan
infrastructure that was recently added. It gives us forwarding control on
per-vlan basis. The first 3 patches prepare the vlan code to support option
dumping and modification. We still compress vlan ranges which have equal
options, each new option will have to add its own equality check to
br_vlan_opts_eq(). The vlans are created in forwarding state by default to
be backwards compatible and vlan state is considered only when the port
state is forwarding (more info in patch 4).
I'll send the selftest for the vlan state with the iproute2 patch-set.

v2: patch 3: do full (all-vlan) notification only on vlan
    create/delete, otherwise use the per-vlan notifications only,
    rework how option change ranges are detected, add more verbose error
    messages when setting options and add checks if a vlan should be used.

Thanks,
 Nik

Nikolay Aleksandrov (4):
  net: bridge: check port state before br_allowed_egress
  net: bridge: vlan: add basic option dumping support
  net: bridge: vlan: add basic option setting support
  net: bridge: vlan: add per-vlan state

 include/uapi/linux/if_bridge.h |   2 +
 net/bridge/Makefile            |   2 +-
 net/bridge/br_device.c         |   3 +-
 net/bridge/br_forward.c        |   2 +-
 net/bridge/br_input.c          |   7 +-
 net/bridge/br_private.h        |  59 +++++++++++-
 net/bridge/br_vlan.c           | 108 ++++++++++++++++------
 net/bridge/br_vlan_options.c   | 160 +++++++++++++++++++++++++++++++++
 8 files changed, 311 insertions(+), 32 deletions(-)
 create mode 100644 net/bridge/br_vlan_options.c

-- 
2.21.0

