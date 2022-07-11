Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638A256D29D
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiGKBdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiGKBcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:32:50 -0400
Received: from na01-obe.outbound.protection.outlook.com (unknown [52.101.56.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D20218348;
        Sun, 10 Jul 2022 18:32:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTcroxfFtgOMa9rG9qXJf1QbmcD0rq1N9iWXPsFL6j1cLsCm/ICFp0lfSJNaRAkKKSwxbjr4kH5F+THek8spJFj5ziZQCGignI0749x7egV1WCE17O4Xv1skaPndS8s1Uk7iK+bEfPb5rv3EmxMu+Q0Rz2/hNT/K0Ln4zGNuEN6fiMP7LYFp9oE/cKL26Y/lJ5cmfasY9C7BKoYSppQcq2ojLmJ1V8zA1EDkPfOD1+jNybnxbtP5jxgU61vJCcJS+1nFHuHW/6M5X/xjyLh8QHstYJ25qCujjRdFfeOdsvo1ps3WkZpj2+7uc0qG9FV5COxIDJGvRUJNXYOzSuA0aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N/MR+f199hT/qwBt2giPKPcY/HgekcH9gQV1fe9zq74=;
 b=YKEQ2G5jNH3+6XfQRzb1gPgyZZFlpguiXyKrh4oS3wL1oPFERL/VcawvbHhmGO6HpmIafw9Vwfhyf/jxF2iMh25ngOFdRx9YX/jW0ww5NnCnxIsMI3VN79PQHHSxwhmO60/0ER7TjJlaQWNstofEv2NAgm4L8TDznJI0Jc3doMVx+1qWWkESpLmya2hTBOi9TtZkqNRiDH51rL/ovVHrry3vjGLVzw/DfVJhpnvpFPQPV87arnQaO7/gXN4Eu+t5+OO8/hzdYmw453z6xkfdP+oW/MMQYtuY5BjeFSb+GlkR4YzDKDv0wWvcfTWeeZ2ogzvlBEmIEo1Kz2l9u821wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/MR+f199hT/qwBt2giPKPcY/HgekcH9gQV1fe9zq74=;
 b=DZkRx90WA3Ja2ujxhRnttlQFWQ6+Gaqe34Gt8w61HvPCiUHEgWcV9oBhxyqw5gEwIkEc2dMaWW6h3nzOgOF8ml1ioRiClowBnebR7Jpo5cAPLScLlIu2qnXEQEn8+yEIQsMkvceq7FRKZSIllLL+r/DPJ5Q5x/4i74QyMpgOl/U=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by MN0PR21MB3508.namprd21.prod.outlook.com
 (2603:10b6:208:3d3::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.2; Mon, 11 Jul
 2022 01:32:37 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5458.003; Mon, 11 Jul 2022
 01:32:37 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
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
Thread-Index: AQHYgSXaDmTuLMCQzU+S4Kr49oRcFa12/0ug
Date:   Mon, 11 Jul 2022 01:32:36 +0000
Message-ID: <SN6PR2101MB132782CA8AE5E01116352AE1BF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-11-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1655345240-26411-11-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=04c5be72-6ca6-4328-ab68-870f355db108;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-10T02:00:14Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9410a67a-bd85-41e6-a3f9-08da62dd3c92
x-ms-traffictypediagnostic: MN0PR21MB3508:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ynjDXlsamHqbneyOxZr69DHHvWz6QD9QFDjg+j3QjWTqhTBxCK3IziLFLkaN9ATJABkP6PDsWPBUpF+O1u7vEQbvHpoTcJz1mT0ESXyE3Hyg7lu0AB7aTp+pebjXwHt1F/94dIu5ubIPZxf1ymzaZk/7V56RdKtdV7/F2m2t/tSSnGYBMHT+KbTvE4R0R2Mskxw/5sPnwOGBYILm0kV9vEHT4O1TlmNs6TRKruEymEVwbmVAiZH6OGwsiu+Ftd2WNgUJwGMJMub1blo3UmPh+437qWb7Z22P9F4suhb4Z2coePxql5gtbHvREbB/DGJ+0EgTkhV95LCjRT3AOOADJIpw9yW7AhT+34MJd4Q2ApLQ93GL6ocvB/onGGpEEPRoJN+SE/1ygFtneTZGFDCz2+5RAF5tjT+eyBmSPaszJISaj+al1C7T7/xlh4Pg7PcImP5ASg8fbmut4dJ2hqMi9uaY5iRYH8G5ACdy5k33Mlsy0hS4q/pOd+njZgYtMr32L+8c4lCc9LwdRX3vYf9tUG3pc0kO/4DBdt2ALSgDbcK5xay2PS9hb0v6seczxFcJk8xlxKitXd6SY54+eDPt7t193wkZ/cedx0yBmWw6raZ3FLFz94s0AZcc+37A8f27d7pmGwKacsMlV/NjPRlYMhFEUCadqpfPpWCv7UNNRNxhb1UQPo3GWHx5dE93Dm7VOzswaMew8o+p0YjRC0vvrOcBmLJOnmvHSV/oCYJQu12X1Uy1W+7XSg32uD2R0yIxLJJaMcJ+S/xltZ1p3I4bQnOVL58Q+ZgxFm5eXgJR5boaoFOItAhgfH6FemFy3P16j17qk2pe0joBE6q5sDWMC0gvmxTWgl6GBMcjRB5G7dt88SsMIYxeAyfcRE4vEe5T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199009)(2906002)(6506007)(55016003)(7696005)(41300700001)(33656002)(186003)(83380400001)(26005)(8990500004)(9686003)(71200400001)(66446008)(66476007)(66556008)(66946007)(64756008)(54906003)(316002)(110136005)(8676002)(38070700005)(10290500003)(86362001)(8936002)(6636002)(52536014)(4326008)(4744005)(5660300002)(7416002)(478600001)(122000001)(38100700002)(921005)(82950400001)(76116006)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qb9xYz6Jot7s0ELUZxo5i0QWv9nU0ExVlNLq44yUCLq/IVFR1sGjajXkHMIW?=
 =?us-ascii?Q?fNuxsVkXGaAWgpMqcpfmpx3dYMVI2CW+R5G9q3We367jTVUDOLHl+/cRvX1A?=
 =?us-ascii?Q?Kd4LwigUl+cD7531MPIFSJVY5Ggzpdr+zK/QouSleyzRSMVYqMBdj8ZS/hDA?=
 =?us-ascii?Q?7h9fFnvjUTo5Sqlefn+ToXfmzB903wBw5SZuRQLIHa4m593+cUSlCN5ZJ4jA?=
 =?us-ascii?Q?FekxtHI0C9MdgDzClezF0srrNHwaUmbKe4pcHhRdOxH0wgux/4+ZaEQ1RgHx?=
 =?us-ascii?Q?HT2XtmXPcWglPbfAbBNhuxCoa5TeDONJulNGH2uNECw65kQd66dWGAA0s6xm?=
 =?us-ascii?Q?app3BWm9ayNDm1E4p91c44AJDjyCx+im5lO9cy8SOrr2KTYaDJQOyXK3Zi+U?=
 =?us-ascii?Q?PfCm0n8WITHV/7n6BYM0FasEwSeXE4NALMvaTulMMtXYbwZuQhBiPoKl0Dx6?=
 =?us-ascii?Q?Nc4QIqTQZNU2DPSWmaUBHYOT36Kbv2gr1t/yBM5JEmZxDwBFqrjj4iU/ty3j?=
 =?us-ascii?Q?tdvxisrwnHdHRC4gvok3hzncGoIE6C+9p4N+deE67v2XWaGtPwbmlqgf43Aw?=
 =?us-ascii?Q?NdmjIimMx/S98WYCA/CNyCLFQMHqR1XcatoNrrt9dGeKYDJa4IR/rU3gFyzU?=
 =?us-ascii?Q?+pqyRxigWfHg5vnr4bhStkMusza6VcGEHhA4mluN9zGsI0yDEWtaCWIBNZhH?=
 =?us-ascii?Q?s1dmICNjQFTmWXsXDBa00Qz1s4knOF8To0mRbJy+clL6zXZ28sToa2RmR9mZ?=
 =?us-ascii?Q?7t781g2M2dpAXewBtdJXXRzEHIrr6g5muFyGH25ZUTLUut4o8Qn7KXn/M1Sk?=
 =?us-ascii?Q?dVPGu9UT32c273lnhGMiIZLQg4YsgMJU/KxgQuHEKtvJgqUio34D+KYN+jY8?=
 =?us-ascii?Q?DShMb3m/etcgNbL8buUJRN+fL/PPW/kyzHoQOVLK5m0zlpjsxjBpsfSnsiUP?=
 =?us-ascii?Q?FqJCiX+poPyBDYvMcQ1RPqCZYj6xK8L8nBhjUzHV6/+wnwSV1dnWckX1hdL0?=
 =?us-ascii?Q?ptji/BKhuBL0Ah5Og3AzKh1rw25umyFYRduDum11NqnCfjohYLGTeWgqnDQo?=
 =?us-ascii?Q?srvUXD8SKUZOOTA9WBeDsKpAHy1GahoScvI5ZxHFK+LuYfiyXBfRWgCZxtLQ?=
 =?us-ascii?Q?VP0vPqLJjryLfe5ST/YdazHUiuMvoiwrDB3U0KYooXmMfyk1bs/4YUMMbd6E?=
 =?us-ascii?Q?/d8oHIAV286wla20JVt9ZdQzLWXPpabTWyaaZljAEMMror5NQntz4NZDDBFI?=
 =?us-ascii?Q?1APFPGuFilPR9tDpeZJYXRudVRh0AL0rM6rJkJXHiW2mjmIQ1xtCXIORpJ5k?=
 =?us-ascii?Q?ft+gos1sWU9aLZyxmufhRJdPBMnSO6zX/hlyMqvM1nLnCkir0VvabHmpNK+T?=
 =?us-ascii?Q?jyLj5AmvQtwzMp2JwrnMira/790tqST8C0HAkmn2l5EuTMJESDhIbYGg7muc?=
 =?us-ascii?Q?/z5mjpjpuqaukTCz+vrPib7O2U/9M3WatfnSvjAeK7j1Nvn7quVbalbdCjP/?=
 =?us-ascii?Q?i+SnLBSRr+yy4FouRE1T1waOwpzq4Uy9lkYl0D9Rv1H5x6Xceu0WPkUQ0xT6?=
 =?us-ascii?Q?Q4Y85J9Qhru5x+ShJ5J0XWtn1lUtqylu++teUTyV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9410a67a-bd85-41e6-a3f9-08da62dd3c92
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 01:32:36.9415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6El/La8JIaI8DMBH8T+gaUssjUz6bXjAIzGzx2PhRBqG63QqJzZ7adhW8QNMQCtAuevwpW+MRDuvmK9ayIfdJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3508
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Wednesday, June 15, 2022 7:07 PM
> ...
> The number of maximum SGl entries should be computed from the maximum
s/SGl/SGL

> @@ -436,6 +436,13 @@ struct gdma_wqe {
>  #define MAX_TX_WQE_SIZE 512
>  #define MAX_RX_WQE_SIZE 256
>=20
> +#define MAX_TX_WQE_SGL_ENTRIES	((GDMA_MAX_SQE_SIZE - \
> +			sizeof(struct gdma_sge) - INLINE_OOB_SMALL_SIZE) / \
> +			sizeof(struct gdma_sge))
> +
> +#define MAX_RX_WQE_SGL_ENTRIES	((GDMA_MAX_RQE_SIZE - \
> +			sizeof(struct gdma_sge)) / sizeof(struct gdma_sge))

Can we make these '\' chars aligned? :-)
Please refer to the definiton of "lock_requestor" in include/linux/hyperv.h=
.

Reviewed-by: Dexuan Cui <decui@microsoft.com>
