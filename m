Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781CD693B8D
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 02:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBMBBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 20:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjBMBA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 20:00:59 -0500
Received: from BN6PR00CU002-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11021025.outbound.protection.outlook.com [52.101.57.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBE01041B;
        Sun, 12 Feb 2023 17:00:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYr/WiX3EwV7XieYUIEMkLptEIZJkxbTcGErVBTsO0ZtJPojhDoeer9RL5mcPupS5w8btBrbYyB1Tfo3vwR6C4jYDJGF3sSj7Uv/KR/P6w4lOqY0maEPmK0uLpYov0g4oZ2xn8OUzI68NtwgLk+Bq1BwFn4msncUl6FZ7k8KxrhH4YebsykC5Lc7exyppUKhedtvSXN+jL3INXjQrHRp58VOGgzxO7enn4AZORm6onOM2EZtugbHhoG8d/ZsRoj3MORGRdIS5W0eSNSlBGc2POUZJY0XtJTd3hzxHiIYv0IALBF3kCmbf19+odH+w0ckzMN+2NT1qmSakxhWXmUQaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QjcMV3x2xqlnLxzU0JUAv6K6MO6aVJkq22kWasDMQRo=;
 b=TTvXPTn1tdUTRHvoeTHs6O3bxSfk8gD4F7YO9SK3jh2lpiVoNvbkVWvhkU751EDiYqknsKYZEXSH+YxTIZb/GxAcSkgIoTExFMUljOrW3HzMhJxsk4X4+7AnA4AMvJPct5S5OZcGf0FXZ/HNBoBEFPPKoM3ZIaLMGuWu739RXoHi9xlI4rAxu0zMWlJIs9WlIzZSrg+0XaYbcJ5QECi/mQ7FzWBRr9WqX7GEUS0ePPvCiQW8lGn5e6rCPU/mBL2pcJQsMnef36emzULzyloeTigdUy+BaDtnhdR/1KuegPKF/3RgUDvBurEiPBuZhC9NNSiZ0ay7A+JNirOL8607oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjcMV3x2xqlnLxzU0JUAv6K6MO6aVJkq22kWasDMQRo=;
 b=DpIvlHEorZoki3OzG+EONKhuVDYzDAsgTeWMXqasf6ZTFV80GtWLCtoG85rUqAoVINnq3E6FKgxIifeKUq8DqQspiSTNa3C2zFoEF6Y7hCJU49hpuJGh5BUDN5cytwkaTv45BLWEkWDH7L3G3e0Nw8scRYoBM1Wl3ZL4UHLXJwQ=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DM4PR21MB3753.namprd21.prod.outlook.com (2603:10b6:8:a0::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.7; Mon, 13 Feb 2023 01:00:47 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::55a1:c339:a0fb:6bbf%8]) with mapi id 15.20.6111.007; Mon, 13 Feb 2023
 01:00:47 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT
 completion message
Thread-Topic: [PATCH net-next v2 1/1] hv_netvsc: Check status in
 SEND_RNDIS_PKT completion message
Thread-Index: AQHZPmoMN86gZuRZokGVMhJb+m2yG67MACKAgAAPR5A=
Date:   Mon, 13 Feb 2023 01:00:46 +0000
Message-ID: <BYAPR21MB16884830B91C6ABEDDE0EA65D7DD9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1676155276-36609-1-git-send-email-mikelley@microsoft.com>
 <PH7PR21MB3116CD4863DE37DD18193812CADD9@PH7PR21MB3116.namprd21.prod.outlook.com>
In-Reply-To: <PH7PR21MB3116CD4863DE37DD18193812CADD9@PH7PR21MB3116.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e69438da-5f24-47a4-8fdb-89c56ede14ee;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-12T23:58:55Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DM4PR21MB3753:EE_
x-ms-office365-filtering-correlation-id: 509ee2af-3f8a-4842-9df7-08db0d5dbdb4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x3q0SaUkzxHg5aCR703Wmy2ZRSnxakrAxLVrtdeRibBBKIdnSyMKOovJYO5jdX6eZ6zyHd1yOIPxugUk6Jsg0J2PwCq1X/EvSm0CIGwBXbgerJ8xUQZqwIbx3Xc609EzWxoQG1mHjeXU1aZthd+PM5uxzaBxuBozq5vPngu/VngobaoFkrdiKtgTf3pxGavTSQ7gt4huqFYA1lebviAb4NiS61bLelJ5uVdOWiJl52WPLTA4oJIizykc4Dh6YNvCC75st/nZ9NpPhOvhdwuvYmCfXgLF4CgAYYxz832LWhlIG02Oxvb6UcKqcTLFLGzTtvxPUU0D+CjIG7ZFP9CEtTvVJmrT0cFJUVtcM71vFb0aQBfrqt2YbehJ8UGHCAHBmnlxSEkqBdpyuNFAxS2c6snyo8XGD+AHDKsb6mpy2tXHvlqo2qFwZYDbHohbyTA994YjLg1ODOTu5B5SZOZg6JbCYeLTiH52O08LnGtxDodduZn5OFQCb954XTVeD4lX7wKuO3U48+l/wZjQFn18GIa/Dj5/6NbMp9zMlIl1DS1H8rrcqLimnuAR9hzAnHXT6v/hxbTUWHEQK6ugvwl2t0cXB8xM2Ce+1EHvEbvV3vXOQGd8KqWrwZUid7MhS2Q/Nr8wXMH31qXq4EKGplQgPx8eq15rw9OWUi+l45V/8pMBCBSn5W6b2VJhJ84o2/B6jOMPMBaA8bNd/Q1hezOF8MrzNGg3hqBksiK5faWcuFfbz2rT2cyLRu035Aa/BZEmRBG15JoJSNFIjqbASk4aGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(451199018)(66946007)(82960400001)(38100700002)(82950400001)(8990500004)(122000001)(316002)(38070700005)(921005)(52536014)(66556008)(41300700001)(66476007)(8676002)(8936002)(66446008)(64756008)(76116006)(15650500001)(2906002)(5660300002)(6506007)(478600001)(53546011)(9686003)(33656002)(83380400001)(86362001)(55016003)(10290500003)(71200400001)(7696005)(110136005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fXcMkOYwMI3Jprhe0DnX9ZAnGt6uDpkXzBSXzGXCDbrJnPIK3QKs2XLUGWua?=
 =?us-ascii?Q?H567uj3g4p/fr/fYIQuBVqi2ewVcAgDCnYX3ibB7JB+Jcy2Ngwylg1bCiqQN?=
 =?us-ascii?Q?BHmuZVG4v1qRd9H0wGORVYI59O4cRskEu841Y9foTgCuLfLCf/59N3dYtSbv?=
 =?us-ascii?Q?OcupX7J2oG+DlFdtKPvwHjtfk/RwaDTHlIYXSag7Y94mWXHr1ts3EJf2+qLW?=
 =?us-ascii?Q?ZV+mQ22h0MZzPgOYDujcpHjf8B++kJt1DOJLDiFRR1oRy/MvaFhd1ZofWJlK?=
 =?us-ascii?Q?1XDxmN4aswB7Tz/QGM9zNlEXXjC7aWZkGA4ZneS0pTSAfBG5GDDfdu6qJ1HA?=
 =?us-ascii?Q?PADdZavcNP9l77TWASsAkxAIXSMHTVVt5LD6PyfnLORNIzSjXbwmByfZ0hvg?=
 =?us-ascii?Q?TFBC7oV8PAcD7nurmmq9gbdF4hx7SqR38W62aDOyibb0Uz5uySflMI50JltP?=
 =?us-ascii?Q?/fakb3x6yWCpL9nNDkpoRT8c6e4Aah9M5dCxiXpLTeowqMLvz8gIkS5F1a38?=
 =?us-ascii?Q?zoJUIkWQLi1dLkvdpAllkWy72S3xqw+O7t9CQKxduTCeTWGJfI4EL7Bf2nYA?=
 =?us-ascii?Q?VAaT4ia67cuPqHR+RIsJidb7YXhGSsshRxMIS5sZ6hO8B/+wKj+R75ZI1OQp?=
 =?us-ascii?Q?zi6OvbQ3k4AILbjVB76JiECfJ6isYLkRObCq68tldoxlGzgCifqTFVSJJxrh?=
 =?us-ascii?Q?gOqTjRcr7iBgreLRXPoZsBAZsEID4r6FKPXU1WZkYBVZTd3Y+dozv6n2qSqL?=
 =?us-ascii?Q?MKihHeB+W5ujk+FVUitT4XqTZ35ARbFP5ZY0fpXHjX/BrZz2d2lQaFGmMmje?=
 =?us-ascii?Q?jsEO0jQqC0MXJ7V0Ng9vR2ykImGBYeS9oCWMwrn9o3UocQjrJxon7bPmZoLW?=
 =?us-ascii?Q?vE5IWat2jkPwLzdT7WQOOwVay/zRxllzSKe44zIjuKE9qFDKO/Iuq37Spf2b?=
 =?us-ascii?Q?PD65zOtIUm0Su/v9nu/QrwGfoccJ5jbgvRcayTrGJkfD6ma1d079HLuP4bWm?=
 =?us-ascii?Q?VCE2FfTBJHX8b6Xh5t9xMVOO8O0Kq9HyOP5vxJDYd9N/DQpsQjPkA3K8aG68?=
 =?us-ascii?Q?Sa7Ytjd7xt1CbTj7zahQrd3JudTiVKiCy8pssP461ZFWU5Jw2A1xuxnrBEdB?=
 =?us-ascii?Q?hXsKcPNDUDJtVmROQcXZzpF3w9Uoc67KUeW1ikkPj36skPZZYlbusqRd4XCy?=
 =?us-ascii?Q?qe/MsP9tE2lmaH7yaD7Stp7b9Ztp1TirC364ZuppzlkAi4MlwQjRiCq+boBP?=
 =?us-ascii?Q?99f6NiS5o3AYxIseF87bnAyGR3qTv/MxzHVDA30gg3VKYLBDF+6BovsBh2lw?=
 =?us-ascii?Q?pMlK6bb/4NT2apJiCEa8J+bZFmp+SUFA35hlINZsjJNkVHsWDF2okCBI6/Vo?=
 =?us-ascii?Q?X/BVe5lp0sFF/R1sue/fNpa1nRbiiAl444HlI4L+JOerO3Xfm1DUmgqJicY7?=
 =?us-ascii?Q?xW8Q3fqCV/OQ0628bYePbPtDO3VaBcjhjOwX9p/uvx+YwxqjEhxvRCb+rw3O?=
 =?us-ascii?Q?E/82zI828yhrBpnv3lDfwP4zjITKry3q3klPmskh+pNjKIh6FoidXEZSlZ5f?=
 =?us-ascii?Q?Bt/fyrxdBvPIYWHBgUoVOW0zDqSWAvrJ7UTbUNEUjLSb1lahDtUloOKbfXTu?=
 =?us-ascii?Q?kVhllziZTLxey0NvzpqPcrE/5FNGhPfViCtbiBzX1KsGtPAxU8I99M/JtRda?=
 =?us-ascii?Q?MFUbvw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 509ee2af-3f8a-4842-9df7-08db0d5dbdb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 01:00:46.8438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cmkTLS5KRebkB9EagKoVllgC5gract1BzcfflNql5MXY9W8B8WYotWBx49mhys3CdzVBw5KxpTDHsNJlC85AxtCuBhoagc4KJTGSdfDLylA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3753
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com> Sent: Sunday, February 12, 202=
3 4:03 PM
>=20
> > -----Original Message-----
> > From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> > Sent: Saturday, February 11, 2023 5:41 PM
> > To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> > <haiyangz@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
> > <decui@microsoft.com>; davem@davemloft.net; edumazet@google.com;
> > kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org; linux-
> > hyperv@vger.kernel.org; linux-kernel@vger.kernel.org
> > Cc: Michael Kelley (LINUX) <mikelley@microsoft.com>
> > Subject: [PATCH net-next v2 1/1] hv_netvsc: Check status in
> > SEND_RNDIS_PKT completion message
> >
> > Completion responses to SEND_RNDIS_PKT messages are currently processed
> > regardless of the status in the response, so that resources associated
> > with the request are freed.  While this is appropriate, code bugs that
> > cause sending a malformed message, or errors on the Hyper-V host, go
> > undetected. Fix this by checking the status and outputting a rate-limit=
ed
> > message if there is an error.
> >
> > Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> > ---
> >
> > Changes in v2:
> > * Add rate-limiting to error messages [Haiyang Zhang]
> >
> >  drivers/net/hyperv/netvsc.c | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> >
> > diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> > index 661bbe6..90f10ac 100644
> > --- a/drivers/net/hyperv/netvsc.c
> > +++ b/drivers/net/hyperv/netvsc.c
> > @@ -813,6 +813,7 @@ static void netvsc_send_completion(struct net_devic=
e
> > *ndev,
> >  	u32 msglen =3D hv_pkt_datalen(desc);
> >  	struct nvsp_message *pkt_rqst;
> >  	u64 cmd_rqst;
> > +	u32 status;
> >
> >  	/* First check if this is a VMBUS completion without data payload */
> >  	if (!msglen) {
> > @@ -884,6 +885,23 @@ static void netvsc_send_completion(struct
> > net_device *ndev,
> >  		break;
> >
> >  	case NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE:
> > +		if (msglen < sizeof(struct nvsp_message_header) +
> > +		    sizeof(struct nvsp_1_message_send_rndis_packet_complete) &&
> > +		    net_ratelimit()) {
> > +			netdev_err(ndev, "nvsp_rndis_pkt_complete length too small: %u\n",
> > +				   msglen);
> > +			return;
> > +		}
>=20
> The net_ratelimit() condition should be for the error print only, not aff=
ect
> the "return".

Argh.  :-(   You're right.  Will fix in v3.

Michael
