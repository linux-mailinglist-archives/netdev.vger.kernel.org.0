Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03DF15FCBC
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 06:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgBOFYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 00:24:01 -0500
Received: from mail-eopbgr1300103.outbound.protection.outlook.com ([40.107.130.103]:24928
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725795AbgBOFYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 00:24:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvAHt6cY9m/GgDEl5DMqkDI/UtvNEdSb5xar1Yi5RGQMT5iWa4pYahl0awUARFUh24keLTKLaZvYpEXJOqfw3SJsqr0u3oEXB0mTzn1FQBIgj4oD4rnc3NbdJiLo6tJYZJrpP3XEeSP+EoMuRUnfxfLiI8Ty9RsPwi/SxzTjeD927+2N6jx0guVi6wzwdBmCVom6tFkMdUbBwpBPV20FsHPbsw6j1k0qWsNsyzLlMnJIHhx1gQTO0ZH19+3qbCd+5sPW63zWJmzJCuKAMgZKvuPdy0ak62RpeV+0DVSGDlizjx2A/+DU9Z2TvdMcP6w9Ot/PEXgjlSKaiMAc4IbX6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+TNbtH8Sw3Pdb3j14YmnUVQSiji3nf1c8Pvcdspoyk=;
 b=B0hr/PYRm7WXgGP4iseUjAap7UdHIdt5TK0sUxV8xyrXTbe45Jhiz8Y4b+3czHWz3h+lpd1g44jwopol0qA2bOF5Z+R2b8to2k0yUc0hlDkeL1loW7jjbDDaq6ypLNqYP9LPnvyG4VNhW04BOAUTZgEOIi39Q5yG4QOroVjcAL5FfwKdB0fOmEW8DxmwVl6PIvYg3GqJCPziLX8Q5WLt0gWqcReWGDBAxHmLj8BYZ7bZxD3uZlqvVQD0IqqZP9G5w8M1QNP7XBepaOobZyQuI76cyi1PTC2DUr+QMp55FmiLR2v3fUNR4P9ae9uTldZoc7U0E/WJCwx4PuTgUNoJvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+TNbtH8Sw3Pdb3j14YmnUVQSiji3nf1c8Pvcdspoyk=;
 b=E3oW9mDNsHnMhuo4cRu4lHVTOehAZiAR14euZX3lguPmhFOsZvWv0tXMmdHxeM2ljMNbStP/C4OFxcO/ZxLM3/ZAi2WVgBf1zvOrAtp4oTNWutQZLXpf1jI7qcm82QSvBMi/FxA/W/GS+PKPR89zXQYQNJ0YmJDuDi+UanHgjpA=
Received: from HK0P153MB0148.APCP153.PROD.OUTLOOK.COM (52.133.156.139) by
 HK0P153MB0244.APCP153.PROD.OUTLOOK.COM (10.255.253.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.4; Sat, 15 Feb 2020 05:23:55 +0000
Received: from HK0P153MB0148.APCP153.PROD.OUTLOOK.COM
 ([fe80::58ea:c6ae:4ea3:8432]) by HK0P153MB0148.APCP153.PROD.OUTLOOK.COM
 ([fe80::58ea:c6ae:4ea3:8432%5]) with mapi id 15.20.2750.014; Sat, 15 Feb 2020
 05:23:55 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Is it safe for a NIC driver to use all the 48 bytes of skb->cb?
Thread-Topic: Is it safe for a NIC driver to use all the 48 bytes of skb->cb?
Thread-Index: AdXjukH6tGicVKR8QjWZ+wsQCSffGw==
Date:   Sat, 15 Feb 2020 05:23:55 +0000
Message-ID: <HK0P153MB0148311C48144413792A0FBEBF140@HK0P153MB0148.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-02-15T05:23:53.1818868Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0bdb99fb-ade9-4625-91de-e48aae6b21ec;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:9:9a10:13a:9851:57b7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c2a50d69-2c84-4673-5dd9-08d7b1d740bd
x-ms-traffictypediagnostic: HK0P153MB0244:|HK0P153MB0244:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HK0P153MB02449C4A5664FA6810D0DAFEBF140@HK0P153MB0244.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03142412E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(39860400002)(376002)(396003)(136003)(189003)(199004)(71200400001)(8676002)(7696005)(4326008)(6506007)(86362001)(186003)(33656002)(2906002)(8936002)(81156014)(81166006)(64756008)(66446008)(316002)(66946007)(66556008)(55016002)(76116006)(10290500003)(66476007)(5660300002)(9686003)(478600001)(110136005)(8990500004)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:HK0P153MB0244;H:HK0P153MB0148.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x37SN1arD31duZQnj7GgD4PT8/7K/L6CE6C0vW/xBByIp9y6P4kgd+V5JNk8xdcLjb4NvmcP7w/3dXEbd+vbvMluX/ISQFuEijlcip23iQmb5Fpf2zGHn9J9UO7WvC7hmOJcLILKEoKo3p4kOpCzKZyOPxKEEHn/t+9tNPRBxJMgHAsd/ZVX4mvm0wsX0YYj+jykKiFdO+mSNSyxUrvJuHIyUtF8gzBP57mWwpM/+8d20DPzQe7czZj3HXvd9LMt8MKhRhepP0JWlmFB5w4TaI3o2eu+qYKLJiAiU6tmtufd3sEwTXrOChWLCKKdoVoVx9NI3xpvRnHITLEE3isiqqZuApcMVf7w9n0dFxo/ADC/gUkDsgrYAY9c4ZojndYqPjkDGUrWElO/LCoBZ21xrMKH3X7CWlIs0ZSVNXpK+hfjpBXOPDicpm3iG5OuoWIq
x-ms-exchange-antispam-messagedata: NbtndxpGpAXFjUrT0dcL81y/HPrFjJNOsOigRgtvW1gJWa7i3ao6tbha5HcFgu7uvcVV+P3F1gcJ2F5ypIYBnLo9KsiWmRrFsgtz1+AVM7m8iLeY6tBfxtwFY0gUfZ+gulKZ+SeOaV/DKDD8N/lYSPAZkgYLjz8k2iDUt95sWHNkA9KHDEB8zr/9iMvySdgjH690nX+3YyO0nycyK8LF4A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a50d69-2c84-4673-5dd9-08d7b1d740bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2020 05:23:55.4443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BEshrHY2NbAwqj4OpjbB5ngdtWpR7n147rW2qY7Ui4LOZc3cb2F1gA/7us2kEv2XUI+LtgCfd2PHlBneU6CWAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0244
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
It looks all the layers of drivers among the network stack can use the 48-b=
yte
skb->cb array. Is there any rule how they should coordinate with each other=
?

I noticed the last 16 bytes are used by struct skb_gso_cb:

include/linux/skbuff.h:
struct skb_gso_cb {
        union {
                int     mac_offset;
                int     data_offset;
        };
        int     encap_level;
        __wsum  csum;
        __u16   csum_start;
};
#define SKB_SGO_CB_OFFSET       32
#define SKB_GSO_CB(skb) ((struct skb_gso_cb *)((skb)->cb + SKB_SGO_CB_OFFSE=
T))

Does this mean a low level NIC driver (e.g. hv_netvsc) should only use
the first 32 bytes? What if the upper layer network stack starts to take up
more space in the future?=20

Now hv_netvsc assumes it can use all of the 48-bytes, though it uses only=20
20 bytes, but just in case the struct hv_netvsc_packet grows to >32 bytes i=
n the
future, should we change the BUILD_BUG_ON() in netvsc_start_xmit() to
 BUILD_BUG_ON(sizeof(struct hv_netvsc_packet) > SKB_SGO_CB_OFFSET);
? =20

struct hv_netvsc_packet {
        /* Bookkeeping stuff */
        u8 cp_partial; /* partial copy into send buffer */

        u8 rmsg_size; /* RNDIS header and PPI size */
        u8 rmsg_pgcnt; /* page count of RNDIS header and PPI */
        u8 page_buf_cnt;

        u16 q_idx;
        u16 total_packets;

        u32 total_bytes;
        u32 send_buf_index;
        u32 total_data_buflen;
};

static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
{
...
        /*
         * Place the rndis header in the skb head room and
         * the skb->cb will be used for hv_netvsc_packet
         * structure.
         */
        ret =3D skb_cow_head(skb, RNDIS_AND_PPI_SIZE);
        if (ret)
                goto no_memory;

        /* Use the skb control buffer for building up the packet */
        BUILD_BUG_ON(sizeof(struct hv_netvsc_packet) >
                        FIELD_SIZEOF(struct sk_buff, cb));
        packet =3D (struct hv_netvsc_packet *)skb->cb;

Thanks,
-- Dexuan

