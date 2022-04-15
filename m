Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78880502111
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 05:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349245AbiDODxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 23:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349272AbiDODv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 23:51:56 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020016.outbound.protection.outlook.com [52.101.61.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C517A10D8;
        Thu, 14 Apr 2022 20:49:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0PkqUUY0/z2YJyXCgJlgW9bDt9GHsfujBjYP+VIIhIKBZg39gJCN3wYRCNpjh1DkoOocgRvVtCk9933d5FiTfiPHbrNTv+GPB/yZbF7hoIwrTCJAsJGxNZ6q7g7Xu1PrVf95hAD3ncGAUQkdkPFk+gv8aDeXS8bN+ASmgr8H7omdm68ie041goBbKmcP7U0OPUE4SqXIBOAtQqBzGbXkz4Qfh40mNJQmLpNt5Jz3Md2WE+MFU38rhHqeDmKX7GUtQs8juoVzl4IJIRy25XhgtN4tAARe8WwhrlQrg/dRAiYFGC6CI0arTBiLl6k54uYEg7nslCTQKIVHlsOegxrvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oE+0kcG0nFf4Cp8FAxuuPilphi0A3yjSQGaZKt4gk8s=;
 b=YFHM2FrLTFgrgnudsvxbpKkbs5JY2n8RCFc0axbqrtLeCGH2o3Gzdpo3m9fa4uV8KDIMKTnrCgUEj3JQDfYatwNy81iF+yMqevUnoXE8Q0ERb9OJvyGN53/kNQIBc6Y4xGvDxHxCj7SwlfC+dQQMTKJgsb9d5mFtrLzQ/jH/rM3Hw7i3SC3tfbj838V2DdLqgucOa8TCQ8UozHApfY2PlC97Pt789B3axdYgiSpAzM8LucHhRgJqvBI5Q8DsW1xDneWACaxLX5wyZQ+W/3a/ed22BvLqUeqpqU0tfy+fqVtnfiLgCfH9dDo9tRdrEl83eCOMy8Eq8PxKB6jKMkkaXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oE+0kcG0nFf4Cp8FAxuuPilphi0A3yjSQGaZKt4gk8s=;
 b=doFpP7dTn1tXHEXP/G2A7c90RkgUNeyFYzExvEmkUEp2CAQXjYhLN5r2YaLQ1hjq5MyfBe2FacYZk7Kwv0cB6ZVkmoScanqB1fZjLxnAT+FCWG98DfZlCCR4vuEy1EgaCO/CIj023kKz3FR8MBHjBCyJyrHE3jIEynSfeS4JDds=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by BL1PR21MB3256.namprd21.prod.outlook.com (2603:10b6:208:398::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6; Fri, 15 Apr
 2022 03:33:31 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ac09:6e1b:de72:2b2f]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ac09:6e1b:de72:2b2f%9]) with mapi id 15.20.5186.009; Fri, 15 Apr 2022
 03:33:31 +0000
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
Subject: RE: [RFC PATCH 2/6] hv_sock: Copy packets sent by Hyper-V out of the
 ring buffer
Thread-Topic: [RFC PATCH 2/6] hv_sock: Copy packets sent by Hyper-V out of the
 ring buffer
Thread-Index: AQHYT3fHt6IPwxyLaEamUw9BuXqN2azvm6mA
Date:   Fri, 15 Apr 2022 03:33:31 +0000
Message-ID: <PH0PR21MB3025F86E824A90CE6428BB2FD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-3-parri.andrea@gmail.com>
In-Reply-To: <20220413204742.5539-3-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b8dd29c2-f8ef-44cf-8da9-9362ec2aa95a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-14T16:32:57Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cd38c6e-be81-43e9-58e5-08da1e90b67a
x-ms-traffictypediagnostic: BL1PR21MB3256:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <BL1PR21MB3256B4DC91B16423267E5603D7EE9@BL1PR21MB3256.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kads88r0HXV2YbL28pGaNEAwjdoRXXU5ajNcXRjuQHJSBAqLZ7Qo3brVTRJVxke+r5W9bnijPXcV5RKy7vnsBelNsX6RiaWu42ubGuyg+Mq0W7YxFxP7Ruum2p1TbvBFkRVGrWUzs12tJzi3uQUiBwopPwGSfRY016OGfC49gRSHN0cOZttHGDopv36ZEScOe8/QPTQDFzguHNIPGnBZXJasjoHgKXkr9tzebB+FqTwt4+V2ARErNreav6MLkboMSFe6c+cf88nRERgQyZFzNAC3EsDgkiKVMkpc7Dqf9KNlL6fRXC5vTQW8FNHw282l0wqpXhM23u+MDoXEXsCIzEAFQsP8mXNQt328JvbU8noZjy2qHQxcHfTu3MSySyXNpGaws2kqBWa5s9AxrvyWpNAEc+RmeJ452RvYGxAY228rIWRbACIuN4oshRE1cxT3je3cUhfOo+B6fR0bmyQzxYB66srFu6rUnfRkoM0Xh/sLH+JUt2qNhMI1aaJHy2dFxvu7r4d8A0FkkGw2o5aTTMB4d7a6JAjJuiQbto0S2076t0AIVvl7W48bp192J3otIdlMSCCWT1FreWp0fBt14Oz4UTxchWyCz1xvjnaGou19AFkkSQgQjZFM56MDHFkCNJw0NwhMsHM9nSZ2v1tFfhaQm02MXrIPCFLsaFm/ssW1A68Laq2VhzevQwvGIJZ5keXvPxU44kJU2BAOASoHLJQyn2HM7SilCAKzNeDduavRBuudEO/515zC+KF9JBcJV9kRkFL/iHxNQ5aByGEXYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(508600001)(921005)(55016003)(82950400001)(82960400001)(38100700002)(38070700005)(10290500003)(66476007)(7696005)(122000001)(6506007)(316002)(66556008)(66946007)(54906003)(110136005)(71200400001)(76116006)(4326008)(66446008)(64756008)(8676002)(86362001)(52536014)(8990500004)(83380400001)(33656002)(7416002)(5660300002)(8936002)(2906002)(186003)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?t8hsaQP7PAK+6m+GQlocH4TIP12pgIu5Lc9XREKWchAP0sbdA+tBZgL1oEE/?=
 =?us-ascii?Q?JQ+U9QxJM1925jlnkJTMMg1VvpBxsii2q4WDadRvvf1Y6V4RGHPDCnz/2iYH?=
 =?us-ascii?Q?HEPWJylRfgemk9BYx3ho752/AJkx9TfhlWQhK2ycg0S2mzbX2wBI6Lfer91n?=
 =?us-ascii?Q?DSlG72J5rVA7MaOavijgjcr0DcZrLQNmcdzTXPN9qoZcWLbxIGZS/XB//C2N?=
 =?us-ascii?Q?nB/tpYefJgPOnMpr/A82A4PitvYw7H1oyku+Q54vAa2pYqXW8fCNmzu8GW7H?=
 =?us-ascii?Q?IkBASu1El7XKRXNIqXAjbVSocQH4q/5iNx9/Y6xRMfcH1n97z6wH1t6uqeia?=
 =?us-ascii?Q?6hXfhp2NgeizGOIQMc3kPD0rRnjhwvey7tyZOcHj4VnzxabLhMrrckbww5z+?=
 =?us-ascii?Q?vmFs23XQK7WqZLkGZuAJiwB+s4CWOaMkaevDPmomg00plkFX6/EzTrXiiJMd?=
 =?us-ascii?Q?SbWHqMaCZAl12lm+WS97AY1zdqO0KBIdIZxrZ7H7NWcDWyRxWBby/1sAuW6f?=
 =?us-ascii?Q?1XHVbEnYytQUxYTyL99KTfO017RDUlFX3z0Z7NCghNprkjgubkOr1ZnoNFGi?=
 =?us-ascii?Q?UNxLIyv+2h5b9MMTKQ0duOIRNIGkGTDzJPF8N6FtVEvPHqMotZ1iYlRvmO+L?=
 =?us-ascii?Q?0SAG4f5xCJLe2A5/ylJaoCZwfYzkmIPI6rqcenc2auZSN/+pDx/RHUJlyQcY?=
 =?us-ascii?Q?xgMudkHA0NG/BNEyWbO/G5b+roT/u3+28P4oLkSdDSjGbT50eHidV/PVeDkv?=
 =?us-ascii?Q?XTMnxgYS1bLx7JYv1sJB507uq98n/Y1NdNjVyfBGI9a2doh5GDM4m1neFJQ6?=
 =?us-ascii?Q?wzGjZ3oP3XA78xj+/5ZjQbv2ASJEzHDjtl3jju1hNMkG1Yh0viOyRC3EOQ3X?=
 =?us-ascii?Q?898qYbmJLA2/YR5L4GSsp4Tz6H/zlPEfwMuYiFAopokmBij3gPKpy0TBlAOy?=
 =?us-ascii?Q?1BTi8dwM29X2jH0BvQ0/Bb+L0KUpxg3DcDU97rRN0j41QzTfC4cQwIN30As7?=
 =?us-ascii?Q?88Emlcrw0t35/MBOGxCD11t+4Vk5r5YzVPVf1DOMFviRiTdXIvtpR9Hy8Wqq?=
 =?us-ascii?Q?li5SfxczZDKCwMrYupuyEC0R90y6Uu81FQcFrLwewR1S2Z4rTj42sZ4Qcy4U?=
 =?us-ascii?Q?JR/nmfdsGHxzJNebb8LdqqaMDZDtX9ouw2T9WHoFLioETxQj7UMMMuStZRfp?=
 =?us-ascii?Q?oJ3hXHYuDQGMuApX+LigYTYwHK3Kas0pzpkOetG3EHOkwmstEuEelvtW93+h?=
 =?us-ascii?Q?g/ouV2FKJw67zttfiuq9kSXU66EV/TpYwxqT+2EfUqXafbz/JIbBlDdPp5Ve?=
 =?us-ascii?Q?6vPECnRCNF7MDV/5ks68qHdlifV33vMbbdc894JGkowNt3DCzUZ4xMr7uWaY?=
 =?us-ascii?Q?ZAiJ5sPLbUHXYg+v/whri2CtuF9iQhNDkqBkUObg7/DH2riaj7ejkwUTouzo?=
 =?us-ascii?Q?uuAtNU7dq/J0Gt9H+IsLV5uck9A02gOPXBOpFSlqS/Ns07kfE6M5ih3ZWCsO?=
 =?us-ascii?Q?Ol6aykCpLhr+zCorrU9GaSq8OBvrfEVbojg4fHpc+1Dot2NEKinAaPmvPzAI?=
 =?us-ascii?Q?rUe2Fzm394DJ+wYOJJw01QuVvd8cZASMy7ts4kYLNTJNjUt4aaHhygw0ykXu?=
 =?us-ascii?Q?GNs3jA/YLeHJwqnUsExW+KhektWFvK4Y80+zIOB+3pk9OvuqBK7YGvmHe+d1?=
 =?us-ascii?Q?nY7fNOQ3sQH9Elb0f4IySmgRJJM67U/RDAARaSpsMkrzTiCLiC0rRKUdsGag?=
 =?us-ascii?Q?zerKIfKVmdpldUWTicjMqkN9o2HA/mE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd38c6e-be81-43e9-58e5-08da1e90b67a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 03:33:31.1691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n4l5Wudax8u/pfqvewKVC2dhFwWRhdy4x4AzJGTmykGgXIqN1WEthxuEeaP1NZktCSKN0C9z0wP88Vv05bm91hJ9YmSPQX4OmeeJetKGzSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3256
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Wednesday, Ap=
ril 13, 2022 1:48 PM
>=20
> Pointers to VMbus packets sent by Hyper-V are used by the hv_sock driver
> within the gues VM.  Hyper-V can send packets with erroneous values or

s/gues/guest/

> modify packet fields after they are processed by the guest.  To defend
> against these scenarios, copy the incoming packet after validating its
> length and offset fields using hv_pkt_iter_{first,next}().  In this way,
> the packet can no longer be modified by the host.
>=20
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> ---
>  net/vmw_vsock/hyperv_transport.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_tran=
sport.c
> index 943352530936e..8c37d07017fc4 100644
> --- a/net/vmw_vsock/hyperv_transport.c
> +++ b/net/vmw_vsock/hyperv_transport.c
> @@ -78,6 +78,9 @@ struct hvs_send_buf {
>  					 ALIGN((payload_len), 8) + \
>  					 VMBUS_PKT_TRAILER_SIZE)
>=20
> +/* Upper bound on the size of a VMbus packet for hv_sock */
> +#define HVS_MAX_PKT_SIZE	HVS_PKT_LEN(HVS_MTU_SIZE)
> +
>  union hvs_service_id {
>  	guid_t	srv_id;
>=20
> @@ -378,6 +381,8 @@ static void hvs_open_connection(struct vmbus_channel =
*chan)
>  		rcvbuf =3D ALIGN(rcvbuf, HV_HYP_PAGE_SIZE);
>  	}
>=20
> +	chan->max_pkt_size =3D HVS_MAX_PKT_SIZE;
> +
>  	ret =3D vmbus_open(chan, sndbuf, rcvbuf, NULL, 0, hvs_channel_cb,
>  			 conn_from_host ? new : sk);
>  	if (ret !=3D 0) {
> @@ -602,7 +607,7 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *=
vsk,
> struct msghdr *msg,
>  		return -EOPNOTSUPP;
>=20
>  	if (need_refill) {
> -		hvs->recv_desc =3D hv_pkt_iter_first_raw(hvs->chan);
> +		hvs->recv_desc =3D hv_pkt_iter_first(hvs->chan);
>  		if (!hvs->recv_desc)
>  			return -ENOBUFS;
>  		ret =3D hvs_update_recv_data(hvs);
> @@ -618,7 +623,7 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *=
vsk,
> struct msghdr *msg,
>=20
>  	hvs->recv_data_len -=3D to_read;
>  	if (hvs->recv_data_len =3D=3D 0) {
> -		hvs->recv_desc =3D hv_pkt_iter_next_raw(hvs->chan, hvs->recv_desc);
> +		hvs->recv_desc =3D hv_pkt_iter_next(hvs->chan, hvs->recv_desc);
>  		if (hvs->recv_desc) {
>  			ret =3D hvs_update_recv_data(hvs);
>  			if (ret)
> --
> 2.25.1

