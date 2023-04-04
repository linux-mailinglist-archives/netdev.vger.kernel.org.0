Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1343C6D566D
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbjDDCHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbjDDCHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:07:06 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020022.outbound.protection.outlook.com [52.101.61.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446F32111;
        Mon,  3 Apr 2023 19:07:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3NZHMZEp7t5OhzpxvPpZET6JHrAy7bSXf/93QjniOb3nyfox2N75GJjjESvduW1vhtnU0rz3xZUBbjk4qYnI++07H5aBjpIg931u0iKbyFhjKH59c4HP8qJCBBQcgKYI8eqcoK1E+NtQBazu6Xu5H/0AcmVkUYlmglEYsSu8Sf9KlAl8uOepmKWu6jldF8Y/ozmdSFWQhlTCnoAteDtWRE+EmOflAbZgWV9DA3LMrIbdkHw6QPeGnjr+QSRhIYmvzF2C4rBPhmopGAX9gT7J5SI+eGUDDIbpcrEKzq8tsETqWIwlgmQP5quPyGCVVi7URw0TjreUmGjRnX815zstQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyQyMDLnlJ2DfFZyn8dC+7aaFeGEHemgz2YuKNO70Fo=;
 b=J40qJrzakYsVW9TzXrK5lsCkPmPwO1F1uJmwuNX7vJ0fGLvWut4dU/e1Gf/vkj2NiP284/yvSSPuLJ3R8MxS7ozF/EBHmi9nYM4P/C0fSwtPQzkKvbBI0mr2TfLkewY9T6A/WhFgM/MhgZ92rZj/7wpuxBTYsyPW573Lyp1wAmUhe7tdYdK/77Okasa+QCAcGtiZR757KKCWo3STOCnZt0S23uaNu4L2GR7ldIRuTLsPUu9yXheLZR4rXBkxLyfq0z15NuVtJ79XchpGY/Jm9RH1/urrvARkl57j+g7LuFEB+rlpGQMYz1e38nrLDizes4y5hHgYNpTwhuo/uZOVnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyQyMDLnlJ2DfFZyn8dC+7aaFeGEHemgz2YuKNO70Fo=;
 b=F/dGRE+/zVbooYfmyfDIztblEdC4h7LBr6x+EDnTJmljmq8J61mqpvmoclgqTGQ/0Q2Qty3e5I59GfrBu0G0M9GOa9cR6vgxAm9URkGM3xMKT+XFqmoIMkIS2UUneNvD72vGzC3yodEtmRikUjvcCZkWLOctK2KuQblrU7I5Hks=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH8PR21MB3959.namprd21.prod.outlook.com
 (2603:10b6:510:23b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.11; Tue, 4 Apr
 2023 02:07:01 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7%6]) with mapi id 15.20.6298.010; Tue, 4 Apr 2023
 02:07:01 +0000
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
Subject: [PATCH v2 1/6] PCI: hv: Fix a race condition bug in hv_pci_query_relations()
Date:   Mon,  3 Apr 2023 19:05:40 -0700
Message-Id: <20230404020545.32359-2-decui@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6f54c075-23aa-4760-e78c-08db34b14715
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1LCrQ6z2VCxfGCI6jthm/RR6zqWTqTZwlRf/HoJWLDPOQ2PBlWnKNfbZjCuitM/vDCl4tAHHGN9DGcdVVek8PQhMhN+l1Yv/LnIXCc6UfRAjcNcCoMWC7pIU4P0xielRn72S/lxoKWek3EYkQAy8rw7nLjwdZ7a93/oSoY2rC5VzVoFvakfCKdKY+WYpNpRrclZ2aMpKR7/kwj4vfyYPnLbRz64/Ax862VqEVCXjTwD0FT+Rn/7lzMnc1yCW2NBn6M1WR8BVa4pQdM14WZojiTCYSn8jeY+DWBKARxidwGznU+yLV8nxn0UQ/pZsDI4ewWFIeXHGsnKLy+g4PqWveQhbE6uyaQGJd3a34WDv6mksP5J8PIBJu/eBpkrwDx+ZVPRfxHiL4rv9I5YIlGu+RyRcXMVk+odBOHV3DkhtbWQVc37neJD0OA3gzV7OFI/bBmt9/VPZH9+YkNQv77vyDZCa9BkaU3tV6RLzy+qUMktGHLDnd5tLWhjtXP4FpZhKZYsN5/PRNEjMrVaIwkFlkmjERjUVZlGF6ARN9VgDGAepjgvuupIte96HNiyw+vJTaxkQGVc6a9Mh65ZqZvQGvnpn7/yZDfmf01Kw8wNaanTSa4PMtwY9AtmK2IkwI00janymxu0on2TbUUR1G3qfHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(6486002)(5660300002)(82950400001)(82960400001)(36756003)(478600001)(921005)(10290500003)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(86362001)(41300700001)(786003)(316002)(52116002)(8936002)(2616005)(186003)(6512007)(6506007)(1076003)(2906002)(6666004)(7416002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3k+msb4sh8R/n0q6r3bElUFBW9ZVUyYP4SkxZa0zdoyvV0zCwf1M2FCaEC74?=
 =?us-ascii?Q?tNUnH1n/SkXucQhzXsxg+La6uYNCs9+hH+p/ztXp5FXTZQxvqvkmzjoh2T6l?=
 =?us-ascii?Q?kbPSgrU6HFIr9tjo9IP9KwZz5H0xBHmj1dQ18YTM2+GD7ikaFAPHhSEvR1vJ?=
 =?us-ascii?Q?JCjTdbIlV3pdu8E14JB0tk/JIyJGkoOpuMwy+0ZCIfXcPABjY1mc9LNELlNt?=
 =?us-ascii?Q?4iutjr3Yu99zy3C8TKFHp7BaSS8XYpxMqE6+CCRzGwdPeZVO1Z6/Dx02GovU?=
 =?us-ascii?Q?oQgv+YvcaTp4hUgZaH5swZdTExAsucRaFBlxq1JF1wnvsZt96yI4rZNmLWrW?=
 =?us-ascii?Q?B8vyliW+G+Y2tVpJkVzGOf8MjBerjIzIYj9FhBiL6A5NOT9LTQqVEEtPMG8g?=
 =?us-ascii?Q?p7B5fsphL58d3XyQMVXxCMRJFneSYFr3Cu2OX0anR3aJFp4Hj/7JfeNpZ2rb?=
 =?us-ascii?Q?vxNangtAV92HDQhYlAKoOaL0AnTF69RRSYmeSqzPEQmzVxnCPV1uZZbrVigS?=
 =?us-ascii?Q?5JECkrlulyDzoc6SeraCqtgZS3E1Fn4dYUalWhuJqEUCKVHx3OWgF1Od+/qv?=
 =?us-ascii?Q?eXy4psKONkpRTcptuHdXTkgqTdatC2q9Euq0c5gjFu9L9kiEFHP40lQ4Q6A7?=
 =?us-ascii?Q?g3UjWIMU+5Q45IPtZdqjndeuxj8FZ7DhJrFi5fXXrZQxWzxIJNhXy7ZpxtZc?=
 =?us-ascii?Q?KBQKAaQYaQA8ajE6p9bZ3k1WYa+Y1vuQCdH03f24hzkUBc1LZtllHhECZUMj?=
 =?us-ascii?Q?UGx1GRJ5IRAT/tIAE+I3QKfU3deFXeSrSqpGhnn/PqHnjQas3GNatiU5sie5?=
 =?us-ascii?Q?XK488lQF3+iWwSRKf+OFXwzC4iyGnSNEwRmvRYD12HNIdMNETcRNzlRnoOMS?=
 =?us-ascii?Q?yNo3yIx5cptrgpCJahaUGNUqwxb6jih+6fBtROZ50otHjNjN/hd2ANhc1MCI?=
 =?us-ascii?Q?DWcDiJ90IWJycYlF3PWOgILUeCbNK3dRuROK/Hmmj/yl5Elmyah6PqjWJjt6?=
 =?us-ascii?Q?fCy5tQIIUbBOtP04f233luE40n9c7uyACeqWl/r0pfG1fRt3oQaBo0wHdnCe?=
 =?us-ascii?Q?2OmAA8XWpK/PsJ7sZ41LpzYOsdH5XcRKLqPMaxH8OldAqQERf2mWtPJdi5dy?=
 =?us-ascii?Q?2kxB2I+DxBh1U3RYzRE+VOo1Ta58zWk+CrtHa8CRZCL8KuatKzmI2PtWm8bw?=
 =?us-ascii?Q?Re5kXviG/HAmk8vJKZk1WfnBe8H6NbQh8lRciRfh01hNSwRrumT6COV3TeC4?=
 =?us-ascii?Q?JxWcalWzhReV22NIPl87bICQpi6qcIteR25F4Nd+RVo9VpQU97PPrz/nDzgV?=
 =?us-ascii?Q?VgO+J9e3Sphb1kuktFOdQB0SF8+0zbnC24OK6sg0nx+lxOrKVS8IwHINna85?=
 =?us-ascii?Q?/6vAc2C9iim25UrnPHK7CvAzaaMm8/y+Vz7snQUIzrv7gdXpiLFt2sKXEV4Z?=
 =?us-ascii?Q?M2HTnEfHzxAAauIWy3jxnTzDVGXVKGk0EqkjFSrwt8+gRd1kVbyTTtIbLeDn?=
 =?us-ascii?Q?bIiNyoBvVVsYgw7bC3jR8SQ8YTusOoyjcAPEeXVTJoP1BoLBAIr+bXxW44KV?=
 =?us-ascii?Q?LIqtUAH5X1XxYxC03Pmh840dj2EUMP8ww4bHpyqyNx+fQNQsEWtowMcS1Spl?=
 =?us-ascii?Q?oRdqbCyZit5doXu4vpEpIWt72YuFPhXSB5dCBAoNthOT?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f54c075-23aa-4760-e78c-08db34b14715
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 02:07:01.1369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M3BdP+6W+198buQ8Cx6YBDjGkz2r8/KrPzhyiEn9UyhNccP1FHfEIS5/Dqgax3DffdQFB3fN5M7DaSeNgvz0rA==
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

Fix the longstanding race between hv_pci_query_relations() and
survey_child_resources() by flushing the workqueue before we exit from
hv_pci_query_relations().

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Cc: stable@vger.kernel.org
---

v2: 
  Removed the "debug code".
  No change to the patch body.
  Added Cc:stable

 drivers/pci/controller/pci-hyperv.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index f33370b756283..b82c7cde19e66 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3308,6 +3308,19 @@ static int hv_pci_query_relations(struct hv_device *hdev)
 	if (!ret)
 		ret = wait_for_response(hdev, &comp);
 
+	/*
+	 * In the case of fast device addition/removal, it's possible that
+	 * vmbus_sendpacket() or wait_for_response() returns -ENODEV but we
+	 * already got a PCI_BUS_RELATIONS* message from the host and the
+	 * channel callback already scheduled a work to hbus->wq, which can be
+	 * running survey_child_resources() -> complete(&hbus->survey_event),
+	 * even after hv_pci_query_relations() exits and the stack variable
+	 * 'comp' is no longer valid. This can cause a strange hang issue
+	 * or sometimes a page fault. Flush hbus->wq before we exit from
+	 * hv_pci_query_relations() to avoid the issues.
+	 */
+	flush_workqueue(hbus->wq);
+
 	return ret;
 }
 
-- 
2.25.1

