Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7620968CFA2
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 07:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjBGGmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 01:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBGGme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 01:42:34 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2120.outbound.protection.outlook.com [40.107.244.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A12A2728;
        Mon,  6 Feb 2023 22:42:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oj81ZHRFw6ksys/eH4H03GN8TnRigebXGGD6dn0UaHrom2XYsfwTAp3yu8dQrcMyx0Dav1vvoMfTXlIA3B3dcdTQb9BnJjAbAyyy8rqtmEwix/3NbhT8Bf6bvR4UM2N2C+uE137TWtp2i1N3mBslP2+yQP9ngJYCFFFAnckr1tv3DxQJbSUaJF5ulB9+jSKvTphUjq5IAEHlCjfupF3Z5klWQw3L8ZjYSBBrEBTtxJx2qvPn28KWd9J+0O8A/Ze+ikUKTp8TgOJO4+5dNDPR3mIjpIWk4bGI094nDt4r7R8dSISDyEWnh+gumpCGmgD3idUFhAIMmK3NttxtsJqEQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MPXwwPXoeoAQIpeAu9hJBYXmpJ1yJGzHpR9D4jgIL+0=;
 b=gl8O6fipan62W4/7upqWFOFWrM3FsFKS/TqtoXf/QlzsWVxHi7uppEyQ4IxMSfdvb8k8vUePjBTeXdGydblngTAtyN6dYFl9IPS7p0ja/JcI28aYdFbal3HStIUN/V7AeDyqLeIkmp9Lxsyo6xvim8Hg0x5+jHpG8NVm2g4UpPTDc0h1H5Qgc05z24A+jRDaBBRJZ6oisJE0CkGlSCbg0geksknHVBgggH9dawYX+8gqr0fKhTb587u1XW09MSLLeQNpNg8UE5ifiAKzvGS14w3NAAZdf2SBTYDDSKc2V1lEslAtVmjCyomoO7K7mc45jZR/tDJL37K+/tq9c7UMlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPXwwPXoeoAQIpeAu9hJBYXmpJ1yJGzHpR9D4jgIL+0=;
 b=qYjyOX16KjHqFCdWhpK/fGybfG8Nolf/eYTLgce3v8arifxh/P3VRZ1m/qQzXo2BMy8I0bNxdMDx5BnfexBR8SNiXQcC3K/6NF3eSmAtzfRP1CDdM5jlnWervU4Vrvk3YpXneD/K6OUUIJmZexFXpCCUETcKsEUZ5jfcqreUydY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3867.namprd13.prod.outlook.com (2603:10b6:5:245::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Tue, 7 Feb
 2023 06:42:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 06:42:26 +0000
Date:   Tue, 7 Feb 2023 07:42:17 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] devlink: Fix memleak in health diagnose callback
Message-ID: <Y+HyyZ7KmAWQGzbC@corigine.com>
References: <1675698976-45993-1-git-send-email-moshe@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675698976-45993-1-git-send-email-moshe@nvidia.com>
X-ClientProxiedBy: AM0PR08CA0021.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3867:EE_
X-MS-Office365-Filtering-Correlation-Id: b82bc637-62ef-48bc-a1f0-08db08d67983
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SrsPCrmbGk+Uypo3HZste20bjM9OEPuzVMtzGb8gA8bLdTjU/zGebYJXssiXZnB7veEBKGfFVBVD4YWbHBL66pR0K0pSCKfMMmjEwfUnO9wJFiiUOffMY4bkDtbrQcg5bQgig60ziyO1Mkeq9UNMrKDQchhvNlGcYgpGXARdb754j/TE8rcL3OnoIJo2fZudJTytooDI9hSleECVf1WZc2qhX4amhbBtcyWIsEpG0xtbKtpQaRpKmzp7Y9kC3p1N/1S6QpBtNzBpZYbxVrh8THgDDh+c2+PMu8SQVLA7MURwyaDyuiYiPj4RxjOLva5q1sqzEIGEapJGt5z6OKdsu50lV2NXQvBnvLClybtJE1by1j27ySAQnToINbSwjNvWJWBg1Zjrmi3SUkebPCfNjZts/XcieCD835oDjXNgfgghxj5KWY0JIIimLnXj+Bw3HygS0f/qUUKU5sHao9pm+b0Z9CESUGD4xew9L+89tKQHi3AplkkKjmKSuLMopiyFQ0UTz7HYXBe6T2GLloZF9d4UhZA/xiez/UqdXioqAIziFNPIw6cRttC/PXqAQtljhu/TWsZbyF50nNa6AJMODA/j8RjEBpWCzGT19sg9CpEj4l/AetTQiWDbxz/b7Cl/C9+70snkYDKcBGlPnoZ8RXOixqTxFQ81iI5tLNq07HwCWw4+fTVvOJqDuCLnxgPW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(39840400004)(376002)(346002)(136003)(451199018)(316002)(54906003)(38100700002)(4744005)(44832011)(2906002)(41300700001)(36756003)(8936002)(5660300002)(66946007)(66556008)(66476007)(8676002)(6666004)(6916009)(478600001)(86362001)(186003)(2616005)(6486002)(4326008)(6506007)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W94VxcIqRC2DFl6rGf2sMvHx7nzwlFO1jcmUcKSVoi5IOaX2peojV52gmlI2?=
 =?us-ascii?Q?Eiu5xFWa7kRWnReDswT6jpqJraovmCkvdkixzs25EMy8xhJhiFAbyQjNNwR2?=
 =?us-ascii?Q?Rx6bZZH3MRFZFTxLYvlWv1ND4906S+xUXQvON8A7dzaiWI5MAjTkPAgHgwUd?=
 =?us-ascii?Q?9lzDQbHd0cIcMJMJGAuZ2c4wNxO2mRSK1do6jIzwcw13YBrE8pTiRb/0eVT8?=
 =?us-ascii?Q?AkUf1MMJC9MqxCVVvvNd/sHs6yqkM4eq8kRqE5Jfrf1LI+eu2Df5tdXtUKyH?=
 =?us-ascii?Q?H+2YgYIARz5sGin31kjVQZhAl3QWr77pd+l1wUl3QFtvwj1GC+aFsK9u8lu9?=
 =?us-ascii?Q?ZeTIhGIQn/xR+ZZxH10PJJtKttmHUqQA9wBlMSksBKfEhcDTxF+XrG7z0mBQ?=
 =?us-ascii?Q?GrOLV2YAD6HdqB7PnRcNBDuqLgSy/Pfq8oH/1+LoDLT54CXB1mIoCnxwmdUq?=
 =?us-ascii?Q?v/W3iZ3qrY0PsArByhkc/XLgqU8rISXaxUEJKRZCB0rg/3brxWmWvBV8iX6p?=
 =?us-ascii?Q?qdjoce2z+mKTdx0UKCGFJrkRp7WTgBsv5p0cnTVK4aBEE5FNWhaGZPAsyzYM?=
 =?us-ascii?Q?8akysP5P+CaDqEklZbr8BvdmKpqLvBsH8h5CL3dfkxBB5pbQM3EmFZsiz5Fx?=
 =?us-ascii?Q?xNauekUiLGg1rLlZSyfhjWcP76tOCm+vIOjn/WyT5/yL+G3SZz/EQXe1SEck?=
 =?us-ascii?Q?b2gGsqVyvfAOhP53TcqLBecp2hqKk/T8K/BDg55k1ArxCICnAkhyQoHf6gpX?=
 =?us-ascii?Q?IsK4vlcVI+SIBRI5nvQkaKqLd1qRRvBQQI3WLoDa2xpVvTbIuQYg+LhpSyRn?=
 =?us-ascii?Q?68YnyURAQpO1heAnzZXeNKex5wnXr3eNHoEHRw817b3WMbfMbGzmV72+EWbX?=
 =?us-ascii?Q?yBzVz1OaAucCgdo6z1WWS7ZQ6/oxvnX3X7McrSW7iohRuzzU9oFSXJFqPdWS?=
 =?us-ascii?Q?443JiPrTp7nz4K+DwDPbO4mcLUo9RG8wgPJdayoKpkQ1r2wqw3ndoi/juydY?=
 =?us-ascii?Q?kB99/XwaCo/fdnJgqtoy4CapbqLJrt9a1v8W1q4er40SJ1mfMVGjZoQcWyW+?=
 =?us-ascii?Q?xvyhYDhkYfzUPlBW1cWHCdAzt8HKch4NZ+wKBrT8LPgD6BaZx6TUy8EjhMZb?=
 =?us-ascii?Q?Tm1edGt3CDqo/iXiyFsmCrJhhyPE/BlGNonKB9TwdVBc87XMlmajiihHDUjj?=
 =?us-ascii?Q?FRvpOssD2taQirnX6fbMp8ZSY4HS/cMw1JCql5q8y1JyJHys1c5KonjSmSj/?=
 =?us-ascii?Q?UbKNnFoiqyEDpk/OBx880IZtHB6odYtvIOji6nfFEWTnhlgJh2IxOsv2evPy?=
 =?us-ascii?Q?aWcNrZBIgAHD0jo54AwaAK7gf+SorYbEzyYKKtUeLyXdUSwJJuIGx8a+PHN9?=
 =?us-ascii?Q?xBp97wdnEbZT5f8wNxTFx+MavIN5u6rBL2aGHHx7Nab2BqWNNLMneWGYMQe+?=
 =?us-ascii?Q?utnqTSvq2lauZVZdNCX3Ff6gQqoQeMGaPUpLZH1TPVTx+hVtLNuifCyaAZVZ?=
 =?us-ascii?Q?K3bWl0gJBtOpDbD7UErRUEeUn8wxwH3XqV8lNXheTi1B4EQoEK0khNwukNH2?=
 =?us-ascii?Q?jVjyUXBoSXos6yBqbFGcCE/CXFSIGLU395PabGdz9kOXWaByTVequmxyNVjN?=
 =?us-ascii?Q?FaMh9BsMPqZaaVoe6h27DCPK2B5khL2iuoH4xQs5jNhd9ItAfUsgKGmrts48?=
 =?us-ascii?Q?eB4cRQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b82bc637-62ef-48bc-a1f0-08db08d67983
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 06:42:26.0406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oAWrfJPtbF/dCoLgfTCIn0lQeDFeBDY/Dox3HGiN4Lix4ewv05aYCOhZdYdjX/233sn53YI414XqWPlHkeaTrdTAaVZ1n8Fn0dD7mCAcE0M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3867
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 05:56:16PM +0200, Moshe Shemesh wrote:
> The callback devlink_nl_cmd_health_reporter_diagnose_doit() miss
> devlink_fmsg_free(), which leads to memory leak.
> 
> Fix it by adding devlink_fmsg_free().
> 
> Fixes: e994a75fb7f9 ("devlink: remove reporter reference counting")
> Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
