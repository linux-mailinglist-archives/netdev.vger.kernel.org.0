Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1755A6CB5A1
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbjC1Ex1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 00:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjC1ExP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:53:15 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020027.outbound.protection.outlook.com [52.101.61.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A8F211F;
        Mon, 27 Mar 2023 21:53:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRdlk7vL2GqwyYg0UqsB6OSy3DfzCcZP7vcJUH5xtr0grTt7Y2n/lPLD/+6SLfcbXJ4pn30KXE3MCc102YKztcffZ3Ptx3iUgrjbn5pGY5tq5E0F048lVho6qTVVPpG8O//e7HZS1Dwx0badxSg8dc9EsaPnNme0IkPx9lEx6RtCFY3G+0YeODwczejc6On3b9mZYEsvXR23d9MYXjNz9Q8BCyHt1iBvoizrbvBzzdguuBr+/FO5/voloGVyFrYu0vP4GRGE3sBPBI1WkfHveiwGqMW7LF5jgpzmZn6zjycubJYsNXY7oozB5AghGL9WYdEThs14ATSHVl4nR65RLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KOudYeSTU9X8aDDWViWGpouAGH7mV9k9HxlIre+s3M8=;
 b=lPq/Us4lsGRTwUosqY8+T07KC2e/dQMTP07PBgf7tU6Za/00vmKO7GBducofuUvAQTdVSSX/cuoxEHm/DnIRa+YZUrFV9eKAiJPoAMM1U5PdJsWYwcQ5VycTAn7VSQOWk5VKT/UnbXVazsA38JmA7K8R/nkT0M67XK0fEVgBOQ5OG0fk4W9msdJz1nJx8q44If8Roq2ZQMEmMHfcj5xjJVtgykZerfQQoNMpB0tZdBesS6YXI0T7XRaXRG1Dep7aifEw2GSSc6wv6YtlDWTkdq8Ycm9BxIdCAW7YD3KDH4pbljqHp6LHle7lqV1ay45lUrVIRgyF/snGVDGY8uaSlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOudYeSTU9X8aDDWViWGpouAGH7mV9k9HxlIre+s3M8=;
 b=iKgRQvciWYPwtC6cjMTaIznLo5lZei79MWxPQ9ye1qwncVguqouk+gny7b2B4yzYVT9uxUFCBvVszvjYBy7oiIptY9URde9v6jLnYCafxbWjkP2hWjPnpnHKYj1DVRtgsRv7LAA4yQL4fwtLswEyA66XQ/T20JtAb6sDXnEgUrE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by IA1PR21MB3402.namprd21.prod.outlook.com
 (2603:10b6:208:3e1::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.6; Tue, 28 Mar
 2023 04:53:09 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7%6]) with mapi id 15.20.6277.005; Tue, 28 Mar 2023
 04:53:08 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     bhelgaas@google.com, davem@davemloft.net, decui@microsoft.com,
        edumazet@google.com, haiyangz@microsoft.com, jakeo@microsoft.com,
        kuba@kernel.org, kw@linux.com, kys@microsoft.com, leon@kernel.org,
        linux-pci@vger.kernel.org, lpieralisi@kernel.org,
        mikelley@microsoft.com, pabeni@redhat.com, robh@kernel.org,
        saeedm@nvidia.com, wei.liu@kernel.org, longli@microsoft.com,
        boqun.feng@gmail.com
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/6] PCI: hv: Fix a race condition in hv_irq_unmask() that can cause panic
Date:   Mon, 27 Mar 2023 21:51:18 -0700
Message-Id: <20230328045122.25850-3-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230328045122.25850-1-decui@microsoft.com>
References: <20230328045122.25850-1-decui@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:303:8f::18) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|IA1PR21MB3402:EE_
X-MS-Office365-Filtering-Correlation-Id: b948b4d7-4c48-43bc-ddba-08db2f48537c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +uuPSCWKWZvZBs6o5y31xkxg9obPMtuSfgRzDmWchpDRy3xPGwpJRx+Am99/xX/s22+6+/hsXHkMIQwXmMS0XqedJcLXxGRDHNffEDyeTZZjY5ruNFbj92vu5QKbJC8iKV3KB+Ed6D3WTPQVNipY4sUkiR9a2ZMYMU8UcQttRajeXg0B0nRzmP7zdcPN2aoVqZgTU9RhOfxP/5ukSJvyuu51TIGxiJYHVEYizYcTd5dOAXQ+ArfpyV+ePCwMwQx0EtGm8UWRuoEyYNLPMcC3K2V41Rq/nThAgI1TC2/M88vHd+XvY/GcAFMv4URhwDXcHyI7Q5AqhJkqzWGivlYwIjU6w9llnZ/g08RkkCfgHiFfKWxOLePBQkHKXnK94IrKbJCTRZRFp4DiY4tjGQc/cWdCjHZv0U9TaheE51oIbojixDyeyNkLaBPdoeyzb5ZoppFouy2ecevae4LxzB2zMwcFZX6Fq1ckM+nl380EoGUiworuzY0g8h1DXL3FaXLekOTDJw/m1WdWAOGZYAE1L13D+3WIK25EdxrPrnLifc1ZwP4liEFpvnLcubxuFqmBFKZUFobKJEmyj4uFDua8OxOVz91tzk0NrB3ExsQH7rRaqIbKGI0Po8mxyi8y8+AYVln9zYriBJYVZzwdPJhHHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199021)(478600001)(83380400001)(10290500003)(2906002)(1076003)(38100700002)(66899021)(52116002)(7416002)(6486002)(6506007)(6512007)(921005)(2616005)(5660300002)(8936002)(6666004)(316002)(86362001)(82960400001)(82950400001)(186003)(41300700001)(66556008)(66476007)(4326008)(66946007)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N2lOZCDTEWfOfv/VwV60CQETWH9qbGgVFb0cipBELH6+tNKALnFn3ggfOFGd?=
 =?us-ascii?Q?nB761ovuJgxwiotU5sBUXDBcaunLbiNW3Q2XOCJTsHkiFueK+J803dytV4qR?=
 =?us-ascii?Q?+Ooi4f62H6/lh70wpVdJm9TjDqEy/6aNeMzcWnh9KE2gDGL7LwX15CMyJ87I?=
 =?us-ascii?Q?I1P22VHM9p3g0xVB57ER7wzHRZ4c6/W0TmKQU/lVtqMV1Tt2VEj63s9cuitU?=
 =?us-ascii?Q?1yIxVkpOT4tV2YEcPE5LDHQ8zBRsOtBeb7JAl9noKtRCmgKe4GY9DA7A8WlT?=
 =?us-ascii?Q?m9ZWiY19Pv5pdObIOwsGMrFymYhS5W8RhlN65wlvPW/3efe076aE+fkpIju8?=
 =?us-ascii?Q?So9A+uoe5oJh5HwRBvJA+YyN87AX4pK7rM3lL2e2e94NLFg9oEN4jlQoxzFu?=
 =?us-ascii?Q?GuoREd6TIUHMlmITlzCUjxADkeIy4XpX7r0yvnL7oAhkWkIABxKhd5S8ozOa?=
 =?us-ascii?Q?JoBxMWMu7Vf64FeDrrHDBUS2+mFi8z2zdvFjs6+hO/BjvEJiP8tjCjxfTfuB?=
 =?us-ascii?Q?gWgxwGq3oANTRsi5mMn8EkEuSN8a77CSM1KhaYNlJe0fMptKGwUkCQXV2WGK?=
 =?us-ascii?Q?qtLsfn0GC7IgJlmRT1n9LbvfphEPqDm37vANxYof8oJvqlhHCX/snKXNyt9p?=
 =?us-ascii?Q?gM1JPom0hru3neZ5Adpr5zjG6RYbSK6mzYjAe0YeHw9futaLf8Pe/ElUF5xM?=
 =?us-ascii?Q?iiCYvSXGvPm3CTH1KGUcSOnImXMYt72FngBLP27CF8yWoWuUHAPaHrF4TrBZ?=
 =?us-ascii?Q?xZFGU8Bzd1NfMgfEF6xp72rRSelMCB9gs0dgT2xrGUKp0CXE+HXE7AirJkMR?=
 =?us-ascii?Q?Ne+EhJhTFz+PJzJ9lsu9YhNMnTHGdc0/DSrR8ehv+AxI2qclZuovFFZTiQ13?=
 =?us-ascii?Q?DYvhIFb85DxLYTqhwYVjtYcZWbveM4klSucpReVZDN+xd/tbjea4dyClHtEn?=
 =?us-ascii?Q?rEDxIVJISDzimXkRxK5LsGEUs0wHl7qgQg6KI9SFJGVeRtnNc2CFgqNMR/1J?=
 =?us-ascii?Q?MeLxuxUS1WWoHjxPLKiVrQcGRYUITZcH/cDw+5y11lbd3Kr4mtN/smVesm+6?=
 =?us-ascii?Q?Asi2bjLkKYvaYXwVMCQTrz/dq30YQuziccef4IQ6qqkrVmnw+9fl0UASC+Al?=
 =?us-ascii?Q?0KhrDX5DDWgXrToPO3ft77VRabz7GOt+bvpF1TRDjZMZWxin177p/I4VMQ0I?=
 =?us-ascii?Q?Sp2JsvnBeNvX3xCN73aJjRw3hdlGAgS5Z0byYFwKesLijkadFFj7lMM2rjh0?=
 =?us-ascii?Q?Um/4W+ucTHDpC6sZRC46+chqJe2rLTPMHWcalCsHr1iZh335bPZaPBe73Lxn?=
 =?us-ascii?Q?48MrnmKHeciFtbNvrgJzvYde8xTAPid/vXLqxLA7n1WzAYZHPPj/JHXioAG4?=
 =?us-ascii?Q?KOqBDcn2TDYuDpLy8jokl3WdkSNMPZ2Gdmp3r8IDoQxMnz4au6Nqm1S1t4vW?=
 =?us-ascii?Q?JfmkunXMQ6ZJzrq0/lsExwHoo4F1vEFRH+rdhYvca2Wl6PpVwGSNp54Ud7M8?=
 =?us-ascii?Q?jqWSkgZ6g6RJqGfEzwyOOHuwiroCh8GBi7R+mlWrrJbNpruuJjyKSZviv20g?=
 =?us-ascii?Q?82OC8TOFOogF6fUEkU7npOz60xJfrvR3vjT+P8c0Gwz7BDK+PG8pVriuO8aB?=
 =?us-ascii?Q?t3DYV+Kr9Vfp9rqHnAGZVrzkKFztLOxc9TCZEYiVo7iD?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b948b4d7-4c48-43bc-ddba-08db2f48537c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 04:53:08.9043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3uu3Tk0EUxPtVBHfFFxfZRTtZ4Jm0/BqKlQjBmRdfMpVJIGvkSYCcSG6khdy1ACU9XjMRCSS3oxwjKZpmRJqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3402
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the host tries to remove a PCI device, the host first sends a
PCI_EJECT message to the guest, and the guest is supposed to gracefully
remove the PCI device and send a PCI_EJECTION_COMPLETE message to the host;
the host then sends a VMBus message CHANNELMSG_RESCIND_CHANNELOFFER to
the guest (when the guest receives this message, the device is already
unassigned from the guest) and the guest can do some final cleanup work;
if the guest fails to respond to the PCI_EJECT message within one minute,
the host sends the VMBus message CHANNELMSG_RESCIND_CHANNELOFFER and
removes the PCI device forcibly.

In the case of fast device addition/removal, it's possible that the PCI
device driver is still configuring MSI-X interrupts when the guest receives
the PCI_EJECT message; the channel callback calls hv_pci_eject_device(),
which sets hpdev->state to hv_pcichild_ejecting, and schedules a work
hv_eject_device_work(); if the PCI device driver is calling
pci_alloc_irq_vectors() -> ... -> hv_compose_msi_msg(), we can break the
while loop in hv_compose_msi_msg() due to the updated hpdev->state, and
leave data->chip_data with its default value of NULL; later, when the PCI
device driver calls request_irq() -> ... -> hv_irq_unmask(), the guest
crashes in hv_arch_irq_unmask() due to data->chip_data being NULL.

Fix the issue by not testing hpdev->state in the while loop: when the
guest receives PCI_EJECT, the device is still assigned to the guest, and
the guest has one minute to finish the device removal gracefully. We don't
really need to (and we should not) test hpdev->state in the loop.

Fixes: de0aa7b2f97d ("PCI: hv: Fix 2 hang issues in hv_compose_msi_msg()")
Signed-off-by: Dexuan Cui <decui@microsoft.com>

---
 drivers/pci/controller/pci-hyperv.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

With the below debug code:

@@ -643,6 +643,9 @@ static void hv_arch_irq_unmask(struct irq_data *data)
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
 	int_desc = data->chip_data;
+	if (!int_desc)
+		dev_warn(&hbus->hdev->device, "%s() can not unmask irq %u\n",
+			 __func__, data->irq);

 	spin_lock_irqsave(&hbus->retarget_msi_interrupt_lock, flags);

@@ -1865,6 +1868,11 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 		goto free_int_desc;
 	}

+	printk("%s: line %d: irq=%u\n", __func__, __LINE__, data->irq);
+	{
+		static bool delayed; //remove the device within the 10s.
+		if (!delayed) { delayed = true; mdelay(10000); }
+	}
 	ret = vmbus_sendpacket_getid(hpdev->hbus->hdev->channel, &ctxt.int_pkts,
 				     size, (unsigned long)&ctxt.pci_pkt,
 				     &trans_id, VM_PKT_DATA_INBAND,

I'm able to repro the below panic:

[   23.258674] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: PCI VMBus probing: Using version 0x10004
[   23.271313] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: PCI host bridge to bus 468b:00
[   23.274554] pci_bus 468b:00: root bus resource [mem 0xfe0000000-0xfe00fffff window]
[   23.277733] pci_bus 468b:00: No busn resource found for root bus, will use [bus 00-ff]
[   23.283845] pci 468b:00:02.0: [15b3:1016] type 00 class 0x020000
[   23.289796] pci 468b:00:02.0: reg 0x10: [mem 0xfe0000000-0xfe00fffff 64bit pref]
[   23.296463] pci 468b:00:02.0: enabling Extended Tags
...
[   23.331300] pci_bus 468b:00: busn_res: [bus 00-ff] end is updated to 00
[   23.334130] pci 468b:00:02.0: BAR 0: assigned [mem 0xfe0000000-0xfe00fffff 64bit pref]
[   23.507985] mlx5_core 468b:00:02.0: no default pinctrl state
[   23.510834] mlx5_core 468b:00:02.0: enabling device (0000 -> 0002)
[   23.516843] mlx5_core 468b:00:02.0: firmware version: 14.25.8102
[   23.745069] hv_compose_msi_msg: line 1871: irq=24
[   33.685554] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: the device is being ejected
[   33.690855] hv_compose_msi_msg: line 1871: irq=25
[   33.694797] hv_compose_msi_msg: line 1871: irq=26
[   33.698884] hv_compose_msi_msg: line 1871: irq=27
[   33.702910] hv_compose_msi_msg: line 1871: irq=28
[   33.705726] hv_compose_msi_msg: line 1871: irq=29
[   33.709644] hv_compose_msi_msg: line 1871: irq=29
[   33.712182] hv_pci b92a0085-468b-407a-a88a-d33fac8edc75: hv_arch_irq_unmask() can not unmask irq 29
[   33.716625] BUG: kernel NULL pointer dereference, address: 0000000000000008
...
[   33.737426] Workqueue: events work_for_cpu_fn
[   33.739562] RIP: 0010:hv_irq_unmask+0xc2/0x400 [pci_hyperv]
...
[   33.778511] Call Trace:
[   33.779533]  <TASK>
[   33.780428]  unmask_irq.part.0+0x23/0x40
[   33.781994]  irq_enable+0x60/0x70
[   33.783336]  __irq_startup+0x5b/0x80
[   33.784772]  irq_startup+0x75/0x140
[   33.786175]  __setup_irq+0x3ae/0x840
[   33.787586]  request_threaded_irq+0x112/0x180
[   33.789298]  mlx5_irq_alloc+0x111/0x310 [mlx5_core]
[   33.791464]  irq_pool_request_vector+0x72/0x80 [mlx5_core]
[   33.794449]  mlx5_ctrl_irq_request+0xc9/0x160 [mlx5_core]
[   33.797454]  mlx5_eq_table_create+0x9e/0xb30 [mlx5_core]
[   33.802127]  mlx5_load+0x54/0x3b0 [mlx5_core]
[   33.804157]  mlx5_init_one+0x1e6/0x550 [mlx5_core]
[   33.806347]  probe_one+0x2e5/0x460 [mlx5_core]
[   33.808664]  local_pci_probe+0x4b/0xb0
[   33.810377]  work_for_cpu_fn+0x1a/0x30
[   33.812275]  process_one_work+0x21f/0x430
[   33.814700]  worker_thread+0x1fa/0x3c0

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index b82c7cde19e6..1b11cf739193 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -643,6 +643,11 @@ static void hv_arch_irq_unmask(struct irq_data *data)
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
 	int_desc = data->chip_data;
+	if (!int_desc) {
+		dev_warn(&hbus->hdev->device, "%s() can not unmask irq %u\n",
+			 __func__, data->irq);
+		return;
+	}
 
 	spin_lock_irqsave(&hbus->retarget_msi_interrupt_lock, flags);
 
@@ -1911,12 +1916,6 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 		hv_pci_onchannelcallback(hbus);
 		spin_unlock_irqrestore(&channel->sched_lock, flags);
 
-		if (hpdev->state == hv_pcichild_ejecting) {
-			dev_err_once(&hbus->hdev->device,
-				     "the device is being ejected\n");
-			goto enable_tasklet;
-		}
-
 		udelay(100);
 	}
 
-- 
2.25.1

