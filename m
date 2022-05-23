Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4E5531AE7
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbiEWUcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 16:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbiEWUcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 16:32:20 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00073.outbound.protection.outlook.com [40.107.0.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4256C544
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 13:32:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jBwZASFXxBNQbG81847nezfo8J1GccohlCV8shdw+epdK62tcZwbSm443h7JBGLhZx8m3VrpqrTfQTzrlSnGA9jmq58vmxnqXbOOheX1h8XHeO8ate1t+0fTc/grak+Ggl163m3joubFC3+LCpJsXCwZZRQg/JRGYuKXOAK7pxqP/rghSpMWtwcoZYnfz/Yy7XR+hYReTc1jZ5sIrlpemlPaCC16xzwiI0DRO+mHuIRL0rET3yB1UUGNBy8x/7VjtuzDq+2wKv44SLHrQi0D3sPC6qncqWfkANjzQWcKAVCaFwIBDCqgOo88VcjbDuyAikIh+84p105Wwm7KQTyE3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNsdLmYZpgqM86cKtjbz9poU0v+eBJLaQbGnevK609s=;
 b=hLpdQpjoNjeyBefDCS6tQYiiP3w7Ti+N/tP/YwNweBiGsqL7xJwKdBnl/htaUUJKtknrU/nxY52mtXUNx6IhmWiTIwnrDs7zxrNWK2QBrcSacDv29Ved6Bs6kN8d1pCUjO5cTMymp316vUtuhEXyQqBFrTxl21C5UCR3me7CU4MCRAVYh1BsSIVwWorX0KujhG4utY9d9bOnzj6elkKVS+7WwWYIyXd4ZVxuAu7PH+FJdyaEbpE4ZqlmR/mAa9xTucFibanooqvwV98YDstrFPQW8ZVbgSUYgwsHU77Uf1+dIOk5QCqZHje1AVN//3U+wMX6TmUWDE1cEL7Bp/GBiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNsdLmYZpgqM86cKtjbz9poU0v+eBJLaQbGnevK609s=;
 b=OEFTr3IVZG3y38EQzdVWtU3QK3kgWpHWS+9hUJM3HhUvuGjDiPebRWoajcp+O2gvfhwon2ES3pXC0xk6ID8fyvvg1YhmXG3fjwCctmGTjas7ddJUFvPh3iYniJVzX/SCsP8c9+b6mDYYY89RRNzgFSIvxqOCgxr0R4YeQK4dRI0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB3PR0402MB3865.eurprd04.prod.outlook.com (2603:10a6:8:12::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Mon, 23 May
 2022 20:32:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 20:32:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Po Liu <po.liu@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net-next v5 00/11] ethtool: Add support for frame
 preemption
Thread-Topic: [PATCH net-next v5 00/11] ethtool: Add support for frame
 preemption
Thread-Index: AQHYa+cqehaWXK64WUeB49V4C8aceq0oW6eAgAEUSACAA3WRAIAACxEA
Date:   Mon, 23 May 2022 20:32:15 +0000
Message-ID: <20220523203214.ooixl3vb5q6cgwfq@skbuf>
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
 <20220520153413.16c6830b@kernel.org> <20220521150304.3lhpraxpssjxfhai@skbuf>
 <20220523125238.6f73b9f5@kernel.org>
In-Reply-To: <20220523125238.6f73b9f5@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15b96777-206b-4408-6cd0-08da3cfb5329
x-ms-traffictypediagnostic: DB3PR0402MB3865:EE_
x-microsoft-antispam-prvs: <DB3PR0402MB38653EBC77EAA59182357C2FE0D49@DB3PR0402MB3865.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h2lmBiw01fCYUeAcgHyXlgHpjA8NRO6QlWCQUrVPZrJfdgB5nIIo+MdSohNmJXrLbnj8pdRAK8vIUK1cDTNUt8nlKUhYbJ2P6xgU1Tbg21iNFhPUHQ+WpsQOEvsZdciXGnteCqA7Nt1WXL/G+cpfkcCJvKtjmQkRjoMsJkvpS++J/b5ZTCnyI479Gk1aaQR6xT6HHb+r66d6KOL26tc9HLqtVLrOju8jcJwhzoevRt9eraV5tmmV1x1PB8AyLqYKKpriv4u8BGBuHfEx/I7n4HaRm81sNw45r50BNaVnoZwmlQcHsfHVYUFFPqqo0zhT2s5gJ/16SUwo5msOXVaVyszl2mvuw/I4zgbiY275JdJJC9/WszpPThqROx0i5uMREeqZz3yDdaGKdpwi7CBWNURqmT6vrlGEpwyksp/8m6JBt2Z67VG1joSQE9/2sA65wf4Rx0X79Kx5NwhEMNySOPz3d8D8RkddSOXhXgHT3X4VfNEv/9PV2emAciqv0jPTiW4yvZU5hiRwzho9RULV8uIqKAYRakzwm65ZIjftfHEj+7N53VC+v9ZK2wpzgdzW/CcM2x41wnJ+shxasG339hDopVfs5XprW0ce519oHYZm3Ox/7JDIGatkeidOZ+7BhI4EVCDZ9XvswyByyVCvmtpsDlQUW/7Yv3K166VBwo0hrdgc5crkNqVNjrXFL6gYWeVQT2VZvjdsM8Z9NZ6qXteDbyfH7z38reTqFEB29dSmLRFvLVkrXvW/hV6NxCAznoZxgoeWUVlt4DdYxleV5fmipFBRkVIEZdUGSWZm0Pk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(44832011)(38100700002)(6512007)(6486002)(71200400001)(6506007)(86362001)(5660300002)(33716001)(64756008)(316002)(2906002)(26005)(966005)(9686003)(38070700005)(83380400001)(122000001)(8676002)(4326008)(6916009)(54906003)(66556008)(66476007)(76116006)(66446008)(186003)(8936002)(508600001)(1076003)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sMhK5nMabViksbDGCEspomWZeLqjL2NehDBonn35wjfCknEPaEyR67UeRUyt?=
 =?us-ascii?Q?nl9W2UXjqeyBJOIttFWghdMG1Y+RNlgJGcUtXb/+j+dXcbl4ZoDG/5uuBAUV?=
 =?us-ascii?Q?uVIaq/YMJwD/iBS+UHSOgSVMgCfKWK+2A3woUqJ2HDJJn/g7ChzaPiINgsK8?=
 =?us-ascii?Q?1bu17MQW91PcP6R16yIIajgYpSddA4A3rCD7jchRIA2es3PNclquhcpT7L/h?=
 =?us-ascii?Q?KWiN2czIohk0bdl3uUduFZlihALrDfiLefx1cPp832lsZ4syaMr8tzOTMnnt?=
 =?us-ascii?Q?CLJkUyWu1o7UvQoJODz7eHZlfnClu8ssyh3Fk/jaeG8U5WKjZGaJCFHjARkE?=
 =?us-ascii?Q?DpaYsVvHAnnVK3bBuw/fkKV69/yrxVnSCoDzna+fOtXoiZGeL1h+IqR1cgFD?=
 =?us-ascii?Q?acR7g2PRgTJgTfT0/8K362buOk43oEDmMpRXGzAugttNfOs+T/hhb9B+uRCl?=
 =?us-ascii?Q?cnwr6HW8fx1WGNKNgLKk4ARWyWb4nG+GFzhs6z8pfZMhwyi3BX7gftcMmIV8?=
 =?us-ascii?Q?XZ7mbg5qRJywqnPmdTwo20QslSv9zQXuBGih47fNhq7isVrA9FtoJGS/TpTg?=
 =?us-ascii?Q?53bfhQBv5GlWlrADc+Y3+p59AxrDNlSHlSuv/DC7c+QcJiydeHuyxF1NNTnp?=
 =?us-ascii?Q?GJBlEIUlYe4u04vCxZYscSS1lGejCwxJaudTG1WRGa/0VD/J+7hIgevblMux?=
 =?us-ascii?Q?Kev9yDaxyTVJmNd0ytRHbPJKw+04+AzOjmHeOg+JeWCk/NNCzX2EHeSQLyCf?=
 =?us-ascii?Q?VrQde4zdaacoTiFTzIT32rYXJ3wzTcL7yN6qNtv8fdLCVIrT1+C9czNGABNu?=
 =?us-ascii?Q?Bh1ckqDESsX1aANMDFa/Mnut8BbEWj3UJe1wrz/0yKvOeEqyR5/M2BjAVZL2?=
 =?us-ascii?Q?ah3niAyc5StodSRs6AEMAPwp6Bv/E7/kK/2n9OTUyirgfTN7sKA+/j3nPIkJ?=
 =?us-ascii?Q?R+OTIWSMhznFEWHyMK688XS4bhpO8jS/+b16tpNFB9E5v6MxLJHlPgohROwu?=
 =?us-ascii?Q?J+50YVIa1M1nXR7tBwRRdgSITsKmdAyIqwEfQtqzSHF+9tFUkIDEvD7h5dm5?=
 =?us-ascii?Q?fej8b5KwrFks2UhpC8EMVFX0TcW3QlRji3ipLhvgJOIITTu1LwYL/PMlwyNO?=
 =?us-ascii?Q?SONS9PQO9/Kfzaxuh7wl3BRiOWBT5L+MKcJ4XnjpmhwWsg+raAuk/g2R/nMz?=
 =?us-ascii?Q?v81vkaYswSVx8Opu8lGUqU8NRZuWiCVQlrxglDgX6Zh5UupICr+d9ZIK70s7?=
 =?us-ascii?Q?ETV/hdy3GE369NKtTIq3tuDS9gUMkrHrA2C4WGfC389VDQy7WjXNVdB+6WDE?=
 =?us-ascii?Q?6mKH/z64acZOaMpd45SxBm6BT5MHBIT7xF6JdfVTc0uD2REgPE/gwsFVqPNi?=
 =?us-ascii?Q?uEIGRtX8sBsGhmrOdN4FPi3DBrfDyXj6SR9yPvNjlVDIAznVrjs998GJozVE?=
 =?us-ascii?Q?E8EMe/rpjef20wPleZipziPFw8JkZZx5xsePWPGpvIQeKiGnc561n81FnfQD?=
 =?us-ascii?Q?KbXjnFQGBCsQDXK4Jp7JBpA3xoib7zLMbgjcZsyp3WPwu9qnGQKKWHQ3NW8y?=
 =?us-ascii?Q?1OGLrtTVzUsYW63meVy4eIYLwQVJnWrqHYf2wDk4FHog4lAJcwhEXXyJLbLT?=
 =?us-ascii?Q?wG/eFz9F5Rom1YO0b0MUyJtcqG2KvKRfHZ1LC0/o0EEjQM5D3bQe150a/aay?=
 =?us-ascii?Q?YPWn5A5w+XyAL4h+a9WWG48cSU0gYs6w+mf3T3jMAWNHcUyY1aMYr79gpULs?=
 =?us-ascii?Q?BTYh9UVXEvEtIiZ7k8ilmjpys25m8QY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9742E0ABA73718428D044C420E7C56D1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15b96777-206b-4408-6cd0-08da3cfb5329
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 20:32:15.5403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RBMNLUxKvzaPvUERDih2PO+xEJhtxAyzHLSEbka9iMgpQPPreHqD17ihgAfbj3YhzUUC/l80TFf3/hkFah0ZyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3865
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 12:52:38PM -0700, Jakub Kicinski wrote:
> > > The DCBNL parallel is flawed IMO because pause generation is Rx, not
> > > Tx. There is no Rx queue in Linux, much less per-prio. =20
> >=20
> > First of all: we both know that PFC is not only about RX, right? :) Her=
e:
> >=20
> > | 8.6.8 Transmission selection
> > | In a port of a Bridge or station that supports PFC, a frame of priori=
ty
> > | n is not available for transmission if that priority is paused (i.e.,=
 if
> > | Priority_Paused[n] is TRUE (see 36.1.3.2) on that port.
> > |=20
> > | NOTE 1 - Two or more priorities can be combined in a single queue. In
> > | this case if one or more of the priorities in the queue are paused, i=
t
> > | is possible for frames in that queue not belonging to the paused
> > | priority to not be scheduled for transmission.
> > |=20
> > | NOTE 2 - Mixing PFC and non-PFC priorities in the same queue results =
in
> > | non-PFC traffic being paused causing congestion spreading, and theref=
ore
> > | is not recommended.
> >=20
> > And that's kind of my whole point: PFC is per _priority_, not per
> > "queue"/"traffic class". And so is frame preemption (right below, same
> > clause). So the parallel isn't flawed at all. The dcbnl-pfc isn't in tc
> > for a reason, and that isn't because we don't have RX netdev queues...
> > And the reason why dcbnl-pfc isn't in tc is the same reason why ethtool
> > frame preemption shouldn't, either.
>=20
> My understanding is that DCBNL is not in ethtool is that it was built
> primarily for converged Ethernet. ethtool being a netdev thing it's
> largely confined to coarse interface configuration in such
> environments, they certainly don't use TC to control RDMA queues.
>=20
> To put it differently DCBNL separates RoCE and storage queues from
> netdev queues (latter being lossy). It's Conway's law at work.
>=20
> Frame preemption falls entirely into netdev land. We can use the right
> interface rather than building a FW shim^W "generic" interface.

Not sure where you're aiming with this, sorry. Why dcbnl is not
integrated in ethtool is a bit beside the point. What was relevant about
PFC as an analogy was it's something that is configured per priority
[ and not per queue ] and does not belong to the qdisc for that reason.

> > | In a port of a Bridge or station that supports frame preemption, a fr=
ame
> > | of priority n is not available for transmission if that priority is
> > | identified in the frame preemption status table (6.7.2) as preemptibl=
e
> > | and either the holdRequest object (12.30.1.5) is set to the value hol=
d,
> > | or the transmission of a prior preemptible frame has yet to complete
> > | because it has been interrupted to allow the transmission of an expre=
ss
> > | frame.
> >=20
> > So since the managed objects for frame preemption are stipulated by IEE=
E
> > per priority:
> >=20
> > | The framePreemptionStatusTable (6.7.2) consists of 8
> > | framePreemptionAdminStatus values (12.30.1.1.1), one per priority.
> >=20
> > I think it is only reasonable for Linux to expose the same thing, and
> > let drivers do the priority to queue or traffic class remapping as they
> > see fit, when tc-mqprio or tc-taprio or other qdiscs that change this
> > mapping are installed (if their preemption hardware implementation is
> > per TC or queue rather than per priority). After all, you can have 2
> > priorities mapped to the same TC, but still have one express and one
> > preemptible. That is to say, you can implement preemption even in singl=
e
> > "queue" devices, and it even makes sense.
>=20
> Honestly I feel like I'm missing a key detail because all you wrote
> sounds like an argument _against_ exposing the queue mask in ethtool.

Yeah, I guess the key detail that you're missing is that there's no such
thing as "preemptible queue mask" in 802.1Q. My feeling is that both
Vinicius and myself were confused in different ways by some spec
definitions and had slightly different things in mind, and we've
essentially ended up debating where a non-standard thing should go.

In my case, I said in my reply to the previous patch set that a priority
is essentially synonymous with a traffic class (which it isn't, as per
the definitions above), so I used the "traffic class" term incorrectly
and didn't capitalize the "priority" word, which I should have.
https://patchwork.kernel.org/project/netdevbpf/patch/20210626003314.3159402=
-3-vinicius.gomes@intel.com/#24812068

In Vinicius' case, part of the confusion might come from the fact that
his hardware really has preemption configurable per queue, and he
mistook it for the standard itself.

> Neither the standard calls for it, nor is it convenient to the user
> who sets the prio->tc and queue allocation in TC.
>=20
> If we wanted to expose prio mask in ethtool, that's a different story.

Re-reading what I've said, I can't say "I was right all along"
(not by a long shot, sorry for my part in the confusion), but I guess
the conclusion is that:

(a) "preemptable queues" needs to become "preemptable priorities" in the
    UAPI. The question becomes how to expose the mask of preemptable
    priorities. A simple u8 bit mask where "BIT(i) =3D=3D 1" means "prio i
    is preemptable", or with a nested netlink attribute scheme similar
    to DCB_PFC_UP_ATTR_0 -> DCB_PFC_UP_ATTR_7?

(b) keeping the "preemptable priorities" away from tc-qdisc is ok

(c) non-standard hardware should deal with prio <-> queue mapping by
    itself if its queues are what are preemptable=
