Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94F31A66D
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 05:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbfEKD47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 23:56:59 -0400
Received: from mail-eopbgr1300121.outbound.protection.outlook.com ([40.107.130.121]:29024
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726038AbfEKD47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 23:56:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=M+AZrEH1pzffRIluNPfvKVpvGEbRZjYZ7U0BArkiSxXDX2YbWkmkMbiVUgYN3885tagxtVzSyq+n8QrKUFQovxK5Wyc/jRLejCIm0XyiTrm+xGbVdx2GTCTaivGgTn98/DoYPHFyHpsRWcbr2ENKsKKY/IDmNXk0vHIW1SS4kcg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/o9ZuAf4kk90Wx3KPTIRfArq8OzkhLWeEOumezWrWgY=;
 b=r7vLnHHYATqSyMqsXmLjsA8mHJG3llOz5SyjQtCH0TWWSuVqvVAH1dT8oVuVu9B9Vv9n7YqYA4MskvivarwbYmRKUBxZQ7WKtxKAXEhVBiuxJVCr+Ba4O4sHI4kU4IKlTCZ6NWBdkpgncsX0u0UNTkpF9Rm/Qs0F+SpotFw7YTM=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/o9ZuAf4kk90Wx3KPTIRfArq8OzkhLWeEOumezWrWgY=;
 b=bi2+BqDDVsFPRxNI8jc6gY4lmDHyFEUnyl5WsUxpuBINQFa2bPU4ThjyhEcjNHZRsrbd2uF4So61DhNrcEczecmxEx23UNAnk1s8Cq0lm9Tr3B8ew8z+ZN9txOvjcwjOVV+7Qw3AC/CzOAAYTiQ8vTlYQodGAOYaOLYHsrgvd7k=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0155.APCP153.PROD.OUTLOOK.COM (10.170.189.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.4; Sat, 11 May 2019 03:56:49 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564%4]) with mapi id 15.20.1900.002; Sat, 11 May 2019
 03:56:49 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Sunil Muthuswamy <sunilmut@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Kelley <mikelley@microsoft.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hv_sock: Fix data loss upon socket close
Thread-Topic: [PATCH] hv_sock: Fix data loss upon socket close
Thread-Index: AdUF8eO/rXjnGSU+Q+iHOcDDYgexQQBncSCg
Date:   Sat, 11 May 2019 03:56:49 +0000
Message-ID: <PU1P153MB01695C88469F32B9ECC7657EBF0D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <BN6PR21MB0465168DEA6CABA910832A5BC0320@BN6PR21MB0465.namprd21.prod.outlook.com>
In-Reply-To: <BN6PR21MB0465168DEA6CABA910832A5BC0320@BN6PR21MB0465.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-11T03:56:45.2460723Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cd20b9e0-8a1f-4bd1-b9b3-e337b3c76db0;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:d471:db70:ecbb:48f6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08289d13-b47e-4b62-e9a0-08d6d5c4b217
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0155;
x-ms-traffictypediagnostic: PU1P153MB0155:
x-microsoft-antispam-prvs: <PU1P153MB0155F2C137B2804686A4E2AFBF0D0@PU1P153MB0155.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00342DD5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(376002)(136003)(346002)(366004)(199004)(189003)(14444005)(476003)(446003)(486006)(76116006)(11346002)(25786009)(10290500003)(478600001)(74316002)(71190400001)(229853002)(256004)(71200400001)(52536014)(66476007)(66946007)(9686003)(55016002)(8936002)(66556008)(86362001)(53936002)(66446008)(6246003)(4326008)(14454004)(1511001)(5660300002)(64756008)(305945005)(7736002)(8676002)(81166006)(81156014)(86612001)(73956011)(22452003)(33656002)(6506007)(102836004)(54906003)(316002)(110136005)(99286004)(10090500001)(2906002)(76176011)(7696005)(46003)(8990500004)(68736007)(6436002)(186003)(6636002)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0155;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qFNcQHn3xvfmKC0nktRX7otKf9x/Md63EyiTAS+aEJzMZu1pOOIpBWy6kNdEksxKXwZjrYB1Bc9NAdTCQppHVLCioDWh/V54o4oOryCpX1m1pnV1//Kw1Y6x5on+z132npgSK5rXm3E9Ly2ZMeOt1s4cfFTOmzMh+95STyMYSdGSiaK2/I6OixBBUjVxQJR7FofG8o0beAbLJybIT0PbvRzqI1Pu8YvCudwy8pxZqZeaQIOgfIbFg6S4VWsyByQrL+iNCm81MX5RKEJvunF64w5nCEgZO6wF5HmvWGws5lOPncmBpSgr9aNHLSxTR5uedQErUGb1WglECSnrcPLM3L+/pidim0IhVMz+qgYcA0Rhu6fd3hyUiTcn0mbDxiM7xV5aWNeSZPMk98fCmf+gaHMDrA5iLmtQocMB4mTMfdk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08289d13-b47e-4b62-e9a0-08d6d5c4b217
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2019 03:56:49.3404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0155
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Sunil Muthuswamy <sunilmut@microsoft.com>
> Sent: Wednesday, May 8, 2019 4:11 PM
>
> Currently, when a hvsock socket is closed, the socket is shutdown and
> immediately a RST is sent. There is no wait for the FIN packet to arrive
> from the other end. This can lead to data loss since the connection is
> terminated abruptly. This can manifest easily in cases of a fast guest
> hvsock writer and a much slower host hvsock reader. Essentially hvsock is
> not following the proper STREAM(TCP) closing handshake mechanism.

Hi Sunil,
It looks to me the above description is inaccurate.

In the upstream Linux kernel, closing a hv_sock file descriptor may hang
in vmbus_hvsock_device_unregister() -> msleep(), until the host side of
the connection is closed. This is bad and should be fixed, but I don't thin=
k
the current code can cause data loss: when Linux calls hvs_destruct() ->
vmbus_hvsock_device_unregister() -> vmbus_device_unregister() -> ...
-> vmbus_close() to close the channel, Linux knows the host app has
already called close(), and normally that means the host app has
received all the data from the connection.

BTW, technically speaking, in hv_sock there is no RST packet, while there
is indeed a payload_len=3D=3D0 packet, which is similar to TCP FIN.

I think by saying "a RST is sent" you mean Linux VM closes the channel.

> The fix involves adding support for the delayed close of hvsock, which is
> in-line with other socket providers such as virtio.

With this "delayed close" patch, Linux's close() won't hang until the host
also closes the connection. This is good!

> While closing, the
> socket waits for a constant timeout, for the FIN packet to arrive from th=
e
> other end. On timeout, it will terminate the connection (i.e a RST).

As I mentioned above, I suppose the "RST" means Linux closes the channel.

When Linux closes a connection, the FIN packet is written into the shared
guest-to-host channel ringbuffer immediately, so the host is able to see it
immediately, but the real question is: what if the host kernel and/or host =
app
can not (timely) receive the data from the ringbuffer, inclding the FIN?

Does the host kernel guarantee it *always* timely fetches/caches all the
data from a connection, even if the host app has not accept()'d the
conection, or the host app is reading from the connection too slowly?

If the host doesn't guarantee that, then even with this patch there is stil=
l
a chance Linux can time out, and close the channel before the host
finishes receiving all the data.

I'm curious how Windows guest implements the "async close"?
Does Windows guest also use the same timeout strategy here? If yes,
what's the timeout value used?

> diff --git a/net/vmw_vsock/hyperv_transport.c
> b/net/vmw_vsock/hyperv_transport.c
> index a827547..62b986d 100644

Sorry, I need more time to review the rest of patch. Will try to reply ASAP=
.

> -static int hvs_update_recv_data(struct hvsock *hvs)
> +static int hvs_update_recv_data(struct vsock_sock *vsk)
>  {
>       struct hvs_recv_buf *recv_buf;
>       u32 payload_len;
> +     struct hvsock *hvs =3D vsk->trans;
>
>       recv_buf =3D (struct hvs_recv_buf *)(hvs->recv_desc + 1);
>       payload_len =3D recv_buf->hdr.data_size;
> @@ -543,8 +591,12 @@ static int hvs_update_recv_data(struct hvsock *hvs)
>       if (payload_len > HVS_MTU_SIZE)
>               return -EIO;
>
> -     if (payload_len =3D=3D 0)
> +     /* Peer shutdown */
> +     if (payload_len =3D=3D 0) {
> +             struct sock *sk =3D sk_vsock(vsk);
>               hvs->vsk->peer_shutdown |=3D SEND_SHUTDOWN;
> +             sk->sk_state_change(sk);
> +     }

Can you please explain why we need to call this sk->sk_state_change()?

When we call hvs_update_recv_data(), we hold the lock_sock(sk) lock, and we
know there is at least one byte to read. Since we hold the lock, the other
code paths, which normally are also requried to acquire the lock before
checking vsk->peer_shutdown, can not race with us.

Thanks,
-- Dexuan
