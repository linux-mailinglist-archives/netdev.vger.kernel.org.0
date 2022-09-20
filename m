Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AADB5BEFFA
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiITWUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiITWUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:20:06 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020015.outbound.protection.outlook.com [52.101.61.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AD34621D;
        Tue, 20 Sep 2022 15:20:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBIAoDfQrjb2AegC8tf7uZjvb3E9mlXQBfU2QMI0wQk0pxvS6+9PKUkt3PMzTg9j1CB826wXAwDWa0VlYu30U5E71yoLMXZB0A/7QAah/kwZCvp2aQeIGCqo9XbSXnze4YTrEZX4vxBWOXDnUckinEIx+eYl4Ub6O3po08g2iJf3Be5TyhIZTIlFdO+LqYa25wACLQ+w06DEjSeTh6Z/zr0Gggiutc5uFRnrR8bLAHxDPt8NZ++2PNuUTOXRTvcmUgeg6aZq0xVeWEb8531THUnsVcktW5Ksp2WdAn2dpt8UiUEYCZ9HtwK7PbS/rq5JcRUcnHXIhyecOn7XYGYjIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y2b+uUqCMv4NRQlUHgR5Hy6zfWOwkV0pTbvYCjLNnJU=;
 b=ogDLKDpiztPbtvm1wNXWBhiHh0C4gPkbfrhzBr4z8KPovDqslmyxxQE6n8crmHHaQgfkQyaMyJBIf3bcur4dmJemWoF4QgJZWvQFGhdv3QamNal7xEijc3ZV/lHPt2w70r7IsjFGJlHFy3oiB5WNqgatnk7fK//PqmOeJo9Ash3HilliNBirPsRjfcF7xW8ZxLdiP+BcXKuOk1yEbZGOith4Xf+qtyb4MQNm3WxHSe3i6aWI8xAbc2twxvNuG5/sXgqeI43C6P2sDLSp9u10EXwWQZt66r8J2W1Uv1u+9FeT9K2mOno1OQfJS6UCsHO5+ddJmgTphAIfAtFO9jEwVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2b+uUqCMv4NRQlUHgR5Hy6zfWOwkV0pTbvYCjLNnJU=;
 b=fectMgk3DjPqHgUPoOP1F+5lQgl0bc2k1O7mUJ1vkeqN9+FPA393YMOLPmkx08v0fMmGQE1ZrBbZPn9Z9YzS5GCD0+IkvHjQJ4seFZr7fioZ3BZhqXuvdlrMUU/gJG1vOyGvKgVrV4uNi4sQfhlynBCNl5Ln2ltrnWbgUcQYgYI=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by CY5PR21MB3663.namprd21.prod.outlook.com (2603:10b6:930:e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.4; Tue, 20 Sep
 2022 22:20:03 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::ce6d:5482:f64f:2ce6]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::ce6d:5482:f64f:2ce6%7]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 22:20:03 +0000
From:   Long Li <longli@microsoft.com>
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v5 00/12] Introduce Microsoft Azure Network Adapter (MANA)
 RDMA driver
Thread-Topic: [Patch v5 00/12] Introduce Microsoft Azure Network Adapter
 (MANA) RDMA driver
Thread-Index: AQHYvNF32YfFj4mQP0Kq8nuSG5RJoK3Xr6rAgAAk74CAENUngIAAWGmA
Date:   Tue, 20 Sep 2022 22:20:03 +0000
Message-ID: <PH7PR21MB32630AED3068C2D463A4DE85CE4C9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <PH7PR21MB3263E057A08312F679F8576ACE439@PH7PR21MB3263.namprd21.prod.outlook.com>
 <YxvRkW+u1jgOLD5X@ziepe.ca> <YynwWTNv04r0xAvL@unreal>
In-Reply-To: <YynwWTNv04r0xAvL@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=44f090ff-e4be-42fc-ade7-b5d6315091f4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T22:11:14Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|CY5PR21MB3663:EE_
x-ms-office365-filtering-correlation-id: 2601374b-390c-4cf5-ebc8-08da9b5643ad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gznDK4aU16BENGTrp71jPjMNUwn3+d+4S23jqp4oMHJZ4+SicNkDcekkBtK612jPq14qml1xV0PBbpLOb/3FtI0HTGmE5rexSUqQk5InzYQdLD3eFxV0GpcUMwJ3zmw1DiAYwqgU2DzNJN8tyujUirgU4fgJcGjChUJVuq2M3zyLaUYsAWMTYXNHrseL8BrhWk0q3tNB0HJxYc4mBzFSib5cWOR+r6GD+chSJ3tfnQHgpj4+uiF7ZpK36tCMLMhXRigQThbyWSTqiRMNCjzr1OBCF/JFc7+n2FfvXFCxFPKXU39XYC5hkP36PiOngeiDmzwq3Yw1sjE8gIaoQAIrwEmIJYxpo/x80jaPXSbc+lq99PdZlziqoc8kwHXW37p/Qf+o79gbwEY4wAtkaZ1xY7lqAmDyoR6AtRz7+BMHj8sajsS3UPmpB7/GpF1CCkL00iqckdQDsBwY+DO548LbB4k11Tskor2l4SatQwlHgiHmRZl2Fol5bsDpLUGs9M2IMdwUjv0oo2htQ2xehiHlMxtl1vMZ2qQUCISXDGaW5kzA6f2XWHU8ZUK4Xxz11cZjczBQ/4/3PHsMVDhTsF7qtC5Qkq1KeyPE5mMalqc0I1Q9jq+dHw5DvWrFB7x4hooQF5TTodDxOxCaSbppPWz+s+ILx1v56KN24xGVuqookEjEvvmL1i/ZecMX2Qaq5w46KjXZf7E3hHMd4DgQ8qKBXrLW+7XZgCpac2I5DAjRfuERuZzu3qDLgEYNEEYPUTAuGlkemP7s9M9iZ9lQe6u3KD3TJQR1p+D+7tflxGtunD+tMLS2clhaJomh/Pq6XlK3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(47530400004)(451199015)(9686003)(82950400001)(38100700002)(26005)(82960400001)(86362001)(122000001)(55016003)(6506007)(8676002)(33656002)(8990500004)(76116006)(64756008)(10290500003)(4326008)(2906002)(54906003)(41300700001)(7696005)(5660300002)(186003)(7416002)(71200400001)(66556008)(478600001)(66946007)(8936002)(110136005)(66476007)(66446008)(38070700005)(52536014)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ewoUk5ukhUSdpErun/+IueaUjmIPXNrIWZj7VH8TkZIOCwIJps6sSjeWLyX4?=
 =?us-ascii?Q?GMlR4ytBzdz8QezgdrYTVT7hjk8Ubr2HpsKh7hTqY1Un+vhjXuXT0QYWZs40?=
 =?us-ascii?Q?/wsuRHwHKTJ09B/ezLdiCK5CDCa6CAZ6s5QcSd5r6qKi2fEM4YFQPHd0MgQh?=
 =?us-ascii?Q?/ienI+eIkYFha0ENy2yeJ8Ng2Sm7VoEOFQ0UIbDMfQ+uYE8h+t7gbnDUN2yL?=
 =?us-ascii?Q?U6F2KV+d6XSiBsQTbAAzkEdf+kb4u213vuwZEis+hlHAKzafRGw8TvH9gcWM?=
 =?us-ascii?Q?zKgKpQWAThzpAPNNFSNLh8r8wm5Jf/L+VgV2r4NNrhIuCj1kD9o+vvuVM/ff?=
 =?us-ascii?Q?GTk/cnHHpa6Nl1MDP4+WS+BvXAlGX6ae3Rs02Rpm6okcYSPZNpRmXsJJeBxb?=
 =?us-ascii?Q?Q98KWk2Cmb455kecoS3L//V+rsHC2ceSp4Y50QjbW4E9NO4WZtaMboPQsOgT?=
 =?us-ascii?Q?8bAn4AKhYfLM7bIWnBPekX1FSWRW2uFWOX4ZVmL62FK5A6P6KQHOxRLJ2+1u?=
 =?us-ascii?Q?84yTzMisMxYrmUBnq6LUAIQEgcoEd9GDyu3WW75FaNBp0NgXqpvJpxscRcqo?=
 =?us-ascii?Q?Yd+pAvqU9GGx29avfd6oQjBa/GkzqSKC43uBCNAvzhsaLmZWHNhVLG9y0puS?=
 =?us-ascii?Q?Txtc6255UNDTAbBESJuX4bSw/zJ6WbLxc7BdRUsqoH3IfWGpMcHcnX5OKYUO?=
 =?us-ascii?Q?OqKPpOaiBMCzCOcTRFBybs4ElMBleGfvn55CG0BQ3SWBw/8mDFo/rLJNMWPA?=
 =?us-ascii?Q?Vb1uSM59JbEOqH3AOQSAIJfzdcOaQSUyrxrIICYsFLIayEqEbA5RI8FyT5xX?=
 =?us-ascii?Q?qR3usnHMnCaaoGC4U1/0jb8Sc043dK8HMp02+efsc1uMN25o9VO8OG3+MCKy?=
 =?us-ascii?Q?RdtyJ029remfWReBOXlFs2YKzqyrF1KoJJntzvFiVR5Pcj/Yv2mYiayMpcZe?=
 =?us-ascii?Q?JwauGCE5BErfRptKPcsWkGoaAPDhbMU9dAf/a5mqTHitEGb3gJVyqibIpNUf?=
 =?us-ascii?Q?hGhaFakDmKjOZmUk9erfj+qkhpBGxT+qFuzPcV+EEtifdWiFwZwdwWaMTfT0?=
 =?us-ascii?Q?bkV7/Xq02QtoW35RTAY8hFmkPKQHgmDXLBHFCB+5OXSwnxdtv3g5SEo9Ss5D?=
 =?us-ascii?Q?EzYmnv/ovZtqlcNkEFOeDHteekK9U08oP7ebM1TXgGeewr46zJhTuL2rCSeY?=
 =?us-ascii?Q?89lDtiqs4MMQjyrNqH2MQgFkJ3ppnQhM5JjT1Zk+5knId/NphCryWgNBKl1s?=
 =?us-ascii?Q?76HyTpUwJceMOZ7jIe8zZuCkcZLXt2Rz3N6fdjKaf5olL3w0zGzNp/S/IAsh?=
 =?us-ascii?Q?VUjOnpJrvs9gHzu2Ronurg3TGzkByLQZtEPgq4VFPGaBf6gq8oJm29Jgle4Y?=
 =?us-ascii?Q?RBdkvmlPfkrMrbD14sLNI/LqItZfeYVKFsNaQqOuuBQKUynBESAHI3II56nB?=
 =?us-ascii?Q?Q/7V10eBAib5p9Y85zNy96xD10iB7ZCh9W4c7+0m8XleUI2nK1qT+kCXdmE+?=
 =?us-ascii?Q?bm9dQXOv0KLsuNq0Ytzqzolec+WnapWiRHF25mgwXrcUVsH/A9ZWkj2TBUu/?=
 =?us-ascii?Q?cPxMtwVSqEvwJWBNhtDYWu72YuAWaS0dJmSv80ii?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2601374b-390c-4cf5-ebc8-08da9b5643ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 22:20:03.0685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xu9tPiC0+JQjXn1XPTjtJbsnphry80dn4EVlm52o5HzNwiAMXNhgrZEtcwHjSOcE0AE49kkHWSC7WCYfCRKGhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR21MB3663
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [Patch v5 00/12] Introduce Microsoft Azure Network Adapter
> (MANA) RDMA driver
>=20
> On Fri, Sep 09, 2022 at 08:51:45PM -0300, Jason Gunthorpe wrote:
> > On Fri, Sep 09, 2022 at 09:41:25PM +0000, Long Li wrote:
> >
> > > Can you take a look at this patch set. I have addressed all the
> > > comments from previous review.
> >
> > The last time I looked I thought it was looking OK, I was thinking of
> > putting it in linux-next for a while to get the static checkers happy.
> > But the netdev patches gave me pause on that plan.
> >
> > However, Leon and I will be at LPC all next week so I don't know if it
> > will happen.
> >
> > I would also like to see that the netdev patches are acked, and ask
> > how you expect this cross-tree series to be merged?
>=20
> ??????

I apologize for the late response.

The MANA ethernet maintainers have reviewed and acknowledged all the patche=
s to the ethernet driver.

Can we merge the patch series through linux-rdma tree? I will rebase and se=
nd the v6 of the patch series for rdma-next.

Thanks,
Long
