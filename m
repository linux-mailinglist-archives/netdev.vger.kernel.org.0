Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633AC5020FC
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 05:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349156AbiDODuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 23:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349149AbiDODuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 23:50:15 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020022.outbound.protection.outlook.com [52.101.61.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938BF5AA64;
        Thu, 14 Apr 2022 20:47:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbd/kJ5mtka8g4o5Ey8Dw1R3IkAhPQ4y2RQPNgrlLutI3vkTS774b6fLT3Iori1pEBZrBWLVTMKhfMNBgioNrIRwz82YIWolrSiUMraIuu3hRju6FU4sDWpCUtQP/Y6IzMhfeG1QAf8j+uzPIVtOALQVlW7RHjI4qwdfY46ycigHqOqY6/4ep2FqQ0cgAKN8J0q04S9y8+EQ+jpMu5QigBDxKCjqg4pKGW1GSiRr54cqb1wHH1m/RV7WZV/Pek14u/77lYccWo+dt2j89op3CNBP/sc456HTt0IapQbDJJkS4jZLVsoNKvQgPaP0FSje2QR0r3Ho/5Mi8f9OvD/BPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gdns2GV/vxR07Jn8/OPo+E5RFbxofHcuv6+F5KYr6HI=;
 b=XhICG79WzvpcIZeLgvKcPkUsjfhAoM/UY923t5fZC1xkeWlen+pkf9pvU6aDiT79qRquu3EpWN1RE2KGlZoxFs6oM37iHpbAzVplj6zC9M2BZbaZRYHh8NEU2E2HOHd8oipJWkZj2rqFuIfkaJD0MEsGz5F4iGV0rNz+kpukd7S9jf+5umTSCjUY+FSZ6CfaLPWlrp129IUlT84BIj44ZxCGkBEF92iwPXLKD2a6amYWJSeICCZK4F+F7L1rQtW/E2QQf2s77gNHX/lZbm5YncX5Dr/BLlk80VCiiZw0ZPkYt60ofl3x+JEyEmsMspwEk0FplVQi9jTnlNZUUzx1Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gdns2GV/vxR07Jn8/OPo+E5RFbxofHcuv6+F5KYr6HI=;
 b=Ti1GbGI9ROxrjGWGRtsVGoU+7r7utFDoVKYA1gT7e+nKrGyW/dQBx1XkntkmLl2pa8OU3qdRUVvqJ3v8/TWrBT6Y2OAHazztnqlTa58TTp/z8/lWeHoOm3clnPI7TamzartuZdi6p8vKho4j8TuJhEClVopbLkwAEXlzwP8VBYw=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by BL1PR21MB3256.namprd21.prod.outlook.com (2603:10b6:208:398::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6; Fri, 15 Apr
 2022 03:33:23 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ac09:6e1b:de72:2b2f]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ac09:6e1b:de72:2b2f%9]) with mapi id 15.20.5186.009; Fri, 15 Apr 2022
 03:33:23 +0000
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
Subject: RE: [RFC PATCH 1/6] hv_sock: Check hv_pkt_iter_first_raw()'s return
 value
Thread-Topic: [RFC PATCH 1/6] hv_sock: Check hv_pkt_iter_first_raw()'s return
 value
Thread-Index: AQHYT3fFI5IGSfWvX0SxiF7md4+Se6zvlcGQ
Date:   Fri, 15 Apr 2022 03:33:23 +0000
Message-ID: <PH0PR21MB3025FA1943D74A31E47B7F8FD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-2-parri.andrea@gmail.com>
In-Reply-To: <20220413204742.5539-2-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ae6a1b47-1f37-4cf4-91b3-8a2f01cb384e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-14T16:11:49Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1eaa4941-f10c-48ae-9efe-08da1e90b1e4
x-ms-traffictypediagnostic: BL1PR21MB3256:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <BL1PR21MB325616E435751CF21E0D304DD7EE9@BL1PR21MB3256.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c+9OjzVMlhr02g7uzdWP7ZJespKC1N6G8F0IeNEnq8OB1SlHszX3o5O2+tdBnpP5sZPH6wI3wYZeUj9ydwVqhfcCu4DAutwaIN9MCCCF3cpOV9Kk8JFaQhIJd0pYhv6nobEGulRbh0RoR2Zr7h47nSZsC49hNDA/O8sM6O95BDtq9ZlIjoE6nik0rLKGi+IHiz3h20RnC0QXxJd1k9icGGIA3jpWAOFCPF5arjVB6oseUMuolYEx0o2XQQyLtU0V9Yp1ak4oso9y+s7748X2uRYEj0e/+sBljSt7Lj058GmjWh3D9sIsazGv3FUdVyrNfxRDUvAiHxeU9Jcx/3gTmy1LcHYKhJNuA+TkPkJ5rH8dj8Ygplj11oEKfTt/qImzCuDP+sSnU0E6Q8+aCLV+Wn69EGXQhz2uNpBgqgnuIYtekNBbUtBsIa6CLfyEEtO1w+v8Ptt5Oh3JsekRtcpxoPeASqkVyVta2sAkgMBAOMtGovWYkc91LPBoncwWyrUR0v8w1L6yTSKWSZqqVLj8X5FWdfDgfR2HZPaL6HjOvTO/I98ti9p7WXk6RM8mhraGSg2cdyS2xGDuL1bwzRnw2H3Y7NzS71CkpFs1UKbSNAJXyjK7TOAoK1rGye+StVa2kJGTV0oLML0v3AzwVS0uxaFLWsWHygutg3ATX+l1ByJyJzJ6gg0xwN6H9tUXjW8svdjnVK+yhCHBqa6FlZWYfQGWiAv9wqKX3hpZMaf6FtKzWe0n8aGfhFr/febq5zi605MevtkYF4VMVl3IPSkidQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(508600001)(921005)(55016003)(82950400001)(82960400001)(38100700002)(38070700005)(10290500003)(66476007)(7696005)(122000001)(6506007)(316002)(66556008)(66946007)(54906003)(110136005)(71200400001)(76116006)(4326008)(66446008)(64756008)(8676002)(86362001)(52536014)(8990500004)(83380400001)(33656002)(7416002)(5660300002)(8936002)(2906002)(186003)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lwmAu0H9bIVwL7XRweFwPUa3Dt1w3bJezNvqMUa1/g5MMQCOMw2sTO2Gwo1S?=
 =?us-ascii?Q?weEMMTZxKq4IbiNSzauhvrMAb+Wdc73p1N3XaUR4R6PaMAkW4WK+INLVj5lx?=
 =?us-ascii?Q?2iP5xDSF/C8+hvflnaeKvfqDI6Wj3IyJoG2Uq+EBWlYZkbLMgzaKt35LJwwA?=
 =?us-ascii?Q?KKVp2lz3hb4UV/+olxACBetBjMJkyo74HaURj3RTYJgciJHWfFSoOkUqGvt/?=
 =?us-ascii?Q?PL4Cy3WTWhPsoCGuO1Q8KHOxq5h+DU0Sp2LVl8B6ne6bL5pAGTahM+PKcluK?=
 =?us-ascii?Q?S8w9YBEaWnTpKBcPX+OQyqb7IrxvxY/iQIZ2wXwCdeQqscvi3mThVi+ffbWn?=
 =?us-ascii?Q?oLj4rqPeBEEyPHU18r24EhFDAgMiQfEZKFKAga/si98BKw6gs4Vwgzew7U9I?=
 =?us-ascii?Q?Xkq4IuhIoqWGUZj9Mj6coMDcun3LMKveYOnrgpSkJPhIUb+XK8L2H2IpCUuR?=
 =?us-ascii?Q?7z+LCJFG/G8zPA551FpTh2+Xo2p0BggZZ6sbnp8aqRgIeedD3KZDJw6mNQS9?=
 =?us-ascii?Q?wN5kgfilXqXh4pLHEattwV5fbJ2bI6hF8WhATd1PwN3Aalg2SSr4tZZDKo6B?=
 =?us-ascii?Q?mhYFpcPdM8DcsTzI5PUSwQ2dpGnUWrsS62Yyfh2GMcpVGWPj+XxXvY7XeJQ9?=
 =?us-ascii?Q?sSO4qOaYSe5CbF/xyrzDP8bOOoJnM+NpqZQm3gk4jZdKoXc/Uc92CcFiT8gg?=
 =?us-ascii?Q?isz34HdPJHr2UhK2/etg/lJZF7sVj3I3C+bQcP8uuTZbK+KJplmP4Z9Pp3+4?=
 =?us-ascii?Q?Y5EgOVG+2nkvvloCY0yADNAn1Lxe2gt/xtjKeq8GBZbrbJv0IhawiNq6QKVa?=
 =?us-ascii?Q?cetE9R7DWmdfv6hp/VAvE+4aCwnU6a/FporLz4d6f4DHeqOSYC4efpEWbYl6?=
 =?us-ascii?Q?4SgGFuSe1946wUzT0wnV5kaDHghS7VGcThkGFLLYPkHRKtrxTI3Gt28h2TAg?=
 =?us-ascii?Q?vHCvAaUHMImZY+I1E+SwrZXrNKVk3Be5z3eTxfUT8VapaUwFVsjZC1D/+cSC?=
 =?us-ascii?Q?ARGNuoNYXYwYdH1iwvUqpcl2t9wxH+PNt7LVFpWUd4GRnY1oSfYPtgy4H+1t?=
 =?us-ascii?Q?IfWT8nLwcHDTpjGGDmthi2qACSfEgZDN+WBtl6whPNckKXs6Y8v/BEax6phg?=
 =?us-ascii?Q?POqTypWxtmVZKVt+OvME9Vy0qB0ezuD7/fMPBZdGQ4Dm5zSxsr15TcgIO4Uy?=
 =?us-ascii?Q?ZlS+InKjxI27v1SUYBwi+e1cn4lsm85PT11RM+wqA+HzUQBtG/5VmjV58Dps?=
 =?us-ascii?Q?ihVLZq/ZF0CjmjbwqLjW6FHPLWZMVpWPLMJ2CdKqVgv4UwstGZd3nWnlwTE6?=
 =?us-ascii?Q?qwCcG0qi5kTTZWsZdygepCVdIVIy9Q2Jgp60Hbk2AQCtMuJIJM05ivNtQfF5?=
 =?us-ascii?Q?l1YXemzNIIzTsKA2ssbmRkGmYsWzKKllGsNA5kXHQdPKu8eb4R/Jwm22VS/8?=
 =?us-ascii?Q?7rHbf4sqtdTaEKfIaTM6gv10EXuWRuK4MomV0rgloUpSm8iCSxJJwy+ow0oS?=
 =?us-ascii?Q?GgKbx3VBf91qEW/NR7Xmb9aT0yFevUjB8aRbQgJz3+bnIeLhiHOijK4P6/Cb?=
 =?us-ascii?Q?dqhp8pjMuA4FQ3QnhjLnPBPih9WnzIBnVNGwvWVPPrGMuVLsR9KxzE32Vyug?=
 =?us-ascii?Q?S8S3/IfjrrWt/svIfIecmjhzhRPBnltqyiDnogts3AXe1N3jydsqQzyJgsMr?=
 =?us-ascii?Q?FOPO3nZZcAyCfhU07PtDLaA2xvf0KFq8b9jtheu5Zzi540V8tW3KJE0zoOvU?=
 =?us-ascii?Q?rsT54YFz7rvSd9+mbpmKfPBWXM+2OOk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eaa4941-f10c-48ae-9efe-08da1e90b1e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 03:33:23.4570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m2bEU//ObcVEr0tIqBfFOVeorqBCuN3zi0htQ4tPGjmCckGmJyY6/XZKuYEv7FfiuLR8AEb5ETovO1R7VdUkbYfAMNXNEceOy2DYSd4QV0M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3256
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Wednesday, Ap=
ril 13, 2022 1:48 PM
>=20
> The function returns NULL if the ring buffer has no enough space
> available for a packet descriptor.  The ring buffer's write_index

The first sentence wording is a bit scrambled.  I think you mean the
ring buffer doesn't contain enough readable bytes to constitute a
packet descriptor.

> is in memory which is shared with the Hyper-V host, its value is
> thus subject to being changed at any time.

This second sentence is true, but I'm not making the connection
with the code change below.   Evidently, there is some previous
check made to ensure that enough bytes are available to be
received when hvs_stream_dequeue() is called, so we assumed that
NULL could never be returned?  I looked but didn't find such a check,=20
so maybe I didn't look carefully enough.  But now we are assuming
that Hyper-V might have invalidated that previous check by=20
subsequently changing the write_index in a bogus way?  So now, NULL
could be returned when previously we assumed it couldn't.

Michael

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

