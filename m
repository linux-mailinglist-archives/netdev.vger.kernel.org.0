Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861DC6B257E
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjCINdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjCINdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:33:06 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2127.outbound.protection.outlook.com [40.107.244.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22817F2213;
        Thu,  9 Mar 2023 05:32:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bthKYLBTyhcKb6sSp9tzvCrBIX/RhyHJiWvppD8h0kJmCCcQ5SoXBDLIRMQzAnmm0YsZXDsh6vDOxK6411dAkZbnnB7iEZ27JjL7jfjgCZh7gTvmUVCJO/Z546IFKj4Ml5oX+PQlWdgo0tPDet7KY5lb/ywRWLU0gQmc+ccE67Qdx8jqtrv+KyvNlIFbJtUHzfdWidkTDBNucKeg2g+OZFBfTE1OrbTi54NE+dzZfu3TJX22c5KtsUs825nmpjKbikYjkhLBfUW7WA1W6zV+PHHUZa467OYJOC+u24almDgZ/noztZfwnMg8UwyH00kdxp3vok4bqPHN6YyEZi34xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rw+g7NyzQqdkDIgwRXzjwPEUcjTRLAKZVHfq3s1rEbk=;
 b=i9kPLGVqdpZgtS1c+sNp4sEuJxLU+guACEFfESZdyoWDzItADAqqzlXNtDFgLwRg+L86JapeP63QOENi+FddgO/nQvbDfKHilrMZ2BkRKVM1fdJ3lJl31o4sd0sI+yvgVAc1iA/ARxHTX92GNm5j6uUV0s+cH3hl8uxl2Os/reXuhiEqiawxvgQa+GsAFW9mxUAwmCxqAdl/KJ7CR9/o9gB6FvlgatOB6/ukpk25H1c1ZZo0mvbT+TcJVM1+nALQN6buBc+fpiVk4iZV9GrVw40VyVq9Iwa9bEVMxOuHmBebRr+DE/v1HnsBJCfe2XdcyRbSm0dfzetCvlaKbYAfMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rw+g7NyzQqdkDIgwRXzjwPEUcjTRLAKZVHfq3s1rEbk=;
 b=OD+43HLkoal0nSm37VQN1f5QAY0Mrl/OFvieehOvsgIiOhmo96NEob/QmlW09sB0GhyaKW88F8DGpF2eZpSBpkiao3gyLof4Ov+QL/c9DO8+QFAOmPzohcQcYSBB28Ku7aJjJfsBZQHZPEjnLi9nGHZZofplGzBQvup3trKfkcM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5925.namprd13.prod.outlook.com (2603:10b6:303:1c8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 13:32:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 13:32:42 +0000
Date:   Thu, 9 Mar 2023 14:32:36 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Siddharth Vadapalli <s-vadapalli@ti.com>
Subject: Re: [PATCH v3] net: ethernet: ti: am65-cpsw: Convert to
 devm_of_phy_optional_get()
Message-ID: <ZAnf9KUAU+Dj+WOw@corigine.com>
References: <01605ea233ff7fc09bb0ea34fc8126af73db83f9.1678280599.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01605ea233ff7fc09bb0ea34fc8126af73db83f9.1678280599.git.geert+renesas@glider.be>
X-ClientProxiedBy: AM0PR04CA0070.eurprd04.prod.outlook.com
 (2603:10a6:208:1::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5925:EE_
X-MS-Office365-Filtering-Correlation-Id: 03689a93-1b1c-465c-7db2-08db20a2c22f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ATyQyUFpizoeLwB1HlM7xxkyc7bpewfwieTGTaxp/7ibjrbQD/EpEmAH+7MtKibWpOvzfckXC/ZO54TF2qqYdb8N0VxMqR6tOHj42uUt3j6ned05DXrsw8FZd1kmJbY4a5eVP8utEBdm892ar6AkUyrrcgA10SwvRTdjZiTSYqC0U55UAjUquB4dYPfQi6tibnSRljekLOcqcjLNng0fRS95OEIhaJ4gt24kWTIo86U6tRvyIRkuQaeTOEhVndgMIU/ZeDsm+5K3k7GXWLHAPttrARWoBPCUQh8DYDYcT22W0lS9ruKlZaf6vIikGSIpTVMGqysuCpQpqEZCCeo8sEKeHv/R7Y83ghmZQzdct+kP9BZrKVlgypKGkdui4b80l5ija7Gu1qo5iYKa1DoVIQQW/xj6WoNbb8vjBQoxQkLmRZf7TFWO6rpw5FUwFtXs46W3UTafbYSIvJpbA+XcWv4Zscbe1qGbInxLnzfsGcdMS37s5o765utFRsCJ/d+o0Dr8XzqOoWKzwp5TQLrD6tjvd+nn+A/hWiPSZgGB1yD3C1nGHvWM5fka/HpVyi5CHl+/1+VTX/zKLT3cJNh+D1vGhwctDcnMEapQHapdknF/lph1akpVa3fhr9ioAAWficxgAFi7IqiyAMIlxodYScns820WhayfWUfmuuj9f6C4ea3y7aep1nLLfs/qEyLa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(376002)(39840400004)(366004)(451199018)(2906002)(44832011)(5660300002)(4744005)(8936002)(36756003)(41300700001)(66476007)(66556008)(66946007)(4326008)(8676002)(316002)(86362001)(54906003)(478600001)(6486002)(6666004)(38100700002)(6506007)(6512007)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2PhINqGvM03dXY5NiN2k82V4BgvirrUl952v3bY1wvwTca7A3MijuGIIuncZ?=
 =?us-ascii?Q?ybl8R2fEzPZ57053ARZhzPcJiF3Wm9PsLIs5gIPm0mAaC2JsR/kmvN7jzTFE?=
 =?us-ascii?Q?KLrQImIlcU/OtEuHcSmyIK3i+xL5hFQIaPVGiRcF8ctZ8NIIdFvYsXTrq/bP?=
 =?us-ascii?Q?jfAYuwBFIEBNi26bJ1sDfoWOPFBVKPliuUPjwx6AQQ+CjWl7sV18u1zcvtAv?=
 =?us-ascii?Q?jPnUOggfGM8LZ8gqwMPfch2ET8vSzx6QDTfYw8RyWefXXIZqx/pxVHSZtDmi?=
 =?us-ascii?Q?r+Lf7dsAwClDMDKUjeMVQ9hfhMN7cxkdqwnbrGbNCt8tQ3jdpNbfl4Cqv/c2?=
 =?us-ascii?Q?Qw5L1B7crtjgaLH7fhtNiNoVWhSJE9vQwJ78NXsYQQxkymV7/mvXdPVfpaKl?=
 =?us-ascii?Q?jMNiz1EPCqpY966o4cnwb2URi0/uy1SxPoFjzvpeRruLeupCPkqsgopmmobl?=
 =?us-ascii?Q?3iNZKWuCKsyMXkoajPHUurtzZgeMYBkXuhiFTRbBiHZdc7v9TPZnG/FcQkZ2?=
 =?us-ascii?Q?4ZJ4wlXcDsB5ghO3eR++csCEHL3Zt6J/DhAS0udWUUhAr6YNVySedJMPnSgW?=
 =?us-ascii?Q?6GOgQm47C6FkRygQhvrX5vhpdHK31pyjD233o0dvlRYX/e+wvdxJ12rHxSIQ?=
 =?us-ascii?Q?JYss7o0Ns3w6E+SINds0UENpbiT8TUyxdGQjp1FZAj7uH74mzBqpMnbH9vFl?=
 =?us-ascii?Q?8ZGE7T7Fv46vvZ1DCZ8udoDcRc1C0fCz7rGbcghHi3jfWOsDjSRnjWmq7rRf?=
 =?us-ascii?Q?zUCHJ9WTtlcmsmBimBvF/KDsRGvctssS86H3mQhaNHdlJkX2RrowlZGT0VR8?=
 =?us-ascii?Q?ovcbrghB3gNzkDnViqoZoi3PlkhE/OzmyozYO1SrG5AOV4KHv2Aj+73k3cGQ?=
 =?us-ascii?Q?KvwNRe9WphBQiWINgrx2m5HdSjxSywNYisbd+LimqPkROGGWZmny7MiUxqHt?=
 =?us-ascii?Q?5IugQtQsZoOMnuGRIl4G4/dHToM9G5bLEe5mFWJ7DXHAqI86TVv/BucHABZo?=
 =?us-ascii?Q?R3Fp0RHXkgMpS9zZtpQtvgTmRrVfjr0il0bPgDM09j0kM/vlRH56MuNmc6FE?=
 =?us-ascii?Q?sADwdBE6P/SSZ3ayDdCIGRBdl2IHil2aj7/N67lLE5ZbOIpyUwRL3KB258SA?=
 =?us-ascii?Q?IYtx7aG0SqHqs4gtpTMBs1bs1UVvWsyutjOuAIcIa/CAxpMJy/qVAtbTp8VU?=
 =?us-ascii?Q?Nk/BzCxdFZxgMjsJcuuh8v07XEs+znQz0K+Dg1ZwhHXFLR25EekGIaLxf3dX?=
 =?us-ascii?Q?9s2uIpCxDLNY/X7oSp52lJunIHL52HRgK0AnqORGIynArYDeO2RynWeyx5vi?=
 =?us-ascii?Q?sFqsDs7t3ZBpFZEa2lfdBW9w3k8e9igPljhoGgPm0oe9Qxscb2SA8KG+Qo9a?=
 =?us-ascii?Q?dv9B6FKBf3t71Mife6b+uluf+6PQLFNtC8usir/1cXd99Y6s0nGV1Vy9LMLj?=
 =?us-ascii?Q?5AymHA+komNaJOE4hUvGcUU1HmEwoEvuvafyg3DAcRKY5BLHjJog96v5ZiJD?=
 =?us-ascii?Q?Rny4YBEr5r1iXJhmcA2/pdyeLIvf6w2X0rDwUBQ4Nn9PkdknzSLnqFdM0zgY?=
 =?us-ascii?Q?GuYn6A8bZOQ+yEaNToIijrQczRiBu+DNJQojmR7z1GR1wtWDcA6oXuG6Imq7?=
 =?us-ascii?Q?XkYrSQkMuGFVBg4D7dHI30iY7EMnrmBfeJOiVVqTHQ5V1vK+v9T4/qWNo0Se?=
 =?us-ascii?Q?7ByAXw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03689a93-1b1c-465c-7db2-08db20a2c22f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 13:32:41.9614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8wwdhrINfmOFC0bKISkJXTiNadX+uHdx4eSS96rUdLeLjToPmUZxFjQljign7c/Ov5EkfYuQXQWb0DNDPbUZyx0jIIfDkA+h3mFxlTuYq1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5925
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 02:04:52PM +0100, Geert Uytterhoeven wrote:
> Use the new devm_of_phy_optional_get() helper instead of open-coding the
> same operation.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

