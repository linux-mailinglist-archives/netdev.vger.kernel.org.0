Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A267768B9D8
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjBFKTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjBFKTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:19:33 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2076.outbound.protection.outlook.com [40.107.96.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C321EBDA;
        Mon,  6 Feb 2023 02:19:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpCUKfTM2wU5xCXqbGIMRXeylojHnPvo3vzc2qlKBwqnRfpr3Lgwb0LLLx3B2LNPw5iJH5bjoiGPOhSv0IG75hfxJteXGH10Ue3K5RE7sllDIAxQDTO+ZEuF6WSVqc/SEulxP6G0ZP0vGOzipSzIzH6XvSkwNI9Ei6TSLSV4IB/qybkDeqiREmoOH+THQO+y22yfeZb/AEEYuXF3MJ5byEBxWEd54cotvSy825em9aNQy4vQM+nhiCBM0RtU+XDCJYZVgSj3z8+4hLzjnRh08TY6Wt/EpcaHuvDwx1UGihV5dGNoE1Hl52Wso9bd6W4aqjMaqytS7X/TFGpdlb2YMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CAP48h4cBiY3bvp02B4AiGerHdHA2R7kdjE+ikQFVy8=;
 b=Ubg/UWYTjgRxVu5e6MDFBQBQ8i44oDkqbdRENIVSx7W0O5HZuCnPI+nsH5Be7lPaBI8qVS91Ax4ve0e3IcGdyIr/cH+5+fnWUAGJo8R0eToMDOUEg3CZNAyFBvisCtS2uoHzwZ83X6VwRjc2NrMQ2EJN/fFb4KrK2kXyQlMkxAxndtRswOqLY+jNkJGPy/RGXP/u5aSHXBhdXfTrP4Gu+TGSPSePzlANelbpEX5D3Uhs6A70fvlY+Tk0KqOVWPJ9SxL4r3R+6UAdJC69brJtgpdgfh40pJJWY6b8GjexYquAFFngwkVStFg9kJGeEQRbeRhSP3Yc26yXtNW3ptjwdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CAP48h4cBiY3bvp02B4AiGerHdHA2R7kdjE+ikQFVy8=;
 b=LXpBlKef5Vv795NpqTDDKD4ZmaXnyE8Ur69/b69gY0kirQ01tyRmrXxlijRR8Lae6SvHJs92fa5xgj/XZMovGua3vdWC6H3C5u+zHXABthuEHjPlC5CYSxMxL4RhUqxoVtUCYOk/BMnA+Yl4PCuCAewVke+pJYg/yop4xQ4dOTQ=
Received: from BYAPR12MB4773.namprd12.prod.outlook.com (2603:10b6:a03:109::17)
 by SA0PR12MB4462.namprd12.prod.outlook.com (2603:10b6:806:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:19:26 +0000
Received: from BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::4b32:afe9:e23:ff7b]) by BYAPR12MB4773.namprd12.prod.outlook.com
 ([fe80::4b32:afe9:e23:ff7b%5]) with mapi id 15.20.6064.031; Mon, 6 Feb 2023
 10:19:26 +0000
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
        Wang Qing <wangqing@vivo.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Esben Haabendal <esben@geanix.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v2 1/2] net: ll_temac: Fix DMA resources leak
Thread-Topic: [PATCH net v2 1/2] net: ll_temac: Fix DMA resources leak
Thread-Index: AQHZOZ4bIaLXD56kTU6BDUgiXUw8vK7BtXBw
Date:   Mon, 6 Feb 2023 10:19:26 +0000
Message-ID: <BYAPR12MB477319ABC35AF5A73B5D5D0B9EDA9@BYAPR12MB4773.namprd12.prod.outlook.com>
References: <20230205201130.11303-1-jsc@umbraculum.org>
 <20230205201130.11303-2-jsc@umbraculum.org>
In-Reply-To: <20230205201130.11303-2-jsc@umbraculum.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4773:EE_|SA0PR12MB4462:EE_
x-ms-office365-filtering-correlation-id: 54ce492d-6558-4074-5dc8-08db082ba018
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RUWYzLbgzxoHKkR6Rooh6R3sP8A4wj/tVmzc32THXJ/jk+V7Q0TddJ2BXq6YwKhxCiFdZL4Ley/gGCtDR7Dfi6l9Iqnv74R6VASXJgawPBFTTf4bAHPG137APpwufDIm8r1UM0gOqww5bQG5/v1lTOdFQharJ9O1urarE4qgjXDm0luzPa/twlhDrBJr5ZK2+SCBfBIA1Q2vWAoqtu1rxST1UJ+JJ+LwlHtiqvQrD4xHW7faQ8GTVQwstoaJC4fw4Be+BZM4WXa2u9IqEttpwdxiDmrOWSkUOCl1zSxUJhzsRTCHyUqinTbha5gGSBlUSwl2k3BUIjjSiGSAaClfFEC9HMh2yIHe2FUuNkZdDNoP3Crz7cUzqS2ABmR0U+3NMKfRWMdljARdu9d6jngu7Ymq6oVgLsvzRUajG6d6eAySL/oPB383q+LkDPgzT8c1fKivQvTDyQ4Gy7e6Yys3iQaKSP6EboXF8dofJkTtG2aZwm1NQX/8X0EVdDmM8+Trt8qQ8OT0v6VfpgPI9ry9KsKe1+tRf5Qc8TECEHjh3VbACyjY3bKl/sCR84/kAUImWw4S0TOLdfhKqT5rcE7P2qQaVzBV6XCN/BIqVkhNx/SKjd3QpqjfzUTRzm9cumRZ4YmZmhh8bClNkJcd5+b+XBLMHacBJ/c1cW1yFLjUJHQvTRaAdKhmlGcShcblG61wenMJJsIoOu67BPxM7cdJGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4773.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199018)(71200400001)(7696005)(478600001)(316002)(54906003)(110136005)(6506007)(4744005)(53546011)(7416002)(52536014)(186003)(9686003)(26005)(5660300002)(33656002)(86362001)(122000001)(38100700002)(55016003)(38070700005)(83380400001)(66946007)(4326008)(76116006)(8676002)(2906002)(41300700001)(8936002)(66446008)(66476007)(64756008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ilrGgngpzzIZiD/wrT93BIc2JoP6w5aSAbVwO8tBfvEBVnd5Ym7pNqNMdOaq?=
 =?us-ascii?Q?4t8vL2DyJMSWUW0NUzTk6Re170NGCTRs13nBYhmYtEB5I8fAAC9+9Roho9JW?=
 =?us-ascii?Q?X23C8WIyRFlOJ7nb4F7zfEwjqqV4ieONB59QracCZmAlTUahU0gcYADloTZ3?=
 =?us-ascii?Q?ckz5s8IAIGTIJepicTcfOwr3nWNBEuN4SCKD1iRNPUlIKNszFdSbfjQmUb4n?=
 =?us-ascii?Q?sfJQcuRTDutQLDE6YJro0DoWqglS8FfZpNneWXWhfnQTJtyD88ZjbrAg5l67?=
 =?us-ascii?Q?Iq1Gm0G/iX6HuLl1GWRZaLvkpPV4Zt4uqRimusu7xkpoCqu4X6+6kWOPFmNN?=
 =?us-ascii?Q?0coazr38YHCXBjap/3ZjBtPWD+Tw2zaie4OQLh7UXVOQrz/RZfgvdjmR3rhb?=
 =?us-ascii?Q?9qSGgIJZwUhgNCGax96Dtp5dTUtsiAs9tfghR20aUIvcMnqANWiSmx13s3Zq?=
 =?us-ascii?Q?8eigcMdKorFM18HVKap9sP3xoPz0BzjivbYQjybCWaqRmC1bhCFSJyPO6sIO?=
 =?us-ascii?Q?rUKsTV7mac6/+Y9Clh4ylrhMfLmqoL2gyn2rjruoIYSzHEv21I7Q383w1Lvf?=
 =?us-ascii?Q?YhbN57EXR/1HhLcAJEcYBN8IyxUrDNkNcDY4li9IgspHlyDvTOchL3mgZvTH?=
 =?us-ascii?Q?75/m7LGiInk8bjFqFWkiaxR7UxS65xrwvPJiaB9uT4zCEpgIKepif5PMJNqk?=
 =?us-ascii?Q?ZYc53Sp9/46XUKtZ8z4B0jhDmOdlWtRaN4DxJCzCzPIY+JlZY4wmcbuhR5tP?=
 =?us-ascii?Q?dkChoaWcVIhYIZFihBcYldmFdqf23BPIicyGMmlZ1myVL/h90fNXhCsiGZ5x?=
 =?us-ascii?Q?GBKxyg2M35rDdHtMzLLhNX87aMaUGHUWAARxinRXUeu3OmJaRTsCKKeMlARs?=
 =?us-ascii?Q?ZoFkIyHAlUKW1aLqkipJro+8+0/hFuYILUWWpZhnSsiAoUBYTSWKO3Iu/8Qe?=
 =?us-ascii?Q?3p2xUO34LiQ/GoSIT3l0Rz6VIRLms6Yt0F7fSOoulFV3mIRhpTEOjsQ8JrdW?=
 =?us-ascii?Q?rSdbeYjRbYdan7FgNq4H7gTGWncvVKxXCdKVZHMEE3cORMMPFXmlKfiRWlo9?=
 =?us-ascii?Q?wS1EtTp8ZImPbGwucYlTlQUFDonSMmFoVWlk0Z98IeIh7B7WaEdDSy+HC/3s?=
 =?us-ascii?Q?LoEImgj4kObH8UGW8oy2e0H1w0uLFN5vxEnh7ywONu81fquh3b5Sb2VnmlFV?=
 =?us-ascii?Q?cWuN51FgQudMZOMyszo//jYLTyMhloPDZMvr+sJOsTJHkssBmUAAx/nfEi81?=
 =?us-ascii?Q?2y69IT4bZfq8saWdCEP+3e7yDDSdOwp8fkuqc4PnJFgBQKI8TvwZ9c3M7t6Z?=
 =?us-ascii?Q?HYxTaai+y3dvL/qTujiOfxAB3Bm/nZrk8OgDsjWUyRWXFuqQts7Z04FmKcBI?=
 =?us-ascii?Q?H/BCvgTWAeI7IDYhJ6AX2xQP6rb6ECJTqomPEOrojhlyQKEeDoYTAz+PtSUj?=
 =?us-ascii?Q?9wOqeL3MC+uGZC7Qd/FO6TY3uu+TQl6sgTE/lLD4doKgaACz2Zd6o+Jl9AMq?=
 =?us-ascii?Q?Bgsdec6kA/qV7Nl6DFkfk1PmuGbJTatCKsoZjLIpU7XDCg9CsNtdQSUipISJ?=
 =?us-ascii?Q?fj9Xa+8rg7Fhiq1hoKo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ce492d-6558-4074-5dc8-08db082ba018
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2023 10:19:26.5155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jzTjH7jGQD9RloKMCF/IomLFjBmRprHuJFMVABruDvi3x+2ZBhDjPi0QvEaUqGoK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4462
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Jonas Suhr Christensen <jsc@umbraculum.org>
> Sent: Monday, February 6, 2023 1:41 AM
> To: netdev@vger.kernel.org
> Cc: jsc@umbraculum.org; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>; Michal Simek
> <michal.simek@xilinx.com>; Katakam, Harini <harini.katakam@amd.com>;
> Haoyue Xu <xuhaoyue1@hisilicon.com>; huangjunxian
> <huangjunxian6@hisilicon.com>; Wang Qing <wangqing@vivo.com>; Yang
> Yingliang <yangyingliang@huawei.com>; Esben Haabendal
> <esben@geanix.com>; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH net v2 1/2] net: ll_temac: Fix DMA resources leak
>=20
> Add missing conversion of address when unmapping dma region causing
> unmapping to silently fail. At some point resulting in buffer
> overrun eg. when releasing device.
>=20
> Fixes: fdd7454ecb29 ("net: ll_temac: Fix support for little-endian platfo=
rms")
>=20
> Signed-off-by: Jonas Suhr Christensen <jsc@umbraculum.org>

Thanks for the patch.
Reviewed-by: Harini Katakam <harini.katakam@amd.com>

Regards,
Harini
