Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC626C9394
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 11:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjCZJcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 05:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbjCZJcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 05:32:25 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2108.outbound.protection.outlook.com [40.107.93.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8903D83EC;
        Sun, 26 Mar 2023 02:32:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cvUynnRhaGKrHooiaPhumTsyWzmXMBRMx5eHANn/VgkkL30jBHQNnN4FRudtQhGDifIQzFYgM3MwfyR5XnunmmKWsuP9oUWzOJKikU3YGsSFJzbYY7WRwf8P/r5mLBISIYH+FiQUJGDU6sNjXH6iRlc3Xo7TpzJcz/4hXbi5ra4A07YyGh6W5641N4XjxsWw45VxlXZDLohzcUkM3msGWBFqvjE70ETICnBMb8whKTNmHfhGDUgQ8FhHH0OVkz47F8GZOEjQLCcXSTPt6z+FUVWlShSVRdVf4gzqGKduCB8GsSzc4wb4BH13HwteNHQQ/+c1FDdV1L4kF+Q04K7J3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zfYu6/cI8DB1V5gWdY1TV9zB+Hl6K4izB2ptgFSsd3o=;
 b=azWbgVU4WBpwR/FfAX/rTYVzJYh/nQU+pXFs7TqAwyqfnMT47B9zhpAYPS5TKCW3kMjDVgVADgDajC6BoJHfyxrn4xyR82AIwCMAi9MxRdh4ccZRuZUnyDcQK7oFsGPoouHSHwvBytObiukUik04/SRM+C95rSsPW3VdfD402KlKw7MAcHjngJXPRpJGyjxC+rjhZMLUEqahwux8aoCT3yrf+JXpPZz2FKKdPvDlgrdhSiQmNemQIQAFN6Dr7o7yQI9eza5aKNa2lT/5J+HX8fyJoEt0LqCT36lLOIJaeJfVLrdL6AVa+4GK+joXipIZ+B/B0YktZV7xVu37HJo6ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfYu6/cI8DB1V5gWdY1TV9zB+Hl6K4izB2ptgFSsd3o=;
 b=gB4kBSdQxeJmJHrpkuclALzBhVCKUzJBz36mNSsb2yxc1G0B/OIZpUJc0YAYtui+/ccALs6nUHujbLNZ/UzM1+ah8LC/MrdDRcV+rRxB5dbMv1DBr3rNmyUZmiKlCFaAjOFOaY/7ju6RGp15zK1c2UN3qGERI41QAhHvefmlzJ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5463.namprd13.prod.outlook.com (2603:10b6:303:196::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 09:32:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 09:32:06 +0000
Date:   Sun, 26 Mar 2023 11:31:59 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org
Subject: Re: [PATCH 5/5] wifi: rtw89: Remove redundant pci_clear_master
Message-ID: <ZCARDyAfmaivvwej@corigine.com>
References: <20230323112613.7550-1-cai.huoqing@linux.dev>
 <20230323112613.7550-5-cai.huoqing@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323112613.7550-5-cai.huoqing@linux.dev>
X-ClientProxiedBy: AS4P251CA0016.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5463:EE_
X-MS-Office365-Filtering-Correlation-Id: 18068c0a-46e4-4c6c-562a-08db2ddcf6e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: faaVJ6u4nhWN2q51C0wsJuYgsWSNe0mAWnR1e0f6ZgQmNByyZ1wxg1YXTz2qe83pQbfoAq5cJkSLW2NIaOEyqXdbau+MHlMabjjTqEs6i7M4IZV1T1exfrtqpsrlXd1LPxsagT/Y8VHcqU571D1TyDGVs/oKZX8DG5B1bnj+5V39S+08IIvCgzyltD6znnpivJUUpWGFRIqsg/XIhTJd15vcpwW6fb4gI1+a6u7VKgDuMKwhIpcU8do3u+N7n8+W1CjVhCa5DECYk69UnB9sCDaQnD6s84SJ2pBYZZESyNoLpRK/iVxAiQibSj3dcp35rio4q0O33DZMuoFr6DV7LASzXoD5fwd+mSAIB+YWcYH4CC7vkY0F6Lrs7CuAbCTJqcKcE4kO5EZd4yaXCyrUPFsSYlL4d/PaP2Knv7n2XuwtxitVFOrVvj8lvskgpQy0i8AbSI9XXPL47PJIhfgojzMYmjhir/LYokLurIOJnbq0BSYhnE/KUDZN9LbxORgtxrG7G0GW1w5mHxt+RWccEQIK5WzpVIESVRHN44yA5yw7MzIiixAv7cgiy2Nvd4Rs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(396003)(346002)(376002)(136003)(451199021)(478600001)(6486002)(38100700002)(66556008)(186003)(66476007)(66946007)(6666004)(6506007)(316002)(6512007)(54906003)(4744005)(7416002)(5660300002)(4326008)(8676002)(6916009)(2906002)(41300700001)(36756003)(86362001)(2616005)(8936002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nTgomUoFDaPYTsq9Ajk57yCCfp2uyvzCE445Z7ZsP4YDnoHC+84zEVE/PxHd?=
 =?us-ascii?Q?XGSuJyiXKSyaiWQEdpIA+MDoF6hvdLOG2Sxltv8orn9UtwEAhhSNVb5NRVpJ?=
 =?us-ascii?Q?mqggusS2Xc6Na48gss1dWkeOi47Vc0Z9u/5YHv4XS3O3tdvOgBZBSX6FRvAX?=
 =?us-ascii?Q?KXwWFDiOi+o5ydSXUJaKB2zs3wIftMmInTED8V5rht8VM6sla7Lz4hV0RbPq?=
 =?us-ascii?Q?wRCbe2iKjDsgdgceSmFtNjoUGaMGOC+KCKCaK0aFFYTYpxS4S4GfKMJ769+B?=
 =?us-ascii?Q?FpThuceC//bDGH9rocI9P7G+xKoGAeP83xwAgAzQba5ei1eHSIdatWdxOg+d?=
 =?us-ascii?Q?PQElxoEr3/qq99tfbXeibQTk7zoLypcnMjaLwoDqgjzWLjjvxwt94FnnB7TO?=
 =?us-ascii?Q?uLm8BQb+oqHX924pDDBF41ISEtXw3/PyVvBCt+K74yq7xlT1sREJEtQd27++?=
 =?us-ascii?Q?WvEsE/HLZ3i3/RIdhpc0HhHPQ6NUVQG1DlB+LIxu07F6IJ+E6x4KcCQSiEC5?=
 =?us-ascii?Q?n/LUUh67bXrulW7h6qVEQyw8aD2sHNxj9RtT7aaf65/xJrddyRQdeAuNEToA?=
 =?us-ascii?Q?uIsNBTdFKKVQwggyDcD8V+NoyZ0XpBmW8b/R/PpaSls36H0V6EAu35tDEHl7?=
 =?us-ascii?Q?+hKCPYXKLgQwfygEVywTrCwexjAGb4x3a6FSMZYP6I1tSzOsSxdOulwvk7Bt?=
 =?us-ascii?Q?rm1x3eCocCGR2rOSWPEexcGaskL60SV5kaSWX5odukGr4UueOgGr0sJUFBfj?=
 =?us-ascii?Q?Nl9/iKNH3OqxYx3JpaAu4Q6ypQRJPjPnRZt4HzJ9bQz6lSBT6gJ9tC8oPPDz?=
 =?us-ascii?Q?yedQbO+5Fv2JfEVnAysVskXKDeZNQglXEkRR9uPVh4QdCaZRpAtNos4YeGGv?=
 =?us-ascii?Q?UIVVNNOHewnI5u8/j1d3q7nt3VG3R6E+bfo5yCF4m/K61AGlNPjxLqkOUZAt?=
 =?us-ascii?Q?7PE2ZUpAov2fY8ZLvVW7BVnx9F8UHp+YoHJ3S9ztDjV44kqIXON3ErAedH1x?=
 =?us-ascii?Q?vlf/a4C8sJ05nwcKbYR890dXG7doSS+vccQIJYT5XcUVk2xOiX8hbuGa0e2q?=
 =?us-ascii?Q?WUNIL4AXuFOyv6OUgMRzexW5ecLimPrghndawpwjy7Sag9RyX6ezGbCRYSHM?=
 =?us-ascii?Q?YHqsi/a8ktrQrXHmtkpofhfuSvGkSycM0emggamxUTbCPjVIti3p+p3DPi7+?=
 =?us-ascii?Q?SdE60PK/kEfnhY1CNVjI/iYx4CeB37AnBh4zPCJPVxUjzkc5Fxjf22ryjSG6?=
 =?us-ascii?Q?rojiBcjcZRz5K6y/oWN4bB/ozYtIl+OG5Ca3JipGesWWkD6vD71ktrT+vqmT?=
 =?us-ascii?Q?uOM2wGqncO54hjGpA/bGMFzoDgV2qzrzJWxVBbZZKUzGB9geLNxzyIV/j9QX?=
 =?us-ascii?Q?59x7of453qQ4dz7WrYTDrh/yuzRFFKIOfZwS2Pn2DGwK8Gdf6jf+TgszBD1H?=
 =?us-ascii?Q?tUyJsapt19wtZWOU/aBRR40nRPPFRdYCmLqhBUc/Ct7VRko6DcjzORzFJ0Qe?=
 =?us-ascii?Q?eBdOpc3qEuAYjMknQHvoDPw8POrY/jjoertTM+zD7sAqPjm6EaEbadxCBI1R?=
 =?us-ascii?Q?2nNZhpOAIse2LlvGMo+UbAhZYcfjazEATmqPfJJhTZO3kM3aSpEbCImgf6hD?=
 =?us-ascii?Q?ZKAorUTNbcO6zEN6chLmTeySX8UqLNovQxn/9nyfNRJfkh+aHN+YIceknGfb?=
 =?us-ascii?Q?GxtBow=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18068c0a-46e4-4c6c-562a-08db2ddcf6e5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 09:32:06.3094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ptCUL9cuTEJPkMM8M/M2Q82KbMgRUc/JOZMO+ZdE2b6OQl+iQqADWroQnBVcOFohKKjAJfnBc2jkP5vVdh+zS9yv+8U+PVVxd9yUT2YCX3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5463
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 07:26:13PM +0800, Cai Huoqing wrote:
> Remove pci_clear_master to simplify the code,
> the bus-mastering is also cleared in do_pci_disable_device,
> like this:
> ./drivers/pci/pci.c:2197
> static void do_pci_disable_device(struct pci_dev *dev)
> {
> 	u16 pci_command;
> 
> 	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
> 	if (pci_command & PCI_COMMAND_MASTER) {
> 		pci_command &= ~PCI_COMMAND_MASTER;
> 		pci_write_config_word(dev, PCI_COMMAND, pci_command);
> 	}
> 
> 	pcibios_disable_device(dev);
> }.
> And dev->is_busmaster is set to 0 in pci_disable_device.
> 
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

