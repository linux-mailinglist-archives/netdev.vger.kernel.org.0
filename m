Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A655F1D5D
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 17:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJAPxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 11:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJAPxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 11:53:45 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2054.outbound.protection.outlook.com [40.107.20.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC7161D70
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 08:53:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=McqhGo/cBd0V8u/9QtNnif/mQp1dg7fwTn2NbbLUu1LiqCs9YMiNneGv4JQ/NGd24aMj20mxt+7VaaOWKAOT9I1lOFUx6SMfGcQlf/nCjjoh3ToBAykUiaraE8oRntF6OZ75Cj4IHfCYL49h9MyJZEd0jQjx7b/dxzG5HkZtOKCjObRqZPG81cRESJ2JS36ySw0r5pLEjvFPCJmGAP7u6KfYaFNHcqf5ivBIcU8qP+Ny1CaWjFLlxk0JUWscdjIe6PMtDpHmMtgGsnZYaks+q43M1vwiWLSFsSJcOll3q3BFhxN5F/zIRJuQrJnLkptKA4hwxwWuIBlXQiS55M29ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jpHxjZsctxvyRu/YuTAmpzbfok6J5M0ni4DEiw+j/B8=;
 b=SGHA8oyDUnYUGYQyyk+wvlch49RBeG6KL9ZopdL2PgGduW24l3axA2YzcXweoKrKjcmlmDySkTcgP8fWiCCfZB5dYLCVnRekovJdb8zo9i0OsXONvLgFsCdpCqfBU6ltSR/w4jEkeUr1VLeEmVt7CrlmbeJ5AxbHW3jlMsS+RZF8biMT+6f8aUpszVEJcwGi4ywF4S3Q09lMu4Pmbv7skbT5q+beLMcvtOKC70wlWSVUhB5LNDQmvANBCOa5ymfAjvWA7CTAnQpny07gxcuE98i24v2woNvSdJhNoUYUmvY/v0ciPvjb26+XSjqSdsVbvD6zt+COehazywqdDUKclA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpHxjZsctxvyRu/YuTAmpzbfok6J5M0ni4DEiw+j/B8=;
 b=bpmqELkLVrF0za2+h4b4Kx5YfrIGELLF0rsQEc2mJP1sDvL2EN9TVR2Kd41nIYYPImnCsmmm8W1Qm/KierE0iYeXB/F+nZlx5OxP0gQ5nOPFUb9+Qhk4shhnMwtstWjfojdCPI6KuTnkfgPUIkuUVzxSQAGZYrd80X4hGdaATLs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6809.eurprd04.prod.outlook.com (2603:10a6:10:11b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Sat, 1 Oct
 2022 15:53:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 15:53:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC
 Merge support via ethtool
Thread-Topic: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC
 Merge support via ethtool
Thread-Index: AQHYsb+mq+RKMZoa5EST9UiAwGJ6ra2ycPWAgACKigCAAHRjAIBGiI6A
Date:   Sat, 1 Oct 2022 15:53:38 +0000
Message-ID: <20221001155337.ycodmomj7wz4s5rx@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <20220816203417.45f95215@kernel.org> <20220817115008.t56j2vkd6ludcuu6@skbuf>
 <20220817114642.4de48b52@kernel.org>
In-Reply-To: <20220817114642.4de48b52@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB8PR04MB6809:EE_
x-ms-office365-filtering-correlation-id: 2758626d-f270-48c3-4a87-08daa3c51b60
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dg0w/JsXrDgyYsZTMoRhgvD6mJQmTLL3GbghA527TTlo3kt0jV+S8Xi4q33u9bhi0ewZdMfX4cvIZLRxfhCH/EHjHQy0BaKdRRn29KkOBKxS7gh1qxgpOUzkIHbDNd03xNAIxw5OD0QuSG1zJIQTa2s+VQdm6azGzMxOmBsJ4skgPVplTYqG0YUy8H0NNpM5P2EztIjHDCMFB7zE3Pc+H6HR3nmsdZ7P2H3Z5/4/hagYNANU53t3kdyzr2yfyaNbHCLA93HefaJL7XzunHc1fFWH+AhJJn2hjhLGy15kpYopTNj154WDv3K++kdVdAJLHulBtneAKVwVNjPcJiZ2r7g9J/XWJFfhLkKg0oYAvxRda/JnIRkHeZj4miGixniJhJMF0VnEQ0ndiFgzLnQVWeN+QyIs6JGGnWa5oOMzS8EQqGSxUK3COkiA74YSOEqP9+3XcgoBllkDFPkQOF2bKRQOpNycXIaPIxHq5av28YHAhUnCNO1S3mgkLocnkSBjdnTBug4yLOG9ciHir2zshJC5n33UsHfcL15obKG33pE/0OpsIxLF/AYrPvdb1qaq/xhnd7PCDOCFnEv2wy0dJ8BC7dyXdFnKKD73S5hLf0OLPK4Vrce7AznXndl6cU50m5mywv1ADqsDn3oNh6l841loF4GVISbFGlXFxWjuLy2sInq8yvjcdWvZXKMiQ+MhVFcBJlUZGA9DGs0YgmQQYdKSlIT+tRx1vR5RN+ASiymcmZjIUq6RrPu/n1pMqtXE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(346002)(366004)(39860400002)(376002)(136003)(451199015)(38070700005)(122000001)(33716001)(6486002)(478600001)(2906002)(38100700002)(71200400001)(66899015)(41300700001)(6506007)(4326008)(86362001)(8936002)(44832011)(54906003)(6916009)(316002)(1076003)(64756008)(66476007)(66556008)(66446008)(8676002)(5660300002)(186003)(9686003)(76116006)(66946007)(26005)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NjzgqNEUhH+z1TGTxLKzgkNtm13lVURj21BBKLIyB8unO79GhpYL1FqFcqwt?=
 =?us-ascii?Q?uMIdO1/FL1hfJuB8eAHwFK0TNlnpyGBfQIiCCX6oz+F45WX0PhX1ZYTPPWgS?=
 =?us-ascii?Q?1g1Ar1n+4IGF+l90tor30i8F5n19HShjfMqbU2qvWVkTkOcW7iP6hZfrJk07?=
 =?us-ascii?Q?irY2dQl8XdTbjIlcqMKT5E10Ao2DAfOBU2phNWJsbKSKtW9DD6xZsKjtkMMf?=
 =?us-ascii?Q?CmrHS1hAxpJG+DWhImjmsUgwLZLo/wvEesf8P1JH8cm8wHCYGE9UWJLpXfWe?=
 =?us-ascii?Q?0wz6FYn6BQkZBLmyv/Mc1uo8bXHpNpp8LNPOmCWdY4DWTs+1muXF4jrxhSQz?=
 =?us-ascii?Q?k/RWIztizw6+sxT7Z0kGhGNk0d7OR8aI8dgRfjSI4uuYC5rvD/pGv2wHDsl+?=
 =?us-ascii?Q?gf9dwJUcICeyjyFA78GAWH2pN/9fyv8bOU7fiJpGkiERhJlzFl4aB/JazaGq?=
 =?us-ascii?Q?BcUY2fV114YRTtDmkzjIvwtyxsYzg/h3H1kCloxF5PXsk3mwudbNK1jZGRUC?=
 =?us-ascii?Q?3iFQzBguTFOzugmvOVziyrFqYRL/q2mdFsaFVsEVlVN9vzzLHjG9XAvJE4mJ?=
 =?us-ascii?Q?6pPvUzGyYGqFsw4pEVVrvh95upupgFeQrRx0X3vo1d6fw7K6GuF5mh8ZVVxb?=
 =?us-ascii?Q?J8uCSDiOgjR1/aLyETMSonLPUMzMyFgoDMO/S8x3fRVZoRbnmVSpq9DBYkyQ?=
 =?us-ascii?Q?1FSI8rqZZrSldxIebA+aOYJ0BDxhYsRuMGgD+J2KpjrBFUlyjis0G8dT3PG9?=
 =?us-ascii?Q?oxgpewOPcvw3M8pnNf+eRbYbMEEvodLaFnziIG4j7jq6+0Axc/xZz37v+PRV?=
 =?us-ascii?Q?JWMlCc4351oo3MVJO3pWrW/Kparcesxi0VsIJiYRWmp2h8yx7n2uj4hze1P5?=
 =?us-ascii?Q?pIUCTO4gE+L2VntPKHJg26YVO8vrkenM3ztJ7vQPsYPCcgnEpYqFwGL1iL6Q?=
 =?us-ascii?Q?glvauUL9adgzl7r1cxf/D0JHPFZNr5AJ3TdleJogbvlRWJywKoXuobd9sC6o?=
 =?us-ascii?Q?R90Xk82Bm4G1RS9XjIoHUBrY5dkJA+YFya3XbdnENByzdHqxY4eo40eP0dtr?=
 =?us-ascii?Q?YG38zEUP2KWDIQhJR85velEHGGJNTSYig6DmIh1yD06NAIke2IdWpxWVZDE0?=
 =?us-ascii?Q?/nyAmtR7/Pp0kydujcToMmWRyjQD3z02g7F5jh/5m6LCcNI5fIc63r+O1COo?=
 =?us-ascii?Q?AtIFQqc2FfBN/lemG+7F6znWYxiOJWOOHBnXgXp3kl0EyKcUCRpAELleF0/o?=
 =?us-ascii?Q?3t6OFVZKTp348mawdk+wC5WYViHSFcRt0ecvoQlmQ1OJDGJyvjhGRE9xV0Cx?=
 =?us-ascii?Q?g/ekqwxsh+UEOSUWYiCF1A59gFLVmPn4MozSwDUOYZK4QADtQbfeU87vLaWp?=
 =?us-ascii?Q?z+BPTaAy4Y5Q2BtMWb6pxHocK0hAGIzIeS6sxGLioywEf3tQMGgF45Lq1xoT?=
 =?us-ascii?Q?l6jHCz5CnP2gL369iaIXEbyDmKecUSaBhoMUupk7GJCUBPNtuEMCptHUqxQK?=
 =?us-ascii?Q?6k12ckZKJEJeOlcb5b5W+LXXY9x/UJRS2j51I0TSi7bOLm1Uv/wTk2d7Oe8B?=
 =?us-ascii?Q?KH5AdipMuMJyCMrhLJNP9ItL6eDZnGxAnGe/60WZmcFQ3cYHPkw9DVjuq2//?=
 =?us-ascii?Q?HQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27EAF49E1AC4A94DA193445CD9FC197D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2758626d-f270-48c3-4a87-08daa3c51b60
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2022 15:53:38.9370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kLeCj8XJnWFDOqF5jls7WFNGnpV6T6vLf6b6GlUfylcGKd+SmaZqYAITd+B1WTqQ0eG0AF7TrDnU+YGci7VM8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6809
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 11:46:42AM -0700, Jakub Kicinski wrote:
> > > When we have separate set of stats for pMAC the normal stats are sum =
of
> > > all traffic, right? So normal - pMAC =3D=3D eMAC, everything that's n=
ot
> > > preemptible is express? =20
> >=20
> > Actually not quite, or at least not for the LS1028A ENETC and Felix swi=
tch.
> > The normal counters report just what the eMAC sees, and the pMAC counte=
rs
> > just what the pMAC sees. After all, only the eMAC was enabled up until =
now.
> > Nobody does the addition currently.
>=20
> I see. And the netdev stats are the total?

dev->stats reports the aggregate of express and preemptable packets seen
by software, yes. I got the hint though, I should also report the
aggregate. The summation seems like a generic problem which ethtool
should be able to do internally, yet a generic implementation is riddled
with problems that must be dealt with (RMON histograms reported by eMAC
and pMAC can be different; some counters could be implemented by the
eMAC but not the pMAC or vice versa, and that needs to be handled, etc).
Additionally, the summation of counters must also be done for ndo_get_stats=
64(),
when those come from hardware as well. So I'd incline to do it in the
driver rn.

> > > Did you consider adding an attribute for switching between MAC and pM=
AC
> > > for stats rather than duplicating things? =20
> >=20
> > No. Could you expand on that idea a little? Add a netlink attribute
> > where, and this helps reduce duplication where, and how?
>=20
> Add a attribute to ETHTOOL_MSG_STATS_GET, let's call it
> ETHTOOL_A_STATS_EXPRESS, a flag.

I'll add this to the UAPI and to internal data structures, ok?

enum ethtool_stats_src {
	ETHTOOL_STATS_SRC_AGGREGATE =3D 0,
	ETHTOOL_STATS_SRC_EMAC,
	ETHTOOL_STATS_SRC_PMAC,
};

> Plumb thru to all the stats callback an extra argument=20
> (a structure for future extensibility) with a bool pMAC;
>=20
> Add a capability field to ethtool_ops to announce that
> driver will pay attention to the bool pMAC / has support.

You mean capability field as in ethtool_ops::supported_coalesce_params,
right? (we discussed about this separately).
This won't fit the enetc driver very well. Some enetc ports on the NXP
LS1028A support the MM layer (port 0, port 2) and some don't (port 1,
port 3). Yet they share the same PF driver. So populating mm_supported =3D
true in the const struct enetc_pf_ethtool_ops isn't going to cover both.
I can, however, key on my ethtool_ops :: get_mm_state() function which
lets the driver report a "bool supported". Is this ok?

> We can then use the existing callbacks.
>=20
> Am I making sense?

Yes, thanks.=
