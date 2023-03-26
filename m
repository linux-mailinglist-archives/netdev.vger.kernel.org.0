Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB926C930D
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 10:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjCZIJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 04:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCZIJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 04:09:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2115.outbound.protection.outlook.com [40.107.244.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6168459E4;
        Sun, 26 Mar 2023 01:09:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTrYdPj9YkqdkMb7D0Mz9Bp2+3tjXFC0BA0IRXvK1AknljsF4n8w0h4IeVidPg7vxF2334ZrFV62WdFOS0D6AHHae6jL/4giBJfwt0g3RcpwIEW+ipcIa3p6VMP3HynQjVvfmWmfWIL6eGQMePMCPawF+QGHWe8mrReIXq3hCmwqJET1o99Zq6DkJPgrujB2dJumEU27I74BmBRVN1+/V/Jn80X5Y4f+K+aWtWjR9SPS/jpEJdtcG85lXgXnJjpPsx9f9kfdUnQuQq/KXce/IW7VKmARUQVtkbiLwngCgxLInEpES2/UVFxcvF8WX3ALKYFjMnfEzgAPPMz3ftfqdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+H9Zjxb8heTmGqk2cs/7n9cjELXholOC49SG7RhCJU0=;
 b=EEXf3HETunGh5gaTOgSv4W1Ac4wb0gyLwddTz3ohpLK5G1UD4bnBND8gfubVX7kncc9/BNfhDjkI0tTgYpcveGhF8uH3agmzlvk4aaGS2M45tc43dMIo/vL80HyOLyCLWd/1nrhbr+gUW2yNeKrgB50w+zimKyVEYzgiUv92Kn1UnHcld93xMrV8Ld62Git+1OgF/m4XG/iGPbQNTMBSYxB74xsa3t8FY0Ygv5xVNMKQlUf41XXohA6Vj4/YC/droSUtTIGpoi7MkJcjd+7hkP0FbqoHgCeHl99vJnCFmlt6VcQ95e62bf/u9kloY8jAidacksVZKFl+GwuUcQFaOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+H9Zjxb8heTmGqk2cs/7n9cjELXholOC49SG7RhCJU0=;
 b=RCfvjmbkvMB/CrdHcOkDZbDHtWYRCPNrFoco9V+DXl2jZA2xLgovGGbqCSYlHlxb2AD1/t90W+ehZUw8vFksggm7zYQSukgtEOYxaZUZDg+dzIwLa8SnBMKpJIiJwfPoWpEjQLYimpX2LzrDhDMPpD1DHl8WaOA6KCtMXBaTjqY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5665.namprd13.prod.outlook.com (2603:10b6:510:110::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 08:09:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 08:09:03 +0000
Date:   Sun, 26 Mar 2023 10:08:56 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rtlwifi: fix incorrect error codes in
 rtl_debugfs_set_write_rfreg()
Message-ID: <ZB/9mBPpFkrQoaxV@corigine.com>
References: <20230326053138.91338-1-harperchen1110@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230326053138.91338-1-harperchen1110@gmail.com>
X-ClientProxiedBy: AS4PR09CA0013.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5665:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f1c1c92-b0f8-4509-4ea6-08db2dd15cde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AR4/ppoL0HNTBjxVyRviqI+DNrFoonlmA26d8eysiFGrGtVPGa300hQ9DVA8RwkiKFO97xRU32bs289uIl1vwMGn1WZfuoZsmSgGgWh0fxmERcSX/hyOm8UDIJ7CjwA82J72kffrcsUzOQ1fkhObw9iuKTFqwtMUiBH+jJOTrGjh0WS+1AqEkFhBB6K5b4G4+jZabAXAvWYXyoa6rW402N8/oKqF49iIqVf99MwSs4F63Hr5mDllVB/qHH6KeaiOPlJozwMGAVq/KspvwpIRr3gEVPG9aWQU8b+N7bHplS1U2peZlZu0695ME72qQvd3Z0CzaLLhzkKRwdTPgN4By1HXPM9ZALuji1yXuihjJF9ghVhhGhQEdIkXdQGxi6dvn6f29Vx7dUhzvUCE6qmRY7I0Z2w/dLM/zI/sMryvbiq2BfOEwo2mMXiiWZqt81WtvxFjGhb6vChuynRIGKmlG3o3K7VI2EYTfGRArVJQIB4GbKlV6JoQ3HeJrOi6O2LqF91AbgsZV7OzjHKdtbxDd7/5nq5p7lymKz0EORQOb3ojaMSBf2VNvQBokRrPK8OR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(39840400004)(376002)(136003)(451199021)(6666004)(316002)(86362001)(83380400001)(2616005)(6506007)(6512007)(186003)(6486002)(8936002)(41300700001)(44832011)(38100700002)(36756003)(478600001)(6916009)(8676002)(66946007)(4326008)(66556008)(7416002)(4744005)(2906002)(66476007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VjNJr772ifhmEtNwTESKiw2BOPyj9qtbYbdB+t2CTtWa5Ac9whyyE8DiSjNA?=
 =?us-ascii?Q?Npzg4dXSUwc2kf32mLiA6s03R6KBflt7NXzHPv7tWWdt8obdxJZ9L9XvLSPL?=
 =?us-ascii?Q?i5LosFAPQq+vGZX8NqugVpP6AHpt0nSPAF17lkEzL29RZEGBA2cSL8GHKcEK?=
 =?us-ascii?Q?+FgQABTA1081/XNxGZOmBLDpptutTuwTfHYMdUOIuiWj5hP/S764IVUQ+3xG?=
 =?us-ascii?Q?W/O8VYsCkfbJvY2Mzu6fhh7EKXG2gbq2ZSNEQ5e8MvJBJthfCXHzoJgQfouO?=
 =?us-ascii?Q?hmoG8mKwmZGDilAK3NCaExSkapSvVQ62YWH4EhTWLbokgNv6K8rFLsFWOZlR?=
 =?us-ascii?Q?I9UyYXHdOmrcZbY4HFxSL+gx1tTq+8w0OwvUdO8lwdmPll+lTXM/8kIRcgio?=
 =?us-ascii?Q?yvIHWFeIChWB9D1Ltv5FADwMCAxsUpyC4Ma97ESVTRvjj2d2oj33fXvLe0NG?=
 =?us-ascii?Q?2Nj833vVniJSxkw3tE2SFIrHcpDc6HS6MF5T/mZhTAX5cp6z9LRuRjyt1SW1?=
 =?us-ascii?Q?op/C5sI4E61xagTY0peZxpKFkH/Xr9aeise7+VKopLp0q0Vz1wFoTXqQZtNB?=
 =?us-ascii?Q?DYOo8n8daPrUcXWl3gs1BtgKCkYOWt/cDuufmJ6AHcHrA2WW90lss2aGx+oE?=
 =?us-ascii?Q?rZoXF7I9yceS3Y1ifSHt2oCyRETEmoumonBO6PgZxEmEUB07JWVl0GbKc76t?=
 =?us-ascii?Q?FdwI9C3xEZNks+AMS2vUdXyAazGOSjpJzLjL1I/YMVbYeyBI9skQOFkdA8dC?=
 =?us-ascii?Q?B7Ih5cXLWLBJH2UsPQmAe4U2sFCBna4vlXRINElTnnSBHOSqsaTXrlhVSCgw?=
 =?us-ascii?Q?kRiIp4+TzKDGErDSZZubZlXvYxah1Rgc+N+nhGv2n8oDfAGIZxPoPcrNKflN?=
 =?us-ascii?Q?gi5JndFDhTxZc1Mj1M8py0PP+28LswQVwxbOBEEgLfOTR+tcg814k5Gteqex?=
 =?us-ascii?Q?FitRQ3inB7BwoHTvmifq42SwdMk6YTAq0k+7RJi24gZ7k/WAioiRuCYNvtE8?=
 =?us-ascii?Q?q3bkpFLetS/De5q2norcV6rMF4BuG7y2AFOQu/Moy722aT98JBooxBPFHmut?=
 =?us-ascii?Q?GAhwjDGu26CbmMnAT4B/lStq+j/wqXWwuq0Ct6tKRSnkYBoMKiR0h9No28bd?=
 =?us-ascii?Q?h4ed086SxXafCRk9tdYIs0uee61440RKOwhQ9JUHwM7ASXrChN5qCO2QJvb/?=
 =?us-ascii?Q?0NhEmzyR31b7oqa10KKO0xrBs7cmOoqeRE89EqEmi6Wio5Lb09JuxR90Lmcs?=
 =?us-ascii?Q?bqpm1PBouHhAFP+Px1jT8PEaXPAwUbaJ2kmT8bfaiNBLC61aL06v5D8lAlQ3?=
 =?us-ascii?Q?bnlzbilCFtm+PNl02nBvqDESpf6X3T5xXoo4BNeFUok4KIyJvqdmj9zEkxXT?=
 =?us-ascii?Q?MZYeVWse//j2OdAaXm4ZkEapsBGb5pHpVFKmNn3uO9uyGkhsZzK9yB7N3t3r?=
 =?us-ascii?Q?dmk+mrOVfBcjMYFLUGQMpwr0JA97NxZYmVXYhe7672/Vjdj3x5BdhovUZmUJ?=
 =?us-ascii?Q?3L8jvNSmOIGKc2/g1lTS/3crQ0vMeVuY1XK/vZQbKdZpShVUjYYHbG992I9F?=
 =?us-ascii?Q?b/MkF9mu7YVykYCYv7CsS8BV70QCA40GnLfUR8BYHGQGzXOfXwvjpmKsJ0B9?=
 =?us-ascii?Q?X+I+b6yHgY5TPdwHyVsv+3exRgbZMeIp4j6Aitz0e/Afu4IlhzLGDBpNYN5u?=
 =?us-ascii?Q?6wONng=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1c1c92-b0f8-4509-4ea6-08db2dd15cde
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 08:09:03.4391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +jnhLtzr4irpUdaLe83zNW4gJ50BzcX0q9z5+rqKpughk64dmTP82Tawvf3jla4VeP0vWdo4iW69ZofItCCfDndTl1RT6HCrk6BC7+B1tRI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5665
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 05:31:38AM +0000, Wei Chen wrote:
> If there is a failure during copy_from_user or user-provided data buffer
> is invalid, rtl_debugfs_set_write_rfreg should return negative error code
> instead of a positive value count.
> 
> Fix this bug by returning correct error code. Moreover, the check of buffer
> against null is removed since it will be handled by copy_from_user.
> 
> Fixes: 610247f46feb ("rtlwifi: Improve debugging by using debugfs")
> Signed-off-by: Wei Chen <harperchen1110@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

