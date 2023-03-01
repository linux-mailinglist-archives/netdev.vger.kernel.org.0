Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38EC6A6ADA
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 11:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCAKe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 05:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCAKe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 05:34:26 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2116.outbound.protection.outlook.com [40.107.102.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A94305DA;
        Wed,  1 Mar 2023 02:34:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elya0NLlhtB0Gz35oSHwPsT9ypIjfFEtTBrNwDaeUDEz3Ihc03jPHtg0dIFxKEoE5Z8wUsqvtf1SF7zlHo1aG5c1UIH6F5hyFfC4i+VeFPUvaSPEIfQlGOq8MWDX+kcQtG73eAcMavS6YsQtWhTE95LmaYAPJuarYODVwP9bW40YUEGSbI37RpoDWWA8IiQYw4eoRIlEqA/3MjOgnvaRh2wFH+gxKABiQXS6TJXKCDN7ner6AnQ4ENpKggcJ/N0nX3iAisafbVddUE4XvwbRnqLrfjJ+BuG7d+mT0YKe6esMQ8hh5KwsKWd6Az1UXaVwierOoKWlwLeipSwpa+b5nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVppVjdcdMJ/9u04EJXw6dfNfztQYQ2aJ/tkkKH+VX0=;
 b=TZKKMqETxlY3ufbJJmQpJkI3t48aX7Ff6SZ/FgcyhubQaZbUawLB5TYTe/4O8Yozy8NtmVX8/+/7aTUtk6Swk0xsrh6nzr37T30oBqV6Iqe2Ufsnyy8ay77nllI9EzZExvXT/X5HdtfjkxNrg+2uZcmzSDHc1gcN5XitkspWWSHv0cLT3sm8jbpFsU7AaywIXwXa0TiRbNTpe3CDrU97eGfeVRo7w/pHT8p/e4MXXOSQ0BbKhwxglbHduv/RPUrjUhKRZoXcj6UaoUwT9yFRkopyL/ExDdbIMDLim4/yuRZAw3P22W0S6yTrxmi1RR7f8753dL3SgTMUkWpoL0hwfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVppVjdcdMJ/9u04EJXw6dfNfztQYQ2aJ/tkkKH+VX0=;
 b=ZRSH94fzbl7hYSPSI6NCe3RHPKNxlaf5MJ6KxbxtOpLRGFawatNvUsTf26ktekIPfhvYsIAyw9NOIdY5+feowLVuffrac7P9CsZEVUck/PqWnbmc4WJYVnc1JE+R4UdDNhC/NKyaLMsuVhplRZLdwDWCJwCHzHJ9GMPSK5YOfZY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5517.namprd13.prod.outlook.com (2603:10b6:510:142::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Wed, 1 Mar
 2023 10:34:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.018; Wed, 1 Mar 2023
 10:34:21 +0000
Date:   Wed, 1 Mar 2023 11:34:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net] net: lan966x: Fix port police support using
 tc-matchall
Message-ID: <Y/8qJn+xkuNRpQis@corigine.com>
References: <20230228204742.2599151-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228204742.2599151-1-horatiu.vultur@microchip.com>
X-ClientProxiedBy: AM0PR02CA0092.eurprd02.prod.outlook.com
 (2603:10a6:208:154::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5517:EE_
X-MS-Office365-Filtering-Correlation-Id: 910fdbde-a43b-490d-590d-08db1a4084d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V/uH+sMGu4nUl11BTTHpaUlBZtXJQBezAVct0ccqGLbKMIa7q+aMJAW95ZjGBKp1nc9p6ARM0kbbMQn1oaM8tgJKLIHfceOvmwKB/0M6gFS56a0Vt33iMIGEOM5Ej+IrYPCdXPVaeBoSJEuAnqE49aQVlMaeGX5j5u/qlmsrd7wBnjBbnltBUrnhHUYMmjohL8PdmD/MvWYe8Y3FFZ0PUYjJ8ON9qn5GLpi3L/dmlgZfExjmLHR17kHD8EbxKPET3lfSPNH7VQ9qvvvXrqnx140Kt+5A4VUIx/1PnLprBDGtXSRWxU9gx1LHzaYKBD9qr7OctcsuKsCEwbV1KyAqXU2Lo86CzhlBEDxAEfzCMsqlTjNmNjA+xFwigR92u/g6JSiumzV317qPNKBTF805e0F4vOywZa8Pcj4BieTgmu0Zyuq/CJlJZuU+pVRaDS73H7M5RRwl3zVZU3MApzIFbr0hzIWeOt6XjLEX51/IbbLsbp0Vvdclr5c9JOuf1odp3cZClRBfrBqHRh+zxO/4IYDZKeL0ckhyY0liTl+JsXCVKMcG4uE9nhfGpOYTKSeouQEqF25Ab8vE5nX0lGehdBx+KW6yueugD1JYBeMGO1knFFEnHB84KYOCXkXDztqN982j2BkRQCCKxqC7soL/drDYrVGOxH/9iN/bNdGQlmraMtPliEOIrn9jgC2ptwPb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(39830400003)(346002)(366004)(451199018)(36756003)(86362001)(66556008)(41300700001)(66476007)(66946007)(5660300002)(8676002)(6916009)(8936002)(44832011)(2906002)(4744005)(38100700002)(4326008)(6666004)(6486002)(478600001)(316002)(186003)(2616005)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YrLBv/afkwHxwqrS3ZgjKJOzktm6WDrGjAfqPaFS7uw8VQgra9yCBAoDpNGm?=
 =?us-ascii?Q?vgL/HjJ9YcCEKjTWCiL7cTVVR4C41/okDBZW1caq5SqDn9mjOSNE0Sndwdiq?=
 =?us-ascii?Q?Lpd1ocADmBN0XmANy8DNXIWJsoWzxvrn8f4Le2+mf+GX45SSH/Re5dnGdHfN?=
 =?us-ascii?Q?1ECDovbui5UhTyu7lvioumMK3awr2SbteX6rRFNt+lU97fAvoRG/s7wQN77U?=
 =?us-ascii?Q?z2dZmOqpJpcxEXla5ZeZNf35rvq6AsxHwqooYGB7JYlnBGHK+fOaPcKZ5ZJ8?=
 =?us-ascii?Q?SuP5np5iSewVEw+7UrZgFWK6/dAk3B2HfwYQiIFZfzR+WkvDCC+X+X5Dbyz4?=
 =?us-ascii?Q?OsLEU0mRMB9MX6PpF2qKnkAHxhuw46mr8SZKjXiJ922vns4sbLFRMawjiggz?=
 =?us-ascii?Q?1vMa0MVfEZr1Vl4fbNE5PxAn7DNWcUAXfZgJyquBxYKsJfU247OI2nL3B800?=
 =?us-ascii?Q?zmFGxp7tnqbMmF5Uz8BBrWkX6G06bFhSqNpp4uzIGjIFBHKuzefuAi2lOwRi?=
 =?us-ascii?Q?7TDV3b2NObmKFzSO9rCk/qayKBAOzBXrbLCJoUuZIQzTGnkATApTMDI+ek9W?=
 =?us-ascii?Q?WjJzMIShcqQPYEnifSzUs1zTH4T9Iyj9Ti5kpMjiQDBUIXGBKMwFlnQMcbmS?=
 =?us-ascii?Q?e2GAAt9I5/XGwpXKbZyOpgJPzBw1GQ7Y00snpUruORB7k/ho5+EtwJldZZzn?=
 =?us-ascii?Q?dfLxUdjJ9+2U2pDNROoz3qAo/f3HhghApQ82a2Lq0ThpmCZGS9+MGUbwI+Ow?=
 =?us-ascii?Q?+xnuo4iG0S11dMycJ9x2nwMS4UJjl3uqg0SFzJTkBdLkSb9IbGyoxgJLi49M?=
 =?us-ascii?Q?vMnWyw+OEI8hfClSxTsRbZ+drreQUzmnLCDeqxnKx5ykCOehj1Cz/c1zENa8?=
 =?us-ascii?Q?89KvEis7xZpgTs+Mn8g2P3dQs66vQGT5oG3vG7bmVojpHa+K1zRlaDB/co3o?=
 =?us-ascii?Q?cHSpf+XFJ2NySp0NkTGNCVu0cbMto92VWiwtJZU/k3fdYcpYPFReiOMsc+zZ?=
 =?us-ascii?Q?ZSNqWFymp2UlPxBYiLDgUVT//+7Q+Z0qnQnf0ZaMyBFzoYlqNF2krGFC9UsP?=
 =?us-ascii?Q?fIILGebjbKpARV1WU9PuxTgkpcoWZHeuNhpJaZ6rygJjCdeOPYvvCUKaW6q+?=
 =?us-ascii?Q?iUUN+w0vytuZbjkHag/B66EaI1qzAGvr75k1MTN90U2CgtdSs6ap1pqaaRVY?=
 =?us-ascii?Q?vUwC+9cxfEUuugqaDk9mm35eOA9JGSymVfwQTLicDv/lLzEl9BEs9JmheVfa?=
 =?us-ascii?Q?giWojUZ3A5HG0/4a91hIlg4o8TIooYasVMIYkrn22rEtEaYs71B9CL7MknZi?=
 =?us-ascii?Q?9Z95KldRhJugL3kXku3xjakDKVuUbd8XH7Bl15JHlX+PZOlN+0gWoAop5X48?=
 =?us-ascii?Q?Ke0kZ5PKMJBntlkALmUTkNJUukyG+qwG2LANIAqDsee+hzIADf2vf6ldaCys?=
 =?us-ascii?Q?RAt1v2nzjRxla8SB9tUrk+3ra0l86YU1JnVBKnbVUxRLmg9V7LneJqi0UVqG?=
 =?us-ascii?Q?fjLndo3P/K6jTS1kLhg7mBeOlYBk0MzbkUG84DCN3KnmclCECIGbFUSnBVkE?=
 =?us-ascii?Q?o63nEcrKZnCfDVK8vyMJDAbzVGlqWQSp2OOdAUhKVCbL+/Dm3fuw1coPOeMu?=
 =?us-ascii?Q?8V61TU/Gm4uBjRsCoK1hp16dm52gLRn+7KXXPlfHmrpVMn/XVjtNkFVtt1C4?=
 =?us-ascii?Q?rf9ZOg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 910fdbde-a43b-490d-590d-08db1a4084d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 10:34:21.4047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Z00TLUgy8/F0o7h1u71GhWthcJh/lAD+nkyBP3g8XrYrBoIUszqYqamzXyOxulhNkj0T55QFAPn/97t2PZoAnNeyW3tiKhWJQ1zNwOYlno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5517
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 09:47:42PM +0100, Horatiu Vultur wrote:
> When the police was removed from the port, then it was trying to
> remove the police from the police id and not from the actual
> police index.
> The police id represents the id of the police and police index
> represents the position in HW where the police is situated.
> The port police id can be any number while the port police index
> is a number based on the port chip port.
> Fix this by deleting the police from HW that is situated at the
> police index and not police id.
> 
> Fixes: 5390334b59a3 ("net: lan966x: Add port police support using tc-matchall")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
