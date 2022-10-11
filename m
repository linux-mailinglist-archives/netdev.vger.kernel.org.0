Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF845FBCCB
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 23:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJKVYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 17:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJKVYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 17:24:47 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11023025.outbound.protection.outlook.com [52.101.64.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABA518B27;
        Tue, 11 Oct 2022 14:24:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZv47yvl5mO5qziMspSkQeUkrlWPQQmey8xZms+0o2IGQWkKWVzVgTlTkBaEGhnZN5pUwU/VIinP8xC6LUR8GBQ0pdFb894iXKEzOiKQYmLrCbhQOx7F2sX5ZDP8FN/Vwk+TLlKaWjFDWl0x9HdQjxHSaU2DyswBW/yJLfzr/tcTt7uKUyHun8tPSO04v1mQ+F0HuQgZlXzYThXU01Oa7SEgXMUgGZsY9UvG8WKCSOaeRNiQTpoyiJpDRlRmTmY3CTgQ/KCSd5k9AVmKxunPUliZr9YR8WgAuO8/zFFGf96lW9PK8JbESjd8xnAEkv5WeRUYL8pvLkCfNj+KFzYFDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xm3gX3ElFq18Iy7lhuroxlf4dEEqSwkF3FL2PYwJ0mo=;
 b=SjWvbidxHy+X6z0uc8wX2mD6vv36p0Jxef1EcK8ksZsSF6jn5pvt4fiFZOsP5LCXlihxYXVj9f95TNBZN6wA+b8HMVGC8vqH+TRFwvBXQ19EnyQBom5rC72B0S7u7ufQ10FNUBd7bqUYQNtNWnrteM0Zp8yfT+ekIy++EqKv6PPnx07ArsdtpeZf664Gl55JyTR6TZ4CsA8edXILk7HAFXlLG4mHNMBPlaTSBLV3FdlE1CcQCiHcwSh/rNPtOchvOma6xgNzLlYq6dM1hYck4lkOqmFUlnaFMl0eNO8zwvk8ucU8Kh7TvJ5ZxeQAVY9QtweDq5+On9F/hePijbNQMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xm3gX3ElFq18Iy7lhuroxlf4dEEqSwkF3FL2PYwJ0mo=;
 b=Jqog41OO/OzQN3uhaN34AFl+1Q/oG5rw1djRLWaxcyaHOIaLonl/pvp02FOaH9hI6nAqams94x7eLRf8bCXH6yKrjkMnwWJrG1C8Wfrx77zKTF5TiQirxt/tsEcXnuQf0HJmiu/Ke7HsQ8wYnhbmalOtHkP23+9orH9NS9aUYpk=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by SJ1PR21MB3552.namprd21.prod.outlook.com (2603:10b6:a03:454::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.6; Tue, 11 Oct
 2022 21:24:39 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::676b:75a4:14cd:6163]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::676b:75a4:14cd:6163%7]) with mapi id 15.20.5746.006; Tue, 11 Oct 2022
 21:24:39 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Cezar Bulinaru <cbulinaru@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: hyperv: bugcheck trigered by memcpy in rndis_filter
Thread-Topic: [PATCH] net: hyperv: bugcheck trigered by memcpy in rndis_filter
Thread-Index: AQHY3adSmTsfvXYduEmDZiuuCp1NGK4JrpJQ
Date:   Tue, 11 Oct 2022 21:24:38 +0000
Message-ID: <BYAPR21MB16884DCA8A74DB851930AD71D7239@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <20221011192545.11236-1-cbulinaru@gmail.com>
In-Reply-To: <20221011192545.11236-1-cbulinaru@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=bbdad44f-af73-4465-a43c-de71adcc96a3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-11T21:03:40Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|SJ1PR21MB3552:EE_
x-ms-office365-filtering-correlation-id: 01f0125d-2af4-4062-828f-08daabcf00ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YgJiFBoPuSiwitZfNBTWrlceXBIr8bmId0/PvR5wbDjrTSBWsPwplzTSL555v1RlZyu+OJjgCc8L+f/gBLrKbQ4nCPvLoHQAb6UQx/RKM4/kknixDStf4etC0aYZjONweOa4+iXWgDzBqBeNtxRRNKU7MixQugBvYaIw4aGnU0a0LuDlDJ8PYlg+s+uCb/CTmTAR0uJWLL1/ONxHoh/xLq8eRemHQNee+tH8tbX19J3IV8Ow4fHVGDKgHNwrbARGXay/ogS5xG+tUR/hZYk9P1xjKDb7O5TAIKMXKHjzaC3SqvKWNyLuOyUILL+ULcE8s6EcgFoEEENmadK4cJFkUGBX2PNDXKMBehKrs6NEzjuKdCrzufxS11MVZXppMPGV6ljXHFExBDvlBpSjB5lNLzhPbAz9wZE9d/K78o4iLdTK/W1Vdh43Pzu4KBBury/t+WTjqug/46Ct8TrY3qbEA9gCJaPk1RZvByIsrtq8XJwpS3NDALLkARgSqWFkd0DHOaJO8bifHAkyOWugAkR3rkLV+pTtLCY8FB2LNO5qjpGWX3hQ8ehkNmocl8SsYCzUMi4NCeHDXuvuNhiT+1Kue7O+0+Zsgvd7KJsGpYlxEf8zgROJZ/F0G+oVKTxzovPYBdCZl5XxCeVsXzGtV8VDLaNhBtKY7tMvaNt93VnlLG6asjeIrek5lTsxoFYriK2p40UfDyoqEdI8o5R5qZjxxpzdIMdhv0RToxVwqZw4D5PqXwwHuLJJjIFw5HbT2XXcV9qQdyQ33v7C/ztPZR0ceNfmFAxLKlgQK+x1A+c7y+gVCqaFogcf1UpXnk/W4QPt4a+7EcLKGWj4HgFPsHZx/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199015)(82960400001)(83380400001)(55016003)(186003)(82950400001)(38100700002)(38070700005)(921005)(5660300002)(122000001)(8936002)(76116006)(8990500004)(52536014)(8676002)(64756008)(66446008)(2906002)(41300700001)(66556008)(66476007)(316002)(10290500003)(26005)(9686003)(478600001)(86362001)(7696005)(6506007)(66946007)(110136005)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rpNqIlU337G4mQlikeWrdVUu50vGRGKtoolGSQl5AqjHIeW+3RXr3jYSlULu?=
 =?us-ascii?Q?wLeUKEYk5RkQ3nZsku+04/s4Y8dL35faulwKwAzaVK2J4QJqj6kwuOf8IpVI?=
 =?us-ascii?Q?Rqbb3ZNz3Qux6G06TY9wYvHaZ4v7Yy7i1ASTgTdh/UYUNIPDi2yTP7tYpXM0?=
 =?us-ascii?Q?blVsekK3yy6MYHzlBxVSmC3E0o+UtZlN05lfT6wfucAG2rBxQtZm1qYhF9ST?=
 =?us-ascii?Q?J5FL34rH2IVlcRVrwp5Sx3YMkg7oMIdpdv93YTQT3xHX7Iabd3Ks124jDbvy?=
 =?us-ascii?Q?MVvnKW7hJTyCXBEFxhour87ddx9ljY2rSB5VpGiAzBSeLzMOhB/XhzxWkEwj?=
 =?us-ascii?Q?PRGXnZ0xvyhvCVAxnfBbbdw8jPovhZBhx2BZ0v1JOfzTRZdEyQnQJdoVDK0n?=
 =?us-ascii?Q?anmqCBt2uizGdHZUu8uqRy/R/kqF2vFVrT6XBw4cf986xDVlYSJvtRPC/xd4?=
 =?us-ascii?Q?fTgH0mHQHFoEf5UQEDetberbjnt/HUs921I6Iv8Clp7Aecb/BzrWMdYMGVU7?=
 =?us-ascii?Q?kP/beBaANAD5g3T8HIod42sDaNgPEzPnBaB8UNGyfR0M0Iemx10igjA2blyJ?=
 =?us-ascii?Q?3AGCulAsGoATY93YUQe8tOdJMhGe1Wyfym/lqe7Vcji2IMy8yueeUti6jaQA?=
 =?us-ascii?Q?ALtWXzLzrsNmvO+ZreMIyleCC3RVKHuIcDDx+uJeSOzwqfv29QXbASz5cD8E?=
 =?us-ascii?Q?iFoTJBi4r3dNms9C4y6FnZD6TpKaM5nMfzzSuUdxFeYor3yvv4KkNWDPByzU?=
 =?us-ascii?Q?RqYVGHhV3SjaMs+NrImtWUdFQt3/dyg0HHJrjhQ6fAw6dOQvu+mj9DUKq+Tb?=
 =?us-ascii?Q?NoDUEDOsZrNXW/2i2h8p/UG6ts7StzfyogKKSdhH5oteiY6O8ct7POrEtyVs?=
 =?us-ascii?Q?pOb6x/GVzvmFstfm9ne+FuxudOxaHni42byKZVtOq+H+TUvzVJ71a3d5OMv/?=
 =?us-ascii?Q?aFI60GwYrL+Gx2GrWAVjjk2WVJ7i4ModwGBt3uVgkTrSZYUbCApQyvtIXA33?=
 =?us-ascii?Q?wgJD1Gs6BF+qr9SvWWdxPEiDz2C/XGXC4NNJhBRkqntP83IW7vPvbZu2MtRG?=
 =?us-ascii?Q?rAz3Cf+0ZYfISxAYSvbFcpEK6SiPVjWgI0xQROsxDR4/QztEnO0nX9A0g/h0?=
 =?us-ascii?Q?NA6+JWJlIbuRv659Bi6PInK4II56vOuOTfvukqyt0GrL1/DoH/D+r9HHhyY1?=
 =?us-ascii?Q?nhVXmN32VCv4jpTsFixus6HvEV6C7ZeIUFx1jbb2Xj3gPxbThxs9FlubUNlp?=
 =?us-ascii?Q?eWqYQ6uFiWi7Bfj6cFWt4GQiZYyL3MlFEmyB47eSifLhxXXj26yC4IUIxodE?=
 =?us-ascii?Q?CnuhqRxGoszTjNrAYomIBjb1zcb1kSkSyHzKt4ce4x2NR+GlfOjwl+msqyIJ?=
 =?us-ascii?Q?lpqpEPwFmsTJUlJHlXpYr2uqU5cr23BtWYo/fjlmBiWYALyEZz5O14c3KpNT?=
 =?us-ascii?Q?02u99g9htZoiBGey0JvHfBf3AqRZOJc8Oe6fZ4Z4irPtkdqnHvzlpXQ2hyNy?=
 =?us-ascii?Q?f73Usgo5DU2Mb3Gm75R12ASUf1w6AS/U346ujyUL4VE2H/PqQ6Uuh8uVCTNn?=
 =?us-ascii?Q?oQRL2Zc4oGyOCuS5DM7nMYKYQMjMqUIGXFDBK2cJ8gfFxoH/ychSnRApqwER?=
 =?us-ascii?Q?3g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f0125d-2af4-4062-828f-08daabcf00ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2022 21:24:38.9046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: haXycGbZ2XgVeb/HLO5uFmteSgI7d1XkHug+rrcEccMSkkuMNR5MWNx01QGYCQ5IG8tcQFFt3TapBa4HW07d3ylp0WMNCfQ6g+05OLXRO3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3552
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cezar Bulinaru <cbulinaru@gmail.com> Sent: Tuesday, October 11, 2022 =
12:26 PM
>=20
> A bugcheck is trigered when the response message len exceeds
> the size of rndis_message. Inside the rndis_request structure
> these fields are however followed by a RNDIS_EXT_LEN padding
> so it is safe to use unsafe_memcpy.
>=20
> memcpy: detected field-spanning write (size 168) of single field "(void *=
)&request-
> >response_msg + (sizeof(struct rndis_message) - sizeof(union
> rndis_message_container)) + sizeof(*req_id)" at drivers/net/hyperv/rndis_=
filter.c:338
> (size 40)
> RSP: 0018:ffffc90000144de0 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: ffff8881766b4000 RCX: 0000000000000000
> RDX: 0000000000000102 RSI: 0000000000009ffb RDI: 00000000ffffffff
> RBP: ffffc90000144e38 R08: 0000000000000000 R09: 00000000ffffdfff
> R10: ffffc90000144c48 R11: ffffffff82f56ac8 R12: ffff8881766b403c
> R13: 00000000000000a8 R14: ffff888100b75000 R15: ffff888179301d00
> FS:  0000000000000000(0000) GS:ffff8884d6280000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055f8b024c418 CR3: 0000000176548001 CR4: 00000000003706e0
> Call Trace:
>  <IRQ>
>  ? _raw_spin_unlock_irqrestore+0x27/0x50
>  netvsc_poll+0x556/0x940 [hv_netvsc]
>  __napi_poll+0x2e/0x170
>  net_rx_action+0x299/0x2f0
>  __do_softirq+0xed/0x2ef
>  __irq_exit_rcu+0x9f/0x110
>  irq_exit_rcu+0xe/0x20
>  sysvec_hyperv_callback+0xb0/0xd0
>  </IRQ>
>  <TASK>
>  asm_sysvec_hyperv_callback+0x1b/0x20
> RIP: 0010:native_safe_halt+0xb/0x10
>=20
> Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>
> ---
>  drivers/net/hyperv/rndis_filter.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis=
_filter.c
> index 11f767a20444..eea777ec2541 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -20,6 +20,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/ucs2_string.h>
> +#include <linux/string.h>
>=20
>  #include "hyperv_net.h"
>  #include "netvsc_trace.h"
> @@ -335,9 +336,10 @@ static void rndis_filter_receive_response(struct net=
_device
> *ndev,
>                 if (resp->msg_len <=3D
>                     sizeof(struct rndis_message) + RNDIS_EXT_LEN) {
>                         memcpy(&request->response_msg, resp, RNDIS_HEADER=
_SIZE + sizeof(*req_id));
> -                       memcpy((void *)&request->response_msg + RNDIS_HEA=
DER_SIZE + sizeof(*req_id),
> +                       unsafe_memcpy((void *)&request->response_msg + RN=
DIS_HEADER_SIZE + sizeof(*req_id),
>                                data + RNDIS_HEADER_SIZE + sizeof(*req_id)=
,
> -                              resp->msg_len - RNDIS_HEADER_SIZE - sizeof=
(*req_id));
> +                              resp->msg_len - RNDIS_HEADER_SIZE - sizeof=
(*req_id),
> +                              "request->response_msg is followed by a pa=
dding of RNDIS_EXT_LEN inside rndis_request");
>                         if (request->request_msg.ndis_msg_type =3D=3D
>                             RNDIS_MSG_QUERY && request->request_msg.msg.
>                             query_req.oid =3D=3D RNDIS_OID_GEN_MEDIA_CONN=
ECT_STATUS)
> --
> 2.37.1

Thanks for fixing this.  I had it on my list of things to look at this week=
, but
I probably would have beat my head against the wall trying to get memcpy()
to work without generating the warning.  I can see now that the way the
RNDIS_EXT_LEN padding is set up, using the unsafe version is the only choic=
e.
Maybe there's a better way to embed the struct rndis_message and padding
inside the struct rndis_request, but that better way isn't obvious.  Any ch=
ange
would have ripple effects through code that is carefully crafted to reject
malformed and potentially malicious messages, so it's best to leave it as i=
s.

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
