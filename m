Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C026C94F1
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjCZODa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjCZOD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:03:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2135.outbound.protection.outlook.com [40.107.223.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5085DA3
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 07:03:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vrtg5ykEHpiHeAMj5mxfiexRYXvb6AIOqSxbkUChy3Y06oQsaUpfjvw5aHN9VEj+ipmnPDjmi3HYw5CvsLZNG8oL9bWOlxrAbzV6WTjtgRJLd81AJEG6vochTOIHPwf0vJnYw9RYLiDCkKq9KIM05RRu1ROcVEMt2mHpdUDPT+/ntqYQM4RC10T5mThTOLcKYFTAWns8WK8Vd5RCT98qTkqfqpdJ5Kh/xezS2g1vw5b2LaiDxj1/d6zZ+HqBqSzeRdstLSZeBXjSNkO7vPSERg1pbqokI6PY4PwmNfR1o68y/a1FowbO2NErelZ59EbF2QFkL8iKWzzTIOwb1WMvCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEY0RpKcpsZ68++jhKeeghELe9/6d0M+WhaOurkD62g=;
 b=l3ZZZ1LDh1pwK4PdsoLHwCaAea6TfZfEGvoxxcoFP7nqgya7KF4K787LuBeF8BXQnWfIb7cK59PZVYfqgX/PJyzqFQH9wr0SQd7tUADjxOIyQVX6YwZzbMSaPIxjvVKAZnHxsETwIOlqzDZCysLSZiJjFymSzik3PzGBTC41XJsmk7/y7G7qd5irCa8UE4i3eVz9LSrQ/2AoKsJq3EF3B/vlZusmq/JowrghRxgRO57dGl+rCb42bVQkZET1loSqu8lZRIF2ztuKKuOMiC21FbmDUHloTdos1QjKLz0zA9IAM6dkAtmzZ+3pM9yY2r4dVMek6GEzm5SgZr/vxpZhFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEY0RpKcpsZ68++jhKeeghELe9/6d0M+WhaOurkD62g=;
 b=d25WtZ5s6OBPjd8Lq0id5k9xOPUd1Ow0bAh25W4aNgwg4aJLW2dKNDsyxc6tgh8ixl3L5yr/djzUpxZZ+B+jnOhTJFiRF0J16LxYE84W0ROQlXk0qoCJY6LtGIG/Drrd95LK71I83N6CpcgBMwXEnSAK2/kAMei4a70+ymbsc+8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5305.namprd13.prod.outlook.com (2603:10b6:303:148::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Sun, 26 Mar
 2023 14:03:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 14:03:24 +0000
Date:   Sun, 26 Mar 2023 16:03:17 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 5/6] mlxsw: pci: Move software reset code to a
 separate function
Message-ID: <ZCBQpSNknylrImKe@corigine.com>
References: <cover.1679502371.git.petrm@nvidia.com>
 <b3ca40f2076f96c10f9275ffdac318033f273a99.1679502371.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3ca40f2076f96c10f9275ffdac318033f273a99.1679502371.git.petrm@nvidia.com>
X-ClientProxiedBy: AM0PR02CA0085.eurprd02.prod.outlook.com
 (2603:10a6:208:154::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: c7616716-af5f-4f2b-b2e8-08db2e02dd1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v0edreUPGsXCDIwc+Pn0OrnJcRZ6Fo5fzmuRnU2+37aciiyLsJQDpvg9kG6gVFk1d7r0NsxeyDF3x8PkiNeeMec2DdRCTQ9ne/csjNg6OYZ0XrWnHi7pURG9QAbhUI7Gzl8DiPxW2FwPxJ8RIuMgdnynNQg4zwZf1GLnA9zqC6JJhfUcOgEnxqj5elOKE1qK0EjEUZU+X/PCZVF/HSwIAcbcYWv4bMWunHrnqz8FxtReklI/XkKRznRIEH0YDXX1vCiNNqVkOr3i/xEert2EC65MDXBM190B+YHrO7AC7l3Yvqwa+qh3JDRn0a3NR1Jr5H1nJXyz+1Q47r2dx0FdHxVXQjzu4jY+lDAdiOt7yFp9lzGP2F5pznPSU1qoXTwGJVTNqdRCaOXCKRfi11cXK80FlOGiL2vu0M8JW+R725Jpv0xOXyxMErEw50k7690pdYnZfNQkfEceOv8yVZllBClCfQga+HAWBOZPvwtIB11m7tj5JuHBf/l1GBroiuhPTwNBi7GAtUSAr4eHnV6KGw8L1V33vgqZ8D2snO0xlsq4Y84TEd2Uk8TZ4gkIi3UR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(376002)(346002)(366004)(396003)(451199021)(2616005)(4326008)(66476007)(66946007)(66556008)(6916009)(8676002)(6486002)(54906003)(478600001)(6512007)(6506007)(186003)(316002)(6666004)(2906002)(4744005)(44832011)(36756003)(86362001)(41300700001)(38100700002)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dCH66MM3Ulgyw0x5mcaEaDC8U3eBNPeo6qBEZiEAs6CxFJxJ6bYqAq2/zw3F?=
 =?us-ascii?Q?C9ra2VDQBRk78bUvseEABuZ09OJWg3xsM59Ec6E/SBlkG+9hUcTf5JGFrxah?=
 =?us-ascii?Q?ndRNwGo1OrEANDn0YjHWNRZkZsEszb7Pztq1aP5HkJeW+eAXZC1JsvGQ1Bsd?=
 =?us-ascii?Q?EMOljfu/iNYlCjBsIdL/ygANu4tACeNXQxs+NR/BZiqV1JVZ9uy4XCz068Vs?=
 =?us-ascii?Q?OruBL6cS8PEvvWvrYicdQ64Kv7gEHpDpcvfD68efenbXBnD99Bbj3jzURotR?=
 =?us-ascii?Q?GFP0Z81fmld4RuATQSNcPdGiv0zEe69L4z5F5zIRC/TEkur4oTVNyYqwwEEF?=
 =?us-ascii?Q?WVPupTmlXC+sZnAsPOJqktnKRk/mJadKcj4KLpj2kglFVVohwpbyZtfAC/fb?=
 =?us-ascii?Q?Bj//kRMVrNj5vK4VVueo3ioP6WU3DklQ/dsETDbfHWfLvIBGWPfTlyHs9GlY?=
 =?us-ascii?Q?VifJqfSb16Q5WccBg2KaSRBpj25cIyIPG11DuxyrcWaJTgOhz+aWCEU7r+a2?=
 =?us-ascii?Q?tklMDZ9NDRVeHGR9s8cTw6yO8Fez3rbRpO/ffVRvitxfQyFVIPSYJ9Ik6CYN?=
 =?us-ascii?Q?+UTPaJj5YQxbMfv+TuQmQskoDmzgwFxv9oGTojL1vp54qJ0phz//DNr6/kce?=
 =?us-ascii?Q?eB8H8kUDxCBE8bEw5uVdSebA2XjYGo4vujVmqZ/j2A8tg5h8kiS3wtHhQ+Fu?=
 =?us-ascii?Q?Lj6RwWaiFwzrsIqjEHm4Q7p24XIsboxbvRX0PpNU3s2Y0D44V60moBkzUfoK?=
 =?us-ascii?Q?EwmIKuhziLwJ/5nCuh/MCOcJS03vAD/mOKWY4jS9VT62Y+k5jBTFw/AEGFPs?=
 =?us-ascii?Q?A1QlDVZARWQFPcA5InCW6g17LaIFq9LcNgEtMez3jKla4H8p+r0rGey8EucA?=
 =?us-ascii?Q?wJX4hKEREfuUPEf9QifRMjA7TVia9a/YfYSANup7ieeKfidOIdCx0KUpFshJ?=
 =?us-ascii?Q?hRvXJM45fqr0kB+03BfmYIHxl3PLQjywQpQQ2CdKbX9C8nDCZwgaOUqECu9S?=
 =?us-ascii?Q?LcKlM1FIOfjd/9j/NtYgRWD7hX5E5nBjT5ApUiMhjWjXSGeefGFJPjJRLurS?=
 =?us-ascii?Q?O390YyXL+yqDppwJHX9I+a/f0zvkvhiwq21XRmd+ALQTHoIOa6D1ejw2wqW+?=
 =?us-ascii?Q?FlOsUkjO1tzKsybO6HwDM3/R83RelTO5KPhvWSM3ckUwAQy2rFEUYhvcnwRU?=
 =?us-ascii?Q?L32H8ZQS+rPYRSkkYiHSy0U120VESPbJF1P6SoyYabc0qKelapuDbtWk3cRi?=
 =?us-ascii?Q?fV2Xct1nsX5LxpMe6tFXFU7Tgu9b5E4s3sd8MWTuzYRobXQkG+QS8WPeOwPZ?=
 =?us-ascii?Q?k2G4QRI6TjvI+cUVj5URFfVkyfgH/MGywJuU03PfnJYTG5Esc8r4JAScGnpo?=
 =?us-ascii?Q?UbSlKVXDiCcM2oQUtc+iw+FZ+9b76a1a4pwS2x3nnKkRNUoXNiUTfP4FkNt3?=
 =?us-ascii?Q?AaRTVHRCFzu6iWVw0aayB2veO5WnnEHFfEJ+jC2pL1oLClzHaZjPq+3h9vyq?=
 =?us-ascii?Q?Fd8E5dVz3/XLSaJEmQ0SK8WeZ1Y4WW7TnCH99AGnKZjZCFwinbWo96907b/I?=
 =?us-ascii?Q?/z9thV2tys+BKpgT55oB4G3HaMfN4Zo3fhm4fiBSB3YELKwOmkaVxh4zOw76?=
 =?us-ascii?Q?WfhWGLSzuFL5gP0lREMw/cgyNQt5uGbiglkwExafBMPFmCb8xX+Zsql+XgvT?=
 =?us-ascii?Q?m4bUdA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7616716-af5f-4f2b-b2e8-08db2e02dd1d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 14:03:23.9616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8aUHkM4zgsZXbA/natSmu/RzLVoZ93LzCPyVV0rLOfCZq+ZAZT+nJFPRZScJ/T6K6UnloQWGYQri1t1ecMP1slhy7sW9MrHqbEpoXlbnORY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5305
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 05:49:34PM +0100, Petr Machata wrote:
> From: Amit Cohen <amcohen@nvidia.com>
> 
> In general, the existing flow of software reset in the driver is:
> 1. Wait for system ready status.
> 2. Send MRSR command, to start the reset.
> 3. Wait for system ready status.
> 
> This flow will be extended once a new reset command is supported. As a
> preparation, move step #2 to a separate function.
> 
> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

