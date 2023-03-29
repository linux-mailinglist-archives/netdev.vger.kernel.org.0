Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C4B6CD4D0
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjC2Iho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjC2Ihl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:37:41 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021026.outbound.protection.outlook.com [52.101.57.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F7A10E4;
        Wed, 29 Mar 2023 01:37:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMloopnpbrlzx6tIvgTXa4poj0079PPObfmYSRZrccMLKkC+ED3pYLaaUE5Vt9HJswzCieMkjF6GwGtz4QNyN6q2Yy59MHbcyx6hhbAO6VmRpC5Fm1Fs89QZmw14EXyTb7C/qwn+W6yTFU0WYPv9DAPLfh2bC7W4/ab7FUQe5iwqA1LM4Nli5zGHenbrm7kE+mlsIJPWGe5Xf8dQoY1fZ8oE/TiF6WbYUZZmTEf2g2F8olzJt0jyUJXtPZfnixHRtTEtgwIiXsBvxKyKEFUIhyGg+bpV9TE8rwcvRHKC0ot3Glk2XUNYAUk6AWZVBAgUslWWl8qbCuekPZ8rBI8+Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubL49LYY3CYuZenm4FRtFViIj3GpwcCkisWsjLwZ6+s=;
 b=V7eOziy9JtJHG5SUtLUMjUfCEQRH5O+Z8N9qRRL78v9TQ5Awh/C7SKV5Uz5OLq39R8K4TmTl8i1ep+3Gc+5C0YPgx1tFxvQceBBKZn84PNgu0LgCE9AAXNNINXa69QDfx6LI9paHti8Ra7uhP9zNEGzZXsk0nSeq7qknSqVaZvuWyknxtWy1F1yUFyV4DjXoXd2b+drMtoMzWZS/LFNmzAlc0ExJRR4GJh5yLDHnh11BwQe71POWds7I0mJhNpeA1PTVb9dy3fYGSaHNAz/4r+oM2bDPqop7j7Zu0P2HeJcIIExGr9ERUBqcTpJyP78OnS0fbfd+Gl4GyrnStnNUXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubL49LYY3CYuZenm4FRtFViIj3GpwcCkisWsjLwZ6+s=;
 b=ieQySeNtld6NYNEmPxD4XbIuxepA8uAXQN+dHLT8sVBGcMtTDPQNSmfIZO04dh2ddI/qPZVP3XXcW3qf5Wafn8K0uL4EZ1EmmeZYZ6SnEYIb7qlZOkivcU68T2Oj9AU513R6VbbgVs/CqjSMwOyioj1hoKxhDEvH2cFzK+TmlFQ=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by PH8PR21MB3927.namprd21.prod.outlook.com (2603:10b6:510:251::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.9; Wed, 29 Mar
 2023 08:37:21 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::2e52:d6aa:9a99:500a%5]) with mapi id 15.20.6277.010; Wed, 29 Mar 2023
 08:37:20 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
CC:     Saurabh Singh Sengar <ssengar@microsoft.com>,
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
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Long Li <longli@microsoft.com>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXTERNAL] [PATCH 1/6] PCI: hv: fix a race condition bug in
 hv_pci_query_relations()
Thread-Topic: [EXTERNAL] [PATCH 1/6] PCI: hv: fix a race condition bug in
 hv_pci_query_relations()
Thread-Index: AQHZYTE8ycJYvqlEuU6bxR9LLTVmZa8PqarwgAABRpCAAMcOgIAA++dw
Date:   Wed, 29 Mar 2023 08:37:20 +0000
Message-ID: <SA1PR21MB13359123DC327D00C2EF47E7BF899@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <SA1PR21MB133553326FBAD376DE9DB48ABF889@SA1PR21MB1335.namprd21.prod.outlook.com>
 <20230328172445.GA2951931@bhelgaas>
In-Reply-To: <20230328172445.GA2951931@bhelgaas>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f08b4990-b6f9-4486-a469-f8ba0684ac06;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-29T08:26:20Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|PH8PR21MB3927:EE_
x-ms-office365-filtering-correlation-id: 7527cc86-4685-4fa5-8d0e-08db3030cfc2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vWl04fSXDqts3oBo1j4ky5dVVffRwSWnIqNzJp+DdEEzbpSpcb5iWcfWqoRjgzENWyPLi46pTaQt6Q09S/DMPVQSFkpV52oyXlx2P4qDIdn6oG3p0MkNDGYDc/wuzCGlqAgXzEXLYBcszkmTsKO/C6bhw1iBFvhqQPVH++YBLvUA9WXMtbtJ7DyRHX/0B2hdlUgUbnr//fjUTmbje6ArrihJn0x6PgW1WILLDKDKgJTDG353rXPf6PmoTsehKbiKbB6Xm+lT6+dA4ediCqE+ntvQovOFwyxamhbxkw7ExPlJXX9PFvrCRi4uDgtKOq3Hej1tubJ4Ivtocn+iRgQTymF+Upgf1TkRWcdLZ689oppVlokxABYcBBLxLtdjpq1mrF8VI+NvUK8lHJud0jqxpyu7FPD5uqUan2YDHLgC5+u3bW4/Q80H8SVF0u82hR7pvnHuXj6DYw3JE+VowPsUHtDBbLGday1p/58XS9P91bGxG5eHEYb4hmPFQ/lqBZV5Ou+amjnBaVHjit3sNgMCuZUZ0qlO5hoZM+xmAPDDcR7yY9M33cZIwFB7gVSW+D+B13PdRtUwbqwuiAz55UVeYej5ALRkUtuMMRWHXD8NtymGzFO5eUkcisHzJu1hBfSBRlU7btO2M5KEqDoTDGTKrhdU7zGmbAcAiGFpjSGblAw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:cs;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199021)(26005)(82960400001)(122000001)(82950400001)(53546011)(9686003)(38100700002)(186003)(33656002)(8936002)(2906002)(5660300002)(7416002)(6506007)(52536014)(8990500004)(54906003)(38070700005)(10290500003)(478600001)(7696005)(316002)(71200400001)(86362001)(55016003)(4326008)(41300700001)(6916009)(76116006)(64756008)(66556008)(66476007)(66946007)(66446008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2D+F5MGAWEDrBp1zTdV2gEhBhgYcTtAWzsc1lNWn0q+OCr8Tqgd9H/hJPKbH?=
 =?us-ascii?Q?LWEG81GJEJDDYRF+7h+I8Du6mXeU4gVrbagl1Jz3y4GfzrOcZkEWpqAZUft6?=
 =?us-ascii?Q?7NqqtDxcZRexgGPT/Su9Um1LEQn0HsZRiSgOYrtDuViGEDnrxIpmAdjNSbtQ?=
 =?us-ascii?Q?Ew844UheZnYjpMlY8LwkodYTMh4DNX339ZZKye61epiuBQ6hXDlQ+CR5Mj90?=
 =?us-ascii?Q?4GFkXUA1dwehcw7m55wcO69SkGkYTYS5xgWEkzpEn+/ejz+68tU8W9yvVM/6?=
 =?us-ascii?Q?96TvSeRnfAyl0yt5cLqF/n9VF8jK3kpkZO5eJz0wo5C/uSfLcpi0gNlESTIK?=
 =?us-ascii?Q?rGbrEA5ULPt/shJKD8kzL7BoXM8b0o/S7mkLtnJguWfeZ8GLh5Lc4T8eoVqo?=
 =?us-ascii?Q?bZTsZYbugB2qWto8zzIh4y88Z8a+fLh4709zIPQA6d33EBU10YRuBTu6wJqR?=
 =?us-ascii?Q?lpBNfPr4rb9RtTXvL5xeQEiel6J4qJaU+h1G66LeBt631SBfrPwu4hLL39Wl?=
 =?us-ascii?Q?ODkXxEABWg6rAN1HVxS4gRw+3Jw1YRhPsOajzydGJME91SS/sc3OAZAsrqok?=
 =?us-ascii?Q?fNT8DTstkdPga5fCEC9kvaqpOzxXcxSu6Lz+9FGMeAXLSnj+CKKGNkheR+t2?=
 =?us-ascii?Q?/GaqekmNYVoNIYkzekgmLZq0R283Tdx8hESiZtpGovEUD6E8pNSg6bRVdNY0?=
 =?us-ascii?Q?UU7nO0Vqef9JA5E+C2oWHZA3SdNeF+SQAkGexf5iwIfDGpYGFyIU0sIwyj69?=
 =?us-ascii?Q?pgQbsjOq4TynBtnEQOReyjPLzeXXvQqTUA/ahT8ns1mnOl8IRCJ2OkKXCVW9?=
 =?us-ascii?Q?HYPHURx8w1IERW8g3OjQsp4eUCHSyU9TkT70f2FwkyYiZxlieNZQhaCWyWbZ?=
 =?us-ascii?Q?JZjZF9Bd8dvo6j91Jv9rB7BxNY86lkVWI+BYuogFRVZesMMzfamjGpdAaOBw?=
 =?us-ascii?Q?uWJuB/4YEg6pxCyfnErJFMRMjiRFS6uxBH+pzP/+hJYhowZP13IPuBQFl9Dh?=
 =?us-ascii?Q?r7sH/sgZhFXjQ57pALqu2XamGd9hGXqDXBw5X7kWhadcYC6qxXjt0cKF8OM8?=
 =?us-ascii?Q?j/UpDI4pRKUxuZlqtAjpwWVrlobyhbiGGjAoVdnmrGCkZOJ8vVzMj5azgzNb?=
 =?us-ascii?Q?vWv0cdmlUo7mYuPw6BLpU2MJSo/puVrtb/W+VsQeLDXkb7ZFarLm6bhEX3DT?=
 =?us-ascii?Q?Qkpsk3ek/rFGKkdI/uwhGhZzpng9ywgiXIuVeteOuQYu3YSEOMGSWkIEFhbl?=
 =?us-ascii?Q?SQlnLvYXbKaAwkLo3Gp6DMGQFVXq6yLxIOAPTJWoKQzFCGMfc5U8ihDeupTO?=
 =?us-ascii?Q?QNeR9pUEzrdC0jib4L9K94KYUBif+19tdThkxVkzxvmAh7lod68fNHY5RmY2?=
 =?us-ascii?Q?qNk3Ym11HrP6vU2S0WTklnGxUOn2ClWk2/AtNiYcvwu/6sSQKEfQIY2FbI6R?=
 =?us-ascii?Q?oATZNHgODd64iZ1QCBxiLTmjlD3kh12a9HdDLGdpCNSkuXms22YjTnVwlR2r?=
 =?us-ascii?Q?oER3HNGxvBIeRkSfjOPLcjOSkM4Y/gxau+p28NZkTRnQ6OHoGtIWIxpvcEnq?=
 =?us-ascii?Q?+Npk9oBcpiiu+dMB+rrCVQEXzveDuZocDKmlBALf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7527cc86-4685-4fa5-8d0e-08db3030cfc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 08:37:20.4891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HUTwfQD1NP9FjYvz2dYsEEbXTjN2b+k/WeKz5ANBttUR5HXB0BtAnjkmW21woffZRnsmiLCJdb0jzfGOqCO2pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR21MB3927
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Bjorn Helgaas <helgaas@kernel.org>
> Sent: Tuesday, March 28, 2023 10:25 AM
> To: Dexuan Cui <decui@microsoft.com>
> ...
> On Tue, Mar 28, 2023 at 05:38:59AM +0000, Dexuan Cui wrote:
> > > From: Saurabh Singh Sengar <ssengar@microsoft.com>
> > > Sent: Monday, March 27, 2023 10:29 PM
> > > > ...
> > > > ---
> >
> > Please note this special line "---".
> > Anything after the special line and before the line "diff --git" is dis=
carded
> > automaticaly by 'git' and 'patch'.
> >
> > > >  drivers/pci/controller/pci-hyperv.c | 13 +++++++++++++
> > > >  1 file changed, 13 insertions(+)
> > > >
> > > > @@ -3635,6 +3641,8 @@ static int hv_pci_probe(struct hv_device *hde=
v,
> > > >
> > > >  retry:
> > > >  	ret =3D hv_pci_query_relations(hdev);
> > > > +	printk("hv_pci_query_relations() exited\n");
> > >
> > > Can we use pr_* or the appropriate KERN_<LEVEL> in all the printk(s).
> >
> > This is not part of the real patch :-)
> > I just thought the debug code can help understand the issues
> > resolved by the patches.
> > I'll remove the debug code to avoid confusion if I need to post v2.
>=20
> I guess that means you *will* post a v2, right? =20

I guess I didn't make myself clear, sorry. The "debug code" is not
part of the real patch body -- if we run the "patch" program or "git am"
to apply the patches, the "debug code" is automatically dropped because
it's between the special "---" line and the real start of the patch body (i=
.e.
the "diff --git" line).=20

So far, IMO I don't have to post v2 because the patch body and the patch
description (except for the part that's automatically removed by 'patch'
and 'git') don't need any change.

> Or do you expect
> somebody else to remove the debug code?  If you do keep any debug or
> other logging, use pci_info() (or dev_info()) whenever possible.

As I explained above, 'patch' and 'git' automatically remove the part that
don't have to be in the git history.

>=20
> Also capitalize the subject line to match the others in the series.
>=20
> Bjorn

Thanks for catching this! If this is the only thing to be fixed, I hope the
PCI folks can help fix this when accepting the patch. If you think I should
post v2, please let me know.=20
