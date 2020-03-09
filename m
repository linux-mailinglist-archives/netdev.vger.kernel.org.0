Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2B417DE2E
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 12:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgCILG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 07:06:29 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:62763
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726248AbgCILG2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 07:06:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KY2uQj+AIXGJjTRA3RVuj6EKiu2xA6wX70C/Ijnr6il+WbjpY8rUmSA9yQzaQ7MdovzgCHtjNIC+PznZnWuuKEqUcV23U+FT7c3/b3motapR5m8Rf99Lv0yM+/6Po9XfSSGEchgZXI9vV/1n8C/6MeLFi54Xheo8bNnOYU1kdUmOaFgBO8SodI/AjcRe6h+VZjn1C+8hHsGCL8+1VMo4+s2rAm95exB6kVUiY3DdaTNNQSdEXIzdmPaI+Vh6edHcFN85+sDMQ9/hVKcsDDiHBaU1lxDCioOC88UO/tIPnApwBhzp/jukOVRosGwQMWlawioZWn+5hrEwMDX4gRpbCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5uPaM7OrOj1Rty4N8wjCHI0yBnjwO7nBS3yH0BXB4s=;
 b=OXDmP8uKLNT31uCZpnINwUQvp6CGUiR7ZaC3FszQ1QtErIByVLEi+UFYdbFkFNAAtgVRHYWaScIDqf31dBu/dyN6yzH50iy901fo6g8pOlU8XxYIrMkimIvebFrW0gVbp8pv7yoJo9HPeUC3TXttoGakIoeU2+byAJ1NTd3wkw70RBtlojzYgRV2uz6z3D8zVlAQBEf33FnnnGNXOQIZTv0GNsoF65BjN0BiUfpv+ETzlISwSWscornvE7EQoW3IV83CWRYN2l+3KNMTXrxYZ8HqZx14x0E3MdpJnmpWl0U6lvDimtBD3JsPHuo+tZuGvASN5W2Vk3GMRFZhFDci3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nextfour.com; dmarc=pass action=none header.from=nextfour.com;
 dkim=pass header.d=nextfour.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NextfourGroupOy.onmicrosoft.com;
 s=selector2-NextfourGroupOy-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5uPaM7OrOj1Rty4N8wjCHI0yBnjwO7nBS3yH0BXB4s=;
 b=Ez103lELIBgFV6dSSM0rs/0G3j4XjDxsf2mW9B8J1jkQeweLNo15yOlfW9mGEpWMhi3yFcaNmVx7Nvi9jICnZccLNUzCqtU6dv+JrtJi+2+t2/wpPuXce9rOBOkcEEsh6qp2ywzniy018g3O0k99VgjebQglxhOZn6TWM7E4ATs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=mika.penttila@nextfour.com; 
Received: from VI1PR03MB3775.eurprd03.prod.outlook.com (52.134.21.155) by
 VI1PR03MB4590.eurprd03.prod.outlook.com (20.177.52.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Mon, 9 Mar 2020 11:06:23 +0000
Received: from VI1PR03MB3775.eurprd03.prod.outlook.com
 ([fe80::ed88:2188:604c:bfcc]) by VI1PR03MB3775.eurprd03.prod.outlook.com
 ([fe80::ed88:2188:604c:bfcc%7]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 11:06:23 +0000
Subject: Re: [PATCH ipsec] esp: remove the skb from the chain when it's
 enqueued in cryptd_wq
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
References: <2f86c9d7c39cfad21fdb353a183b12651fc5efe9.1583311902.git.lucien.xin@gmail.com>
 <37097209-97cd-f275-cbe2-6c83f5580b80@nextfour.com>
 <CADvbK_dqRXr3D1WgLDXqiBhpyw+QGRrvwugqDhOMr_kpQVi3QA@mail.gmail.com>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
X-Pep-Version: 2.0
Message-ID: <bb90ae9e-9d8f-e860-5d82-dbd06081905c@nextfour.com>
Date:   Mon, 9 Mar 2020 13:06:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <CADvbK_dqRXr3D1WgLDXqiBhpyw+QGRrvwugqDhOMr_kpQVi3QA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------123A24450A02DFD5970F628D"
Content-Language: en-US
X-ClientProxiedBy: HE1PR0902CA0046.eurprd09.prod.outlook.com
 (2603:10a6:7:15::35) To VI1PR03MB3775.eurprd03.prod.outlook.com
 (2603:10a6:803:2b::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.10.10.144] (194.157.170.35) by HE1PR0902CA0046.eurprd09.prod.outlook.com (2603:10a6:7:15::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Mon, 9 Mar 2020 11:06:22 +0000
X-Pep-Version: 2.0
X-Originating-IP: [194.157.170.35]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fd5bf8d-424d-4248-1640-08d7c419e743
X-MS-TrafficTypeDiagnostic: VI1PR03MB4590:
X-Microsoft-Antispam-PRVS: <VI1PR03MB45909C57EFE73570DD2B532183FE0@VI1PR03MB4590.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0337AFFE9A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(376002)(136003)(396003)(346002)(366004)(39830400003)(199004)(189003)(2906002)(81156014)(235185007)(956004)(31696002)(6486002)(81166006)(8676002)(54906003)(86362001)(508600001)(16526019)(52116002)(53546011)(8936002)(33964004)(16576012)(186003)(4326008)(21480400003)(36756003)(26005)(66556008)(2616005)(316002)(6916009)(66946007)(66476007)(66616009)(5660300002)(31686004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR03MB4590;H:VI1PR03MB3775.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nextfour.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YoXCf9jtqjitdk0HECW7V+JmhcjC/umdGorKjURw8aMEoCsl5wq3OnBGQkuTRGK/VT94how57EK8+YCIsyOmjtKKdv/Bq3kMxUzaZem14wsOVZjFlDoGPssz1WP3k5a6AN9woqf3AbbXvmqp+noWhi7/ZJRutNjYlfYGxMQb8uvYZOisL1Bfamkw0nQ68w3+gb6dsgsEvUbwOoZL1mtD2bpY4VO6uhz7u1Ti1o2kmQEdVDHZCFJtO4xr5/qPlGXzOnaFk6AMZ0OyFYyRvWET9Iy1skLiQwHjSXpKAUpCHQ3l+lnW7XmpYQbDnZWUtY6tAR2JAuSJsjDX66NOj/6B3gbuajHeQGiG1rwLDkla4pmOMkoKRn+9CbSzJCDT14B/nhEFAXAetLCRls0eDo61vE8R2AHMIe5VVPAtRsw9ERyH6Qt15XGHcn22W2jiIvnx
X-MS-Exchange-AntiSpam-MessageData: yD2f8I71QtyEmvLhHVnpXfpYqs8rQVwWRRhaHA3VLKSLEvZHdq7GwvByV1rpCxGmaAs09iabZWUH6aivKNFeQG66RDOZkB4MdCQjzPcnrgbqkOX0AtdGXFxMzWgr0e5Bz2iPzA2hD/8/Nb9zDN2zUw==
X-OriginatorOrg: nextfour.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd5bf8d-424d-4248-1640-08d7c419e743
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2020 11:06:23.0893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 972e95c2-9290-4a02-8705-4014700ea294
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TlufS0cTs8b4+NngQpeN+Ucj9GR6HyMjLnVwh3MeK8BCnFVwEsW0ztE7TNzQLGNve0sguURkFpaD1m/doSv87Lnl4dd8xzkKgscmETGWyXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB4590
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------123A24450A02DFD5970F628D
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On 9.3.2020 12.50, Xin Long wrote:
> On Mon, Mar 9, 2020 at 6:07 PM Mika Penttil=C3=A4 <mika.penttila@nextfour=
.com> wrote:
>>
>> Hi!
>>
>> On 4.3.2020 10.51, Xin Long wrote:
>>> Xiumei found a panic in esp offload:
>>>
>>>   BUG: unable to handle kernel NULL pointer dereference at 000000000000=
0020
>>>   RIP: 0010:esp_output_done+0x101/0x160 [esp4]
>>>   Call Trace:
>>>    ? esp_output+0x180/0x180 [esp4]
>>>    cryptd_aead_crypt+0x4c/0x90
>>>    cryptd_queue_worker+0x6e/0xa0
>>>    process_one_work+0x1a7/0x3b0
>>>    worker_thread+0x30/0x390
>>>    ? create_worker+0x1a0/0x1a0
>>>    kthread+0x112/0x130
>>>    ? kthread_flush_work_fn+0x10/0x10
>>>    ret_from_fork+0x35/0x40
>>>
>>> It was caused by that skb secpath is used in esp_output_done() after it=
's
>>> been released elsewhere.
>>>
>>> The tx path for esp offload is:
>>>
>>>   __dev_queue_xmit()->
>>>     validate_xmit_skb_list()->
>>>       validate_xmit_xfrm()->
>>>         esp_xmit()->
>>>           esp_output_tail()->
>>>             aead_request_set_callback(esp_output_done) <--[1]
>>>             crypto_aead_encrypt()  <--[2]
>>>
>>> In [1], .callback is set, and in [2] it will trigger the worker schedul=
e,
>>> later on a kernel thread will call .callback(esp_output_done), as the c=
all
>>> trace shows.
>>>
>>> But in validate_xmit_xfrm():
>>>
>>>   skb_list_walk_safe(skb, skb2, nskb) {
>>>     ...
>>>     err =3D x->type_offload->xmit(x, skb2, esp_features);  [esp_xmit]
>>>     ...
>>>   }
>>>
>>> When the err is -EINPROGRESS, which means this skb2 will be enqueued an=
d
>>> later gets encrypted and sent out by .callback later in a kernel thread=
,
>>> skb2 should be removed fromt skb chain. Otherwise, it will get processe=
d
>>> again outside validate_xmit_xfrm(), which could release skb secpath, an=
d
>>> cause the panic above.
>>>
>>> This patch is to remove the skb from the chain when it's enqueued in
>>> cryptd_wq. While at it, remove the unnecessary 'if (!skb)' check.
>>>
>>> Fixes: 3dca3f38cfb8 ("xfrm: Separate ESP handling from segmentation for=
 GRO packets.")
>>> Reported-by: Xiumei Mu <xmu@redhat.com>
>>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>>> ---
>>>  net/xfrm/xfrm_device.c | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
>>> index 3231ec6..e2db468 100644
>>> --- a/net/xfrm/xfrm_device.c
>>> +++ b/net/xfrm/xfrm_device.c
>>> @@ -78,8 +78,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *sk=
b, netdev_features_t featur
>>>       int err;
>>>       unsigned long flags;
>>>       struct xfrm_state *x;
>>> -     struct sk_buff *skb2, *nskb;
>>>       struct softnet_data *sd;
>>> +     struct sk_buff *skb2, *nskb, *pskb =3D NULL;
>>>       netdev_features_t esp_features =3D features;
>>>       struct xfrm_offload *xo =3D xfrm_offload(skb);
>>>       struct sec_path *sp;
>>> @@ -168,14 +168,14 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff=
 *skb, netdev_features_t featur
>>>               } else {
>>>                       if (skb =3D=3D skb2)
>>>                               skb =3D nskb;
>>> -
>>> -                     if (!skb)
>>> -                             return NULL;
>>> +                     else
>>> +                             pskb->next =3D nskb;
>> pskb can be NULL on the first round?
> On the 1st round, skb =3D=3D skb2.

Yes, I misread the patch, thanks.


>
>>
>>
>>>                       continue;
>>>               }
>>>
>>>               skb_push(skb2, skb2->data - skb_mac_header(skb2));
>>> +             pskb =3D skb2;
>>>       }
>>>
>>>       return skb;


--------------123A24450A02DFD5970F628D
Content-Type: application/pgp-keys;
 name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
Fq/REmUeraUWcYydE+B+4Xt5yIF/V/Zwm0o=3D
=3DZ2VJ
-----END PGP PUBLIC KEY BLOCK-----

--------------123A24450A02DFD5970F628D--
