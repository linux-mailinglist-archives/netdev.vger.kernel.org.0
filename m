Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5302C572588
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 21:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbiGLTTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 15:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbiGLTTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 15:19:13 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021021.outbound.protection.outlook.com [52.101.57.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF02A113CAB;
        Tue, 12 Jul 2022 11:56:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5UYLpYm+ajCZKnx7devcSNJeHnDRbdXpETqnpSxrsliXWir3vlFkvGTPV0zz6G5Peeef0gqcys4RAV1xLMXqbZ92Ur7+6Lx0rrMOLARtdmird1O4Z/m5+5RKW6Lj716T/CdjCoJqT8yRurR0AgjCs4llSjk+QvKM8wCiLgg/AVehCi+XfKiSTKmMILaUGpIb8yBnHTZEVneAkUC/kIFBwprI4XbI2i2jJdqOFX+Q8zwWrc4ujdG4zClpsxqJ7EijGh8Q1vCSGt7kbwz21RoXom69x1520r7sH36v01p9dRSbD1NTh8newbf58QWocnEhDPw1XG3v3SdCU5j+RtEog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJZlHtvsmBIUWnqq01pC2BxybYmDwXTho9huwjpoJqc=;
 b=l9N02hkE2ky9GzaRS2uHIeHE/9Di6MdNkxoQOChqCvQ8V9j250s++rZ24RFKOn0JmRUy8N06ka7jGJ5xk6X2rHPiZ/VETH657umFCgtvMYpOnI0Up4qqY2vIlsWkHN25ftnzkEBkeubvD88P0pl02gTh4H+g/uvnJuVuCef8kaY/qT3ra49aGjE25TPlKE+hn/nQ78eMqXqjtzaofseEzlE3k6qfXMaFv8VQfuvwImM4/zTFjBiUB2uJZBlg2nKJC3k2Y7pFeCEy/CYXCHD6FqsQmdvPXYQ4yuPyjUQLZdBrnWv0tB6W6YXa4wBSiaHnSINGikDFlVMJI4A4+EXNoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJZlHtvsmBIUWnqq01pC2BxybYmDwXTho9huwjpoJqc=;
 b=UZkytpViJfshkYIx9uzW3lePEUGdDrIl10tP1vqqP21AY2IJa8ffWOxLsU+oYso54gQBjuviiMX++3f3aXj7bTT2Evj7a/T91tlLl9t5NnFF3RchcXvBdBrpXnwwPoF0ZovtmqWYGvacBZgpl+70iAIdqZsW7sHFrI4whM8ctaY=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by DS7PR21MB3572.namprd21.prod.outlook.com (2603:10b6:8:93::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.3; Tue, 12 Jul
 2022 18:56:19 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::88cc:9591:8584:8aa9]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::88cc:9591:8584:8aa9%6]) with mapi id 15.20.5458.004; Tue, 12 Jul 2022
 18:56:19 +0000
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
Subject: RE: [Patch v4 10/12] net: mana: Define max values for SGL entries
Thread-Topic: [Patch v4 10/12] net: mana: Define max values for SGL entries
Thread-Index: AQHYgSXapK/j9OcQR0GCg9byS04hAa14iecAgAK1uzA=
Date:   Tue, 12 Jul 2022 18:56:19 +0000
Message-ID: <PH7PR21MB326368AF44C6B50E7639302DCE869@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-11-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB132782CA8AE5E01116352AE1BF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
In-Reply-To: <SN6PR2101MB132782CA8AE5E01116352AE1BF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=04c5be72-6ca6-4328-ab68-870f355db108;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-10T02:00:14Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37c05da4-cc8d-4be6-071b-08da643834cb
x-ms-traffictypediagnostic: DS7PR21MB3572:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IatxV5yiezByX6X3ii7elylt61STVyAgLhkWzcXLo1xTPjeOr1J88IZfStnGmz1xtogQtTwFwGi6aR4iq3xLJwpBaESbyRHgpD93xWRmbrSDSPR+M/SdolUGvyAC/zuYhuFrqYlxPNMlBZ8YIwVjle0QJAWzU7vQUW05KhC7ngsZtZbU6JcnU2HLLRTlioQUByjPnvpWk7hbAXpoUDrOxeYsOvVLXZwlD1wcNwF/lsg5MvEhUXhKMUUoXC1qqRKJZYklgkHklC1rM+0ppYJQSp3wuaCeyOAekdG6HdF08jqTQNh5taHJBfQkGqkiF0pi/mN6QMh2JMZZma4ulkYRkQU63DC+DfjjKZF20RqLHOya+5914Qg0xKgdwegp26CESDm4POrNSDSIk+FMLngLIby99utN+2CjqdaTWwHDxJ4tFqm4wwEOQLTxtmwN4HpQ3+l88/JyJ1aj7K5/BCufgLplv0G5Az8TwJrmHitdye8AuaL78yPJOSBpuQb3fIxXjkq57VK8NNpaCiYbRUA4EdNGSN7afCzq9wj6IofXnBwGjeuh6s9v26Ud6EOe7uQlR1RYCSMgpHWTxokSPNchY1+WDGw1n3Y53/e5BdIMOXJaX43d2WksxrNkfXqlYk82UZvkhnogLz/3qd159AP9eqjeVWxEnwSz2aYmJCvkSqUR3xpC0nnEhEYDlkL2E/ZWGET4gPjs/vnx++QqSm8BVqGzqy9SPV6YIp5nIGllDn8FosA15DfXaXbXbOooff4JJUlvA2WYbz1qj9/2xunR6w/Tp6RJ0HCieiPdnxbmV2DGBQDuRt7YcedqX7LFxhA6l7lP3tu8SVvQoUHQF55ExpnCZS7J68UBovy8BdJDFTQylzj7y7NCMSI/IIDfz1z8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(451199009)(38070700005)(66946007)(2906002)(921005)(6506007)(38100700002)(82960400001)(41300700001)(478600001)(76116006)(122000001)(82950400001)(316002)(7696005)(86362001)(71200400001)(110136005)(8990500004)(8676002)(55016003)(7416002)(4326008)(5660300002)(4744005)(83380400001)(9686003)(66446008)(66556008)(26005)(66476007)(33656002)(6636002)(10290500003)(64756008)(186003)(52536014)(8936002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?11aNLFSehg7jg8n+H4BTlKi2AfFTrdKuZ/om74Buf2tOP9yFFiIqroZyF6LD?=
 =?us-ascii?Q?OXkcA9XjeH5fCq7AFl4fUwPPR6yZoqT5lbMHVvfgZ8lRQDnQ8s7FkCmr0Z/g?=
 =?us-ascii?Q?uj9KKZXlmWWH4eQ3EyZO0C2+MuOlNrl+rqeQ4frEYTQP6OxhAGueuGsSndLc?=
 =?us-ascii?Q?EhPi0xWgETzECxBEIjHelh2t79/FRtkl0JfoJgxidyAk9SslhPu/yyH0+1Y8?=
 =?us-ascii?Q?DNAMVjAPFwU1GSTSAp2yJzRLY3Rc7F20BFKR36ybzNp0MYswzDwMAkUmlR48?=
 =?us-ascii?Q?szZvJsImu8Ypyu6JPFQ3ytoHFWyFUplE+U6dKcqfEeVlFG5PNCkR0gGYjfTg?=
 =?us-ascii?Q?D2pyIEn3rntIc9e45Lo5WqDy2xviAysewP6Il59SrWwrCQ7f/NNlFi7r0onw?=
 =?us-ascii?Q?OC6vngNh9mUIYZ2oJSAZJyVfAQfqHCUfvtTkh/i/e6EOkJHSP/vN//RxpLMZ?=
 =?us-ascii?Q?st6nJgNW2CDAUqt/tYvDePTKwasmopX/iWCt9U+M2HmS0ZAGgWa3WUsuMGbh?=
 =?us-ascii?Q?qFy71+IEvzqctZdDKT8FFww2836mqzLGi4ai8lSgP9cfzhu0GkevDmuwaa3b?=
 =?us-ascii?Q?1QdqZVC+UDCRd5EZUNDDjVDbO7HauiVdR2P+g0v47SAckcvgNumu8VYx9LyX?=
 =?us-ascii?Q?eJ9VDUyDuiVgb+D6aCPs5p0nn7HY2PjhcVMzUIJWD3QHkLddCmfXtWZ32k7P?=
 =?us-ascii?Q?fl7WVpo5t7aAGOElhDEZPCjLLZZ84YozgmqvsGifd1mYle2JVTJ7QrBBpw8t?=
 =?us-ascii?Q?1v/4wHOjq/g0zaE9ML4Tlzt3eyDT3CuygRen9hhGv0HyiFQn8/ySt5hc7bX6?=
 =?us-ascii?Q?1VfqSs9iHyXrWEfMDcG1o6a6YOPDNR5MgKMq6FKD0ncid/AgFA1Nd4j+fXec?=
 =?us-ascii?Q?0R7d1QxRwK3l2TRC9UvZ7u9xLX+XT8zWBSF7TT8rAp2PjJ96DU/ZBSYzRnZG?=
 =?us-ascii?Q?5837D2kvGe2XqbnHwD+N6C/qIhXo42Q/3wRGPKmoX6r7z3bZtzylFhcq8k8d?=
 =?us-ascii?Q?HVg6kF/EJskb9y3jYYXGSP73UtiVMBzeyTjFgDJMifQLch7K2AsOEWuJVgUW?=
 =?us-ascii?Q?0eV6cZqkkbFIe1mtiI/77d4Rm80FuqfVxWhPax9YLlYGQurlG0k8vZScqP2Q?=
 =?us-ascii?Q?4vnjog/dks+zC5vXo/BCKmcYUBVaN+TxiqhVUCGv3lv+5ulBodRWkRZVy4M1?=
 =?us-ascii?Q?roY5AWmuqVp9kMypTaHUhuDD9ZRQVeDYv5ATs3QJOt1fBvg1iC5pedohXtii?=
 =?us-ascii?Q?+UXLphswIJDD0fFDyLSMiia4UTvgo2Fb3zJxX67+BQcvOTNOwsrQCUJHLT61?=
 =?us-ascii?Q?3Fm/eY9mVoBorGKxwGCXpSqLJFq62DniNpvLWrwAbrK+mmvnyhJZ/59f4Eeu?=
 =?us-ascii?Q?sr9QoZZFlfW2ukpmLMgGhfLox9vkVqZ0DAoPONBzsfR9jW0tP1SdTAfytlpo?=
 =?us-ascii?Q?yFKmYtv5ngXKo5otUx58e8kJssPqR4e6nxODjzLy08wDIJaNNPVhQPAjLMkg?=
 =?us-ascii?Q?rzB7SOxk/kmXaXo5igCKVHRiyqqC1dWd3h0bQC4GL3wrK4/TTw25L2h/H6X5?=
 =?us-ascii?Q?l/7ca0qkvgcbe3vtr8LXWJXbAV/4BnPE8ZwQl5ga?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37c05da4-cc8d-4be6-071b-08da643834cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 18:56:19.2544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a6uNaCQgf1eJTeY6IIlaW2BeLDUsdIo2w4HFkiUk96As1Y+z51NHFt573OYzmnPYI92DlE2QlW3abD2u1Uqkjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3572
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: RE: [Patch v4 10/12] net: mana: Define max values for SGL entrie=
s
>=20
> > From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> > Sent: Wednesday, June 15, 2022 7:07 PM ...
> > The number of maximum SGl entries should be computed from the maximum
> s/SGl/SGL
>=20
> > @@ -436,6 +436,13 @@ struct gdma_wqe {  #define MAX_TX_WQE_SIZE 512
> > #define MAX_RX_WQE_SIZE 256
> >
> > +#define MAX_TX_WQE_SGL_ENTRIES	((GDMA_MAX_SQE_SIZE - \
> > +			sizeof(struct gdma_sge) - INLINE_OOB_SMALL_SIZE) / \
> > +			sizeof(struct gdma_sge))
> > +
> > +#define MAX_RX_WQE_SGL_ENTRIES	((GDMA_MAX_RQE_SIZE - \
> > +			sizeof(struct gdma_sge)) / sizeof(struct gdma_sge))
>=20
> Can we make these '\' chars aligned? :-) Please refer to the definiton of
> "lock_requestor" in include/linux/hyperv.h.

Will fix this.

>=20
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
