Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A025BEFAA
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiITWFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiITWFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:05:16 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020021.outbound.protection.outlook.com [52.101.61.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A7B564F2;
        Tue, 20 Sep 2022 15:05:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFdbLYtqdQnm659EXTaT9ReCnmFWp/ztHP+f+9lhFUONfFsxU1303WtacQBUGdx6Wu1ITgD8hJc6KdTHZQaMl3+/oGeOKKHy8nR0jb1pXQW/1wQ7FM4kcVQijsa1dl/H2aSVaiJmPVxT7OW0hW1Omgpvfz6ptmHH0ySuw6wP0Y7Ssr5q4cYGXZbg/In3QjnN0fKg4upYqthkGMQ2cqYRFfgvb8VSYNspQWfSFpV4yLzP0S03O60elBMn13L9oYn/zEJnXX1kJXpCR/9Dr6AWZp5PnIkoORrZWZhYPQJH4EWJAXQGDYxacYXCBPNFhEfnLsDrMpebtx0x8ms447wJvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9qjnWpANNNjoBy8/YAwbX4ELFl5xEBKIS4480P9Nrg=;
 b=nBpB76Iwq2bhEbVZX/bzUhb6lwtky+YWO+9E96t6ouDf4IKwZUK4/bF5ZJ+86qOJVnrCZWK+/4Wd9MWQJaHiShWSZbGsfFWJRlT8xGI+Bu4B0iKoN6dSOagRuyVSC6XgC3dsYdF/Aq6nMf+/80EzsSiLsPq+8+eZ+KkCCqxTDrytowJ6Zdqxb1FWNw2WpKVOcw7lgOMJVdkiB1TKzh6xelevlIY8417tvwADsUJoqheA1QUrHUpuonsVuygcCI+jEuMaLu/k6SyFiZnUs7Icg86m0bJsYgCxRk7po+BFCimxrnYWeFIYRoMIK2EI9X8tmk2wrEoi/FrQKJdtZ4HTuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9qjnWpANNNjoBy8/YAwbX4ELFl5xEBKIS4480P9Nrg=;
 b=jHp68BjwJZA4VIWBJ25+AcR4VZdfx0SIo5tQNW47k9baedllebsM62RYfo2SbsTLK811CgH+64aG1XHu7RClz/EuZRhnmub8QHW35ECj7JEAB/gPxlGN5O8WnBGRUP5MHHZnUsgG7ogrmMgq4aL/YcrnIX8J/RWmKB3HDk1Yklw=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by BL1PR21MB3043.namprd21.prod.outlook.com (2603:10b6:208:387::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.5; Tue, 20 Sep
 2022 22:05:11 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b%9]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 22:05:11 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v5 03/12] net: mana: Handle vport sharing between devices
Thread-Topic: [Patch v5 03/12] net: mana: Handle vport sharing between devices
Thread-Index: AQHYvNF5tayLixG0gES5wB0RFS1SSq3pAGCA
Date:   Tue, 20 Sep 2022 22:05:11 +0000
Message-ID: <PH7PR21MB311617EC32C69D7166F768EDCA4C9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-4-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1661906071-29508-4-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f8a3775c-0411-4103-8da4-ae83a65180e2;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T22:04:51Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|BL1PR21MB3043:EE_
x-ms-office365-filtering-correlation-id: b30a1c63-6ac7-4549-6ef2-08da9b543064
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wm8CHdhAIxyufh3sfb2zpC/Vq94HDeDRuSx63zWaITOuLLrSXNcCDOg7L08OXyLuRxud/MfUqR1Q18DdB51V6Y7Zlhxx7N2H3OUpp2EpdLk8LDZ7VpvIZH5WpfXftGkb9Pv64ItZh75PWOQ5KobnAx0SZC8Y2CscuwHhgAIya2xAvWJzdv9xqVvRRui5uwOYia4Iv0b9Gh8ui4Yy28w/YC0Ve0Y6r1O2EiLXm0TGSQ2Fw2N5Oovuzp9CfHvaqC3kD9408tmnEktXTzpyqB1InzoT/CMHL4v2PLR/TgCDcokzDkPyOQLGXwD5qZgwOxxDQVctBRKtOGghOZKfXm5kIj2vAUcP90TW9bpNu/TBCjrNTOPa+Rl+V/9N95GRy1XdER6VIUGEl3uF9tc2iDZllUbvt5jWvuBdCvFK3GBSIjyyJdQ1nOi8heLQwczS/95ITfOlMFOPK53ATY22O08zKnE7RJypeBz3eP8FNdSgciwlApr8Azz5/jGv2bXK0Pz5EkhW+x7sFWa0mJkJuxIp+DKJpfMhpUDuG0ivHb4jnSRbsGOzzt1EVX95pw51EM8T7hNmG2V87YXAMwNCBoQCEdHQ1Vql5vcoeum6rVkcmRQ9N7WAVimTqun5oKr5DCGyqxefJRPlhUb+BPbDym9Im9aDAg8OgE1tGqXivKOUUFxmxLTBU22s807E3bo7rrn/3pohq+zvQ+oepjEafUNmttd037PIX5n6DjqEGTN7hXCLeyGjZnefaQtdWPrniLMPc92xLy9jHbISaJ2gCH+cH1k9CMupC0xgo4yNN1/PUQrzi2tKB3ZWEFoHfDuCC5UTFtC43D4Qbq+dWzOcGXWrhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(53546011)(26005)(9686003)(55016003)(71200400001)(41300700001)(6506007)(10290500003)(7696005)(110136005)(5660300002)(8936002)(186003)(54906003)(6636002)(8676002)(4326008)(7416002)(76116006)(33656002)(86362001)(66946007)(2906002)(38070700005)(66556008)(66476007)(66446008)(64756008)(52536014)(316002)(8990500004)(83380400001)(4744005)(478600001)(122000001)(38100700002)(82950400001)(82960400001)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wjog2Hcb9sHOCbS0aC7rpXXPtRxFUhX45RjzOa2oJ2aH2roHBgPwBbDg/vlA?=
 =?us-ascii?Q?JqdZ6JHc54bKcFVE1MqBvrj7UHP7FSHFQX2XCvyBVF//yugf+0h9f5QAuoTr?=
 =?us-ascii?Q?AZKzoYuTXaktYHKE36viXXEOPMmAA+stp3D8sPTeq+1mYrV3KMl6qOubzEEN?=
 =?us-ascii?Q?IwXYHYvK8ylfw9uhA1xY6a9Nq9ryCzLaZsRO5+LADpU6HTp4RjN3nk0azTDB?=
 =?us-ascii?Q?F+2DwdOP4SAiTuNk44O6uqn9HzEiYyGdRhtZLM8SkX12epUC7Xf/JaHWYWqh?=
 =?us-ascii?Q?sDhdTb/NnOr6gFkTZn4LeHeXpy+RMnq2Z+w9JnRsxRiX7i9Q+uLz8XWv6cwq?=
 =?us-ascii?Q?kmJpFaor0/qv5uWzs9N0/a+t9V40s4KkI8L/zkgqDNehGPpg1IDUCD8zZ/em?=
 =?us-ascii?Q?QJrw3EmwVE4UJ3zYYLFgKkmNvK15IHrsG/cMDdUW5HZvJVwMEta+cpJJa8zi?=
 =?us-ascii?Q?v2R5vw74TWvULM1748m2abzDOWwcDY73YT4ypI9CE3cwCUL6+RHC5Ewmyj4U?=
 =?us-ascii?Q?DnNcKjq1qweBJvoyipQyF6CN6SV2gUdoCO2HjovEiTxHt6hNrbPt3VRjBsfN?=
 =?us-ascii?Q?4b1c0dJQEpyzDHaDeKed82yu/rPYIiMJS/twmnnP1uUTY0eRGKDziBSp9Pwb?=
 =?us-ascii?Q?pgN4skMpK8K+AALJ3v6dwFw8Nk8F4SGrjUzY/D/w7DKdppKGw/e2MZhVyDVa?=
 =?us-ascii?Q?4SxjO/l7sBLGXO7Jx+hONGA8YpT7orRnUZcxZysUN7QBeiSTdzFJxSDTwgoR?=
 =?us-ascii?Q?AQMeUtqaQdK2Y2LG+d00ER5qE/RRlhqnxwTxNeoK/bXz8Qkj6S+aNyiMKu4x?=
 =?us-ascii?Q?LO/dMb9a4AFcliDW4yM3IT+g1X3OjE5hUHdKBiZRmQAAXnqAWo6Kcn6Q3Mxu?=
 =?us-ascii?Q?QzvFrhxjSQsDt+tAyka4iOOIynFpymHXQh6gnIzbvsmBE3IOZXIRFmPtPIOG?=
 =?us-ascii?Q?ejP+YXU/lMVQaC/vi2+d/Ng6y5/1Zkvfr/rFoB5YsJ9GltuVZq+KhgUaZzQl?=
 =?us-ascii?Q?+PfkWjw1Ja2cxEU07UTj84cpGNEEa+680Q1VImBvAhVNJwjLxTsBv6L70ppE?=
 =?us-ascii?Q?5Wl1m8Jy4fT4oYleX2uOCuWL+5vd+UZpWUXWA0NO9zf0Wmet7nviux/2YZAd?=
 =?us-ascii?Q?1xeftI9INixmbIm5xQtHTqf5D0mPL14n5grDdmg8AzRn5ZgVh4zCtJSkJYP6?=
 =?us-ascii?Q?1b686Fws7TXUzn0HNA6u2LxYDzrOKc9ERH3RQtx26wvAVroqWxwgg/zHcMFo?=
 =?us-ascii?Q?I3mQnlaCyACpLEsQEHLDj9PxZRWr6muY2t8bp58UfUKr1pPG+zWvnsFPWNCm?=
 =?us-ascii?Q?VI/VOOZwnt4n8qxA/KVjt6Y9oNlN2kq4GH6hSMjD61/c51UVMbZb7Z9q5LrX?=
 =?us-ascii?Q?Oln79F1hK1iAs0rt5wDK/pFgYzXNQj7+1TWUWmOFGtAgNqd5hBrI9GKvczeH?=
 =?us-ascii?Q?uRMhGM2UHsUFlEcTShWhA1fGqX9ac2PWLMDRyxzoyKVT40HNmU2ay8WQIwOd?=
 =?us-ascii?Q?316qCoZACLFcvojdwPqcuN92mKcTpchY9JCZuAiluhYLs7hf0h/AuF/zRH1A?=
 =?us-ascii?Q?jqkxzU16Ml/RonFTIO4WUotOmArIb2BnEPd+Gj5+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b30a1c63-6ac7-4549-6ef2-08da9b543064
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 22:05:11.7479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gHnmnHCJ1hfNHGzGv1ZmoB7Ri/iiwz/6yVorr3H/bO6W+hKnZaDQAsqSaeEUWshj/hDLPnu7/0C0lglrqXRAkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3043
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Tuesday, August 30, 2022 8:34 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui
> <decui@microsoft.com>; David S. Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Jason
> Gunthorpe <jgg@ziepe.ca>; Leon Romanovsky <leon@kernel.org>;
> edumazet@google.com; shiraz.saleem@intel.com; Ajay Sharma
> <sharmaajay@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: [Patch v5 03/12] net: mana: Handle vport sharing between devices
>=20
> From: Long Li <longli@microsoft.com>
>=20
> For outgoing packets, the PF requires the VF to configure the vport with
> corresponding protection domain and doorbell ID for the kernel or user
> context. The vport can't be shared between different contexts.
>=20
> Implement the logic to exclusively take over the vport by either the
> Ethernet device or RDMA device.
>=20
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>

Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
