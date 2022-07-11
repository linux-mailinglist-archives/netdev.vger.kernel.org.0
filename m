Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93CC56D28D
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiGKBbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiGKBbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:31:40 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020026.outbound.protection.outlook.com [52.101.61.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4904167F7;
        Sun, 10 Jul 2022 18:31:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDJiPL7th1pjsIeTarDrLumcoaIldwxHsKmceO7YF0lZZfDHWhXPxZdf+7YzIZ/89bYfIE4TIbL+HcJMz3SBNW8NfmUtLqFkHjaRgMeTk4ZaQLSHgHz3s6iSmIiCTbP5ifVZecIfeXBXMsTev/tSAtDcP6pFX19uim6qnm9PaRiDnmV9OgovqpzUa1JoWwSncQ/7iHYNAO6KEpr0JPg1Eh4VXUwcUW5D4twhu9fFKOyz2gRYPTI9u/So/tmR8UY7lJxOQgF8e66llfYLrkE5I65xCDgCUOr9XEB9LzbrJMcwd0UaGKil04IddEJIIIV3mx6jeXkyWnHDMUG5Y/QY6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7cz2iZPEL0otDOdGzG/pkFQD8eQOa39HHm11Yvc38s=;
 b=JSZQ7V2wPMVFXkARlR1onec3nmbOdmqg4nNGWm5+IK0cJMg0xhfcH8sWO7F8Pt0kGdRg7FMq1/hGZy2rQmDcg3fvhfYdJqTBcjOSVARHcN0g3N+msbjhFUCNKY/AKPnQSUE5oc5bMeZXsAqaaoFXd5VX8TB2G22JcnXjeYusVQMSO1GpGleSdQIM2xAvCsn4jcdBLMN4IZq1WE6GRFNiP/xoK4D+ByTJm8yaatthk9YRWB3BmKRvJ0fXEyYCUs42LjLmKUAZvpNjrOkCc+wtDFNwvKow0O6sZtbkuSuSU8tqxnws2sp5vGI8V/uqUj+32qb7to0fjqH6qA3jL6Dwpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7cz2iZPEL0otDOdGzG/pkFQD8eQOa39HHm11Yvc38s=;
 b=BhuOXUqZo+3MfLlBmu5jroNNI/JmCEWh0Efx1SyKyvA6Upjn2cpVVhvMLRK8fbYE49Hke5/9Hi7Yi4i3OAHd5pmEeB2KTT4RoRQkyCmXrB7fDInGaMiYli5uLAwk5DAYgiW9PZF2ucw8B9aGlP8Kmst3MkQ7Ftb7OwdUgpdaag4=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by MN0PR21MB3508.namprd21.prod.outlook.com
 (2603:10b6:208:3d3::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.2; Mon, 11 Jul
 2022 01:31:35 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5458.003; Mon, 11 Jul 2022
 01:31:35 +0000
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
Subject: RE: [Patch v4 07/12] net: mana: Export Work Queue functions for use
 by RDMA driver
Thread-Topic: [Patch v4 07/12] net: mana: Export Work Queue functions for use
 by RDMA driver
Thread-Index: AQHYgSXaXBLRTkYzmEuo1cqOWd4jua12+ZOQ
Date:   Mon, 11 Jul 2022 01:31:35 +0000
Message-ID: <SN6PR2101MB1327F4D818A94D4D1C588F09BF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-8-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1655345240-26411-8-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=93e21afa-271d-4db5-9c72-e1e55af0e033;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-10T01:39:46Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b75be65-30be-4a55-eae9-08da62dd17bd
x-ms-traffictypediagnostic: MN0PR21MB3508:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: afwcmqoci7lCSemrQUbWZebnS8+x6EnA2fB8QRu/Op4uVo+YA3jAi1b4SEjYBaig3XDbXpi7PafFXTlBTod7fLnFfKUUI3UO8fjHBmTBB4RF7zv3ZTcbbfVvSrZbCwx4FuGJaXQ9KrTvBjs+9ZaYTdRwK1E3QbfRYcl0lG0Ia3ilXNyduNvieegt1WbgJDsU63SBXGzZawk/L0YoDkIFdMGL/TidSipknT5/VS0dD7dWpNgUTuxfWQqPv0v9yJol9iZ1WYCZhe8HZ5Zs6WNYpm/WlU15Tz4KlsJFmryhQ2oQDaKvoPw3tgzTo6DUbiDmVL7tiIoaO9WibtLoH4MMWqypixestTPL0KH0r2Mkd1CRlwEmGeGPBX1/TqqEmMwXPfEv+Z8BZ+PgBZINPme6hZKdUpZZ36Dp4cK/VcIjSHTpreUGy74fnWmib6/9ZCaTYWATIep/Kk9edmowVSXTXB1BVDvkB+SFqb2op8MJTqW5OXcd8uK3IoedoSjPcD9SkSZr85JW/GfL0cqLGib2eF1/BXZ37+X05g+UH9ZyUmYm6GtQyhHkb/80pif+dCqlnzlvnzITwtVi6XjPArbbkRrIbPycRtoWnspmIdWwsIyiylWRqmRZsRqySdvB6ILfZJqIM146ooqj/Y4TPKXceGuCO3eZNsCsKD3vgmwW6zxDMWIeWKfAgUp4uX8CnthlT/vkhfRQl5GZZ+um7UJUoCU3Txu7KI3iLyOJK1g4tSJgDyEa61QhK2WE+p2OlphEm9A8tnlSTUY5P2H5qEemuW+xVIBVMmdVWFh8lsAbCmQog0AoqXrjcc5qdEO9i9r6EoFBv6Rwgq1GztbFXu2OICQbZXLGURT1dIrPiMv7j0uovRjxnVj3JFDCRLZneg/b
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199009)(2906002)(6506007)(55016003)(7696005)(41300700001)(33656002)(186003)(83380400001)(26005)(8990500004)(9686003)(71200400001)(66446008)(66476007)(66556008)(66946007)(64756008)(54906003)(316002)(110136005)(8676002)(38070700005)(10290500003)(86362001)(8936002)(6636002)(52536014)(4326008)(4744005)(5660300002)(7416002)(478600001)(122000001)(38100700002)(921005)(82950400001)(76116006)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Pcda4lt2cMcYkSfnkyj0eLWur0gTLPF9gde9uCUkBh/r3VSLOuArqxCkcx7X?=
 =?us-ascii?Q?qMJaYznLAQaUMWUHv9V6NgyOvp0Mhl8h0uKwANmTedAD2FdlRIc9C2rlhrXC?=
 =?us-ascii?Q?WnH91UnIOEQhmD2BWx/yCRutgpeArteeEGu76L0kuBIL2/4vflnrM/f6Xdry?=
 =?us-ascii?Q?ez5H7LaQNN/mlykQ8Tb+IS7DPWfg4FyN3hacxPhhcUk+yWVhN+Afu7tnkczt?=
 =?us-ascii?Q?Ka/BZyY0px3bAVEl4jzePrk4n8Wnf1XOlGmbpsSsjJmIbaVmO/L4n99zKNs4?=
 =?us-ascii?Q?T6S6y0OWWngfXCYdoRc3lcNP3ZZk9RBhrc7veMBRYt7PI0CROIN0qm+t9wsy?=
 =?us-ascii?Q?MWjNHMr7BiHVp1t9TasVQ/X3Z0diSlCo1CpyxJ159WuIvlCFO8AHTiD0a3eh?=
 =?us-ascii?Q?56Kibc0zi5uHp6ohfq6n6wNT4W7h89bozUiAIJ+SIZRuq2Ifb6V8eyUnrYGW?=
 =?us-ascii?Q?hc8KFJKAv4tLYBv22n77PG5PVOZXm14FkGTaIRk7Cn0sg80OxWqEEpRgpu4u?=
 =?us-ascii?Q?XqOIehMJ339/9PwmE5sg0wZjRUlnynvXf/HG0q/K+Skbwa0/nR62rMVF6IQ6?=
 =?us-ascii?Q?AhNAklJ0zVSiwe800W3j9/iAjPdp3bscesTOS14KfM/tPTmYX7Jwc9sYQLwJ?=
 =?us-ascii?Q?v1TexlTIFcMZmm80vr3JNRi5MYpmxdxGU3fjUJ8OuDKsvsRXrKvfTtgXQhSm?=
 =?us-ascii?Q?eoqp0+2gjFPai/0HIImpRQvyebelsHllrQnX+/HlPxscmIBKjLfTPszQXTW9?=
 =?us-ascii?Q?PlMP25DFAQqqzZNZ0vN82UAbJwZwl3p9/OJzzpWluGIQx2Ds4T+dcJwaQoKQ?=
 =?us-ascii?Q?TayM7qh735Dih89CAFhTeE7w/G1ywb1jXNvu0sdzW9lh+flfCVhboy+renQl?=
 =?us-ascii?Q?oaiaJm96YP2OVHNpaGze9PC+wiCucI5hCtUA5EvTjDZdL99lrVNS/X/Oxxk7?=
 =?us-ascii?Q?pSA3R2xuOiGtCguiqppDHsst+faTo0vlcsAWV7qqwz7xsa84lByTIpRZwBmV?=
 =?us-ascii?Q?zViN/O1Zft6+y+nCgYeS+e5LpE46YjNQYUz7tIM4vnk9S+2zs0Uxd1ra655C?=
 =?us-ascii?Q?OElj5ciB1i5XZWBuVlJjFenfiMmcKkShf7e5eCZJ+arupeYumchhA3HyzDwh?=
 =?us-ascii?Q?4wY4kPIMPD2eTzyTFnlZtjKEiIHx8X+RMgpM/GIpZjJujA1kXpyQYma6/DEO?=
 =?us-ascii?Q?dam5QktJhGm627eA1QgQRPIQBTwGO+0hJJF3roSfX8pyYiBuXfckkSmiq5vl?=
 =?us-ascii?Q?UqG7tEaKb21BjiqNAbKXQnp8DSry1wLUsg9gcnVw6rDBDCk88z0g/qLdIFHh?=
 =?us-ascii?Q?UDnn22NiTPmnNesIPmBbd6Cy7zq7whSq19TebnTDjYrWWbq8xzKQFAkdef4K?=
 =?us-ascii?Q?8gR7UnLcA6GUytqO5es3WDBydih5w66uKhHZssMPiKhT1CdMzwA/TrEO7eo8?=
 =?us-ascii?Q?6zMGupEWCQw0Iz2cHV+wBsFmFhDreaa+nnkiCIMCGYrRCFUggr6BHjp8zBAn?=
 =?us-ascii?Q?uSFRtMEnODmuPCE6f0dpIaNzRhTCqQKSsbbH+lb7tX9oYxAP38r/TayJOFNS?=
 =?us-ascii?Q?cQ5rv8K84LQ4xVPJMMVaHIaE+Z7Lbj/8QaKjNrr4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b75be65-30be-4a55-eae9-08da62dd17bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 01:31:35.1338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eEdOTfQagQo0+HyjozFPK4dU7+8NPzoKKHsG1nsKY5iY17qpfPW0IHRP5bQshYlhz6/tPSP8KkJb9jKfpIUC5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3508
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Wednesday, June 15, 2022 7:07 PM
> @@ -125,6 +125,7 @@ int mana_gd_send_request(struct gdma_context *gc,
> u32 req_len, const void *req,
>=20
>  	return mana_hwc_send_request(hwc, req_len, req, resp_len, resp);
>  }
> +EXPORT_SYMBOL(mana_gd_send_request);
Can we use EXPORT_SYMBOL_GPL?

> @@ -715,9 +715,10 @@ static int mana_create_wq_obj(struct
> mana_port_context *apc,
>  out:
>  	return err;
>  }
> +EXPORT_SYMBOL_GPL(mana_create_wq_obj);

Well, here we use EXPORT_SYMBOL_GPL. If there is a rule to decide=20
which one should be used, please add a comment.

In general, the patch looks good to me.

Reviewed-by: Dexuan Cui <decui@microsoft.com>
