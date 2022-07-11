Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C37356D262
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiGKBJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiGKBJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:09:13 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastus2azon11021018.outbound.protection.outlook.com [52.101.57.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730159FCC;
        Sun, 10 Jul 2022 18:09:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1r2lxDcztrk+xPkA9HViX5jlpWXbIWqvboRyJJIj4cWBt8DAmHbPixgJfVbOt7M7HZRqqP8uqgPQd1ncOObu1wVs88jacifbz0DR+tSBAEnOxEnV8TsAfLWcpy759VQ3bKX6DUtBxmz+DBGJOpU6NprERGQnEkn8cFc29wz77R+JyQo7mRBgUMn61DcZV0x25R1XZJzMp7Pn6XXyC1z35j7wO+NrLI1dTjKevsEWLKOJZwd3jfSVfbS5y010vkp85tQLDpsdJ13QjVKuZ7f+eENN1pl7RAo/XMmUoHXLHV+eYrrH0PuM00SJx+F83c4Fyaqj34BxtR8KVGmz2AEZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FFj7/CLokHL/vPL1mi+hCQwamh2czPaVy+OMNcmn3Yc=;
 b=M+BJaCeJ57TVBRL64hV+69HM7/XXsePVIgBQPvGqq8os2DkmVwKula/LOXlCITDf03on+kAQLDeaRl7IDBtsgXWcWIx5BvyaRQjvtrBAePmQF6X1B4To2T7o0WvCkFttmJnQMBVsFButk1qBRQlRar5tNcW0m0FornslQNs/TpwdOhgiA/CUamDqdSt8SB3W0MpMjpxPtSHoILn/rl2ZyjsGLWVRmfEYSwmi7tpBPwcP6PbJKv4ZhX82+HZowYFLNLlFA2HykgEX1UwpsTxPbmEktYlJj9NaTTMdfdrY1mluZvFcAIEpVwyYKYm36DZtCHm2JCe1pGjlj7SyoB3XSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FFj7/CLokHL/vPL1mi+hCQwamh2czPaVy+OMNcmn3Yc=;
 b=cKmusxKFOe37EGKfEHZaRVOGUHzHtgB8xWCpx0nTeN3Kzm2J2fRBzHOeCTJgtu+14fmva2tY0N6pjr5n71K0rZebxXWpXF3D0oq0jT5hkwcyQRClkdzFHerBOWOoiUM38BUHTutrxUtHEmU3z/lkhmKiazKcOaoz+2pl7BK5ToU=
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 (2603:10b6:805:107::9) by SJ1PR21MB3673.namprd21.prod.outlook.com
 (2603:10b6:a03:453::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.11; Mon, 11 Jul
 2022 01:09:09 +0000
Received: from SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0]) by SN6PR2101MB1327.namprd21.prod.outlook.com
 ([fe80::59ea:cdde:5229:d4f0%7]) with mapi id 15.20.5458.003; Mon, 11 Jul 2022
 01:09:09 +0000
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
Subject: RE: [Patch v4 02/12] net: mana: Record the physical address for
 doorbell page region
Thread-Topic: [Patch v4 02/12] net: mana: Record the physical address for
 doorbell page region
Thread-Index: AQHYgSXYmoIR08bCCUe2eqZa1LtM2K12xzdg
Date:   Mon, 11 Jul 2022 01:09:09 +0000
Message-ID: <SN6PR2101MB1327D3AD23CBAF5EE7C3EF6CBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-3-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1655345240-26411-3-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=fabce1e7-28b6-4d69-8c37-27f1171fe2d0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-07-09T22:39:31Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e513ab0-092e-479e-0ed7-08da62d9f570
x-ms-traffictypediagnostic: SJ1PR21MB3673:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zsdbce/n5LH501wbFb8nLRGGQSXHn+LNghOzouGTrOsOsXpXGUtdeSCvsXu9QqMlyfTnL1uxmMLBAsZ4uccLakYeeP8VMmngf9d8RA2I1RoLWTEgsJ9eRX39MUZlVcWfIyAlWkd59N3rQ/y4baub8ZBaZzErbpZdUhLiVZ0ta2KHXsNgW/+MfceIn9U1ufKfSSDekeB+wW6N3vYZV8K+NLCfMaM3pSzshTr2FiOuXJqcB3wVR0oqxfF/FyVlpvtrAOn28RMjEvjbdOYpwp7BJeawEKt48jPSZ2iMOjmwxve+oX3LzW8YMaFjQHnU9ft9PlB/A4adcst3c6duFgvJWxYOk1TwHqHA6oz6ULKG83SFlMoCtmTBUZREpHqEMWlx1j0Yka8vZsFegbB2tEBJcwOLdNNuPZJSHUupRCgcQ5v4VV0aikRzn52dT34zIz0sOF5Jf9xTacj06OHlPuj5oCITExMGUZbjovhnOjX4IhSR04xDOsnp14C+0Amv+2Pcf/NZ75plhDJQEaUvMGwqp9yYrEy5dHDYaRA9QaJWoIe/dRjuPl/JUXeDIX9Lko3x+E7C/o8sGyCZOFk6IhDbFW0rr/vB2FaiUJv8dSfMx6t3YouU2EddsD9NZQ1uWwHe8mtH8MgJnbUSi8CZrDnr/04Jy8cdBcv3AeCgdUozE4f1AuhXj7h+4MaZjMytrcWy3cWdfHdHv9BixUBTV7muFzsRQ4Zcd+1HzB+WxuVHTR9KeJyMCCxyaVYZwsoyKHBucqRWB5QB32e/BmFHGvoPUnd4ByEHzbztT09VWQGLApbbEDG3hrOfmD0it9ImRZBg32kVxu3KHnI5r8U24JggOY3mDj8GDc+TGe0SvWL3c0vJTgafS3dnxbbVTyVPyYnz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1327.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199009)(4744005)(5660300002)(66476007)(82960400001)(52536014)(76116006)(110136005)(7416002)(316002)(8676002)(64756008)(4326008)(66556008)(10290500003)(6636002)(38100700002)(71200400001)(8936002)(66946007)(478600001)(66446008)(55016003)(54906003)(186003)(2906002)(86362001)(7696005)(122000001)(33656002)(38070700005)(921005)(26005)(82950400001)(6506007)(41300700001)(8990500004)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PYo6pQRHYsRmjgMXkMJxctnXAOP5gvGTMk8gggIlzxrT3GSqvsMSBu9eF0i+?=
 =?us-ascii?Q?BnpKT2OdhdDnZbGkLqEnqY6puUqsN/3glAxnkyWbf+6+fKMYbBMtZN5BNjSD?=
 =?us-ascii?Q?PHZ3/HBu/2Tr9bP+KUVLSshYeeu4ABH5+WRmOsL7JDKF4LR4zHvf3Sl/sXZI?=
 =?us-ascii?Q?w1nSeEq14lstOpZDy7w/6xsYQHOd5EzcU52AjhlREd6DpoTZpzZrMWM4TCyD?=
 =?us-ascii?Q?AiBlmn7Eunqx7fVLNFlzaFp4d4i1JBZtaWClTJpZR9lUyDl3GNz8EPH53ieL?=
 =?us-ascii?Q?lqf8rtcIE8LvF++tUSe08LZG5NiC0lwSoGqJGoSpxcvGJoUYW/wTwjJy+wz0?=
 =?us-ascii?Q?LIVuF17bf57ak2rz87v4A6mrzTcW/1LhaWfzZhuGL4LOf6Gp4IgbFRdp0t87?=
 =?us-ascii?Q?O5oH68W9bAjVdDXdQ4R1IlB2UIRr28ZJAvJdhjDrfaR0DKYvv1N94vB8720G?=
 =?us-ascii?Q?n55kXISCZIMvg6CjfvQqm4Eo2KEQLw8/c27fOCwVMiExn8PCTb/TOLWHpTPJ?=
 =?us-ascii?Q?/9BaeSbq4x4uPthPJBur63nW/m5S0futNCbv90GEq3zkqROp+uOmsFgRL7oW?=
 =?us-ascii?Q?Ec/g7iZ/+tqHIIjDmpC3HC7BOKQ+6kD3qJJQghCw2SIYd++IpPay6bQ2hpxm?=
 =?us-ascii?Q?rBMgoytXIPenEOX8Xp2b+hE5ML7KvApjHZkHoOPiRSqTlio36siG9Ek7UrTM?=
 =?us-ascii?Q?byJ0r6xjigwrv7BW0OUl0HOUMZkmUh13sFGSGdWamnoNd0FqRCyqICGw/K/a?=
 =?us-ascii?Q?Oa7/P4SR4kmrQ7wrXi5yJ5BAlAl8hO7CGEThhwOs26GvoL+cYJzzq7caIvSD?=
 =?us-ascii?Q?0TS4x7lkt63flULdFQhBrd1jO72aUgN7rFhDp3EBUGV/dnstfW85KS534dY7?=
 =?us-ascii?Q?AuSNNwrhov+4rP/7nWF1Nsf/Gw16ZmP08YOQ14YZveM7LUkUTTgC2gTYB83h?=
 =?us-ascii?Q?FFKUFHWt/t+dD2QX0ce9K+3A1AffKVpzFMNckijmoX/CdlBc3Tv5dcTj5ELb?=
 =?us-ascii?Q?xEtNFnYn9wUQ5DWo7AwRlbIk+QDEOvnK0FymB9uDMhZvGiQz+15dUFI+gnYL?=
 =?us-ascii?Q?SEzmRTe5HyCMzwi5shYMzpd67VRARQVvIsbtERoksKJe7XgxpvBx41qoSptQ?=
 =?us-ascii?Q?a9ISpKAuclII03NB9ypbX2mWjkYBZPtMPmEZdX1OZHpRjxa5xa4Uj4Ikfg50?=
 =?us-ascii?Q?ZS8T4eaHL7n59dis+oHhUz2el//N5CpbQniFN/CJpWGZRG0CDjmgaSbf4BYE?=
 =?us-ascii?Q?9NFeTKonthXUOD3WylDS5AzZfB9sgaWDi+sPgRmRQghaXWmniT3sq0feWL7i?=
 =?us-ascii?Q?dGVaH6QqwFIZp48YAGr/dyLmLyK1ZreyV0e6aA2iD0spRB/UNdnXCy9j4AtT?=
 =?us-ascii?Q?5lY9mpEpYWgzfYPH8kHAj40Y3lr4bVMKXTjOSVZUwr3LfTZSghVcA0spPtD2?=
 =?us-ascii?Q?VfQZLpg/iq4tLryMrbN4bUfWf/anT2xLgNhz385m9O+yfxikIwKmjI//TR8k?=
 =?us-ascii?Q?P/avFzeCYXBlc9hdOzosW7nmXo3a4oM9twNAWu3uf/sd6QhhJebZfZ7LFuTi?=
 =?us-ascii?Q?BBLHEebvRsI4fguMuSV54ULMhF0A15nU69xNU4qU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1327.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e513ab0-092e-479e-0ed7-08da62d9f570
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 01:09:09.1376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RjFch10xuvJV6QdkPOjtQvjLRI7c2kHh1xfnWwuxMKlj9k11yWBVyAt6sno848lqcAAh0TLJ3AC8DPgdhpxt1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3673
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
>=20
> For supporting RDMA device with multiple user contexts with their
> individual doorbell pages, record the start address of doorbell page
> region for use by the RDMA driver to allocate user context doorbell IDs.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Reviewed-by: Dexuan Cui <decui@microsoft.com>
