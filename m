Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5606D3901
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 18:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjDBQmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 12:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjDBQmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 12:42:01 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2095.outbound.protection.outlook.com [40.107.101.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F67CDF0
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 09:42:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yx9PB54Rr+9TKJM/3ITQCvMXyrU2VnK+3Wr2rOf3b74c0ueN/rkZSlOop853B46zk01lG8EMKWr/1VZsYG3gqAAPpVELsWZyWqdb9kG48WkZ32WblQm5a3dmdJBcNhlDXMLjo7qVBU6JIXdbz+5jT9gosq5HCt6UIBcuVUfU7oZ6uufP5yspXerMH+AGydUCv/E+ekOZFvtZGYZdlbqSDVznSei1qrV9dS42227OMp6CqCJmR3SeTohAn8FuNjvRkKuqpLIOBzgk3HrBfsv/pYeIN/pQT9Grb8cytonCAfdNLgirpzRbFG9FoNuxeYG01ScJ6RWiY8cUczKnw+Q4AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KpUbYc6xsMEIL2hQCklxsc5YGT1CZcyVIhdYQILofbM=;
 b=fCIVAT7RbXq7X7UX1knLr8az9WAV9GKogasjkzAI2HJ6kHRiDTJsYm7j3h+XAlCsEBNwuHJY2khByiGZSn1K859xjEqn1AK8x5oKttUGfRPuM+XAQwIj3nFxrWANGoVA/NvZMisuUHiiiYI3pQjAE12K6qknUym1/hve14I63GkE2r4NZipfc5JiRNlMjcXeS9vsfGsL6l7auX4OsPMEdfn9yFaIl7lTCZg2XDi3pMFgXzPu9eBm8qdtHJdO9qGbCdaWoi61dRPKp0rfLuJeS2X9qrEmQEqcP6NkgHnmKx+eRGgyw8xCDsDz7W108XqtH1aonUxS97BfGJh4HGerHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KpUbYc6xsMEIL2hQCklxsc5YGT1CZcyVIhdYQILofbM=;
 b=Mr/89DSLgVAgpKaSji2cM8nOciHJN2QVjukbME+H58wg1DhXVKYqvfPma+KRJhhe5mkzu4nKAGB0NOI34qUq4N2aTUfCeEdYC7JwKGL5JD5MmJ7qVrlNDH65mCFGm+wUGXsx3kAsfwALQkLeA91w6iSVg5bx/c6jZjCAkmGJntI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4160.namprd13.prod.outlook.com (2603:10b6:806:93::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Sun, 2 Apr
 2023 16:41:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Sun, 2 Apr 2023
 16:41:58 +0000
Date:   Sun, 2 Apr 2023 18:41:52 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Healy <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/7] net: phy: smsc: clear edpd_enable if
 interrupt mode is used
Message-ID: <ZCmwUKDSrECitk1h@corigine.com>
References: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
 <31386c3d-098b-6731-7431-baa761bfd16a@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31386c3d-098b-6731-7431-baa761bfd16a@gmail.com>
X-ClientProxiedBy: AS4P190CA0044.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4160:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cd84551-2a12-4a2f-252a-08db33992d36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tDP9Vt1LLxScvvOh3ZQVAH/GrJpCD8cc8dfOfDRb4R3rCkT4NVetci1iPxT903MR2Xb06wwcQ0GtoMiLkI6gdNS0r3ucNohE+FOYo03n/KkjUeg707spo3K9eAaaKkt8w0VpMpU+9H5Rf9YHpbcd90nShf4jqD8A/YqtNChbrzJFxvg2ulL1JwGkJV/Ci8uLo5vnLADRX2cKCbI/urOyty/S3I2+TjS0IHOAIdDy8LUdib0aqSv4UKpqBvjd7Co6xJX1MBfZ8Ol53mQ7uq0I9hD34xEdprsg5OWZeG5XPhwGVyZIW2/GpUNYLqe+syuw8jXZi9qFjA0QPOi9LRjlBg1n5hzBAxNoUonY4CCFB2yBdldpoXX7stpdQ40UVjg2wuZfMO7K0F1is4N4Ihdqx4m3AeOo2Jx9tFx5bLZXS198B5M6SxXjxrZ7IKH23P2z2m+hINiQhj6J7pkYy+9mCa/4CHx+b1ls6YnqdfZZPxFjjFCcJ7oixnD+rREFbwh9SFbIMJe2jgiIAHVx7T3fi0N6kgk0SgWCHVBbqb2OuC9/pUP1Bsj7nJ7ekAjR1w0lUlZeh4OrQxM4/zAii5v//nPT1CjJ/csnFxsHxl/pb/4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(396003)(376002)(39830400003)(451199021)(4326008)(6916009)(8676002)(66556008)(66476007)(66946007)(478600001)(316002)(54906003)(8936002)(44832011)(5660300002)(41300700001)(38100700002)(186003)(2616005)(6486002)(6666004)(6512007)(6506007)(86362001)(36756003)(558084003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n2O8LaE/8j5IvipT8JYlP3g4jDe5wOtnhJRDER+KAInJl4+p1CQE255MoQYE?=
 =?us-ascii?Q?9x+4PEld7iY73fTL2v23RsBC30HUlF+dBpiHizcZQX/iamiV14H1gltwLXyZ?=
 =?us-ascii?Q?MQxDf/EiQiaCScK2rbGLaF5qD3t824sj1XOkgyrLFHzA6nkXr38IdGAKnavy?=
 =?us-ascii?Q?bd1nTiZVvhydymkv8dkhQC475x5dOhqtJYetKNAIPSygvJVtQBsKXoL/UoX7?=
 =?us-ascii?Q?0MlRF7i2Tv+iXmQx6xOQz/26sdcp7Sf+1PElze4eHiKua/NLVIEFKn3Mn2E5?=
 =?us-ascii?Q?qEcY21oAHDfn/NMDlJ1j9GibKz/lKrDJ9Qwo9aYTgCMCgYij+gD4XvPbpdhS?=
 =?us-ascii?Q?Xz1qImgI76PWut7BTz/e3sFoVykRafj6sevb3C/o6Hgs2opLDgWt5bE7vBKH?=
 =?us-ascii?Q?byklS/6htuWM/wXNtzUSehDKtWmuK0N0krHBcI0OGn6W+WOPLNg3bDsBc6Zn?=
 =?us-ascii?Q?1gd36h19En7lJ0dsqUoGzl2D7zK8sJ+jtmA8OPVHJe7qPRmAh/hBCn+S1ycJ?=
 =?us-ascii?Q?8uHb1QbNV348AaDtxL7YTWBUjG3SFnmr6pBzHdMBzrNxcrqkie/vGHFicSTC?=
 =?us-ascii?Q?cnmCFyVeqVbt07gOrMYscwyuKHUNzDuH7y0Bs4mM0t8OiPXbpKk8PmeqJIaa?=
 =?us-ascii?Q?YoOPNkpmnerrFFWMAhOFRkZjGixz/zJ3wsQxD78Gjn+E0X5gYMIE76mKnNh5?=
 =?us-ascii?Q?PJW3keg9wUEQZGPmdwbtoM0p+QkEo9eWSetTBlpG24AoNBrfpf8qLy6aREKL?=
 =?us-ascii?Q?RuyHreM+HlHwrJv36ujB/HIgIj4pmCE3tEjkz5cqxO6EgIoMbqlZ+f8eNLX6?=
 =?us-ascii?Q?+UrscopiFD7O5gjiqg+hA3ieqxsYzmDMfw/vBvdVjO9vTH0P0DfwnNJ16RdT?=
 =?us-ascii?Q?OY3St3I2zQLP0gbe6FCHzLWPj2/edshqcNqXMaM53ztKSKlvwA1uN8vaxmsn?=
 =?us-ascii?Q?DuHmHstM1ja3N2l1YkDj4tRoA35V0+iZoJLvWR+lJ5ffJ4FH/8i/+FxqDkcE?=
 =?us-ascii?Q?SWp4AxunrllPS6H9L/jVunynEiWxyZEGZdqp7eSil9vcwXwu5623/+pCrNJ1?=
 =?us-ascii?Q?hGTbO3zcNbD7S1poXbwP49J+cvCw/gpOhVXhrbZG7UyMDBOrY1BmIA6uT+cp?=
 =?us-ascii?Q?2I8zqjWqf/3OkP4Q9OI/twyg4imXrj/Unqd7q8FQM+HbaN8KgcRtS3a4sPTH?=
 =?us-ascii?Q?WY1AvnNVMKwOpfbXnSCeF+hWROSCUJ5s8bs8jgjWvlVZ2x+I6jIWIfpHG6sa?=
 =?us-ascii?Q?0pkDiAujNTPPeb1TtJdIjIXekJZTkOnozZs4H88fch1w+5k6diGt86qzQ9cg?=
 =?us-ascii?Q?vYNglXDTlpt6UXemObyNT0BMvt2JvuaPGxpGIeh1ZtCm4nZGChhIdcTBZIM1?=
 =?us-ascii?Q?eG8rQGm453Q1CEUF4rFNacydmucAJ5LGnjC7PjKbbviTlvM9e66I0hrhac9h?=
 =?us-ascii?Q?GQVIxDDQfjf7BITGH87yVyGXPw4ah5N7ss/yz9XSgMACglFbUVd+3DDs8Bkc?=
 =?us-ascii?Q?N0C/OQlrE588CF8jZxF3swaomNzaIEtHPya3rT8OgXkFPJehNJ5d6gulBBOR?=
 =?us-ascii?Q?DtIR9imTR0B7E7HXc4YxKTme7DF0lrTO4KrzDsUHshWPD6bjTaPpVMWgBHli?=
 =?us-ascii?Q?DIXsehfdRfHJ56z2hEEbtHcC7NjTyZRAkVMG6MsQmH+mhNmi1IEqr9T1p3T0?=
 =?us-ascii?Q?yp19OA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd84551-2a12-4a2f-252a-08db33992d36
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 16:41:58.6034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 14y33GSTAWkvTKMTVxUQJy8AXxGf9mdWq1ZZxFMmO7ww3uO/K4jSYWEgFDxKOdulRMkmB06xFLnrDW36jS3J82VYGilXaPYZvS/laEiqIzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4160
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 05:13:05PM +0200, Heiner Kallweit wrote:
> Clear edpd_enable if interupt mode is used, this avoids
> having to check for PHY_POLL multiple times.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
