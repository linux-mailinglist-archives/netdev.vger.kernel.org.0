Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1C16C1813
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 16:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbjCTPUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 11:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbjCTPTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 11:19:42 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::700])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8272E0D5;
        Mon, 20 Mar 2023 08:14:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3sKR+cMiKaiU7Nd8M+b+XXIrGHkh9FPLtHmfkvFN4L5qTSJDqFq5mwBLjfof+9pUGSWu6+wkKkQvIVE0yPKDY+aGzeEduh4UQQRm4x5q+RO5KKb3kq5DgurQ6zklmF0k4sCk1DR+KmFbb/gOsibu27+bTfhAr5ZVpp4Hewp0s6iSLEyHHwBHnxPFBfAisUO/eQ0qfGeCfd9/IGmaDkXbHSsRhxtmVMdKqXjn4SzBdNc3FSWVVEFDhQghxYfM5Wn41X8JkcyI6V9xpdtRYYswhg+Lkre7bE0gOTGRZyLMXdsenO/JBOi/uEgUf5GN4hrD5aVGpGxA8fYQYtR7xwT5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jlken2dJYrAORtpdgfvjfCx9Urw8QuURDVHy4JtbLe4=;
 b=YSDvQdEHmqeimPk19S184QQt45j5jVmv1G4Qv3avwdAQNam7robx0TIm9JMsdYVDfs8pepUsXxL+FC5z85lyWqOOewurUcWjOlOm1H7BW/Cns9BbnBwYcRqgQ/qI/q9ComI08AxCCv7yO2jyVDVnakN7sU9VRwZ2pyaLk98AQfm8P3jZCuoQxwIB7hpIifr8kFI9DxNymKO84sdpkyKCK3O3sGn7oB9HU1w/KBBvXqpDt+CusxFkd8AE0HgyRXApDLRL9n58usV0ZXjPoaPPljzLqQE1a9h/9XgH6wuYQg4ROU8QV7N/Km3vjAVR4xekdfgpV/PApsXlCZotYPMWFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlken2dJYrAORtpdgfvjfCx9Urw8QuURDVHy4JtbLe4=;
 b=aQ8Al8yhGEnPR2NiNrZccbVe/N+EV40hvHKVLzvDTnbCY+Sa1BkLcScSsRYekzmqWJBTf7pb0NuiE2MwB3qZNLSqbO/aR3X1o+/Pt+/l1iVYs+5vsDNpY3RAhzmsRygd43x7417/p6fBsWgMWIhwu0X1cH1FAIjozCs9wzG/FG4=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by DM4PR21MB3538.namprd21.prod.outlook.com (2603:10b6:8:a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.2; Mon, 20 Mar
 2023 15:13:49 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::969d:2908:c2e1:e787]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::969d:2908:c2e1:e787%7]) with mapi id 15.20.6254.000; Mon, 20 Mar 2023
 15:13:45 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Francois Romieu <romieu@fr.zoreil.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: mana: Add support for jumbo frame
Thread-Topic: [PATCH net-next] net: mana: Add support for jumbo frame
Thread-Index: AQHZWqm9UOpmxqzZvUOZ7L83A2HDza8CtAUAgAAu18CAAKdXgIAAPNRg
Date:   Mon, 20 Mar 2023 15:13:45 +0000
Message-ID: <PH7PR21MB31162E14795F1FD030C1C2A7CA809@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1679261264-26375-1-git-send-email-haiyangz@microsoft.com>
 <20230319224642.GA239003@electric-eye.fr.zoreil.com>
 <PH7PR21MB31162F5F9E5C8C146760AF10CA809@PH7PR21MB3116.namprd21.prod.outlook.com>
 <20230320113317.GA290683@electric-eye.fr.zoreil.com>
In-Reply-To: <20230320113317.GA290683@electric-eye.fr.zoreil.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ba968960-c840-443a-aca0-e0de3519cd5f;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-20T15:10:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|DM4PR21MB3538:EE_
x-ms-office365-filtering-correlation-id: 234ec767-b956-4520-d098-08db2955b309
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zcx6L8KccaObAEUptnOn4u9qNnRu/GNj7E/vWmct0e5xdkWXQB95UXA3BnmQuDS84xe6LNWqp0BPyf8/XTFVFVZRRP+aDopQAnugQ0mjOOw5EMLQLhQtvkfrcmREyVMu0Jiv4U4q4q9L12bouroM1bxDPcQ+dkbLrv6OiAMhbPnQHRlCu4xMRinfp8Eo3VseOMErfZL9QQ5nL3YHHmaOTEh58SAtcaDJKIqOUAGu8XhWd+I1n5PDVCZ7/cW3oNoaklePEiZ17SvFkm1EyD8p/CEyvSIB+ZtnpvAI7FQ/2sSstWV7SldGrBFPca10MYZlhVW0CBJaynaRy+oKw9sCmh+knDbTn/fO4EyXQgxbsUBlCZMNW9w33tPFB8+BhwPk9FOOop3b+Ixs12LYTSqlGQB0ofDOsxMofm3LCDK2v3lOYtY3XJADl38RqmrtoDoWD9Ny6xsnGfc7Ohr7Ih//8nOVhD2/kUbwvjsbmo5vTgEDe6cUSeshKBSdQlK7bpQkUXb6QNoUq8nRMMLx1H/k79lyQm7zst6z5ogR48FdtbCaLrepHPq6BDoGhTLSqsWuFQJBC3v1Ob0b9Uh5HmalqyaEzESNMAPuBENDv0snhMZaMBB1bNB5rWhwMtknOAGW+xt6DuGSA+mLiA5M/aAXc6aQfgRR6Cdn6hMSmKfV6CUhQ0iGZMd9mLDmaJ32+xeGzmeL4rdf/zKyXLoh4c2x2l4HsX837tIAla/PwztNlbfMeLnLuB3FyzAbVtd0nPXr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199018)(4326008)(6916009)(76116006)(66946007)(66556008)(54906003)(8676002)(66476007)(66446008)(478600001)(64756008)(122000001)(316002)(82950400001)(82960400001)(2906002)(38100700002)(8990500004)(38070700005)(86362001)(8936002)(33656002)(52536014)(5660300002)(7416002)(55016003)(83380400001)(41300700001)(966005)(7696005)(186003)(26005)(6506007)(10290500003)(9686003)(71200400001)(53546011)(66899018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?t0OSSDnp034YBWUi0d3PBYttNDjqrd1foF3CLT9sby8+OkR5tfl3KVYx1BO8?=
 =?us-ascii?Q?dmWfm6KBBG6PdCssp6CpKmDk0ufabU+HndlR6oG+R4lmrzBaYS8itlUyzNHN?=
 =?us-ascii?Q?Y4AaDCD0gPMY7kF+cOleXxXWOdxu+Ho/W4W+rz2c8nikJ9gKZS4Jyzmu2GbF?=
 =?us-ascii?Q?469tdD1I4kRRQsC0JxWidLvNoOwMIq/sgasLaqwQUc0leJIJOSs+/O5JujQ9?=
 =?us-ascii?Q?DRJe/e1jrZiiOxItTiN0x9DpusG2hD+vZZnUmJUyJj9OxLi+NmyX14r5OG5h?=
 =?us-ascii?Q?kbARuvqm96liqX9cERY5gjyJQmjx7UiiHHAdpWYWmhKbNH44EMqiqHjrdMLR?=
 =?us-ascii?Q?S2lwnKx6/5j3fsp4Ut/kuBq2QfBFsyVHiQMxSwtcHyqaQYZ10CnYRatIDO9i?=
 =?us-ascii?Q?BPqCjgjruiODb7UeJT/Bq3zL1sLup0Zz7MOGq6zQycPHHaX9evYkSdP9cg7l?=
 =?us-ascii?Q?0dR7d2GdmdBrVaaC7KRT6pI++ab7KYjzgTr8TfmWga4yqgknWTmhT17TGoxk?=
 =?us-ascii?Q?1Ao6rIqh7D+fWTpVFkVhnasSxau8RlKrFBzN65jeC+SBWF2nL8/NKsh2kiKp?=
 =?us-ascii?Q?KXUTtgihGGhIGl96GufBtRmqJOFNNOE6ZbhM8m4rUKV5Ib/897jRmKsNies6?=
 =?us-ascii?Q?/G38pKX2U0gCrfWBtBGKrFo4OSpEs6Xspmr1idSE7xQ4zPhLQrx2lAIMvVoI?=
 =?us-ascii?Q?fqWG4ZzJNrF6edlUV+6SLgbB3oWqBaTIahoRTJWrLfXbCEzu2Piy219klA1A?=
 =?us-ascii?Q?JFe4HN2sqZ73i/rxjPXKGxdP/NqTV34PRa5aR6ZcdFL9jL5F9C5dI2OWDcAX?=
 =?us-ascii?Q?IfCLTDXjmIEp+jGPw267IdpphyxTgBE/mEZHqk/lsIjc3l+UL1elxpGFp4FR?=
 =?us-ascii?Q?HSnrKTj+D4luxfRmQGbvOOhdpKYWvZnJvtpH2LyUtFh7rba57c4DTNODSg9P?=
 =?us-ascii?Q?5eq292pNXIG2DPFs+csRGByaaqaBlFwj9anWTtovtTnixdjc/UFzcjWZUuEz?=
 =?us-ascii?Q?D4+jMIanuCiczd+WRP2GYQo+THHzc4NJDsA861f6IsbbSzQRzYSlmbOT7Whn?=
 =?us-ascii?Q?Qy70aFwrt8KF7O0E1j65sPkbjnfP8sZAjC3nT5zsA7tUbiqQs2S3zhqwWN5/?=
 =?us-ascii?Q?ftRvLTTqDhUVBsqLjpVTthLp+mBNGR+w3kPkW/wR/V6iRzDBAEa1yHFEqk7N?=
 =?us-ascii?Q?5WX9ZlF/iso/kbGeHN34ZtVmtSUjTu1eWBm5qWA1HZ5r/19cUk+LYKWoMFZm?=
 =?us-ascii?Q?NNk1itkvVyH75Vr9fd+/ck9g756Z/PgCu3gfar+3mhi5I3eBjh+ygT+vP1dB?=
 =?us-ascii?Q?1gA2Z0vXhYc6RtTCuQyQHEOLa6bjP+zvHV9qhFi9aD2yhpsH4kutJCy4RUic?=
 =?us-ascii?Q?xLSyOfG/U5/Zd3Xlo2gVGPV76lSlg86UGW1eFfTeDwDEtOevqg3DxWCl0BWM?=
 =?us-ascii?Q?WSuLsq922N72sjXiqaiAh7BGWbr1UOuYZeiFsgk32+q3kZZDNQ0wJZ0OgIUy?=
 =?us-ascii?Q?n9OOkIjz8xo88BHGU4YfsF8mkTSK8IlvcXVvu8/jOfUygaP0ytROOWIi0tu6?=
 =?us-ascii?Q?elgECLlO9DdINPlyQvPxc6uy+ZL2F3HfBBwVFdb/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 234ec767-b956-4520-d098-08db2955b309
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 15:13:45.5533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L6m7prn8p9FOglmDVhpD2Ma0V1YGmsQ6nGQpcSuhCL9HvEHPOfuzCAfjkTe1tSnCuOPMUTqGfSXL+NCIU5qvDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3538
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Francois Romieu <romieu@fr.zoreil.com>
> Sent: Monday, March 20, 2023 7:33 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; wei.liu@kernel.org; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; leon@kernel.org; Long Li
> <longli@microsoft.com>; ssengar@linux.microsoft.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] net: mana: Add support for jumbo frame
>=20
> [You don't often get email from romieu@fr.zoreil.com. Learn why this is
> important at https://aka.ms/LearnAboutSenderIdentification ]
>=20
> Haiyang Zhang <haiyangz@microsoft.com> :
> > > From: Francois Romieu <romieu@fr.zoreil.com>
> [...]
> > > I do not see where the driver could depend on the MTU. Even if it fai=
ls,
> > > a single call to mana_change_mtu should thus never wreck the old work=
ing
> > > state/configuration.
> > >
> > > Stated differently, the detach/attach implementation is simple but
> > > it makes the driver less reliable than it could be.
> > >
> > > No ?
> >
> > No, it doesn't make the driver less reliable. To safely remove and real=
locate
> > DMA buffers with different size, we have to stop the traffic. So,
> mana_detach()
> > is called. We also call mana_detach() in mana_close(). So the process i=
n
> > mana_change_mtu() is no more risky than ifdown/ifup of the NIC.
> >
> > In some rare cases, if the system memory is running really low, the big=
ger
> > buffer allocation may fail, so we re-try with the previous MTU. I don't=
 expect
> > it to fail again. But we still check & log the error code for completen=
ess and
> > debugging.
>=20
> In a ideal world, I would expect change_mtu() to allocate the new resourc=
es,
> bail out if some allocation fails, stop the traffic, swap the old and new
> resources, then restart the traffic and release the old resources.
> This way the device is never left in a failed state.

Thanks for the idea -- I will look into that. But the real world implementa=
tion may
be less than ideal :)

- Haiyang

