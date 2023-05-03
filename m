Return-Path: <netdev+bounces-57-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC0286F4F10
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 05:16:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4F931C209F8
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 03:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18360813;
	Wed,  3 May 2023 03:16:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB387F4
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 03:16:24 +0000 (UTC)
Received: from mail-m11876.qiye.163.com (mail-m11876.qiye.163.com [115.236.118.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877C6AD;
	Tue,  2 May 2023 20:16:22 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPV6:240e:3b7:327f:5c30:95e8:3d27:11c5:1ee8])
	by mail-m11876.qiye.163.com (Hmail) with ESMTPA id 7D4DC3C0234;
	Wed,  3 May 2023 11:16:14 +0800 (CST)
From: Ding Hui <dinghui@sangfor.com.cn>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	intel-wired-lan@lists.osuosl.org,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com
Cc: keescook@chromium.org,
	grzegorzx.szczurek@intel.com,
	mateusz.palczewski@intel.com,
	mitch.a.williams@intel.com,
	gregory.v.rose@intel.com,
	jeffrey.t.kirsher@intel.com,
	michal.kubiak@intel.com,
	simon.horman@corigine.com,
	madhu.chittim@intel.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	pengdonglin@sangfor.com.cn,
	huangcun@sangfor.com.cn,
	Ding Hui <dinghui@sangfor.com.cn>
Subject: [PATCH net v4 0/2] iavf: Fix issues when setting channels concurrency with removing
Date: Wed,  3 May 2023 11:15:39 +0800
Message-Id: <20230503031541.27855-1-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCHUlCVh1KHU9CTkpPSUpMHVUTARMWGhIXJBQOD1
	lXWRgSC1lBWUlPSx5BSBlMQUhJTB1BThhIS0FCTh5DQUgfSUxBSkoYTkFKHh5DWVdZFhoPEhUdFF
	lBWU9LSFVKSktISkxVSktLVUtZBg++
X-HM-Tid: 0a87df9c4c802eb2kusn7d4dc3c0234
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6N0k6Tgw6CD0OAToTMB8XQgIK
	DkoaFC1VSlVKTUNIS0NITExOTkpIVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlJT0seQUgZTEFISUwdQU4YSEtBQk4eQ0FIH0lMQUpKGE5BSh4eQ1lXWQgBWUFIS09ONwY+
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

The patchset fix two issues which can be reproduced by the following script:

[root@host ~]# cat repro.sh
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


