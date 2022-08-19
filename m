Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B435999C8
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 12:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348331AbiHSKVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 06:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346861AbiHSKVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 06:21:53 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053E6EF9EF;
        Fri, 19 Aug 2022 03:21:52 -0700 (PDT)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M8HlQ2BYBzkWMp;
        Fri, 19 Aug 2022 18:18:26 +0800 (CST)
Received: from [10.67.102.169] (10.67.102.169) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 19 Aug 2022 18:21:49 +0800
CC:     <yangyicong@hisilicon.com>, <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <zhoulei154@h-partners.com>, Linuxarm <linuxarm@huawei.com>
To:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>
From:   Yicong Yang <yangyicong@huawei.com>
Subject: [ISSUE] Cannot enable VF after remove/rescan
Message-ID: <9f37e68c-e960-5188-f52a-4761866c37ad@huawei.com>
Date:   Fri, 19 Aug 2022 18:21:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.169]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ixgbe maintainers,

We met an issue that the VF of 82599 cannot be enabled after remove and rescan the PF device.
The PCI hierarchy on our platform is like:
[...]
 +-[0000:80]-+-00.0-[81]--
 |           +-04.0-[82]--
 |           +-08.0-[83]--+-00.0  Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection
 |           |            \-00.1  Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection
 |           \-10.0-[84]--
[...]

We operated like below:

[root@localhost ~]# cat /sys/class/net/enp131s0f0/device/sriov_numvfs
0
[root@localhost ~]# echo 1 > /sys/class/net/enp131s0f0/device/sriov_numvfs   # enable 1 VF
[root@localhost ~]# echo 1 > /sys/bus/pci/devices/0000:83:00.0/remove        # remove the PF
[root@localhost ~]# echo 1 > /sys/bus/pci/rescan                             # rescan the PF
[root@localhost ~]# cat /sys/class/net/enp131s0f0/device/sriov_numvfs
0
[root@localhost ~]# echo 1 > /sys/class/net/enp131s0f0/device/sriov_numvfs   # attemp to enable the VF
[  433.568996] ixgbe 0000:83:00.0 enp131s0f0: SR-IOV enabled with 1 VFs
[  433.639027] ixgbe 0000:83:00.0: Multiqueue Enabled: Rx Queue count = 4, Tx Queue count = 4 XDP Queue count = 0
[  433.652932] ixgbe 0000:83:00.0: can't enable 1 VFs (bus 84 out of range of [bus 83])
[  433.661228] ixgbe 0000:83:00.0: Failed to enable PCI sriov: -12
-bash: echo: write error: Cannot allocate memory


A further investigation shows that the SRIOV offset changed after the rescan, so we cannot find
an available PCI bus (it's already occupied) for the VF device:

Before the remove:
[root@localhost ~]# lspci -vvs 83:00.0
        Capabilities: [160 v1] Single Root I/O Virtualization (SR-IOV)
                IOVCap: Migration- 10BitTagReq- Interrupt Message Number: 000
                IOVCtl: Enable- Migration- Interrupt- MSE- ARIHierarchy+ 10BitTagReq-
                IOVSta: Migration-
                Initial VFs: 64, Total VFs: 64, Number of VFs: 0, Function Dependency Link: 00
                VF offset: 128, stride: 2, Device ID: 10ed
                Supported Page Size: 00000553, System Page Size: 00000001
                Region 0: Memory at 0000280000804000 (64-bit, prefetchable)
                Region 3: Memory at 0000280000904000 (64-bit, prefetchable)
                VF Migration: offset: 00000000, BIR: 0

After the rescan:
[root@localhost ~]# lspci -vvs 83:00.0
        Capabilities: [160 v1] Single Root I/O Virtualization (SR-IOV)
                IOVCap: Migration- 10BitTagReq- Interrupt Message Number: 000
                IOVCtl: Enable- Migration- Interrupt- MSE- ARIHierarchy- 10BitTagReq-
                IOVSta: Migration-
                Initial VFs: 64, Total VFs: 64, Number of VFs: 0, Function Dependency Link: 00
                VF offset: 384, stride: 2, Device ID: 10ed
                ^^^^^^^^^^^^^^
                           offset has changed
                Supported Page Size: 00000553, System Page Size: 00000001
                Region 0: Memory at 0000280000804000 (64-bit, prefetchable)
                Region 3: Memory at 0000280000904000 (64-bit, prefetchable)


We don't know why the SRIOV offset and stride changed and is there anything wrong. Any help on how
to illustrate or fix this is highly appreciated! Please let us know if more information is needed.

Thanks,
Yicong

