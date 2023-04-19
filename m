Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43546E8004
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbjDSRDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbjDSRDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:03:50 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2098.outbound.protection.outlook.com [40.107.243.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440C172B4;
        Wed, 19 Apr 2023 10:03:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6FH1xTyxdtgj0nG23SUPmGjv6KER8I7qyCZOsY9iMyAfj/FXKAVRfdN7rXOBEGNw+wPCeBUWl8GphL2RRJkchBIg6aFKie02Zlm/x+4FM1yGch72/tOJTm8ekM19TerJIjlarXAr4iFPOm94STQdgKqlo/UwmpN+L06KmvN5BuNYIuy5ajukamxFVjNMHesIflxQw+4ASVR0j28GrSwiBFwSCtW5cEzaT/b6zHJcRYFRZijaa7Is0cVYPqMwDp61mtuGnQnMaBVVnp5M+IsZT6CzsyJPxfo3Bd1/JxFGprFLdz97xmBpRI/cNBwxuXBvKGiDJVd85AL12LABp3Isw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1H08zRtaLwGM3T93c1JJAmh23JSUBxtKnRYbSYfUHg=;
 b=eaLT6/aozthO1yuEBpfG6szMeVvQ/e5cKA0X8f0mWddPrDQ9vPJ9/PVBAjHZK/BpW+E/A3pneJT/pcbbXwxFPbRG4t0jH12xwrElFNUMPDK1X86holUavMlFbnD8FAXNnPDNw0VkTBfJG+xhOGxDheyQk1fwfgy9mNb11UrMfYahyNFwwI1wVHYDfUwNCClc1zo4s3DDFZDhO1WQ2xtcXbjZHNw/zcP8HxRnLTtdQHIX5qL0H8E7TVkzIjyC+FqJlnFy+18Ewc3U+dBs0wMYwnOUlQbLZkq+kNwCo8xbc5dWdWvRVFYchIpOfapYtDSC2F4zcaj96n3x04KX4FXYvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1H08zRtaLwGM3T93c1JJAmh23JSUBxtKnRYbSYfUHg=;
 b=aIs3hgBbx0Jr0/8g8647WJTmx8BioX4lVrCpPahf4ZvSlslRbUNQP9tpE1YXm50hdfvjVrEzJVyqK56LpvpDZpUk3xnJ4S6+7dSItaNbVJhvhgs+wWj0xxKPIOKZrYF4QlYeVX+mlpodsgLN9wUx623oixfsm+6JJxtnLiIJIsg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4130.namprd13.prod.outlook.com (2603:10b6:5:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 17:03:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 17:03:45 +0000
Date:   Wed, 19 Apr 2023 19:03:37 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Ding Hui <dinghui@sangfor.com.cn>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        keescook@chromium.org, grzegorzx.szczurek@intel.com,
        mateusz.palczewski@intel.com, mitch.a.williams@intel.com,
        gregory.v.rose@intel.com, jeffrey.t.kirsher@intel.com,
        michal.kubiak@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
Subject: Re: [PATCH net v2 2/2] iavf: Fix out-of-bounds when setting channels
 on remove
Message-ID: <ZEAe6b3QVAhGc/Qm@corigine.com>
References: <20230419150709.24810-1-dinghui@sangfor.com.cn>
 <20230419150709.24810-3-dinghui@sangfor.com.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419150709.24810-3-dinghui@sangfor.com.cn>
X-ClientProxiedBy: AM4PR0101CA0046.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4130:EE_
X-MS-Office365-Filtering-Correlation-Id: a3d41e6c-233c-4d89-982c-08db40f80912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jKd72d/skLq0leWHnx/2dohxyz3MbcBteUSsJ2UU8zH4rqSl0tT81grS1O0DlrbOtytU2BFeu2vPtkheJZ1NOmrmWBgEFfKUhknBeJelsYTfHXQQ0SyRVQGSzbz510RaUbaxYcIzJ62SCaBy+8pnikzYH/v4IHqMdQPAYyH5E859vZVr3be5aPFlfbMotQdhn6jK64wSYbcYPYjufw+tU2O5601I9Pmzb3+S2Hn8Mnbd3TvuUHN5e86u6gogeeh6uHPDBm8u74fzYUTdkjm9zYFy06bt6tbFV5LsRYo1IVu2lwKbBm4hGss3RfHnWlY7nKIKBHfSEcYXtYbKoD2ar/E6fnStBrrH2BDh9MxuvYFi3qfOhGTZhIhXkFEF5HWDXc3ASYc+3+rQsbKj6405ufryQbN5nKgeH3LoqpBSvC6eTIX2aJ0sTYAs9m7gpf2QgQg965IlMPBW1IWQBYJCEfSf/ts91nZ3amJx3H2kl/6AU/4naxaoeIPNYafWb7NFMj0qaBYgj/Ff38gA9qKPZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(136003)(346002)(39840400004)(451199021)(84970400001)(186003)(6506007)(6512007)(6666004)(6486002)(86362001)(83380400001)(36756003)(4326008)(316002)(5660300002)(41300700001)(7416002)(66946007)(8676002)(8936002)(6916009)(66476007)(66556008)(2906002)(2616005)(38100700002)(44832011)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WZAWuGizuB0qB8a1WGlwW2/a1aeM3xIAhJNIhvM8kbqj0o0S41I2mYCAs8la?=
 =?us-ascii?Q?1M/pogMhfAIXByHbuXpMrZpXjbblG7O7EjqE24fH5Dbzr2kCMcQNVTYlT5CJ?=
 =?us-ascii?Q?QHFYigZzijyebbG+GdXYT7AWRjALf7ATfT7Fl5W1yZzeb1PL4JHU2qE+J5RS?=
 =?us-ascii?Q?O4x57PDNYqGQfry3nFdPrRzk6uYgxrGftzhL0F8//nReHg1jKIeVwimxG9VN?=
 =?us-ascii?Q?TM745h+0FkIajzwiV2c8Ic7/mj/YNYEUoDbLvPvWiVrf1bcnoxpjtBFrhO6Y?=
 =?us-ascii?Q?yIJg57TmbpzOoaavCMttf3RFXH/PvCzJTCdRatL8ZJgU/pRo59Wy6UGe6y7k?=
 =?us-ascii?Q?knYEpVWYpPSCgU4s/cxVqYGbOqDueMVzdNPP4TWvhcuF1we2o01e0Bocv6n1?=
 =?us-ascii?Q?brur/pKjWJYIlCPL7C3oRi4Ep1GZJsaGwTpqVCdIqFxInW9d2CJSKUtuioGv?=
 =?us-ascii?Q?8BRrXk62gFbt0SOc20GlFvq6CPo4JyLE8pKEzXpTs8VjVp9ilRJalZ/1qvxU?=
 =?us-ascii?Q?tUU0AaPOLBiSr0tLtVFDRSTntu5TOo458rKSczAx34e+AShaIri5V9kTAO5U?=
 =?us-ascii?Q?4lPx0RJSoci4EJMD2Ap8BQDP40Ac5gFdv4U5AXvJw0lA++oXACYt2cTkaXAp?=
 =?us-ascii?Q?xh9jXX+KMZqNGuLK/QbV2/YqTtv2Ut1E4P1vFu/xVRfkf5CqRMHSdWc6wxBN?=
 =?us-ascii?Q?RtRHVFWyIvGjyhzAYAC329GHDQzyjG60HP3TwRYrmQPWPZHr1t2x76pqWmFj?=
 =?us-ascii?Q?tpuFJfYDc/G/HQBSIc9gJqSsoF8KjJV12fLU7HkuGxUGejRnzsR4EtDkLH3P?=
 =?us-ascii?Q?A/CtlvlL9p3DymLsA/Yorklo77QOtPFoaWGK9s3KnLNJo2hARK1e4V0cdUt6?=
 =?us-ascii?Q?BVk14B7CoFk/yeT1C7DE1TKkbHaAKU39WV88sBsS2OoL5mg7sXrJji0nmt7G?=
 =?us-ascii?Q?6y/xHQOSJ+hkRpn1Gkb9rL8so1NVJ9RnWflJ3LTtsZ4ahsMOt+a7poMAiwct?=
 =?us-ascii?Q?TMruux1l++RcfyzbV76JoW1s9oAsX4LyVZjBOcfEiRIWVkZKDT4LW6gpjfAn?=
 =?us-ascii?Q?smjI89cmQiEWfyHCUoun4zMG2g/lUh9iFMU0qPO7btfRaoZJMu0xihBknLqa?=
 =?us-ascii?Q?oRwZpmnlNLuVOKinCxsvaeE15dL1NpSgPVZfm6V/VF7VfexIkkpRtcXsNIQ7?=
 =?us-ascii?Q?7JidxDsIRZdkuZsO0noikXp8Da40ERjZD1HDHbYdCG9V/iSa+hYP8XpwcZOz?=
 =?us-ascii?Q?dHqBz4EitxnRIEKA7Z+vCTPx2CIbyc5wHZA+LH7jC9/730J7YLgGaVSpX4H6?=
 =?us-ascii?Q?0Xj3rXB6HhffMBo2uwlthYLcmTLwW+pMzuzB0sNM9BJM2+0TeARlDELnG00g?=
 =?us-ascii?Q?WLay9EQg9ababrGqcodDdXVGE07Bt/YCGWJwcKZ9Rlwhj0zG05ToOkBrWEwZ?=
 =?us-ascii?Q?EGs8HZ3lhJuP9uAOdcW8SmHMoKVES97eCYCv6QbGeFLlFxWbUy378maYbSd+?=
 =?us-ascii?Q?ogOZ3cF17IhwQ+HH+W1MlPR1Bp30yK+fy2HR7THKM+PEzclBjTmxoza41t1D?=
 =?us-ascii?Q?ON2LLsegGr7PBD9mQUKiq80ub5R+ZyK3mT+37rx1YBujRA+0/M2ossPq5uLy?=
 =?us-ascii?Q?QH22ClOqFcReab5Z9Wc0f0X0gffm649tb7Q+CaqDT2y3Y/DUaNJ0oyB3ej/H?=
 =?us-ascii?Q?fSgIrg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d41e6c-233c-4d89-982c-08db40f80912
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 17:03:45.5737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /GpaFrclxTsH+6kNlcO0itUa2RsIBjUCu/MWQmStYVV46JFzWSwhWtjzPs2i5P0z8gDpf/eQHIxOC8ryIQZ4kcozRRJD0M7+NNJNKU+rY48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4130
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 11:07:09PM +0800, Ding Hui wrote:
> If we set channels greater when iavf_remove, the waiting reset done
> will be timeout, then returned with error but changed num_active_queues
> directly, that will lead to OOB like the following logs. Because the
> num_active_queues is greater than tx/rx_rings[] allocated actually.
> 
> Reproducer:
> 
>   [root@host ~]# cat repro.sh
>   #!/bin/bash
> 
>   pf_dbsf="0000:41:00.0"
>   vf0_dbsf="0000:41:02.0"
>   g_pids=()
> 
>   function do_set_numvf()
>   {
>       echo 2 >/sys/bus/pci/devices/${pf_dbsf}/sriov_numvfs
>       sleep $((RANDOM%3+1))
>       echo 0 >/sys/bus/pci/devices/${pf_dbsf}/sriov_numvfs
>       sleep $((RANDOM%3+1))
>   }
> 
>   function do_set_channel()
>   {
>       local nic=$(ls -1 --indicator-style=none /sys/bus/pci/devices/${vf0_dbsf}/net/)
>       [ -z "$nic" ] && { sleep $((RANDOM%3)) ; return 1; }
>       ifconfig $nic 192.168.18.5 netmask 255.255.255.0
>       ifconfig $nic up
>       ethtool -L $nic combined 1
>       ethtool -L $nic combined 4
>       sleep $((RANDOM%3))
>   }
> 
>   function on_exit()
>   {
>       local pid
>       for pid in "${g_pids[@]}"; do
>           kill -0 "$pid" &>/dev/null && kill "$pid" &>/dev/null
>       done
>       g_pids=()
>   }
> 
>   trap "on_exit; exit" EXIT
> 
>   while :; do do_set_numvf ; done &
>   g_pids+=($!)
>   while :; do do_set_channel ; done &
>   g_pids+=($!)
> 
>   wait
> 
> Result:
> 
> [ 3506.152887] iavf 0000:41:02.0: Removing device
> [ 3510.400799] ==================================================================
> [ 3510.400820] BUG: KASAN: slab-out-of-bounds in iavf_free_all_tx_resources+0x156/0x160 [iavf]
> [ 3510.400823] Read of size 8 at addr ffff88b6f9311008 by task repro.sh/55536
> [ 3510.400823]
> [ 3510.400830] CPU: 101 PID: 55536 Comm: repro.sh Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
> [ 3510.400832] Hardware name: Powerleader PR2008AL/H12DSi-N6, BIOS 2.0 04/09/2021
> [ 3510.400835] Call Trace:
> [ 3510.400851]  dump_stack+0x71/0xab
> [ 3510.400860]  print_address_description+0x6b/0x290
> [ 3510.400865]  ? iavf_free_all_tx_resources+0x156/0x160 [iavf]
> [ 3510.400868]  kasan_report+0x14a/0x2b0
> [ 3510.400873]  iavf_free_all_tx_resources+0x156/0x160 [iavf]
> [ 3510.400880]  iavf_remove+0x2b6/0xc70 [iavf]
> [ 3510.400884]  ? iavf_free_all_rx_resources+0x160/0x160 [iavf]
> [ 3510.400891]  ? wait_woken+0x1d0/0x1d0
> [ 3510.400895]  ? notifier_call_chain+0xc1/0x130
> [ 3510.400903]  pci_device_remove+0xa8/0x1f0
> [ 3510.400910]  device_release_driver_internal+0x1c6/0x460
> [ 3510.400916]  pci_stop_bus_device+0x101/0x150
> [ 3510.400919]  pci_stop_and_remove_bus_device+0xe/0x20
> [ 3510.400924]  pci_iov_remove_virtfn+0x187/0x420
> [ 3510.400927]  ? pci_iov_add_virtfn+0xe10/0xe10
> [ 3510.400929]  ? pci_get_subsys+0x90/0x90
> [ 3510.400932]  sriov_disable+0xed/0x3e0
> [ 3510.400936]  ? bus_find_device+0x12d/0x1a0
> [ 3510.400953]  i40e_free_vfs+0x754/0x1210 [i40e]
> [ 3510.400966]  ? i40e_reset_all_vfs+0x880/0x880 [i40e]
> [ 3510.400968]  ? pci_get_device+0x7c/0x90
> [ 3510.400970]  ? pci_get_subsys+0x90/0x90
> [ 3510.400982]  ? pci_vfs_assigned.part.7+0x144/0x210
> [ 3510.400987]  ? __mutex_lock_slowpath+0x10/0x10
> [ 3510.400996]  i40e_pci_sriov_configure+0x1fa/0x2e0 [i40e]
> [ 3510.401001]  sriov_numvfs_store+0x214/0x290
> [ 3510.401005]  ? sriov_totalvfs_show+0x30/0x30
> [ 3510.401007]  ? __mutex_lock_slowpath+0x10/0x10
> [ 3510.401011]  ? __check_object_size+0x15a/0x350
> [ 3510.401018]  kernfs_fop_write+0x280/0x3f0
> [ 3510.401022]  vfs_write+0x145/0x440
> [ 3510.401025]  ksys_write+0xab/0x160
> [ 3510.401028]  ? __ia32_sys_read+0xb0/0xb0
> [ 3510.401031]  ? fput_many+0x1a/0x120
> [ 3510.401032]  ? filp_close+0xf0/0x130
> [ 3510.401038]  do_syscall_64+0xa0/0x370
> [ 3510.401041]  ? page_fault+0x8/0x30
> [ 3510.401043]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> [ 3510.401073] RIP: 0033:0x7f3a9bb842c0
> [ 3510.401079] Code: 73 01 c3 48 8b 0d d8 cb 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 24 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 fe dd 01 00 48 89 04 24
> [ 3510.401080] RSP: 002b:00007ffc05f1fe18 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> [ 3510.401083] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f3a9bb842c0
> [ 3510.401085] RDX: 0000000000000002 RSI: 0000000002327408 RDI: 0000000000000001
> [ 3510.401086] RBP: 0000000002327408 R08: 00007f3a9be53780 R09: 00007f3a9c8a4700
> [ 3510.401086] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
> [ 3510.401087] R13: 0000000000000001 R14: 00007f3a9be52620 R15: 0000000000000001
> [ 3510.401090]
> [ 3510.401093] Allocated by task 76795:
> [ 3510.401098]  kasan_kmalloc+0xa6/0xd0
> [ 3510.401099]  __kmalloc+0xfb/0x200
> [ 3510.401104]  iavf_init_interrupt_scheme+0x26f/0x1310 [iavf]
> [ 3510.401108]  iavf_watchdog_task+0x1d58/0x4050 [iavf]
> [ 3510.401114]  process_one_work+0x56a/0x11f0
> [ 3510.401115]  worker_thread+0x8f/0xf40
> [ 3510.401117]  kthread+0x2a0/0x390
> [ 3510.401119]  ret_from_fork+0x1f/0x40
> [ 3510.401122]  0xffffffffffffffff
> [ 3510.401123]
> 
> If we detected removing is in processing, we can avoid unnecessary
> waiting and return error faster.
> 
> On the other hand in timeout handling, we should keep the original
> num_active_queues and reset num_req_queues to 0.
> 
> Fixes: 4e5e6b5d9d13 ("iavf: Fix return of set the new channel count")
> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
> Cc: Huang Cun <huangcun@sangfor.com.cn>
> Acked-by: Michal Kubiak <michal.kubiak@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

