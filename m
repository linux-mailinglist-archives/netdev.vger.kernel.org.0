Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE3F6800FC
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 19:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbjA2Sv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 13:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2Sv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 13:51:58 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020023.outbound.protection.outlook.com [52.101.56.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCD313C;
        Sun, 29 Jan 2023 10:51:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZq1xDYGrbmDOGsyCPBkZVMHI6+u2hd4wGgwoKbSe6dkte6Bxhgod+knx+/GGvFUqvdcSpWRCANcxsYaMBEsvupnzY2n9E5BZz57OMTZ37cFavGp/wQ0O67wQIGcI60lvonR9FybvSWu6Gy6+dU8wlE5pPNOPzkkKWfCpsKHti2+oQvhhzWfIV1OA7B3Qcvz42W6oa/Cgy9hf08ms/V31Z4MfbIxgeqzvzEJC3eLTOIkZ8S3N4S2aq0Z8Q3zIpR2IDEvEJH9eGR0/zR+Ox7/Ud40KVAWbdGC/fYq8D2xJJaCtuAfyETjBt+IPmYxPY64Co+Aul5YADRQhYU5H9lWcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuCYBZuSbFxKuul2G29wIZJyFG6Q2+Pz28f3YPPhqjk=;
 b=W3QJNXirdKv2V3fxnXlIMwyaOb1TbK3xXzRBWxLPyRQ2RBfFCKwH4UkI81tNWGW3N2lueL/h2LT7SbOTZOPWcqFo7+yq7ognbAmDhPKfhaxegEmQxFxdmF+MlpJ9WWw0Yojw0E/c6RPvanfuYYxWtpRflH/+ruwB0t8muXBKHydR6flw/8l00domyuNLa88OI0jILRkbhtBubuR+oRNxVTsTYWk21rNYZlPOCA5Wl5Tbw/jgKGCl8Ib+a0klfIBruFBN+K/2PgaudN2fLFLBwsZPYvJkfyeJsed+Dq+6S+GcoTlFFaUacdbxeIVgqMBR63bCE5dRJot0WKTdWhU34g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuCYBZuSbFxKuul2G29wIZJyFG6Q2+Pz28f3YPPhqjk=;
 b=fQxiimjUWD95nqi9l98n4fmoJ30GyHP3npnpqYJzszPXzDjX1/ab7vFHPi3qpbejFS1MeTlUlDCAYsMwLxj0ylo0lCcf7qGeLv7VF6Bjue1mdkvB6i8Xcf8kbYrGewmnJFFBNELEA6RfqNHdFl/jU3rQbYSSeXVXmiMm/AQAlRk=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by SJ1PR21MB3745.namprd21.prod.outlook.com (2603:10b6:a03:453::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.3; Sun, 29 Jan
 2023 18:51:55 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce%8]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 18:51:55 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net, 1/2] net: mana: Fix hint value before free irq
Thread-Topic: [PATCH net, 1/2] net: mana: Fix hint value before free irq
Thread-Index: AQHZMcn23AFRD/VpY0ej7V9LSkZxq661JFSAgACdfoA=
Date:   Sun, 29 Jan 2023 18:51:55 +0000
Message-ID: <PH7PR21MB31161E49E2567C5E5739EFF6CAD29@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1674767085-18583-1-git-send-email-haiyangz@microsoft.com>
 <1674767085-18583-2-git-send-email-haiyangz@microsoft.com>
 <Y9Y8FSlYNyNDf6AD@unreal>
In-Reply-To: <Y9Y8FSlYNyNDf6AD@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ab8d0ebf-b26a-4b64-a5d1-256b6969b8b1;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-01-29T18:51:30Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|SJ1PR21MB3745:EE_
x-ms-office365-filtering-correlation-id: 4aa7ac1d-bdd5-4a17-ef13-08db0229e460
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0maBh4yJolxVHqxoNrxv7VUeVL3jmqWwzIv4kesPP0YrEfUUisVv2h0Gzi3t9Z0xtU8Pa8BCBJ/IPTT0HanBDbFBktQnKDGw5J5KW5ZcfztiYANQ+dMaSP/owOHkcmsNu84oa1OwR59mpoKfm1WPJce7pE/zwZT6ksBeY4mr5NUrxGkv456AbURk/Nzj+JZbFPbtNKIafQehqb/yjvjX7XghwbV8w/75Z/ciTeF+fHF8D9/4b6s398eq+1/y24uWFrqafOpN0h2cTtIQSCpVn9RpTvItgPMQUeYl7cyUv4e+Us9FXXaDyvOl/Hxbi1IkoGx3Jr8LvM7CjZrPh91SEvMfwA+nhqcaEDqgNxRJdIDrZFr6Pg8XmQ+Xip9S4vJ9yk2CCLUM2Y3TtyDfNfKvH+0y2LjUYB3mJTstXAwr4EzddJespbO7ancgPlTEKTkzHAw64y+9yyYkHLWlIYiq/T0OX9sOOnUTbgbq33YflwjccQQgVkKtk9Vk3+HsOUGAA7y0XQjmnaiVr06SFgRikeK9GlWRAPsRrICqsv7cEzF/Tgcqw9w/NvDCjuhzPGOkyhaiG3QbHAMp6jHML+hv4nvfhmbZ2SVPV5U+9YjAVI3ICUYJqRlAkxr2KSD+QC4RMPaM2hN+eN1c8KC800N7rOPBbRRrJFeDuS43ygwY66s1p9/b8QEMNw5+UsbwPhZZ9R1nbECrIhtvkolo17Zz0SoSQuU4OmDllzZ9sQiq6jwLqClhS7GppbVjvfTYuPi+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199018)(55016003)(82960400001)(82950400001)(54906003)(33656002)(38100700002)(10290500003)(38070700005)(66446008)(186003)(7696005)(71200400001)(26005)(83380400001)(53546011)(4744005)(5660300002)(52536014)(8990500004)(41300700001)(2906002)(6916009)(316002)(4326008)(9686003)(64756008)(122000001)(8936002)(86362001)(76116006)(66476007)(66946007)(478600001)(6506007)(66556008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qSVKKKMd326XSmFaY5SGEC8ALdCbudvo9omq01pZlaygWr+IxkI+DTpNVpRt?=
 =?us-ascii?Q?eOzRgODPnNUqfiq7C+Od9gcCiPrf8U7dlrt/XD10Igd6SiGb1E+4e7w38KkR?=
 =?us-ascii?Q?82V6UnYSNRKi5RERJ49EPWM2WudfLZRpRGK2B8UiT0C6UXrF/yTDqLQNBAos?=
 =?us-ascii?Q?FFwa4JPl95gObgd2qqjgdhfUywO8fxUXNwIxHIQ0ZJBvJ70p+sapeVAs1v01?=
 =?us-ascii?Q?nMHivbrHhBK65Ib1zK6bh0A2qo7nqrRa3P09WfDyeMZCaM5+AAvU8UJ6shkB?=
 =?us-ascii?Q?MdDVq64yz+N8t/lCqM4TudK7+dZXjXiD5GOMkHh20lI22UsdrXbdifMBOsja?=
 =?us-ascii?Q?tw5PLJ7l74MTWCuVAKK/DxdlUzyvCly39chLDuh97nKV69r2Tlg2aqmeLl+j?=
 =?us-ascii?Q?xD0f6a0oLXjVSoqt4B+4FSPMi7rrU19Eab1ykttXfToEKuOpKawlQrWJ/AE3?=
 =?us-ascii?Q?eugQ/FwHsyetcuAALbTUhjsj8yA4EQjcK+pZ+Fj/976hVjnAt+cD/z4eHrbq?=
 =?us-ascii?Q?/gPddEtxToe7SlMU8iznPpLtz491tPZ42XtBktu7TrCTgcM7hCgPt4nehGqQ?=
 =?us-ascii?Q?/CQRY+PDHaobnrJd/LfWN6ciAHi0xCOFBQkgD9F/R5duTGpwitMoY8Bx2CPv?=
 =?us-ascii?Q?AdN5U9oei5Ia3cM2j2rNTKiLVYTnIgn9zs3CXl+g89Hsx0Z93KAZ6w9b0z/r?=
 =?us-ascii?Q?+7uB9EyFWeQdoIqAwHG88KaTyzEA5oDLtHl7mx9Xf3grmLpSgumaHw8EQORc?=
 =?us-ascii?Q?XEWK+AZpYNI9zNN8J3eVfX3LxCklSaWXkmjkacFaxF6/pD9Dn7Rb0VCO83jN?=
 =?us-ascii?Q?RP2vtDToKhz25uO6h+nV0YSlmDOroKVVDofxieNbig9ur5syUfd1NKyE8hsJ?=
 =?us-ascii?Q?Cp8et4/N4WNP5Q/ALzDNmInXL3e9nJr0Nl/s+pbHf/H9hKYFkI0nclQuLOss?=
 =?us-ascii?Q?f/PBYJEEUwBBSwptOhpq9UrSDpH9aUoew+xiGf2TjzB2No/6nGsgZQX7PKP4?=
 =?us-ascii?Q?dAJeAo7jDEJ25b7TTbHyUi+yXOY8MJ876a+M2dEftX8BVOQenKRbjxJnGdtl?=
 =?us-ascii?Q?LGuMksN/nX+AFzhn6hpJlfJv7s0/E9lqb9P/RyV7yWLG7CintHLafFrwIe6n?=
 =?us-ascii?Q?frFeqmwZrAFakflXYLmgcaQ7ddSrIXAcXZTz7Ck0WhoUPEYt94ZXEkzA5cpk?=
 =?us-ascii?Q?Ov/y6TQ7KLSSWdp1avrnU++22cwHiq9okjVOpiYXLRuYyFQeEJb9vRWUKbRO?=
 =?us-ascii?Q?TMi8oMTB2/dNn6gPrwVD/cjwqtGiCnMbw4MRUPzOqZM3Wcp+1Y59FazP9otM?=
 =?us-ascii?Q?Tn/iD4uNunVH9n/OG1tLbc0OBwOiBo27NR1daQr64YBl4LVzRlg0n9Vtpo8U?=
 =?us-ascii?Q?a2sGKCA+CMhTdO5ceeSxQvd6R9jl+t++qoB3uG45pSLBPbULWrWLwtt9+uat?=
 =?us-ascii?Q?tYNy4VkFMXkY44tV/RXm2G4FthZxz1VrQOLWq4ypUpDgKH1Sqq0v8oC9ztG8?=
 =?us-ascii?Q?KOaJ4cPexCJKUeRW8F2V38PXDGyQevzJVagzDX6nD4G2UsAyNVGOLlQOM4+R?=
 =?us-ascii?Q?E8z7SptGrC4ufqn8MxGBG8OZeOau19L8x5cSVe/s?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aa7ac1d-bdd5-4a17-ef13-08db0229e460
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 18:51:55.1217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uj6SVuIlQT+8avyjlN6Wm8IISnxWuXUgTdUzKKMHIIYASYsdcm0hUaQV6lIlFdauzCU+klwbfOGsH5fg9ouXZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3745
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Sunday, January 29, 2023 4:28 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH net, 1/2] net: mana: Fix hint value before free irq
>=20
> On Thu, Jan 26, 2023 at 01:04:44PM -0800, Haiyang Zhang wrote:
> > Need to clear affinity_hint before free_irq(), otherwise there is a
> > one-time warning and stack trace during module unloading.
>=20
> Please add this warning and stack trace to the commit message.

Will do.

Thanks,
- Haiyang
