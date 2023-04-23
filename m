Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52546EC222
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjDWT5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDWT5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:57:52 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2138.outbound.protection.outlook.com [40.107.92.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDBB110;
        Sun, 23 Apr 2023 12:57:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxNC2HeoATnxJSciQzYtycUfs7WqmleycJDxrzdcmTlYNBBLbUNpv/Qg3Z94s+Y0c8+jxmH1BrUJenTXRY05XT2A4GaHH0TBY4n/zbcTrvw+BEaCQh56z+E/3kkGq5A1wSNApBiPZzQS3Ajdd925bm3aGkXL9EO7UN1I3JzHlB5cEGQXNrM7oYOj+nSzLbSLCXQLmW8xNFIPraMJwlgK9HEa4Y6Gbz1/qyu9EOxM3jqetZRZg1Pb5oprC35wG/qk4CcZ1OSb2yu+mqUBG/m5WPkPobr+bFhlo2Rei6z5xVNDNxzEKAvReo8RxNEJNO/irQj/AWj+BDpkCXGcgQC9RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GTnI9hD1ikLM++VaQtKdyU2VcoN84lDteOe+80BPyzg=;
 b=K9scU5hVV/AWqEENYPneAoSgbkcj2h90kaNSgd0voM5WjTSs7KWZVGzVgiA+42SWNeii/OwBtIBMBPI6JeohIjBQDk0ZCWL6V9QjWzyvYvZCyv/CJ7J2AlyNBVN+Bn0snw+ZkM1BnbjA/NkqNIKO43LKDj3d9+VGnkfVmRHmvU9PsO72CUFOghxqBXM5n6YMhR9dnUcqOf7igSjh27eo1Wzi34XTxxcpOQKEomqQbC09TxJ6Y0Pbxz9HCKA1Ob4e5EBVSBNn75bzCiYnJIrt9gcv0TQsqOkQuqGiyeNvwv4PM7DwW04BJtcdmaLMwkuhxW9P2fUCUcTdfTO2IusRYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GTnI9hD1ikLM++VaQtKdyU2VcoN84lDteOe+80BPyzg=;
 b=LBKT2W/U+SptmuCrhX8UmnNIJYHW+zWFRUUIAhMBJ8p0gfNHul5OSwIISGf/xD/deeO5KkTJ2OLT12j2yuxhfWRRKtP1TyDY2m0Ks6OVqcWXkDQtK3YKRh/a7PTCMfD3D0R5QWpvQ/3T/z6BEDArTRyUXcTCuU1093dWNGeq+GI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4830.namprd13.prod.outlook.com (2603:10b6:806:1a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Sun, 23 Apr
 2023 19:57:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Sun, 23 Apr 2023
 19:57:48 +0000
Date:   Sun, 23 Apr 2023 21:57:41 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk,
        jarkko.nikula@linux.intel.com, olteanv@gmail.com,
        andriy.shevchenko@linux.intel.com, hkallweit1@gmail.com,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v4 8/8] net: txgbe: Support phylink MAC layer
Message-ID: <ZEWNtepnhsZp/HwW@corigine.com>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com>
 <20230422045621.360918-9-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422045621.360918-9-jiawenwu@trustnetic.com>
X-ClientProxiedBy: AM0PR10CA0042.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4830:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cf1bff1-3b3d-4255-e7e9-08db44350304
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q2U8xGd6xmTrVFRUNghc4g5DLrSmKtPH6TbgR+8HHhT9j8ZQ155kj+/0+FfcWqqHVTn0rCJiEstTIO4sY88o5sXI7dV2rPCQDXB+nJgeEZmADdV4fj1Ws6oT0aKLNKFaDHxsxHA81op06pBUey7EufX+0f+nDxl/s0M65gQJW+7T/vQ2nerwG3mADPTSBUJAAsnXf+3FKAeKBeiLsCAqcsuMlapif/+3AiHXWPYpgQ1nA7RzsZLyK6LaZRXhHmN2gXS+MY7gRUDPFzSyuwvVQph+Lwbo0fYgLuxR9vp2GfRAIo4pyggndzPuVcbn+upfTJRaj0gJut1C3Th3JrBTB8107OpdfHXBU836hapPZpVcL/AWnXLtqWt7p4xG+VlU9hISVwtWFVd4Umho7MB3iKV5lIMC28sDIz/6GLojmDrFEfm0z4uvH3Cv87uXtrwJoplgMG60kveucuN/Vee14GZYgHJL6x65j5+xVZvswXYymodErcJtrNEgjnfhkAH3LKtO5ssR86XXUKEOrswbg1VdKXOOa7AIo+KJVKEORCcDisy6R1F0AiIq/wEny5iZwvvjoqP5jGbXXryOlMI4ozRtp+NWO1i9EzOU65OsPBQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39830400003)(136003)(396003)(451199021)(478600001)(86362001)(36756003)(186003)(6486002)(6506007)(6512007)(6666004)(4326008)(6916009)(66476007)(66556008)(316002)(44832011)(66946007)(2906002)(38100700002)(41300700001)(8676002)(8936002)(5660300002)(7416002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kudzBOugl83BsUOAGO3SKQQCqPO4Qi+C+ZzjqolSmX5O5BgkZL781LyifQhU?=
 =?us-ascii?Q?oEsGTW2H/e/FAu7Ytzho+veedqgzWkPZog9wHtv+kVbvywhOPG1jfD1XEzWu?=
 =?us-ascii?Q?TcIRhoU+SONQ1oGuahyJ1NLsNYGTI3bfuTfXTb6qDiaQwu6rVm/DanLtUKUv?=
 =?us-ascii?Q?u0mtWKMAN+boTAjbpm/rHzPb8IsiuRx1HkQznz9LZfn2tlep6OmIqRA7WM12?=
 =?us-ascii?Q?38RHitBqjyNEOP/tmjBC4LXYzKUfYTrgEl0HwSt/3aS2v5kw0NikIb/nw1hQ?=
 =?us-ascii?Q?5F7qysEQIP4dNhib9VD7KBeV3npUDMqU/Gk25e10S3CoeHWd7aSqXMOWLusT?=
 =?us-ascii?Q?n/9LEwG52L6HyxRMwo8HHx5+wq/LVPWCckYH1/CdGp9birvwFrOxvgK6Nv7p?=
 =?us-ascii?Q?nTJHuR7KjaorDwkTZFdrpB0uFVWYpirwxjT9C1y591ZQIsToqC0MumTCQ3GV?=
 =?us-ascii?Q?a11pAIt5UBgUpf+IwLMMxr7ckbwkgVXcchOIGylduZMj1M8U61/BE8mkZL2h?=
 =?us-ascii?Q?/Y6pt/vZ7njzNig8wOFLzVXLkdJ6Mq+NYyfoir9lyMY+beGOCzuM+UXNfOCt?=
 =?us-ascii?Q?r25gIdBvbo9KRlTekSe8A63xTPeIwk/NszK06/USQ1IARHXSfszXN6lL1x7K?=
 =?us-ascii?Q?KXreBPDbr+Xs/A8d0vSyr1CBRgPj2MjYLyfhI1SbjgmQLsJtmDXnd8jN/+pb?=
 =?us-ascii?Q?K/RxadtrKHlj6coGSH1AYf0BMnKlQ2oeLvCBobZstiUtNL/o0z9Q0q0qhgup?=
 =?us-ascii?Q?PRMxBcTDLShUaRgwh+rYQ4m2iNX9kEr5Dgj2lI34dsZ325TdOVNFZKPB5IrB?=
 =?us-ascii?Q?K5FF0L8RxM38ZT0NAUHRmLb8oJqbmYuK7d8Hht7WweZ3KmdfAZUByNr5pAVN?=
 =?us-ascii?Q?yqFunwSIoeo9ny0xyd2zkLwfAnejm8rBqWr3ZddpiNQUlpHqq5o5vearMRiQ?=
 =?us-ascii?Q?nMe4GF1cZvI4HjoztjmV+HLgwgMWIhIulMt/NC/gKAvjUIeTZvk9Kg+nBYmq?=
 =?us-ascii?Q?mv0taE+xFdJlbV7mumi1hpmwBC3sGc/9F9fk/LWv+Cfqyk26xl7BAXuedM+x?=
 =?us-ascii?Q?YM0UCcTlavZ/8GBc587/5zQupHsGFqsgPVKLXtRl45hyOdd+4HYTaeE/JGwN?=
 =?us-ascii?Q?JC1r58TXRbbM4kF6+Lc+/nyHRqiBxOznvAX8h+NAhmUeB59J+YkUApG7enbZ?=
 =?us-ascii?Q?az1cuQ1URN09kyomfGonScHh9C6UUxwrzkGKA4S0awoNWmuG5vjouqOkzW9O?=
 =?us-ascii?Q?T0kNP/LKvHyeVUyAoLjAYGGz2cpfecsdyg2qNoaOHbwX/TKEG+/lh1VnUclz?=
 =?us-ascii?Q?LXSnLM2HWnvS9sw/dpIExgjxR5V6ov5L9amiqijkCLRU3dSIOUoGeyRrf3Z7?=
 =?us-ascii?Q?92GxPtPJ6DOp9oSHZmun8fkwNRNSOwmU1621880WRWmwUfy12IAa1EQO0NMe?=
 =?us-ascii?Q?KXo/N3hj2Va/Ew4gMQ7bUn+4dIXd16z/JHn1v9tDEI8Fdhu8XO0uQL5SRORk?=
 =?us-ascii?Q?C1n8bkZRssOMoeiST6wBKGt9eu96Fhsg7xqmVC6OK+f5+0wQ7g6+3k4wvyZP?=
 =?us-ascii?Q?2gdf8dVWnQOP5C+wZlJ4L4gbRRli2v7ZIoM+5uwJF77k44KhiIbewH4uWvC1?=
 =?us-ascii?Q?0hc/DUeolF3jKiIY3myNHyeEl5eFqPJx8zX0AnRu6dgpklwKaixjP529p51G?=
 =?us-ascii?Q?rz89bA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cf1bff1-3b3d-4255-e7e9-08db44350304
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2023 19:57:47.9341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1O36E/mx7a93jJDIq+cbhrN4CVyuFtDnJ2o5qeno4KEzwSkYXRfj4+RFBntWpNWd133L1Bty2tlVod9UCNZk260zilxmky9eSDa4JEJQ56Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4830
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 22, 2023 at 12:56:21PM +0800, Jiawen Wu wrote:
> Add phylink support to Wangxun 10Gb Ethernet controller for the 10GBASE-R
> interface.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>

...

> +static int txgbe_phylink_init(struct txgbe *txgbe)
> +{
> +	struct phylink_config *config;
> +	struct fwnode_handle *fwnode;
> +	struct wx *wx = txgbe->wx;
> +	phy_interface_t phy_mode;
> +	struct phylink *phylink;
> +
> +	config = devm_kzalloc(&wx->pdev->dev, sizeof(*config), GFP_KERNEL);
> +	if (!config)
> +		return -ENOMEM;
> +
> +	config->dev = &wx->netdev->dev;
> +	config->type = PHYLINK_NETDEV;
> +	config->mac_capabilities = MAC_10000FD | MAC_1000FD | MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
> +	phy_mode = PHY_INTERFACE_MODE_10GBASER;
> +	__set_bit(PHY_INTERFACE_MODE_10GBASER, config->supported_interfaces);
> +	fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_PHYLINK]);
> +	phylink = phylink_create(config, fwnode, phy_mode, &txgbe_mac_ops);
> +	if (IS_ERR(phylink))
> +		return PTR_ERR(phylink);
> +
> +	txgbe->phylink = phylink;
> +
> +	return 0;
> +}

Hi Jiawen,

txgbe_phylink_init() seems unused.
Perhaps it needs to be wired-up somewhere?
