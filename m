Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144E551B028
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358453AbiEDVOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378530AbiEDVOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:14:02 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60085.outbound.protection.outlook.com [40.107.6.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0186862E9
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 14:10:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odQLXII+hDwimRV1Apt5SpLfjurG/dj+UiasZ7T+BW6r4XTjARDWlfkmZJUIRnzAXdISgU/6W7nLUVkXNN0q9nbO/83pF8xgYZuPa+hf7d8cZzzuNA+ZqQLzj0z0m7AZvGbgzKRCyxyLyTCwjFx/gdmZ06qh4Rhej5ZaAwrDna8KM+bPcnEndFd1kl018T3cE67FWcZtzgdD7rmcNaRcF/9HCl0Q0Z1e98QMWcJVx9jar7XHCl77ob+frd+F/8Xlkgyz2BGS1C+MEbAMg6YLFe0Ufk465WSaJbLOziH5MWwIvPyROkt0KbgEFdb4EgHUxshU8ZIoXGS+evsDAJKClQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e5j72fBKlXkPw7n7B/OGLcQ8SPEkeeyj323oC+oSCTg=;
 b=LxRM8iOx+i3o9vCef/nf8mULMgI7B9RhO0U+rigQ3qmQgan23oH5uNM02cZN5zEtEksEIFV+G0imhHgUYEa5jlyEajR1FXHtUws+9zAbrTMaR7kpfol56qJUzqQBpurVhbSCUUnoANAfWfuL7NYoc48ePqAL5n02v7Vg6BI0Zhush2YMMiM0J2gaxWAfyna1BibMechQgiBdHKKDK+k1R0XkJBVUaqKDV5qWQMwNOIIdPf32QpS8PVGbcKsUk7NxmoJ2tKS68LERyXV8AljsHNjD2IFYvjK1jmIc0JIIZMyuFgqEA9BwwzadCWTELlgTMR2QdDSmR/6/0t5lAr2FxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5j72fBKlXkPw7n7B/OGLcQ8SPEkeeyj323oC+oSCTg=;
 b=jHarlmmpnVSF4XcX0HE5zv89qQyywQY2ffJW0uLP9x7YIs7IF39y8GEebUIUJW0nGWqXtocTWI3CBk+3/9npEo2+IippXoHetSn1hpgrvZXF/teOUfDzXQlLoTpIdkTJtTFBnyCzkKJzVMJ3bavXTk7iVylHa6I2FLdmUOGaF+s=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB5575.eurprd04.prod.outlook.com (2603:10a6:20b:9a::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Wed, 4 May
 2022 21:10:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 21:10:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: Re: [PATCH net 2/6] net: mscc: ocelot: avoid use after free with
 deleted tc-trap rules
Thread-Topic: [PATCH net 2/6] net: mscc: ocelot: avoid use after free with
 deleted tc-trap rules
Thread-Index: AQHYXuUEhP0+UFE53kei9Q4RN5j5Yq0POO4A
Date:   Wed, 4 May 2022 21:10:21 +0000
Message-ID: <20220504211020.dffltlb5is2rcz4g@skbuf>
References: <20220503115728.834457-1-vladimir.oltean@nxp.com>
 <20220503115728.834457-3-vladimir.oltean@nxp.com>
In-Reply-To: <20220503115728.834457-3-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a45f346c-1c72-4562-7b73-08da2e127ff1
x-ms-traffictypediagnostic: AM6PR04MB5575:EE_
x-microsoft-antispam-prvs: <AM6PR04MB55750570496E6ECF8509D5E5E0C39@AM6PR04MB5575.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gz2pPYXOGSIaSmf/iM1lRKJqr4Rs1YFvGctCA2Sf35KG184nk4FhbAcqbuPtBDVpCTTSD37PK/Q07aYcojv+qiqeVmQYHH+Rg2kd1CqgVtfCaIrqftO0CMEbKfX+NKaoRHwUBzI7iRqVVLFXX3LfvVSOsojJffaSXQPz1EbKMhosxrlsXaGEfmtA4jNKFoSRwjFtyZm9beg6Ml3W0e/oKF5+wgNyf2gX1JwA45lDWo8QsXdDjft7alvm05i+FOH2thuZnRSV0TARR+iiys4DNjZDZcI8AI5G7fEtHCPQC8ucJZAXT6qI32nClJlOTr0k8v9U2boZfTM/E/ItXORA7rdf5dwFBxaIq07s/z1au8TbTyJYkprxYtjJIda0r5U5a8xv7qSRbou4+x3CwJAIRm4zlS6ZJPkMQrOyHXCS9Pvo3ms2WzKt/m4zAe2yNTplyGJw1qvjJDTgRAb4GAwqmEAUHOrwrXIVF7siQ65rbyjiDclUPWvk3D9DkLfZ3OjXOPq5/umV9dRL3hcTRT5tXMztKDaWs0+IgjIFfSmxj2a49Fm+8wgwmMxtNSQb6AGtZtX8dAjV3R0xjwNPuQCBLymUcPolZiPAaYa/CQGAT0iI++iat8CCeCUea8hF2hjkwxk6cHP9Hxp1za2ZsJg6+p6dWCrw3wD/kKUWKsXEIWzUEE0AGlR7RsIG9W4XL5ywVQAivB8TZ0rSCRbKmzSZ6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(66556008)(86362001)(76116006)(2906002)(6486002)(66446008)(4326008)(66476007)(6916009)(8676002)(122000001)(66946007)(64756008)(83380400001)(54906003)(71200400001)(316002)(508600001)(38070700005)(91956017)(38100700002)(5660300002)(6512007)(33716001)(186003)(26005)(1076003)(9686003)(8936002)(44832011)(6506007)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eo0cPaDmDTixlhxFvUjbEibBYOi3BqXHB2DLlrT6rusfcbu3eXnDjHZ8S1cd?=
 =?us-ascii?Q?5J7oFtQb9ScZAZuUwbQQ8xP4ccqFIk2jdJRFDlXh9VCbCsnbuvMR6e3bh6ac?=
 =?us-ascii?Q?BRoVZFbMYrn4VZiaUG9sUzYvlUcTlxoI83Ri1l0Pt+mbmmFL0Dgo+oRevgt5?=
 =?us-ascii?Q?RUWv4cvSrz2GQArB2MQWQ8LvG0CVUMwuGw4hvi02zGpa8OBaszq5YbPA0+sw?=
 =?us-ascii?Q?Dpz5Sq9n8a/PVjutbtzzjdPYu/TCqyn2M1PwHz4r6bJ8+AogfbOlFb+oMFl+?=
 =?us-ascii?Q?zk1cJ51LL0ZukLw6IZ0+xJcwx9jBMtAVmaTR24+1LPvDZKoh0+BI5DBvetW4?=
 =?us-ascii?Q?lmAKE0L57BkAqZKWN7UP9IBqXXnAAs80YGaHQPhCRcEChSWjZFr2OzQsP+We?=
 =?us-ascii?Q?dzwada9iBc9HX+GPqJESgXjhAcKKBzRgF/3KZq4p55BSX8IR0ZbAMJp2DxrU?=
 =?us-ascii?Q?AsBu/RN5Hy+JfhERqKZQh3cm6pa27XiHDxiHQX2yNr9T9Xli4KKqpFzNYod5?=
 =?us-ascii?Q?ommIUhmHYhnoErfrhkcOvlgmW+n5XR1mzJNYZ8XFpHm0Uzxn1WVy9urXhgKb?=
 =?us-ascii?Q?TjHTGllt8PaJz4eT0Q0fAHCVu2sjN9oOUHrNy10A2jUX75z+nqjRTjWgaoRN?=
 =?us-ascii?Q?d7vHp7JuvRawJP6zFHP3nHyZ/nINbYU3c25lDYgO5mxTqH3M4i4IRJtHotDk?=
 =?us-ascii?Q?mS6vDZ98l98p7aJxctfeXF9Y69mOFl5mJQMV+pV130Gxh87NS0X8UP/Qg0Hg?=
 =?us-ascii?Q?jWPIQCTCQhNx/5naw4uCyLa2mL/hp0gJXjPBrUSI+R1pjVJ1yomvNDvcM2ID?=
 =?us-ascii?Q?yYor18BGAUac55sqY8gOWHeTelDHiUu/3f5NT0Ym7+q9s2nwzM/jpLBJ/ZeA?=
 =?us-ascii?Q?Dyit8tW06bM00HW33TJIvodV1Jj4z4Mslpzm3i2ZQYBUDBCHdrl9+NAJLG+v?=
 =?us-ascii?Q?wpehaZ3fAKXS3MJ1eIMzFNPIv43fPE8dNClG7nbnNMtDOcM37E/fV+w2kiE2?=
 =?us-ascii?Q?PBClEXigXWBXKBsf/sL3tfjhM57mabV3gfG5cxL76lIKfbOhfZ/Nt05RwmVW?=
 =?us-ascii?Q?hjqb8LhqurK2EKV1f4JjFQLAEgHh6fgzV2wOTmnqH5DqmFpZbZFujbX3m6SY?=
 =?us-ascii?Q?PhYegFP+HOFxzp9rmCYTQFGD47ng9SkiGxsnqVZjobLSbCfBKyeKNHbC1RfE?=
 =?us-ascii?Q?+7VjBjbTJtCZBjwHXIHXEXmyh9Gn4RtHc0MqNLnQSv3uCpvVGZf6mCpG7GYI?=
 =?us-ascii?Q?b8FBk6/NOkmYMXLj60/LNevSypw0LbZS7DV+66yA2PkIn8AoLHYG5Ro0omLJ?=
 =?us-ascii?Q?S4C24rZNBk38gWMueheqPr4szHAXwEqeCAofTsxOlkuQhJuBVaV5hsSOTr3M?=
 =?us-ascii?Q?/cF1HlnqHtePLji8jih9bcSqYiwdaHl85T310VcBwKpwh9+M+z6trM1V5ZB4?=
 =?us-ascii?Q?jOCi64Kjny297lYBA78AoK0UJw9yqxPneE/y7I0GTXatoG8L58T/SCqOpZ+m?=
 =?us-ascii?Q?ob73Fgu6c7tT/u4TJAAtsbBQrI5gtGTMR7aeQCsEXlrwPXck/xfs2oGZZ/9W?=
 =?us-ascii?Q?ycPYD3o+ym/2ebejb3b9e+idDqwRjT4laEtpPxp8m6y7qo63Gaz+9sIwrsHm?=
 =?us-ascii?Q?IDIZCdCPpOczrGm/oO5y1zmT8r67F6bsB5PtJdF73ahb0djtG+mse57aqL3m?=
 =?us-ascii?Q?CinO7x3VqBfnG6uYqcOV6zqbTfyZg8+rBvtOL503HLsN2hz63iq5ZZ5sKLu3?=
 =?us-ascii?Q?OPprF5XvCFhEQx+ybMuFpkp2WmiA8Bg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4A8B15DE4CAC12408C5377C4F69E20E5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a45f346c-1c72-4562-7b73-08da2e127ff1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2022 21:10:21.7011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y1qY84yHjZOjw9+CrLU7NLnRqHiGVlapgKELKvzQDuHyLrJ+pOUtRFacloknB3evAeNKeWB57OROBR8NS29BFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5575
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 02:57:24PM +0300, Vladimir Oltean wrote:
> The error path of ocelot_flower_parse() removes a VCAP filter from
> ocelot->traps, but the main deletion path - ocelot_vcap_filter_del() -
> does not.
>=20
> So functions such as felix_update_trapping_destinations() can still
> access the freed VCAP filter via ocelot->traps.
>=20
> Fix this bug by removing the filter from ocelot->traps when it gets
> deleted.
>=20
> Fixes: e42bd4ed09aa ("net: mscc: ocelot: keep traps in a list")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_vcap.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethern=
et/mscc/ocelot_vcap.c
> index 1e74bdb215ec..571d43e59f63 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vcap.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
> @@ -1232,6 +1232,8 @@ static void ocelot_vcap_block_remove_filter(struct =
ocelot *ocelot,
>  		if (ocelot_vcap_filter_equal(filter, tmp)) {
>  			ocelot_vcap_filter_del_aux_resources(ocelot, tmp);
>  			list_del(&tmp->list);
> +			if (!list_empty(&tmp->trap_list))
> +				list_del(&tmp->trap_list);
>  			kfree(tmp);
>  		}
>  	}
> --=20
> 2.25.1
>

This change introduces other breakage, please drop this patch set and
allow me to come up with a different solution.=
