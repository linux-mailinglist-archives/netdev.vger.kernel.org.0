Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F60066945A
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 11:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241202AbjAMKil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 05:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241315AbjAMKh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 05:37:58 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C757577AC8
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 02:36:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/J+rSQ973W/qWYSHLjfsn4thnz5MJXzoYJ75q6d/PwAu4pkrlHUx6Tke+klTuNX2J5wU+XrIvymURewluAHiK99mIAW2SjN5h5wvaBjzI7Xl0mbb/0v+D+QwX8Ef63mJiHcLxAV5cJTq6kxBf0YJe72/XsLs5Le/3ZCx7PaRjk0sqjaf+Pw02IkRzXdCnQECR5SS0lhaj3GYY8cwdbbP0NKhqazjzshxWqm1KfleMLMt9K9gwSzYd//ZzMWEzNzrksaPa9UenjzznqtUtKuJrVCvJbhRPgc3eWDJ/dig4yqw2kB3xjwbRlqc5riiddUjCsBVOWZyggiE7s5jQN5cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J6hRwYt7ugogrrUpwM7xaP2UgejmGmPRRnkzkRiXSDM=;
 b=LD3/SqQNe+KWA4TFhSOdmRGmKQZ0RZnDAl66Y66tZH4+jqbvwZ8aFWyCvSjhEdwyZGsG6hJXjHDf6lY2vuzDmpAXVY38YLL6fs47KddiQjg5VSUYM4VQz9HMPnUWubMqFXZtHNxj7u99DTIZoa0iKAWwEZb1Gesn1rm0azoecxhoK8Sh/bUz4X5OWQ+3OBS/uT5dDo+G+pzAhJydiJnkA4tTRaEkAXyjfL3EV3Z9ZxExD2RjDU0kbpcLKsZQ1m4/LgM0d7Z7Kzye7UarFpiX08I6G16jxahR1kFTxbCVDFxm+rGeH6+/zXdEEO1SEjKKwf+tP7Sf3U3MFoHwyw6sbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6hRwYt7ugogrrUpwM7xaP2UgejmGmPRRnkzkRiXSDM=;
 b=mdXT+AJgH1knoYj88lAxwJ0+LirdRwvWxmfgof3Ow6QuoCZNonxzV8+U68qRCYRW3XUGgzwNKg0k6k5YA0eZTQ63Y0mDFhmpItoBIhGlwK/jXnkVwgsq0bll5MyIcXPcSbDMWvB1vRARVOIDsU0ZOsijybXd37jYNyz67erlzO0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5206.namprd13.prod.outlook.com (2603:10b6:8:1::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.19; Fri, 13 Jan 2023 10:36:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.5986.019; Fri, 13 Jan 2023
 10:36:11 +0000
Date:   Fri, 13 Jan 2023 11:36:05 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 00/10] SPDX cleanups
Message-ID: <Y8E0Fej++QpZaUDb@corigine.com>
References: <20230111031712.19037-1-stephen@networkplumber.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111031712.19037-1-stephen@networkplumber.org>
X-ClientProxiedBy: AM0PR01CA0143.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::48) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5206:EE_
X-MS-Office365-Filtering-Correlation-Id: 36fe012a-a9b4-4f0f-f643-08daf551fd30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96cG1tPq9XE90555D1Sb4Y8IZKib4axPHIXc6zriOdO2CgTySYc+7DzSvXA/E/t4Gd2ZOTD9l2Jlaw1hodpaxsnPLwWq4FHw1n25N5gUkIpj7nyH8kilNjRoFG6JnZ2xBkx+Iep/OnvHLWYzLT3L6V3fEZFhH8XoKn2+nR2WTKpendUwTZv50pu8rLEfhbZS2o/X7Ger63Mgfs5uEhtBdwgIc07krmRZd9oK/MD3UBggR+mjDUnQcHHHsdnfJmZcfPN4aaV2jacv5WnBEH6FugmM6Vx1cYUkQWKkGuAwN0jZxd2Fhav50O22gsKstDOzMSJCDrrL4OHt1LvqVmsBmEroWwwVt0FN+YoR5c6IfTBR2ZOPHUCLlkmuLAjM0UnZBzXivdTMmRC8i505BU7HUdGD7DmYaD16sTtqlHG3cNucQFbYdqpBgf+PClqmIB0mdwEe/NaqVR+zxMjCshSrG9+IxP2xh5XnQaYyEF/BwAxK9NoFKGpTM0EsOtAoDD5QLMK2mEXZqxVP/y/vofDYpOflepOfNZz0WQungFj5J1wIzOvyCwkpElzE5atGVoU4/+tk4HHu27RtK39uOkQmDEVe4jjokkY7A0FFHMEmiHcoD4tEOIGeI6sYpYijaQbKJEYZo+1VDWQwXYB/gE52UA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39840400004)(366004)(396003)(376002)(346002)(451199015)(66946007)(66556008)(2616005)(41300700001)(6512007)(4326008)(66476007)(8676002)(186003)(36756003)(86362001)(5660300002)(8936002)(6666004)(6916009)(478600001)(6506007)(316002)(6486002)(4744005)(38100700002)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QPrGtLCWn6Ua8yjGy/MAx8xKevvfFSNTiIKsczuLENNowZwRnFlMwTs7XHqO?=
 =?us-ascii?Q?oW4bCBhrw7O9ZIQ6MM+qf10Qwl7P/Rj+zTDcjl3krQbT7rlpiPqJ5XLl1YG9?=
 =?us-ascii?Q?38EtV40JsQxiuyVKn3vQNYD8C6pg3NvAWxyFAs8S6bYKz/n7WUbD9FnKkN0g?=
 =?us-ascii?Q?CU1rmlL2H7vTV0u6EVCIRlabUr8fZtnI+uFTIJa3smyw6z2Nl6gSk4ZekcZD?=
 =?us-ascii?Q?v1GAdIEgxuU7bRQRZFdY2zWaeHNQlOTK4H0v3rlOJh7JI4kbswmuHnTMcZvD?=
 =?us-ascii?Q?KNb+wpDg0FMvpMpKCHL3Zw1WqqBR5ZmCchQ3zCiW6QqiUFQs5H0RynFltFSV?=
 =?us-ascii?Q?wWGXRvhwtycG50KxQsU+ah+BoP8Wkt+sAZGqOWcrtzPJ6PTkkMGik2Fi5TMM?=
 =?us-ascii?Q?Gi2b95GL2nPRVDGA7XLeMaJEU4i+q7lTqPyuUfgFc+NJSJ+/Fq+pwXCZutVK?=
 =?us-ascii?Q?y7Q3O+0pG/O51JXPUutUaBrDBH6xCfdTZ5j89HInDVcGJ6C1br9XKb9poHdV?=
 =?us-ascii?Q?0jq/Egrts+0KaZuKNi8H2p1KhSM8IUXu+jwC3OO6B6L/57vJTFNRBhrZj0YF?=
 =?us-ascii?Q?SJVTEnJ7sCtXaBSFxDEX19l6lVRFpsugHPJeIyJeOtL5+wiuBryfT9HGmqN6?=
 =?us-ascii?Q?tbbuwNOX839mhcklem7OqmpAM7bJsqFqeyPych+vrBrjaGWPmCJpBMEJcPB0?=
 =?us-ascii?Q?kGMKernIjNSkfYV4r2g7XjkFmB503H44s/mNCCJJZutclDw4FMCgBoUH+0+H?=
 =?us-ascii?Q?/l1BYatLl2eH4hYF6DtqWDUFRwoKfYHAjq2a8GXX1wWo1QL/8FInUxhyjnGn?=
 =?us-ascii?Q?SjFHD6XYO1eTcm+JRZ8JyuN9MxgQ+u35WqvMw5PxhSf5mkaMc1uGkIXXu8yc?=
 =?us-ascii?Q?q7s8wUPHRvujnOuzo0ojdLSQSeElrDXbJKbcDRcL5ydTJHcBrAqSW0URcmGH?=
 =?us-ascii?Q?who5nVECgVLeaxNSF8fVz+q/a9J2cgseMFCmWQNX4JxjvN6rHd6bryui407I?=
 =?us-ascii?Q?GKvcg8B2sy3Z8ChMG35v99fiRCnkuZKupqwGqMbz9OFQtCi0ZllUbqK+sQfp?=
 =?us-ascii?Q?ia21tkuIwhwV0hlI0iGrAVJ5UUt+zQBxdIhWEdlOpTrUS/E1EBWFU2cJMbZ+?=
 =?us-ascii?Q?2wd8aWgq+2vYlzqHFNxHRppGFuwdl9CeuQ6RqGwfJM8HlC1JmP/UfATudNam?=
 =?us-ascii?Q?KArbg7B9s0TKAuE0zNdCz/0HmMT2b86WaVWVES3u+zW5WwkeiqYll/vEB348?=
 =?us-ascii?Q?zH4m1knprQf0erapRLKqs1MMcj2UUAFTnOVYQxMiYEL12tnprIOJixc310/3?=
 =?us-ascii?Q?F7/MEdlA5FDeK8x5RHE5rnihMiwttTTOFIq5hs2voDrB9EJhVUwQpy4tHgOn?=
 =?us-ascii?Q?84CBCuXG04MEwJz+7NtT86rQqNZx5dTLNVqHNvJlBC2PGoi2wdZXpc8LbYSq?=
 =?us-ascii?Q?mCrqrZdlM24wrgdPhg1dmDXT9+Kzhn69v+1lPzPiB5C7qGS0VrXnxsfojj2Z?=
 =?us-ascii?Q?/IYukA6ahKoy+C5q3noD3WCjPgyLkicev66xOiF8UOyqYUN3QE/Pp5d5VcR1?=
 =?us-ascii?Q?kaLWDSxjPhMCBW+US4qtDiV0e1Nsm8WOMwLbUpIwTLSFc+G5IKdpeByh9hf+?=
 =?us-ascii?Q?YSRSs6wPOPiHpPIik+xHzQiAn2aQSMiFYdlaFcZD4lJINcX6ixtwGjiZ0zPm?=
 =?us-ascii?Q?ogrLrA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36fe012a-a9b4-4f0f-f643-08daf551fd30
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 10:36:11.7065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HPpHbGhVZ7eRIKq5I5fGc+oVLdIjG/1n0414ZNb4r7XfVxQDzb8j6eTJH1PT0hAGMl7T4neeyUxie7NXWEUV1TxZJZs5L1eiIltdKHVV+eM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5206
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 07:17:02PM -0800, Stephen Hemminger wrote:
> Cleanout the GPL boiler plate in iproute.
> Better to use modern SPDX to document the license
> rather than copy/paste same text in multiple places.
> 
> There is no change in licensing here, and none is planned.

Hi Stephen,

FWIIW, this series looks good to me, modulo a minor comment
on patch 09/10 which I am happy for you to ignore.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

