Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB22452C8FA
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 02:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiESAyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 20:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbiESAyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 20:54:00 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11021016.outbound.protection.outlook.com [52.101.62.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128EE55208;
        Wed, 18 May 2022 17:53:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jvy08O4bz3WMaay6pL7dktv6rbquaRroFXNteIyXDVDv0YRSStwxGTLBCIiNclMkbo9T0eSo2OYC/ELbgDDI9R+laC0mKdlsJw1HWgBIEKaRbghKanXVPIrh7ABMtXuRdQ3qh5NRT9Y1G3zsHh4DkWUTERK4y+E5XOrgyL0YKgif7zXdToDt4EkMTrMifz4QZZoBR+NBFYemqpcK2TkCfrtKQOdAroJCiTYscdxAb51WnYRO3yWp0Kr+QOgaNnS9tt699pvcDpK7quBx8bPqr708yAwjKQnY55CFKffjMVwgqwkNSB5W/ZyN63E4aQyjvbuSp9+WRkPV+ZrDDrXvDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2mA0Xcy+/4d8K9rNJFpebMSC2JhoDnSf+wwIrWA5ToE=;
 b=Yz7PzEYp4uX3LLZx0vFoazfaG9+lXniHpZkuFl6lKOBT34iWRLABejYEBuxfhfV4zBT4Flog4juSAXxaYKv46Ij4cPwNOITy+0SlPEuFpq+qiAbbzjd9p/bVPljhmxFC1np88vi9TYrfTX9mYzpTRaia9L/XieXtnYGXZw2M/FCzc+Lh7wfy18Vsuk3ZJqVz8+2rraZ03SCzsTCFa4zCXw0GyehPeTXYn8XJOivbFDTEqUJrAEGl2X/CyZ6GqUG8nCxvWHVsInKNAyBVhjfHyq2AWR24tOylW8VUDkjVKKFrwaJmhv0gS6U/7OyYLtkgrO7roVUNDpLnzbsn7R6MYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2mA0Xcy+/4d8K9rNJFpebMSC2JhoDnSf+wwIrWA5ToE=;
 b=hTJ2aL4sAQ+3V1wbCP/fhcdV7J+V0hrfylzyr8ktN8a3edqL1agafGamjNjMz+cmneXCVxIZM25UaKqUyxv0Lmowwb+Z4rkeuOMZJj5TkL0nsPtDu+Wu0p5CJeS/zuK7r7U6AMVMHWcyvEHxBlkfZ2Ys93av1hOor/5BxkXPyF4=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by SJ0PR21MB2016.namprd21.prod.outlook.com (2603:10b6:a03:2aa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.7; Thu, 19 May
 2022 00:37:54 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd%7]) with mapi id 15.20.5293.007; Thu, 19 May 2022
 00:37:53 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH 05/12] net: mana: Set the DMA device max
 page size
Thread-Topic: [EXTERNAL] Re: [PATCH 05/12] net: mana: Set the DMA device max
 page size
Thread-Index: AQHYac0t/cR6HA52CUOHz8pr+lzroa0jKeeAgABLXKCAAAGZgIAABm1QgABEpQCAAFjD8IAAs9+AgABQTyCAACamgIAAF+RQ
Date:   Thu, 19 May 2022 00:37:53 +0000
Message-ID: <PH7PR21MB32636589EAFFF6E521780245CED09@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
 <1652778276-2986-6-git-send-email-longli@linuxonhyperv.com>
 <20220517145949.GH63055@ziepe.ca>
 <PH7PR21MB3263EFA8F624F681C3B57636CECE9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220517193515.GN63055@ziepe.ca>
 <PH7PR21MB3263C44368F02B8AF8521C4ACECE9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220518000356.GO63055@ziepe.ca>
 <BL1PR21MB3283790E8270ED6C639AAB0DD6D19@BL1PR21MB3283.namprd21.prod.outlook.com>
 <20220518160525.GP63055@ziepe.ca>
 <BL1PR21MB32831207F674356EAF8EE600D6D19@BL1PR21MB3283.namprd21.prod.outlook.com>
 <20220518231111.GQ63055@ziepe.ca>
In-Reply-To: <20220518231111.GQ63055@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ffdd0740-9cbe-4e97-94f9-66c7b6943ca4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-19T00:36:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a33aefc-fe95-472b-9b5e-08da392fcfc9
x-ms-traffictypediagnostic: SJ0PR21MB2016:EE_
x-microsoft-antispam-prvs: <SJ0PR21MB2016E7AB447D797AE66E2627CED09@SJ0PR21MB2016.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Vq/fiiVN2ieAUiePzClI3rt3/0P2VuhLsFohaf0T4hSbz6t5z/DnBPBgGATGY9JuqrH7AbGofKZpC+gWFjChEUVOhF71DJZMvsND5PnIZdkmHl6fYYp/mXW64xQuDFVxCpIrkiq/7aggHJ49CKu2+Vd8iObtayvaDSEhZEgvfgs8eT/Jv32mkjxTEUxGNB4rCTKYXEV5sh8uERNubYy92vOle9DSutrGnExKNn8/rNQVO09CG0P9vwy/nu8jzti9jBWXnP7ZONTigJas7oNqyEcFnNOHFQUjXzfEUR+Gi3xdtrInn4gn7XYIxod2uQt5BR59eInmaZqw5nbwmJUN0HinriQYPNJ5iU14p2dVJidRtHlrijucbReH4u+UuSrBVTcvSRPlp/q3VxiiLtds0vYtUvwOoZ9xjHEDxYlckfPJYumcXy84TsFa+Huh1GWgzcxJ3BjNWbTBOWlopU5rQ/EUjNnsxdJd4p9B0T6XAkLSJQ/5bEgaIr2L57OFP4zV9Y+CZn48yvOmKInLDGvPQSNfKtyvmqLmz8s1NcB2wKnL9fcX7ZeiD/GQIKtJZV26dw2vtoP22RzTgE57yuKl1NGws909TxQIRicwMAQAADgoisacbqAWiHhke1kUz9dFFBB7v3K1ZMG/mLIEQtZ6OFwihMmqocHNEIeO8mR9NgUPo+Udlg2pQ65UOxSPRqExVv0X/cC1CyUCJixUBNcI3gDTzgQx8jmOoTiHPv5jqv7KRUHd3K7UGXbMpBLKbQO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(4744005)(2906002)(71200400001)(8676002)(66446008)(66556008)(66946007)(33656002)(66476007)(8990500004)(4326008)(7696005)(64756008)(76116006)(82950400001)(82960400001)(122000001)(9686003)(38100700002)(38070700005)(10290500003)(55016003)(26005)(7416002)(316002)(54906003)(186003)(6636002)(86362001)(52536014)(508600001)(8936002)(6506007)(83380400001)(5660300002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WE/VH6w5zlW9gZ5F//Ukdmj0gIIWq+iPY39oVrVjwnVbyRGMjWB7RL32F/P/?=
 =?us-ascii?Q?myeJdYAwam5lUwnTc++XLKR7EgI9kFJxn930jpzuivsfBIRKWY2/ypj3YddI?=
 =?us-ascii?Q?ugkifkfNYeCjw+6wKWD/6QryP2UaY2NU3HsfwoKk2TdmdNQQfhohPUYSQmul?=
 =?us-ascii?Q?87zMaq2YFrgRObJS0v+NHlhB9VH7ZkeEtRDM8C0eUtdNyazu3mCsdvcVo3d7?=
 =?us-ascii?Q?D8uLVWX3VXMRj3r1Sje3bULSMtTT9pF84hQxgIWj9AIyrCi67f3e+Rqr6M0n?=
 =?us-ascii?Q?8LOhZKtO/9Yria/4GUimrY0ARMcNyvg8lyiFo83/V/CYoqD0hZAfH4dsh24J?=
 =?us-ascii?Q?0Dtpm9WmW9tQKpWC0lMHQe3wa8YLv5P7BZYmjYQiL6lwQZ4f0OO/fbRYJ60R?=
 =?us-ascii?Q?BlKOuvRDYXxBRlc8ylTNkU7qwknkmmj6jUSS8sJA/RRvhYFUAXNL5YhPWrv+?=
 =?us-ascii?Q?a/myuHNTjV7LMF5EaKEvHL9lSNolYFP9/B52mCgP0RBxaMbChmXLfqq++PnJ?=
 =?us-ascii?Q?RJW/ozFnJo9SrKY7yFuw8QF1oUYAoOsCsar6L4DUx1K2kJm0xzkpb/rF0GfC?=
 =?us-ascii?Q?lDSrIzKfuvmnmKgn3XiNA5aM/tYJmfFH+TBDykpA6/Wcy6JTOa6ldHXBUnem?=
 =?us-ascii?Q?meV9AcPPX2TGXICUXNoJDyD40JFYISevr+QuFJVnYhsc9cyShiSqvUzzwWw7?=
 =?us-ascii?Q?vwYp33KWvdIMt1ACicVX7S1TK0g10tXfZbZG7dn9BjfcddqanYvA/FjCWYHH?=
 =?us-ascii?Q?zCwZvOZE4jldAmgYXiORKtT38aSCoGTMNa+eD9HcV2bp+tDR19TP7XW07g0j?=
 =?us-ascii?Q?cVBKERNR3qhuUPJo7Hqkmk3e+ySehrLvgzgbGxSTDpQusY5ilTTdqkACZ5gf?=
 =?us-ascii?Q?XnRrd92f7sDhLVytyJGg+ZHD4oqCUE260bYvXDfPO/i6lnDsv4pU9HTjgPhT?=
 =?us-ascii?Q?2Sh9f4qdHItoSyStdYrfbuuN6eCcMnVlpRvrZEds2dGqaRnmPnZSvIXuHztr?=
 =?us-ascii?Q?4QbZnKmz4T+d6m+WsRIPEvDVoHIdJdpiRsMABMqbDFlBTSMYlb1rsvLmj2Kc?=
 =?us-ascii?Q?vLXjX3MntMmkm8sdRMHWK14WGpoFBJFFYw3oUaz++6d/4BAmhXI43F8ARXsD?=
 =?us-ascii?Q?PEvA+WsOyEo0Lw51/pkOssMTcxzJxWnKO9anTnmXGwCcEjQAKBMIpfKzvuV+?=
 =?us-ascii?Q?GPHpfrFOiYI9XSjglcwNxzERnbZrughHqZdJZbCpuxN9q/wUX1Qw5wegL4MP?=
 =?us-ascii?Q?lnT9ZL6lfDC50uxUrmC6sGNc6KiZcmtvGL6dYwBKk30hf8SBxHbt5N0S7zyx?=
 =?us-ascii?Q?WLGM8CZvBIh9SR08Cu45W0xiZimBp4InmtYW0RFlRdAwp8wsDBiJQ/n1yc9X?=
 =?us-ascii?Q?+so3bKD+6ZAsp4OOQDUonaiJGqz5TuxqyPgfOR6N0HihmcH/e7Qg4PuwuCZm?=
 =?us-ascii?Q?bI/21FnnStEItcPg1w6Z1rDhqpGyDgHz4hcZgqIuPK0WNtsjkFPvNN/qnYlr?=
 =?us-ascii?Q?KfE6r6IuECElGxxFfV8u+BUgeKvBZkFusKES3B0yFUT37skUwCKU0GPzKq0G?=
 =?us-ascii?Q?vzdIPJhydhsxvPCoSwsW9KjQg7xPDiQRKRzBReePtusJd2uDb5YcVBvl10r+?=
 =?us-ascii?Q?YZHVhYZXZnSHQS12jH2Em7OmZojpgSpRTwZehTqey3QQHOIIKq2+lbhv6sfU?=
 =?us-ascii?Q?mOLOuX4qwWBdb56bWbAGlgloKlW31wHsX8wtdygvZE0TeHIuONVEKKJJaBwa?=
 =?us-ascii?Q?RWSwhinOWw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a33aefc-fe95-472b-9b5e-08da392fcfc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 00:37:53.7589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8+2MH0IuoxM5WWriAoPrid/VErHkcIyU8TgpYia8l7n6x4hu87A0s8RuYybws1HcWNkjd+qkobDzHBEHX3zxHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB2016
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [EXTERNAL] Re: [PATCH 05/12] net: mana: Set the DMA device m=
ax
> page size
>=20
> On Wed, May 18, 2022 at 09:05:22PM +0000, Ajay Sharma wrote:
>=20
> > Use the ib_umem_find_best_pgsz() and rdma_for_each_block() API when
> > registering an MR instead of coding it in the driver.
>=20
> The dma_set_max_seg_size() has *nothing* to do with
> ib_umem_find_best_pgsz() other than its value should be larger than the l=
argest
> set bit.
>=20
> Again, it is supposed to be the maximum value the HW can support in a ib_=
sge
> length field, which is usually 2G.

Will fix this in v2.

Long
