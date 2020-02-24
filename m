Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7333016B182
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgBXVIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:08:01 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53135 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbgBXVIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:08:01 -0500
Received: by mail-wm1-f65.google.com with SMTP id p9so788335wmc.2
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 13:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u7eh0nEdK/ugaa5HQYHhe9o74MK9yAH57HMQ6PU0J74=;
        b=geC8aPsktFbY3SLW5IzUIm/gDjwAHC3vIrI2s0Bna4Y1v4izXDVM/Y9j8i41jlKwIU
         vp/318wLRNMpsNfYoaZLdBZc6+yf0oxgWZGS7eBlQbDzagop5YGbuJIyhUn7Hf6IKqGe
         7eNjbjzi/vprAQ5yhQ8nRNb22HxpBfGlnmzv42YMYMy8BLvRWtDi448o44eSw0rKFqc2
         DbM2bukZCkM4L3lXyK53oPatuPN77ywPfOnmNXWPfBVeDUGQbm7aZv/7e6bpTTSWnSOs
         ryhQQadp4ai92sJDCa0Z4xro0V79OuwCTnI13BZTO7EnFJWLId4fFZHyiCbiDJoV0pjJ
         OdhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u7eh0nEdK/ugaa5HQYHhe9o74MK9yAH57HMQ6PU0J74=;
        b=Nc2yniSjL66Aal+Tl6Rkmi6xcvWRCjtUeDHwSDXI2OuL4TJ8k785lTXHhangQ/gpe5
         G/bXam+1Wob0gtlLfTNBZ4FShYeSCMNuz3XLQu3snfO1HHYuV8RJ1pfkaoXVeIe3MMMt
         0UtHKeqHjXxGGszKvI5n91oyehqg3iy9B4byZYdGtd174JdUMwc46vyAOqNXnfIHFZh9
         hzcrfG05apyX8WFhU5i+w027IH4t5HbLlYGj3o3pgvgm7ZAu85tvsJL/cxpIQU/VTRjN
         XshfBLn3FfxGj8NNtd4O1T1guY+48Ly2ZrrnOyeGMKKak7fDDX6MxdTf6yhFNFiPW3Pi
         gq7Q==
X-Gm-Message-State: APjAAAVcn73fe4K16XEY7tXjS1Jvyem4MQgAzTRpOxGvNU2ZDcftSw99
        y8Lh1iElI1owmDsZkRWj1QNjWUrnGzg=
X-Google-Smtp-Source: APXvYqzs+OLShBhWVZ3pzNugSkVOd6bE9R5hFSpory4e1GDPOPNwM0HGWSzy2MuZmpvevB5i+Y3kLg==
X-Received: by 2002:a1c:4c5:: with SMTP id 188mr881002wme.82.1582578479843;
        Mon, 24 Feb 2020 13:07:59 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id g14sm10207150wrv.58.2020.02.24.13.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:07:59 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 00/10] mlxsw: Implement ACL-dropped packets identification
Date:   Mon, 24 Feb 2020 22:07:48 +0100
Message-Id: <20200224210758.18481-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

mlxsw hardware allows to insert a ACL-drop action with a value defined
by user that would be later on passed with a dropped packet.

To implement this, use the existing TC action cookie and pass it to the
driver. As the cookie format coming down from TC and the mlxsw HW cookie
format is different, do the mapping of these two using idr and rhashtable.

The cookie is passed up from the HW through devlink_trap_report() to
drop_monitor code. A new metadata type is used for that.

Example:
$ tc qdisc add dev enp0s16np1 clsact
$ tc filter add dev enp0s16np1 ingress protocol ip pref 10 flower skip_sw dst_ip 192.168.1.2 action drop cookie 3b45fa38c8
                                                                                                                ^^^^^^^^^^
$ devlink trap set pci/0000:00:10.0 trap acl action trap
$ dropwatch
Initializing null lookup method
dropwatch> set hw true
setting hardware drops monitoring to 1
dropwatch> set alertmode packet
Setting alert mode
Alert mode successfully set
dropwatch> start
Enabling monitoring...
Kernel monitoring activated.
Issue Ctrl-C to stop monitoring
drop at: ingress_flow_action_drop (acl_drops)
origin: hardware
input port ifindex: 30
input port name: enp0s16np1
cookie: 3b45fa38c8    <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
timestamp: Fri Jan 24 17:10:53 2020 715387671 nsec
protocol: 0x800
length: 98
original length: 98

This way the user may insert multiple drop rules and monitor the dropped
packets with the information of which action caused the drop.

Jiri Pirko (10):
  flow_offload: pass action cookie through offload structures
  devlink: add trap metadata type for cookie
  drop_monitor: extend by passing cookie from driver
  devlink: extend devlink_trap_report() to accept cookie and pass
  mlxsw: core_acl_flex_actions: Add trap with userdef action
  mlxsw: core_acl_flex_actions: Implement flow_offload action cookie
    offload
  mlxsw: pci: Extract cookie index for ACL discard trap packets
  mlxsw: spectrum_trap: Lookup and pass cookie down to
    devlink_trap_report()
  netdevsim: add ACL trap reporting cookie as a metadata
  selftests: netdevsim: Extend devlink trap test to include flow action
    cookie

 drivers/net/ethernet/mellanox/mlxsw/core.h    |   5 +-
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 289 +++++++++++++++++-
 .../mellanox/mlxsw/core_acl_flex_actions.h    |   7 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |   9 +
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h  |   5 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  11 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |   7 +-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |   3 +-
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  46 ++-
 drivers/net/netdevsim/dev.c                   | 118 ++++++-
 drivers/net/netdevsim/netdevsim.h             |   2 +
 include/net/devlink.h                         |   8 +-
 include/net/drop_monitor.h                    |   3 +
 include/net/flow_offload.h                    |  11 +
 include/uapi/linux/devlink.h                  |   2 +
 include/uapi/linux/net_dropmon.h              |   1 +
 net/core/devlink.c                            |  14 +-
 net/core/drop_monitor.c                       |  33 +-
 net/core/flow_offload.c                       |  21 ++
 net/sched/cls_api.c                           |  31 +-
 .../drivers/net/netdevsim/devlink_trap.sh     |   5 +
 21 files changed, 606 insertions(+), 25 deletions(-)

-- 
2.21.1

