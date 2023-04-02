Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07466D391B
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 18:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjDBQpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 12:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbjDBQpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 12:45:07 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517BFFF03
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 09:44:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CqIdoy1IYbStisj5t/accus9cA2Ad0hxZ3VP7NCckJT/mgPI43bykkF+oJK3r1HNzcRiV3C7kw1ZjarhJPRFV5JF4mVG8C67l6UeGiJmpVP+Gpn+Ukpcwyn9aHsAySI+cQ6FyiONk28GgzZNMxYEUOg/yYB5KJ9ppgAIPQxxx6uG+1PmXcFBdZBdyrD+ZOMCedGdXOuTtvhzTIvMFdZIvZo9RTV83h4n8RoYzY0+xPfm6E+HOvpsfHJgNY67KAUfO7Rp/oTFDOpFmlS3YhL/mDTnrI1r8Cu3fiBOBANHh3yDLTKSUML6ffM5wmyodmmXEpxxSg5uSuhb/q2T5H4qEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tmJfFevFXVGiK6nLQtTaBAJl3p7MvaTSPcEPCc2XKQ8=;
 b=G9KTitCzF9ifKwaewVCLvSMJQXXWwQ2WM/oqP4xn1mR4qGOXc9TtK0We6/xfuZfJEu+dRR3g/ux8LNShEFrtTO6jtMe1ufvJLzPnR1nklXY8GEd0vl7fY0amOd2PnM/7UutevYQJPeIhXOM5ILlTl27sqYqnMEaBOEtyMR6vBMMY2IpNrQUjfJLmfZfvBBRmdz5L1lRuDa6xbQiFeY7I9Z/pgIlNb2ShMBReVeeUpfrijzZQ0kq0NsYfa62khnDtqsPtrd7AJazGwGlbifiiiZxNhD0UlhUlhKQKeIaVyG0fAwed5rcAbnfOJ+3wCTCbW2h2JQe98rBGSrA2fY8vkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmJfFevFXVGiK6nLQtTaBAJl3p7MvaTSPcEPCc2XKQ8=;
 b=H08ZqJUy+dNnT0s33bFNs39atLiCZl8bvCYRpvdF9AuAzvrPugZnltXMmb0CgQF9xgKlXmeVAfRfE/RhA8h3QlcWp+VYeybfsCgsI8K9t/U8dw9bP1TSC3sWFcw93kZiDIUc/L0ab6x4hNSFs/qHDlESFekrA4yx4t1N+9HKFxc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4160.namprd13.prod.outlook.com (2603:10b6:806:93::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Sun, 2 Apr
 2023 16:44:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Sun, 2 Apr 2023
 16:44:09 +0000
Date:   Sun, 2 Apr 2023 18:44:03 +0200
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
Subject: Re: [PATCH net-next v2 7/7] net: phy: smsc: enable edpd tunable
 support
Message-ID: <ZCmw077/2MNHycdo@corigine.com>
References: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
 <d78e0ee3-55b2-e2bd-c9f4-b8a88f31366b@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d78e0ee3-55b2-e2bd-c9f4-b8a88f31366b@gmail.com>
X-ClientProxiedBy: AM9P193CA0028.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4160:EE_
X-MS-Office365-Filtering-Correlation-Id: b1050000-5d5e-4f6b-6fc6-08db33997b3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: snE7L12YdwiuAsj4V+ADb/UIlpyoXJNBHC/kmrwv5ANVNV+74QzxGvJGFm4FBWGXf0Mdbf75F1IF4lB0DAMVHrItM9vsPotAamp9YRHuMSTbcraOVZoFNhGLxekULgSCBWzygM7P+CicxzIEoFblTQdYLJNw8whQOfOrmnhhWQmxP5/P6hvKMtyQxkNjwZyn2h09slEuEzqWfT15jyU8L5ONTnzRh8kLHywjgRmluQhvzRyjFF74Eu+LBSCg/Nh/IaxKXjEOL46gQHwQ70tgfaKf81a8+3zXzJHKSx5n2l82hJ2rcvjKaT49oTDmhia5VIUi6VLLuchhoGoGUXKj48RfWuzOdVXAc/Dh9ispHVa2ZEQLX+1NTQULikHMVdik0nLdvrTQ8WABnmgl+AyYwcjAf6aA4+czAxZ4o2vHxrkjw6tC6D2MNIPYY8/K1XpWqHsbePAU4QY2O07HjIoBZLJr5mrtonYR7oXNI9V2+VhmM8CmdQK9dJIaPrZYMDIew4Geg4Zm5KmHOqtElCvHl8dWW2733h1/K5cKmpkwx6jrkcTQkMjzFuDBhdMdNFKSNayx8afjlQkz6V/vyyObQf0T+ai15AXJEoxkg+Ugs70=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(396003)(376002)(39830400003)(451199021)(4326008)(6916009)(8676002)(66556008)(66476007)(66946007)(478600001)(316002)(54906003)(8936002)(44832011)(5660300002)(41300700001)(38100700002)(186003)(2616005)(6486002)(6666004)(6512007)(6506007)(86362001)(36756003)(558084003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3DixGYlivGmrvN6zg3X2uZBV1dneiEqGUhiTRlgui367q0RSpJV05259X1uI?=
 =?us-ascii?Q?W4HTKtwcVcgnj8AbywpMYnahabVNLKyYUTRUiWcZeAhKw/4G3eK6GDtNOA+F?=
 =?us-ascii?Q?gqk2t8SDckYMrkHObKBceZDDeex4mQx48Zr/s3I1VPARqM7dA+KxfgKJJpam?=
 =?us-ascii?Q?eO1CW/ICOhbkzzABSgvw8d7LW6LOYATLwiM73TOv4bG+5xNgOs3rudNmVTwm?=
 =?us-ascii?Q?BWlxBBQ7OM8APJ3gFO3CuSObq0Lx9dWmtiGnZ/enO7KBq9Ef4BWFyXX8p5on?=
 =?us-ascii?Q?ms2f8cSp6El5GkbX/e6DhlUI9hoHkrdleRhAGedchNGSQBrn9bBlcHMlX5PR?=
 =?us-ascii?Q?euUhzmnVKxRa/xNkaSoMMQkyCx/3RQjYU7rWXM61jEtsxzVntRJDydAAnD73?=
 =?us-ascii?Q?QGDnpO3tjHbRrRDMzJrSV54lORLZL3M9zv6ujHGbPABiJx1KwJe9z7wqJrWy?=
 =?us-ascii?Q?xVSms4ytNYhxsBBQgqPkYsazJocYBQGsW6q8nbb4bptj2pzx7iTVO3lgEeXr?=
 =?us-ascii?Q?Ru6HPFhBJv5XstDvHu6qJlTG7mmDX32CTRTngDWXIpAb8wCJfnbz3JGv9gFM?=
 =?us-ascii?Q?zcCFz1tW/TXUm/RzHLzAIjqkj48Rkbz5U/uow3X4I8UTr/r7p+ZadArQlpHF?=
 =?us-ascii?Q?zS8fWuHSQG6I0gCW/WEjDGRbkEuHol1vQpYAwvApAk70xfmmJYHB9zZxHbHV?=
 =?us-ascii?Q?tm5YsZigVnkbrKlc8smlIhcxYhMN33bPVLc1n7YbGTlLNwvAEqcerPOeW3Ni?=
 =?us-ascii?Q?URYy5LfDL2tqv2qOPS4XtjnGRRnXQzRRCUyAiLnvIWr3W6RrG+Jyhwz+hai4?=
 =?us-ascii?Q?lk5EkHxyuMrQP+Hvu+sUvpa9B4bE3aVHl9veWZqt2HOdk0ljmLoGuPWE2Ygz?=
 =?us-ascii?Q?5+sdMo9OxbyHCJdnTE+OFpR0lMqrvWbVOQ2dKhCjREgz77u+Ith//SZ5MqOs?=
 =?us-ascii?Q?aiKy1i9v0gQo/enjB7GNxGcSao+CAcFGx0Rs0JhKzl1j/tBdRyVMmEqLoOV6?=
 =?us-ascii?Q?jqL4ZP/FaAY3QMVx9eapdARbltdkMBGneeYK+4IWG8augLUQneh7Zu1RNeqd?=
 =?us-ascii?Q?Who7tgucD2LgIIYmqeTc+Zo3j3md9daldRQAvs1jS36VzAuVLA+G0BQXbvoP?=
 =?us-ascii?Q?dx2n5AwAgpmpYXcEAgtJ7mhX0qT1xD+eaWNlOId48zR8TTL81L7ai7FGAOt+?=
 =?us-ascii?Q?+3MxtVWWFqLfse6VCG8sUAJXdNgFVZhYGC3cF6TrtrghJ1jKMztad1YoIlpJ?=
 =?us-ascii?Q?S5Oo0lgODk3qlwD42/J337PLl/eRG7OWXmImwOayeMgEbMVwG88zYl4eup6m?=
 =?us-ascii?Q?Cuh3MHnPbrcRqRZUM0UIsXkovac93v5+ofEq7DzPL0qrd0RrfEW3tXjELawd?=
 =?us-ascii?Q?zCuVwCP3nADYaa6R8zdiR9kvtMaDIaS6ZB0nLSissooqvdzchp7/QBN6fJ1M?=
 =?us-ascii?Q?1xyxhj0rHlylJkoeHCmZW+PgC6EZLynPKdo38Fa3tlqHMSwTuL3B7zOypl8s?=
 =?us-ascii?Q?ra/N/n2JiSNxzwKuboPa1Bu72dIamxO+LCXlticZNwH8B9Yumc5duewoU+vs?=
 =?us-ascii?Q?YAQTvAbGt3wBukRQl/N8/WPfLK9LN6O/B9wmjZRaBNSENkvxC3rU4k0XI1a4?=
 =?us-ascii?Q?/h/L/vTfp1K9jgdg8frBny6v29wTSWgSJrhdVVucD1sJWc8PEQCE9z35GYiY?=
 =?us-ascii?Q?oZxR9Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1050000-5d5e-4f6b-6fc6-08db33997b3f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 16:44:09.5400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RpQgybbQYgC/x46JGz6S+HG/yMDZthTl3/LROuq3/HBTddkfpx+jHTR3AUbd6IPMNwLpBExKvxDGIsKXNE3OpQah+srXSobDiitkwfqJeKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4160
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 05:17:35PM +0200, Heiner Kallweit wrote:
> Enable EDPD PHY tunable support for all drivers using
> lan87xx_read_status.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

