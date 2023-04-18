Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4F36E6D21
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 21:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbjDRTwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 15:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbjDRTwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 15:52:23 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2092.outbound.protection.outlook.com [40.107.244.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7529F975D;
        Tue, 18 Apr 2023 12:52:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l21boauLGCKtvMRcANsk9/Z8cc+3ni9KTeNnXymwK20rU4D2n8o3frJC5C/6YvVWrD2BinYDsusJdhOCL62YAxao7Fc/nKUD2gaJoLJ0jC72G9lFcu0K62cwYk3w8qz24SaT1RgZbHiR0UTcPzGuOZFi3Ve2mQPyNrb2pyYPpwd9MvMYSfV1XKFgEYpWH/kB4LAFQeMZvR0Y231um6PkNnMCW15En0Unf3ZuJNWxkinG2Ilwg4xSue+ivxtV7Qd/u1UZLfThfzK8E7tLCcC5FLw3qj8eTOI+SlsvwixnUEbwFEUKJ8hyYT6kBA+TawZzue7ho7xvRSYjrC3KXVdwbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FLtJBkNa6wxRjEd2K9NsM6l7pVUKVK/m7QeVIvR//9Y=;
 b=X8kxMAOJdDViDeGvxxcUGIAiHPaarPsDb8zUSsgJ5fPCXlgVtY+33qlHVx2XoMpWVSra2g+zUp8aXYvJI5rFC9aksJy7dtjSdfhlhKdKrD0CbmaCO0nUcp3mc2f66GRuEoud4hobGMPYcRx68VlG8abyS4tm/PByfu7mKSW+mXIYk3AT/jVy/wzsv7mb4TAW/JmpLEj3thx9Pg8hnYVn20D63WSMKmGzf5Oqr2l8Efo3Rvs9+GvzceTESHEDoz/2g98par/RBIc28AAuAyhHyDNroauGPyoEUQxyA629r9Uno+jTNqfMkSujJcXqw9rQNcgnbuYG+YaVtFl8fucxiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLtJBkNa6wxRjEd2K9NsM6l7pVUKVK/m7QeVIvR//9Y=;
 b=viAzPcmiJsI3d1QUMUlN65muV79MuM2XQKFLiguqVmEKuLSqnComPfuT2y/frdIE7ykljUUjmfRcjO00ESYFb4ZOLOk7gZMUWfECVczpDpeQ0Q4BRALGwHr6depx+BfdxBtGntNxAQhq8T0nzaGYddSsoyA3nHAghwpcVP20+J0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4483.namprd13.prod.outlook.com (2603:10b6:208:1ce::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 19:52:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 19:52:18 +0000
Date:   Tue, 18 Apr 2023 21:52:11 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Ding Hui <dinghui@sangfor.com.cn>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        keescook@chromium.org, grzegorzx.szczurek@intel.com,
        mateusz.palczewski@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
Subject: Re: [RESEND PATCH net 1/2] iavf: Fix use-after-free in free_netdev
Message-ID: <ZD706wjxpREz9no4@corigine.com>
References: <20230417074016.3920-1-dinghui@sangfor.com.cn>
 <20230417074016.3920-2-dinghui@sangfor.com.cn>
 <ZD70DKC3+K6gngTh@corigine.com>
 <ZD70cUCsxoN0BTNK@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD70cUCsxoN0BTNK@corigine.com>
X-ClientProxiedBy: AS4P191CA0030.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4483:EE_
X-MS-Office365-Filtering-Correlation-Id: f864cf9b-6378-49d7-48c3-08db40466a9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: slXWIdQ3irIN8MjgdByY4T81p7odIBMUaFWQ9AIcpbs4bEIxDoW2dVhjA0oVMFreJvczn4iRSokI+/F5B2zkYYDV5cFuyDBz+9jd1UgbYU61Jh9BHm4SmvZd8n1Hh4WoOQgWw8/0OCIS8FytnvZf/xvwyiDXtHBgcn2RcbkhrN6KBXSS5pKyBuBaH5QkP05J9P4vYIFOTicevWhgMs5+xg08ocD9pS2s1p+9dvAAcLqUMgKJFnS+HlnyWimH0l6mdf6Bc9cOJ+YlD6vMUl8DJPWLs9Grwi//ssHRn5jkFvX2/vQpeiVjsm0F7+KFJYEeuYzaFpWWIHb0kRO8TVTADYLpPVeDjY7biL5eQIlpeerKr/w8WpbFMsN/JPRC9jKbw7y2guLJRiMYrwkyBrdvB2YKg9dfgrglpt7lvqOsCcjU33ywu09Y8Oa3kngwTrXCG6lY4qrAr67IdAHxMEVXRXXk6x11aIvdCWRG5+e8dtvF8dcR57zotRDjA90lCyj3+YJmcQ5WtpLf1gIjwwvd6xyWPWQ+cL9YUz648qhv9jo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39830400003)(396003)(366004)(376002)(346002)(451199021)(44832011)(36756003)(7416002)(2906002)(5660300002)(8936002)(8676002)(41300700001)(86362001)(38100700002)(478600001)(2616005)(6506007)(6512007)(186003)(6666004)(6486002)(84970400001)(6916009)(4326008)(66476007)(66556008)(66946007)(83380400001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wxkmdlJN5uRXo2LKl8PUGg5xCX52bmZ1YNbW9+SGMhSfzTtg4we0wDPKOGun?=
 =?us-ascii?Q?J8YcJfdpNChosaO8G5PlSDUF6BrQ/GGHpDOXY8WHXH16TErgi6WjFgwIMECr?=
 =?us-ascii?Q?ikRaJlH8yNMVBEj2rnRmfFbPvHjgfHOy/send2kPxuQ04XpPVrTpB/GcdiZi?=
 =?us-ascii?Q?jc0Ooc67w+xpUotBunTinZ5qGlpIXMSPtePM8Ru+ENFIFQCfLKqw69lboHUB?=
 =?us-ascii?Q?vS8CmWl13ymX1mN4m977lRMhrPIZvECZFHuxqgTz3CallJKotIM4ndfMsKcY?=
 =?us-ascii?Q?eOMi7K9rlLp7DdCyjcDZphrmsf0eiMlMeHng1xoPifDYI8bxHTBMYQDs4mF6?=
 =?us-ascii?Q?aYPAA2sAM6DUbEFxYxctxM8QEfIAtU7gdzwkuJ4Ft2GTKjJue1XApZCrEJIw?=
 =?us-ascii?Q?1VTQLjML6nA4/EgAFffzRTtzHvTjojxOG9IzN3q3P2xF5fa+1acuHWD17J5N?=
 =?us-ascii?Q?rR8E/qDQdlCChxURqwgNGuT2+XDjpo9lPxn2mP34CVM+TANh3LXOIbvLbnwq?=
 =?us-ascii?Q?/7SsdQPnSz2WeTyQTct3C1xPmb8BMHrnG93yzffAzuCdf7ZLAB2Mi6TG1X4x?=
 =?us-ascii?Q?yOB/cmlU2AIQHpXYPLHhz/re0JblBzrvdlj7ac9pcUbMCt8xiqvXcw1//6fo?=
 =?us-ascii?Q?259iDFNaQJSBNVHTpxBmkFjonkKtP83lxEbEN049JtTiAVW2Gk8ZxkmLNCsS?=
 =?us-ascii?Q?2FYY6P6wHXCToCDLY080T1a2/lmNZ2cBYC1e3W6aH6cOWDmgbz/Str05152W?=
 =?us-ascii?Q?k4FpWPURFCqik90sbQwx4jxl3l7V0hAYtTu+s7wC4JVdmcUdEwrh7mfBIK7c?=
 =?us-ascii?Q?AhVwfdMfAZmxqTPD2MIJBBRAbt2+r6cN+AvwR0wjgcngXffp1shoGxShi5Dt?=
 =?us-ascii?Q?z14dKauc0Sdg1km2qXq91qg2s7RAhhuVoCZ6yIeqVYAgToWc3aMR80hj7u2e?=
 =?us-ascii?Q?I/UQDiwlECFjDVczZxQ+EuFNve5AUcyy0LcZXNez8sr1t+9UUm5MGlUm8WmZ?=
 =?us-ascii?Q?sKTQQQoYFU/rMHzo7s2bTSqnMhtq/vBGijcd4So8QSADhg3Y+o99xc+5Cwlx?=
 =?us-ascii?Q?coPkShlhI/3LiovQeWsSIFN83yWZmlByMh78rjRXAxmBrNMbkuW22rbnAX/i?=
 =?us-ascii?Q?1t+2fJ4sB6abBcr3T8eQm785aPu4clqgCn23hOgZlNmG0GTfpsQnkZ63lvdf?=
 =?us-ascii?Q?8VdNMSgtpjhbseqqr3jGvBNUgoBhrffLKQy+og40IT2jT9rY04/bfxHbVccz?=
 =?us-ascii?Q?ZvZIv0TYPxr+7V18JWbKDGVKDn62F6UP8aTmOE58gE0q8d3k7kQZKqjWMIpL?=
 =?us-ascii?Q?poacY5+MbJ8JjCRQQJmYcydidcr6A+TnMS95JMsHr0/mP3h4HXmMZ5yNs3lQ?=
 =?us-ascii?Q?+vMOB+yCzZP2TJ/pBkXCKM3jUaADBrrrXuXtA8tusxW7bRByxMM3EdUCCBJW?=
 =?us-ascii?Q?Pi8dmMdgtT1rAzABFrk4PBC1P7hRcFQ7k+iOePFY2lh+4uNkn9pYbz22LkFm?=
 =?us-ascii?Q?w7WgVKl8NSRzi+cEVGIjOdEcQEmwscYMaIxla5ptmXl/2EzxNNJCi0Bn48z9?=
 =?us-ascii?Q?7U4dx48RfbUXKdWg9eUdeslHw2k6j3JDPHKvUe5D2Q4ypysufC2jFjpulX7e?=
 =?us-ascii?Q?e9dFjLtlFkfFi1MRAFY2mpV0Rh/VAikZHhrjIvZaN0ijgrvXnVU3v3FNqvz8?=
 =?us-ascii?Q?4P2kbg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f864cf9b-6378-49d7-48c3-08db40466a9f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 19:52:18.5450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qMa5PZQ6aqSjSQtZsubIoMtu+N8uAqZi/jFxnAgJACVpD2LCrIENA2RDmC8RA3prZa/+uGMbSdZSmYifownKbO2c+0k9sgJHqMNO7iMs41k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4483
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 09:50:17PM +0200, Simon Horman wrote:
> On Tue, Apr 18, 2023 at 09:48:38PM +0200, Simon Horman wrote:
> > Hi Ding Hui,
> > 
> > On Mon, Apr 17, 2023 at 03:40:15PM +0800, Ding Hui wrote:
> > > We do netif_napi_add() for all allocated q_vectors[], but potentially
> > > do netif_napi_del() for part of them, then kfree q_vectors and lefted
> > 
> > nit: lefted -> leave
> > 
> > > invalid pointers at dev->napi_list.
> > > 
> > > If num_active_queues is changed to less than allocated q_vectors[] by
> > > unexpected, when iavf_remove, we might see UAF in free_netdev like this:
> > > 
> > > [ 4093.900222] ==================================================================
> > > [ 4093.900230] BUG: KASAN: use-after-free in free_netdev+0x308/0x390
> > > [ 4093.900232] Read of size 8 at addr ffff88b4dc145640 by task test-iavf-1.sh/6699
> > > [ 4093.900233]
> > > [ 4093.900236] CPU: 10 PID: 6699 Comm: test-iavf-1.sh Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
> > > [ 4093.900238] Hardware name: Powerleader PR2008AL/H12DSi-N6, BIOS 2.0 04/09/2021
> > > [ 4093.900239] Call Trace:
> > > [ 4093.900244]  dump_stack+0x71/0xab
> > > [ 4093.900249]  print_address_description+0x6b/0x290
> > > [ 4093.900251]  ? free_netdev+0x308/0x390
> > > [ 4093.900252]  kasan_report+0x14a/0x2b0
> > > [ 4093.900254]  free_netdev+0x308/0x390
> > > [ 4093.900261]  iavf_remove+0x825/0xd20 [iavf]
> > > [ 4093.900265]  pci_device_remove+0xa8/0x1f0
> > > [ 4093.900268]  device_release_driver_internal+0x1c6/0x460
> > > [ 4093.900271]  pci_stop_bus_device+0x101/0x150
> > > [ 4093.900273]  pci_stop_and_remove_bus_device+0xe/0x20
> > > [ 4093.900275]  pci_iov_remove_virtfn+0x187/0x420
> > > [ 4093.900277]  ? pci_iov_add_virtfn+0xe10/0xe10
> > > [ 4093.900278]  ? pci_get_subsys+0x90/0x90
> > > [ 4093.900280]  sriov_disable+0xed/0x3e0
> > > [ 4093.900282]  ? bus_find_device+0x12d/0x1a0
> > > [ 4093.900290]  i40e_free_vfs+0x754/0x1210 [i40e]
> > > [ 4093.900298]  ? i40e_reset_all_vfs+0x880/0x880 [i40e]
> > > [ 4093.900299]  ? pci_get_device+0x7c/0x90
> > > [ 4093.900300]  ? pci_get_subsys+0x90/0x90
> > > [ 4093.900306]  ? pci_vfs_assigned.part.7+0x144/0x210
> > > [ 4093.900309]  ? __mutex_lock_slowpath+0x10/0x10
> > > [ 4093.900315]  i40e_pci_sriov_configure+0x1fa/0x2e0 [i40e]
> > > [ 4093.900318]  sriov_numvfs_store+0x214/0x290
> > > [ 4093.900320]  ? sriov_totalvfs_show+0x30/0x30
> > > [ 4093.900321]  ? __mutex_lock_slowpath+0x10/0x10
> > > [ 4093.900323]  ? __check_object_size+0x15a/0x350
> > > [ 4093.900326]  kernfs_fop_write+0x280/0x3f0
> > > [ 4093.900329]  vfs_write+0x145/0x440
> > > [ 4093.900330]  ksys_write+0xab/0x160
> > > [ 4093.900332]  ? __ia32_sys_read+0xb0/0xb0
> > > [ 4093.900334]  ? fput_many+0x1a/0x120
> > > [ 4093.900335]  ? filp_close+0xf0/0x130
> > > [ 4093.900338]  do_syscall_64+0xa0/0x370
> > > [ 4093.900339]  ? page_fault+0x8/0x30
> > > [ 4093.900341]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> > > [ 4093.900357] RIP: 0033:0x7f16ad4d22c0
> > > [ 4093.900359] Code: 73 01 c3 48 8b 0d d8 cb 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 24 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 fe dd 01 00 48 89 04 24
> > > [ 4093.900360] RSP: 002b:00007ffd6491b7f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > > [ 4093.900362] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f16ad4d22c0
> > > [ 4093.900363] RDX: 0000000000000002 RSI: 0000000001a41408 RDI: 0000000000000001
> > > [ 4093.900364] RBP: 0000000001a41408 R08: 00007f16ad7a1780 R09: 00007f16ae1f2700
> > > [ 4093.900364] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
> > > [ 4093.900365] R13: 0000000000000001 R14: 00007f16ad7a0620 R15: 0000000000000001
> > > [ 4093.900367]
> > > [ 4093.900368] Allocated by task 820:
> > > [ 4093.900371]  kasan_kmalloc+0xa6/0xd0
> > > [ 4093.900373]  __kmalloc+0xfb/0x200
> > > [ 4093.900376]  iavf_init_interrupt_scheme+0x63b/0x1320 [iavf]
> > > [ 4093.900380]  iavf_watchdog_task+0x3d51/0x52c0 [iavf]
> > > [ 4093.900382]  process_one_work+0x56a/0x11f0
> > > [ 4093.900383]  worker_thread+0x8f/0xf40
> > > [ 4093.900384]  kthread+0x2a0/0x390
> > > [ 4093.900385]  ret_from_fork+0x1f/0x40
> > > [ 4093.900387]  0xffffffffffffffff
> > > [ 4093.900387]
> > > [ 4093.900388] Freed by task 6699:
> > > [ 4093.900390]  __kasan_slab_free+0x137/0x190
> > > [ 4093.900391]  kfree+0x8b/0x1b0
> > > [ 4093.900394]  iavf_free_q_vectors+0x11d/0x1a0 [iavf]
> > > [ 4093.900397]  iavf_remove+0x35a/0xd20 [iavf]
> > > [ 4093.900399]  pci_device_remove+0xa8/0x1f0
> > > [ 4093.900400]  device_release_driver_internal+0x1c6/0x460
> > > [ 4093.900401]  pci_stop_bus_device+0x101/0x150
> > > [ 4093.900402]  pci_stop_and_remove_bus_device+0xe/0x20
> > > [ 4093.900403]  pci_iov_remove_virtfn+0x187/0x420
> > > [ 4093.900404]  sriov_disable+0xed/0x3e0
> > > [ 4093.900409]  i40e_free_vfs+0x754/0x1210 [i40e]
> > > [ 4093.900415]  i40e_pci_sriov_configure+0x1fa/0x2e0 [i40e]
> > > [ 4093.900416]  sriov_numvfs_store+0x214/0x290
> > > [ 4093.900417]  kernfs_fop_write+0x280/0x3f0
> > > [ 4093.900418]  vfs_write+0x145/0x440
> > > [ 4093.900419]  ksys_write+0xab/0x160
> > > [ 4093.900420]  do_syscall_64+0xa0/0x370
> > > [ 4093.900421]  entry_SYSCALL_64_after_hwframe+0x65/0xca
> > > [ 4093.900422]  0xffffffffffffffff
> > > [ 4093.900422]
> > > [ 4093.900424] The buggy address belongs to the object at ffff88b4dc144200
> > >                 which belongs to the cache kmalloc-8k of size 8192
> > > [ 4093.900425] The buggy address is located 5184 bytes inside of
> > >                 8192-byte region [ffff88b4dc144200, ffff88b4dc146200)
> > > [ 4093.900425] The buggy address belongs to the page:
> > > [ 4093.900427] page:ffffea00d3705000 refcount:1 mapcount:0 mapping:ffff88bf04415c80 index:0x0 compound_mapcount: 0
> > > [ 4093.900430] flags: 0x10000000008100(slab|head)
> > > [ 4093.900433] raw: 0010000000008100 dead000000000100 dead000000000200 ffff88bf04415c80
> > > [ 4093.900434] raw: 0000000000000000 0000000000030003 00000001ffffffff 0000000000000000
> > > [ 4093.900434] page dumped because: kasan: bad access detected
> > > [ 4093.900435]
> > > [ 4093.900435] Memory state around the buggy address:
> > > [ 4093.900436]  ffff88b4dc145500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > [ 4093.900437]  ffff88b4dc145580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > [ 4093.900438] >ffff88b4dc145600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > [ 4093.900438]                                            ^
> > > [ 4093.900439]  ffff88b4dc145680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > [ 4093.900440]  ffff88b4dc145700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > > [ 4093.900440] ==================================================================
> > > 
> > > Fix it by letting netif_napi_del() match to netif_napi_add().
> > > 
> > > Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> > > Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
> > > CC: Huang Cun <huangcun@sangfor.com.cn>
> 
> Oops, the comment below was meant for
> - [RESEND PATCH net 1/2] iavf: Fix use-after-free in free_netdev

... and this is patch 1/2.
Sorry for (my own) confusion.

> > as this is a fix it probably should have a fixes tag.
> > I wonder if it should be:
> > 
> > Fixes: cc0529271f23 ("i40evf: don't use more queues than CPUs")
> > 
> > Code change looks good to me.
> > 
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
