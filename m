Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066E4694772
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjBMNw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBMNwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:52:25 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2092.outbound.protection.outlook.com [40.107.223.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE5C2733;
        Mon, 13 Feb 2023 05:52:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYUXnyyCC2RnWARn0LS6RbnjVkxdQYHukSXdovtNUviaxvgORQqpL7gLbv3p+5GU8RCQxe+L4Z1LUEUaSD2Q5wgnDLGV2Rw3GLYGEfHXcwYfHu9jgkrXb2GsuLW4oIR0FbyCjfiMDu4IUDVZaFsLK3FjNfkOhw85sXE3GCiWP1me9xo1Q52HbPazhgzFbyWxwaqMQRRWkyu6lWpK7HKPxijSbf6xDUuiMl3iA7WQr4znxygXxWAo3izOl7851Vz7/cF/o0/nWWrX56Guqk5QsgokDW8XYuP93IxAHsUeanjOCaPUSgtcnfOW9HfdTjueN7byrkqSCwq9hKq3cEUklg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OLpMxDWXBVvx1ZMg+V1DG6tM/qCshN5xf2Eg2Z1+Jvw=;
 b=KfZyefqpgM7RzPXn+f5oYatASqRjqm0Uu+qIyVLm16KMxstrPV22GRlyeK+z705OhBw8rOCQ2v4xqnmfiWfPRARhBvHQhCH7Lb6Am9K52vaZEhtzXwgjSWPbAJnOVgamdUPtZ8KGYGTCrms1kd3Cn9a5/6IpajzWFZXqkZRbYHiruZfJA0py0P4VedAkwBT/v0jWPhDLgHTWa5lLU4guWIAO5i5F7zsiCdptBH88iKUC7V6SpHTXqJblBbUauwF9Yi4ji2j3lRi/JOHFqk1OwPhBXFQdxTY9Qp2gNK3kuSiJHmcHp8DEQhJIxIout8amAx2uyxDKZQ85opdFLhUOLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLpMxDWXBVvx1ZMg+V1DG6tM/qCshN5xf2Eg2Z1+Jvw=;
 b=EFkjcZcQFoDYRqFooiQfvQXVkGGpBmGVLRhOpU6SCY6YXMZVdj8PE65BEK+parPa9vsf4wMiky6M+4wQzlMk1emRjdX4h/s303XMpDRSdNKzd9B99c2YEpv6p7/FS3y4pwzKxERXnc0AU0y5MQzjMLRE2M1LTcY7DI16PfCrUxY=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by LV2PR21MB3060.namprd21.prod.outlook.com (2603:10b6:408:17f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.0; Mon, 13 Feb
 2023 13:52:21 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5768:4507:8884:ea33]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5768:4507:8884:ea33%6]) with mapi id 15.20.6134.000; Mon, 13 Feb 2023
 13:52:21 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
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
Subject: RE: [PATCH net-next v3 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT
 completion message
Thread-Topic: [PATCH net-next v3 1/1] hv_netvsc: Check status in
 SEND_RNDIS_PKT completion message
Thread-Index: AQHZP2k+qB/hVR8vfU+dyBeL5D/8h67M5Yjw
Date:   Mon, 13 Feb 2023 13:52:21 +0000
Message-ID: <PH7PR21MB311690083F9311A12819458ECADD9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1676264881-48928-1-git-send-email-mikelley@microsoft.com>
In-Reply-To: <1676264881-48928-1-git-send-email-mikelley@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cddbd1f9-ed07-436e-89be-b814b2fe5d74;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-13T13:50:48Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|LV2PR21MB3060:EE_
x-ms-office365-filtering-correlation-id: 13eba114-0fd2-41b9-0b28-08db0dc98736
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qc+JqbU6uqTv1KJChi/w/8Z2FwrDT2EMRg0L2q4tIPD2cdy6KAeVRC4HjyCsywmG5+s2OIHCW8XyP7amtnL5u4EC2HVrQ9fblLq9Iaav3Y+/DpsYSGxls9wnkzm3qB9MDt3z7fw4llndT2iTZVRqCbdkO8ePN4FOUTMN4ytZGyEqBZBkyMVeHzV7c/mLbR/U1Tm+k9R+NnPK5Lfm2I9RYffHilwkbDV6y6jVLxIN0CrgAj6eIyXMWJl+bJ+0TG2l85tImkn6tmfILFgKwrOwfKsgQI/TkDc1tS9BopsvglltltJKC0SfLz+BNbDHiEQNDsmg6D5NWrDxd5vau2mx+vYs1CqHG1feSbd1Ukmrb4F1dt77cZPci04ib5uprA5BteDZ2R3w1Cg4deo1oSpM7vO6WnMSkj17WKmdBQsYjYkFoAgMC0tMhrdR473RoSJolckrVTXw2IBR7DBWwcg/Pwaq91SM3PegV6OKAYzKikNp9N8otpnAUC9Y6M/wNM13nikfKyPX37X3atMq4FmBzfbmz/J/v8HUVUtrjN4JVXSmj0KBqKZTLvPWN8ybd388abhMuLodm7OMFkNrV/b5EW36ygtdUOv1zNMXoPzxx0sFVfNdUvy/2YPQIDWhKGigq+a+FRXCZ0r9nkgefC6mGGzy8DDNylLM55CQ/ExKQPz1CAv00OD99DQUUomUTbW1W2To2mTaGc+R7WQYaiRJHi3Ras0H58uXjdqHCBFDfQ+Q1Dh1QJjtTdh9e/wnhv67PApcqH6/POiOvnsp7wNjXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(366004)(376002)(396003)(451199018)(55016003)(83380400001)(86362001)(2906002)(15650500001)(8990500004)(33656002)(6506007)(478600001)(7696005)(71200400001)(53546011)(26005)(9686003)(186003)(10290500003)(66946007)(921005)(38070700005)(82950400001)(122000001)(38100700002)(82960400001)(5660300002)(8676002)(41300700001)(8936002)(66476007)(66446008)(76116006)(52536014)(64756008)(66556008)(316002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0bp49MMEykmpEgouu7gOl2YtuDnqjywH5H9vzGXSbU/nJF5lfZapTMau1fTR?=
 =?us-ascii?Q?qnJ5Fnbw8nhs2LgrSzi+Ch4WgmGa7T0wK/KnGj6EsFBa76LG7yOlJaVJYGi/?=
 =?us-ascii?Q?57qZqYJLqxvsqxWp47DSY3DL4o23AGMD3urXIMehkau2J5X0lRaWqHEblMlb?=
 =?us-ascii?Q?GAAnrFNNOY1jCMb+iPPC6CYWhdpF9hj2tUI64SrmpNaXMPuTJCMo/j6nALnF?=
 =?us-ascii?Q?w5WDceFDuqn5IctBglc/iewk3dZv7JOb2KHttkKMy4/oC2lcIRmbYdwRqntu?=
 =?us-ascii?Q?o1ALPhHCLuoRPWG0aJHIf0yIx1OdaBWWwbx2NVs9Tp1m/jgHQxQyRXxSjaeV?=
 =?us-ascii?Q?4Y6jTpYDNJovEXz79zEj+nDXr1XLWiXyZzFvb5fnAzKxp2wnafF8CTjwWiYr?=
 =?us-ascii?Q?alxwY4yOtmED2GPNFrCuukJTVVLoJyj9CWt7bCqnhSRtrlO1VGgWzR2uuesJ?=
 =?us-ascii?Q?JNTwAprphnEEQPPogdvqY27OoHwfAJ+535Z7Y+kNb3gqZx5f5yUslsj4SaPi?=
 =?us-ascii?Q?BVGVDUDL2h26LvnaptHytmZ41SkG8tTvu5IU9+Sl2Ayq0SPAtpaq1MSj6oGS?=
 =?us-ascii?Q?DCNoi3HbwuamOu81US82bInlybImjuc2XGQmZ28ZED7phsMmyP/qpRY0YVwd?=
 =?us-ascii?Q?jN0pnoNF56nBNaXhPwB92Udm0fYY/tJ7AQSXseB7C2zeu7z+KpO9JLqC1Wig?=
 =?us-ascii?Q?bBkhbdtBuLxYMcq5qokTSxyG+2j84qRIPT4eHKSBs4QjBqyso030MOfrIKcc?=
 =?us-ascii?Q?DypEuzU7uY7+YXJzox61pco5pMiMf0Zl4alEYSQMAmqulVs5IRatRK1NNZZw?=
 =?us-ascii?Q?dP0twOiAGd4CqdqEnC2YCH3SvponwJ0pPlkcBc27pUkqY4DG5C3XFD//dHM2?=
 =?us-ascii?Q?S8DB11a+YKZ8UDxktccEQww7JJdhwFg3+fPzAqYx8D6MSF9PzYZEi10DaICv?=
 =?us-ascii?Q?7TRapEmxqHtokXFouX09y0hCoUwIFuDWdQ4yE74i3IS3c/PBmnf8ac0tBF09?=
 =?us-ascii?Q?4AlRFGxc4CrupvwiOh/qCbBsnj3pW+OiFwJZgnQyYVuyt2/UQP0xYDcZNK6+?=
 =?us-ascii?Q?HyTDsYHiVIoF84lxHDhHTk3JzKoBWuNR92irWPKnNHTM6+g8Lqo48M95s2Rg?=
 =?us-ascii?Q?IDsqySfDrdtOKnuBxOJ59QLHp6skHBSAlkLBSft4ONoihT2mYI6Yoib5PtGT?=
 =?us-ascii?Q?fENZ0Wj4D/6Gqn2Ou8lZqmjc16pJABL3hRoYUjNLNhQPNT6wzTrdXR2ZFfb+?=
 =?us-ascii?Q?1I43FtRBtgZ+VNnzG0m05emBkF6fylq2Y2S+mPhkpwFJwEOeuT0doMgw0Itp?=
 =?us-ascii?Q?SrAI6h8fLvju4+iKjSeoilpBLQYz8g1Nbe+aB+aG0kKMwnxD/OlFDU3sXnh1?=
 =?us-ascii?Q?tqMUGrwO2i5FF351Jtvmg4hD5+ji4mRFii9t1W+/yKxlzyzj/4CXh09TuE3D?=
 =?us-ascii?Q?cU2BoEetVeLb2HQFjkXkUZZHyiv5ZOU8b0laiN87R619affd48aeNXBmJ4pV?=
 =?us-ascii?Q?aypNyN8eFu7+nezsLN2260sMxsUF2cRjuywrk4liFFfXCCwlLdUQsA0z4Hdq?=
 =?us-ascii?Q?g8KzSVPSs+FpJrQSiphEZALAUrTx0DLBMVOKTDj8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13eba114-0fd2-41b9-0b28-08db0dc98736
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 13:52:21.0642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GCg+W0KyZLca8Sg21C5ee+BbNAtDyC55VtKirpGSmN2wXcIhCYH0ZU+qf6h00afSlbaLcxzEqcnfAr9pzxIwXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3060
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Sent: Monday, February 13, 2023 12:08 AM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
> <decui@microsoft.com>; davem@davemloft.net; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org; linux-
> hyperv@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Subject: [PATCH net-next v3 1/1] hv_netvsc: Check status in
> SEND_RNDIS_PKT completion message
>=20
> Completion responses to SEND_RNDIS_PKT messages are currently processed
> regardless of the status in the response, so that resources associated
> with the request are freed.  While this is appropriate, code bugs that
> cause sending a malformed message, or errors on the Hyper-V host, go
> undetected. Fix this by checking the status and outputting a rate-limited
> message if there is an error.
>=20
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---
>=20
> Changes in v3:
> * Fix rate-limit logic when msglen is too small [Haiyang Zhang]
>=20
> Changes in v2:
> * Add rate-limiting to error messages [Haiyang Zhang]
>=20
>  drivers/net/hyperv/netvsc.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 661bbe6..f702807 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -813,6 +813,7 @@ static void netvsc_send_completion(struct net_device
> *ndev,
>  	u32 msglen =3D hv_pkt_datalen(desc);
>  	struct nvsp_message *pkt_rqst;
>  	u64 cmd_rqst;
> +	u32 status;
>=20
>  	/* First check if this is a VMBUS completion without data payload */
>  	if (!msglen) {
> @@ -884,6 +885,23 @@ static void netvsc_send_completion(struct
> net_device *ndev,
>  		break;
>=20
>  	case NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE:
> +		if (msglen < sizeof(struct nvsp_message_header) +
> +		    sizeof(struct
> nvsp_1_message_send_rndis_packet_complete)) {
> +			if (net_ratelimit())
> +				netdev_err(ndev, "nvsp_rndis_pkt_complete
> length too small: %u\n",
> +					   msglen);
> +			return;
> +		}
> +
> +		/* If status indicates an error, output a message so we know
> +		 * there's a problem. But process the completion anyway so
> the
> +		 * resources are released.
> +		 */
> +		status =3D nvsp_packet-
> >msg.v1_msg.send_rndis_pkt_complete.status;
> +		if (status !=3D NVSP_STAT_SUCCESS && net_ratelimit())
> +			netdev_err(ndev, "nvsp_rndis_pkt_complete error
> status: %x\n",
> +				   status);
> +
>  		netvsc_send_tx_complete(ndev, net_device,
> incoming_channel,
>  					desc, budget);
>  		break;
> --
> 1.8.3.1

Thank you!

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>


