Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88409572F19
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbiGMHWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbiGMHWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:22:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2114.outbound.protection.outlook.com [40.107.94.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54B5BAAA3;
        Wed, 13 Jul 2022 00:22:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=USc5YnvBxlSWlXlimxDAO98aEfbGic0d8IZawJCmS/Jo+E8AqJoPqA3FqB2XFhLTpCP8/XKFZxoD1XR3OqP8gGSqBkZHxFz5nPhGRtD38f6JqCiuhNONHcsdBkfsOuTeWGjIa8UkbrseUTDUtySFv7DtnbOePmhL2Ko6fAEG7DJ9lIoUV1BXbtnprkq/QD8K526loSYwAAY0TV8/qFSIpErFrXD7S15NngplJ1b8TNyUET0GjudVWFbhjCaKYkkmxkhd8W8NFYYk59blke0AWQKcdNAFfAV6ZMYh3JFpWobpVN8pl5PjhW1wcHQ8v7CT3CvDdYGsxv63HegouYBCqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hCu+xOgtabFEM/r7j8pnZHQ885/nAZ4/ProQRMZJbJA=;
 b=HwxqrgIxAdjlV7dLtSd6mxCraKw6U+ukw+o/J1IUjHFQ91Cnv67FJco5AeFdNKKKKH2uKVqYMnT70Bds4Etg4dAODYlW87p6HnKQKB5Y76WmDtaKHS6/avVgO2ab26leG05tne1l7iW/09b0GT0uBrlcmPSDMkHWaX289CpZyIvy6sRi0g3Ypk57jxrD0ls7NHWW4ovzkkdrNpDl+6aaqxrqsPGK7nJ/GN/rIIYQKwn0q3k+d3Iev9h6gZlV18u+4tU5pdpAZLr2Df8uKVA8WM9nB4l0kVM337GTEsqrUdnevorx2zVVM3P2tjr1I0wy599w6Am/WEu016/g1BAZVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hCu+xOgtabFEM/r7j8pnZHQ885/nAZ4/ProQRMZJbJA=;
 b=OfcT86Cmp6j4lWvIz5ioO7PIWGniPFxe+UjHpimX9dEx4lOOrEIhgHv0CqmDlCY4wjaBsaoZIrQXdBIzICX91p3yuloIBvwkEZLWSwT2ZwN7qsYS2TS56wh1wvhB/Mq3EaVXGcORm3aWA+1XY1MMcWDgFF+Z1T14U5sgW9ek2uw=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by DM4PR21MB3320.namprd21.prod.outlook.com
 (2603:10b6:8:69::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.5; Wed, 13 Jul
 2022 07:22:19 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5458.005; Wed, 13 Jul 2022
 07:22:19 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Ajay Sharma <sharmaajay@microsoft.com>,
        Long Li <longli@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 06/12] net: mana: Define data structures for protection
 domain and memory registration
Thread-Topic: [Patch v4 06/12] net: mana: Define data structures for
 protection domain and memory registration
Thread-Index: AQHYgSXZ61KmVR7xZES2DK7HXoNYta122DDwgAUKhgCAACpp0A==
Date:   Wed, 13 Jul 2022 07:22:19 +0000
Message-ID: <SN6PR2101MB13273A97F6709C7752F37A87BF899@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-7-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB13276E8879F455D06318118EBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
 <BL1PR21MB3283DDCF92E59105F9D40330D6899@BL1PR21MB3283.namprd21.prod.outlook.com>
In-Reply-To: <BL1PR21MB3283DDCF92E59105F9D40330D6899@BL1PR21MB3283.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b2f59ba0-0f91-467d-abb8-8c0490284381;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-09T23:40:16Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9c40e9b-2223-423f-5f99-08da64a06bf5
x-ms-traffictypediagnostic: DM4PR21MB3320:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yAO11wg9EEqCV0UccNksophNKZCmrKV30Eeo9Pw+i8lWqXiNbFPdK2XAdeHAPKxlD7xO9FYj4HJk0yDxQ7dsvmAgOhQ2nRu1EtwemG+NEpAJV1vchiBbHZTcNEFuriuwjm9eym574W63syyjiW2lpzxEPBgpatCWusDfw2AjpajBxGvRBz63MJ/dNT9IuqIknz06b/YcOD7NNDhCNMp6XgBtAqJOTVvGI2vm0L1s+/1sR/VpHTDw1ysN/ZyJihtzdbT05tamepaiW0Rm9KGAJIuq9DTMvk7WwAi6bUTg4zkc/NYct66Ew6ub+6RERNp3BRTUFFXvDD5EZnzs1Nisr86UA3TtxlIRGtmEdXwYimZqV7L4abtIWX9PXlslzBP7VXD81LA49eeEzpWNwBUBwGs1XynplnOwfrmQduqjOr/TB/dnvvdcHElJehOBVglJuqC2QvpQfmfHyl93H5VuAI67SKJCujs5Xu2eAc+8KdWmpsJvUTdO00GAMkhACcMkniKbMyInRoFX0p8r+l0UPTwPiSoilved7exmwKKP+JNysn9Ow6xBLSqxsUoWgrEctvREEC6FEaEoLP4bpiYKOhjYigUhtib5XiBe8SkdFzTmUrskkgzw7mu/HGMMnFJbdGID0bR3m6u2vCf1cmhoROD6rtE+DqVLcZYfUYvMW14Tp7RmoR1o7/dWL+d6qJGQhyqNk+b7XWPYoR3hUDgl7ZW52E2YmGvp5u5F3d9cwsYMsv3PT4xZztZDbcGlCRAjQgCwLVxM8MNoAKdKtrGo54wW+dcaK6ekh7h7CHUwtnc9iz+Nsh4cAwo57jWVQopEZdcpyyVUmUznDdHNwCJnH1/1r7PjapgjnPNVViGepuxQrAzsWPILN6GY8YS7zpQx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(366004)(39860400002)(346002)(396003)(451199009)(921005)(33656002)(82960400001)(82950400001)(10290500003)(5660300002)(7416002)(478600001)(52536014)(9686003)(26005)(8936002)(55016003)(110136005)(122000001)(316002)(54906003)(186003)(8676002)(7696005)(83380400001)(53546011)(6506007)(76116006)(66556008)(66946007)(66446008)(66476007)(64756008)(4326008)(71200400001)(38070700005)(41300700001)(8990500004)(86362001)(2906002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ReLV7wOl3v4jzEfzcOyCess1KpDNf/mZSrDXJvO8Xcck9XLlvpb3B2n3dNoh?=
 =?us-ascii?Q?b14eD4xl2S5DAQGI8j6Q4TeT7vPv0wBB6Bg86yS36IyPdcRQQTvu15KYYLf8?=
 =?us-ascii?Q?3EY1ZKHydDl1Mn4UYQvGuB9V9wNPRe9itpM71frekUABRqiVUL6OJx3/QSw8?=
 =?us-ascii?Q?+53z2jL7r+kqib2S+43RHaOCX0JplMrD7Pgvgj7iSqUnsdIPTM8I+Jx1U/Q3?=
 =?us-ascii?Q?YvBbHyeBBsRjlgewpdFoPB1Sbd7yGD1cBVwe4J40mg5GoUErLMHHTponscKC?=
 =?us-ascii?Q?v705NONfeaK2SwzOJpAaGpe5RAYgin+IjDr6LvmFqKiy7Amg3XjrJHyjbCmF?=
 =?us-ascii?Q?rY8d7+/7vl5QWjpz7IJ0+nySimM7CyoWGFNmRFyAwAlyYdansZxtEzOIWt/x?=
 =?us-ascii?Q?vGdA+EI9yag21K2n0t+6FQl/y2RUuZJON6deXY221lXdjEzg3vo7RmO2awMu?=
 =?us-ascii?Q?kc7Ye+vsn6iWi1WsNHqeGrskYcnEbT+3FL9PfD5VrzDXmYqKYHFJt30EnOOH?=
 =?us-ascii?Q?BMn35ZKOxownNgIB3prIy80m9NfLQtMkqQSjvsoJkdykCU3ypxqMxKL4whv/?=
 =?us-ascii?Q?s4OyakLG+FyFk/LN7npTMzGA//xeZ/q9Ou8N0NE38+1/0DO109R5eaELnzxz?=
 =?us-ascii?Q?YPAPc/+ku6jUm5Rt+Lcu9qz7dpjukwsZWhsA7B5hfB8WEjB/++rjr7lmWuxW?=
 =?us-ascii?Q?aHZ4iw43LjsIV0Xw9nGYbqvq+8jy7riv3c52ZBmUW9E2+RTa+aTSpwN+eIc9?=
 =?us-ascii?Q?QowCF/pewvxoQdvLGeBAhd66nol/qYb0DD5yPRhx8Bc1rqdg5Um1wMapq+03?=
 =?us-ascii?Q?RQvRczRxNKeiLMVmHtg6vyN0/3MTWUoYvMy81osQ9d7cxksNyfx5xNPRZuiU?=
 =?us-ascii?Q?jz6UQlzSWOk7t5RT9zzSOAxHeF1OWNeYk7LQdsqDeNa1a2gI/biXEvKosfMW?=
 =?us-ascii?Q?7FcbLTbdK0dykeoaeYdeUANTuBMzEdWysfyhy75d6YvbQp3pAuV08Cry/TKL?=
 =?us-ascii?Q?+QBr7X1AQ3oEPzRPVXkN5q3Wbwz5ToPrV3lgeOx30aJE69KH4GMp/VnMVDpn?=
 =?us-ascii?Q?2pvbSlgxnmGdP43KN+ZR/C9WNfMToYRsJ8+n9Am4JdNir64lKI7XGJVO2eTi?=
 =?us-ascii?Q?UbpadRedUDmncTRZNIbtklMjzeuVyxXYg3cYRngTpiT2V1y9+EtJoDTCU9bd?=
 =?us-ascii?Q?xkcy1QpmuKcB9J2waDeg2ovxvGa6GEgHrvE85D/kclClpSVKXGsD5+lbKBZY?=
 =?us-ascii?Q?oX/4oN9/+dbZWkGXBGnl88bZXnw1eC1hppPQ+KsIcLdF6SZ7JNSJEMrc+xmq?=
 =?us-ascii?Q?b+JBp7PbVwB5eB+vdEPFi2oIAdwf5qA9SbvsQ5GHWylClFNEJTB4ZlnlSdZK?=
 =?us-ascii?Q?VyR2pEXWV7Oth8UCl2HwdUimFiyjYtviXXqoJl0U55rKENj5FG0cB+MdaFsA?=
 =?us-ascii?Q?kM4Mw736/M5TxBQ6tKHr3QDE0xHGHb7JYXe4eZMykPcglLh5JE9tb5HqJaBs?=
 =?us-ascii?Q?/r/EG3Ij7ZKGSgumgqHae3e5GSAtAL7AK3rztskvH5C/6hDEH9UsH0UmjNd6?=
 =?us-ascii?Q?ysjUe0ZNH8/KoluvX/i8i5CksbXZljjQnaznQWXw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c40e9b-2223-423f-5f99-08da64a06bf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 07:22:19.4821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kCnJzfSayxM+xV/cGCp/QNW8TZJbmeEzYR8tsce0HNLNGOOccJM0eY7AibOcQwFJ1T5dC4RSVK5Vt6qK/hVuRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3320
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Ajay Sharma <sharmaajay@microsoft.com>
> Sent: Tuesday, July 12, 2022 9:39 PM
> To: Dexuan Cui <decui@microsoft.com>; Long Li <longli@microsoft.com>; KY
>  ...
> > The definition of struct gdma_create_mr_params is not naturally aligned=
.
> > This can potenially cause issues.
> This is union and so the biggest element is aligned to word. I feel since=
 this is
> not passed to the hw it should be fine.

Ajay, you're right. I didn't realize struct gdma_create_mr_params is not re=
ally
passed to the PF driver or the device. Please ignore my comments on
struct gdma_create_mr_params. Sorry for the confusion!

> > BTW, Haiyang added "/* HW DATA */ " to other definitions, e.g.
> > gdma_create_queue_resp. Can you please add the same comment for
> > consistency?
It's still recommended that we add the tag "/* HW DATA */ " to new definiti=
ons
that are passed to the PF driver or the device.

> > +struct gdma_create_mr_request {
> > +	struct gdma_req_hdr hdr;
> > +	gdma_obj_handle_t pd_handle;
> > +	enum gdma_mr_type mr_type;
> > +	u32 reserved;
> > +
> > +	union {
> > +		struct {
> > +			enum gdma_mr_access_flags access_flags;
> > +		} gpa;
> > +
> > +		struct {
> > +			gdma_obj_handle_t dma_region_handle;
> > +			u64 virtual_address;
> > +			enum gdma_mr_access_flags access_flags;
>=20
> Similarly, there is a hidden u32 field here. We should explicitly define =
it.

The issue with struct gdma_create_mr_request is valid, since it's
passed to the PF driver. We should explicitly define the hidden field.
