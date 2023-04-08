Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDAC6DBB56
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 16:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjDHOBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 10:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDHOBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 10:01:22 -0400
Received: from mail-m11880.qiye.163.com (mail-m11880.qiye.163.com [115.236.118.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72464EF88;
        Sat,  8 Apr 2023 07:01:20 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPV6:240e:3b7:3279:cf80:b96f:666f:20ca:bc83])
        by mail-m11880.qiye.163.com (Hmail) with ESMTPA id 60349201AB;
        Sat,  8 Apr 2023 22:01:12 +0800 (CST)
From:   Ding Hui <dinghui@sangfor.com.cn>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        keescook@chromium.org, grzegorzx.szczurek@intel.com,
        mateusz.palczewski@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Ding Hui <dinghui@sangfor.com.cn>
Subject: [PATCH net 0/2] iavf: Fix issues when setting channels concurrency
Date:   Sat,  8 Apr 2023 22:00:28 +0800
Message-Id: <20230408140030.5769-1-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDSB1MVkkfQ0lDH09MShlNH1UTARMWGhIXJBQOD1
        lXWRgSC1lBWUlPSx5BSBlMQUhJTEJBGB1DS0EZQk0dQU1NTR1BSUsYGkEZGENIWVdZFhoPEhUdFF
        lBWU9LSFVKSktCSE5VSktLVUtZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PxQ6DQw5Pz0cTzcXSSo#HEox
        MzQaCi5VSlVKTUNLQk1JT0xISkJLVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlJT0seQUgZTEFISUxCQRgdQ0tBGUJNHUFNTU0dQUlLGBpBGRhDSFlXWQgBWUFJTUJLNwY+
X-HM-Tid: 0a87612bcb4d2eb6kusn60349201ab
X-HM-MType: 1
X-Spam-Status: No, score=-0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two issues can be reproduced by the following script:

[root@host ~]# cat test-iavf-1.sh
#!/bin/bash

pf_dbsf="0000:40:01.1/0000:41:00.0"
vf0_dbsf="0000:40:01.1/0000:41:02.0"
g_pids=()

function do_set_numvf()
{
    echo "set 2 vfs"
    echo 2 >/sys/bus/pci/devices/${pf_dbsf}/sriov_numvfs
    sleep $((RANDOM%3+1))
    echo "set 0 vfs"
    echo 0 >/sys/bus/pci/devices/${pf_dbsf}/sriov_numvfs
    sleep $((RANDOM%3+1))
}

function do_nic_reset()
{
    local nic=$(ls -1 --indicator-style=none /sys/bus/pci/devices/${vf0_dbsf}/net/)
    [ -z "$nic" ] && { sleep $((RANDOM%3)) ; return 1; }
    ifconfig $nic 192.168.18.5 netmask 255.255.255.0
    ifconfig $nic up
    echo "set $nic 1 combined"
    ethtool -L $nic combined 1
    echo "set $nic 4 combined"
    ethtool -L $nic combined 4
    sleep $((RANDOM%3))
}

function on_exit()
{
    local pid
    for pid in "${g_pids[@]}"; do
        kill -0 "$pid" &>/dev/null && kill "$pid" &>/dev/null
    done
    g_pids=()
}

trap "on_exit; exit" EXIT

while :; do do_set_numvf ; done &
g_pids+=($!)
while :; do do_nic_reset ; done &
g_pids+=($!)

wait


Ding Hui (2):
  iavf: Fix use-after-free in free_netdev
  iavf: Fix out-of-bounds when setting channels on remove

 drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 4 +++-
 drivers/net/ethernet/intel/iavf/iavf_main.c    | 6 +-----
 2 files changed, 4 insertions(+), 6 deletions(-)

-- 
2.17.1

