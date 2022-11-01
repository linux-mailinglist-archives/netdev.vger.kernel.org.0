Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B12615194
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 19:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiKASbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 14:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiKASbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 14:31:37 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11020027.outbound.protection.outlook.com [52.101.51.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6731B1C9;
        Tue,  1 Nov 2022 11:31:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYKxZrvlTumgL/e7GzlFg750prgCTmLW54arGX7cFkGVIB+dTMOD+a7jrylo7uPfaLSD8r5T7rky3FIRvMLAsGXDeuROejs1+DV5gtB34HZ8HTWsOoMkinSI6Ve45kZgB2SS6CmZJwJTIGMpZ7poGuiue/rf0O3PVJ/L6IJLiVsRsIkHr81M9FLRhrEf5/FK9WoqmHVWjDoO0rd/o2aFl4OAy6ExFL75x5in9dldNTRfSFnMWFYUCuR3BB+I1kMQDn+relO1ggQMpneE4zgAhLc1Gw9yY73URq/h2leu0DtxWkDcfp2226GVidJOu66es6pdOivlm1I0rXtbCzaApw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pRkHifRIP8Y8nupgA7Qdw+21Cs99cklMaCxw5U7iWGs=;
 b=aDmI0iAgA/oqbTdi3MQJm6gapvHNmZkBYPKGQExoWTDXHFD1MgdzICKweyzB0+/1xhiDmcTcdVmFsmQkJcJTopOtv5h2roak0jBZudfLhiKfplxqfyYGLtzjW+qsYvgeM8weG2YNku7H01v4cqqJ3xM03Qhb7qAJYkuMW5ttWu6LwCXEDYPi5joWpwywXQKEqAHHoPG1z5GXBFV97WdaR9cRseOOKcZritwvdCs5W5Sl8jIso5DR2UARyBE/lNzgi8J6Ao6LiWYdodR0qAma9dcDCgHDKQY+LM+VFzDLjzfWqpz+h/Glex7b4lbv6ujD+sAsVV8AaKuHMdmAEriRtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRkHifRIP8Y8nupgA7Qdw+21Cs99cklMaCxw5U7iWGs=;
 b=H4EXGnAZSke8QqUoUrLYyEgnS+hdvfpczprlFpSeFS73bCwDs6YOoqL5P1+zOZgMngkJ3cFaNkzn6oX1YUISUtpgRt7BCmtnPoFln9mRHY1ULSn1RLVbsZzeClJTi2ZuaGKb6eJ/4v5B2JSqJfbxw+Fk3AXfSrxKmd79SIgB5jE=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by BL1PR21MB3040.namprd21.prod.outlook.com (2603:10b6:208:394::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.15; Tue, 1 Nov
 2022 18:31:31 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::4496:4f7b:c8d9:4621]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::4496:4f7b:c8d9:4621%7]) with mapi id 15.20.5813.000; Tue, 1 Nov 2022
 18:31:31 +0000
From:   Long Li <longli@microsoft.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
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
Subject: RE: [Patch v9 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Topic: [Patch v9 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Thread-Index: AQHY5al6hxN6sUEdtEG9iC3l/s+gkK4kFzmAgAA3TbCABhR8AIAAEcpQ
Date:   Tue, 1 Nov 2022 18:31:31 +0000
Message-ID: <PH7PR21MB3263448BCCD27A72891A59F8CE369@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <1666396889-31288-1-git-send-email-longli@linuxonhyperv.com>
 <1666396889-31288-13-git-send-email-longli@linuxonhyperv.com>
 <Y1wO27F3OVqre/iM@nvidia.com>
 <PH7PR21MB3263C4980C0A8AF204B68F1FCE379@PH7PR21MB3263.namprd21.prod.outlook.com>
 <Y2FW7Ba/krWc4nwP@nvidia.com>
In-Reply-To: <Y2FW7Ba/krWc4nwP@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=29a8c6a0-2f6b-45f7-9705-437e6f97cbb7;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-01T18:30:47Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|BL1PR21MB3040:EE_
x-ms-office365-filtering-correlation-id: ab0304e5-92c6-42fe-1477-08dabc374c7d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uKvnU9gbLtF4Fj/qOUMuZQUBTUTZGBVMsm1jsB8I6gQqpmEETvulwaraqP4GUV5NP3Oz7aRILH/2L2bXzYEVdnGZH3c3kkW8UdqEkqeZw453N+SS1Zd73KXV8FZ1d7GyuMXxKyMHpfZ1L7v70DMNoUDo6b8Id51XZOpyb3hppnTkiFkTvqdJRM10aZYQuh6aZkOQ5rbcXnUgmEErRG3Vj/tVReELNM3aKjvSv41Oaj5uHBwlzgx4foNvU/9pzFXxM9VQqwvc14gV1o6PNc3suu0MFVmhNhbLzQdJegQuTtZYRicJN8YlDakcReXY6rX/ejXnk31PQVrfF+Hf+bn6t+G7Yrn7QEVYQ7rqjU5UHl3stLiC4IcmKuf80D2u0wMH6xiq0kiBEnS77QhAih5VqOvvEFa7hsxHJEWIdhf0RmmAjanZy501P7I8Df/GCAJpkFkPYs6vlkwQ54muMBx/pPBIyIJf4SeQj/vcVlOcOTlLi2lztgGwIpPauvhFGYvNSxa60ELnDRHjSx987+ubkob0O+8PuPUBahVFk4OfVN7L/PkOBsj04sSjsb9V4iebBi0c2vZleXpiXbKEsJhfJOMwU8800Spfh8VBoIsdDBTYe/joQYhHJOMItQcsmOJD0UorkFnYXQp0kT5Tb8bm2BncgMfO087JSB73SsYjom6iY/bDfz3gAiiz79ZSUXu9EXajEchmAmdQe82tnyMe2ulc32OkgD8HzHp2Im8ZEFk6Xz7oXjPPNKyDcS3I4ifOEmyYecAOLjHflqlv30qYjbj4IJ/pLKEqWXIYuptVQLqM5CN72IspQK8UvZjMB4Eg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(47530400004)(451199015)(2906002)(8990500004)(5660300002)(8936002)(52536014)(66556008)(66446008)(64756008)(8676002)(4326008)(66476007)(76116006)(66946007)(7416002)(41300700001)(316002)(478600001)(82960400001)(33656002)(38100700002)(38070700005)(82950400001)(7696005)(6506007)(26005)(54906003)(10290500003)(186003)(9686003)(71200400001)(6916009)(122000001)(55016003)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rT3ctBRgdGfD1cUSNfSSA32Y/8J2is3TFO5QEhjQl4Ag62WF9ewLC2wEi+Xk?=
 =?us-ascii?Q?Y5ddoFZtIhKZx/TkZc62a+Kfe7B8FM4aicvt/Oo6tWJp3WZTcVSgbmGSfofT?=
 =?us-ascii?Q?YT7SGZdBwDqL6VPtxW8UAp8yxO3vLSItwBLujEdk3WpxGyvbm/Qygs9gZH2T?=
 =?us-ascii?Q?Fi/ytzv7IfXI7yOQ2x4/Hyi8A/U93+u0feuNW4ghVEJDK6WFSpD7BGPi0RKw?=
 =?us-ascii?Q?CgGz8FObUDhwtCDWa/y99EdFkpK3/AXQnF9DuRxXeTFYQkLcAiktFU8PC0Y4?=
 =?us-ascii?Q?6V8qnLTUxaORD9ljuRa7JyBwBvbNeCf8dH0o7/NHoKfUFXqwY5vHom7yjzqa?=
 =?us-ascii?Q?FRqOdyhEczoOu568xZTSzb2H0aUMcGncHYlWDend+GLlSnHXB7oDu6YHMPzS?=
 =?us-ascii?Q?K4x071DO9k+MI+iHRspGmmcy4/wHnlYMsyKsOZ6HHdaj3rCm6/427ngboeqz?=
 =?us-ascii?Q?L1EQRUTylcqmUjTFgKQr3LuUztuf/ko5773NKUs4b6F3s0hxyK+LLjJ5ORRD?=
 =?us-ascii?Q?LLA6Hl81IrTqPIUCpbhY4Xzz9eZa2gzpoiogZbEbSwJjf7cvHdXWkcMERaue?=
 =?us-ascii?Q?fACkhNFAqMVb+tm05VXivSqQlgUtIFtJLKoYjZC1yT+7aeLqkKrzOHXQaFFF?=
 =?us-ascii?Q?TJV1fwqdndyQQcXmYvX3Y3PXUIDXbn9OwciGDNHn8gjT6J4csqyVOoLTFf87?=
 =?us-ascii?Q?iYN0vmSMxV5vchFHv47omfljhQOFGvHfP9gPf7NM0g3eQFthvCJfXVkVvWWs?=
 =?us-ascii?Q?Tet9NOlpHD689CHVM02xa596uZ7Qt1jc8XSVXwlbiSNarludS8Ayz8YPumA8?=
 =?us-ascii?Q?yQ907BB91RY97Kv/IAhaSrSOCBeGR10H3QwxWVdU6IQ125SV2106NwfBOwlA?=
 =?us-ascii?Q?oC8NUwvdZWpFJC+udRVd+cmC1KUAJrfexnQeubbuleUCKLbBH/xTf7qCw+XL?=
 =?us-ascii?Q?QOPPzHW4v1FKn67UfBotV+j/4FebSUxmWhhrmWO2TgDQbVjr8RiLlf3LTkmw?=
 =?us-ascii?Q?M1vZT8U3yA4/WTcGzxp9Kb9bim0cMxA5tUkeykX3ApYy9s/yAw8jkPR8tKmh?=
 =?us-ascii?Q?ag6eMpnX6Zg5LgjYhJM9ke9usWFRAwtLrA/l8v0Fpdv6BCQcnzLsAOoANuby?=
 =?us-ascii?Q?w1Qkj8CfryLV0bqEy320vdZZQXG8w2BVCdKiX14yRuXtZD2rQotUWDEiADQC?=
 =?us-ascii?Q?PZRlcyPGXhEuGwnKHAEbb1kd5qDznQMukEdWoniCsaRV/+GsCdboSl1U7gKC?=
 =?us-ascii?Q?8flIL4ti+EcfzSUOJO5T537p8HN7h/jnCIKT+AUw5NOZQTM988a2tuZELENf?=
 =?us-ascii?Q?P5eWKDOi4NLv3EbzLex388tfxRBYQcIbSxK2ZptgN4k8wy5GlbEnyWMInqRI?=
 =?us-ascii?Q?sprYccjVaiXH7QUJY+RY/jssH+1GBggwzkNcnieuct2xLHwMAApfZyt/vqHS?=
 =?us-ascii?Q?oMaiBgzXTLpx2709RLl44Cc9T53I4KYLCBExEoKED4aUPuMdWmuE/pMnEpH8?=
 =?us-ascii?Q?1+tIZUeVMgrGeFV568MVaFgnwqUWOB7r+Y8jFeXX/dfuhIWLEtqpI5LvpNOl?=
 =?us-ascii?Q?6DPyryHlFCMW336seyKPyzwREu5gXH/uWmnx8Q9N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab0304e5-92c6-42fe-1477-08dabc374c7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 18:31:31.8209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9sIIHKypQq1msSXoud5VGSn8cQ6orC9iQbyrQ5BNNUZtTsyyNZ0OB2G7SP+4QOvQoRyZYNnfckIAiaJ/ud5ssw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3040
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Oct 31, 2022 at 07:32:24PM +0000, Long Li wrote:
> >
> >         page_addr_list =3D create_req->page_addr_list;
> >         rdma_umem_for_each_dma_block(umem, &biter, page_sz) {
> >                 page_addr_list[tail++] =3D rdma_block_iter_dma_address(=
&biter);
> >                 if (tail >=3D num_pages_to_handle) {
>=20
> if (tail <=3D num_pages_to_handle)
>    continue
>=20
>=20
> And remove a level of indentation
>=20
> >                         u32 expected_s =3D 0;
> >
> >                         if (num_pages_processed &&
> >                             num_pages_processed + num_pages_to_handle <
> >                                 num_pages_total) {
> >                                 /* Status indicating more pages are nee=
ded */
> >                                 expected_s =3D GDMA_STATUS_MORE_ENTRIES=
;
> >                         }
> >
> >                         if (!num_pages_processed) {
> >                                 /* First message */
> >                                 err =3D mana_ib_gd_first_dma_region(dev=
, gc,
> >                                                                   creat=
e_req,
> >                                                                   tail,
> >                                                                   gdma_=
region);
> >                                 if (err)
> >                                         goto out;
> >
> >                                 page_addr_list =3D add_req->page_addr_l=
ist;
> >                         } else {
> >                                 err =3D mana_ib_gd_add_dma_region(dev, =
gc,
> >                                                                 add_req=
, tail,
> >                                                                 expecte=
d_s);
> >                                 if (err) {
> >                                         tail =3D 0;
> >                                         break;
> >                                 }
> >                         }
> >
> >                         num_pages_processed +=3D tail;
> >
> >                         /* Prepare to send ADD_PAGE requests */
> >                         num_pages_to_handle =3D
> >                                 min_t(size_t,
> >                                       num_pages_total - num_pages_proce=
ssed,
> >                                       max_pgs_add_cmd);
> >
> >                         tail =3D 0;
> >                 }
> >         }
> >
> >         if (tail) {
> >                 if (!num_pages_processed) {
> >                         err =3D mana_ib_gd_first_dma_region(dev, gc, cr=
eate_req,
> >                                                           tail, gdma_re=
gion);
> >                         if (err)
> >                                 goto out;
> >                 } else {
> >                         err =3D mana_ib_gd_add_dma_region(dev, gc, add_=
req,
> >                                                         tail, 0);
> >                 }
> >         }
>=20
> Usually this can be folded above by having the first if not continue if t=
he end
> of the list is reached.
>=20
> Anyhow, this is much better
>=20
> Thanks,
> Jason

Thank you, I'm changing to those in the next patch.

Long
