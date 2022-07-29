Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCDDD58566D
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238882AbiG2VUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiG2VUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:20:13 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021016.outbound.protection.outlook.com [52.101.57.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D355510FF;
        Fri, 29 Jul 2022 14:20:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSQFKEWCDXUn528q07y7BOYh3njdcL9RWgfGzyWp7BR5VcXs2JWZIS91C8HxfKbHqYtpM+zWDaiITRCJwPpZlZb6hvZ83cxmtIrrE0HocHkttPPHtQS/VbSmEWxI+9QgTVu+ph+nIxkWoNdefe2VqoZZO/zeeRhuyaE9i6kKDrbhqaDfmQPF/Mgb0YQ5CZFdpUj6ZlUz9vXbBGXwxEUUM2mpYlk/retofT0fmWcteu7RyU2KNlFOa6WJ9JFdmDe4R/tP28wb6dhY5vbMYcxpghOmt4BsXxpIGB9Z+jz9v/NBAFgbichqkE6VHJDI97Nw4QB9DwecFRUd/mir5gUgfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkfbWhKdI7PUvS3YAhschkTylo6r9+YiV0KI/meSpzo=;
 b=DsQY79Gk5AhwgRMJa4AHfXKNjhEuVfLJeQpv/XOWonDKw/0LNWY6o/TneE9JoLw25nBkyqC4gAsqp+X/sWxBTMPpw/p+7tDYRWG2YBvb90spc+LFA4AgOw6w6TrC+pXDNcQjyAF1NBNieCE3cFEh+SEvPgXRVSISzqmXYFRFqcuqer52JUWXarvKedoc1nN+8GN5mbMye8oSOWSQtNCW2sYTyNhQqo0Qig8Q/H+4B7fo/bGnn5Q016UDCdWcpJFjFo63NIxfZk3vAAhzeDAGzprvF19QI8HmRcNMp+JTwGL8QLPVjbZHy3oaPCVqxMmp8gXnjZ70bPcR3e+MyvBLIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CkfbWhKdI7PUvS3YAhschkTylo6r9+YiV0KI/meSpzo=;
 b=jP+/dTGBkXVkG4fQQmMVmRNHdZo0SGcd4q4ACa6IAHQNHtVWafKhRIUVsyWEt4qbiQl29eEjoB9KqnzxeT1iXXp7j+f5pP4oPCD5vt0hLjvuvtVA4hBXkHV/TrmU+ybVPYQsNGcuk8zBK9HODW7GyWY9RPu0oXhJgnsoSqvIckg=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by SJ1PR21MB3744.namprd21.prod.outlook.com (2603:10b6:a03:454::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.7; Fri, 29 Jul
 2022 21:20:09 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::69ca:919f:a635:db5a]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::69ca:919f:a635:db5a%5]) with mapi id 15.20.5504.009; Fri, 29 Jul 2022
 21:20:05 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Thread-Topic: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Thread-Index: AQHYgSXY1SrlgLfyyEyOddi806gORa14hJeAgAK137CADOflgIAABSdwgAD1agCAADIx8IAADwKAgAcIraCABZU2AIAAHszQ
Date:   Fri, 29 Jul 2022 21:20:05 +0000
Message-ID: <PH7PR21MB3263E741EA5AA017A2AB5602CE999@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-4-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB13272044B91D6E37F7F5124FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
 <PH7PR21MB3263F08C111C5D06C99CC32ACE869@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220720234209.GP5049@ziepe.ca>
 <PH7PR21MB3263F5FD2FA4BA6669C21509CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220721143858.GV5049@ziepe.ca>
 <PH7PR21MB326339501D9CA5ABE69F8AE9CE919@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220721183219.GA6833@ziepe.ca>
 <PH7PR21MB326304834D36451E7609D102CE999@PH7PR21MB3263.namprd21.prod.outlook.com>
 <YuQxIKxGAvUIwVmj@ziepe.ca>
In-Reply-To: <YuQxIKxGAvUIwVmj@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0927ad60-bacb-4c7f-b9eb-dfc5674d1dfc;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-29T21:02:45Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e31e0b0c-3e44-4288-2a3a-08da71a81b32
x-ms-traffictypediagnostic: SJ1PR21MB3744:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X3RYCe7PpEev+dTb0oCnfV+d8I77ORxsxyz81C3WSUrVV2+VWvV2CUDzYbLSgWR5no01qfXvKDi/EC2xsA1PsUU081oYOdUTAqfdV3hUUkc3QCROry/SQ+EML+pqksTASTRYuH/gqVJxfKqEZI5yZt9R0mRlxxUlw2ZxEHkp48EoovAwWQjL0PUm1rMJgYTC3hJKiRnanzf7wh/4Inbc6jfJCH4ugKdM3xDtraCBOmYGekMPPjbCvA7AqISZiWCWCb4qckqnHeNcbXd1osTPudaSgfME+a/R++AXO4jz0WNxX0jJYgm3xsuez6BRUC2pt9aH4MVzjvVrBQ6s848jaYA691lBkIs4iU1hpPjSFSzS2Ul50yZ8fQ2qMJ+gQCzL2F8ey0YAJAAd6bOJuWYan2URUp4nGJtAKIf+a1oDFlaytyQu6TJpYguodm/9sW0XIk+kY+OItHvmycLF6cV4pZRhRr8JiN20KfE3pcgd1BWaWCksqXVFDBxym1k0XZBHJi6b94OcC2uhv9oLb2KroinI+hiML3Kimalqmbxy0IlokxN1+cfvuOmwcqs3nCHSHVWwHI9cdDJQFyh5H6v4db04CTLCiTbO1c0kge1rwvek+s54m4A7yRJjmfMD+d0Nc+843dgVIwJ2tNNESTEGY7VupUwWtgL89MlueAsl3qtgFbCC5ZPy64Zx+a5qh78Ydc+Vvvxu4484N1RMYZnZN6ak79lVFMZTKwHJRHYMK6jR732S8AraA3hHXX5XkNLM6LRq9e6xls0id+3bcxf+ARQpLH6Z/P1QGTWR78A1xLidUrtXqDQ0M+K4o8te4eR92SCNKp//jrT/akJPVdUjRGrpNZR5x8e10jAUDWUSOpU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199009)(478600001)(5660300002)(41300700001)(8936002)(7416002)(6506007)(82950400001)(82960400001)(55016003)(316002)(38070700005)(52536014)(54906003)(6916009)(10290500003)(38100700002)(86362001)(122000001)(8676002)(66476007)(66946007)(66556008)(4744005)(66446008)(64756008)(76116006)(8990500004)(4326008)(33656002)(71200400001)(9686003)(2906002)(186003)(26005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?deAEnCxUsiqhlsgayw/eFtxGrUw+s7mB0CgeN41pXTCQCb5pnVki18kEeA/R?=
 =?us-ascii?Q?E7kPuW+H8EHeX5WjU9NJ1DQOOhGXga8uD8CBOrVN3gWb2JoST8PBalzVJtH7?=
 =?us-ascii?Q?CW0azhhx1seo0WyAGfN27liit2ehgZPkFpZY89EwgRXxSp9zAOUTKImTEeFq?=
 =?us-ascii?Q?isIERDVywocLwPG0yUS+ur611uuDux3NgNpdchVDkDDyqQEvuvNY1/QFpiMm?=
 =?us-ascii?Q?P0MJNTrh8wupa840TwOqYJSpOPsx14cMSc98QRS+BaCC2GctssQzBAjLuWZm?=
 =?us-ascii?Q?bDYXFlpINrP1oLoGeZM3WcUE8yH08fGhSwdJGDrlumk5yA4hldeul2DVjvJo?=
 =?us-ascii?Q?leYZXrHXhd4/KeBEY2qwXdCfi36v6rKst/8yYtGVkLsGO5ZoQRVyRu4LesBz?=
 =?us-ascii?Q?jGGqWDGlaoaD7Ho9hdHrd0R2+vxRYb/uUBFlED3yjtW1FFhPCJvcPpA0MgdW?=
 =?us-ascii?Q?GIuThOX3BRgmgXT0qO/MZwoV7LNMRhhfWaDp1eaDWoIwESaskMe4IJETkOMZ?=
 =?us-ascii?Q?acH6BRi16zvpHNxUlBOd+qZZzWlUQ2uEE0nPOLv84nZ8NrMpEAFkJaa38EOf?=
 =?us-ascii?Q?oCk4OGYGmVqeWbIOI2uiF+BcUbbs6n9SzNuw1m4y4dLd7neaja9IUjTGitBn?=
 =?us-ascii?Q?qnhchXAFZuhND0cr5N1hWCIZqNrrios+nKQtINs2N4RBokHV+Bq7+YW7fE//?=
 =?us-ascii?Q?Rg2Bmdl9BDBIu57W1vMfeRMh4wW3Mv8QJxdjQ8//0pPITE8y5kjzG77DKH3i?=
 =?us-ascii?Q?NJzahQASQis3nrzboF8BLZ94zv5g/jucGFQAVTFflHGDi99lh1yXq9m1vc/W?=
 =?us-ascii?Q?a6sRkDyQnVZBPFmoRZCQS8O0Nu6qzIcaThlSAvjyJDFMWIIVfHao0OvgLFz4?=
 =?us-ascii?Q?vznXFvkzwgVLTFFPgfjnCPDHiGm5aigJgR99zMJX1CYAUmHmw7jm436KzElS?=
 =?us-ascii?Q?igBrLTIdaUC5tN7n85FFH6IgAp+vxCrNZIK5JC5JPbrr5m7wIYo568honToE?=
 =?us-ascii?Q?tRiCnMEvZOL/lEVBi6GLlvCjLHcufe7LeW4Mhqgq251/kLDlDjJVoqGf1TWJ?=
 =?us-ascii?Q?8kONXhbkuV3KufDLq8M9rxfFveIzLEC66swH4vHWz/6utW0JQ674Bml3guQs?=
 =?us-ascii?Q?Twx3GDCr/sQ03eR2ZLFE0STU0XP6VvYNzi+qhejG9td7BlUCarPH7EtiTO/+?=
 =?us-ascii?Q?E9qjTNJ33bkFbxEr46t/Q+WR+I99+mJuxIiZdrJXg1NeuZi3YCcWU/czdQ6V?=
 =?us-ascii?Q?9yUKKPLiv8vEECfvA5U9X2PwGacIAM4UzDkvc+yYVB/zAryKXhehNebbfQA5?=
 =?us-ascii?Q?/2pgZMLzCDuTkxvF5r8M4fMczWU3iF7bbpXeyRCmCQhCMI4d/Vq/mZc2Ko3G?=
 =?us-ascii?Q?Hp9ttqlcoLBdIhVxiboxKLCUlGzT6i31rBP/cCElRCilWaZzC5lCh0+0CC96?=
 =?us-ascii?Q?V6OhCFzKm5CChTNBkiGU4mta+HVzDZojXQY0h+gQrdrNHetgg+lLlnA+hEqh?=
 =?us-ascii?Q?2cGKPxeknFJ/ic5Q1h0BbzbFawOGsnjAGTjLnzh68WTFdDlEurF6rpBBIjtZ?=
 =?us-ascii?Q?BGMnOsjFWTVIf2pshVqzin9GEwuNKKLer3BWOWdG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e31e0b0c-3e44-4288-2a3a-08da71a81b32
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 21:20:05.0439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OEPT4cCaCKkrcYEIlWxhIDmeT4EyaiGTcauAaJB0ZNxwjbVycgpTA90gqgM+4ErqnoNIXi9ETSezEiwlJZ5T5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3744
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > the Mellanox NICs implement the RAW_QP. IMHO, it's better to have the
> > user explicitly decide whether to use Ethernet or RDMA RAW_QP on a
> > specific port.
>=20
> It should all be carefully documented someplace.

The use case for RAW_QP is from user-mode. Is it acceptable that we documen=
t the detailed usage in rdma-core?

Long
