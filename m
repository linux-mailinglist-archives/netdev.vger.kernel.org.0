Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773B64DE4C0
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 01:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241602AbiCSAIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 20:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234310AbiCSAIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 20:08:37 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2091.outbound.protection.outlook.com [40.107.223.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7422E6D46
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 17:07:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVSvFhn9C9g9YxHd+Fe/dmbAVd/qOl3xD20ILNt5x4L/fKm7jEQnfvclgUJjSHk78OqfNxHtG5g2VqhDiqbdhvF3ol4RjOqed5kqAy8vbSIjKNr7b/qR3YHSPE8zTzlzv8JhtegLsnLSru/9xJbJPp7hKLsmvrW9JlxGAUAGxx30fIQq9/jW8ERIgdWMnm86XEccmuiYKD2IDTHXEx52bxPwC/dVQvWWdNAV3plNdfRxz/AASzjdsMR/vvb5K5ReLEO2CIcyf3QouGYSFPkHd0cC3ztOByP0JHF0/T2c3p9L6cwASppaqCgPEyYjAadjeOywflCeif2j/jNYDWOnTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hdrrV0FjSI0wQRuhRTiIo+Rg6fusxHqHIWbRSgjVxX8=;
 b=QJOMuZ0G00giCYVWzuUs3h67aftz477nrKGlFLHQOuJ9c2Jp0ZsG794Y4Zf2VjG2AawMa+YUv2pC+J64KVG1eTfgSnUNub279FORSPIIZWMKud0OpdWSGCQc5rLVckps2KpyQXZ7bX/t6w/8Nd9044BfejjCDjGCS+tG4h9mqROo8p46O+0PAoGWtPAZ2tk4x/VYX+iCIn+ha5/56Kg8Kk3dnShvKtVudWO3iF0aPx3b2PPv8/BnElDv+Uxtoa2RXMqgfkumaZMqpDne+tZruhMOpH5gfaep2ucjHtWtAPMRsv2zs607+jYQIn6Rw3xjlPWkwHabYYY+17ULhHZdnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hdrrV0FjSI0wQRuhRTiIo+Rg6fusxHqHIWbRSgjVxX8=;
 b=DVOZFFnMIKw74hT2hOEYK139eck/jFsN1gny61OtOdGHiR522yS5uRGjN7weyIwDem5J5s/3STnMBwxVpDOddbgAuUCTOAGG/vtf78dIaCh+yKVMaUlYwBu+45eppWplA2REf0D7D2kwMJ0mxgqdUpN2300DhetT/T+iGWIFU/g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB3952.namprd10.prod.outlook.com
 (2603:10b6:208:1b5::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.16; Sat, 19 Mar
 2022 00:07:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5081.018; Sat, 19 Mar 2022
 00:07:12 +0000
Date:   Fri, 18 Mar 2022 17:07:08 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: dsa: felix: allow
 PHY_INTERFACE_MODE_INTERNAL on port 5
Message-ID: <20220319000708.GA929848@euler>
References: <20220318195812.276276-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318195812.276276-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: MWHPR10CA0024.namprd10.prod.outlook.com (2603:10b6:301::34)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbaf554e-dd22-4db3-62ad-08da093c6afd
X-MS-TrafficTypeDiagnostic: MN2PR10MB3952:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB395272A885726BF502AA03FBA4149@MN2PR10MB3952.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k4RVeFsU2nSX7aQsI5A2rbAkjYNeJGrH28wgUiUNBU67as2WZ8SWWvISlSsGQsAbr715tS9ooCVRYgfU46BQw+1FVqxS6v7xMUBwwPXhgy7xI8yCXs+VeHDXYvCrsASpVzm6dD4I6i68WYPf6ImX7vyXTlQTnmFSx6vDYgyTURM9+nmtJ0oNhEbhDu9JgWcvpKgvK+j8hwQiHgDKCASh3tSqRuj7Q0fXhF8a+v36UKx6pUJbWjpcy6mZuU4shUEzzme6o/KUbbnab5dzbLsdsqRayzkfYIAuMDXS7g6qfdNwkkXpG8qdBDjXhVThhLYEJJHCFpz5jEcPuwIePKv3v6/WQ1GuNBd6rCSv98T+3u3L4ulOD2NKoEijGb30WfAdorSIIRjAwtlccMrJWuT2l3Lm30YTc41c1GIoeU3jUr5fPQbMdI8rGcyATMT68lbScchMBIIIEzGQEoF4Yu93Uehh0wmdq1iWZ9mlgbFKXjgEr9JwbpuQtVdQw7ETaRHBK3I1j7OnImLuSJeXjtQP36R12QOTzhGdpwaQRwqcfVkXa9CNrIGyHN6VC4GxPLvLSk/ZpRapivy3pwOInDPxZoF9/fpwiCr8ZhcOliiNI3RzIQqwUGIHtw4m1OaHaXziIuv/qg5JYqpUxq75kabNSths/tlHUuOO23jn6w7vvl/+qR/GKItU+hLgoxge5xgbz5PXZ43MtABl40EQIi7UiaTVVLDviChpmZEOAAlOtiBDgwGttYGRWcEvVF6oKEqIU4kEGqtljpZcg2fAqnG6pMSOGmacrlSv1HzE0ISW8eQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(136003)(376002)(346002)(39830400003)(366004)(396003)(83380400001)(7416002)(38100700002)(38350700002)(86362001)(33656002)(33716001)(44832011)(6666004)(5660300002)(6512007)(9686003)(316002)(54906003)(6916009)(6506007)(52116002)(2906002)(6486002)(966005)(66946007)(4326008)(508600001)(8676002)(66556008)(66476007)(8936002)(186003)(26005)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IYPthd+nt6CcRUNyMFs/ZAG1KznFT1u2RoXBnFRa7BOOlF66nUxVaXpjzrQB?=
 =?us-ascii?Q?ZanJRALRdcPK8N/ZdQJv8pqkArArF6Q1GUXLdmHJchakCP5AJrxAEJjmmP17?=
 =?us-ascii?Q?lh9ZJtmTNM2jNhrnTYNQuFhT7b02yFp+nSKVghVPFA1iWcp8cNVY7jhrfX9R?=
 =?us-ascii?Q?QIoSPXcuAW4Z+6ZXjAw09ttXCmL261u6y0k64JutWPyybof5kz1YRAfel9Yx?=
 =?us-ascii?Q?0rEQehjwNsZmqL9QRwYvQzM4F+3uDJZYSjvQ5TgRWEw0rhRBRU6aLVWZG9pX?=
 =?us-ascii?Q?yZ+z/S1bB8q8Blbt+dL8qCeg5REAyCPaCGiofoKdAFUEUkAQ8OPAMbmEkVpz?=
 =?us-ascii?Q?PjrncJRBtUpRH/BFhOdK4jadNOf3uNJ4zY9StjFy0whOo9y8R2t45idWpGZV?=
 =?us-ascii?Q?bgMS4//V62r263ZhbnCmYx1B4X30Y0W/Eb2NR/2y0HVYWr0BhX1DhRJvERSA?=
 =?us-ascii?Q?p9tSabBDJreLLo352s26DWY618YV4IJ1SkLjPVMnEbWXyZfHNeVdCA/OqXas?=
 =?us-ascii?Q?rmSYQdQgaibGG4+jnpSUvzR0g6/xIXhqb1CsBYhSACOPXBKaiwiw8W+HFlec?=
 =?us-ascii?Q?mHbge2ZFnKaL6fNBwOXvKy8CeLh7v0KXIFwwGHmGIh3tmc/4ajzA9Y3BNFGp?=
 =?us-ascii?Q?+GigE+lVTGrwgS6v+68pWbRk5a5EZvFQB60VKSlqGirbvJtX+WGl21klJnJZ?=
 =?us-ascii?Q?RxOX8D4RO4x9XoezMRqdcf/osdw7S21uR99UbCeHWdns5irRptEDSQ14C1kB?=
 =?us-ascii?Q?ObPrWl+X8os/8r/qR4AKWF2B5w7cFlfAcCEliuJcSbKqkmgJFw9Aol/EJzwi?=
 =?us-ascii?Q?naFCDXSqhpvotX+o501vQy82cNyWCGuN+3p6GLXOlO8UDs31YoSivDXTAjb2?=
 =?us-ascii?Q?FlpHZqW3KuFcwJD/04l2Tz8ZiG4fu63dqJNyCbn3Z9MoCJZIFYR4KViF+f9N?=
 =?us-ascii?Q?oqDHkrAG7QzT1K+N7AU/zDqg4fpG00ljtyPMbJJKiXhMxMSlfBqwrOp0sD20?=
 =?us-ascii?Q?wwUM2zdFjNE9JwKqyTsipLMv29U/AEXnjKYyPlWE5ZQsci9K3J5CCHPostn8?=
 =?us-ascii?Q?BKtUEtyxx61N/xZ4YzFKn7i2XzpHG+qTh6FT2COJE3epehF2i3Dx/OAUTi0B?=
 =?us-ascii?Q?zDJUZAXp+3kbBujb6uj/V56mxftR5JCEaBbea8w7urnAvCN9+ZjQ7DWU3lZ4?=
 =?us-ascii?Q?eL35BaI+jWuRrYf4hk5yjRNPlhLO4fxi3HUM99AAPLV7BsIWfM4Kx1XOHXzI?=
 =?us-ascii?Q?q9F0/qIy1cShz7MOsQLxHVPDi7VS1P638GoFyJ9AlRnXkW7XIOa6MCfw3kaV?=
 =?us-ascii?Q?DWjVKhHZvwwVerJhz80Y1MbPpHoDsVr6/nPgUjkyDTNeCGfmsVP36V7bJcMO?=
 =?us-ascii?Q?F/rw7psxIz/MjbH3W/hNNbiyuaHXZ73FeUBk5cpIsKLW33mLSFZsmxwS8FvY?=
 =?us-ascii?Q?ce0TNmXXvhn8rgkjcdYSJrwQCwTetegYgkSO5uEjkZvTbCnSsvV1DtmBYZBg?=
 =?us-ascii?Q?cPCAjP9IqfsL69Y=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbaf554e-dd22-4db3-62ad-08da093c6afd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2022 00:07:12.6524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g+rSg/3MPYeLtO4bCekPO5Ce+TbEoQt4PLuDw/Pihu2VWJ+2tDN//b4jN//CvZmqTqU4pDVZuM9mxkuc8TlIQSOjca3vNjfRA7dIUS0W0Pk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3952
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 09:58:12PM +0200, Vladimir Oltean wrote:
> The Felix switch has 6 ports, 2 of which are internal.
> Due to some misunderstanding, my initial suggestion for
> vsc9959_port_modes[]:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220129220221.2823127-10-colin.foster@in-advantage.com/#24718277
> 
> got translated by Colin into a 5-port array, leading to an all-zero port
> mode mask for port 5.

My apologies. Thanks for finding and fixing!

> 
> Fixes: acf242fc739e ("net: dsa: felix: remove prevalidate_phy_mode interface")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index ead3316742f6..62d52e0874e9 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -37,6 +37,7 @@ static const u32 vsc9959_port_modes[VSC9959_NUM_PORTS] = {
>  	VSC9959_PORT_MODE_SERDES,
>  	VSC9959_PORT_MODE_SERDES,
>  	OCELOT_PORT_MODE_INTERNAL,
> +	OCELOT_PORT_MODE_INTERNAL,
>  };
>  
>  static const u32 vsc9959_ana_regmap[] = {
> -- 
> 2.25.1
> 
