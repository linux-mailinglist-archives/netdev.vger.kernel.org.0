Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F95509372
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 01:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383114AbiDTXR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 19:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345452AbiDTXRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 19:17:51 -0400
Received: from na01-obe.outbound.protection.outlook.com (unknown [52.101.57.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B7D15838;
        Wed, 20 Apr 2022 16:15:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GknRNaSUizrLNfiXE68gqMojMCbnDEw3ZeQEkzKmU5KjipOmQO9hBWqNIBauKcgRQ5uj108OQm8Rl6Lpjuvv3WUrOStsvurBcmoXbG1ZVyy885iUbWtIlh6NmAd3H+3JH87i/1w6Ahg/O2VwN6OwT1CSciqCc93GpoOX1Q2oAgVRBxmUpchw6ux9EWlmRI3OpQaDlHB0aAO3K0iqq2N3AgpwMgsD4F8AWMY1PX3naeb7yckjMdEErAZd+8/J4633/uGfWqFKBRg1ctz6hrRy5fXOU/MYBv085KpqfOG9tBuUoTSU3RNhSn1yns6ak34zQ3OwZ7qU/5bh5iSlSYTjXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G48gaoFMLG6KyRpgrzxv3LFh2u9c7s6gbwhig1Vylp4=;
 b=gwGoynlzGGbM/WyASP7h0ZlKoTXhbvH77GnjzEWltri+FccsRqcLuayQ7XG+rH8sIUrSIrrrEtIO/sLtELw/g7IbCfhbpk8RCHZ4DfSL0LoNI5jxaTMylt/jceBvJUTfEewatfgiyMT2Z6FwTBGOwaQJXGtvfzCLu+Asr9/sdgjiQGx2iv90BMkoJu6hBN8zmJhF5+G916P+t2kgphpW1t/+EUcaxGf7GI1l4WyPnNGcuuQCfV/WfFZoYF5Bb9iOKlB/w9RQkOYZI5t4LuWPrfbz3so783Nj4tqw8P3rFHE8LNZ1H2hOuGvAeDgNv3/S5sMxPL0a8HOlF0LRclTlGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G48gaoFMLG6KyRpgrzxv3LFh2u9c7s6gbwhig1Vylp4=;
 b=AOIe/dnvTdtSa/oBLX60TtGbXnn7gwYb4JZgv/EHtnv/DCSDrKSVsWLgRe7aoWBV40Pg+PiBTbd1SRvMQcWqyEYS9I1Lvnq1WiQu/RyHu0U8az9bks0bZpzQjdqnnRR/x/+RRMF8hq6FC7+ne91E9QO6fhrVkEYliotn8iwm864=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by DM5PR21MB0634.namprd21.prod.outlook.com (2603:10b6:3:127::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.6; Wed, 20 Apr
 2022 23:15:01 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::dd77:2d4d:329e:87df%5]) with mapi id 15.20.5206.006; Wed, 20 Apr 2022
 23:15:00 +0000
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
Subject: RE: [PATCH 5/5] Drivers: hv: vmbus: Refactor the ring-buffer iterator
 functions
Thread-Topic: [PATCH 5/5] Drivers: hv: vmbus: Refactor the ring-buffer
 iterator functions
Thread-Index: AQHYVPJSruHaMyZGKUm01yiVMWl9T6z5brnw
Date:   Wed, 20 Apr 2022 23:15:00 +0000
Message-ID: <PH0PR21MB30253EB6EBBC3BF674DD20EED7F59@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220420200720.434717-1-parri.andrea@gmail.com>
 <20220420200720.434717-6-parri.andrea@gmail.com>
In-Reply-To: <20220420200720.434717-6-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7ec502e7-3170-4548-9c01-55f53781ec4a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-20T23:13:56Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 987306b0-4223-4141-510e-08da23239804
x-ms-traffictypediagnostic: DM5PR21MB0634:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <DM5PR21MB0634C94747B70F21BFD9B521D7F59@DM5PR21MB0634.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OtCGjTZJOJS1ReRbwDI3SPT3ypUSHa2eP3aFcJLKWpBu10Gv+MgRg12zWDmYzEZO5JaZYO6dZysTGQo8VsPiTT12EYAwQiXQQTPK6tM9oHP9IFN3eovjPXGi3r914SXPrduaDBNDO2pow4WZeaLxSFwVRl51JNtLgcfETJO8OwYWEfx+8xP1Oe28IiE8uLcwe8DTJVTE2s7+AISgAndjbycl7IACut1QYsfYtZJykKbV5HZ4KBiKw5j/7gLBeMkrZqyS8dZFsZW2oo9qTjfo1DiYXukXVtwOH466dxKrs+rG7mlcKLlj8/Fo2hNwqDFkDWSyXVsp1ZlWU6lcjj26cNav8tcB+nFnmyXUP/ZfizM2k9t+x32n+a9WwzMsYMwvj6YwKZbK2AAUwXQo7AWwMkQhAvD6BRy75uMPc+1UcUPN+hnmccelOEm+8PeebzgsmY0TRWdXt9CA8w0M4h50KvbvK4DGw6SYtCkJj4p9IKmIS/Q6qUDv4re5jSVc+CvkbUFG7s0RcrpYKgNUE/IgWUSilYN1p7DTyc5HGD3KH9TIeU3epahZi0nkotaOlJDu+rPCB3MyhHAHcAXSHF/K3iSOFRaA2wKmETjc/HCmsPrGh1U475XoCybA34DSD8r3U9X4ZGu11L9SYoP0vmBkbpZAbMkGOBZn9VJ6ZbbhCIFmyDuhD8etY072Rouzn2u76KWUn643kDz38ZXnRC/l5y4iaYxjOGWL+hDIz1l+r1I9uLcg/tOlnBmf4his1Wl4bPvz8uXNMfeXxihzbeFlig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(26005)(8990500004)(6506007)(86362001)(2906002)(9686003)(186003)(110136005)(66946007)(7696005)(4326008)(54906003)(316002)(8676002)(64756008)(66446008)(76116006)(10290500003)(66476007)(66556008)(38100700002)(83380400001)(38070700005)(122000001)(55016003)(508600001)(5660300002)(7416002)(71200400001)(82950400001)(8936002)(52536014)(33656002)(82960400001)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8xsx4yAPsa0fcDBQrCzDnfBnD5u2Tz6+pjKWNsrgX4Bkx4HATWSr8Vimh9Sp?=
 =?us-ascii?Q?dw8DLZfnMRsupIa8VPGjRoUMSObPK+cfNJvyxCF0uK+jEPbpzpq35QYGniPk?=
 =?us-ascii?Q?Ra0Sg5eYi6Nfj8xZbanuWlU9bBQRl+zWYOPs0F6loYUCjwF5g3RmBvoJO34M?=
 =?us-ascii?Q?ojGfjWmOr4B4bT7IkDLFuaSCNUnB7sEfkGIFMwCTDZWK69m/lHa0a2I1hrIp?=
 =?us-ascii?Q?WGWMjvVMQUyNHxBPZLGsVuPd8sLWrL8aFi3j2XalvrJRT7oYt+8q5p9d2YOf?=
 =?us-ascii?Q?uCoF4+nDPNfbht4lhPyqgmwyzEbIZs6orbpyzErC+MDsf3aiOciWD854Qi0A?=
 =?us-ascii?Q?wUfdsB5osrG6WIU/CDsY4bOjMzQKwEp4PppCbBOfniSO1CQUll6gg6tqlMs0?=
 =?us-ascii?Q?BK1WGL9JrJQWZ8Hu750wSXW7uoqmCEq+76Fi+FBJ3WCI4pjBFhAgGwU5wLRE?=
 =?us-ascii?Q?ADyIVOTECEr15jQxId3zn0DUtOMC9ExiuiryI6eFdWjTSXpwLOvAI6sEWyhb?=
 =?us-ascii?Q?/U902GIEcOojt9J4YF+n0UqEV/J5wR2GGq2GTTOsKQpmDCkNWFelV6Mu/jNP?=
 =?us-ascii?Q?WiKqclkFg8MYFP4ji70c6bnir4K7vfx1K/rpxNxqvRtG3Hm4IPQn5VOPPHmv?=
 =?us-ascii?Q?MIHgyib4aBqPJunV7gan7GO4V1P9gJfPTwiQu3kTLHYt/4DANUDfLhly0l9g?=
 =?us-ascii?Q?4A95nsOqfEjVNXxYGvoOISjsw6f98etHwDmhrKhEq8U5RKEwhTMjOTOOhS8/?=
 =?us-ascii?Q?3uEfTMJU+GYtHKLDtbKMbz82HKxGevPV6LOjuxZgtvSJFF0fAGqxcqz0EA5B?=
 =?us-ascii?Q?l1FZMIde46xXzIE29uGOyfxKitqVGArCz9G4B10Q7p0T+zckrFsHJP5e1lef?=
 =?us-ascii?Q?uJ5uI/i/Uo41ZqZDVa+xU/iWqRBFc4Z2cE4xd+fJHbpUpJPkXlR7lSz37X7/?=
 =?us-ascii?Q?V/8xjdlx6RClf92NEsTBvBOWNhBcI6jHiIR87l+nMRwqzOk4Q7NTool5ZjoU?=
 =?us-ascii?Q?n7AAuLmPR6hB5/XbiDGnmPaten7VAfToUKF8EUbvIdtQy6wxNCNqua5GcVJp?=
 =?us-ascii?Q?nwBjblmUAQ4KWQQct4Bbw0qRYkIZmK6NLfzK9pjKdTkjv+NCoz8ohg4MbDxP?=
 =?us-ascii?Q?wy9fSrTytnOCF14hCTzGNhn4FTg1R3PrOiG2pTJpw2wxx7n2b9ml+L/fjcPA?=
 =?us-ascii?Q?xuS9/lQwq7YlNipcYF1sl7Gh1AtjpEYL95T2dXwNk+EK69ACyVdvalgZQOxA?=
 =?us-ascii?Q?QbBH9ZU7yJnidiMCvWzFzTtaO8EyDxo+IErCUV9JEqMVO9C3BB1+J9Y7eePr?=
 =?us-ascii?Q?KW28uo2DIi0du3uQ3KDooUbjyJHbNxN9CAzJ3Od5E18oLfAWwd9ih5750xxI?=
 =?us-ascii?Q?tDjkZ1LBZBph5QqZYEdTLd2YuyFF/4LYtNoZqwtF2BRcwdF08K37NNVGbwwE?=
 =?us-ascii?Q?M1AN+0jWJ3HMD/efWmpLgyiLimxauIrVZExmUJXLZn9P+8CSTmOYrHrxFuyG?=
 =?us-ascii?Q?J/UC6BD17idc/XoFnwzJZvC4/Kp6B9Kdi3d6OtE7ZN6uMtAmbE8GGH1FSwrW?=
 =?us-ascii?Q?dJJLWpO6vj42gVMTcP2cRC8HOzvjQQClcw+PG0pWeMrW5VFgDZ79U9OGi1U9?=
 =?us-ascii?Q?IZN9pN0YNNlUbH+VdP3AS57kgHrd98qPVnBI5F1UTl966u0hQW86WsXaKL+W?=
 =?us-ascii?Q?t6ipzGFwjsFWBJBn59ztQga/aMhmvk1Ufz/MYvAZRlB9L0SeteTYkb+ib3YX?=
 =?us-ascii?Q?u1UPsFrLMWv+eHiFKWTszh+I+QXoIYM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 987306b0-4223-4141-510e-08da23239804
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 23:15:00.6793
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jtbFOuSVX/vHvJGScy0EJTs8N7LxamtoNjYf91LQ1WS5lrE+CeEJr2zGpVhZUzIBdF3dV89reE69CGnaxC8CyDmXg5A/4aLuxPJHHSfQdxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0634
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Wednesday, Ap=
ril 20, 2022 1:07 PM
>=20
> With no users of hv_pkt_iter_next_raw() and no "external" users of
> hv_pkt_iter_first_raw(), the iterator functions can be refactored
> and simplified to remove some indirection/code.
>=20
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> ---
>  drivers/hv/ring_buffer.c | 32 +++++++++-----------------------
>  include/linux/hyperv.h   | 35 ++++-------------------------------
>  2 files changed, 13 insertions(+), 54 deletions(-)
>=20
> diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> index 3d215d9dec433..fa98b3a91206a 100644
> --- a/drivers/hv/ring_buffer.c
> +++ b/drivers/hv/ring_buffer.c
> @@ -421,7 +421,7 @@ int hv_ringbuffer_read(struct vmbus_channel *channel,
>  	memcpy(buffer, (const char *)desc + offset, packetlen);
>=20
>  	/* Advance ring index to next packet descriptor */
> -	__hv_pkt_iter_next(channel, desc, true);
> +	__hv_pkt_iter_next(channel, desc);
>=20
>  	/* Notify host of update */
>  	hv_pkt_iter_close(channel);
> @@ -456,22 +456,6 @@ static u32 hv_pkt_iter_avail(const struct hv_ring_bu=
ffer_info
> *rbi)
>  		return (rbi->ring_datasize - priv_read_loc) + write_loc;
>  }
>=20
> -/*
> - * Get first vmbus packet without copying it out of the ring buffer
> - */
> -struct vmpacket_descriptor *hv_pkt_iter_first_raw(struct vmbus_channel *=
channel)
> -{
> -	struct hv_ring_buffer_info *rbi =3D &channel->inbound;
> -
> -	hv_debug_delay_test(channel, MESSAGE_DELAY);
> -
> -	if (hv_pkt_iter_avail(rbi) < sizeof(struct vmpacket_descriptor))
> -		return NULL;
> -
> -	return (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + rbi-
> >priv_read_index);
> -}
> -EXPORT_SYMBOL_GPL(hv_pkt_iter_first_raw);
> -
>  /*
>   * Get first vmbus packet from ring buffer after read_index
>   *
> @@ -483,11 +467,14 @@ struct vmpacket_descriptor *hv_pkt_iter_first(struc=
t
> vmbus_channel *channel)
>  	struct vmpacket_descriptor *desc, *desc_copy;
>  	u32 bytes_avail, pkt_len, pkt_offset;
>=20
> -	desc =3D hv_pkt_iter_first_raw(channel);
> -	if (!desc)
> +	hv_debug_delay_test(channel, MESSAGE_DELAY);
> +
> +	bytes_avail =3D hv_pkt_iter_avail(rbi);
> +	if (bytes_avail < sizeof(struct vmpacket_descriptor))
>  		return NULL;
> +	bytes_avail =3D min(rbi->pkt_buffer_size, bytes_avail);
>=20
> -	bytes_avail =3D min(rbi->pkt_buffer_size, hv_pkt_iter_avail(rbi));
> +	desc =3D (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + rbi-
> >priv_read_index);
>=20
>  	/*
>  	 * Ensure the compiler does not use references to incoming Hyper-V valu=
es
> (which
> @@ -534,8 +521,7 @@ EXPORT_SYMBOL_GPL(hv_pkt_iter_first);
>   */
>  struct vmpacket_descriptor *
>  __hv_pkt_iter_next(struct vmbus_channel *channel,
> -		   const struct vmpacket_descriptor *desc,
> -		   bool copy)
> +		   const struct vmpacket_descriptor *desc)
>  {
>  	struct hv_ring_buffer_info *rbi =3D &channel->inbound;
>  	u32 packetlen =3D desc->len8 << 3;
> @@ -548,7 +534,7 @@ __hv_pkt_iter_next(struct vmbus_channel *channel,
>  		rbi->priv_read_index -=3D dsize;
>=20
>  	/* more data? */
> -	return copy ? hv_pkt_iter_first(channel) : hv_pkt_iter_first_raw(channe=
l);
> +	return hv_pkt_iter_first(channel);
>  }
>  EXPORT_SYMBOL_GPL(__hv_pkt_iter_next);
>=20
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 1112c5cf894e6..370adc9971d3e 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1673,55 +1673,28 @@ static inline u32 hv_pkt_len(const struct
> vmpacket_descriptor *desc)
>  	return desc->len8 << 3;
>  }
>=20
> -struct vmpacket_descriptor *
> -hv_pkt_iter_first_raw(struct vmbus_channel *channel);
> -
>  struct vmpacket_descriptor *
>  hv_pkt_iter_first(struct vmbus_channel *channel);
>=20
>  struct vmpacket_descriptor *
>  __hv_pkt_iter_next(struct vmbus_channel *channel,
> -		   const struct vmpacket_descriptor *pkt,
> -		   bool copy);
> +		   const struct vmpacket_descriptor *pkt);
>=20
>  void hv_pkt_iter_close(struct vmbus_channel *channel);
>=20
>  static inline struct vmpacket_descriptor *
> -hv_pkt_iter_next_pkt(struct vmbus_channel *channel,
> -		     const struct vmpacket_descriptor *pkt,
> -		     bool copy)
> +hv_pkt_iter_next(struct vmbus_channel *channel,
> +		 const struct vmpacket_descriptor *pkt)
>  {
>  	struct vmpacket_descriptor *nxt;
>=20
> -	nxt =3D __hv_pkt_iter_next(channel, pkt, copy);
> +	nxt =3D __hv_pkt_iter_next(channel, pkt);
>  	if (!nxt)
>  		hv_pkt_iter_close(channel);
>=20
>  	return nxt;
>  }
>=20
> -/*
> - * Get next packet descriptor without copying it out of the ring buffer
> - * If at end of list, return NULL and update host.
> - */
> -static inline struct vmpacket_descriptor *
> -hv_pkt_iter_next_raw(struct vmbus_channel *channel,
> -		     const struct vmpacket_descriptor *pkt)
> -{
> -	return hv_pkt_iter_next_pkt(channel, pkt, false);
> -}
> -
> -/*
> - * Get next packet descriptor from iterator
> - * If at end of list, return NULL and update host.
> - */
> -static inline struct vmpacket_descriptor *
> -hv_pkt_iter_next(struct vmbus_channel *channel,
> -		 const struct vmpacket_descriptor *pkt)
> -{
> -	return hv_pkt_iter_next_pkt(channel, pkt, true);
> -}
> -
>  #define foreach_vmbus_pkt(pkt, channel) \
>  	for (pkt =3D hv_pkt_iter_first(channel); pkt; \
>  	    pkt =3D hv_pkt_iter_next(channel, pkt))
> --
> 2.25.1

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

