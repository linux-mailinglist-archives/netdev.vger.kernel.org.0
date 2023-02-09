Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA90690AD8
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjBINta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 08:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjBINt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:49:29 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021016.outbound.protection.outlook.com [52.101.62.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950565A938;
        Thu,  9 Feb 2023 05:49:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLKPE2LmEwAcRlcHreWgENmTkePWPW1XIXEBXc1pflWQ0PPpw/phZgvKhtjV8OP9da8T74BIGIS1USdlVTU8B4hBODmO3sL20XQGmdQ/RMFo7nqn0P4U+fFOWIT/sg/gsJjwkQDp0DPlq3M4lX/QrJifvdIO4fy/p5lTSHAKbrbpw1M3XXX0Ia6kLEO/mUb4qdSx3Ve93TWcD9mV/6hIzkokl6MaVgE8rb0hTiiatRjXh7HS2TuSOgeB7DsVqoFGZ97cYZaQA+cJVaKBVjyRjeuti0/vJ+9bPSlIjDyJVRMCtXwvfnXFhap304fynJsUPLRhaq3rSt4N3Y0YzNi2Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ftJmy7d8wSBHZymRLymQhIi4SRbG7GKQEdxNF2cwm20=;
 b=NMBdRQvgg+yMfUa6QqVfULpXc3bWvFxcmUCJY0qf1E/XGRnCRclJ9mKa389Svk985ygA2k//T2Ri+cZXZbxKUmwPWx6afp9gNtgQ/BZd80W12oWRQNFNgwUJ651L8ne80MIakvna6eGvyVTvSSG3du11aPtPYmk526S28RKEHpu7B7d34OoVKN7CqNzszHApV6TtdDtdMgwEQcnPkWOnAWevoiHjO0etySUJpXUksJzkcD+3Y6n3YmhZer4e9BcD3jaWkCrlfgf/Rj8Yvv3GEK84hmd9LTgQX0ps6XbNl4dNCu0aFOGS0tRptrjfQejv7T1Vfj9kHiF477u6fSlPpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ftJmy7d8wSBHZymRLymQhIi4SRbG7GKQEdxNF2cwm20=;
 b=JulEBl27cMUfWWRtckO8NH/qa7AiETldRNuijy3DCx5PqH4KhMKSo8Wtcw8Bi4eKDN5kk+qMRxMzvD5J9H6DfwbOjEcoOVwmMtzA004zbUKyrKoS/dtxIxpUW4XYulBjyAmX9ZYFM74X9ZEiOKrxCLETDqv9Zqa/lhVOdv5bADs=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by CY8PR21MB3801.namprd21.prod.outlook.com (2603:10b6:930:51::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.5; Thu, 9 Feb
 2023 13:49:25 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::4d96:93b2:6d5:98cf]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::4d96:93b2:6d5:98cf%9]) with mapi id 15.20.6111.003; Thu, 9 Feb 2023
 13:49:25 +0000
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
Subject: RE: [PATCH net-next 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT
 completion message
Thread-Topic: [PATCH net-next 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT
 completion message
Thread-Index: AQHZPBgbtvv1UGK0aka4lQW1EWRBLq7GobFQ
Date:   Thu, 9 Feb 2023 13:49:25 +0000
Message-ID: <PH7PR21MB3116666E45172226731263B1CAD99@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1675900204-1953-1-git-send-email-mikelley@microsoft.com>
In-Reply-To: <1675900204-1953-1-git-send-email-mikelley@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c8e0a383-fca8-454b-983a-3339aed813d3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-09T13:46:41Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|CY8PR21MB3801:EE_
x-ms-office365-filtering-correlation-id: aca84732-10b8-43a4-6a75-08db0aa474f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8BvTDFgvlZL1EleRMb7gsi5H9UpgvbRXVSaadDt6zFE1sZaZavIc07oa+uefKY2Abk8TMSGmJMEzRRlCpU1OgWNvz/nYlSrQjRA2FFj7AriclfFQs0Ip1aIxBm40OKWUWJtpf8VzfosvsjmToRKZeoF5oDqxCdz0/qqT/XA5oXIlavfGuPDAmmIxcCnOMwfQ8RgRTyano7MMPBrBdGY81as91yFVY8WPNwQffkSoZfNrUgHDgvpH1kigUveHJr/gSrx9IRRcExh1lkplewiW2KewxAT20+S1wQThqGqjOqLqEi3xU2bzkbt1ubFGlOhVdPaO8kUHZl1uaN8czfuSDzYeTanJXL9+s2/4Q+GxKfBJm2KIuKYEBcbul2AEXCEhiUmS9yG+mlX8ESbMbDFVE8nh0DELrcZUD5IfOtGj6JRr8s3Rh0hxtP8AAVhhPPn6QxMfFUxZyyQir8kms84rwx9ITiaMFVHQXrLxTeReYsteR+P5ZfQTcEaBWbDwt7otNR6QR4l5CJaUwkd0LOCVpzELYw96b6Wu/EJ1c4+UyBpfSUSlPYDusOAlMzhwZ3jIWtJVevodox57wy9tZUVJ+agc3OF1twmfvo6esT3RBpzraySkombNqqExkOOr9Y57Wd16rKB1x61A/cmcHN+cM+WO33Fag6bPI5ELMis+LBJYFiaDqYjpEHsFlOhoJYtTYADuYFx5EekGS7eEfY2zYvaqOUehMkl8dTIGTkModG8gb3VnGDIEcQ27sEI9PvUB77VUybo6lgl+ydRCHoBRQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(451199018)(41300700001)(8676002)(66946007)(76116006)(66556008)(66476007)(66446008)(64756008)(55016003)(122000001)(2906002)(15650500001)(38070700005)(33656002)(86362001)(921005)(82950400001)(8990500004)(82960400001)(38100700002)(5660300002)(52536014)(8936002)(7696005)(71200400001)(186003)(26005)(9686003)(478600001)(53546011)(6506007)(316002)(83380400001)(110136005)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LMJCADjnbaRDytx25F0Yt5iQKmLgzA0SVUhaLoECrAT3YM/2U6HznwTh+KgH?=
 =?us-ascii?Q?04IvyfEmB5BtM4cGr9L9WvHposYLP79GQ7e4yhgnfS0BxXMJqG4G/tFU/AVc?=
 =?us-ascii?Q?sHZRppM3lbQo9Vy44vIcjknXEekezvKqAVbaUQYurpO8aYWb/51tj+07ema7?=
 =?us-ascii?Q?grUNoByjFLQ4ns0LO6sE9yocMV4wLZwvKxWMO/LPlf+CjJTMn11CCg1nH5Xf?=
 =?us-ascii?Q?ik7PfJODyuAMKS/wBuCGXd66YmhDWr27HwVFLJihKYGBG8c02UoWpl2dQ8wu?=
 =?us-ascii?Q?Lhngrgf+eS/VBg2vm/SxSuk/IZoyk94NpsvMFYaPkGNHhkT65RlCUXPwg9s2?=
 =?us-ascii?Q?+WNwfWu1w/4UsSrac5uHZVuqgyFuYILDswOAdm3NZ4GjP2INVOC5yoAWhkMq?=
 =?us-ascii?Q?fh1RXgnStzTReqknML2WPzwbXY+i3cJdd5YRqyuQxx2Uw7eHUza7L2W9BAoc?=
 =?us-ascii?Q?1c/TCKtr8ugL5Zl3zAFlxI1C25XU8epbROFv3m+aUC10v/k4rj3W9RCxPpA4?=
 =?us-ascii?Q?Zw8QuklZCk5ne2uHY1G6q0sW1yxgef/3EQNE/RwdH46/4dPF6x1/ZmawVR6Q?=
 =?us-ascii?Q?FGcdvNdjPXpznUPnASk7PSm421oQege8vpzX15i1truHhj+qMnBXkh+zvv3q?=
 =?us-ascii?Q?JRcPWqy9W6C60UqdudwUDvb08zXruPV9V/Iq9knzUzRd/qM8COp5L59l6VSK?=
 =?us-ascii?Q?s3DgxUl+xrPofwAosGDkNUvD4Ef45DTy3x4KdrWh7IvAASi+ldY3jyNf6l1C?=
 =?us-ascii?Q?KsZBDH9YKfVQnGlyRwZ125ZhscN4TFnM417F6cPXB94O1+SsWR/HZ6B69PvE?=
 =?us-ascii?Q?+wxlhFwpf9k4EQD1OZN1PFUp9YEJjd6D/xI1eWj3v8aMI4q+4a8PU7FmJEU5?=
 =?us-ascii?Q?oj3bzOeCNWoTuljKlQz+fVUu1Y4B1+vZvxQj2rEHJb345hMhxOaFfSinCP+5?=
 =?us-ascii?Q?oMGti3ZIsSw+GNDQHtmwYqUxtFrRoK01Max2mtqzgmwFtHU+QpSSwX5KhSps?=
 =?us-ascii?Q?rs1S7MnFVLtUzpStMyu9P93eZ4HBlInuQaWzEBl4cf1okjNrbU6JCobjWLJY?=
 =?us-ascii?Q?Yg69poSii+MghGSUPEQJoGLeetHjFW2BzDv4aUWH0+H0xjoTxIJg34ITZVoh?=
 =?us-ascii?Q?kEUUJTGzQ4v7aE1hIeQFc2iOal0qkDejCijjz7stfV32W+REgVD+Vs5FF2Wt?=
 =?us-ascii?Q?LxgiSpAfOGsnuxBorJBTarG4NIcGruqVV0Jxc2qhdsw55MIHKhgYuFDt9Ewa?=
 =?us-ascii?Q?PaFO3dLQeSSkvSifD0XV7mvgquNE3JjNuCv80O3NQPy2LVzteWALkylRFfR0?=
 =?us-ascii?Q?KwimyzgpyzWNA680yawUCqozU1V35ZstTKKL7qrXn2Plu3y8q6p9f0FTJACh?=
 =?us-ascii?Q?U1/N+/hJtwTEAXKc9jKa/goDrDYDotcj/6IvSpDUdISbg2kFXL55IhCD253S?=
 =?us-ascii?Q?39w7i5fQKdibzpg+EXx9LDzdStjuylj/xTI8dz7AFUulI4daUglA1V0v6eUl?=
 =?us-ascii?Q?k133KMXTmbTTmI1f6EzkEpX2UoMcyZiP0M+xGI9NOEeom4cAPrYIlGL2diAI?=
 =?us-ascii?Q?r23fiVSvfKXZgY2VGR35HMgqkl86FT57KMO+4Sa1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca84732-10b8-43a4-6a75-08db0aa474f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 13:49:25.5456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LxaoOoKpxjjN0Q3URNa9SgRNFGdfXp6aUgUMl4p8L0artmU8qEsv3P2jtv90jagWXnIUME7yqwQLb9dSnKHtPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR21MB3801
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Sent: Wednesday, February 8, 2023 6:50 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
> <decui@microsoft.com>; davem@davemloft.net; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org; linux-
> hyperv@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Subject: [PATCH net-next 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT
> completion message
>=20
> Completion responses to SEND_RNDIS_PKT messages are currently processed
> regardless of the status in the response, so that resources associated
> with the request are freed.  While this is appropriate, code bugs that
> cause sending a malformed message, or errors on the Hyper-V host, go
> undetected. Fix this by checking the status and outputting a message
> if there is an error.
>=20
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---
>  drivers/net/hyperv/netvsc.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>=20
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 661bbe6..caf22e9 100644
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
> @@ -884,6 +885,22 @@ static void netvsc_send_completion(struct
> net_device *ndev,
>  		break;
>=20
>  	case NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE:
> +		if (msglen < sizeof(struct nvsp_message_header) +
> +		    sizeof(struct
> nvsp_1_message_send_rndis_packet_complete)) {
> +			netdev_err(ndev, "nvsp_rndis_pkt_complete length
> too small: %u\n",
> +				   msglen);
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
> +		if (status !=3D NVSP_STAT_SUCCESS)
> +			netdev_err(ndev, "nvsp_rndis_pkt_complete error
> status: %x\n",
> +				   status);
> +

Could you add rate limit to this error, so in case it happens frequently, t=
he=20
errors won't fill up the dmesg.

Or even better, add a counter for this.

Thanks,
- Haiyang

