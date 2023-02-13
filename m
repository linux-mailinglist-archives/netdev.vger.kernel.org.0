Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F55693B41
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 01:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjBMACo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 19:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBMACn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 19:02:43 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021017.outbound.protection.outlook.com [52.101.62.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB4EC654;
        Sun, 12 Feb 2023 16:02:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xk97iFJKX7IBFB4ERjlsRUTaryLeOxESBJNLcJkXEas3qJbtiYIaxgwqe8y5DnccNHfv00Zo53Kcpe0bc+gq2rGaKWCY8ozhmj9Ksxv50p7by1AWtv5736JEET1w0QLYTOPYWXOw3mqvSddEeX21/kS/mfIaKaIlB1ULL6We03QNGPDya1g2nGMQ0gwH3SCVFz0I5KQ9sti+Xstj5btK1Ks8Kx132QJafvdmZ7crSPeGdBBfASddl8a+J6MjQtL/ivepvbg/e/u5dzSC68+fx6tfmuJSAEvhZDUNLqWpVuFJynUyuJlncOEs+Ex+LYPa6fozHR93trD1A9GSsYH8GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTiyvPB6BufglGo6cPAoC8PJ3HAEW3bBywLgiFkIHiQ=;
 b=MnrtY/hCQEkt6Pq9IEOWbOm6gVsELI2CrUu1pqEe4sZXqO0pUnCm4jVsxRfwTK905cadq/OLUr0X6F6UquV+DPQIouEq8xmV7SVWmcxQUZjEt/bS0NeZDtgEGzL22zkuJ43KBtNDav6KeFURTd+9kbjbS5cqNZ7pSlubB6Z15qhG4fNWqSW/WoGGv47Nkd/W0CrZ65rDkjk7hCCylrm3sIfjvWTsVyc1YXvfvxw6FTZdXMPs3i2O/HhhOEvkHF6BEvmCwzT16mqViruWEC9yzllJCt1MNM9uD9HWquhCX0YTnjHq+/vlUsZsNdgRBFjaxoaIVUTDVA9M9CabQq9MOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTiyvPB6BufglGo6cPAoC8PJ3HAEW3bBywLgiFkIHiQ=;
 b=hCkZQSi6DjS+1BkYxfu258WkjWOFWFkekYFx8cXzwnJtTVjuMdcZFNMsOkDfC1i4N19Vl9Pti4Tw0m3ccPSOJ5aU/5jSd3Mk5vqmP2Rad2fMoIJeLOZLYCIGeAbp7BwHjpbLO4L6uA4APEI0WS8pol4Jj+BrxT7y2S2ycXEOKM4=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by DM4PR21MB3704.namprd21.prod.outlook.com (2603:10b6:8:a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.0; Mon, 13 Feb
 2023 00:02:38 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5768:4507:8884:ea33]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::5768:4507:8884:ea33%6]) with mapi id 15.20.6134.000; Mon, 13 Feb 2023
 00:02:38 +0000
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
Subject: RE: [PATCH net-next v2 1/1] hv_netvsc: Check status in SEND_RNDIS_PKT
 completion message
Thread-Topic: [PATCH net-next v2 1/1] hv_netvsc: Check status in
 SEND_RNDIS_PKT completion message
Thread-Index: AQHZPmoMCFL/GKeQck2dOT8XBw4Cyq7L/xlg
Date:   Mon, 13 Feb 2023 00:02:37 +0000
Message-ID: <PH7PR21MB3116CD4863DE37DD18193812CADD9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1676155276-36609-1-git-send-email-mikelley@microsoft.com>
In-Reply-To: <1676155276-36609-1-git-send-email-mikelley@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e69438da-5f24-47a4-8fdb-89c56ede14ee;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-12T23:58:55Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|DM4PR21MB3704:EE_
x-ms-office365-filtering-correlation-id: 4fbe30db-e745-4456-a938-08db0d559e16
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bRPsagoQ+Ao1ZHwxhp5/pU14M3ThiH+L1WeXM8sXbRgfIa3WoQ5LceVkJDIoCCdFfvPV32PkGX/z9QJOoAmOuU4W3lrwNl/7rMwKymdHbpGFevL/+fFdR49gJx8bMSLB8Ca4anxk+2gCKVCUTo/5aD5VA09+53/WHCWapH7cormVEwGGtYYRVJZZgkX24TGbKIFJBbneRi0yFiUPm3+tA+IddEjHkRtbxVtR5kKe8+jNbn590t6pVz61SjKPkuxuVV7bRLP1DM3rN6UVjpgf7mRG419Il/x8u8yEeKZnQTDmDGW7iGpMIlSAfK1PI7LuAAwZq/P0AqcSSfGGw+Fdkbcah6HsxwoOHPhT+G1MnDhg/FsZbZvmPGC4XlsWUF6L5bV8vBVtwcHnk6hcCp3DxKe0Sytvrr3pQ3tUzp+Bm7kkK001JRMQl1gg+L7d1PVXrmyy2K/OpCe2H3RsU0SLRhjrjjgrI32/tydNMqLEabyg694cFqa3rZv0Mj+oX4rciBZ1+jZB8DKJ782NxST2oRedXEKjBp9D81S43Si3/gMbSedk3mz68kEUUQdkDFr42eUYDDUfGZbEV3R9vOlEG2TKaAiqvgFo1HnuYHkAed2BTQ6dRPxcRTqCIaqTNjtr2RpsALzCyq7aKhA+5zXw4k6fN8dGvk+SNCOtLV52qo9KerMFxDvmeIJkXsr+pPYATDVCRSlEd3LcjP/MgKI7HpuRS7pvIfg890qkCDczn1iokRnniw8zAMCDzcKFdY3scI7w+TnHXyjfMhxP9g9DoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199018)(38070700005)(921005)(186003)(26005)(33656002)(53546011)(6506007)(9686003)(82960400001)(86362001)(478600001)(122000001)(5660300002)(82950400001)(2906002)(8990500004)(15650500001)(38100700002)(71200400001)(52536014)(55016003)(8936002)(7696005)(10290500003)(66556008)(64756008)(66476007)(83380400001)(66946007)(66446008)(8676002)(110136005)(316002)(41300700001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?klPb+T5ld3oWnlrAIdphmse/WDYYa98Y5Z0wVBScml7RHRDntIkF/fy5u1zW?=
 =?us-ascii?Q?cOJcvUhLsQEuQxV9Lm+8uwCIJtAIx7yMjGw2/55//OPn6x5slUSi0S26gP/d?=
 =?us-ascii?Q?RkBPjoyO2HxfEClmi0c3TODG/tIJL6GKHv24G/6XT/ZBR56Gb/2Tng4kFw6p?=
 =?us-ascii?Q?Tvi1hz/lmF3Ud+1tVzHw6PJeNl5jhmX3mminKBD/htBxrvWZs4wEdSXAYMAH?=
 =?us-ascii?Q?XUNwySA5v0znryo6uf8bpWyv8JHSpTOgujSfw+okTNbCrfjtodi/iHRcUKgJ?=
 =?us-ascii?Q?3s/ShF6jyuSBvqX5k7pSR+rsvtOTVd08DiGE94FxuVNyHbU5Lqdebt/wggZ4?=
 =?us-ascii?Q?2IUcxEaMvSHCuBxzikZtKLjPIabM+vGTWBfqw+1cA2P58bXGl2tUIBvlQ1GX?=
 =?us-ascii?Q?2q1QqhAibHNu8WUcr1QEIXrHIPwPrV2/0Jhg15Xpt2CtOC37xTv5nNhcvQyx?=
 =?us-ascii?Q?j24+cFJ0K81vQFLItG5nWpaHXLlUUglRD5b2HEtGV7Q5dJxqUvzjZE3g+whK?=
 =?us-ascii?Q?ffmrQWsR2tmXcN1HNvOKvhQ8srtxdOiqDwBzUFxkrIx8Lp3StD+wPlpFXyvX?=
 =?us-ascii?Q?CvNvCdBHecm1Kvx/nSe38lhHL8CM8A/DfZIclxTnzYaY10NAupQwC/6G/jiY?=
 =?us-ascii?Q?KrwlKCyend0g+ZIG9geKDrHUB+6p6Jkg460YKzHnNhqrqtdExgdpG1NHm38/?=
 =?us-ascii?Q?PLfsT8NpjjA0Nkxvy+Cu+R+1sW+W3K6I7QSAod/IxWbv8fDXnN2Bgz/+8ywp?=
 =?us-ascii?Q?QLn4vD2o0EHmNcESEj8Sp1YvDvQKNTa1Cv6wqn43dqfy+XWGWfctvdVw3doL?=
 =?us-ascii?Q?nAaZ/guREE5Hsfq33i3GWw3CEopg7peE1/BN5uTpMvp12DvIUlQDP0iH8JjG?=
 =?us-ascii?Q?MgE5kkU7GbPJnmB2imNvi8h+wrXEpTKPguqijln/nlJFUf2aM5nFYE2/2+NN?=
 =?us-ascii?Q?a04/SOWABinorziDeYsOi3ugiQceLDeBtNRA072o31HQbDAxQPMk5JPyRplC?=
 =?us-ascii?Q?K19bux/+gdYPpk9IALgW9VTAD6WaZKzUKU3eyo7hy3VouxCoYUsVlF1dnIBy?=
 =?us-ascii?Q?OmFQPoaSuo7RCCI+d3WyPdf6DVvA7T2bqlJnoTJcluV/oR3CkyPexh/+p4yC?=
 =?us-ascii?Q?Pi3hj8E3vobvhjowMXRKpQK7wUVeC9u80ZFN5/dgu9v53wbPTLA6WUDtmWLp?=
 =?us-ascii?Q?EJ3lu8hAXBI2XA7jt5UiIZwt0xHaRxTlXPoM3d0MbDwndqy/qP3hG8Vkhnhj?=
 =?us-ascii?Q?nHssUcqUFENNDdZbny+bhe1daVu7bHFpHFnvaqeDjTkA3h6/HEzFkfpEMeN6?=
 =?us-ascii?Q?7ImWWfTEQIyX3hgnlDNFmiGEIfcZVsJCVCCQvUJjZr6VqPN8rBUg8N+dlMKa?=
 =?us-ascii?Q?81FkxdqZ73yVY2Lk6HQbfqRywHCaNfPyS88CHlcsIKEt/qbVCRItrwZOLEj0?=
 =?us-ascii?Q?78iBiFK5xplZyNx/sOUKw9sEa/Uzbu1YI70GeFuLOMK0VLg7n6f4Np54mah9?=
 =?us-ascii?Q?2Gw1472Tj7VaemtWatPGxiSG84BCD51PgBMAXB1j4+kN6SV5Zp6129JX4dEZ?=
 =?us-ascii?Q?9RhyLTxwXY0b+ncJMXpLXR5sJm85vGH3+WDPaePj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fbe30db-e745-4456-a938-08db0d559e16
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 00:02:37.8567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lyh/H2oMBbUCPzZJo3LjXrP4Ngu/0sNTqRDS+sp9jqlnA+9u8hBzTI/Q280UVELO2eTsJ5DbJ8P3gerD/AhglQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3704
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
> Sent: Saturday, February 11, 2023 5:41 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
> <decui@microsoft.com>; davem@davemloft.net; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org; linux-
> hyperv@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Michael Kelley (LINUX) <mikelley@microsoft.com>
> Subject: [PATCH net-next v2 1/1] hv_netvsc: Check status in
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
> Changes in v2:
> * Add rate-limiting to error messages [Haiyang Zhang]
>=20
>  drivers/net/hyperv/netvsc.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 661bbe6..90f10ac 100644
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
> nvsp_1_message_send_rndis_packet_complete) &&
> +		    net_ratelimit()) {
> +			netdev_err(ndev, "nvsp_rndis_pkt_complete length
> too small: %u\n",
> +				   msglen);
> +			return;
> +		}

The net_ratelimit() condition should be for the error print only, not affec=
t
the "return".

Thanks,
- Haiyang

