Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38476F1FA3
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 22:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346732AbjD1Ur4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 16:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345943AbjD1Urz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 16:47:55 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2125.outbound.protection.outlook.com [40.107.93.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0880310D0;
        Fri, 28 Apr 2023 13:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTZohZDRKgaUDROBAsQGwETS0zEiAaRXHZHXQWPA0B7+CGK3IB08/6ziySF5X2Ur9LBZ8ZlWpig6BOhw1J1nEDLh/KfxM94RoHaMyktb4PpfwsufLfE08yGcesrpjrccndC57TwCG1HeDsm0XE/dHSbvwEMxWDs/I8e3J/oI6T+vFwvykDB22yrcgyuCx8h3QQgDQFPDLHVeDOD0DRJpw+aBlHOcOy6vAMZJWCySgEAtnkDl4XCR0mdetohaURrscPaTyXJKKHJTHca99DbUbo8xUohBeN69+i0ntAUveYwnpY1mtm5k+4uZeWeN8rpBrcWPdz+wTO+Uta2nn8RmtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+beufDMqvC05vn8TPbI/zB+ldU+asLHmFskbd2zy1c=;
 b=i7TNF0ihZnj/KxPr8LuphjOtOd1gDt7HMoX4pg+QMzisHxNuT/6f3onzs+DO8ps3LJeEPQPvCHVgieZrKMUUUj8rs4iUl9AyBcvOOLwdPksCrBfMrY87+DMXb9YGyECDgTbQEoqmLYvRFs4MherU3WtmmPa7YISNNrlYJmGIuOG8YcmqR1I0wi4Gl9ULAEZ24DmAqzAdkXQYs6eMLnTevStEIMnej+2xVHWt7TVhhoELYeFO2Y88oQ4SbphXJ8EHp8hAxGourqaN1CvX8utfYQUXVZSUohCOwJUCr/JlRZVNFnALY/MT07SPBk26ijE6ExAy8WKtVVTMdEHHe9L24g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+beufDMqvC05vn8TPbI/zB+ldU+asLHmFskbd2zy1c=;
 b=FsFHCV6rfXxm4niUPkKBQUHLkonyV/gMDpiXY3vfZnZuhm/ZApXIyWGIXQbz7RT9sCQIgFUSma3dUqclU+ux+lBny4JQKbnp47hjc1HfiAqjURzXFlZeJPJB6zGNhGZ5Qw+eX8Nl3zDJdZ5CMsXkYuYXOWvsAnfwfa19T4ZRyfY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5383.namprd13.prod.outlook.com (2603:10b6:a03:3d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23; Fri, 28 Apr
 2023 20:47:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 20:47:51 +0000
Date:   Fri, 28 Apr 2023 22:47:42 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
        andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
        jsd@semihalf.com, ose.Abreu@synopsys.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com
Subject: Re: [RFC PATCH net-next v5 1/9] net: txgbe: Add software nodes to
 support phylink
Message-ID: <ZEww7uBf5HYy7AqP@corigine.com>
References: <20230426071434.452717-1-jiawenwu@trustnetic.com>
 <20230426071434.452717-2-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426071434.452717-2-jiawenwu@trustnetic.com>
X-ClientProxiedBy: AS4P195CA0050.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5383:EE_
X-MS-Office365-Filtering-Correlation-Id: 40078d8c-c250-4838-f0a1-08db4829d4fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Wfb2ze+LjBJO0Q6QA6NsVs5678nJ2U0DhsrC75h/VRbY3RNqorTMphqGauLLvcoGS7No9hkN+FM6QZzUtBZ2T9sTDRjOSVdsU06TajhXpVO/Hr5SobmYKb0uO5e8X9VozdyZCXovBWbFchQZlaFXIcCjw/AYT1LrEQMLY2sw3Drx8g+Y3DqW0UXs9UAjVRvsOgT7nekIJhfPgDVdRL8auXKkD1pd7Sx8XvK/bUwpjSDLpi0Cz54bpkSH7CIB8yTR+I7AcAq8qWYXMcwObZMvhHbufoRitt8FY/gLJO33ftLjz6p1Fqql8WbCYGJm2Yy/xah7qgmw4kt7Pe038Y0gDFjvw/5fPSTDdKxfDjleAST3ttwPDqefGcDK7Ss8LGRzGDSh3q6ccRRSbEWISRqXAGkFS46Cc453qaV/HKVJ9koxCDbWtclWC8Mm4ifrKd3JaNaG5niRvDylKD/gR/vBq6SaE0jNgUz90NyI/4tAwVJJ47DT37hie/pSI15tuzw7LUr2iglzdgiABhVkOg9kFrVreWsyiY8rRV8rgOJgKrD8IL/CZXplDuMiqEL7EsDKAjhpH2sDWzbFF2be58SCOKFUnUnr9GS+uvUQmMljdY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(396003)(376002)(39840400004)(451199021)(6512007)(6506007)(478600001)(6666004)(6486002)(316002)(66556008)(66476007)(6916009)(4326008)(66946007)(41300700001)(86362001)(8936002)(8676002)(186003)(2616005)(5660300002)(2906002)(7416002)(38100700002)(36756003)(4744005)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oo+Q3BhSweYcbOH7UhEswbzHrjUJOdTPclfcUS15W5CTYe8WUCjFrEdgz2j4?=
 =?us-ascii?Q?YiE+nqcQfDyQC5bx3QXNF8uq6TPx0qpkd1bSFYjw7fqDqEpU/X9tIj2Hf8xK?=
 =?us-ascii?Q?gThY7aljcOYh28uxheLajjjoQFSKay6wUprHOpdwElTL7XHTySXZDlRxA5vt?=
 =?us-ascii?Q?f97ig1czByv9GLqqrpktgW6Ej+WLXEGt2vJmZCSdUhoIVXeF3fDPY5b970aJ?=
 =?us-ascii?Q?arJRVFJRlYHI+E+YEkcfs5R+9GIS5kXeKCuR8BLJ0j2fYN9JpfllAnsAHcvA?=
 =?us-ascii?Q?DDHvCUJctfgWd30fm0gNmh0iodhcGvR5NOt+CFTNXCKGukDgMicFDfdO46aY?=
 =?us-ascii?Q?8w2rrVM9wnmn+EvMa0QZwSamNOx0luKTPFF0aKsvJ/1R3r3njQpHmBkti9rk?=
 =?us-ascii?Q?GJKLEDJN1G/fR/alRAAm1e7CSOSzeX9uMb2HTSAbIoxNu9wdFRnnyOwzq0d0?=
 =?us-ascii?Q?XTdyvMZs1UyTDgejZN29tYOInWoFoi5zmcjnxyod55ztAiD+baCw5h9m1NIZ?=
 =?us-ascii?Q?GL73D1jzc5zVyLW0CfOsv2CVFxC1GFyiBTnpZp3MSNj/9FlEMC2d9qS8QipC?=
 =?us-ascii?Q?f0T0FPo8cY2EU6SQz+WC+pyiYnG4zB1p75meuyD2RQSGfMKy/rugZWmW7tTD?=
 =?us-ascii?Q?wJ6qCMqPQg3N7CTvAbf0LciMyis/KZa+jFwhLyog9ABCXJP+XaQh4fTAi2X2?=
 =?us-ascii?Q?iTJYQSFigp9hURt5Jk/8FIW7nkGfGXTkH5LojlMNRQofBWN48djvXejJG27H?=
 =?us-ascii?Q?S5r17+HgqYyIqYUE5frKiy3TAB7yrVYIKJzlLBf2D405oqq/TFhBkCbz2xR1?=
 =?us-ascii?Q?Pah1HJKU5i8nm8iTCsKp1bE0w9Pfe3GUvuDcfJCzmclcmQDsMsGxc0ts/iU0?=
 =?us-ascii?Q?YeFSs/XIHdWiU8Vatu8r6y5PJW5HxIKMKJtyhYWNQhzRvMUa2zISvSrf0LoK?=
 =?us-ascii?Q?BgSCdM29urrjoDPFqENKtn7bGAXng49BVOc1Glma3+QtJ0lOYcowId7a8quk?=
 =?us-ascii?Q?v88TsBpnc1LTkylS0YqRdi65EH3T2lU90ASeeKaaTg0HCf+5TRmo0uPwnlPP?=
 =?us-ascii?Q?snLTyIP/xnZSTN8Yef0xOnUS7zWWw6Vxd/MT8GT4I2cDV3aEouF5/i3KSfTS?=
 =?us-ascii?Q?7lqIplP/+ELciyIJoATlV7W6tlEeGrEWG0u7YWf8uvTJmL/czQL33KaDMDKf?=
 =?us-ascii?Q?G27SNj3VvS/s1YOt66T8Bl4v8HcReWRqOTtLfr22QSX2/VVdBFJVcSKeo0b9?=
 =?us-ascii?Q?6CSrkx066GYDj7d7hH6WdMlhTVCtALcJrDdrFxiec5MI8qzuw4if7lqmFi/W?=
 =?us-ascii?Q?WUZoUu5JRkauoRPJhctG6dpgbBOC0oYIDkr4qkl9wBYhP2lEHfcWTPwF2+Cp?=
 =?us-ascii?Q?i8v1k4yzC8+q7oJfHmPCeZ52KTknqq/viW7VOrc3MtuFincZT9tbAkYmeCMj?=
 =?us-ascii?Q?ZO/dsC8oUy+Rc9BMcFF29YkKe5hOapdMwVeLDqOAOjvDwvhjDN1tulUKTUK4?=
 =?us-ascii?Q?nGCfiH0K6pOdg6tNjxFA+o1n0S7EZL1UPML56qN4rDFaBeyrQAr2jAO7OdEn?=
 =?us-ascii?Q?N21gvFGs3728KTHWkRpmEb3YjCnDFuR0/Ql3btNvgHvGc+2ab8ZWcMqugreP?=
 =?us-ascii?Q?HGfAsKrbkHWNPoF0DkUpwVD4yZsEkiALPvUQn/LOaZlIWkkVXT2g1E9PxLWN?=
 =?us-ascii?Q?FMgiXA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40078d8c-c250-4838-f0a1-08db4829d4fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 20:47:50.9081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vqfWUYycTWnMRnWGQHvwPGnxEqvY4JBD43TaTNX/LBiDdutyilT/N2XgyQiqBkYvfNZr5oPlUzEZyMX99QNwtsTfZj/srYyEQxYxD3whkFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5383
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 03:14:26PM +0800, Jiawen Wu wrote:

...

> @@ -663,10 +665,21 @@ static int txgbe_probe(struct pci_dev *pdev,
>  			 "0x%08x", etrack_id);
>  	}
>  
> -	err = register_netdev(netdev);
> +	txgbe = devm_kzalloc(&pdev->dev, sizeof(*txgbe), GFP_KERNEL);
> +	if (!txgbe)

Hi Jiawen,

I think yo need to set err here.

> +		goto err_release_hw;
> +

...
