Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8FFD16BF04
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730353AbgBYKpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:45:32 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38078 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729417AbgBYKpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 05:45:32 -0500
Received: by mail-wr1-f66.google.com with SMTP id e8so14130512wrm.5
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 02:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JKudRvcTO8rgWPkCP9rmiRjxyvxieFSOWjFOG+/nM30=;
        b=I/Yz+pell4sk9QZoibTiZyfQpxqMCF6Bgo8/1k9PqEISXfdY+vN6N9FXsQlxKl2XSB
         eEAiUXzqYokrmWIUku1GUJsnExo12/WbmLQAL7NtyZKTCZtqajBK2Z2FeiFeZMQbmeSM
         rkXWzveQA6DBGtTI7m+8zAtLLLEBp5Dse+diQZkVytEZfok4wc4usOAwF01juPzduklK
         eG8njtRmm840XGSRkq1sml1BtJdhioYH4d0qgCQb/RTZzzqA6A07IiXzTlflU4gWZjmn
         bn/wO2hS6pQ9hZ5/Gkf719oG0U6d4W1AR8VtqdnPv2Ue/M8ti7ZtIiiGB0i4craqTpbv
         vokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JKudRvcTO8rgWPkCP9rmiRjxyvxieFSOWjFOG+/nM30=;
        b=U8I8AKWcWasl+yDICtvtb/M5DGZI/VDJWEaP8A0fuekHKK67fhiod3bUze8uiTUOoj
         dOTjOXVSM259YY4QcB/VhqUOULAsU0ENSt8/Q7jwTcSCDb+ckgDRxdweB626mFp8R1EP
         kuTdf1t4nZ3nmhGvsoMhIuGWSXaC67ryQpGNhgJxpbnPV+zYWxR0Od306Yw1VkmXBe0i
         zox5+VE8mPY6fqyjk7ESNcEkkWK/KiSvg3hFIwLF76FU/ovTlylt3PW+p0GHrVY4ydAM
         wQJ7/wNi1FsSWVtg5DKrfyJ3Md1VmiARlGZaM1on3hGEurNVfw6ErDUW6SbHfD8XoWTm
         Kv2g==
X-Gm-Message-State: APjAAAVMV+Izcfxsf9+bHSNG/7Ex9Cvy+OKGczF7lfWgyYBgfxVxFJtz
        NC7dafloOCdOwYoqnAy1bK1FGOanT2E=
X-Google-Smtp-Source: APXvYqwKSZ8O8PRzrBfyVC0sLjCKii5OGn6XyNt+DyicLIlmcXRg49XcpV3U0IljyB3ufGcLEUVhtw==
X-Received: by 2002:adf:f641:: with SMTP id x1mr19853187wrp.248.1582627528595;
        Tue, 25 Feb 2020 02:45:28 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id b11sm23516733wrx.89.2020.02.25.02.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 02:45:28 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 00/10] mlxsw: Implement ACL-dropped packets identification
Date:   Tue, 25 Feb 2020 11:45:17 +0100
Message-Id: <20200225104527.2849-1-jiri@resnulli.us>
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
 drivers/net/netdevsim/dev.c                   | 117 ++++++-
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
 21 files changed, 605 insertions(+), 25 deletions(-)

-- 
2.21.1

