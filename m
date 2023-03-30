Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D936D09CA
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbjC3Pf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbjC3Pfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:35:50 -0400
Received: from DM4PR02CU001-vft-obe.outbound.protection.outlook.com (mail-centralusazon11012001.outbound.protection.outlook.com [52.101.63.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D287BD30D;
        Thu, 30 Mar 2023 08:35:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIKp9hyfIQS+1a4hLTAyjrbNYB16T13Q/JKPGH5nYhqKtQAFPbb/W3TyFmp9MCcIFrZhEiCpF/RgYu8cYm+AqFi1UrlEsHyzBUmwOG+BfroKeGgktOkmw1Trb9yk4cHxOU1CK4wwhY2lliaLfKDnSdQOzojtzHA1+U715qeFeUgR9tBWgF/O09H/jIrdBYQN959xpWtkAfVCKnWobAxD5kVG1YzwJG+wpTORWY0+SCm0lYtUulIdNXBme8+JKX56u8TliOTBXKlL+bvaOkp8e2JlDC8dYr+dZQrIgkj6jl70Hxtlx3WE7qS346d0um6tGIPCJZ7mEC26FHMWwtJ4ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MouLZf9ei+oMqmBiK9Q6uzI8EWuh0SHZ6LbkWv+XEVM=;
 b=L5F+9D38qvCXdHWGQbXOsPU1xH3zUiHkhLUnOnzW/G546fM/Asjr662oPlSrXLoj6AsQ3TKOVDy7KCZzYBXQAxkvrqQ60hKbFlp5UqGtgddUK37JE5ioMMqwnw99ix2uaQ5zMCc0q8i+ngm+dZGuA9rYPnHWpj8WLsucLYww/VH4y6C7d1RD7btYN1PYPS/uKQDoSKs3lEXOizUIo48Xh8VmwV/6dEECd7aawyQd6v6qEo5+/bFF38lLOMAHKa62ubyiJbz2F05H9MQrZNFGDv2Pm9do6S8G2unImeZ5+jjligq///St1xpNzOBqTxKnfXX3mqHEVKm/Oq2uTzfu6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MouLZf9ei+oMqmBiK9Q6uzI8EWuh0SHZ6LbkWv+XEVM=;
 b=mInmLmWDdHYBit8AfqJxObpUxWPFtzSNxK2VzUl3VAX6K6V7CClYPIIgeuDOEPTLd9X7ZNqO6ZKjIJjhVX+HKX3Ahu4dWRMpAZzSW77Cok93gJe7KzcwALTwKXp9zo+kx+iCfY78S79ZNeiwItSmwCCrtffBs4sqmA+SZMn3jHU=
Received: from BYAPR05MB3960.namprd05.prod.outlook.com (2603:10b6:a02:88::12)
 by SN6PR05MB4509.namprd05.prod.outlook.com (2603:10b6:805:2b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 15:35:13 +0000
Received: from BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::8cb8:9578:d0c0:83d3]) by BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::8cb8:9578:d0c0:83d3%7]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 15:35:12 +0000
From:   Vishnu Dasa <vdasa@vmware.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Arseniy Krasnov <avkrasnov@sberdevices.ru>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Pv-drivers <Pv-drivers@vmware.com>
Subject: Re: [RFC PATCH v2 2/3] vsock/vmci: convert VMCI error code to -ENOMEM
Thread-Topic: [RFC PATCH v2 2/3] vsock/vmci: convert VMCI error code to
 -ENOMEM
Thread-Index: AQHZYtbL7ZUSdfIRlkizlTLuphx4kK8S+uEAgAB504A=
Date:   Thu, 30 Mar 2023 15:35:12 +0000
Message-ID: <554FE762-95AF-4D14-8BF8-BEC610937C77@vmware.com>
References: <60abc0da-0412-6e25-eeb0-8e32e3ec21e7@sberdevices.ru>
 <94d33849-d3c1-7468-72df-f87f897bafd2@sberdevices.ru>
 <wzkkagpfxfi7nioixpcmz4uscxojilwhuj4joslwevkm25m6h7@z4yl33oe7wqu>
In-Reply-To: <wzkkagpfxfi7nioixpcmz4uscxojilwhuj4joslwevkm25m6h7@z4yl33oe7wqu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR05MB3960:EE_|SN6PR05MB4509:EE_
x-ms-office365-filtering-correlation-id: 9deaaaa9-056e-4a09-14e6-08db31345a5c
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QfpFLJWkR1M4Ltvfo0eu0YIUDuu7N1rMmsRJ31sJfo5fB++pOAZSR/pWdhKsia9STIfdva7Jhjqe4aSdraReZFHQ55EhiZAKZj9Tkzg66oR/Dulu2TsFJkwVDmJ38/qmMLSTak5EyYBVUJnfz1zr4TQLbmTv3iWDhOC22UjB+l6GsYSRnypL6pJzY+zHBkP3/nPIbQRknUr1TWWpn49V1JgfCDcboe0VYh+uH7aLYjk0aPLf7BVaYa/gK4L0Ib4sg6RY3OKr1VAspL10Htmw+Ye8NWSwyPdbdAUFjxmHSSijFENFgGZX4mh15OsC08y4jVqyXCl19oycNlk7tFD7klqtbZYjSkylIrp/xb/ps2CjPz/VqX1zyfiphybxUO2ku1/7VkLyJbd5Db1IyWQg8uyLr0JJ33JpCOzzamD8h85Qaos158GV7olwxuwDDA3iuUusVo4HNJYPSadYKtrMaeOVPAXea9NVOl0t5j+zQqkqYxGf5K8tHd3IkLO6LPeNIEdMSu93ivxCvDQtypfAIzojWHMZqQrxlUBtME09FWtpli14DEr5n1E1kD4iIwgvqBc9ed8sts7tSglmA6lpDIwKdjzCvFM2sOhAX3iJVN0df6NdAzZlHhHzLj7K3SPE7Dh4tcH+CecscDTlUkdhgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB3960.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(451199021)(8936002)(41300700001)(76116006)(6506007)(7416002)(5660300002)(110136005)(122000001)(38100700002)(86362001)(38070700005)(66476007)(36756003)(71200400001)(91956017)(66446008)(66946007)(8676002)(6486002)(6512007)(54906003)(66556008)(4326008)(316002)(478600001)(83380400001)(2616005)(33656002)(53546011)(107886003)(186003)(64756008)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2fPWiubcTQFvCreHFJeLQxYm5ud5E7l10Gcabhe0kEnMowEhUVq2Q1/NvsVc?=
 =?us-ascii?Q?Ugx0nf1YgZuwzldJ08Z4c+Wjv7mnFkYqdpv01Mkyk97guX84Pql1GiMUO7WU?=
 =?us-ascii?Q?0z0bW8WApeHI2Rh6iP40RoPpDr/qAuYg7Z9m6ex1M/fb0emKLw9FPDTGuL3p?=
 =?us-ascii?Q?ZXWTrMfsxplKp0MUIxV6+P1UfDX/rdVFS/aotpJ+r57gs/4VCofj2GQ8aFxz?=
 =?us-ascii?Q?OPJohCoNpQ3pZ+ptUlOa6H9cYS7ZkzzN66BinsA1FCDnajPp3WUGIJyzDX+V?=
 =?us-ascii?Q?kkZZyle76VDtj2PRpH6rc7U0ySz+M+HMeKx8zl52Mx4pEF4fEFI3tHajRKdl?=
 =?us-ascii?Q?wOcb2bGXyjtzMYN1UpeAHZcehIq+HO0/D/Ok7RDIDXYVrDqVU1TwQDLE89ob?=
 =?us-ascii?Q?2OvlXeKngfIraktqiZcSRhxmP0mqD4p+hwACZheYbxSUkJiSvvU12yG2kM1d?=
 =?us-ascii?Q?lvUtMMJdSYSQR5Qm6c64nRtbpsDpko5/cxfkGeAPPSUOYsWoNQTgxQlxJWQ3?=
 =?us-ascii?Q?zHzfpyT5Mo2YgLfBaEgmBmZ1juSMN1GUhETmd/eZB9SCIUgLB4oMr7fCBgWl?=
 =?us-ascii?Q?sW+AIU8l6X5sHokYLbeanO9NJtoljdjOOYKpcRLLORoRsrxMSiRXrZSSVByZ?=
 =?us-ascii?Q?o6epSKWofgy58LjsTHpN51jegPWrJHceJVx0MtRYCJe0ZdLQZbmQ8RRk+v80?=
 =?us-ascii?Q?kgtLUANh3W1g/E3cn40CirlSDfdrELjqpTDCzD96Nphq49B+tTPRP2rdC2z2?=
 =?us-ascii?Q?4DqdncEImpCorkRvleES00FXtsgwgWxnYWlE0r271uFqGGDHmKAqLPblCEbF?=
 =?us-ascii?Q?PwelxskysmESYTG+ZHhS/ExMlH0eWTDj9KhcIj1w1plmG6ENODU6ucCZc5hg?=
 =?us-ascii?Q?5TSn+XwHi0ROEXLBgekv4qwE5q09XVFWR/CSTfU6tzM8xxodwJko822/ESw0?=
 =?us-ascii?Q?LmrymOWcQ5J4jyBxC9ZjquMxwEPIyB1hXwmystsF7ORtnoMxlBleL3a4tChh?=
 =?us-ascii?Q?UZQlcKYuF4gb7eOxcjewF0XhAXmVrOctsrQBdyqTlVw8G+zK7rhaduPq7Uzw?=
 =?us-ascii?Q?H+FH18zWlgG2tnK3ZwxMuaOGtwNQwtrgxhfdnim6i9TCUL5hu/iwBvFMmzLi?=
 =?us-ascii?Q?SxafGCp0u1xVht5ozFpF4oXQHr0gLXfCR2NkYa3k5S/8+2bo6R2YoroM05fh?=
 =?us-ascii?Q?8BciBPSsTZi2TdnWK8ngZOwEKZn/zrl2rNeigevzZLsg44wPFaSoyPBaxQNE?=
 =?us-ascii?Q?TPRbLQve2AjL8GpwVxACOk3G06Ud8w9xrBrb9FpAGgDtu8N+Zgo7GyAIvEMD?=
 =?us-ascii?Q?lQVWDWYmwMxczQsFgLhjkx8MdBc1TO52A3Ow1HImHZLVIqZOiVOtiuNDivM6?=
 =?us-ascii?Q?Op3iTXgzTYtFpArOEUR3E7sg4O0tbCkfP2J1BqQI35JlMjhJPrTTM+YF101s?=
 =?us-ascii?Q?XIPt39hyiaf5m5IwVa7S1lO2qnlb5hZI7dd87hfoDLuh9F7pLoxCSSOQ5bAr?=
 =?us-ascii?Q?N4xo/Jaut2XKSCBg26uHlMh7y9j/GR4k8XWRkkVCRhsTRTuUuY8GFxIJwB3/?=
 =?us-ascii?Q?b1MsOZuNvzpYKw+2a0TSwPg3MT4nDPJScRTCCvesbqUAI7DNAcFriTMlpILc?=
 =?us-ascii?Q?fZTAQpGs59LxwgSdIvzedG6aycGLMWBW0gsDsgAybdNt?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0757DC12ED527046A5FA535E775C5322@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR05MB3960.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9deaaaa9-056e-4a09-14e6-08db31345a5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 15:35:12.6896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JefU7zpMhXU7JnCUCe0BPGFR2d9BwqA9P5ZlB89IP44dNfs6L8iRAfTvsRwJZVjnwJMamZAEnQuMbl4jxiDNxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4509
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 30, 2023, at 1:19 AM, Stefano Garzarella <sgarzare@redhat.com> wro=
te:
>=20
> !! External Email
>=20
> On Thu, Mar 30, 2023 at 10:07:36AM +0300, Arseniy Krasnov wrote:
>> This adds conversion of VMCI specific error code to general -ENOMEM. It
>> is needed, because af_vsock.c passes error value returned from transport
>> to the user.
>>=20
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> net/vmw_vsock/vmci_transport.c | 19 ++++++++++++++++---
>> 1 file changed, 16 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transpo=
rt.c
>> index 36eb16a40745..45de3e75597f 100644
>> --- a/net/vmw_vsock/vmci_transport.c
>> +++ b/net/vmw_vsock/vmci_transport.c
>> @@ -1831,10 +1831,17 @@ static ssize_t vmci_transport_stream_dequeue(
>>      size_t len,
>>      int flags)
>> {
>> +      int err;
>=20
> Please, use the same type returned by the function.
>=20
>> +
>>      if (flags & MSG_PEEK)
>> -              return vmci_qpair_peekv(vmci_trans(vsk)->qpair, msg, len,=
 0);
>> +              err =3D vmci_qpair_peekv(vmci_trans(vsk)->qpair, msg, len=
, 0);
>>      else
>> -              return vmci_qpair_dequev(vmci_trans(vsk)->qpair, msg, len=
, 0);
>> +              err =3D vmci_qpair_dequev(vmci_trans(vsk)->qpair, msg, le=
n, 0);
>> +
>> +      if (err < 0)
>> +              err =3D -ENOMEM;
>> +
>> +      return err;
>> }
>>=20
>> static ssize_t vmci_transport_stream_enqueue(
>> @@ -1842,7 +1849,13 @@ static ssize_t vmci_transport_stream_enqueue(
>>      struct msghdr *msg,
>>      size_t len)
>> {
>> -      return vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
>> +      int err;
>=20
> Ditto.
>=20
>> +
>> +      err =3D vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
>> +      if (err < 0)
>> +              err =3D -ENOMEM;
>> +
>> +      return err;
>> }
>=20
> @Vishnu: should we backport the change for
> vmci_transport_stream_enqueue() to stable branches?
>=20
> In this case I would split this patch and I would send the
> vmci_transport_stream_enqueue() change to the net branch including:
>=20
> Fixes: c43170b7e157 ("vsock: return errors other than -ENOMEM to socket")

Yes, good point.  It would be better to do it this way for correctness.

Thanks,
Vishnu

>=20
> Thanks,
> Stefano
>=20
>=20
> !! External Email: This email originated from outside of the organization=
. Do not click links or open attachments unless you recognize the sender.


