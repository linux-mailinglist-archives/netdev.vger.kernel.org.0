Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08DC68B935
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjBFKAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjBFJ7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:59:49 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004DBEFAD;
        Mon,  6 Feb 2023 01:59:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BjdqK5/6yW1tpM/N75ZTCEogCh55C5F+XPdtE+V0re0IGuJAL9/1BhHPGNMJ3CUKNQ6PWqx/LXtx6qoD/AMi4SRy27/TXQp5iTLKvq0mECBkKOKgJ0n2yt+sM1AoPP8abcPSpjbfE6En+iodOw5k9eahx2LZs7Ta9P4RuW/1PmX8ojXQkhN7Z1JV0VU6TO7pG1GbXsEDAjiAhC7CJg0AATh7IN0QnnsBDnmMkNAsAFoOuOZ8JqcYiI2g+WSAo8r8WPeiwXq6FzEzqQaVvDdO9SEpay0CsN8Cx8CscvQDgoMtosDIibw6LM0/HEmJ5xA+BdOJZdu7zh+wyPOIHmpbCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1BL0yKzLuarJtq9s15OZXXQP3n6U0aHnQLxSwg2TS8=;
 b=PXpswyP2bk7DnttVcU5waQGwccboDSWVZPVcUUzLlZwz8RZmHpwUDAknaVXiytDxx7l6Zw+D3LZEk37QwFxi7Ry2HbvMWhVQx2NnPQUDeOhmhbWCqpB5SHluv0J/g8ZQjHt0nBnPK5gZRf5IOo0A/gyGsusG4+rmuEaJI4Pn6Ip3r/S4xzdcG7yx+an0X1Lark+06kAv7GcinV0g4o2gAp5oHTKKQ3AlU3Y1jWPyhHpqRx3NF76ROIVSryBSaZoiYx0WXBpDkUXpuI441DQSQ2UiC4oO+v7rhwdhKPcjp5gfrHqBXoquKPi/Olaw9ZUs4BbaGXRqxKKy3edBEX9OMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1BL0yKzLuarJtq9s15OZXXQP3n6U0aHnQLxSwg2TS8=;
 b=3k+6dxbDRUj92ddDBz15jLVHJPClnzcTmXOb1/HyXUacTn9gBlkBtIAuY3fXaWUygKG+9gzEvxH/knpqsNfPnk3nfwK6I9uh26iR6N9UWtAw++sT1PAE/R3ISnfE5vHuw2c3YPrOkZbIGz3cG7Il3flZem4jq0KMly/KRzc8q0g=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by CH2PR12MB4261.namprd12.prod.outlook.com (2603:10b6:610:a9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 09:59:39 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::4b32:afe9:e23:ff7b]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::4b32:afe9:e23:ff7b%5]) with mapi id 15.20.6064.031; Mon, 6 Feb 2023
 09:59:39 +0000
From:   "Katakam, Harini" <harini.katakam@amd.com>
To:     Jonas Suhr Christensen <jsc@umbraculum.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        huangjunxian <huangjunxian6@hisilicon.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Esben Haabendal <esben@geanix.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v2 2/2] net: ll_temac: Reset buffer on
 dma_map_single() errors
Thread-Topic: [PATCH net v2 2/2] net: ll_temac: Reset buffer on
 dma_map_single() errors
Thread-Index: AQHZOZ4gD82bQ5NIJEahfbNEw7bub67Brbnw
Date:   Mon, 6 Feb 2023 09:59:39 +0000
Message-ID: <BYAPR12MB4773DD0FE03A6DDE1B1B36D29EDA9@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20230205201130.11303-1-jsc@umbraculum.org>
 <20230205201130.11303-3-jsc@umbraculum.org>
In-Reply-To: <20230205201130.11303-3-jsc@umbraculum.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4773:EE_|CH2PR12MB4261:EE_
x-ms-office365-filtering-correlation-id: 8110370b-e0e6-45a5-d6ff-08db0828dc71
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UEPh5+hpvlk08mWKnO+z61aGjQBQJMUIhqB4xrkA11QmOtLF6OE5+IjyUmHUK4LXTqMFr93kQJirygg+cMyeanURXUSDKpxcH7u+KJ5fFH1k8oEbFBX2Bz1DIcoJtO7oQXu+6YKY2hsATNQOFFDXS9EUwP9eVkLHvp+YuyfLwVmvFeyFlBd3cv+q16E/gmN2x9O+0r8FLeL838SMPJCjKEnYkBzAqJA9fIx1oRooSW5d99P/XuHVe8xUVHqBAQJyQzoTDff1e4DzTJP/hKa12lf32upFIRMMynBBa0/KJrWUc7ePIvD2dnBxr74AGxjQHm4BHpM4d1UgkuqvbKmHIfWaGjt1jN30QNiInQu5JJsBj76Hoix6ZE0shdiTjCLT4DgJOenw4Z6nTcdjy9M3YEEejAWNPP55Qzya/eI6kmFERiScqOektHev2z71b7GKgSIaIZpB8xsc01WrVSDlrWJAlCzWQtYxNJlJOIcc6W6QY2blB2S4BdYhCSFaCwsEXB8XU0jbYAunpjjp72NVN/5LfraBUt64cYAaZlWpezcYV2jUMTH6Eb3iyIaPy3u0bSF68hNjQBi3uP7kvGorJf53WQxsHqrK3tItCZuG9/T6MSJzrELBZOERUig2R+UqsIZJKryFc1SgqJdzPsuwYRmRIGH7buUGQjsCQxPaccUsP6ltNZzKXliQJ/soky1sBVLNk9St7icuaGhWMDhfeg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199018)(7696005)(33656002)(55016003)(38070700005)(122000001)(38100700002)(86362001)(26005)(9686003)(83380400001)(186003)(478600001)(53546011)(8676002)(6506007)(7416002)(71200400001)(54906003)(76116006)(316002)(110136005)(66946007)(4326008)(41300700001)(8936002)(64756008)(66446008)(52536014)(5660300002)(66556008)(66476007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OND2A2n1EuZzfJk8L+//snDoEKtUehT6l1Rd/R5j6enEBB9eSslew8/0UvhP?=
 =?us-ascii?Q?whcXh89czHnuUlCYoTt72cctrIgYWS/4FhAc/303UwcP9sBztWuy+mHezgkB?=
 =?us-ascii?Q?kq2YFGj7V9u4AkVY701BsT6dgCh2bmQRlWnsHpNfabPf3mrC9w3iaBkBlaLG?=
 =?us-ascii?Q?xC8Gqzl66+4THRJSJSs2/oHXkS9CP7aSVufcQj/uzY9eB6gYXfDVPbEo2kLY?=
 =?us-ascii?Q?FpBcXf/tFbuFuPvOrAL/qUM5n3GDiC9tSlWZIlYi6114z6iQFuHYJJNfd2sw?=
 =?us-ascii?Q?7toedHcW6SLb/B3GrQrwPwoQczKncIIrcpn0q/EC6ejnIS/LZdd4m88xXXlZ?=
 =?us-ascii?Q?QdHB3/8ErlvW2OTn0M8HUaEFQOVsVT/ksrpT+Iu+Zo5iMrRsGqSbePVEYlH1?=
 =?us-ascii?Q?rNVeG+cyEPng/kHjp33WYAhkwrodgio3Pj4E8tex2+o+JE2Z9qEDlvQSF9Go?=
 =?us-ascii?Q?KjtMsxylGddYSjRxAKvskd5U9FQTLm9tHcfLsJ6A9hbe4DeGXtfnos0dZVU6?=
 =?us-ascii?Q?UdQx/xym+D/Krw6CQfBbea3LCQxNY2vhSfky3qtv8BWoHoN3Qtff5CIqxo6A?=
 =?us-ascii?Q?ccFLv8wipy4L80EJlYbawsIrY+1fZds5SF8fBjsbgdyDA0Y3DVLOblJzzxjO?=
 =?us-ascii?Q?/0x8GwqeZtisG1SJvEMrkPbtgqDWoJBDAXTvdJfqGIEGWtUy2gRRyhgp3S/6?=
 =?us-ascii?Q?ysDMu3LXo+6lYE1kkfhGe2VPfWhBuF8ZW4M2YLRvLMdCYtYk+ETcXm+WDqqE?=
 =?us-ascii?Q?S2onApe0MC7ZZDxwAfNMKv1BH8rgynLYefryunHiM2O1Igs48EZgZi2B3r5b?=
 =?us-ascii?Q?8x6WdgAwjYmResk5fdtiIjq77lJsfXI8yz9VpFhv011udGGR5ELZrwuD4ajN?=
 =?us-ascii?Q?VzgxblOlMllqliF+Ki3YFP+6rvFwT9Aa6reoly/yfs6vtXp5R2cdZWJEhUeQ?=
 =?us-ascii?Q?RIpoXD60JX+7n1HktsJKREfhbqDvex1jDGJJnxf1poPJLf8wifDOyCksrCnr?=
 =?us-ascii?Q?5JSOz6Ggq+7IUAfhBGqE7hHmY5v+Cb1nQ7HZfjJZdTBL05m2VKh1fQqzrDUw?=
 =?us-ascii?Q?SO6IdZTVh+zvtNT2uifR3fktKXerWGHlQ2mKXsCWzg83krkxUL1nTrOUxaVI?=
 =?us-ascii?Q?QtyMy5ZxvLXxTlEM1K/CNW9NU9xFKx6Gj2QSxiSqj+EaAskklP8WCm5sNO4D?=
 =?us-ascii?Q?MAvERJICsKLrvrQXB2kOS1aUxhe9Ysr3o9Qwz74wJEQVnWeazWzGFDitUMMm?=
 =?us-ascii?Q?nIXi54+c1tiQuiFZF2QGdZcWEIXu0X0gd5I4adLaHqFNKku/FfntEH/JL85T?=
 =?us-ascii?Q?Gj5p/BLhG7sUJVFGtC3MisWmqJh8hokPN7sxCvWnNqI2OPzonavO05q39gkT?=
 =?us-ascii?Q?jR3EAcGZbrps8kT00UOcrZOXst7SkQCdnCatUX9PppmFfWIXLiRASKUnEvBN?=
 =?us-ascii?Q?QOjpmeHJDbX1bnwikHv9hSVPk2Gbxk3vxN6SuVN9M46LKUQBplAJuKe3xbbJ?=
 =?us-ascii?Q?JXkhyk3pfCsx89CVJecRzXSh/r5YVKj/mQbi6mvr/HodSIVZ+k9IjUsnkPV/?=
 =?us-ascii?Q?Kua8wDuWPbPiFcbLtLM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8110370b-e0e6-45a5-d6ff-08db0828dc71
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2023 09:59:39.2750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HYzG3MeSB1s2xxiqkWt7wweTuPYj3Arpf+pO5r11IIXHLKfJsXXtodm/4H41WHCu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4261
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonas,

> -----Original Message-----
> From: Jonas Suhr Christensen <jsc@umbraculum.org>
> Sent: Monday, February 6, 2023 1:41 AM
> To: netdev@vger.kernel.org
> Cc: jsc@umbraculum.org; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Michal Simek
> <michal.simek@xilinx.com>; Katakam, Harini <harini.katakam@amd.com>;
> Haoyue Xu <xuhaoyue1@hisilicon.com>; huangjunxian
> <huangjunxian6@hisilicon.com>; Christophe JAILLET
> <christophe.jaillet@wanadoo.fr>; Yang Yingliang
> <yangyingliang@huawei.com>; Esben Haabendal <esben@geanix.com>;
> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: [PATCH net v2 2/2] net: ll_temac: Reset buffer on dma_map_single=
()
> errors
>=20
> To avoid later calls to dma_unmap_single() on address'
> that fails to be mapped, free the allocated skb and
> set the pointer of the address to NULL. Eg. when a mapping
> fails temac_dma_bd_release() will try to call dma_unmap_single()
> on that address if the structure is not reset.
>=20
> Fixes: d07c849cd2b9 ("net: ll_temac: Add more error handling of
> dma_map_single() calls")
>=20
> Signed-off-by: Jonas Suhr Christensen <jsc@umbraculum.org>

Thanks for the patch
Reviewed-by: Harini Katakam <harini.katakam@amd.com>

Regards,
Harini
