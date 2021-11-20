Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0F8458070
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 22:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235938AbhKTV0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 16:26:41 -0500
Received: from mail-bn7nam10on2119.outbound.protection.outlook.com ([40.107.92.119]:16068
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235830AbhKTV0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 16:26:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dgzs96bvA0hBYBW1RxuU6SlkCdBx6oEopDrbqSyJ/ljfs2Hoof1d05lupRwpdgm5Qb6gu6zNwCxhuOQ60K7Vhwv+2LzXrRrgK7oFbxd8Hiju1s55DCGaTeg4Rsr7d1hPtDUA4+nrh7eBJPrFFfzMSe5JS0JVo1rDD/Ou1yVufeqcNIwo17JxeGHKVgzL7Q6M0Nyzvff93Oq6gMZqawk1IcwDn7ap+891lK9sbVZqIJhKGgueP+bYUc/i1yIwzmD+jUDdNM2sMLykE4tu4VAvdwoGjKiCGJgvf66gBxoPqotYsRLBXLxdYyuCYrlXeDQg6UxlORZJAqWxWfj6nsplOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UbA1feWGrDkBcweyG1IfII3/kt3MJBE8GFgcPlqsp0=;
 b=k4wfku4c9UuLcrdkeZ6V739R5v6nV44peFFuKso6QkmBuVuvn/g6Y8+ANpXaZTTBJARG7/NoheF1G7VIfT7YXmQF2o9yrZXIn8XHT6srXfw8EPvJjmYyjmNMcuScjCPIelTbl7w3Ep8qFJJ1hIiRzAPzSVcN8n6MMGRZb0B79Pt0muInEFpr+Sap86lmpkbJ2jHlMBewWSBgY3yxORMYVC1AE496S3l+EpnHmVwmULtEt+7p0QuIlVlIL/TngBq0zZJhXQZYXSLacNULWW94KE6N8Te9w+EN1Hi59EHs139wqJDcqP6WoutS2C+3ERp17QhLfKqv5atk3GJjZgCUYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UbA1feWGrDkBcweyG1IfII3/kt3MJBE8GFgcPlqsp0=;
 b=z2xF3o4Mvbrpx7PZUU22pazZX15AlCfNaptW/Lo4aPVb3gXvExSsF6yxk6opW65YrbTvX4nHQz01dleVr1lpYY9ZcKZp4TIod1Odnz1Z+sLT0+XLKb22i7eOzLCSfVgi6mT8Cfa7SGM0Jnc39gPBwuy9r+lJ7SL8qg4WirAgejE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5540.namprd10.prod.outlook.com
 (2603:10b6:303:137::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sat, 20 Nov
 2021 21:23:34 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Sat, 20 Nov 2021
 21:23:33 +0000
Date:   Sat, 20 Nov 2021 13:23:24 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 1/3] net: mdio: mscc-miim: convert to a
 regmap implementation
Message-ID: <20211120212324.GA2497840@euler>
References: <20211119213918.2707530-1-colin.foster@in-advantage.com>
 <20211119213918.2707530-2-colin.foster@in-advantage.com>
 <20211119195610.72da54d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119195610.72da54d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: MW2PR2101CA0022.namprd21.prod.outlook.com
 (2603:10b6:302:1::35) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from euler (67.185.175.147) by MW2PR2101CA0022.namprd21.prod.outlook.com (2603:10b6:302:1::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.0 via Frontend Transport; Sat, 20 Nov 2021 21:23:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2840313d-a88f-40c5-cb7d-08d9ac6c0107
X-MS-TrafficTypeDiagnostic: CO6PR10MB5540:
X-Microsoft-Antispam-PRVS: <CO6PR10MB5540D13DC9C0DEE088529C39A49D9@CO6PR10MB5540.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fZKW0fdbN2xDMHaIoy/uwkzYMKKhK8ez/zbA0kAoPZG3ypffGwaswzWEGSbpCGi0q+gkYVHRKhMqwZ7UevCA4rViKxQke8ZqZvz+fpx46iJex/CEZUdkljx8kLwywADjC3ZI7LZNrJSPNVXgtmzwL4Dvy4QDbuNrob2GE1/7Oq016TXyY0kOLJ60a61xphBqWiBENnNZgZA5/jNDDoiQfdlpmv7LUzQASj7VF+WDUJVUWi8B5s3m/KxhR8kw49rFk+IqweEHjT3xJ8V7gVBQiwb4QvLydN8EY3OC92DOnyIgZhZIsjP3VtOXjnTjw5jlSxsIDazG9B98HUZrmOCgYAtJR89PZphIVu/oBVDk0VkHIPrKh0TrdxftHfFM3dVtYJ0BACyBBvorITsqW9qr3iM8no21N3tjieZHaATCm2lwNTIUG4ezd+JykIBgU3ERBkqDBvzEqf98Tm2XiWvxq55yFvM3zkNZDuGRSD/rxdXW+v9+NVgImcQLR9mut9Svp/CoZtFoDmOPHtG5H2C6SCQhJJ3Nw+v861lEEJOZVdjtsWPvDTBvnxhUm0zQvQhslgFdYe9ToHOP8vx9V8AhazGcsQQGQJSmz/UlLyxnO4r0iIaZmJ89zTj0v+a88bJJnbqVyXvQiWmDqaJbdl5bmcvU9msDcpK4R8okCxSgmewElJtr1/qQVVSoYDwfKao4Tpj5fNlhd3iZeZQrFS4tcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(366004)(396003)(346002)(376002)(136003)(4326008)(6496006)(8936002)(54906003)(2906002)(33656002)(956004)(52116002)(4744005)(6916009)(55016002)(6666004)(9576002)(9686003)(1076003)(26005)(316002)(83380400001)(186003)(86362001)(508600001)(38350700002)(44832011)(7416002)(66946007)(38100700002)(5660300002)(33716001)(66476007)(8676002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dWk2HkuAhX8tCTxw0snGbZctGfCvxlVvWGMRsBQJTmcUqVu3/N1YpZKV7I0/?=
 =?us-ascii?Q?QIS+BYEz+EM1+9lPNZdl0gj93st/ygmfDfHt8O5jTW+Yu1LRFc/9ErgPfr/1?=
 =?us-ascii?Q?cvAZYfxCt8NQe5vo+ehfRSxzQFb+xhLadfd0ITr1o23dAq223tnbS0rtKOLQ?=
 =?us-ascii?Q?HwQIXBA+Q/YY7f4Nh4dE3AVppQfxofMfl3VHnEZOmIixsDnApqOJMoG6tdPn?=
 =?us-ascii?Q?KqkvfJwaVmZcnwPcpkqedFACKo1MHXqyi+JrWv/Zp+Y10GtxLK1MSXJQXVtX?=
 =?us-ascii?Q?atqpBmsQU3oeEjlrxqQbHz5SknRMBCWDOxmojPAyGxX+WUC1UCZDA6hknzyd?=
 =?us-ascii?Q?aZm0+T2xm3uh17tPE8oYX98Pl+f9JAiO3gVCyO5JRS26uLvyLtCwS+v1kjZS?=
 =?us-ascii?Q?QHMuu+WoZB7XOrzROp7gJC7qSOk75eEYjxqz3I5XKP0l5088lOJtkexsWrup?=
 =?us-ascii?Q?dnasliReTmT28ziBXRqXIe98KGmDBh4yn9AnXWQaLvuzm3tgdujskEdVqA2u?=
 =?us-ascii?Q?99XJZmPDBH23lQYZ3iiPzeFaJfD4VQg0KJH2MQhBdcZ2KMZgpumrbEHehUw3?=
 =?us-ascii?Q?iVFngGIqVPiBqJ64/YfVitjraSaeUPFscAQvcC2JK65tD+njPLFfyTgVFaI8?=
 =?us-ascii?Q?iX2CRRbJlKc3Gka/M/QmFPXQ+BUBCsChO3AZNs9yb9Pve4S/iHNbW1GX2Gnr?=
 =?us-ascii?Q?L8LmWiMgdWUMT1l2KZ1qVTgbYDvsqRNwOlFOENvc00HoQHG6NvY/73771eD3?=
 =?us-ascii?Q?u1aTRDBF0nagaf1UoukUQUizC9F3Xz5KNHNvEBhMMeFwETIykeH9bA7oGnMQ?=
 =?us-ascii?Q?lrjUR+o2uc0/KM8XKboZy3d4646iiQl8ZconK/WNd2SVgA/LXmD9iAaNrfSP?=
 =?us-ascii?Q?QmX1VCCItxYgUFM/58L/0XRIPYEN+A0FrfdjMJ2VUOrY8g12qxwFF05vg8i8?=
 =?us-ascii?Q?bxsvWACjuS5g8GqjqjLA09gx9J6rquSnjrd6H1zhwQ44KLaE3itAmu7YNrij?=
 =?us-ascii?Q?2862tQx6NocG2CXNIjLtW3vX6hsHeyZiU1XojgiTQ4nKrmIgGxNp8wvBp5PJ?=
 =?us-ascii?Q?iLqSMZS2R5agI15S5M9gGhS6GxAtQp1K+TZQERJEqCiRRlDYV49m+xKHYivP?=
 =?us-ascii?Q?xAqN1ocbTzpTPF5cBlRxBHiqIkuFlImc0fg1Q05s5M0GAH96nl0dwuWIplvT?=
 =?us-ascii?Q?KgKI1wD/DOu3dotJpsIKFRgP3FAeKl4emwMGl9fZkOom1gCjeUOXR0sUgRDw?=
 =?us-ascii?Q?7hKmF3fntA701Ea0hqSFRHQA6aW/QpKmrArKM2m682Dwk/0SK34BwP5lpGxw?=
 =?us-ascii?Q?w8mTEDjdkBSamw71tdyZVCUm7Bs574QVBdfuRFg6kJgRc+YD+enCeBqQl7Hb?=
 =?us-ascii?Q?2UTfKf+TymETxZQptQg1sPyJVIqdge7hfoIuzZNtjFriCQQ9pHzs0nzNI+lY?=
 =?us-ascii?Q?0AFk0E3+UuzEqNkoTeFGMgIvxZj3pi/IzurEEApJRELKUgaQpu0sCR4bKv9D?=
 =?us-ascii?Q?eLWOZfFmFMD3EqiImxxBk2exR+qQFitmN+ylcCOqBChq70svm0yMv5hO4Ybd?=
 =?us-ascii?Q?Oywg++wdncZH6ZdGisdbhuy1iCrZXRlnNfWGC+Ilud0z5vSPxd/Mk7toOeXh?=
 =?us-ascii?Q?XpLjiJWS1eaAtx4HquuQd79BSc6qrgw7nwnsrTE0VU/rFioCp6+rIetxvdcL?=
 =?us-ascii?Q?55Nig+tL78DbFYIeDyfZOw9bPWU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2840313d-a88f-40c5-cb7d-08d9ac6c0107
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2021 21:23:33.5772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LWpCb/QnrunBQ1gMN57tZy5EbB2fG7m/QFIZ1Ryd6bJX0VUo61TzdOjCKDPRK0C50XbFWhDJb5gKxaLfz1n8y+HrgmqKZ4hNUD0GcjQHL1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5540
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Kernel Test Robot caught this as well. I'll fix in v2. Thanks for the
feedback!

On Fri, Nov 19, 2021 at 07:56:10PM -0800, Jakub Kicinski wrote:
> On Fri, 19 Nov 2021 13:39:16 -0800 Colin Foster wrote:
> > Utilize regmap instead of __iomem to perform indirect mdio access. This
> > will allow for custom regmaps to be used by way of the mscc_miim_setup
> > function.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> 
> clang says:
> 
> drivers/net/mdio/mdio-mscc-miim.c:228:30: warning: variable 'bus' is uninitialized when used here [-Wuninitialized]
>         mscc_miim_setup(&pdev->dev, bus, mii_regmap, phy_regmap);
> 
> drivers/net/mdio/mdio-mscc-miim.c:216:13: warning: variable 'dev' is uninitialized when used here [-Wuninitialized]
>         if (IS_ERR(dev->phy_regs)) {
>                    ^~~
