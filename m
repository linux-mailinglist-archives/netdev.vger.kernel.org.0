Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779D26F464D
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 16:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbjEBOqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 10:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbjEBOq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 10:46:29 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2101.outbound.protection.outlook.com [40.107.243.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143591716;
        Tue,  2 May 2023 07:46:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1GjSA14ehGDf5L2NdyRnOqYw3HFTpDskupOiseDKy09JOotapxpFWMTImC7RYZohW2AR8gLV2GWKy08cvOF0JfGPTa0nqlNufiBMto8xOzZk6ftpuRDj5BDJadGDnFcHYooVSrSQkzhLe8a8E1rvf+bEBOR0jQti8Pv+GqAEz18+klL2NW9qr2Pu+xKBt2fnlAgvjabjpsjBhElc+Tewpt/j7xRQ+d9hjsKKBNoF0HWd2jPIFqRCkkyHce+QRs7e33cdyAMbnfnRHoc+2xVJ6sazAHxBythCYe7X5uJWvoLDatNsXvUdy4VsObXZArck+1Z4pBnLhFtDnTgYBOXTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o9nV0Cyfybjn+2YJIjlzLFXFLtnPcrx8uTUbks71vnA=;
 b=F5LUx5opdTdworOOETPQPYfOBLByQAlNpERFess75uIy7ULJHbpr4sxsTfqCT7kZNYDTeoWQPGlrv2bcL5nfr4vUf/sI25cZj8JUTT6F9sQnszvOVjAhxPLZoGnkcyJsGb1rhTHDGL/6sn+lnSt+gaErYEuYGUnX+CXTVI0wW1YG9zgfv+LTFDl4arAGaaZLGCJw8CoE73hwHO9OVC7G4KWHUpsUwG/E996rpDRBOwfvZV0DdFlBDk2wR/d9JeLG7tw/rYOmsJR0U8IDDIXCwvqGQyjdvzodONtciFIS/nTgpZU6lVfoTAPmyxCqlY3/2KM2Adcsd92+XKqZQFxVnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9nV0Cyfybjn+2YJIjlzLFXFLtnPcrx8uTUbks71vnA=;
 b=JSqDGGHQbrwExoSo1897P6nY4lfYiOttRxkyReyAQnBgN+5JARX6NQx6KvSDL/NX1kU71f3T/b9ubzSTETPD97u6/Oki1Uq/a8WZo81Lg62BNcnpbzgwSbWXCpkw3K2f2U1r6kvTso5BEFy5blwf5ta8SLOB7tZzrX4g/rEdPr8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3648.namprd13.prod.outlook.com (2603:10b6:208:1e8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.20; Tue, 2 May
 2023 14:46:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 14:46:24 +0000
Date:   Tue, 2 May 2023 16:46:17 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, v9fs@lists.linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] 9p: fix ignored return value in v9fs_dir_release
Message-ID: <ZFEiOdK0/UxKiPQQ@corigine.com>
References: <20230427-scan-build-v1-0-efa05d65e2da@codewreck.org>
 <20230427-scan-build-v1-1-efa05d65e2da@codewreck.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427-scan-build-v1-1-efa05d65e2da@codewreck.org>
X-ClientProxiedBy: AS4P251CA0008.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3648:EE_
X-MS-Office365-Filtering-Correlation-Id: 2953b82b-9064-4536-99f0-08db4b1c0086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cLBoew0nQkd+aNYB3IlGQVvUKY39OyLXyXT2MG6vaGHtS0DMPPvfTQRqmy3pyqeJNQRl3aOnxkE1JUhDP7TklzYZK+cKar8Nw32d1zYWFWI2nFGmi9vCMkkcQwfFlXVgoKdJANIvd8fO2W4fWFUVH345TC27IC646V2Q72JLjS2x1KdjH1DPPDtLXiDWAED4RFt6gZLTLswoH+m9RLSO0NBwG9uWliZ4m5LqMfJIvwW8C48UDq6ODesdwdWqzRWR7XQmy3evGf10WrcpOiVijvZmkin/vwTrrekMcdIHz3o451L/6f41YlHncCoqHztzNURywLN2LMvr+jTD5RGjnRJFBNA8vyg3tZnG5Nx70FCPwcOBHQoqIPQtYxvvnZlZphhgF0gEBwkb1w7RF5e0GuVqH+L/ZO4RBs8eclaPKZehKDVSUSJOlbw1lsUk3kC3KgeapxG4v1Pe64nSvG0WYQnCWgcAZ1sm/TaKH116/ZVEm6Hx66teTiu9mfnh+1qwnVb2ZXcuCC2e3zvVe9Oc3MXk6yFyIa+2rgodF6nx8CahBpwvVfz5diAjvceX/6cE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39830400003)(346002)(376002)(366004)(396003)(451199021)(38100700002)(44832011)(4744005)(2906002)(7416002)(8936002)(5660300002)(8676002)(36756003)(86362001)(2616005)(478600001)(6666004)(54906003)(6512007)(6506007)(6486002)(186003)(83380400001)(6916009)(4326008)(66556008)(66476007)(66946007)(41300700001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pgFkRkjIY43GUT8llDzLtsT/FdNefwY0Jx5wJdpTfzgVOVWuqisdcW0NaAMb?=
 =?us-ascii?Q?BidJ4ZJc0tVnBV+ox76RHj1LL9xCriRetIBET9uKbgkYU6RH+dJ1f76c5niT?=
 =?us-ascii?Q?BnNzAlN7Ct0hByCIr9g8kCjj3JUUY0SW2xUzM1BsvDk6oFCptRyLRqyOXwfz?=
 =?us-ascii?Q?PRT5EN5VKeOBVSqC12w/Jq6vFr8JIRGRXT/gLv1ZhXYo1oY6+ysQdvFzTmIj?=
 =?us-ascii?Q?oEEq7KTJJmZXBVMUWV70MtQR9bk/NIc/MNAkgyCjkL+Dcy/eN16e0nMQ2QVF?=
 =?us-ascii?Q?THoTPUcrV5RNczUtA9JquvvgyfhXwAbKnXNiYiZb8yo87r33+Kdovn+LWqSI?=
 =?us-ascii?Q?A/lOGj7pJcB53xfrcnR8VdwDmRns/+rUBl+BM8iRiLQaGfAwzNAOvas/ZVDE?=
 =?us-ascii?Q?7ctzdECjvzBuUcNYTxytyKgz//mC0XbdnF7k7jm78bpr06BfnQc9+PIDipzp?=
 =?us-ascii?Q?QJjBTI6DczaZhKwicOGY2IbmWby37buonp7GeIHNaLv723J7X8lbykniVgAv?=
 =?us-ascii?Q?/xCBaOWjbeElrQimbiHNVO02e1WPoP8x9UpBGpHkDpAo5VFTV3cwC5xj2qTR?=
 =?us-ascii?Q?jto3xBs2K/MSbZX7IXgNYVUgU7Z0D+ASMCmPwrEU2PnXEmERFKxF1tC8zLJo?=
 =?us-ascii?Q?ZpeTQuF4UQ32v90knvgS4WpUqpFsKwls3qfwKROzMnO0tMCAzwRhW+R0mlL5?=
 =?us-ascii?Q?0OwukcVMBldDNCiwYibW2T+XV/Nh0NI8wyaJmoor7cgh24i6aaLfaLalWTPf?=
 =?us-ascii?Q?hT/Z5HYtPRN79YiaPC3hj3OfY2M9tjP9AlT0AfOhllGdPFSxoWz2tW7zs0i/?=
 =?us-ascii?Q?cAAPl5ofdjCs/+r9uxk5c0Bf1WvrYgwCohx/jS5Ol7UaAe1txz29y9QCTaDm?=
 =?us-ascii?Q?nhUPTLL0iik6ndLtTqicbqy8EQRqPRnerWTiEXEKbVgpQgtYA6gKPdnLt4dj?=
 =?us-ascii?Q?Dz3plxDMqocptojwEHHL5lMhCFjyfB73oAvlTFfK87P0RVt04CwWXMJ8ddBj?=
 =?us-ascii?Q?JZM/x3ujsm1y58ejQV4sgFVQeOhNg/Uc/7//HM8jaqsJnjlHQ+AtG7WmSLML?=
 =?us-ascii?Q?ca00tqF9Jg+dQZ4rfakeix0k3mqs+XvS0EFAiIUTn/llS4RPE2p3GPkZGUnc?=
 =?us-ascii?Q?tNYSv5bLiLKFgl4JtgIXd9GIOjxbcY2+SK2W+64mJCmeJh2RiblTmRnfH6ml?=
 =?us-ascii?Q?63UOoKmP0htgGYTFQFsiwt27Au6VSoB+MPAQqZdQ7SA3Nz8OEF0ZZsmeC/1/?=
 =?us-ascii?Q?RZJ3CzsuMfKI3UF74eSnFHUiifpB1Q9pk0TvqXAPhbFcITFkJjPJY6CxU8RN?=
 =?us-ascii?Q?hHcFNw4g+s9etxfcSc4g/xMOHmFyotGLLaFwZdyjPpW9nV00GEHbECCIgA8J?=
 =?us-ascii?Q?v2j5JFlVR9UnGGSxwdv7QavLv3i3pM21ILuHdx4cFz/M05VQP+cvHyy08NTc?=
 =?us-ascii?Q?ydXlkr1Q0agl0OtB81ODEl4YI4uNg63ch1vtDLiOeXnQAIcLIcsUbXz8vXRU?=
 =?us-ascii?Q?mRcK0utcd2emQR4gO+CFX6H7UJiOmg6ecr23X0QEXDZbEPA6jiaCEpcAaXYC?=
 =?us-ascii?Q?beATP7Q+JbIt4yPKUr96ZJqISJzvpoRKxU1xJy3Qq/YlH/SsMm7auvgpyQt5?=
 =?us-ascii?Q?zTWxHoEEpMXvs7Va8Z1Y/Bx+/13gAfOszzhqZNiEJbAaxVu2DDurgpey318f?=
 =?us-ascii?Q?ksY3aA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2953b82b-9064-4536-99f0-08db4b1c0086
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 14:46:24.6114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /pfJjh6iu6GxOuUqi2ipeJq8sKhBqmZGDqZKY3djG67R0uPRvQsaEL59p887lZNqkAU7RmN3nhqnjJP3wbeBkqHg8bwaUlThSxTGW+6dGS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3648
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 08:23:34PM +0900, Dominique Martinet wrote:
> retval from filemap_fdatawrite was immediately overwritten by the
> following p9_fid_put: preserve any error in fdatawrite if there
> was any first.
> 
> This fixes the following scan-build warning:
> fs/9p/vfs_dir.c:220:4: warning: Value stored to 'retval' is never read [deadcode.DeadStores]
>                         retval = filemap_fdatawrite(inode->i_mapping);
>                         ^        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Perhaps:

Fixes: 89c58cb395ec ("fs/9p: fix error reporting in v9fs_dir_release")

> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
