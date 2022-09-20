Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A625BE936
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 16:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiITOnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 10:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiITOnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 10:43:08 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00062.outbound.protection.outlook.com [40.107.0.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB8F543FD
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 07:43:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aeXv9bcq8Fer+1HDCMAYlDnbHqz4EgrHJcK/PWXh/TJCuYouCD0YziCTB/O1pNPc23y86QWozgtVZX4DBxXzdfgYmamXmbJ1qfPFzsfeC5QA0ypKwvPBhJo7IQ9UZZzckMUWoC2bXvOOoKdJJECmrl9xo14M+i+QMkgqotVWQqqN/dsVDh1acqQzQRsVe7iMh/MAQZFpzdOzucGlT43bu7dPO0+ea8uaje+S1/nPx/cEQv9ho152Y42E1bqtDeSwWUtZamrQOpW0C+rzGCRXbFSdVOsQawXDdc2UK/hu+SusuTlSVsj7o+Ap/EyfBsSiAN02L23azDUGzigZ9ldj0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tfNC8BRNjbLM2mE9pzA7Sh7+ZI85umjMwx06uhoyg3w=;
 b=hpXXIqly1rtTAH4cB3SiC7cii5a9BrBPC5gHoygsUJYkKwYk+sDEztJWomcLj1x/avqgcXg9HWrpDswwO/KN2jqroQX+zV45x6xnFCE63zaiaqwWMc4uyIX696RD1ZmpsL8s6OKdhVMLqTFukEUaQH282CbWmq1FyVUqnNzshJig6mHB15rkrS/xKdoFxtoPXd5DpLSq0/e61SFF1KVy8Tn0rT8r+oENeJJ5h9dwP7UkVAQLn/KoM0NISC/tLGilcQZvB2q0zde8T5nKRQq2RbiGJeQ0M5mMkUZlvp5ajgQ+1tNIgGqJru3YM5JLgiRSJyCY8pPoo3fMHSRadcKauA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfNC8BRNjbLM2mE9pzA7Sh7+ZI85umjMwx06uhoyg3w=;
 b=p5j209tQJku3ZpTqJTHptDGlhBXSNLNwcnsog+VEsYlUDQTHg1O5w38xjJQImDPSfOrdJIa1xlMiZidEAxsUb2VelNkkMfmgin8xOCWRGkztTNRVgPkAUgGVn6ateimMnZNrTuK4MF6YK4QPZiAt3LFN5HrSOjHYQDa8gjzBCZs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7758.eurprd04.prod.outlook.com (2603:10a6:102:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 14:43:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Tue, 20 Sep 2022
 14:43:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v0 2/9] net: dsa: qca8k: Move completion into DSA core
Thread-Topic: [PATCH rfc v0 2/9] net: dsa: qca8k: Move completion into DSA
 core
Thread-Index: AQHYzHXViyfkGghB2U2CmPjwCD82Sq3oZaeA
Date:   Tue, 20 Sep 2022 14:43:04 +0000
Message-ID: <20220920144303.c5kxvbxlwf6jdx2g@skbuf>
References: <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919221853.4095491-3-andrew@lunn.ch>
In-Reply-To: <20220919221853.4095491-3-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PA4PR04MB7758:EE_
x-ms-office365-filtering-correlation-id: cc3bb3f4-da86-4569-ee60-08da9b166d0c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JltOMKY46aaWBr1iS+Ee53Z0pvPYVyxUFNRA1QfxPwDKdLed7H4lCCDKRAQ7Gr2brzxqhTAqBbtZcGL76jWxBuLwsHxOVvffUkEV7Xbcpkh4Yus/ukIDHL+z4CWJ4HmlePtyd5WFye03hAXanTiOaYe+gVmgFF5K1Ufq32oJUsloQI+vVKJa6NxvnJdqSrdhey8cQQMvXFwIiJaeImAiIkFjttUVYK/lhr6W+14NEPd4ZxtxU5T/W3+RPRw/SOOnMGAAA7BiUS0dJY07e4EsImCQHmYnNwbLwi1zImAaMUpv8IFHhYE4HqJiLprFaR05/ExQR6y/qfOpWy6SHCpvfyeZfl5qMGQX0UfaP48Ld4V7cUGCdkTUiZ40wcVRXlzAiil5Rjuj5iETULK1x/r6tart4D6AP25APr5igDi6vNlbsEBBmjCGTSWRnhTHfI0fBsY3BOMwguFpdUpQHFmpVUSARA6tEOHOiP+wmz7mWlomq/vaYVKxd5kRnpgwJvqCBsTi13FP2sqhmcwsJzCPSekSuX1/paNVTgq03PxgMKHnbXSifdmZn3xniVkvSi7PdnHdJ/MOktgdoa/Le5EqoQByqY1fZfEwLAG/ufGyy9C1sdP3GM/QwZB5WsxFlO39r6wqb+ZLxkWN97pOIBgtxoCQKwY/pE9xPb/kHzxZN3mG7PDvXcVF02y8gqPgEH6D/4KkVFoBJM33YAihfpVX6X1iEesl4sJGDlRkHgS+HxLY3KjsERuOz7lBCNFNoSKMe8+fPDRVoEA8XVLmFbmhE8NfAR4y5tAZDB/nsJdz91k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199015)(9686003)(38100700002)(6512007)(26005)(122000001)(33716001)(64756008)(6506007)(8676002)(76116006)(91956017)(4326008)(44832011)(2906002)(54906003)(41300700001)(38070700005)(186003)(71200400001)(5660300002)(478600001)(86362001)(8936002)(316002)(66446008)(66556008)(66946007)(66476007)(6916009)(1076003)(6486002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?junsPGcgZW+tPUt9F9gfvZoyzLkAMF0EPqgNEm6rUP5bfqewJaqanI6TOSyB?=
 =?us-ascii?Q?TIixq8MyU0mTVTDf47ytI99CPHgJEzOvfzBBbuS+gzhEVGjVxXw2M3GZrYTI?=
 =?us-ascii?Q?BIV3PD/aWCp4mvyUOICftlR6M179k0qM+kaxzwH+8GgS9qZBJ3MDtt02x3GV?=
 =?us-ascii?Q?vuTVLWqxnxAvIvJgRpBhT+UCfPAUIsudsHEJwbdBmBLhyok2lsxFJIAjVKH0?=
 =?us-ascii?Q?plmhjpgPArUQaEw3Bpp7exg8NOaic74oiUzoXqTGExJYJQYJkfswcLuKVxHK?=
 =?us-ascii?Q?KoSz2th/f8h8jRF/Iwk+GlSFw0k6RKm2vFvVajlD18QhnPdbDncJ6Eg2/MMk?=
 =?us-ascii?Q?bDcsgJRZwCXGhB7XbsfLiVDazJLoq9D5cSuyAkFi+eHmD/xRfBI1dvR1+C9g?=
 =?us-ascii?Q?Uxf8ZTHqgL/DRyxNyHySP3k4D6I8xvinyvfEhkMP2pf7MSZ6F3EmJQc7axRu?=
 =?us-ascii?Q?HthL/p3jRCvtVsqP7sYhiuX0fA9832alXlygbQgEtgTB6o/cSbPCHcLOLczM?=
 =?us-ascii?Q?cZWb3vSqxJlq1Hp3aEWEfqBj0r2C/4y72O8y2Gt8NtCe+WbNHSLAvlTMePay?=
 =?us-ascii?Q?/tkaQA3yy82yAIiIdw4rbD6Ye8YAlqszRRbQTzcQAam5sSkL9appUH5kcAgP?=
 =?us-ascii?Q?/BMOo6Fv107HVIB9VLoBxEH8QCCt2ECwkA9XFnqzI+6Mnq//o2fbgqOL7TVS?=
 =?us-ascii?Q?NgTKltXS1rfMmHwqLhtrAbc31Vd74cRFYD5VFkiLJGLsYHlV9gWaXz5b4rdL?=
 =?us-ascii?Q?3N+kb3o/I5Hd0PmCS8uN+OuL1YBqLGuebyVaYnaZ4e+PQDCjOMb/hH8FMI3v?=
 =?us-ascii?Q?LSH2NLNSv8WLID6AbwjtiMCWWGP7r6HgRDZYCl0A/ls/+6lp6PAsx5D1OWJq?=
 =?us-ascii?Q?IyzrQoZdwh+Iyh50QhU+fQIawbAP81jWcdBl9SEliOMjpHwnQeBh9KdRVp9l?=
 =?us-ascii?Q?J4S8tEzkE7jvC+DicJd5JX/AXbC/1VjUokdRfj6y9glSgmc8Z0VhF7zcZezI?=
 =?us-ascii?Q?t8KyPmV0zjE3WKFgXXrRAO8llJWHYuKMg6xiHeeiseZHMBgOOIxkzGOsYUje?=
 =?us-ascii?Q?ysdgy6MNGcD1SS4GYMP9twGiFyas6+Q6Y3/SvxO/cQZdJXxWgoTfhQu3+ZJa?=
 =?us-ascii?Q?EBF06SK/XN/0CJFUd6lPD4G6BRoI3FQkageOv3LGHLMm3Q2sndK6LVCwVtye?=
 =?us-ascii?Q?kwjsSXwwlBXRQLF36vTiOcMd++mg9SvtAlZq9qL95jHtzUDVm4ZxgXi96TFj?=
 =?us-ascii?Q?ACvbZz56ihTvVAU80yAyE3dJb94eugJQUZV4aLripwWp5o3xJLsnSwGHpWKK?=
 =?us-ascii?Q?CcDGZeuM7JhC8e8OA7X1j1soT9bz/WAV46tx6PW7m5Uu8FL0Zj/Emu80QUmv?=
 =?us-ascii?Q?1lcuYdwDoN1mn/2CTRiea1io7fmH+cZpT8KXA9x2JymUznELG1S0H3quENht?=
 =?us-ascii?Q?iKinq5upRezWYHIopjP+1UfDWkQy2yij2JJiZSYqebx1QXW8mIb/n4dD1klo?=
 =?us-ascii?Q?at28s2SH1H60GPiFDxyN/Yhg0iC7fno98YqruGS9ImmdajKJfANt/dnjaQQR?=
 =?us-ascii?Q?Qz0GGLX2jEwk0UwCLTawWcbTaM6jwzwvTzVKiiwbZnq5iadQinh5iA10UGmN?=
 =?us-ascii?Q?4w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CEBE2329E5A6F24F8B65F356927CFDBD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc3bb3f4-da86-4569-ee60-08da9b166d0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 14:43:04.7340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1/H5vxA8kmHLlg5DibmjMkujECAGqL9t8RmMR045HZrt/7hk2UNQelkFPIsaQPyFTfA/frCo37xddi7L8t2fuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7758
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 12:18:46AM +0200, Andrew Lunn wrote:
> @@ -248,8 +248,6 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u3=
2 reg, u32 *val, int len)
> =20
>  	skb->dev =3D priv->mgmt_master;
> =20
> -	reinit_completion(&mgmt_eth_data->rw_done);
> -
>  	/* Increment seq_num and set it in the mdio pkt */
>  	mgmt_eth_data->seq++;
>  	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
> @@ -257,8 +255,8 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u3=
2 reg, u32 *val, int len)
> =20
>  	dev_queue_xmit(skb);
> =20
> -	ret =3D wait_for_completion_timeout(&mgmt_eth_data->rw_done,
> -					  QCA8K_ETHERNET_TIMEOUT);
> +	ret =3D dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
> +					     QCA8K_ETHERNET_TIMEOUT);
> =20
>  	*val =3D mgmt_eth_data->data[0];
>  	if (len > QCA_HDR_MGMT_DATA1_LEN)

Replacing the pattern above with this pattern:

int dsa_inband_wait_for_completion(struct dsa_inband *inband, int timeout_m=
s)
{
	unsigned long jiffies =3D msecs_to_jiffies(timeout_ms);

	reinit_completion(&inband->completion);

	return wait_for_completion_timeout(&inband->completion, jiffies);
}

is buggy because we reinitialize the completion later than the original
code used to. We now call reinit_completion() from a code path that
races with the handler that is supposed to call dsa_inband_complete().=
