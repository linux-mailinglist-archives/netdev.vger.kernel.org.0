Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12CB22D3BD
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 04:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgGYCVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 22:21:17 -0400
Received: from mail-eopbgr1300127.outbound.protection.outlook.com ([40.107.130.127]:9786
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726618AbgGYCVQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 22:21:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6qH3NLUyknHod+AFIW9MIbz12I1oFdRIglek8qP+HXUYpQeUaN04nocuK9oHgGU09MOjhphWaCsKppSuA5J1nW5rHfQgWYAl4xcLXx4z4A3EkP2bUhJ3O7VUb+yAxNKC5zNthye/htw+LsQon32U3ueipzBI8r6UbmrtdYf2YG4nFlrsSyHy7WggRuVqqiwEwsOHYu47VwrEiem0WHJREplePagiy2kHEl7bk36supgXjEyQrDBpxKwSFwtUoMhyz4Dy2/oKkgcByQV7QEWVCxesnJdOnl0Nj0TQf8CY7hq11CYinDUlMs9nEujrZHXwKuYORc3otW/SIHtAgehGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onk7LixzZPCr+R726NF299GIisQWyVTxh7wY25UYGzg=;
 b=UcY402Lbt+4QDKBrQLjoEYzSAocz1XTuhNkFkHQw6L8EtYBs4NE2T2aflVBhgXqMOPcj7rS/W2bq8tv6vIJTbvXFL6gk5MLxCYF/v2PnU0/wIHx6O9wA2B093fKFeHJrAiapHbzLZumagK5emTx+eLESQkjQ9e8Vvo+4ytJo9Phr7IcPc+tfUQgHrTTpJVkfrejgT0Y/3SQ97Y+FcNqwzdwa6dp9pfZinGSsT/ufXR/f4k3flE1S2U13JzQRV9KyryjT6YDSwg5A4vqtFIFFdjCgzPo49eM7ATVIvgZMZISlWf3b5HbeswYuWo9a1x9hTH6cINXGXrWCMZh/ifIIJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onk7LixzZPCr+R726NF299GIisQWyVTxh7wY25UYGzg=;
 b=fQ3pI0gZ3LtfKWvNxtx9fD9rni1Lk2hB6U3d2OSD0iTw8Dc1bu6ato+O7pr5Yx4f7FHTyKs2eusnioAtcCxtj19a6x0ZZeAZgn3msqkpGmnN9RgZ/LAzclEjD36z8P/JRmXUOWXb5Ijce2deru0DTT8pavhobgZMk9rriigp8vA=
Received: from KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM (2603:1096:820:10::19)
 by KL1P15301MB0038.APCP153.PROD.OUTLOOK.COM (2603:1096:802:f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.0; Sat, 25 Jul
 2020 02:21:07 +0000
Received: from KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM
 ([fe80::819:688c:f8fe:114d]) by KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM
 ([fe80::819:688c:f8fe:114d%9]) with mapi id 15.20.3239.010; Sat, 25 Jul 2020
 02:21:07 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        'Eric Dumazet' <edumazet@google.com>
CC:     'Willy Tarreau' <w@1wt.eu>, Greg KH <greg@kroah.com>,
        Joseph Salisbury <Joseph.Salisbury@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: UDP data corruption in v4.4
Thread-Topic: UDP data corruption in v4.4
Thread-Index: AdZiJnBIPDXmVtR1R7+R+22vR2xKPA==
Date:   Sat, 25 Jul 2020 02:21:06 +0000
Message-ID: <KL1P15301MB028018F5C84C618BF7628045BF740@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-25T02:21:04Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=27703d82-9db5-4a34-8ea0-34cf263c47d2;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:a280:7f70:2d82:da9e:4d9:9425]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3ceb9e8e-1ca3-441d-5cba-08d830416377
x-ms-traffictypediagnostic: KL1P15301MB0038:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <KL1P15301MB00389538442B161B6CB47710BF740@KL1P15301MB0038.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KRY9PLDfHptkRVcJZI5OVMej79fyW3oNrd/h4Kd4uSO9smd840ImkIbHQZ6HfS3AkikRFiyvugAD5IloPRMwlMlQvbGOcmlRYMfvuM8Dwl8PrdUMFx5lXbgPYHy3uRRaMogAcaxGSGMYjhMOVlGwxCG+3eMJUvF2lj4eVuvsOZpvP4QtcJZ9dI9HwMVwgHIZlpblMWJp1M4RxDsFe3EapaOdqVW5uSyZa4b9LQof1f0jE/PoeqweZ2I0yQexOIrTsiJzwP/FkyPiIljoZ0fF69H7KOfPZ+zSplNhLbvhJ+xs7cpkiI6mPBEcWFEBPOfaGbTNAfIdpdfYavuJ/7DF5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(107886003)(498600001)(33656002)(55016002)(71200400001)(54906003)(9686003)(2906002)(82960400001)(82950400001)(110136005)(83380400001)(6506007)(5660300002)(8990500004)(8936002)(66476007)(66556008)(64756008)(66446008)(66946007)(76116006)(7696005)(186003)(4326008)(8676002)(52536014)(86362001)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +H4o2fTSEye9ZnnInjUbIHs/RKDUB2CG4x7mx5lhZIro1QboZB92l54Y/a3dX9EnncSCEaPzEgrLDfLKtYu4QkbxOEFyY+Z9NNOhsGZdvNdfxo1CG3NHqtkkELfEkVB7W80dvGbwyuvryd8W2D3REfsdpKDPbQkGc2F2qZ+j/7Vp4l7dcLm7+K21P6JBW/+AIJrx7RH0Cm1H5GR/emFDmaVAeaoUsOABRXm+V1l9sF+HLDnRCDkNTZPNYu6GR8INaAMmu7oTNA3+hjBem5tX8HtfpILvS6ThzPMLCT9rHb629omr5zPQSPoGvnHnGCROOKvSVeeLT0cNBHjV+NvFx1bEw++znIOsKNSuwAypMSi+U+Cs7fVaTF2IH+bv+dWgjAbpuM31+oBcbdxTgOpLhRfL5WHiIgap/rloeDVpNE7c4s+g3ILMW1rX50g4ygxENcOFckKEOQS7mPE77Yht4atzrL/qKv+9D+wvycI6OEFYYPVNiGcdhZT7A+62a2JNZK+pSDPKKZTPqGogUHap68HUR1ipZ/LJnPUBBRtlHrAjzyqWUSbE6GL6U5raun8vjVqNf8nzPj0QAA+IB3PrOzunugtcVbLhUqVC1XFkaFSmEstZ2viaOuwl7IB14s7R81RVrdRwgCr2lifE/lFkI+sceBd8ZmCszlsHetebE83NDztdRS7uz1mvVryoDPxK/j1Q+xrwMVbCnb/1CL+H+A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ceb9e8e-1ca3-441d-5cba-08d830416377
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2020 02:21:06.8232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dkLvO2bxkfJpwRsH/jr31cI5qpLSP2Yd5PF8a617FwAyIb45YyK0X80u9G0OCnYAsDzST+h7cKKGfEiSopVKdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1P15301MB0038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
The v4.4 stable kernel (currently it's v4.4.231) lacks this bugfix:
327868212381 ("make skb_copy_datagram_msg() et.al. preserve ->msg_iter on e=
rror")
, as a result, the v4.4 kernel can deliver corrupt data to the application
when a corrupt UDP packet is closely followed by a valid UDP packet:
when the same invocation of the recvmsg() syscall delivers the corrupt
packet's UDP payload to the application's receive buffer, it provides the
UDP payload length and the "from IP/Port" of the valid packet to the=20
application -- this mismatch makes the issue worse.

Details:

For a UDP packet longer than 76 bytes (see the v5.8-rc6 kernel's
include/linux/skbuff.h:3951), Linux delays the UDP checksum verification
until the application invokes the syscall recvmsg().

In the recvmsg() syscall handler, while Linux is copying the UDP payload
to the application's memory, it calculates the UDP checksum. If the
calculated checksum doesn't match the received checksum, Linux drops the
corrupt UDP packet, and then starts to process the next packet (if any),
and if the next packet is valid (i.e. the checksum is correct), Linux will
copy the valid UDP packet's payload to the application's receiver buffer.

The bug is: before Linux starts to copy the valid UDP packet, the data
structure used to track how many more bytes should be copied to the
application memory is not reset to what it was when the application just
entered the kernel by the syscall! Consequently, only a small portion or
none of the valid packet's payload is copied to the application's receive
buffer, and later when the application exits from the kernel, actually
most of the application's receive buffer contains the payload of the
corrupt packet while recvmsg() returns the length of the UDP payload of
the valid packet.

For the mainline kernel, the bug was fixed by Al Viro in the commit=20
327868212381, but unluckily the bugfix is only backported to the
upstream v4.9+ kernels. I hope the bugfix can be backported to the
v4.4 stable kernel, since it's a "longterm" kernel and is still used by
some Linux distros.

It turns out backporting 327868212381 to v4.4 means that some=20
Supporting patches must be backported first, so the overall changes
are pretty big...

I made the below one-line workaround patch to force the recvmsg() syscall
handler to return to the userspace when Linux detects a corrupt UDP packet,
so the application will invoke the syscall again to receive the following v=
alid
UDP packet (note: the patch may not work well with blocking sockets, for
which typically the application doesn't expect an error of -EAGAIN. I
guess it would be safer to return -EINTR instead?):

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1367,6 +1367,7 @@ csum_copy_err:
        /* starting over for a new packet, but check if we need to yield */
        cond_resched();
        msg->msg_flags &=3D ~MSG_TRUNC;
+       return -EAGAIN;
        goto try_again;
}


Eric Dumazet made an alternative that performs the csum validation earlier:

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1589,8 +1589,7 @@ int udp_queue_rcv_skb(struct sock *sk, struct
sk_buff *skb)
                }
        }

-       if (rcu_access_pointer(sk->sk_filter) &&
-           udp_lib_checksum_complete(skb))
+       if (udp_lib_checksum_complete(skb))
                goto csum_error;

        if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {

I personally like Eric's fix and IMHO we'd better have it in v4.4 rather th=
an
trying to backport 327868212381.

Looking forward to your comments!

Thanks,
Dexuan Cui
