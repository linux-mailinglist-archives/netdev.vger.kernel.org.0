Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71DA509357
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 01:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383070AbiDTXKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 19:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235668AbiDTXKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 19:10:05 -0400
Received: from na01-obe.outbound.protection.outlook.com (unknown [52.101.57.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F081E3EF;
        Wed, 20 Apr 2022 16:07:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zf5v/PKYZggwLw7XWdRaNnX4otuiHrP4H/WFek74cKnWA0Lf/pRP355ho7jFZDcrI8u9gaVuWPpxG/lJzypWUmhYohewX7hmlGE912v4rK+SlYpUWsAhEJyUjPR/O7lFvAzSeCDHnnejvoOaiT6u6mNjrbBWu6bwdKO8SC/tPKDAduNYPzUTsPbYfh53caN2PT0utLQSUpOOYkgAdwxUXzkao1LUqxxeFFs1T7aU3VyhMSR90OFCP8N5EVDbXZNLJe/xH8NrChJY+p8jxzSULBB8gRPA+P3KdqW1//DhNjhmfaeJ/0UTbz1j/SGeHbDv2HvaVhZ+4Kq6WnvqB7skXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNEYDDK4Vafr+Jqf0PaMDg7tROjZNvJ/mR1J2rj+654=;
 b=hClXFDA/hQoWsj0MdPR7YssaiSQzZpwbXbKjVNiguQX/A9QEt5x4FEsKoWKXMwUVsXkkrIY15OGgyPgLjZjQKwTM9es4/VRQcjmx3y4I74zR4Knv4Nsa3j2yuO6qFn0U1L7/JkzvgW4R7ATfNoFbFVbBdm1/mMUxEeN2Dt9UujY5uu9DbZGCwOxXsbdS5WVh7MVQIqsZqOUQ66Z+/s5l086rPm0nYDHKErkFUx02tS99GPqY0L44a/6NprnZ6A00lmH4/XEKs5CKtSpOn5Nd1fEAB1LyCWI46orEYouLlSeVe4Vehhd07Wp5i90x0WMIJCyzpoJhdLOfDC+EmQL9bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNEYDDK4Vafr+Jqf0PaMDg7tROjZNvJ/mR1J2rj+654=;
 b=iHoCcjMkxGxGEVGlATxn2f99q54EIaC6lDsJIlGAJzkmmdsJZFW59I2pAvxVaJ+ujZPq0WATKzJRKgz5TwCga3Uu3i6pmpx19QVd30qJTwfAS9ol5oprxaAe8UWeaCJyyN6gQ07xtRFp9lKCh1aVn+K3Q/8i18mF/4QU15KNk0w=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by DM5PR21MB0634.namprd21.prod.outlook.com (2603:10b6:3:127::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.6; Wed, 20 Apr
 2022 23:07:15 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df%5]) with mapi id 15.20.5206.006; Wed, 20 Apr 2022
 23:07:14 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/5] hv_sock: Check hv_pkt_iter_first_raw()'s return value
Thread-Topic: [PATCH 1/5] hv_sock: Check hv_pkt_iter_first_raw()'s return
 value
Thread-Index: AQHYVPJOg6b8Qh7Hl0ach3tCpZo5hqz5bKJQ
Date:   Wed, 20 Apr 2022 23:07:14 +0000
Message-ID: <PH0PR21MB30252A0248FC9E5BFF687387D7F59@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220420200720.434717-1-parri.andrea@gmail.com>
 <20220420200720.434717-2-parri.andrea@gmail.com>
In-Reply-To: <20220420200720.434717-2-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e9a66bf9-4a31-4de8-8a69-3d46965b78f7;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-20T23:06:27Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9c6db6a-1916-46d5-c6fc-08da2322823f
x-ms-traffictypediagnostic: DM5PR21MB0634:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <DM5PR21MB0634B6D752ABBB9F21F72407D7F59@DM5PR21MB0634.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HxMXpXKVRaAl+jc0xyccgJxukh4Wf0q9eNzlcufREkpVM2qn/1xPFDIsCVWP7FENw6iY4cVFU+jVw5fj+fATPWPefuGC0My9xDFeRljK3TJNyxXioCJ70eF5LN0rY85QyBKE4HdbetWkINeBtAz167iw7UntVMazLpUb4Cd8ZUADzJRviR/g24G58OgLaYJGulabivdtAx0eXMFKCGMCjQiSypX6Vg8meIeMGVLwMo0bDpSRzWxPSlun+LGogi1LSZmhwYnoOrg4rd8jUyHzZswRPgSSmy5qOsStycoST7CvlAU92Zt4HO1/StGwZWT3U82Qrec0SCztDnVnoYnE/QEw/8qUp4Kvo9R0k9Vs5aEgLidtbn54qUlkj4F+BpJMyWCEqdTZ4Eb+KaYOd1DYsaDv+WHFdhyKZN4vL40tg1hfmfws6KKcKmFDeGRyLmg5c/Dvwo8JsbccbFBgny4TggMSWPzOS3UUGwM9FxeypLICyjhx7iTR/Nm8KNrystqrc1Oy7quxDcVaZiAfmsTH16CoaTFwP7rhUKaryeTO6qPbdlI9bxpLkADWspc3Yva0QC59QXFZiJDAZYnTXdJG/z9XO3yCAFBCtySHE7bhCb8k4q39GKeUZ67GonpCn7EpGaHlDK9Ae1pIZsF49ztPwuGnKHxM+/iGoaxMawUXNT3Ckak7P3Cxxj7keOkw8IJ7S3YuI34AN//Iie9V9OT0otOb8BBN5liv0zMpx1fYU5bhKsvV32Tvz1IPTZTBzQJZwWuYEwNZ1MTZYK4xtZ5hqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(26005)(8990500004)(6506007)(86362001)(2906002)(9686003)(186003)(110136005)(66946007)(7696005)(4326008)(54906003)(316002)(8676002)(64756008)(66446008)(76116006)(10290500003)(66476007)(66556008)(38100700002)(83380400001)(38070700005)(122000001)(55016003)(508600001)(5660300002)(7416002)(71200400001)(82950400001)(8936002)(52536014)(33656002)(82960400001)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LarTIWW+nH4QnsW0DNwqKjZyx9sruELAFYJTofNB8ZK1OuZ36waVyhT1I49F?=
 =?us-ascii?Q?sEKPDgFgic/GRchQK4n0J2dRjSueVVTxZpUxiPwhyB3fsy+obcqF8EM0avU8?=
 =?us-ascii?Q?B+giP0PMMEirP6Jl7SQzRjG4vWTZh8ZRcUoe/6QRTHVKsG5WrOporakv/JzX?=
 =?us-ascii?Q?Q5/iCl5jOdu5D5K+kofyjRH3/mrZU2sS/vv6xbNc7t1Rfm3MP/mPXQUM+FjY?=
 =?us-ascii?Q?0KJP909ERqAfEPzSED6Mr+6jd3Yf7YCOTUfnJYw6f8GKk1gvFtNFojPiqnfI?=
 =?us-ascii?Q?AnUWJb191dROs9687qv1bKcqVBkKxWIrxGEL70uLFj+OfWAYV7DK/rrhDNmX?=
 =?us-ascii?Q?eUFfl4UxU6G5z9B68/223utF3KA8mzlmpEZ1FFuuhnO9cNsoCicGSKRilOA6?=
 =?us-ascii?Q?dQC7g4JR03dRHLQj2uR7NMalAqYUJEhq20WeHGxS5hKOwLA0Mv6P+PtS02U/?=
 =?us-ascii?Q?coZz2VaV+FsyinhrHxEMW6gk6wisiEGYx1gYYmd3OfnbhUE0GtrOg7HTarJe?=
 =?us-ascii?Q?q76KSgL7m73Miw1CpnxPLWunHjdcNi5MA96J9Fq3APn7sjb5B7jpp3Gf4+dZ?=
 =?us-ascii?Q?DJcZ3z7OEJESg7qI7ma8gJAIn8qVHvyF7p8wkLYmV1ytuWWL37jKATzyswFs?=
 =?us-ascii?Q?eSQVnFff1hfHRGXuZmKx91NV7wM9AWi6LeNKi7/RpZP3NAd1k5Kld5hiHxcP?=
 =?us-ascii?Q?2ta7fEkSdEOwMi+0uPHI32Myqsz0D/dyFYfTqxnchjA6m9Xe0TF3gP8iawVc?=
 =?us-ascii?Q?iCeUXaajwfdCMIdoS3wCOhOluqzlUiI+os2wdSTvJ0Vf+ncvIIbHiiO/Y/lR?=
 =?us-ascii?Q?tmYXshUCDrhUqNomFOa1KrxcgOtTyXuqL2O7Y8dtYKDwKq9Dp9qfOerPpRcb?=
 =?us-ascii?Q?K0okNpevFa8foyFw1o4CfshKiyvJSQ26nPPnEoE2faIG7zvj7dKM4J0g3fJM?=
 =?us-ascii?Q?jRdHAxJMYvOyoEPgsFhwS3nvVSY1+sNXRGOWm4hpp6t9uDoExGYgpc0YKvAq?=
 =?us-ascii?Q?GylMnHU4/ItGjwKxYsgn88VvvLGPHdJPPey7MZFop49B6vDfriz4bnrPWKV6?=
 =?us-ascii?Q?29F0FgPRNtBl22PmXxOR6iGYq7jp7BU308mkoYkaMf2J9oywXVUeRRg6we5D?=
 =?us-ascii?Q?MdB9kHllvx/uk51xw5ePJM5TWziWLY4FE8jVydkjQuq/GyW9PFo95JnR/R5w?=
 =?us-ascii?Q?8EMrtQGAf0yqIFTQDT3D4+ZZwq37UtWWz5tHUuAMqyjWfSc7X3Rw7A9cxae7?=
 =?us-ascii?Q?GO7WuQxTKxJWbcRzszcwxllPK8+6808dwrwlD5NkEbawtyAhs6+wmR3c+mO6?=
 =?us-ascii?Q?8xBZc3gRJvxWsDZgbHnJONgq8+q6os9kYwUDqoxkYIk5do6+V/irQYgF6cgR?=
 =?us-ascii?Q?chlm7FGRVxQ6GeAwAcuiyuH+QDtV/qi1s8Ff90vrDwRAELMRk1dt4m/b6wHq?=
 =?us-ascii?Q?IfryPzHgkHowOk0IiIoc8GaV8FBzXHtDIGZ3ITezM+AcWrzLQudXPlg7ekPp?=
 =?us-ascii?Q?MHk04FWkjz1N29NhQkpxwiM1qEXaVaGRwf9QOsZeSZ7QCr8dX1h6ahOah3T/?=
 =?us-ascii?Q?/+5/oJyaXUMlDn7qJFH+RNbzZgwwmF2reU88xYtr0JjwxTa4D5I4jYI4uccF?=
 =?us-ascii?Q?5riu5bbKx5MMQCM30VFcmax1bNzIBspO+iHrR0l7tiTxrJ8C3kc58mxoZPQw?=
 =?us-ascii?Q?hzeL52G4BBCb1cmWoGpeUbuisVuuOAmaMbJJPM7D9u621AQAguFUK6EHmF09?=
 =?us-ascii?Q?TvFKxu5tt1dpaPXXrPsJKivmjEojrvI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9c6db6a-1916-46d5-c6fc-08da2322823f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 23:07:14.6774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8uTOr1ULHrSCvPEfdCbSzwJEKu5NuhandNJU+1viCdmmlZ7u5hEFig/5SyJgM24OnosVdFW8ikTYNJsc8uv1gpdd9Vjtr16r1zPxJYPEbS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0634
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Wednesday, Ap=
ril 20, 2022 1:07 PM
>=20
> The function returns NULL if the ring buffer doesn't contain enough
> readable bytes to constitute a packet descriptor.  The ring buffer's
> write_index is in memory which is shared with the Hyper-V host, an
> erroneous or malicious host could thus change its value and overturn
> the result of hvs_stream_has_data().
>=20
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> ---
>  net/vmw_vsock/hyperv_transport.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_tran=
sport.c
> index e111e13b66604..943352530936e 100644
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -603,6 +603,8 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *=
vsk,
> struct msghdr *msg,
>=20
>  	if (need_refill) {
>  		hvs->recv_desc =3D hv_pkt_iter_first_raw(hvs->chan);
> +		if (!hvs->recv_desc)
> +			return -ENOBUFS;
>  		ret =3D hvs_update_recv_data(hvs);
>  		if (ret)
>  			return ret;
> --
> 2.25.1

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

