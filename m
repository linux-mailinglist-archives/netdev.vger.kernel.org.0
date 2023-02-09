Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49396690E8E
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBIQn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBIQn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:43:57 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2117.outbound.protection.outlook.com [40.107.244.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06805D1FE
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 08:43:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFgxmwTSrLJW/Zk6NgvypDtL3Po7gXKcYo3jpIMMdVnsyIDh8rkfdn4coMFHSewK0lstx15mENe+diTw9Yc3rUF5yTWVIfwv4sM8Hq+581aqwaZYkjOn8piV25Z6tv00RgWfjk9cHCvQuRWvjLnQDxTniYB8DDmiSl9jQfUL8grj3T4eNLrdlenIUEO9PbEhPnABekwky7/IWZNQ96Yz3ylQhzVU438i42bCJ8oo91KGq7v5tFUFlCcdOJkLSC3EKvn51du6lT0npCfEAnDl+EfkMuExdrdVZEC/kTlyrCshjE02bz++yIzAhQpwJhY0otNvlwPjEHu1X6H39d5lCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ZmKHk+iUutZC19fu5ZJ+TaFiS2BqL6oeF1kqxORaUY=;
 b=PFyGa3waStkkX7YvwkqFDttviURHyWaU3lf0D9J3Fz9p1aVE8IVhFgSdw839JvKlwCgzBsTpbdCz+iOH1FXvO3fZgWXqDdxVDT09bi9ZbwrVsIaU8pTzfxO4r6ivJ00l4puQwmZja+4P/t8tcAae4AXShyPIZfzHWy4LKNf1jE1AAfv4QA6oo0UlPOC520Vz6Z+/6/Zty/b4BOqvMDxGudwvr0lLRumgU63yd+35CGnbWkOAT0YXGubnujo3iyYbfBW4+mYZDg39wwNdA3v/KEGNRQNdjEx2LBWbE+GCPM2c2hIggZo2r4cI7WGPLJ9FBhWLF8w6Z/hvaOpszn/61A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ZmKHk+iUutZC19fu5ZJ+TaFiS2BqL6oeF1kqxORaUY=;
 b=ikccgc8oZIwhoAZo2nzoeYxtaNGJJzH88UNAwVI/NwBvfbUdPxbBy4iMW4ofsqX2XMLQXkzdVVWSAiIvPGo0ISydh1yeMbaqMh2nB1ja6CxXjjHLg96bYhtVXQe0sFJd+Ug/sEHKoY39KFhylDtWVSPMb1V7Pq/2iS9mTMY80Qg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5361.namprd13.prod.outlook.com (2603:10b6:510:fb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Thu, 9 Feb
 2023 16:43:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 16:43:55 +0000
Date:   Thu, 9 Feb 2023 17:43:48 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        saeedm@nvidia.com, jacob.e.keller@intel.com, gal@nvidia.com,
        kim.phillips@amd.com, moshe@nvidia.com
Subject: Re: [patch net-next 4/7] devlink: use xa_for_each_start() helper in
 devlink_nl_cmd_port_get_dump_one()
Message-ID: <Y+UixF7fOxNaSQmS@corigine.com>
References: <20230209154308.2984602-1-jiri@resnulli.us>
 <20230209154308.2984602-5-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209154308.2984602-5-jiri@resnulli.us>
X-ClientProxiedBy: AS4P195CA0026.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5361:EE_
X-MS-Office365-Filtering-Correlation-Id: ef64b9bc-0ac9-4a29-5203-08db0abcd51c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +S+PWn1zDjzFZNQCE7VJDRPBND2vsk4UgRAtvOfVw8DhRoL2eVHF3yDtFhWENiugn4e6X13Ydxd1VrM/jpaNI7KkhtqZ2e6WI58LRSRBSR1yen+KL8Ya23PrIbOOZ9R1F8SuL3nTD7NfLpIqbjavdMBOAPTkViO71L+NumiNrTg11dLQTneIuYleElchsi33I5TUztT5fU9GCgEKsTK/4gOrqq0q4umnFucprr/AxkRZok0Wqz9mjE5DotlYGABXh2Q7WL3+v/mRHBnGR2TojFx8uj2QEjJn/cAiiQmRK/H8YVYEPZqRl7oujf4FewXS9dP5KdROcxsYoZX5Qnihdrs9FMzRWmCpf2lX+aEepe4fSSPdW/mLa4rpSeTnlU3CI6vOOqT7mJ7J0fm+mAedAL0DsJk5Cst/MDwhUoQbk/vvJRvPsNnhLHrjUkTZq5tcA4nDkFyu1T4MdXHJsAwnUj/jlFFlJwZCKNh/TZVAkIjjHgFgACT10n2RQ3wPwwu8pCUl/aiA6n7oTXQbckRzP6vkrckPpWAnGKkKZsGF5iCP82ipOM4PUQ4YtrUkj10DxV+HvnDIKhJ9xU02Jk76QsIwjkGbi3A5T46QuqYBAxTlOPk0yI9IY2GksRtC29C5olTQZVdTPD6hCCNtdKHPoS9hvTLcl2XiAf7+YSSl2czDyxPf3yCSI6RakbbM4AM8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(136003)(396003)(39840400004)(451199018)(6486002)(2906002)(478600001)(186003)(6506007)(6512007)(2616005)(6666004)(36756003)(41300700001)(8936002)(316002)(6916009)(4326008)(86362001)(66946007)(66476007)(8676002)(66556008)(38100700002)(7416002)(4744005)(5660300002)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?14PPtNyINM1fkXiRaQGXmeUgp/jBV6mxBV5husGT6OlF4g4V3VgIlYY5bvNP?=
 =?us-ascii?Q?FKvtdi7NGal8/3y2IwatlVV95mrrvWxn+cbnedFIhug/0JxH54gi0FggvsuU?=
 =?us-ascii?Q?0RvA/7vVEzgCtr2mBFtYZfsM9+srFJaojm17Dzv4KEp3t1pvTGgEyaO1M/i4?=
 =?us-ascii?Q?pnTQLCFeVPjRjQeUqz7DBU81iPoda5BNY6qL/sV8Fl1peoCIeKvwI1E3HEew?=
 =?us-ascii?Q?zyZdAZvkY5jylXc21GzotGqBoOHJszKg7N59EMrxbi60ER/28GH+qoITg3hM?=
 =?us-ascii?Q?6XymNptjf6sInFCgvvU6zJD0IZUbGwZFhmrCSsPkQmEuSKXMmBOl4eSMtmTh?=
 =?us-ascii?Q?AHlqN06Npjxjv0JcguHec5U7WhhpnaFakD9EWXl6cBjpLyghH2jgIOb90bBC?=
 =?us-ascii?Q?iJpAGRhP+OIfulqCp3oB8UKsA6XJm2NXYTIbOBZPOCk1NQsbIuBQbwSB4l5l?=
 =?us-ascii?Q?dCCtTqgN/3xKF/im4VbgCkToejXuwEXQ+F7ZZ7K3xkrVCAgmooZ1CeypoBLQ?=
 =?us-ascii?Q?iGpF0jpbISUyCBSwSVbotT6Mk+yuTQimMJbs67U3EMFp9rM8tGL1jv9iDOnU?=
 =?us-ascii?Q?2BV5by0wVZGcWmBQdHaUCdIs75xix/iAWdgtTbjkkX0iqRqvBXKrz0s1t+8w?=
 =?us-ascii?Q?rer7FgATvmcc8+plxXZe7NholDBlrBN6BuqfYmP/pPqyIYxldjdlSjSPo5yX?=
 =?us-ascii?Q?6jkC+8RcJRBHysnC3E+ZzwQDtp9dlj5tKYuXluLIY5eZQ3UyIZc6U+cyJ9i5?=
 =?us-ascii?Q?uh8G534mov4ATm7jGqSvKGxnZFcT1L7kmXYt5WrIr3XtyNuqLmqsnqQQmXw+?=
 =?us-ascii?Q?/PtDg7EvsMNAZA7ut4InLLD8Jrq7o5wyuNUSb58XqRYji1w9/q2wZOl1pV15?=
 =?us-ascii?Q?InnD38LEyWjiQJ8t7T+4dpjA9yuOol8VZVNHbrHMkkxfEmaTFWDAuMelOZjH?=
 =?us-ascii?Q?o3QnehM0Q70OhuLX8MBSIpxeXz4Yp6EKSQCpgCeU4EUWYnepoTg4h0iLg1SD?=
 =?us-ascii?Q?PNX5KESSSJ29Fb4lFs/Dv9GS2fgJjti1O03F5H+QE1r8RbfWV6u/W29zakUu?=
 =?us-ascii?Q?a4eN333dSpuosfrX9EAAhgrr3wrGV7TegPecBu3AtKifNdbfvRUq01KPNyBq?=
 =?us-ascii?Q?hU4ljbMz8PtDGrHqMlOCOQ3Een8MkKmqm2wF8RGtpSDqrQ3BYiOkL3QDP/gx?=
 =?us-ascii?Q?eQf+ZyBr/4eYnPqXJV0pdBgEAPDna52MZQoYkb2LozQbv2YaWwljzJpWudK5?=
 =?us-ascii?Q?6KKudABBdxNLz3kTUMT9vGPX1LgciOyXinUYdswhQU8oDMXcwE9SP1mhKrIm?=
 =?us-ascii?Q?xeontoS+xyCFSnT+4FWvLIgoi17v/1ppmCV4FwEh6GJS0n4AtjJM5z1ys69Z?=
 =?us-ascii?Q?ThEWpyuQK9f6lu7yRQAmdMsCceOL/nerMXKMUfTdLkEsnrfs5wIwEqAC0uJO?=
 =?us-ascii?Q?+yqVEbkz6ksN3F1W7gaQ0v0dJq5hA3qgYqRmln5hppN/Kx5O6QeaiVvgJoNY?=
 =?us-ascii?Q?7xKjXBtGLNPLbwhTkNXZP9TPm4x6IFEothKziUgMfQjONZIzF4+mSp/oLmwT?=
 =?us-ascii?Q?zF1csJ0NWnOviJLfi2sq8cP04a/3iq8rz3FkE3I6K/GnM+1zeJ2FQ4G0+880?=
 =?us-ascii?Q?2nTy1QBHExEhonxEO/GXdID1FJJCUxL7Atc88fNc2PLDIYN6vOWUUVHeYStX?=
 =?us-ascii?Q?vxyYKQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef64b9bc-0ac9-4a29-5203-08db0abcd51c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 16:43:55.0308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iuEd5A9vY4t5J3y0ab16cIdNeI1BWTJYtM15DopzTJ5Sxe0b5MaI/43TbIHooFbJNjtk5ruT4C+wti8IWchhnavc+pbrkoBdfYreL2hJZsE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5361
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 04:43:05PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> As xarray has an iterator helper that allows to start from specified
> index, use this directly and avoid repeated iteration from 0.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
