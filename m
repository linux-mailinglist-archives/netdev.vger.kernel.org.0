Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9E548E7C
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfFQT0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:26:30 -0400
Received: from mail-eopbgr780100.outbound.protection.outlook.com ([40.107.78.100]:30953
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725938AbfFQT03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:26:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=prhJ9XhbQjGXGvM1sfqUNJRViX6Y4TW8KrGIcDimCmHu7ptyWIDUyPRa5K/+KITDs/i2BWQAIzCmxqlAauenGjmpcdhFJaMtiK48jlU0w6uzdDF6vfQ/gDGvVUKTd7l2u+b0hCOUSra8GIcYOPzsT8vt+5Ib8IDl0RMbCHhw4h8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQwRWmI7W0cV7a9cwT5eWPZGNqIzTEBH6HUL+k8WGHk=;
 b=lzB3+k174Zs732BPsiafXseg5zFtax8ynKRmYKbnP3NHJOuNnL3KM72kE0DKvHb4iWBeFiIvO/Xe4dxnYZf3EVocTe/AaZOCH5mefkCInHY3ZSdV6mnshCRl3WeKYnJKcZu/KFDah1ZuCUU4Hi1qdTs53ZTQ5KMFZCYFBmYimxY=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQwRWmI7W0cV7a9cwT5eWPZGNqIzTEBH6HUL+k8WGHk=;
 b=UtosAeplbxCQn5jGdFt62s+7eWUkDiwFwUHfrwV+gfP/gHJ3n/KEh358vCMdrULvGOPpZTGPE1FEhVW6ZA+T803WImWixbF+MUIY/+0b7wjqwHgmaePpAQbk897uoba/Wl/I+gZi2629MbS4i1AIcorOjorplsFYtbb1X08seIw=
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com (2603:10b6:302:a::33)
 by MW2PR2101MB1114.namprd21.prod.outlook.com (2603:10b6:302:a::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.2; Mon, 17 Jun
 2019 19:26:25 +0000
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::a1f6:c002:82ba:ad47]) by MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::a1f6:c002:82ba:ad47%9]) with mapi id 15.20.2008.007; Mon, 17 Jun 2019
 19:26:25 +0000
From:   Sunil Muthuswamy <sunilmut@microsoft.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2] hvsock: fix epollout hang from race condition
Thread-Topic: [PATCH net v2] hvsock: fix epollout hang from race condition
Thread-Index: AdUlQoBZAbnr1Kw4SGmEewBGCyepWg==
Date:   Mon, 17 Jun 2019 19:26:25 +0000
Message-ID: <MW2PR2101MB111670139C7F5DC567129DD3C0EB0@MW2PR2101MB1116.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:3:8d7e:cb94:2f88:ec90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86d7fc2e-dcb4-49da-f4a5-08d6f359b063
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MW2PR2101MB1114;
x-ms-traffictypediagnostic: MW2PR2101MB1114:
x-microsoft-antispam-prvs: <MW2PR2101MB111437119FE3627F455103D3C0EB0@MW2PR2101MB1114.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(39860400002)(366004)(396003)(346002)(189003)(199004)(8676002)(81156014)(81166006)(8936002)(316002)(22452003)(478600001)(305945005)(7736002)(10090500001)(68736007)(6116002)(99286004)(52396003)(7696005)(6636002)(8990500004)(110136005)(54906003)(1511001)(102836004)(10290500003)(6506007)(14454004)(66446008)(73956011)(66946007)(64756008)(66476007)(66556008)(5660300002)(52536014)(33656002)(4326008)(76116006)(53936002)(46003)(25786009)(2906002)(74316002)(71190400001)(71200400001)(86362001)(9686003)(55016002)(476003)(486006)(6436002)(256004)(14444005)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB1114;H:MW2PR2101MB1116.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gTNVgLMIeDrMf0qNxDAxCdA05+1EW9FFvyV+ZGBLCAu5Ej4RcHfVJzBQHGyC0xjvIEa1Z7KuRvqAWUPWJDcr4M2bbpVG3qV2jLzFfxjQpakQ3eKN0fjeigYeis9JeLz8kEheI08eKfdsx+kOz4nSVhzuwZ+rniG+MepK6r4ZTUrtvHuPOWfbqQdvNNZBn9/F/2t6mieH3j8kw4wcCcVb4RIZ9Y6oZiRBdGWEc9kt4s3oiNyrp5hdr1OQ2s598deAE0JIuqTs5LJixE+UM1jy2iogMDq1ZEerfbWM03VOHjk1kkkH587PcNtyidTtLvuLM9t2KiUXt4aMCnX9vhPaf3SIQPQr8ia07eCT0OVllFig2sudbUAZSVtJlVAs9w5ZAteJFxCmMEa8svFg2heDzvyWHVJGXUHqf2m9+zEKRF0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d7fc2e-dcb4-49da-f4a5-08d6f359b063
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:26:25.5104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sunilmut@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, hvsock can enter into a state where epoll_wait on EPOLLOUT will
not return even when the hvsock socket is writable, under some race
condition. This can happen under the following sequence:
- fd =3D socket(hvsocket)
- fd_out =3D dup(fd)
- fd_in =3D dup(fd)
- start a writer thread that writes data to fd_out with a combination of
  epoll_wait(fd_out, EPOLLOUT) and
- start a reader thread that reads data from fd_in with a combination of
  epoll_wait(fd_in, EPOLLIN)
- On the host, there are two threads that are reading/writing data to the
  hvsocket

stack:
hvs_stream_has_space
hvs_notify_poll_out
vsock_poll
sock_poll
ep_poll

Race condition:
check for epollout from ep_poll():
	assume no writable space in the socket
	hvs_stream_has_space() returns 0
check for epollin from ep_poll():
	assume socket has some free space < HVS_PKT_LEN(HVS_SEND_BUF_SIZE)
	hvs_stream_has_space() will clear the channel pending send size
	host will not notify the guest because the pending send size has
		been cleared and so the hvsocket will never mark the
		socket writable

Now, the EPOLLOUT will never return even if the socket write buffer is
empty.

The fix is to set the pending size to the default size and never change it.
This way the host will always notify the guest whenever the writable space
is bigger than the pending size. The host is already optimized to *only*
notify the guest when the pending size threshold boundary is crossed and
not everytime.

This change also reduces the cpu usage somewhat since hv_stream_has_space()
is in the hotpath of send:
vsock_stream_sendmsg()->hv_stream_has_space()
Earlier hv_stream_has_space was setting/clearing the pending size on every
call.

Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
---
- Resubmitting the patch after taking care of some spurious warnings.

 net/vmw_vsock/hyperv_transport.c | 39 ++++++++----------------------------=
---
 1 file changed, 8 insertions(+), 31 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transp=
ort.c
index e4801c7..cd3f47f 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -220,18 +220,6 @@ static void hvs_set_channel_pending_send_size(struct v=
mbus_channel *chan)
 	set_channel_pending_send_size(chan,
 				      HVS_PKT_LEN(HVS_SEND_BUF_SIZE));
=20
-	/* See hvs_stream_has_space(): we must make sure the host has seen
-	 * the new pending send size, before we can re-check the writable
-	 * bytes.
-	 */
-	virt_mb();
-}
-
-static void hvs_clear_channel_pending_send_size(struct vmbus_channel *chan=
)
-{
-	set_channel_pending_send_size(chan, 0);
-
-	/* Ditto */
 	virt_mb();
 }
=20
@@ -301,9 +289,6 @@ static void hvs_channel_cb(void *ctx)
 	if (hvs_channel_readable(chan))
 		sk->sk_data_ready(sk);
=20
-	/* See hvs_stream_has_space(): when we reach here, the writable bytes
-	 * may be already less than HVS_PKT_LEN(HVS_SEND_BUF_SIZE).
-	 */
 	if (hv_get_bytes_to_write(&chan->outbound) > 0)
 		sk->sk_write_space(sk);
 }
@@ -404,6 +389,13 @@ static void hvs_open_connection(struct vmbus_channel *=
chan)
 	set_per_channel_state(chan, conn_from_host ? new : sk);
 	vmbus_set_chn_rescind_callback(chan, hvs_close_connection);
=20
+	/* Set the pending send size to max packet size to always get
+	 * notifications from the host when there is enough writable space.
+	 * The host is optimized to send notifications only when the pending
+	 * size boundary is crossed, and not always.
+	 */
+	hvs_set_channel_pending_send_size(chan);
+
 	if (conn_from_host) {
 		new->sk_state =3D TCP_ESTABLISHED;
 		sk->sk_ack_backlog++;
@@ -697,23 +689,8 @@ static s64 hvs_stream_has_data(struct vsock_sock *vsk)
 static s64 hvs_stream_has_space(struct vsock_sock *vsk)
 {
 	struct hvsock *hvs =3D vsk->trans;
-	struct vmbus_channel *chan =3D hvs->chan;
-	s64 ret;
-
-	ret =3D hvs_channel_writable_bytes(chan);
-	if (ret > 0)  {
-		hvs_clear_channel_pending_send_size(chan);
-	} else {
-		/* See hvs_channel_cb() */
-		hvs_set_channel_pending_send_size(chan);
-
-		/* Re-check the writable bytes to avoid race */
-		ret =3D hvs_channel_writable_bytes(chan);
-		if (ret > 0)
-			hvs_clear_channel_pending_send_size(chan);
-	}
=20
-	return ret;
+	return hvs_channel_writable_bytes(hvs->chan);
 }
=20
 static u64 hvs_stream_rcvhiwat(struct vsock_sock *vsk)
--=20
2.7.4

