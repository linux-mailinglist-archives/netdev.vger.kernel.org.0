Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24FF633C66
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbiKVMZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbiKVMZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:25:00 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2075.outbound.protection.outlook.com [40.107.21.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C9854B24
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:24:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ex6PbdBark7XQtT3C3AFn6knH/1oycyJ6qe+p1XQvY6kwRgFQNL9v/2HLi0BmEya9k4HBUzHlrXVz6crcx2b8H8jVGhAQPWEY68GjZlNQljSCo7r0mtYPs59e2WlC7+Dnas8h/4WRE/4vbaixUvlYLpfeU34ybY504wFTxXxQznr8gZiSQkdwq8nc4BQOTkrwwLP8TdXuNze7Lg7UUTO5rL1GuBtzd4KHe04euTnmFNpB4X3USoFbYo884AJmyhZyeQxPmC12wJLJdoyg9tMkj/BbOyq5lCGBpy2zCldCLKsYW9dpBVH5ltWRz1vk+5J5QfWnQ2EmXtR8M/ZQY0zEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uL2gNnqHqTqggQAFl86jmrpXhmDm2vh24QsoAoa1hJ4=;
 b=eDbR9HzTc4b0HG1P6rY7q/LauH7W4JdUiifL25WWO/AptiMEI6FxFHt9UhV9EVWrXYOdbS6anIUMX/lixUEk/nfqj/O5zCPPzDNcB6dBdOPWSnU/whaCko1v9xfY7z94dOb3eCGkhOHAUkaI14A9gVB4dTIZVUQrHKs2htZpTp9MYyOjPLboro4KKO09HPhAAvDMzDv11pFJpy7dnoL1doQfiP4EdF/6cuOswAeOMoT6u2YKqgGQ7wMql3wktVmk3wf+97Fd6C8pFft6WgETPtwb97RzLtVgUsfWrPriu8ObfP19T819rMbRRagnkpkYRMLQqUyB9j7GlP/z1KzUyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uL2gNnqHqTqggQAFl86jmrpXhmDm2vh24QsoAoa1hJ4=;
 b=ZD9FZNKHUlt9SQcWUZ2nmoyPkCiOh07OwCHTJzvFrK8Ugo5mH8OvyvIsvkD2WKKrofB+/uoy/RotMPSWo9I+Rty2NxmXUJmbDHcu2Bq9bxcdhHbaN+B3bV5j5gBtvNnxWtzULVA2YL8cuZ1PO0QVpXgHYIcuDic8FNBjouOlCyM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9361.eurprd04.prod.outlook.com (2603:10a6:20b:4e6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 12:24:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 12:24:55 +0000
Date:   Tue, 22 Nov 2022 14:24:51 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: Re: [PATCH v4 net-next 3/8] net: phy: bcm84881: move the in-band
 capability check where it belongs
Message-ID: <20221122122451.5hk5aw4q6mu6t22o@skbuf>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
 <20221118000124.2754581-4-vladimir.oltean@nxp.com>
 <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3yYo63kj+ACdkW1@shell.armlinux.org.uk>
X-ClientProxiedBy: BE0P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS4PR04MB9361:EE_
X-MS-Office365-Filtering-Correlation-Id: 51a61ed8-2948-40b3-1e64-08dacc84900a
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/G0+xenBSRfTpjWdQxj0ek0iRvssIwfK2yctJUAWXQAm0dTNrk0jBxKmmvKh7KMIKq71yXcixZVDljwohkx0TaullfKJ22gIqIgg9/FbQziI2M+czQpxEcGbDmuJmRm5OXcpsVc+priCVjUXJxI2NK17ic4zKiO8kMhkpG9F6mFUSAJ25GifVn/s3ZZXR9vQu8m1peRElav5pg9zvtzDMH06us5GnXN29OXkbMfzXEBhTbwN3BH/qINpRcI1ETQM+LOPzbPtrxaHg9fHTFzDr7Hr75EhF9QyvYVMJHKgosDbsIZUwd2dYzGe0C5HCfohelUEY3Axm8IJdRJf3XcKuDU3MkboVG45FxJKuok5t0Fp07Hx9u0AD0e/HORnb8dx3W0so09E0ZYvWgMCd1mQO9wPD1oXsxtDVCrersvt5F4+36lUWd7pMNA9cJCyAFa/rSA5kS6OsN356DYZxB71PvBuUXkT//34Ej/JybERQvvAsToBpY0jvHlO3sH+nQameeomZkcH99BdMCBhsI3dTrXLuzNfs4ImUJksJ7Z6A7PYZNEF1t/yQJpfsjJpFH6A35wjKKrA3LA19r0WG+YKu6sc0B9e/B2Y66QlxqiRppzd6ZX5IeIhwhHIYeetHqq/DkfmbzOlYKTMP+8o/HaYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199015)(316002)(83380400001)(6916009)(54906003)(8676002)(66476007)(4326008)(66946007)(41300700001)(66556008)(6512007)(9686003)(2906002)(6666004)(26005)(8936002)(33716001)(5660300002)(86362001)(1076003)(186003)(6486002)(478600001)(38100700002)(4744005)(6506007)(44832011)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z0Qjh2qxX6YwWiK7udj0tU5vKHsS2/mTfzfDjRQzx8uRZwlNX40KLt8jqBtx?=
 =?us-ascii?Q?WdAQIiB7XDeiOQ5rdPt8iKd6w8WFV/SDDDXBQjCbj97oIC2p1LJxL730zRep?=
 =?us-ascii?Q?VRCHfsAwXB5NS5YNfxeKKNNIe9kplyHPT3ZkEnse+GnsR7z8GuZENa9ObYEF?=
 =?us-ascii?Q?oj3IJIN/O4bo5Y9EOUhYrYNnedx3REquCoozNcsIwfchNEf7UDjsFbl7L1dr?=
 =?us-ascii?Q?eVQWu63eneCpKibpJlUSa1Fc9r96eSduNYKqCLjyiYeaPXvnYpwVCjVO0+CW?=
 =?us-ascii?Q?JeBW/B2MQ+0AL2NuUSpEQgdETxrzvlK5yBgwvzUOJs8RKodlOFzXx+yi5ku7?=
 =?us-ascii?Q?ux2SXfh5FK8G2InRasIPeKOhxVcQ9kDFKRgcuSFNhvC93gBXWyM3TDKFoHAV?=
 =?us-ascii?Q?+yk159UqKLc9rnmEWUp5Godtcvve7307LuisPASUV+cEgb/SQSXIX0r613fJ?=
 =?us-ascii?Q?ayRtrv1cJZjg007b8L0vg2WNPeyue6ayGmFdiQcspqE6bBJJ1bZfvTX2F7Ky?=
 =?us-ascii?Q?s8kzOBxYRt73h7trvqW6HSGiKXN/Sn4EwAKQ06aM8p0cFMvx5s11O5nP/ZY2?=
 =?us-ascii?Q?Ho/4AAyQJ+fmOPkm/ZJAYd8JWoHHOZvaRtAcsjCWde9vJDJzht542W7pX4J0?=
 =?us-ascii?Q?M/UFlT4jZK4JTSDCIaFXNxpqv9y0Npm3W3As2U15+X+f+E6Kdg2lRgMSr03n?=
 =?us-ascii?Q?nY4Fowlz55KsFkMbawm8ulhWOHpvG5OD4tX3i3lqajnEacVFu7DGOoAV0uY9?=
 =?us-ascii?Q?XGNtRbxv8Z8l6GBLpjyf3rr7r6YwtXi4FqIbKiS3h+nMLPPwOH2124pEZK12?=
 =?us-ascii?Q?AXTRxoRb1m6x+8gPWVOXbgtCiJNcDah5mSgbqGJ7jnG2YD6nBw2B9YowjbSa?=
 =?us-ascii?Q?rZK+6QpZ8qcAd7FDa2xJHu6RDf1QSSbve7zaMQ09BmPRgdq/IFVyd8DDJGVt?=
 =?us-ascii?Q?VGkAZudNXmVj8X6C0opF2DLntTywSe3Y0cvNmZw6nIA/eGh7hDBBffiCOUrQ?=
 =?us-ascii?Q?PWQQdFs6ulEGAaJtzt2cKUP8U3rH6/PXXejZ7WgsVwtxksO97U8gHvL50iPj?=
 =?us-ascii?Q?0+CoTEACcb8EI+QgxeuP/52Y962DQBQdEMB44KgWonCak811poULC9wY61zP?=
 =?us-ascii?Q?dvCH48oh+1F9nxJnb5eEUHsSSTSMvF1oNByffG0POFAcI1f3Ndxl+mu+CLhD?=
 =?us-ascii?Q?yQxk06vTXBTMzRXQyWWRPjI3DJhrzeIBgqoLUW+HabZBLJK3WYzEKjT3TMQy?=
 =?us-ascii?Q?CsRDUrc2dxpQ4MqN6qqHvzAn3VdKhNpAlVyj+vss/vwVLAMiBopFSfU5KdAU?=
 =?us-ascii?Q?jTQg/k1dBVJzn5YpIK3HABjGvHhzqwA9jvWn9Cx66TLo+oRZvShrHp0M9ERb?=
 =?us-ascii?Q?YnJaNDAsAKXb4W7vjVQPLpZiIfMs3hjKyV07/zCvmtFN+lO0eZvgmcXTkM3B?=
 =?us-ascii?Q?i95zgPIlBcf06TzEu1scsVvRlVSi6i8LT787EkhsJjLxueviFT9OxK8jwbTr?=
 =?us-ascii?Q?E1epcie+IcTYQ4pE6/oErv9kAxU6rEG6giqG3BQ6ecTqJjiEJQGZJnWnb0qu?=
 =?us-ascii?Q?Bc8ebVcLABa9z1X0I/t6yY50kMg9aSlLJJPr26ecXRvSaM/0GE1H+9sWrQhv?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51a61ed8-2948-40b3-1e64-08dacc84900a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 12:24:55.2552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gp0pyaGx3/Ff50n0gFUZLBiCMzP7HQfGlnIBXW+ya3qPyDaQjbMDTXjj3QUKZt+WwYieaBgEnX2HewdzPULv5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9361
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 09:38:43AM +0000, Russell King (Oracle) wrote:
> 88E1111 is the commonly used accessible PHY on gigabit SFPs, as this
> PHY implements I2C access natively.

As a side question, I suppose it would be possible to put PHYs on copper
SFP modules even if they don't natively implement I2C access. In that case,
if configuration from the host is at all available, how does that happen,
is there some sort of protocol translator (I2C -> MDIO) on the module?
Do you know of any part number for an I2C controlled MDIO controller?
