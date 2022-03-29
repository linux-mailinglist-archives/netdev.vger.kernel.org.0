Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E0A4EAA5A
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 11:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbiC2JUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 05:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbiC2JUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 05:20:36 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80077.outbound.protection.outlook.com [40.107.8.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF6C12627;
        Tue, 29 Mar 2022 02:18:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMdjh5utQfl+8jZesoZHDKn+BpT2RjXdaTfSKf6pQ+pxF0h74tPri21BgCUlU5uT/QotXYEGttCNo2j1eldwSESwtgvR9aZ8XGump4H0CvfaCmm16qVs9udlFRs8PwpYkZDLJM7JztxZzPuOuMcCLfoVspqTemwMV7+bIDcMwnT6ldoESEVCf+92oujU+cUvRHW8vKCCoYaWUnxTMZEJhugpSF4+WE5szLhT19jZJPbQF1flSPiXaQnQuslzhG4IKT1QgilFxgP6GRzHk6X+g7ePw9HLsRyj1MYLZijk0tYY7PYOfzpy/IXYRCOcumqVUUmx7qNlUJphvF9vYueuIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jh9Ztu8uxXSY13Jsw2eXfD8PTcbhjLbiD5lDBMYJIpg=;
 b=NQ9cysfD3HjQTp78SRlkOi2nEkpAqMlg7Hj8WsnvcNoW8qen6nibWt7MKVDugiOmkF0tnb7MQggD2ZCiGfNLDRURuDIahY1KyytmJGOvVGftw28xl2otiGyGCaOfLxGRY+dDi1sdcdJTyj1ONEoVmbebcZErJ20GkdVYbThpuxPfPmhLs3AZIl+1hK+vSMGLO5pJFmYO66yzHRCkjHRqAZYKUFTIZzt+8zZRuX0ALjghGRnNlsULjO5ar66Ad76lrZGH75D7z/mFSa8MkBp8Mztt5wswz8GreDBWUKSSPAoc1fomyMOCuiSBrZoUyLTal0VbYqA/wajqZZmCratWOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jh9Ztu8uxXSY13Jsw2eXfD8PTcbhjLbiD5lDBMYJIpg=;
 b=ikqkbb9PKWfcCh6PNAjr3N3hD6gZYlaeYCCICr+suFpe/sD2ijyAzzsWB58V7WpdrmFygnNiKD3/P90GS/u6gr8KJJNZM5PfQnM3sDeHKofJYN6z+6vZMywUvabuHpJ5Tk1Cb4IiinLgEd4/XkRlkzI8903nEhDi9sGnCfpQTUQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8249.eurprd04.prod.outlook.com (2603:10a6:10:25c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.16; Tue, 29 Mar
 2022 09:18:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f090:8a7e:c1e1:3d8e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f090:8a7e:c1e1:3d8e%3]) with mapi id 15.20.5102.022; Tue, 29 Mar 2022
 09:18:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v2] net: dsa: felix: fix possible NULL pointer dereference
Thread-Topic: [PATCH v2] net: dsa: felix: fix possible NULL pointer
 dereference
Thread-Index: AQHYQ0zySk/umKLd5UCso4wZA+nelazWFWQA
Date:   Tue, 29 Mar 2022 09:18:49 +0000
Message-ID: <20220329091848.tfzoszmvjp47jre5@skbuf>
References: <20220329090800.130106-1-zhengyongjun3@huawei.com>
In-Reply-To: <20220329090800.130106-1-zhengyongjun3@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb99f3a6-98d8-4012-e715-08da1165225e
x-ms-traffictypediagnostic: DB9PR04MB8249:EE_
x-microsoft-antispam-prvs: <DB9PR04MB8249A3E83A0C2A742AE053BFE01E9@DB9PR04MB8249.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0WbiRytASD0TV0SAvFyVueR5+uCYwW2BQ53+L8XtRsBcaNTOPqIBKdxC3CDAJcfUFlrzO0uWOF+kLgJEZCYSiwiHR7ltWaucZc07DLN4Y1RyVIZBDMQ0RMesZ8jINmYR7VP7TV3HoFhrcJ+WSjT/batAeID06A0uBlwFfR9FGmni45eXC9DuJmCZy5OLrP75lgt0d9bFHe9FZ+qFK4JU41SALNw/1AuK3KwCdm7PKwQw/gaJ8HDZqbRpOUUyyFoX8t7PIWB5wRxIFeq0v62rVFCfrw7aotgB6JmBaqiHpfE3uQ/ixmpzIYKXOt5Sj6XQengji8Q/dM4/D2gsmUVi9S9EL/qF62qv6csX7UbdiXSkoU2WHNimXKLIH2aQPgiSm0Az5LtdpK/3eFMox+N6QG+Vhs8dD3IMYcxGS8Y9CbXE9cwUDBDI/wJBG9Vv8dIi7WC73esRz+rAwJQOOfLE4ttIUXOykGe5IZXLzGxvpW3TY11lZ/Y1j1RIcdGAVge4K0xvsJgnMbT/LgDETSgVcfDo0Fx07mnpCmUOtmyUNiUEA82snG+pAW/eRCRe0fapxEs609JHNTntXJKaLBw82PEmWYfj1QcUoGkUxiDpIp5L4gRfI2PKqv9xwgLZa3ixvZfflayY/IR099fNRFQtmt9ioxgjCetC+8U8DXHUJsU7c0mjmau8L0HKI+b/RtYSfb4hEv6ueeCZDC//vvKgvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6916009)(54906003)(83380400001)(316002)(38070700005)(38100700002)(1076003)(186003)(4326008)(76116006)(66946007)(66476007)(64756008)(26005)(66446008)(86362001)(71200400001)(8676002)(66556008)(33716001)(6486002)(508600001)(6512007)(9686003)(122000001)(6506007)(8936002)(5660300002)(7416002)(44832011)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wzrfyAudkwk+mxOwH16KszHqSFPoyJAbETfa7zf3JenhKvRzlUBk10DTdzpU?=
 =?us-ascii?Q?SGFKl5Wkj4Gcbqse55pTSfPRywuDNuehNmR3/dBf2oBHN7FPbif+HKt8xuJw?=
 =?us-ascii?Q?RPcd3yqDhwkKfhUasGEknAeYpkH3FJRKTzFzBokc30qMk0O8jpkCC7MG7fmL?=
 =?us-ascii?Q?VMjYu5lUc537D+hyGQE1DPVHhHGAML3xK7hLa1i7kVwfZpZ0uuUMOwv8bjEQ?=
 =?us-ascii?Q?cmdfR2CwcqgrDd3i33F8cEb8rdNhfx4yzE9b6QUADRB/kc3JgC3mWoFL/NPL?=
 =?us-ascii?Q?l5vo8LRmvWzXlpx2JG6Gd5xLi69M8trBhmTFuF3TYsdsyoGAjh3uNKUrT6Be?=
 =?us-ascii?Q?lqnC7arzntthSrf8IMuiZzwxHB9xuZHPcQE9BHc+2ZkEUgUpaRo59bWKrkmg?=
 =?us-ascii?Q?18DANOSdSY8dEuPhmesHHXxfJ8iYU7OY/7uBwVgAofNgYP/TNVLyCClozacj?=
 =?us-ascii?Q?qeasZbD7LCIEHv7OHbmFwDSVvt7C2/LN8l3rO64y2lv+l+Yaw6jaGCf98SD2?=
 =?us-ascii?Q?o8+vQN1KrMXBtl9hYriqOeTwfz5uD1i26F0uMbC5X/5V3dLo/c5Z6HezvvLB?=
 =?us-ascii?Q?p0b6F9s7oJsbdmx7b+UPcaTfNxK/Ud7N6/6wWkDYPYOsoH0DUUGXJwv8UhHz?=
 =?us-ascii?Q?RImJfXfcXqIqJPzC4KHX5wnsiqyop9KUrqbaGhSFaHvi6+VLY/PtYI/x21vU?=
 =?us-ascii?Q?J9MA+K3Ybh0bACKLmkLSMqE5MnYbgojC8PnHQqyrID84QeLC/p+emksNdjVY?=
 =?us-ascii?Q?LuhRY21D0OxL3XIXyfjh/cJanVz+UbbdtvXdiomo9cPvfry1QqwCtk8yVKQo?=
 =?us-ascii?Q?FQRELBfyM20ZbZkwl7yFlXEV0/tBVJIgw37DbB+sprvmcCgPzT1GCCXuk6wO?=
 =?us-ascii?Q?CEGj1u1cCbM+VqgKxj5S8g2pEJLW9ma1tKvMNwKFt31qdkhkA1o3QS+E6ErR?=
 =?us-ascii?Q?TQ/X36pv5MZqfX82ME4/bIl9WsDu3NziSjZH+FTlNiIgNdBkfg3pQoAHRIR1?=
 =?us-ascii?Q?RBNvOlKCLskOIfLgrF/sblhQu2BW33Ap37UJYuxKj5sjDr+1TEDR4YH/DYuW?=
 =?us-ascii?Q?8uvTIru1xM41/NXvYQr8zxN0tHiGAMRxeKi5US8Vm8OMUpMwgAUEhdPDz8Ka?=
 =?us-ascii?Q?0Uz/TgFMrJR5jy7priOo9daGSbXmLznk3fYrZ2FGVsqncpc+nYWKh/XM+z3t?=
 =?us-ascii?Q?t9ehRTJmB1ok/7XXyfMpDDXH629Ewbfaf6mZl5+EgzSiygITqflWi8KR+YpF?=
 =?us-ascii?Q?N7JBqg/ImTIwy6nSSl1cu11Gy7/ukI2SS98BeWDJ3xOVTBuRVhhff3pt7Faz?=
 =?us-ascii?Q?zn0eg/78ZGCDxdjj40CB3qlMy++tZyN0IQcPe+B09SZdnWUL930X1Fr9cs1F?=
 =?us-ascii?Q?U1vjyZ7esnB/Ae6WnBclGKytyQcDSNAoJKfmEF+DB+X6939ebicKfNpPpmCs?=
 =?us-ascii?Q?qBf+uiDToRJ1j/yz8YB07GKOJ9Tah1ffkR48BcLNkFOjeS86p+Y4lntvKnh4?=
 =?us-ascii?Q?aSm575P8gMhNrUOJPEMBwsgbTgHM8bE28k98QeCHSm5NZ2dPNoJtd0lN2KPg?=
 =?us-ascii?Q?V15phqE52FNXrd7F0a9DWCY+GHGNAHVPew8GLxT+Agh3B14qMzsI1xoMqDp/?=
 =?us-ascii?Q?VdLSctVDkWXihkmZ/a6qi9SavwoLLl3JA7YvHwJ0Lm85wmqa4NdYzP81DHsT?=
 =?us-ascii?Q?73SUfFc9UCFsrPAsQDuAsuPhB5Z+7B+bVVCt3Ntgvck5LGqnzGCEqlo6NIsf?=
 =?us-ascii?Q?vsjrmnyjQiH0bd8Ta2ahYTBMxj/HNlw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A65AFDCC2638784EAA3FF47A9A016F3D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb99f3a6-98d8-4012-e715-08da1165225e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2022 09:18:49.1266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: reGq0o4DnyfV+BHB90pKqrtIoSHuvHqtp2DQAHdJ6zEQZO3joMI7hfqdYh/K/pLdWxahkSg3xaVUNXEomZOBlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8249
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 09:08:00AM +0000, Zheng Yongjun wrote:
> As the possible failure of the allocation, kzalloc() may return NULL
> pointer.
> Therefore, it should be better to check the 'sgi' in order to prevent
> the dereference of NULL pointer.
>=20
> Fixes: 23ae3a7877718 ("net: dsa: felix: add stream gate settings for psfp=
").
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>=20
> v1->v2:Rewrite fixes tag, delete extra 'q'.
>=20
>  drivers/net/dsa/ocelot/felix_vsc9959.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/oce=
lot/felix_vsc9959.c
> index 33f0ceae381d..2875b5250856 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -1940,6 +1940,10 @@ static int vsc9959_psfp_filter_add(struct ocelot *=
ocelot, int port,
>  		case FLOW_ACTION_GATE:
>  			size =3D struct_size(sgi, entries, a->gate.num_entries);
>  			sgi =3D kzalloc(size, GFP_KERNEL);
> +			if (!sgi) {
> +				ret =3D -ENOMEM;
> +				goto err;
> +			}
>  			vsc9959_psfp_parse_gate(a, sgi);
>  			ret =3D vsc9959_psfp_sgi_table_add(ocelot, sgi);
>  			if (ret) {
> --=20
> 2.17.1
>=
