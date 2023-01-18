Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CFA671B46
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjARL4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjARL4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:56:18 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2136.outbound.protection.outlook.com [40.107.96.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0278B5D938;
        Wed, 18 Jan 2023 03:11:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGmaNbpiUlIm1pWMZv6I0tN/FIk/XTAHuQq/Xj5uD40i5bCs3yYH+6iG5Sncnyepja5zUNvpA6w2rk72H6j5golY1RuzKe428nUDz7yToPVMkNTfpm7E2UCTPm3jPSJaDLoUkCU16nKUUzEyvVfRVyXk8f35IhwQZfQwQjPQ0oGfix+EazUur75SKTEXrOOdphNMnrTfDLXwimxROkIb5aZuJWuVrV5j2biPXHLDBqxnou556u5VxJnEmVi4xHFRYS/o1lXgtfybgEu/B6ew8Ig5xDVXG7h660jHNsh9TgH6ZMpFGMvaRARIJIYCJG0CvPkBWt+y+61KIW9ifJRk3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3heVJ/tTUC77oFBetaxgLyNe5g1p4EX7655IGJb2GM=;
 b=ea6nuj/+WUEFjODdIvuKp0B92lGlYQLp+0NbLaF9yLP9/5BDzO0GuDQjcdI+Ts4ek5Ef5lFrP5wTyhctQ1cgSxOrnEI7rNaNDM/icLLh93zm1rDMMFfmT9kmGk3pCsUNK/b+nIA4m3UoXeMa/BYdi11Wg22OHVwQKJNie1Bq5t+qzB2WDi02oBYJz3g2mmohzV6KKWTFqIH/Bn+koozEkFOCETvSDLE+IdFYRL79Pi2Dtop7CZLSvNAGE/4Ma+MwSr0UVdGiUpN2kQ+XE7JpYBKoP7BGibpJb0PZs1FYrrF0yG9L5uEt5Xw8grPS48KgD7y+7XmdSh8jL4uWeUb/bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3heVJ/tTUC77oFBetaxgLyNe5g1p4EX7655IGJb2GM=;
 b=MuMu5MEt/kZNN9mujs+2UM5WsKHmk+9bKxmht5TRdE3Rtz/7d/zhiwV1qGEOaavxW3fmPA83vK4iaFg6XQi44YjIF+omEArRxByVcuva+DC+eYHJVYk5u6oNTWRqTs7pbbY1KlEdbEW4jBuiehDmFpy5lDo61+7cPpgEl022Kr4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5603.namprd13.prod.outlook.com (2603:10b6:303:181::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Wed, 18 Jan
 2023 11:11:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 11:11:42 +0000
Date:   Wed, 18 Jan 2023 12:11:36 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, bjorn@mork.no
Subject: Re: [PATCH net-next v2] r8152: avoid to change cfg for all devices
Message-ID: <Y8fT6JN5uHtP4Pws@corigine.com>
References: <20230116075951.1988-1-hayeswang@realtek.com>
 <20230117030344.4581-396-nic_swsd@realtek.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117030344.4581-396-nic_swsd@realtek.com>
X-ClientProxiedBy: AM4P190CA0023.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5603:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c94d8b8-9c0f-42e4-8f04-08daf944c761
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gREc9r+J478ULYI5+T9WZN5TNbMUnE1ntH0JnElOPV3RyG/8KAxmzzeDqcQuK7n1DHk8ywtrBGlhTmhMZYpn55Ylu/1bcDAvn6+570UOvRDcl4xvRVqU0m8byxC8IfdvyuGBJN5fc/44acj2YIl7qk/BuzxKjISliVqaGjmBLUzw5fl8VGy4Zymd+HQtPiQ4aMz6LwKbA5Z89v+zIzi99IfGZlTT/oYoPUmTRhNw/5pA75TGOMfpaKd7v+nDrd1DoSM1fLKKx5ZWpy1Roa6ZWDYfN8oqDmKU9eU1MZvYDa05Lm+Jf1kdFI6TCewT1DAg7ZxhCX/C4ukbBp2nKIX5NOjkWS1UJhQl8tre6+Zn4Wu2lzsZkxp2pcxxPiTYfUPLEdGe31CeBevqyvvjlxao6axHZlkNHaVh3PZsHl4Y+2noItUZkMQ4+w94iPpPcaRCpJjdD9BJV3DcASnbaFP1FuCz211eSJiDy3gwr0+bLqFpbytP7cu+NbDFx2FhtBOql1tzc9lCLu/uf4RD8pDTL/xFtEltk07Wdx0CwJlgkDBpjfY6rEaGhqR2PX0mTi5BEZyrfHEUExn+5O4ExX7r4UQqvG3y2pbTRzadWSaRQs1okok8iaR3e0LI7BvV+82vsy63Ny4iOlvpGkE1qegtZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39840400004)(376002)(366004)(136003)(346002)(451199015)(2616005)(83380400001)(41300700001)(6916009)(316002)(4326008)(66946007)(66556008)(66476007)(8676002)(36756003)(38100700002)(86362001)(4744005)(44832011)(5660300002)(8936002)(2906002)(186003)(478600001)(6486002)(6512007)(6666004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S037WAUdv020xbSTpWBtT4o/Ll20WjxTXcgG5+grMFU/oFCbVqrWLBXtWoux?=
 =?us-ascii?Q?4I6K6rNiYFWXxdFaQOJZM8jVnyurW735v3dg7GZE56u04mJC8ewLo5eVKkMA?=
 =?us-ascii?Q?MFXqzbjrrUSYSF2sePU4LDHu8LZalYLn3eJO7tkWR/penjsLJz1JOdgIF5kb?=
 =?us-ascii?Q?zhdRSEjqpb0GQQMhajEWwsPnh33oICf9/7EQyQEbr+g1hPVYSzrFvP00lWJJ?=
 =?us-ascii?Q?TZmeIcbdWw4hHmtHtw8OS7rCpzEUs64lvot55MPV/wjV8r9csbkNQH6o3eEn?=
 =?us-ascii?Q?s6BZiYjQ8LxJVMWLQnv3E2qpsXMPI336Sm+OFFvXQ2QhVKFoqDfZKBgb4nYi?=
 =?us-ascii?Q?WOBi9hIStYtWlJFGVTKnBJ1FiYo5dvsQczP3BHdsWXXhhbmyWEzq8MloGgs2?=
 =?us-ascii?Q?y2aBvbLFOySxon/QTpnDQn8SvAbxhTBoB1blpxnuHO/3yo09zmyTj7vB2mdP?=
 =?us-ascii?Q?Vp/m/Szl5wkTbCxJfnqbZRbKY0+RpQ6hsvnQ9tqJWyGpXmrAwgVzrSifEhAF?=
 =?us-ascii?Q?b4ouCwRxZcxvGDTS4Bc88m1bx8cGOD8D3ZwLbPJ4sEAhQk0HKAmKnb6mnDNw?=
 =?us-ascii?Q?PK8HiLxxSbsdHhLcJSk/t/etXSBU+2TY2zZGZid3dAm+eNdfUzsMmdagKjqC?=
 =?us-ascii?Q?n37xHAqyDyEFUlBlf0r85j1MwKPBPzO9xtV1uKc87jDyRHqRQoJBM9U1hSCp?=
 =?us-ascii?Q?QfMPxeXaOcRbWGxWVPGgvLVPsIKE6HCohnxqJ8MRSLvetOMYsqiZtmrYj/yM?=
 =?us-ascii?Q?+CHkI1ZJRNIQFNBkucTO2yLAgtRLdYc+r/Xc0hPqJKdO28XYsqqkJzjkRtxK?=
 =?us-ascii?Q?XKVdXd3y+PpIJbyzyFUru8uZE2o0vzde54P5a6xtfhyiGXzx0ZQnkaGyIUG+?=
 =?us-ascii?Q?XOOd7ulCtPAZxMtLWz3YJUL0NOrgFYV46BZzORU0cT63Iy6I1BBZz1o7NEYx?=
 =?us-ascii?Q?hALronjYsEj95jdD4CNZddFzqlwuMN4FOZHWP6sjNOX7MhGNFJWgIe0cckV8?=
 =?us-ascii?Q?YNE01Lx8PjMEF8GUKI7dtxBpcpTGHyO8/yNC9At3HFDdzhzA9ZFysiGODR1Z?=
 =?us-ascii?Q?VPkdNzDvQmgjip0Mz5GpAEZ1IDu/s7+pjd14Rz4sHNSLMaFKc48GP74qf/K6?=
 =?us-ascii?Q?q6lZWopHgogZDBn4hp+u147o4ySrHwUUnRaZ5qEYi5AxFxK6bzldxc7auTlz?=
 =?us-ascii?Q?5a7jJFI4F2AJirXLc4fnW9LIKW+5xBOnxGL99OHkmVryx7bmSYDCDZ9fwuYO?=
 =?us-ascii?Q?dmy2zvppyY4Js5wd4qyFSLtm3qBnF701CsvbbY6qqOWbj+xdKJYVpJkFQEP/?=
 =?us-ascii?Q?XPFTskpn9sG+uBVFL7ZLazqrQD3URYi+YtLHXKYYLW/jIhKUiiSsFxAjdVm5?=
 =?us-ascii?Q?3dnNdat6abLxDeE+FX28axXmOJmbMM7Lw2aAsaasS4mOvadMH/T8CthTouDK?=
 =?us-ascii?Q?h+dRybNunnP6nacPSPkflayFIKJwvQYRvkabss923gtB9fNu4UKQRhJWq1yD?=
 =?us-ascii?Q?n1SNMctDMfwUDvj6TG8wCggeTpAL3kBEJCLfUBlwbaQnFcTlTOxwtmH5dWPn?=
 =?us-ascii?Q?5TxfgExGzBhgJWIG15O+K3DSp8iy+47vHrss/C0FjSyiFMsBmETQf89Yr3KU?=
 =?us-ascii?Q?wR1i0w7nvRmDuQV7KJfOwsDLciSHbs8MAKJfAKpYJWd+1JPNKQdiaYoVLnlH?=
 =?us-ascii?Q?KPNzdg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c94d8b8-9c0f-42e4-8f04-08daf944c761
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:11:42.6373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D431hk8afeA/L+NLEJXsNa45fHaeqfIgwDnzEKbNNDeFeuOk/bxXV+j55R87nakLtPaGb60yRzukBujdYK5hmgnxHw5mi24GUz0z/pctZcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5603
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 11:03:44AM +0800, Hayes Wang wrote:
> The rtl8152_cfgselector_probe() should set the USB configuration to the
> vendor mode only for the devices which the driver (r8152) supports.
> Otherwise, no driver would be used for such devices.
> 
> Fixes: ec51fbd1b8a2 ("r8152: add USB device driver for config selection")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
> v2: fix a typo for the comment.
> 
>  drivers/net/usb/r8152.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)

Assuming that all the versions covered in rtl8152_get_version()
support switching the device to vendor mode, then this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
