Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF426B2AFF
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjCIQkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjCIQjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:39:52 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2098.outbound.protection.outlook.com [40.107.212.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63DBFEF3F
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 08:29:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkWlMCqA+Tb+su2SY/4mYX1MIxfyJTqjWnlR7aNj8F9xCUkYSHkvxuB/aEufcA0W5CVD0kZbcWqAh+ZWrQtOqufa3bxdfRtxLWYj7aC2aFSrz4OIScbmvzynjzCuososjA6mX0ZqV9YgnYBVU3rcvtywyeAIMdq9Pawkns4h02DyIkEhr/k8ZbxylpY2+2Zy7yz7Mg2rD07Q8/odxx1kCzuBKbB9/406KM3YAeUMnz8XQBSoJq/ysWhFjhIVB9IWij/jzV2bvSR4RCbrzeb4oW5NBQtQXoh6ceW/mKZ92kY0tH33mQ/P52GPwMQudkF28uGY9bAlffOUdibUQPLmMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G+z20qzx5jSHSn/342C4ZJDfTvwWAoqfNE5JcEjt6II=;
 b=lksOgEMYJIvANJsl26fqBASXU0O1ViqvQtSSgeqMmy4GrkcWZ/L2wSxJyrWRxMBoErwy+SCvOjdBs+aDaw4sgkb3cr1hu8sKlMag6T+Qbd6p5Wslbxx7+ssaLKE1rZK6td9c0xf+LlQECQE1mQZ91zfh+J/hnDxMmG0vKuLlaE5kZP+cQeNpaWgjLSwAT0MdA4sBY6zxNUqPASgCIAeQH9Ib/ffPFfVk7crPYSp9rQwOa+yOc3A2ZFpXiUoZuVI1160yQY2DY6hx0SWcUqV3p9UEaF+ApkxLPrmlO0D6ZTx4MH76hVosX+iFL0P5jh6VqoKHqeljLsx8tVfM4d3tlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+z20qzx5jSHSn/342C4ZJDfTvwWAoqfNE5JcEjt6II=;
 b=XtgF3b+cpgxLvg/IDyqxdRufpHhPNFpVtr94509g3Y+JI5cHF7PdYhpkJApr6BW7Oq0haPCRtiE5G/9Ve3uvncEYZonutBBSbtWImjEJqX9wOuY2p3g+21uyKWiXqM/HQ3UfHIyAbQMdvu4gxL6XSUIJ228lnVp2clg4U5qVf3c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5492.namprd13.prod.outlook.com (2603:10b6:806:233::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 16:29:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 16:29:11 +0000
Date:   Thu, 9 Mar 2023 17:28:57 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH v4 net-next 5/5] net: ena: Add support to changing
 tx_push_buf_len
Message-ID: <ZAoJSRoXUz3SYPLg@corigine.com>
References: <20230309131319.2531008-1-shayagr@amazon.com>
 <20230309131319.2531008-6-shayagr@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309131319.2531008-6-shayagr@amazon.com>
X-ClientProxiedBy: AS4P190CA0044.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5492:EE_
X-MS-Office365-Filtering-Correlation-Id: ba19c743-7421-4659-d090-08db20bb6a0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mGrbaQmUzMhWaQQJI2g2/j9GMJP+2lQKk/DJqm6fZoN+mFAR8ncRosOzjvisby+J3qfc4nOJ8YO/fggECJOlO1uC7CL9rEDJFg1V1ep1vQ9ywXcIFIsVmqWoMBg4VNocje8AR696B7ekYmdFT+Dhyn0+smQo4NpxVAZRbu3QYXa+Q8j5Fq1YKXdwnPFq3m8v8la+JZKMSJkUqnSdjxLG11sYRylF8tAEEo4RlBYXuDjhLncqrclf+B8CYx/WWuk/5vMVZigrcW/cdXlXHPctNI1eNXyNCzBx4b9PoK23w2yi+cCpdD2WaLTguiSea/8n5uQpfr0/XK+v7BMFbsfjdMz8emi9J0FpokyubSs9myZCMU0tb3+Rq+4IkxWYYPywXn2/8ndqLOEYloQGpoKds/EIO8OLwvKrYGXuyHG/QvwWwOHTj30sCsNLuzHnJXJo6M2uY5+r59tT+jgwPVNK9mTeRVg6TSM5JbzetZAoGgzOCmmZwHNhovYisuBlJQX4i6llBJgVyJn5EfRI3xZ6/8y4+409J9PyGvc2jYTPHyejxiCaddcp28HBjDhi4bPdXGsEiyMl/nVC9BNuQToucdvovOtRUEOaBtNQLWMWkILTiTWRgsRmE0qg2an7sMABfqePaBxkOKbPgRA5JxMhBcpae0hyMC8Q+HV2Vy3piPTu0++/LVn8zzb5X4YITknz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39840400004)(136003)(376002)(346002)(366004)(451199018)(36756003)(316002)(54906003)(186003)(478600001)(6486002)(7416002)(5660300002)(66946007)(2906002)(44832011)(4744005)(66476007)(66556008)(8676002)(6916009)(4326008)(8936002)(41300700001)(6666004)(6512007)(86362001)(38100700002)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EIOe16yPAatgLNsRoFDJoQmQQE+walshOJGoc+wN/7J+UnZoWUYLaVkX0okQ?=
 =?us-ascii?Q?As0qFOEHGVaNGNSsvsvYz03zA7aPqVDHPb4bwt36I3xPuxYancCHjIPEirPP?=
 =?us-ascii?Q?E6IlorDz+jkHN9lob82/qUFAFaU0Fh3soQjaQaWgVwh3mwFIdUkr210pR6jf?=
 =?us-ascii?Q?ij23Hm7xSEleaeDRpZUpfsyedfUHrzyJiU8P+hhDQwmxwB06Edk521/u8IMU?=
 =?us-ascii?Q?T8zbAurpHJITNVvwXQmmKb+585EtcgvnMc8GigofeO3yhOzNxRBK/WyBNw9a?=
 =?us-ascii?Q?GkCGBzALP8nNzOovUYIDRqDWwVZsTaRqJvPSbWnPSHZ7A5XR7EZIZlziyJhb?=
 =?us-ascii?Q?GcZe/yICl6AabXDN6V0qxMfM8V9tPWqWvunTthkHoOt9WNWYG7nIkYydbwqG?=
 =?us-ascii?Q?o83F7lD8HVuxUEY+vdFQoRlyt9x0VOIrQQAPswUlRlmbzVwhYB7nNPmhBs9A?=
 =?us-ascii?Q?enQnrDjyQ0JxdncF+6Ai9CbdxbklHZo6FDiVnzgtepTJhrSuJx4sA3bhUmxc?=
 =?us-ascii?Q?+WpyGWDIe5i/pyO7eJS8gtX2dFu0aNPt/ETI6j8y63SFUVmOzufHNCX9YdGM?=
 =?us-ascii?Q?jQwHlwwwGhSDS/VNU1CxeviRF6HokEvgyrUa9seymFWeN4mWfWkVfS7KCMg1?=
 =?us-ascii?Q?cGcxlPXnXgvzA4Cb7HRdBC4T3pBBPevN2OVENJ0syCXQF4Qpypbct3gkPLXK?=
 =?us-ascii?Q?Piq3wJaXB1HUfP7BRk9G+f+Ywz3kBAFxA2UvFyf52zoIbCZQ+kdehl1JHNYr?=
 =?us-ascii?Q?W308lsx20aOwwRbhcwfYoO5AUjWvfbQAJ9afGNmNOGfrw9SxsgPJ3BiEspsV?=
 =?us-ascii?Q?UafvuoFGh5j2UnafYVBecQzygujBLd0xnBk+NQw6Gz9WmUc7w9+egmnrhji6?=
 =?us-ascii?Q?h+hHymeDsRPcXB5mw+798jg7IiUXFu+c3est8OmIKLPWLG+y1fLCtB8nYUHY?=
 =?us-ascii?Q?tnOZp5ja3NwKsVDLeXsJn8+jZSLN2QWZ5H5mPP1kp8lSnRyRw+WWiTPz29gA?=
 =?us-ascii?Q?5Pbmpx7qRy9mMyVdRSiyl6UGmaNk6GRGN9Bb+ytLHfZfFZZj2ScejrsQrgf5?=
 =?us-ascii?Q?iLU4JYhCLxHp6ubqHBH45UIAPR0QV8RZeqn3oJgYKZbRYhczTPSsXRnoYNaE?=
 =?us-ascii?Q?o4CIf/3st2kJbRBqjdb+2fnefneihlv9ql7FxcLV3rqEQbVB0F5BSN84aR0F?=
 =?us-ascii?Q?yp95bQ6ngAJwB1zhiniXEyKrAGlN/nAQLR8YYICwNLAIoVhLY96TS96nQg8s?=
 =?us-ascii?Q?vcfA5+7zAi3ro3ZF67RBsok7yO3ZuDld2OVkgDZ4LFEhBlazXSvkNR+MSitW?=
 =?us-ascii?Q?Yo1rLB4KJYFJpdmT4Nmp1rSf8EtiKw9yGwWdQBH67izoatQEaJYWJmQUzN+O?=
 =?us-ascii?Q?op7csxm+GoX79TG9KtPcRMx7txKJl7D3UCqmCf0afYY1z8G6TO32tJtkun3X?=
 =?us-ascii?Q?t+Xy93iDmIZWOiQV9In7QHf1FMgg5JmmJc1KViiZ3BVw7/7sajz3c1ODsVKP?=
 =?us-ascii?Q?qpW0InxeSbs6LKO2Gx8BdnmT9zdIYdU0JALyJsWLVZ3c1kmyRkXBEQv9OLnc?=
 =?us-ascii?Q?cI/oErmxZMEzpjJ3hJkJGwQwBv57PDqBJ8gGqFxa6KHi/76RmmrSyvnw90qw?=
 =?us-ascii?Q?C8ami98nWFj+3R35E6DCAyu5OFuaf9qoK4SG3/RyDoZQjN91EJWQcGfL9SUW?=
 =?us-ascii?Q?HWJHXg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba19c743-7421-4659-d090-08db20bb6a0e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 16:29:11.5573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EkTfsrxR/YyXc0wR8+J2oW0POb9aHRWNCudpDpSNNPZaID4G0L7efVI0Zji71UILsTXwR6Iac85xCH1xBpZ5yiLtVkqAkSSBfX9O4Jb5YOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5492
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 03:13:19PM +0200, Shay Agroskin wrote:
> The ENA driver allows for two distinct values for the number of bytes
> of the packet's payload that can be written directly to the device.
> 
> For a value of 224 the driver turns on Large LLQ Header mode in which
> the first 224 of the packet's payload are written to the LLQ.
> 
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

