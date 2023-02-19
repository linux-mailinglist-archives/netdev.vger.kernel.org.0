Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C881469C244
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 21:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjBSUaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 15:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjBSUaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 15:30:14 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2097.outbound.protection.outlook.com [40.107.94.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF1B14E8B;
        Sun, 19 Feb 2023 12:30:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWwI4TJLxkLbukSmaSAsouz8CwPFd0SgrZ9ppaXmohveJEBaM5xFbly3Az4EpgkhChCjXwJ0mzy05bCUtOBfJ34L8Ii5LU9KxJRAinidbZtfv6Uyih5qXEcBe6gsQjDDRYHP1yFKQIAWlRYiHObQrE4hlBttC9s5c7BfYQ31TXdIb8m4SpZblB1iYEPzf1OD7bAB346IDiKRTKh2pTKZk0Ea41jr6+SOemKtzMQZGMngPKFPjf6r0msW0lYsiq5wkwnEKbqMOaJa97MtCkYwKboJcMTW2xSAXdd7mSR9wg1eLBe/ZPxZN79gNvwNduBP2jeIHV0jEM71Zbok2xFRLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tb8AHTvzhElWzV7k1gWTJqnwRw9PNba7AAYHhrd92d0=;
 b=ebVB3HrB6FhLPI+myvpQoo7Fgp+DPIEUx7XGrHg7lR/7fzwCgXnJbIU4cp4DYfD317AAEonEO278sGS3PXTp1BUrNQI4rscz3xPtGPji+BjeR+ZdLL81XnndIfQCZeP1H/NbTC7v0n9K16h3cbZBJRJd+yLJ5IttKoOACCeGxuHJ0wK3sxo94vYpdJofYZrP37Kqr1JSOBaU1mZyFFXuJAe27JrPAYJZXrTtTEiq8bBRmlyfVYgoc9ey1iWbvMg/WrLwMijhfKBsMNTiKZe/oUnLXkZr34Sul03/VGFGXs3Ro040wnBPW3EqnrgD5YufQ0ZbEa1I/GPVRZWiBJHfyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tb8AHTvzhElWzV7k1gWTJqnwRw9PNba7AAYHhrd92d0=;
 b=UsAj9BVI/RWcJVR9IVQrKcT0ujs2BECM20+MDUJKD+IRP68VIVoc5K7e40I+OZCLUv5aUsBpc6GTGs1u4+ayMTeYqs8wQHdua3sk2pZRlPwWubln9D+RQYCaAwv3xBuyP6kKnBu+8DBh0rMV5XKN6Gp3cpsBlIN1ksFquvvDDu8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4556.namprd13.prod.outlook.com (2603:10b6:610:35::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 20:30:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.019; Sun, 19 Feb 2023
 20:30:11 +0000
Date:   Sun, 19 Feb 2023 21:30:03 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [PATCH net-next v3 1/5] vxlan: Remove unused argument from
 vxlan_build_gbp_hdr( ) and vxlan_build_gpe_hdr( )
Message-ID: <Y/KGy2u6QX3orUHn@corigine.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
 <20230217033925.160195-2-gavinl@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217033925.160195-2-gavinl@nvidia.com>
X-ClientProxiedBy: AS4P250CA0001.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4556:EE_
X-MS-Office365-Filtering-Correlation-Id: df1b9651-de88-482e-5b4a-08db12b819a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O582mR1ThY/fUmpH68beTOjPnjwI9eADLDOt0P84Rr71BFBYAYC8ilDMGDTBPW7koshmRbpYcO2fWUjji7zv3N/0yjVkYuuiAd4gFJWnU2a7grqm1ZrjvRstvrbKzUYYp1yhbmQ6BnC+4geXHZlyEO6nNO77k3US18H7trLJ3T/JM+vVJFy/S0Zd8uUkjU/p1gTtSTB9YCvhpUxXyNNZL/hL+AwF87cloBoOcU9/ImT4A5hN8UsUp2F+RliEzrWtzpDRX2ad9riusNfU9iCM224wFASib9XasRSHWiuXL5z7TxHFW3rvX4gEfSlpDUro64Q7AWuHqtmi/hmGMQgOkzTq61Gid9ZYdnuWNYIY/QSduKeHgXHukJ9O72O7pYbZZyDavwfHsQaZM6hcy6NyMK5hjnarEONdtVQdtga1CzwvYv5MrGBWhY/LXo0Flp/liSGKd745og5vaL92aHKkEpP339IrsyIjZhVr3w15+hjIctULI74HAhhPvcgVM9Il61Y1uAjBXI0gqaxDx8eTh3mfZoaz6Pt+GDekuUYP7IZcuK7SrWKu2Tdqct0s4r5zPeichB0q6DM620NdNiWboaePNPLcf6sw9nmyyoTjqyn3bWfy8sEeV6MCF1AKy+pvvzcXwrr/c9FScCsVAIRuLVvvlHi2eJ8wcX9Au3NCtIvgOTk4KLincNUwKH7Psw4m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(136003)(366004)(39830400003)(451199018)(44832011)(2906002)(558084003)(38100700002)(86362001)(2616005)(66946007)(36756003)(316002)(41300700001)(8936002)(8676002)(4326008)(66476007)(5660300002)(7416002)(6916009)(6512007)(478600001)(6666004)(186003)(66556008)(6486002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d6lIhuTJ1V0xGUhBe2Hcizp7NBGZmvpyf4A09Yq3BHRWR+Hd64HJFuCaufp4?=
 =?us-ascii?Q?DeGgLuQiIXKej2U7IJpZpjPR77kHOZ5O9hwPCaKya7c7XPIg4V7F12GVmWvT?=
 =?us-ascii?Q?7+awn39Yr1il6BLYpiftYomFjsUZ9+cnKRRPUmwC3IhhQWTtDrNGJQsjU47c?=
 =?us-ascii?Q?U9yFoU8c6VzAZzneRZK9etbJUKEgzeKjbPbDwexH0NQAZDoz+ikHqtF0EyB3?=
 =?us-ascii?Q?0QW2bkiBIpVcfY6n/T+Toi0sEFEA3KIalTl8x+FQemSZBE/uvOmss0cc1z6L?=
 =?us-ascii?Q?CnG6ZM7H83390VfGfRQeeq4TdkNxqfzrrfoeAvyzwltFqPIk2v55k7kV06Ig?=
 =?us-ascii?Q?+ghqBbKi31Pp/SzYcvBGnJMmP1mH6aOZOcXi8MMy01Hlcrnq7liSNJ3NAqtb?=
 =?us-ascii?Q?R6QlvBA8RLb3tVmLwu0kJOHxl5mWv7g5XZzh6DU0jtQyklveZ5T4gF1Vvu0L?=
 =?us-ascii?Q?O/GiwyVjf6iTgs1uMumIlJb7/wZnThyYrRDcNtDGV8g7PBsrZ6f8mTpCJlml?=
 =?us-ascii?Q?0tLmDp6BMTLQ7Ot9eXYqAuw7e5aicEW/8fu13RmwxTRTCygGnaCC3Z0PAzG7?=
 =?us-ascii?Q?SLI237CPoRjtU8ptcm8bH2+fQ6ZpVqsGC1tYCoYBoVBDMNyWddJaNDqFdOoT?=
 =?us-ascii?Q?/7dAWdjRW5kZzMY9azM/ZyNbNVBGGiRP70x7q/Apb8p/YJLl7+0rWf/4bhjC?=
 =?us-ascii?Q?WVGPnMF9md82s6TPBkdPGdqpnYDTcJFtlRi4JNPkKy0sYQbfZ5AjpSbCqZgk?=
 =?us-ascii?Q?Js3mp89fPeJW3/s9wsI5hKhX5sK6sLFzpkQOxdOfhuCJuVDbzrzdH8Ub8JSz?=
 =?us-ascii?Q?BJ6R2mtIieRUuCFUbhjR/z3uyQz1GBFaOmNkrnjFbh5O7n9hvW/3cHdNc770?=
 =?us-ascii?Q?6pKTHpB38mRB/1r4/mRtpKJr8dAl3E2XTXhL3Lr1JOOAHKFmswphei8SL7ts?=
 =?us-ascii?Q?TrqJfNuAGu72U7T+zsIj+RQsV05sUliLVpFwMQ57TmCNn2LmUNMCIvx47+Vp?=
 =?us-ascii?Q?fHX8pnNFSKz0OwpUXLc1ie7vVrGqMgTpgx68CCQ4Lz7xEfzepKuZMUDSWkBf?=
 =?us-ascii?Q?c45tmcDNg5eDSjDxxijBoLgXwplLUFkDaOqvdDEZ4gzqyaukduOR6ltJ0OI7?=
 =?us-ascii?Q?UH3M4cy4sgmCznmz4fWKKLkbVK16p/w3iV3BTp/TWZtKNQIQtuoNXxnWqw29?=
 =?us-ascii?Q?lnHZAUWWKmUgCHL0BLyrIdYXRw0e0oovbHVdTtpI9S3JzMa30Moj3erxE5Ho?=
 =?us-ascii?Q?+YwXgtt+Clc778Q6YlMf1RGJyWH8HTkxfC/XfHnJOqLZEcWxdyZZKZDyzRSD?=
 =?us-ascii?Q?aG4oMXcOMF2TAPA3ay7pdoEea5x5FEw/TNlVnaOTaa/TgnwV+VOsiZM0BtjG?=
 =?us-ascii?Q?bO+M6D68l3lNVi+GdWHc//8PYoQdYAy8lu7E1yQI+4CKPhmaOphFHh9YDrct?=
 =?us-ascii?Q?k7hF557DnzH9SoZ3pJhm8epdN4lP4RZg3PI2lxUSeK5Dxg4yPOa5bGaAkHwz?=
 =?us-ascii?Q?8omuX0liYoEZm0rFbpqn/OOQ8kqlSqwLSy7mQHIdXL2epSwYr/Hc3gHr/UOj?=
 =?us-ascii?Q?s6xI+38wFSVoyJlJQ4AqpPodjtpX136p2glVuGlyWOF7nrqM33bYV0G85vFu?=
 =?us-ascii?Q?cjo7yXKqs9EmwryfqQ14GgP60MpnnG/oYMsCS6C6eYkSttcDm6AucuSGnrXU?=
 =?us-ascii?Q?5tPtAQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df1b9651-de88-482e-5b4a-08db12b819a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 20:30:11.8325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BpAZ8130Qw3sdBT+VoXbf0jtOxnXDBo1M7Y3g8zFunKn3Mlpm8AVeduCd296v3dnV0WFFh76fQ44Q1SrJt2dKA8hgnY74wBBBct466DYkHQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4556
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 05:39:21AM +0200, Gavin Li wrote:
> Remove unused argument (i.e. u32 vxflags) in vxlan_build_gbp_hdr( ) and
> vxlan_build_gpe_hdr( ) function arguments.
> 
> Signed-off-by: Gavin Li <gavinl@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
