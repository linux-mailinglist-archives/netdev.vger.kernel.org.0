Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38365BEFB8
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiITWGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiITWGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:06:25 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021026.outbound.protection.outlook.com [52.101.57.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2C078225;
        Tue, 20 Sep 2022 15:06:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKLnOp3aMmaSp8HMEy1gwzBLBS3ofl4taoSnAmHzw1/nwJQ+o+1P7H3C6OPOWm3H3Sb+juPpJmHZf7P11ROTqGcBlWjZVgyKP1S1xvx6WkHrmkb4+g8Nyh1pRPu8JwXqMfv7qS/U43Fs8gGd6XXaGR1iw0oU8Wwcv3+pkWbTydEN+OqJPxH3bk0X5LMYgR+zzm7B+2bc1eGo39U71YwYgCljYky2t/VW4JDn968qtA1FdsFPR3JmVsngyQUbgoDmUuU08ylM6JMtCjuKkWzwVMIYrsvT545vIXtbVN7B1t1sZeeujuFLE2YosIDB9BXbcshLLP1dbzKoGqIcbOKLNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m14j24mTfg6W5gk2pj4+YmsXNpAWPI/8gaIuQVcCW+Q=;
 b=Hv+E1spupt6YK2mmHRR1OdsX3SQX5mRH2zrTMLFHACUyemIZyiG5Xt/x1H+Rlvav8fg6xdSrCVTOdQJ9KfoKbmikbfui9uJYDVa6jwtb6S6q0lXZFuvNtJqQOfumZfyc/mh0en06hQ+eFVOcx1L6F8lr27PqfMDU8wn+2l5ZI67BMIwAgDIPcJ4EPlWD6sqomdYokpXYl5oSks6Y/P6KwP6tvqf0uE1RNRDM8Iz0VS1MQddTvJUs+ryxsOpwjDZAc4bTurnJSO9Bl8LDwcv7+WLAzDCMxYRrRDSO/lZO/fI/tpCx+FoeLrI7I5m9VA5nOOQsQSGjxQ0j+hMLCdxPIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m14j24mTfg6W5gk2pj4+YmsXNpAWPI/8gaIuQVcCW+Q=;
 b=LsgrXCMfZ0UMcH5ULIZY1GALxPvx5GiC7wBP/6PCxR3YmFZPk6//sl35/6uueIAzCYMQclBvvj2SGDkg+3WlqlAaKIIXyk6YVLyikrF+AjAVyc9PAZ6ejv8eKxKD097Ocy6lZ3dydewg6OU3UG0R5aYiRA7VlVqS1SC2w5wW1P4=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by BL1PR21MB3043.namprd21.prod.outlook.com (2603:10b6:208:387::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.5; Tue, 20 Sep
 2022 22:06:22 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b%9]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 22:06:22 +0000
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
Subject: RE: [Patch v5 06/12] net: mana: Export Work Queue functions for use
 by RDMA driver
Thread-Topic: [Patch v5 06/12] net: mana: Export Work Queue functions for use
 by RDMA driver
Thread-Index: AQHYvNF4gUHUfmbzb06LJLpdYe1ssq3pAL1w
Date:   Tue, 20 Sep 2022 22:06:22 +0000
Message-ID: <PH7PR21MB3116C321BC002B85763D0F8BCA4C9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-7-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1661906071-29508-7-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=898a1b7d-abde-46d4-8421-0602621412ac;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T22:06:09Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|BL1PR21MB3043:EE_
x-ms-office365-filtering-correlation-id: 0c74d9bd-22f7-411d-e9a3-08da9b545aa5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6V4hoE+bPbYbkBBZOCIWf6WUhiJHyuWgQnHTHqd0R7gNmMx6KFW0QUd/DTV7kKN6njGi0X5dQxxOOWRneolKesqL8N2qaH6i2Sm3TiQD7n0X48MrsUF3I/ha/dDGyJl4GNyLm2EJB7Ik+oKo1te/9/4LL6lJefzbuTbF0mydLWMB9KmZMT560nLqbcSLoKRTow7B3woJ16L1BtfF2mvQ24OdVuGfTrwgbHxtYJBjRG05fUyyS5+jbwKgh6u6/EoW743gvi45H5MVjH25gUk++A7u5NPoC8Py6Y37HxcSGel4mHiCSfFlegjnHQ+ZRyajK4icDz6VcJu558ExOtkoaL2Cc7ZfORyR7T7wIGUqLi8lSWJFLwjWca/SWKsVFDQxqiTDw4haUpaZvU13ovhdFw6wJd8WjmpVmSnsz0PsGBDbhlh0piQDB00bfE4xQNvTuMFNqpeiKvhAjrsrJbar8sAlmDemRKsFAfVmB/6qxFHG+11VLziCfAO0lsb+UauT8GSh7olwnJMef1rrL/pbqp3IKfr99Q+Dy1vDDs5zduOuyUdhdon4HUEmVDGT6YRkBssjsOWEH1FfeXfGs2aobTuyD4Aih3924+cFTWu18pNTqtV/mPjsSe67ZVO+e56shWZaCxzNCkqsGA82iXsvPdoh6Y7hAhHww6jxmQoIjSDDuuKbTGsJHBINYOdqF/VPBWsZH9cThy1c2l6NNsEP7VOsf+38uqL+PsxYHsA4+JsTgcT+NK7zeUypC4n1A/3F2XfzTxgShX5qPPfUWSr7x7dyD3VRPkX08OJm0KuudJV5M26K3eiSETxHpswve4z1qpPfGpLbNx9zJ+YcSaeU0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(53546011)(26005)(9686003)(55016003)(71200400001)(41300700001)(6506007)(10290500003)(7696005)(110136005)(5660300002)(8936002)(186003)(54906003)(6636002)(8676002)(4326008)(7416002)(76116006)(33656002)(86362001)(66946007)(2906002)(38070700005)(66556008)(66476007)(66446008)(64756008)(52536014)(316002)(8990500004)(83380400001)(4744005)(478600001)(122000001)(38100700002)(82950400001)(82960400001)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z6H9DDSKQlDpLwaVWxfhi7Zs91eOJrlgNfXxMOw3tfVU2vox8Cf2vn1FwM77?=
 =?us-ascii?Q?z447MNCKXJYzwHIjh35jE4yS9IiTB0OVW3T2rbo45YEnYrGBCI+xEKVZEpsS?=
 =?us-ascii?Q?6LkWFzr2x8tfCQloUZh+qICo/V5+2ROKioJuFTU5scrEajLqsekIb9b2qQ6L?=
 =?us-ascii?Q?Xjz2qKuos46QcBy6wxhJVAfRxFXRS2f94TdXvwHayAIcIWlaZhhFSwXY/qKP?=
 =?us-ascii?Q?AUeCYC4wZvdy2mjfRKjraKyXyTgy0+uV2fib8SqUy10I+y3fKqkJVibf1Y3c?=
 =?us-ascii?Q?xGdosgSPqPI3Ttcz7mOhb96+1QS+RiKL/sZEqveUlxorJ5y4/xKoD12Oxv7U?=
 =?us-ascii?Q?UlG8JMVicD+h3dK0b6WX/bg/kEQSOhc7l9Pf2G5/vDvV07vIX/p9/JBqZvYx?=
 =?us-ascii?Q?7CEQ1S36L3JoKolZllJkh4sOhOmkmrqRBGJVTospM3WuUTIyKvGVUT0/r6h+?=
 =?us-ascii?Q?Skzc9GpFJlplSA9idEs/icwfqk5YcG6ZZHimxjHmttisb+8AOHzQR2uPbXXR?=
 =?us-ascii?Q?+Da6caj9r/WFD1m0csSsrxcGUYD8wlyEt2pvnOjn7Q+iUXoA3nK5t72vIPtq?=
 =?us-ascii?Q?BnmAO1x3eeMIoGv63nvmPdk3ieztN3m1KjQs3LiF5iEZSjfjzpzrukWzcZA6?=
 =?us-ascii?Q?+hP+C26CjKz9GAUDQLEf6n0PVMVl6l2esIqlNsH4cF1Aruh6HBsDDnqvwt92?=
 =?us-ascii?Q?1PszTPs93edw+pbkaIFyH4mQOubUQ4uBmVtEtjnJjDOg+IiJOp49jC6HF2mb?=
 =?us-ascii?Q?cTEqq/9yyjFkILMdWpW7vYaMKp7xGW3lUMcUOdMS8hp1IqKzXSVUPINIZg0a?=
 =?us-ascii?Q?da7weyxbI2YO709OpRqpm1AGOJWW9j+R/4pFAslOMrFDstYFKas7EBTqfFJ3?=
 =?us-ascii?Q?6GlorWPIruNSK93JcZQrIlm9K9mniR64ooE7tLQoNWn45yRKo4rj2WYaS0qa?=
 =?us-ascii?Q?EUC6ftN8+wd2BAfeRkFgujOkfEeSBsYT0mu7IFJrw2nfKY4kKzKDDrDcStQK?=
 =?us-ascii?Q?2Azf3rolzUWx4WEckD9MXu/37dzB0hparzTzqP/IKr5+1dc/lyBjBSsfIVqM?=
 =?us-ascii?Q?FkVF9sSbN1jK/wGFgg/sRSUgepeJ10bISy6JHuBR+xK9+J+lJMGVRoLxd2Fh?=
 =?us-ascii?Q?g9kdR5luQzcw7kxCsTon8BBaNYz0GJPmvFVgBx3V//2t9+3f8KXdti6YMylS?=
 =?us-ascii?Q?C5MkOBh6fxbK1RvWsbbsJhbGi5Mq1esmkY0A7aOUkgHprhWA6BKJSzw4kf3R?=
 =?us-ascii?Q?GDz9ewABZPau9Yr7puQG0KXleoqPIhdjDNWk6w236MnA2FS8gxyMe/+ajueN?=
 =?us-ascii?Q?9WUpSaxNVyStrzAVijD9Odx9QZnw8MjNjBn1vYIWVaRhCHBLppVwGClr1NcY?=
 =?us-ascii?Q?ZEbL5NVX7+dM75fLuVT2lY+JGdxLPEp4djiPIwSUkzlRr0jo7WyABdAuhUI/?=
 =?us-ascii?Q?GSWtws3EWbZ5YopSYAXyKTEG+FYw57JhD+cKCC4kAIGTgAK7DdJBtCQClolW?=
 =?us-ascii?Q?apGrn1xddgBNXjU17Wjr2gFmOTUO/lLgMBshiZVzWHCiOyXXFipnncAuJCGV?=
 =?us-ascii?Q?4vhPOLLMYsolGlIK+OMslC/1TU3ewGSGVmmYMgsZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c74d9bd-22f7-411d-e9a3-08da9b545aa5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 22:06:22.6258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tAr08vlEY/cOTyIscoCrqvNMxUeyG7waVAG3Mbm0XQo98cl1R3c4WyyVpR6jnP26i/8EpT3k3EKm3oiR1k7lKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3043
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
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
> Subject: [Patch v5 06/12] net: mana: Export Work Queue functions for use =
by
> RDMA driver
>=20
> From: Long Li <longli@microsoft.com>
>=20
> RDMA device may need to create Ethernet device queues for use by Queue
> Pair type RAW. This allows a user-mode context accesses Ethernet hardware
> queues. Export the supporting functions for use by the RDMA driver.
>=20
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>

Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
