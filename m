Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551A36BCA6F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCPJLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjCPJLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:11:00 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2098.outbound.protection.outlook.com [40.107.243.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E37A3756F;
        Thu, 16 Mar 2023 02:10:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeVYc785PPk4PvFyR4rvcbcfRMnC7sk12EW7MAl4ymgE3tMpk5QTrWMVPuGKJ8kU1LEF02Ya/2VAlfSR6rDWfcHlNtJEJne4o4/8KQoLf1jdeq6Kv1M90gjhjSnswoim8etpzfh1RudK3/SzT7xgCr7pGKKBgahiA4NYj4xwoGFJfG8I1bymYjTmE5ZPfwpiL7l7vBpyYOtRtFmm6k3dYl4J7CV4zIekSG76G9gszjfd5YatJTCHhJpe3Lg+HrHb3htJtnT+Ll8hWgqB5nk+gx23zAgjDFNzhDONfTA96ywWplcq1s4/e7OuiJcHtZs8Ad+XSdwLncGliajE1kFDIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLbg6ZXRUF4hoK/07iphLTFz/0GR76O5ePsZPKv/gNw=;
 b=XHM6JtZB5xhP6etFaBeywWOR0mHIHTH+fDv6SaTcAgS/5EnCtbK6FlWgSvDm0Y11pu0qpkBrP9UKKv/YWcHxRW38ENnQ67sEu5CdiNfw8aAICYUK7F/yzhHYsZcsB8nb5UV4zyowDrrpKZAGFbGmbdH8PsImhKSPcOa/t3AjT7LUiFqix0Tu9BM3LY63lX9V5d2y3ND+468yp88CogNnyph8iS+igT/CtTwSxXrreBUt9r+xCKtFFSlYm6L6zPiMtCk7CneVGsHcYCVs6cPdeHJxYPAg9vNWezP4+pD34V34o/eqIGWf0kcTkZ2sPenHZqskBUY3T05PyRgr7BzQAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLbg6ZXRUF4hoK/07iphLTFz/0GR76O5ePsZPKv/gNw=;
 b=qLOUNhbtSRrUF64b9+iD6VIUnwYcKuJA8IWcxN/BbSA57ugV6VqGXdunqUPcC2RXjF7NGUXNgQqYMyAZo660gA7qCG+4fX2CDQ/NRPSmyyHTvSUw9SAyKMhjgTP7rrGBXB3vwIchdq20BTctkLef60ZuGjwuvgf9TomcM2x6hPM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5112.namprd13.prod.outlook.com (2603:10b6:8:11::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 09:10:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 09:10:50 +0000
Date:   Thu, 16 Mar 2023 10:10:44 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 03/16] can: m_can: Remove double interrupt enable
Message-ID: <ZBLdFDMf+2YoRK6H@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-4-msp@baylibre.com>
 <ZBLc03OYJLLhHLNj@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBLc03OYJLLhHLNj@corigine.com>
X-ClientProxiedBy: AM0PR02CA0123.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5112:EE_
X-MS-Office365-Filtering-Correlation-Id: d4beed0b-4ff0-470b-d5cd-08db25fe5673
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WdJQXklSRrdfgLZ86BloPytET+idJQ/GLitoz9dMXbhE8LQkgzQeP23sOxDkXNiTGsb9aa92Y8mYT93lM57/JQTjBPoDhPqvyE55F/CGQsETXwfSAdMkkEGu6tp/R43dwN/cZ72/HbiodpnhFEVbP3ZUwM63zRTw5IfmErNlWzWxQrMXqmi99V6P48oJE9rIUMDYmjUWkD44KFGokaIq+B8yadqvinI8dZDMHCHuZf65gaZPDKocgTl8LHxcECfu/i5tHSZaq8JGyNudRARM8796Vp4v3rYE+rkfW7J3/ZZbYvS2ZymDOyZC1L6rTYmAp5gh5uY4IlpdhRsZAzGfqUIsGMXIBslKRSMcOaajDiS94GxLZHgorbiPWKkY6n+UVsQ6MAu179z/TrzkMKkjN1FELQbZTM0nHxgFosbP70B/S7J4lrE2/uctD1Q2TIYJ7Md3ef4HFRooVrdTEFsHnd4zWShUHWY0cOtv9RLdvZ3QRXESg+pYNijzjYnJ33oFKh1bHtWn9yXy1r9jSmbVBMLaAt3P1qXNtuEO4C8GYYtB464RRD7r9B+cLvzYON67ewni/D/Ec7nPV+Qiior5cLatqDr/uykmmuyITlNJEhzfC2sD4bZqKvyQ3np76gIo2c+c547KYaSADMJlMcDp1KUREwxyEPo4G7AAs/ChVk8uAywDZQyF+/72ALXidNwr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(366004)(396003)(376002)(136003)(451199018)(41300700001)(5660300002)(2906002)(44832011)(36756003)(38100700002)(86362001)(8936002)(478600001)(66476007)(66946007)(8676002)(6916009)(66556008)(6486002)(6666004)(54906003)(4326008)(2616005)(83380400001)(316002)(186003)(6512007)(6506007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0wgDLgV6cg3kO71bkSKw21rQPRdwROz1ls0mRD7oMEUv4MAL/dle7OsPF+9T?=
 =?us-ascii?Q?+ajajWMqk3rmUgdababm0kxniuvByiELremaCTVp61M/6OgCq6NzD5cKtpXp?=
 =?us-ascii?Q?+uE2ZIJqlbzA8Dm6avJtFFbNfuxiEYdR0fIIycvCVpvv+o+7LUr2v8cDzUXz?=
 =?us-ascii?Q?++OAOBtXHoETw0qRc5C6n4ia/SIhEeY0di7G+LAlFm+LnXP3/98yLy2DqiR9?=
 =?us-ascii?Q?T3yJIMNKGDIW5lb7dYox+U8szSegih22dqnEEjk53WDYPCRnLlYFvIJ/ZGWj?=
 =?us-ascii?Q?hZ8tzM56wqRtILrzGOzj4CfAjf9hN/AfX2b3hqYgb+ozhmBoUQK28MuNpiO+?=
 =?us-ascii?Q?ZccKAtSjEUMs3D9HGEgZlF+DUVB4tZ14B+0kAo+bEpc9oUOZtSHaO1qof+QN?=
 =?us-ascii?Q?1kdCvLpM972Q8SR/mViiOxUVU0aknY8LXbcEppDbEcKdbqVyc5IbMOrRm6QE?=
 =?us-ascii?Q?BFIcke6XLXhh58YrCzqAtAzbfN6y0mLjP/zj44k+QfjsIEhTr5GSB0vSYfqw?=
 =?us-ascii?Q?Vl6M/HoP1PTSyfNgPFNSCYzrTQvt3N+elfndJuBltXd6ygdX434kfD/ax762?=
 =?us-ascii?Q?36Duhvkh2iojuY/F4gm/fftcYdga5iFOfRlD329ttzswpCd1bk8SSAZc0MJZ?=
 =?us-ascii?Q?53LnA9hV3+sVtvxo2FRCQ74QwumTQ0GMmD2kXNZeKpZ4fid7ddLKpyR02O7z?=
 =?us-ascii?Q?A0YD8nXAgShxrInBcjnFJx2lXnMJgRKhswrYNZj+dMDnt7EuFrQ+0vmH2RGk?=
 =?us-ascii?Q?JZOMhimcTXnQsAWNFWgCxuSexevZvqYR8QYXZMWmkETeFXEKORu4doyUWpBf?=
 =?us-ascii?Q?ptPReHdjPAYmzG9lI/KLf8UkxSx5FB1Pyl5+TfzabLJaSSSqG/8OjmXSzhaK?=
 =?us-ascii?Q?cgFkq0yDBj8jkF/Bj/NJZhIFcb9NSST9rfiusmIm+ZLmBK68iCvmwdohan7A?=
 =?us-ascii?Q?vL+jLpw0pZRHie7F9F6fFYUjJRcdDPD6OI04DGy+ZfA43CqoG+mv3LnAPjZY?=
 =?us-ascii?Q?nibfl/1/ErGZrNFjPxe5jqfy5wm/th/JkY4913c6NHkg/y6+IWGg1HEjyvd4?=
 =?us-ascii?Q?XMZfCwLYu4wx4JCjoth7G7cqpVIxzpK40ag9peaTMVLv4EvbSBR+cH12O3QO?=
 =?us-ascii?Q?uLDOEMUgCdf698cSRDcuB4ohDG9zuvn0knR0u15ctlUkzPj4hN02Cr1NvULU?=
 =?us-ascii?Q?kYh4VSJMSJZdKWLzveZsP6VV7tzGjox+83/KH4IQH4Qz1P9ld3Zt2s25ykIh?=
 =?us-ascii?Q?urkchm64dCF+npQsYuKWqxLcAjCGv2/njVx6gb4F3peLsXv/ZKu23miXij7W?=
 =?us-ascii?Q?UclRD6YEPJ6lWRvF2TqPpBQTipHi86xDWIKUuKhQBdn/wMzPvmsVYEU1ub2T?=
 =?us-ascii?Q?iGJYAA9FDima2MKDdX+fwwG691pZCS0+G0wW1B6/hNgTNk60WQCRQHFz75TJ?=
 =?us-ascii?Q?7eTJsIL61SHtFrdtjxZ/rOb4mA2te90k2rVOYk7gmK1t+nVvy9RMjgu239fu?=
 =?us-ascii?Q?LHAwcp6s2HmO4bCKr/n3v4yiQELPqnma2/ldAzj501pmDlVs6rQjT4n219ie?=
 =?us-ascii?Q?Y9OJMHt9nawqQBzwUS8Ox/1NpaK1tZ9lkb055hIyPWZx8OiQRMUt1vIbw5jk?=
 =?us-ascii?Q?EvQG8pb6rkox9AcmbJLhFYJp6bY1PUl73Hd5BedNdVuk/cGCoEf0SSSjzFGZ?=
 =?us-ascii?Q?e6y8ow=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4beed0b-4ff0-470b-d5cd-08db25fe5673
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 09:10:50.6659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XNQxhWCXONvxhm9Ig8oR6JAJx9oUCz9vwgBsfnqSbrWtjzb8T0+Q4Osq2v9ulP3/C3rY2zMlFJYkiIQdyyjf53/C/OAe9CVRQNlCFJBrKbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5112
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 10:09:45AM +0100, Simon Horman wrote:
> On Wed, Mar 15, 2023 at 12:05:33PM +0100, Markus Schneider-Pargmann wrote:
> > Interrupts are enabled a few lines further down as well. Remove this
> > second call to enable all interrupts.
> 
> nit: maybe 'duplicate' reads better than 'second', as this call comes first.

I didn't mean to imply this should block progress.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> 
> > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> > ---
> >  drivers/net/can/m_can/m_can.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> > index 8eb327ae3bdf..5274d9642566 100644
> > --- a/drivers/net/can/m_can/m_can.c
> > +++ b/drivers/net/can/m_can/m_can.c
> > @@ -1364,7 +1364,6 @@ static int m_can_chip_config(struct net_device *dev)
> >  	m_can_write(cdev, M_CAN_TEST, test);
> >  
> >  	/* Enable interrupts */
> > -	m_can_write(cdev, M_CAN_IR, IR_ALL_INT);
> >  	if (!(cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING))
> >  		if (cdev->version == 30)
> >  			m_can_write(cdev, M_CAN_IE, IR_ALL_INT &
> > -- 
> > 2.39.2
> > 
