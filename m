Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D89502DEE
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355935AbiDOQr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355979AbiDOQrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:47:23 -0400
X-Greylist: delayed 47487 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Apr 2022 09:44:53 PDT
Received: from na01-obe.outbound.protection.outlook.com (unknown [52.101.57.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DE124951;
        Fri, 15 Apr 2022 09:44:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuWep0dyRr/OL12M3YoIETAmuJbiezVEFI53sGYEg6oTTMqgUiKla1BiDCADDgiCVUK9BZOJyvY9P/O9PUDCZva7JZvFRa5Bq5UvBmHBVLNHZjAJZm82Rkr5mkK9cwQ2HKfeaUyzTqbNBCBJ/ICoeXquwZXMtVvmR8U1w722JPC+FOQkS5JV+ZH56w1YUxvMmyM5416Acb7bS/gMn7OJpV3CuTERp2vXw/iUR3OQzX4csHXoFFBdAn6Bvb+/bXGTLQeByCx5QBveg6NBgxG37DSGKOKlOiJjIr+gB+LYe/XthXi7yw/oL1ZM0LhdCtkMFCV7SStq4AjCsU1LATJ4Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HYNpJjm/jne0HL73swP6S6943rvp+b2Qz37p9hfTQzM=;
 b=FNs56WAZY4TrifjKS4igHqN7WVhWx5P9jKQFKTCgZh002n45u8BBvN0+6gfhSKg+3xFMz+YZr6BEW848gx29IMfGWSuxXIrUW3G7bv0MGkqXdyd/PLFToYrtHUpSSkQgyS+K0in7/gZCtRgK4oBqaWvKHnazedG0XKYEVsVYJasrMyVLUdNKf0xLJnw9RW/cNY2+HB2KNcWd5g2NNydyJV/YN5oglm1D5l5erCK3P7Hd6hUNpjRQXKOYLpLYmuwHkr6TYSipCk88qCUvl9UldZtVGs/NMcsYtdO3rOAHeXaCXCBEuH3hY/sjtzfRK8+XTe/OHwP4klq0pL4FQ8169g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYNpJjm/jne0HL73swP6S6943rvp+b2Qz37p9hfTQzM=;
 b=EDuhr5xwXnuvJLJZHxMp2tl4dhQ3w6SjymMSmTxeFAQdzTlqA9wgv4prWkmkKGzgf7O4tnOtV9iV0TTN6HVJ8k8RROiddJBHmHFQbs32SiLoGy+MlE3D8QSGhbIC1m8tL7hHbr8qNzGm96FyVkS3t3ZISYrOlTVNF95XpXjiNOU=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by SA1PR21MB2068.namprd21.prod.outlook.com (2603:10b6:806:1c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6; Fri, 15 Apr
 2022 16:44:50 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ac09:6e1b:de72:2b2f]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ac09:6e1b:de72:2b2f%9]) with mapi id 15.20.5186.010; Fri, 15 Apr 2022
 16:44:50 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Andrea Parri <parri.andrea@gmail.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 6/6] Drivers: hv: vmbus: Refactor the ring-buffer
 iterator functions
Thread-Topic: [RFC PATCH 6/6] Drivers: hv: vmbus: Refactor the ring-buffer
 iterator functions
Thread-Index: AQHYT3fNSP/rWeVvYk6P66NWBULOUKzwUztwgAA60oCAAJ6bgIAAAP3Q
Date:   Fri, 15 Apr 2022 16:44:50 +0000
Message-ID: <PH0PR21MB3025ECBC7D7102B539A7705AD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-7-parri.andrea@gmail.com>
 <PH0PR21MB302516C5334076716966B7EED7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
 <20220415070031.GE2961@anparri> <20220415162811.GA47513@anparri>
In-Reply-To: <20220415162811.GA47513@anparri>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=fa73a567-3147-45ed-8a40-c3aa28b6497a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-15T16:31:43Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67ea02be-8e0d-483d-e29c-08da1eff423b
x-ms-traffictypediagnostic: SA1PR21MB2068:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <SA1PR21MB20687CABD919E3C755F68AC5D7EE9@SA1PR21MB2068.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AElJhhJ30Ht8p+YlDmCXb2wQcus3Zc5OcwCe23ismhzJT8HAfEAw5k+0IkQbn68pirG8zP8yC7FR3Y+2d1mXIU5pPKaDkLAxt4c8VtxmFGL3e1MxQoUpBjbAqMri4fXYo2h8+g0rpFBC2GLZMBJAXPYGjaBFf0Kordj6o58jaMoqeRt/qxdT+AaiO02xxQ3brOLYYCEIPnMPKbhAWEvrCDUrcP+ph6hQ6jz3lozj7p0x0wO5xNst+nHyQTEN486/ne4BqolT2FxnsEjJaY0yvhWjRzKmXP1SD5Fxoi/QeSZNOr+omoDBDvYQ3OPzgDPgKtXgBUitCPVRy2bO+2uLP6MUPywktx95aVvMPb+06YZBkmX4W9Lu30Nyi3J+0UYJ9DqOkQeDrOa3mbF2MaXtXeSj83VlSsGIrcVFLSs2p8Qb+SiJceXV4NkrCKXIu2lCFxAuJoDKKPhxTWZK98z2D65w/svBIVgaS4pKLnAbHXVjail5ikh7JzKgoXKnap5qyINFtOxi4nPu5eOM0k61Zqj7ix+H5iZbM7+bHT8mTDKWyj08YRC4Xs0rgsIBoiORPfTIC/svd32l+0wptLdF9GWvqL1/194WeCHFsNQAL8Kz+wjk5flh5KH4jK4GV5lpFIqbVYf2Zfp5XHpaLhkq2hgzDUElqzxa25Dco1ri9tUBF74Jn6xoj9kdOd3Xbaiix8lL3MKyizSvn8MA2kIqOlp/u8mp7cNLrclUkEZrI5l/VkGXATCbPy+VJx57eDHY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(66556008)(71200400001)(82950400001)(508600001)(9686003)(2906002)(316002)(76116006)(122000001)(6916009)(54906003)(82960400001)(38070700005)(66946007)(4326008)(8676002)(66446008)(64756008)(66476007)(52536014)(7696005)(6506007)(8936002)(7416002)(33656002)(5660300002)(86362001)(8990500004)(10290500003)(38100700002)(55016003)(186003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uFQSh/UuTtjU2J1xpTzb9ozPmLRcji/4wxIPl8+CzgI+PDWKbFVZQu53neVV?=
 =?us-ascii?Q?ParzMjjLBSjApEhAJnrqWyvDGg9QPUcXwXaJj80AgYzmIV2gowvDIWE6LlZQ?=
 =?us-ascii?Q?v1qJr/UomMtufjj+mHUqS10PLEdqNx4zhzFw5aDw4Go163oWYXbQGDnVikRe?=
 =?us-ascii?Q?+ClFoXsv/rB7FGRdeqTGqdB82OoE0N9aQ3A8l0/7PQ/BbBTr5zRBpGCvh88M?=
 =?us-ascii?Q?okzt6XsWXYx03nKk5LzfwwLkN6nZWmhSkFjDyW317Y4OnRlpkhdbeNX2XN5k?=
 =?us-ascii?Q?VhSGcSJeZnSuqi9luOSGP3zXp789CplrpCfH3sMtJ3SdshYPE3d9PcQLm1WF?=
 =?us-ascii?Q?Cv/b/wCxCvOiqmQPnL2trAtfd93bHMQW2QWYnvzdapVgpdk/uh/Yd3tA2nnf?=
 =?us-ascii?Q?+EoJkKqeTQ4LMo8TlzumMy5azNrGHsPD1s/6c4kTV2MYB+6dKl4avdpOvxFk?=
 =?us-ascii?Q?ILhx4jleboDHNCS3pAmZqNlBtwcq44RCLpUWB4ci/Gpr+Jnn97HB3Snw2qcI?=
 =?us-ascii?Q?GNbdn7BNIJJ+KtGm4U5AyWyxsFvL/2kOGsNl0cX360p5L3QGc8norjae2wrz?=
 =?us-ascii?Q?ke+HtTEX2ia4ephn1/cdfcHSoPvFbeuMgwP7Ya4l7ZjpEUrKVrjVMwwV7K9D?=
 =?us-ascii?Q?t/TFeskZ4YYc30eu5d6xFF0hbbTR+7tYr0vKbwnPQzDk3j5CW9XhvqX4bL5F?=
 =?us-ascii?Q?pYxvNiccMhkToESwPfi9GhwPCj2yy1CdzkVoQ3xpAm4BA4liwVUfMyVRiA/O?=
 =?us-ascii?Q?0dpSwwaaNfAosVjUSc6S7QDSaUGg8JEBW5sloEm2cbTLi0u9YrSppFKEiB7R?=
 =?us-ascii?Q?Y7SSoJtbZJX97SLGv3jocd4s7/XOBy8WXIi3j0uzxXZDGkhcNEcU6xbpk9ui?=
 =?us-ascii?Q?wuS8Z5GW6uPmh/IbUGZ7VR+zjS6Sc8ngdXn2Hwd16XX9FKLauIy3g55wKT+Z?=
 =?us-ascii?Q?3RhYjvsE2MsVGT4x32OwwRJVVY92AnOQPtW9zOqO0+xgKRVU7kEznGWORGhS?=
 =?us-ascii?Q?+KCATA/0wvT9gXLRd5sB5ZQDfEbLWV9Ev77FQmxjxwOaHwOucSQfYziib3ag?=
 =?us-ascii?Q?r8brzJoh6vzenPEhgpD2NtqEgIrMQeRrfc5z0qzKuqBlwhtBwz8WOXhetong?=
 =?us-ascii?Q?uQLfL+CmkNIZ8iVLvReMFW/SMH2hm3zhU+LMBac4Sme5jEZSqnmXMOQWf6v5?=
 =?us-ascii?Q?qPGycKx3zMbByHDyK/VDTkg4MpscaICKDiXw3Dh+ZvlxYVikKXVvFjFjcFu7?=
 =?us-ascii?Q?QFxgSEGborb/rCI1v/bcXjPvip4RA/SBgJ84/0bCemE9lkkPeg/gDKQBBPop?=
 =?us-ascii?Q?xJ/aaghPSJYCoK4Foxy1MfPKyhnUzV+j/rCY55rIh/hiChuFclUuZLdIwtKV?=
 =?us-ascii?Q?KDm0Gxue67WZDo61xbdMR6z+GVncuf6KKK7ESfe0WEWKOwzLEjscyVq3B2Cd?=
 =?us-ascii?Q?+HwgmnOebsRBULBH8Dm/7uZHgkARTbjhUTrTCOReyXQiRWxoHsZsXnu2kju5?=
 =?us-ascii?Q?57Pj903XjnO4pc8lNHv9dYSNZ/7D/81+V4WJa2OlEyC90SLJ0EgcEME2ISZT?=
 =?us-ascii?Q?8fwsEnGgDIs50jllIio63qhTjxTWwap/RLT5WPfdZAoFYw9K/MAde3SVurvX?=
 =?us-ascii?Q?AMKZt/8DXOkIAfkAm0NYH6fQzbSu2XYSOxfDOfBUJT9LPw+ARezshHnHpY3y?=
 =?us-ascii?Q?MH8pbnv2tZV5LT1oXyeg5fpJlgKFeSnnQzZ+uQOv1HA8FQbM6y/b2S96qJF0?=
 =?us-ascii?Q?QauKIH6ZlrYFGDypGHOUH2ikYnTXxMc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67ea02be-8e0d-483d-e29c-08da1eff423b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 16:44:50.2711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lvr/w26F2JAZijcwZwDTuIqfcpfZNejgtWT4Bq5lnhsJcJ0yUHbcIM1SRQWPuiCZph7XGjs/mv1FQmT/M5GZJDGjptUkfh9jIYpf0+AkTYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB2068
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri <parri.andrea@gmail.com> Sent: Friday, April 15, 2022 9:=
28 AM
>=20
> On Fri, Apr 15, 2022 at 09:00:31AM +0200, Andrea Parri wrote:
> > > > @@ -470,7 +471,6 @@ struct vmpacket_descriptor *hv_pkt_iter_first_r=
aw(struct
> > > > vmbus_channel *channel)
> > > >
> > > >  	return (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + r=
bi-
> > > > >priv_read_index);
> > > >  }
> > > > -EXPORT_SYMBOL_GPL(hv_pkt_iter_first_raw);
> > >
> > > Does hv_pkt_iter_first_raw() need to be retained at all as a
> > > separate function?  I think after these changes, the only caller
> > > is hv_pkt_iter_first(), in which case the code could just go
> > > inline in hv_pkt_iter_first().  Doing that combining would
> > > also allow the elimination of the duplicate call to
> > > hv_pkt_iter_avail().
>=20
> Back to this, can you clarify what you mean by "the elimination of..."?
> After moving the function "inline", hv_pkt_iter_avail() would be called
> in to check for a non-NULL descriptor (in the inline function) and later
> in the computation of bytes_avail.

I was thinking something like this:

bytes_avail =3D hv_pkt_iter_avail(rbi);
if (bytes_avail < sizeof(struct vmpacket_descriptor))
	return NULL;
bytes_avail =3D min(rbi->pkt_buffer_size, bytes_avail);

desc =3D (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + rbi->priv=
_read_index);

And for that matter, hv_pkt_iter_avail() is now only called in one place.
It's a judgment call whether to keep it as a separate helper function vs.
inlining it in hv_pkt_iter_first() as well.  I'm OK either way.


Michael


