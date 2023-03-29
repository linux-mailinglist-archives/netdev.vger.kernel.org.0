Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD6F6CEFE9
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjC2QyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjC2QyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:54:06 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2107.outbound.protection.outlook.com [40.107.102.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDE91A8;
        Wed, 29 Mar 2023 09:54:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jIpTwWk8pPWx0JrrFlNHtHBBEQnPVll3NPKRh7FOyvhqhlGr2zsNUHpZM9rpVXas3+l1SCTnze1IKbmkUtWFt+MHn8flgeC5Rr4lFW3XuZyauoqNu+6n4XpiqDpwtFiu1jKedGbL/5zXvl6s1C4P5w9tMPWOtsTZ+/Pgs2CAmpyVR4Blz9LGiJliUc0pf79DOBOrbuwNkkiF3BQXaYD0CC2xvbx9k5fGhxAoB3l7beya0a0MohgKMsfmjkZAJRFbQ8rnCrf5c9InCBj5nZ6dQSVFFePwXGXvdg00V49iKgT0mNXkMGCVF/mr6ZdyNt6uK7TcDD2FzraBLAtmxjC6Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0k7M6vnHlwIFIySiZ2DSdiUJ+RU1KTyyjs31IOZQH0=;
 b=WZoIZT+Z0QJ/Z/GqdU8yUlWC9GTfy/cKPG8XUm4V/Av6aBbK9pQ3C2p2kY8Ntk62j4HlFDHVr3y1r0sKHYb2XiES3/s/GhZBKFVAShuFbBTRkq8eaJnF1bZFxt8Hc8O268A9ttHsJnCAjWnAqenldQgGRL5b3d5Tg8+//Iu57WarTx5PB+GPxod7CjwvJvGGTqYKJZ9vFjN6CgyTTZnHFH86cX29etuKWVtGxA1mL8U+Bf1hY4LMe3WEdNXSOnegRp547CUD43MGOGheybaVGlVn04jLwZeKbtjDgM4UJ4w4wW/tYFuhfZoGPHZzzoz7RWbZlphrrT837SBhoLQrJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0k7M6vnHlwIFIySiZ2DSdiUJ+RU1KTyyjs31IOZQH0=;
 b=SLjQq4ixF1pufDIEvA9OB5vwNSrZ8KoSERTO2iODwP73t4fxU/TGJ89L11jXSBXgZK3UiUA2CgnTn8Uh1vxNSoE2nfMhZ9CMXGFsxPVwh36VOUcjvmg/a0htI/gGQitxzNVxbeCgtLBm8b0aFazsOhbwqW6hYL+GoytEDNWTrew=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by CYYPR21MB4022.namprd21.prod.outlook.com (2603:10b6:930:bb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.6; Wed, 29 Mar
 2023 16:54:02 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a%5]) with mapi id 15.20.6277.010; Wed, 29 Mar 2023
 16:54:02 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jake Oshins <jakeo@microsoft.com>,
        "kuba@kernel.org" <kuba@kernel.org>, "kw@linux.com" <kw@linux.com>,
        KY Srinivasan <kys@microsoft.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Long Li <longli@microsoft.com>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 5/6] PCI: hv: Add a per-bus mutex state_lock
Thread-Topic: [PATCH 5/6] PCI: hv: Add a per-bus mutex state_lock
Thread-Index: AQHZYTE1pEQ7gkU7iEqSar775+Y63q8R92VwgAAD0uA=
Date:   Wed, 29 Mar 2023 16:54:02 +0000
Message-ID: <SA1PR21MB1335F4BFD506DC8486D30CCCBF899@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230328045122.25850-1-decui@microsoft.com>
 <20230328045122.25850-6-decui@microsoft.com>
 <BYAPR21MB1688790C39FEC18826449AFDD7899@BYAPR21MB1688.namprd21.prod.outlook.com>
In-Reply-To: <BYAPR21MB1688790C39FEC18826449AFDD7899@BYAPR21MB1688.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d326267c-94e2-4182-a6ec-05deec9dfec8;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-29T16:38:28Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|CYYPR21MB4022:EE_
x-ms-office365-filtering-correlation-id: 2eb34118-a597-41b0-f3b5-08db30763300
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f+vYEk2rEU/B/f7sWCSMB8yPE2i5taKbD6OHXnA7W5MmHrOuqd5l2pNZzQqyXsJxWlLj32AONpW7wXG4KWnhhnfBkZq3X7FU4Sk3oW8VOPIo2QlBRLdt82UxTnF5sbPMlAxbDE2nq2bTNAlX468OBa3LCYIBozhSHVLD0vhbbnfN49h5OjVKYCbUmJtI7F2xhVJGQQqAwncGCAfu7znYSQn+IC1IlTixxRJte1JEImtId/ThTx1huKbhsytV4mOoadfxUV0LiA6HW6wKVG1q/b2pW7izphte9a6hJnT2jsKbVVGtxfr3BAw5ZbDFBGovO6VYd+g6Iy4I0l9+sEmJFHscD7Jy2XSa2KxdP+VrQeGk+OK6QURIQxXoexWslZ/P497f2WTmi1VuKiZ8s8V5Uxnvb0FVXjDMUJTnm2cOu+RjiFBe+NiEu0T3JHtnFBkH0BfuBcVfwMoQ0kqZQSD8sV92EXdrnnLO/1ai7HBq/bgnRHpLQS7IOHGuG6GwxNX65x0Dd3LpBnB79kLNzytaRXPOOvhUDkbCOcHcX5M+sa/27r2/+z0M8lyd2lgiplNn1DAUgNOLWPVRtRWp1xSIVAgq9cg1MCGi1lzo1fjHQR8YZGkHGLumDZGyQW7hH/DQN3P7x2855wxG/zjZf+P6FqRB5tINcKKO40TPzhPiZo/05VSvAId8x4dvKo+4wv5z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199021)(478600001)(38070700005)(10290500003)(83380400001)(2906002)(71200400001)(33656002)(55016003)(7696005)(38100700002)(8990500004)(7416002)(4744005)(6506007)(921005)(5660300002)(9686003)(54906003)(8936002)(52536014)(110136005)(786003)(316002)(82950400001)(122000001)(82960400001)(86362001)(186003)(26005)(41300700001)(66476007)(4326008)(66946007)(66446008)(8676002)(64756008)(76116006)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YoSwZ8s+R96rjDTkEXgK2O7t5QmtP5+J/RfbZfVVt3e1pWdNMdlKMbmsdbqR?=
 =?us-ascii?Q?1ooweJ77HTeZTSq1AKHRASdd/CLl7wVJwaa8Owku5oKANYakaRl+9X8n/We1?=
 =?us-ascii?Q?g/GyVO9wKU/TkSLU+anteJLm3nqHtfueRCE/LPEF5ftxSs3IgLDzHdTSIs03?=
 =?us-ascii?Q?2PZH0Vk9+KkVR0pJvLG1EbYh2O3r6u4pb+CFPRBUYk8BV9ib4LKULPxoZKZT?=
 =?us-ascii?Q?WKBwsoGSHMQiuOBUiWd/3LDEW1YsD7zggEK7vTauEhXxY+xMzzATVZm2zdCN?=
 =?us-ascii?Q?ekAyKaitTBqvWcIGXDiIiFvS9iCcjkiFbSmBEVj1L2GSXDt3Mlfsk92x7+IM?=
 =?us-ascii?Q?3b18bob4MGQ08u1/lVYbQ3D0ITnngn6dRSnoKxzsFkiFALfz2nzhZ/2zEOHK?=
 =?us-ascii?Q?I3JxX6tkBqz1gbsbnumqK8s1X4XR10alG9rhGTngRCUlBCX3QU1Q+bSyzHXu?=
 =?us-ascii?Q?829z94VBhQ3q0d7nkk/undVfyLfp0A0V5GcimJfpfsQcAMDKOG5wfiHZOd6l?=
 =?us-ascii?Q?WYnIhCfcLWj7Yfv+9DtnNEGJ4+ugtCdK6jR9zv7zsJvw4WnnoONq1G1DzPXK?=
 =?us-ascii?Q?dc1hhps9dbdzuHBGExBPR/UwzkaUGtB/aAks1nCLXH7rymw3vStXWjOVFqqV?=
 =?us-ascii?Q?CIlXaLq9bXk482PqAJCAKrg2byNZ24Tcs2+Js6YtMNozaruUN1BDljxULCnQ?=
 =?us-ascii?Q?GbBIUNmIhyNm1nUGT3a6JvAEdXJi6BLlsk/XrIZ/jLpe1eo+aCMH2WbztQnO?=
 =?us-ascii?Q?Zja3VZiHBkrwa++3eA2wiw9pRe4A3hMiFZ+EZjwbxwhAn3dUg5lw8AJmCZkD?=
 =?us-ascii?Q?N/phA4VsxaVzlilP/jjPp15jHA6YWXRxvuYUbu4aqW0we8wdoLu9QMEyT+gr?=
 =?us-ascii?Q?RqbaVovan5Pfd6amejXiItELk58P4sWu4wNmhfGucUn/zlf6CnPcZBJA7FSZ?=
 =?us-ascii?Q?2uY2022GickqzEFzSBmSO48xNMOrXK88xM63QZUrmt0ZzvTTREnhwZkzt+wn?=
 =?us-ascii?Q?M5i8HTlQyBSxs+Ay0ot4YgASs64/mHhwSUWh3c55dmdWYBysbhnRerenw9E2?=
 =?us-ascii?Q?Smq2/aOjpVqCtb9ktz0JoEItlW4BlpdyRnDbiAEtP4+XQ4FIw/qEa7hj5uRD?=
 =?us-ascii?Q?VhZv25sITzvFxmeC5z1HFTVgu577VUTsEZwPp+sREA7hS8RYAtB6xw/wzoY9?=
 =?us-ascii?Q?KqnCIMfXJcSEw8sB0erLs14cAJOqBK2hST+wKcoc4sY/RVPXzsX4Y1omZssn?=
 =?us-ascii?Q?Gz0kP9ONd0vgQVpL16eQilu6rqeB4eZukE/LbQAdM7pr9nep7x3e3P0RxfjY?=
 =?us-ascii?Q?pwBEpckI75XAaEXp4pQ4fOowcmbE6ZtYvtnC59QGseQaGq5az6DWHBNKchox?=
 =?us-ascii?Q?eulgzPWZGbS/WPuQO9QoW0MDWOxWTsMt448HvQggMjStggATOEfQPZvZaQfw?=
 =?us-ascii?Q?s68E14uLBrhHT0TMVan/5hJMGzHHung8Un9+bJmWGa7VqkTVL6F3fvdFiBuy?=
 =?us-ascii?Q?g7oHvKoUXDlOuY33hsG0DlIQmPY83bKvpHFg1oyCU6LR/27tcYQRLYgHy/BC?=
 =?us-ascii?Q?N+/973MZKn2HPaFWa6QoGnjImGIj7LVfXdS4fiq+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb34118-a597-41b0-f3b5-08db30763300
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 16:54:02.2561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Mm6fbIfAYxxjhvPk6AxVp1VT1tLjK+RIE3exnQdVB2B/ieI3lEm4DVOaBpfxHMXjZaVKG6+gZpLmUCAfa4/xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR21MB4022
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Sent: Wednesday, March 29, 2023 9:42 AM
>  ...
> From: Dexuan Cui <decui@microsoft.com> Sent: Monday, March 27, 2023 9:51
> PM
> >
>=20
> [snip]
>=20
> > @@ -3945,20 +3962,26 @@ static int hv_pci_resume(struct hv_device
> *hdev)
> >  	if (ret)
> >  		goto out;
> >
> > +	mutex_lock(&hbus->state_lock);
> > +
> >  	ret =3D hv_pci_enter_d0(hdev);
> >  	if (ret)
> >  		goto out;
>=20
> Shouldn't this be goto release_state_lock?

Hmm, somehow I missed this. Will fix this in v2.
