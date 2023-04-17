Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AE06E416C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjDQHmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjDQHmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:42:06 -0400
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B606C193
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 00:41:35 -0700 (PDT)
Received: from localhost.localdomain (unknown [113.92.156.116])
        by mail-m11875.qiye.163.com (Hmail) with ESMTPA id 9568528115B;
        Mon, 17 Apr 2023 15:40:48 +0800 (CST)
From:   Ding Hui <dinghui@sangfor.com.cn>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     keescook@chromium.org, grzegorzx.szczurek@intel.com,
        mateusz.palczewski@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn,
        Ding Hui <dinghui@sangfor.com.cn>
Subject: [RESEND PATCH net 0/2] iavf: Fix issues when setting channels concurrency with removing
Date:   Mon, 17 Apr 2023 15:40:14 +0800
Message-Id: <20230417074016.3920-1-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCSh1LVhhIQ0MZHxofQxpCH1UTARMWGhIXJBQOD1
        lXWRgSC1lBWUpKSFVCSVVKTk1VSkpNWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVSktLVUtZBg++
X-HM-Tid: 0a878e28c4152eb1kusn9568528115b
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pi46FBw6UT0TQx0OOBQOGQIc
        QzNPCk5VSlVKTUNKTEpMSU9CT01IVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKSkhVQklVSk5NVUpKTVlXWQgBWUFJTElONwY+
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patchset fix two issues which can be reproduced by the following script:

[root@host ~]# cat test-iavf-1.sh
#!/bin/bash

pf_dbsf="0000:41:00.0"
vf0_dbsf="0000:41:02.0"
g_pids=()

function do_set_numvf()
{
    echo 2 >/sys/bus/pci/devices/${pf_dbsf}/sriov_numvfs
    sleep $((RANDOM%3+1))
    echo 0 >/sys/bus/pci/devices/${pf_dbsf}/sriov_numvfs
    sleep $((RANDOM%3+1))
}

function do_set_channel()
{
    local nic=$(ls -1 --indicator-style=none /sys/bus/pci/devices/${vf0_dbsf}/net/)
    [ -z "$nic" ] && { sleep $((RANDOM%3)) ; return 1; }
    ifconfig $nic 192.168.18.5 netmask 255.255.255.0
    ifconfig $nic up
    ethtool -L $nic combined 1
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
while :; do do_set_channel ; done &
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

