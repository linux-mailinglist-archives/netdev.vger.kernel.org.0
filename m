Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8166D568B
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjDDCIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbjDDCH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:07:59 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020018.outbound.protection.outlook.com [52.101.61.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9832697;
        Mon,  3 Apr 2023 19:07:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3vOtvneztIcQNqSo5ywRnqvMCGGMI8vQDyfUMc63QsFNEfs24u6NE+ehBl5Pq5Z9foKN3duKebWogOMhokSec+eqtpjfvf7CWGeZugLvQNdyI1GjfjpD8TzfUETKmuYC6I1Y2DlAoUh/1uneIqmdF1exNgA0WmMt4Q1kuyAHSrGkyhWCPb+lI0DA3fsxqqz4TwQnt2lXNJtz1oVSz/OY+Fu0+0xKKgNDGWQSyZcqqcrOzCyeUL7U4w5KFQrPoibgqFU194ORcMog0pkv9glZRoitevXhWHAgYweDcvtO2Eg+b1ILm1fK/WyKlPVY3YeSqWBGk5qYPKeAOJ3ewMfbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDCPVlpBub9q/x5lZqg7h70+lhnavfvxkowfL2WMUR8=;
 b=MjMO2RyN2D1lah5oHivG3hFUvSM03ufLuqKubpA+PFMhECuJvhpnWs0rkvXzFevJNknUJZgQJMnqWfD26OgNQQPW9anKiOXmiRaeXPQ6ht2mRYwjfVJZeLw+5yRATDs2XUTCzSM1znxiOuQ4Thk2rC/P0lFeZx0SlrVf74kXSJlGFIuyu0PZVRjs3Er+gnQICmoy59My4ScNGROnVIBc8qShsNxSdj8GBCvG9YRCvySaZsS7dNSOQRE78NIat7GPX4Zz11KYyFfPxLjNHERPwm08ZwfBb2S2aBzg+FFib1GYjt0PuA4NXPWSdksGfK+ucLtOM2T1wf/98fXVjP9gRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDCPVlpBub9q/x5lZqg7h70+lhnavfvxkowfL2WMUR8=;
 b=PBWjRFjFJIZXPg2iG2LNqf2FjXzHjXbEC1k+OUJCpETNs/HCVPraxYTN3qz3l0eHt0Pye+Il3YSXdRyp7oijVx1ZNVZnY3p2KH8ns4aozV3x4t/Nd4AiFtI2W7lyIkgndMdkTJMGNsWanYG6eilePe5qD6fq8Yd22Tfnfmxy5KM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH8PR21MB3959.namprd21.prod.outlook.com
 (2603:10b6:510:23b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.11; Tue, 4 Apr
 2023 02:07:12 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7%6]) with mapi id 15.20.6298.010; Tue, 4 Apr 2023
 02:07:12 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     bhelgaas@google.com, davem@davemloft.net, decui@microsoft.com,
        edumazet@google.com, haiyangz@microsoft.com, jakeo@microsoft.com,
        kuba@kernel.org, kw@linux.com, kys@microsoft.com, leon@kernel.org,
        linux-pci@vger.kernel.org, lpieralisi@kernel.org,
        mikelley@microsoft.com, pabeni@redhat.com, robh@kernel.org,
        saeedm@nvidia.com, wei.liu@kernel.org, longli@microsoft.com,
        boqun.feng@gmail.com, ssengar@microsoft.com, helgaas@kernel.org
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2 6/6] PCI: hv: Use async probing to reduce boot time
Date:   Mon,  3 Apr 2023 19:05:45 -0700
Message-Id: <20230404020545.32359-7-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230404020545.32359-1-decui@microsoft.com>
References: <20230404020545.32359-1-decui@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0019.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::24) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|PH8PR21MB3959:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c926473-d701-4552-c891-08db34b14d8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vc4FiXZaK0usUYP9gESRaVpcpf/Nmf/fF4lpfzeizYeyGJeJmm6oFHefiu4w/7ilMfHqA2bnfN4PD4f+9XYAypcDmKHbuLTWPLkO7y4MwpnVU5fouc1lkYwf7OLy4GW9yCdWBnIMwCrDP0qa8dXcSoIgPuw4dBeBCmwi14s7mqAeK2pxrbbD2QVsFI5s0UGAbrKKMu9raS8l9fzMVUieICvyn8k0AxA6nDcEh3dgR/j7rqlU/9AxMUMMEMFTBghO8P8cPp4TVl05xmU5O4zP8p5DnTp0NoU0N6sGMjxu556WQvPR+J0N6oEPJuBbR9ffacBS8NvJDuwpkRMPTW16IrkhNGf4+lQcRC4eErQtKMOASQP/ldKpMa5smxVnDdNn+aBzjQSII+kC3olNSpPZOeqPtTZ/lIkWjn/V0dy9eBNfJLDvOecm3sHIT7prICbno6O5Troqe+96bABxu5jYoh3paaaVJB874aDaVirxGC0I0j1ySQW2hgHC4peoBfsHtyatOP2iuVpcPVfNPVdmWN2+2rgH7KqHoz9Axuvhr24v4WFy4gra6Hnt1JAuLdVyelkLTnPzCxiRzrEfpZnksB93isAExmoDTLpxzQotBpUDreBynXf0Of7kfrBBjQi0Jdw2I0l04lZyjivoX865MQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(6486002)(5660300002)(82950400001)(82960400001)(36756003)(478600001)(921005)(10290500003)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(86362001)(41300700001)(786003)(316002)(52116002)(8936002)(2616005)(186003)(6512007)(6506007)(1076003)(2906002)(6666004)(7416002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rVbyagShOq2tM/r7e5VeQBmI70EJ8mVhcMBy2quxg2J5NSGGkQinsEaJT9D+?=
 =?us-ascii?Q?fi6Iw8gWngDKk6hTFxSqUxItS25XWoPORiJVxTQPKGofF55sYU7JWn2fH3aT?=
 =?us-ascii?Q?WQbw5SJRVnrz6IcT7OBxX/7xZYCTtPU1E8gi55ketYn7GE2rbDqkWGTojoQc?=
 =?us-ascii?Q?SI2ma+8rrxGKlPmFyOLVKvhUOLqdCPYKvY+iRgalBJATP46NTkLyzDX+JIOS?=
 =?us-ascii?Q?nQAktrKkjHK4n0OA3ucMyUTahPJ3e3S8nW9DAG2jN/3BX+Qn5rsQA0hK9Pp4?=
 =?us-ascii?Q?uwaz/Y6k3vjGcWv7sSbhVzSv1pPsFKjPunfAfij9kx2zm1f+jLr1GBeQ6CBP?=
 =?us-ascii?Q?9OmHqtZzZ6veQ824O4+3oYlNtm8CmQySKUMlIJL90PzuU6JxsxsGL8tS8cKh?=
 =?us-ascii?Q?P2wVq47/oMWZDJLVo/ayyjQa2lT76kr5PYzKUiT58qsNnHqX/DnxKI0RbYe1?=
 =?us-ascii?Q?BB4fHhDa9JITbiT/aydrynXSlFrqR8rvJtce93hBAJ1mpspF5AtGHNHT+kgw?=
 =?us-ascii?Q?0O/nJUqiAbMGXIOaa+TtXOvxKwxlz8F1chp+2wb42s9xD/S/cN6NP4dfbuDT?=
 =?us-ascii?Q?VDVVCdmv/QICWXCo4ztkQcwLayyv571O3m0aNldMi+/MC7dPzQD7PoRUKXae?=
 =?us-ascii?Q?T4AMFR40d5MTqTaA7dK3k8zrBkdiMkbepWpkK6a+6MTWu7j1IN8ZZdsjCyXu?=
 =?us-ascii?Q?fzn1P9ybiEVpNK8Hr0yymFz9dH+wcn1YzLEziegpfLhqaeiXSjRRuL2FhImt?=
 =?us-ascii?Q?0MaAOXcw2ptZ/WanfhEuLC4/E9rBJcDd7flgpivyq8WvEIJ6j1OArekOLK9A?=
 =?us-ascii?Q?SO4mBtA4yUi08/He386PRKVxxGGSYv5AtZlJiFv9nNteVa5ggZOVi1xvHKtR?=
 =?us-ascii?Q?WFO27SyM5ocmQ+Qq335/eyF7vZbsnRqBqp0BfdLDJCCvtAC08hlM38xqycKU?=
 =?us-ascii?Q?2KyWe0x1U1LLEEBtBAbE17jBk+kDNb+Uxg4/4AjUmhWZrm5JopWZBerQ9V92?=
 =?us-ascii?Q?wcKpu33GSuI2/xl3E1V3PaFavD01vm11eaGidlFye7h5mvP8cztotJ+2BzjH?=
 =?us-ascii?Q?OGdOFB2QqXx3VYi0JizA/sSdZOmVzLhRm/wCL7eROOZ+s7QFDyMqZeqXPIOb?=
 =?us-ascii?Q?CVV/vMKPFMi0oNRu1bOoDaFkdFt+6gjbJTeKnB3oY8wyCx1SvH/GXEmNLhLe?=
 =?us-ascii?Q?mwFXDC2EH1PsT+tK1BFJ0ghVRAvlH1dLMZdlOoYqSrYgto2PDQjyYWCLO3JU?=
 =?us-ascii?Q?zD7s3XpE7u7ZeAnN5K90YLTpN3UJLTYbYU/grGBFVgwYI/ne9w+Ag8dFZMcj?=
 =?us-ascii?Q?I5+jfp06RMtseAy/dgZPaYi7M3pkbjiFptjkZ7Sw3u+nkuHDpgja47h4j+eW?=
 =?us-ascii?Q?slV0UZimv86gtukouNCWtOpyhERpT4EeRaKN+Hk4KFikv09/fKVc2R2oteG9?=
 =?us-ascii?Q?zZKQiij+DOwICdexAhirhrYjpw1fOgsKmiUuSOr9g2OWDKymCgp8AnauMjJY?=
 =?us-ascii?Q?LK1drrv3Zg/6zCa2mrkvGVqSjxjC7y4pm2DPDCq9c5q1cJ+997i2IlMUCdXM?=
 =?us-ascii?Q?W/nXHJHdOdTEP29LbZISPCkzo1IHqEZRG0brOf5dMR+LpAJRimk7YeDDpbtd?=
 =?us-ascii?Q?AO2emU1UZFhC+OGJ1kA8EYnqqC0THv3V+2ydL3MMKors?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c926473-d701-4552-c891-08db34b14d8e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 02:07:12.0059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jIX0nLvWYBH+lIMTI2vAE4+kZiiDYmjBIVbKzCJ8k/UU+OzF7CQS+LmNrsB8+BIR+ZI2WPnJXciD03yuKOBxhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR21MB3959
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 414428c5da1c ("PCI: hv: Lock PCI bus on device eject") added
pci_lock_rescan_remove() and pci_unlock_rescan_remove() in
create_root_hv_pci_bus() and in hv_eject_device_work() to address the
race between create_root_hv_pci_bus() and hv_eject_device_work(), but it
turns that grubing the pci_rescan_remove_lock mutex is not enough:
refer to the earlier fix "PCI: hv: Add a per-bus mutex state_lock".

Now with hbus->state_lock and other fixes, the race is resolved, so
remove pci_{lock,unlock}_rescan_remove() in create_root_hv_pci_bus():
this removes the serialization in hv_pci_probe() and hence allows
async-probing (PROBE_PREFER_ASYNCHRONOUS) to work.

Add the async-probing flag to hv_pci_drv.

pci_{lock,unlock}_rescan_remove() in hv_eject_device_work() and in
hv_pci_remove() are still kept: according to the comment before
drivers/pci/probe.c: static DEFINE_MUTEX(pci_rescan_remove_lock),
"PCI device removal routines should always be executed under this mutex".

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Cc: stable@vger.kernel.org
---

v2:
  No change to the patch body.
  Improved the commit message [Michael Kelley]
  Added Cc:stable

 drivers/pci/controller/pci-hyperv.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 3ae2f99dea8c2..2ea2b1b8a4c9a 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -2312,12 +2312,16 @@ static int create_root_hv_pci_bus(struct hv_pcibus_device *hbus)
 	if (error)
 		return error;
 
-	pci_lock_rescan_remove();
+	/*
+	 * pci_lock_rescan_remove() and pci_unlock_rescan_remove() are
+	 * unnecessary here, because we hold the hbus->state_lock, meaning
+	 * hv_eject_device_work() and pci_devices_present_work() can't race
+	 * with create_root_hv_pci_bus().
+	 */
 	hv_pci_assign_numa_node(hbus);
 	pci_bus_assign_resources(bridge->bus);
 	hv_pci_assign_slots(hbus);
 	pci_bus_add_devices(bridge->bus);
-	pci_unlock_rescan_remove();
 	hbus->state = hv_pcibus_installed;
 	return 0;
 }
@@ -4003,6 +4007,9 @@ static struct hv_driver hv_pci_drv = {
 	.remove		= hv_pci_remove,
 	.suspend	= hv_pci_suspend,
 	.resume		= hv_pci_resume,
+	.driver = {
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
+	},
 };
 
 static void __exit exit_hv_pci_drv(void)
-- 
2.25.1

