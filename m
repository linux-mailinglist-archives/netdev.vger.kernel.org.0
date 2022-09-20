Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BDB5BECD1
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 20:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiITSdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 14:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiITSdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 14:33:05 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020024.outbound.protection.outlook.com [52.101.61.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544737331D;
        Tue, 20 Sep 2022 11:33:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P4e92xxEWr4dpxTVn8+7QEZC/BFjLWoPFMNwucQe/kHjLz1KKchwbrigY8L/PbggEArzztny1tCe5EGFZuWqR2Y+rWWDgyJLY6ScxErCYCGOrYaR/zPvCD0qmJhlQJ/oHwbJaYmHwPm8EAvxBLeDggY0BKXoyhq/mcxmn3tN4XAwCGziK68dAS9jbd8RGTaeBCYraUAwnAGZRw+bYin8ezNi+DXCzSwtFvvxlKiHu79J3wmeTrbmuhQzPqB1FTTfT9vrgwy+umYwrjgWXj6JKXpxAETEl5gko7El02b9n7wpeEQAFBvyFhHnXf2Re0e8lh+U8EJ5dTVyzYm/x8Ijsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LoH+mVNkn+SEmAaU/elv5AI7Ycrob9vATH+TlaPfXA4=;
 b=UsnXqS6u7zrxUSrm33eu53Kk2ryTInfiXP6rZyKb5QSZWRNN+eHo3yxmXUCZ43Ijg7jLpA9p6ilvTEyItWW2PipmD+i95nMR81dHL1td61/6Lt2P8nD3ykF7JdncnMm2niowwQ1PUfH+1FxgGjQsyp469XJI1lczCIKdeI2VSTm8eXNW58lEMhoBH7Vy7HXPs/Fubr64L5x3Wn2AMxRmq9W9aKedCfleQlYCtcBmsBBc6x1PMBCjgWlUPyTHPKNyAsfRI20LLQx13HQThX9vGnw7KdiR1QzHKDhXpPRRbc+FeyRM1npzsyc4FfcR1fcS7xkTn6SHca73j7mK112Efw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LoH+mVNkn+SEmAaU/elv5AI7Ycrob9vATH+TlaPfXA4=;
 b=KhM+hjpjNuNZkPrmYVHfr5u/7LksPJ9jlzjVGSKZW9hCdXxaYuI2AZo/26tnxVNMvw1KeW2gOxOJ6f4I7g3iorD/U0TvgfOgADh/kTN2T3D7glkC0/J4/g1/MdsBJpB/auMR+MhYZi8I/HROl9J/2ojWVC99bFp4oU/lSv0aXDk=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by PH0PR21MB3024.namprd21.prod.outlook.com (2603:10b6:510:d2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.6; Tue, 20 Sep
 2022 18:22:07 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::ce6d:5482:f64f:2ce6]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::ce6d:5482:f64f:2ce6%7]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 18:22:07 +0000
From:   Long Li <longli@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
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
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v5 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v5 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHYvNF9Ou2enAy4lUmWbFSQg4aWla3oumCAgAAHOtA=
Date:   Tue, 20 Sep 2022 18:22:06 +0000
Message-ID: <PH7PR21MB3263326F8FE9A033964A4362CE4C9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-13-git-send-email-longli@linuxonhyperv.com>
 <SA1PR21MB133500C46963854E242EC976BF4C9@SA1PR21MB1335.namprd21.prod.outlook.com>
In-Reply-To: <SA1PR21MB133500C46963854E242EC976BF4C9@SA1PR21MB1335.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=82c64755-33ed-44a9-9f45-3e5b05469094;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T17:36:15Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|PH0PR21MB3024:EE_
x-ms-office365-filtering-correlation-id: 3c62d4ab-648a-43a8-d5cd-08da9b350676
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: asLyPf1fEieosHQkdLgp1LfeiYsJDhAqTMoeVano3MaAOv7bVuD2nLI5lIoZ7QwpTlrFJEQgU1SXdoZzVnmeP/5Q3aVcH1XxA1KKoemBRrSiJggQItRPAu9m5dAfgz6Up7DvfJgJJCUUL9KBU2iNHGwMupGcrcowwqa+2Xxw3YOprti5j100LBZVelor9laKq7RlWzqE75S08MhdLC0ZxqregwqjFuhTArjl9g/Br3c4vGWL4TPN0RCH1zMn/xK00eA07Wqiglz49AuV61knKSYYdC+eBKzp6WWW0E9UWIxtuz6XQjPwacXJnq48+mtBuma7hbMYFTPJ8iQIf76w0iwucZQcTVJ6y7nCYxBvwOO+OSmG84jreefAIePpsRyDlIhsc80iHj8pqmautpzfBkY37srsxsKUrNMK99iXCb5IwEaniXU6q7Qm6r96n98SihSDAHrDf1qobXIq4nfVg+kgOscC2g1iHgXrzhTixdgP8pfzGCUjFYzx/KxpUNU06OB5nwWNGX0tKz7Y7+bGsJbiGIyODgpJMdgASQCu/cnds2xkcIiYtFQ1xxDWOLXG4+rFeMLprNzu+h81XnDyf74KgSq4U5PiqZKgDZYTWohremXm8wrpU2XCEineBuSYNSLogu5oj3SQS73KBd1bJYmVcBwg/kUJuEXyfgbuh9b+1C/mwvX9byZ3F1Ht0Ytdqym6OiSomWWOiJL0bFW3PzaeLVl3OrpfBZBQxtUtyuD6m/e4rGKoPKYfQqEXS9itROqjRXq7ZBsio7jN1D+ePAayNp0ZsI9bibpuyqizXU7rQiHGqPOHXw508lQfX4iel1pwfLXp4ex8tDSE44RP6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(47530400004)(451199015)(71200400001)(478600001)(7696005)(6506007)(9686003)(26005)(53546011)(2906002)(52536014)(5660300002)(8936002)(7416002)(55016003)(33656002)(66946007)(10290500003)(110136005)(316002)(6636002)(54906003)(8676002)(64756008)(66446008)(66476007)(4326008)(41300700001)(66556008)(86362001)(122000001)(8990500004)(38070700005)(921005)(38100700002)(76116006)(82960400001)(82950400001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Yk0ijSxNM63+82I7ONNwYg5lrc0cUAekK+8iDcRHIf5RgoDy5kJAYCvixrln?=
 =?us-ascii?Q?bBHxvetX++pSaACRqqTKWZr0Yr3QaGrS0avzyOzrYV0fvlJgMRteKmMWqI41?=
 =?us-ascii?Q?enRlbobk6fxcO9/4B4gRq14yE32SihBQSttrYIkvoF0jgPOnXAvShH6iWCSQ?=
 =?us-ascii?Q?IOY9KGRpKTvmjqFRPZ8vumImn7XM5tn5/edyC3cOFt6RgSENUMBpTYdEIA9r?=
 =?us-ascii?Q?tEtxXkZDR+Fu68Ks8I1CihZdWBJhHYBBIxzziFiaupUrrC+MI2Vn1EB0MY9A?=
 =?us-ascii?Q?kk9xkoVETUCvnsfIKmen6imqqINlLxv/bcCIgRhPrXnV1WOPY0+7tilcuyr5?=
 =?us-ascii?Q?wE8uZAD6VGuCAVebBahSGp44QHhgSsNixrzb2sbMQLV7+KULS29F+Ra7iKyA?=
 =?us-ascii?Q?x06wVjahXvPKlHqjjEHJ7B/f5jNFceZ3MtuJhQPWwHJpSOelwQtZTMZ3jv+Z?=
 =?us-ascii?Q?C/bpHA0YVYeIT47nHrp2UCqfO5mvx9IXxA4w0sBanE2NRN9rLsOgCFLIG1Dt?=
 =?us-ascii?Q?11guEka3XSpUgSBVeozTQ1xuz5he/5qLfsAFYzQ4y768X+NCnFB76jLb/2+4?=
 =?us-ascii?Q?BX1eIrFSfpfoxjWGe3+0/TFMhEjxqHwoJYIRe87MIEuIIfNi+w/5/rEDwHz5?=
 =?us-ascii?Q?JHzJNO5ByonA7OohJTO33qUpcEARSGEHkutcZpgmENAYLhY7jDCWrYqT2+Am?=
 =?us-ascii?Q?ssGG28niyu6ZipI3fthf4o4FdOjw8Lq3O9+4FTKFob9DADgyVHurjkUJOC3d?=
 =?us-ascii?Q?G5IgETpib1XRcOtAc9MTvd3U2xPUMMTO4fEuQlslpsxx6uAIyZyo9iJJl+zi?=
 =?us-ascii?Q?UaZy4vZve/bXkCyXRfB1Zl9hROoR9cbZ44Tqxn1mENkZ6j4mndTzAguZS+H9?=
 =?us-ascii?Q?mJ6YDXFHvOxzaZfvQdfjgZA7GTG2GxV4sYDx1Z5c2rMbc9jP3ng21ZimQn+X?=
 =?us-ascii?Q?wK8zzoQyoCrgX6nU2VXsHbwNX/RlNHshUlsf8MRecSG9jw9e3UBBOlC3WcaN?=
 =?us-ascii?Q?bawVNB9zndgpRCcY5gBxcBWQR7r26/pW72v5vseure3q0w9tAkcHG3shGBgo?=
 =?us-ascii?Q?S+Xm6ePNkTS0ed2Ayx4CxxIvqnZbVDz750ETKqj/A3yn24OYZ6QsQ2fZaBOe?=
 =?us-ascii?Q?xnqNxtEkavyp+NL8RM3N/gD/Q4lIm5fMSAZs3bgFITGQuabCRUvvAC7VPETW?=
 =?us-ascii?Q?NEBBtPw7oGQaOnf02f/Uttu9OIDvHFE4pTzsQiPrDcLTkbLGJJZ8zQxdx1+X?=
 =?us-ascii?Q?vLYyAGlQN5watl1jo+xk5jQdcgZJTpSZQdMvZnJCrgou174JqLw+O6iSBYVh?=
 =?us-ascii?Q?zbx8N5AApBKhnXMNtCtOYEF63SbaIH5UAtPBcz/Cjelh8hiQCDnxP3M+SwtD?=
 =?us-ascii?Q?M/WtIP17hcq1EnZY6VQsq+ptkYFVueoI/OCfEYyjBHnumEmARdjg6+FWqpF2?=
 =?us-ascii?Q?ZpyghzGp3LLjtx4dft421XmjfChHScnhsnU96ZrEV2YHjFcECd7dhHkiqdl5?=
 =?us-ascii?Q?+XuPrnrqZQlH9oLVwm9qFUqLES4VMYtXX/LhjBZUlKF8UL3xnaWwXMRK4mQv?=
 =?us-ascii?Q?p5caXjfuE2mI+kHVTfCd5ByeS7dxw2oDhs04BpS4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c62d4ab-648a-43a8-d5cd-08da9b350676
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 18:22:07.0213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qjL1zmZoMSkMprMpMt502C5CNLUgGciYcf5jwfJvizqEYFgkwuobr7dn+CaWUAFWb39rgdYeCfmOpZmHFhTgzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB3024
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: RE: [Patch v5 12/12] RDMA/mana_ib: Add a driver for Microsoft
> Azure Network Adapter
>=20
> > From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> > Sent: Tuesday, August 30, 2022 5:35 PM
> > To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang ...
> > From: Long Li <longli@microsoft.com>
> >
> > Add a RDMA VF driver for Microsoft Azure Network Adapter (MANA).
> >
> > Signed-off-by: Long Li <longli@microsoft.com> ...
>=20
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
>=20
> The patch looks good to me. Just a few small nitpicks (see the below).
>=20
> > +static int mana_ib_probe(struct auxiliary_device *adev,
> > +			 const struct auxiliary_device_id *id) {
> > +	struct mana_adev *madev =3D container_of(adev, struct mana_adev,
> adev);
> > +	struct gdma_dev *mdev =3D madev->mdev;
> > +	struct mana_context *mc;
> > +	struct mana_ib_dev *dev;
> > +	int ret =3D 0;
>=20
> Small nitpick: the 'ret' doesn't have to be initialized to 0.

Will fix this.=20

>=20
> > +int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct
> > ib_umem *umem,
> > +				 mana_handle_t *gdma_region, u64 page_sz)
> {
> > ...
> > +
> > +if (!err)
> > +	return 0;
>=20
> Please add a Tab character to the above 2 lines.

Will fix this.

Thank you,
Long
