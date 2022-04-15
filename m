Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C8E502103
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 05:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349190AbiDODvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 23:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349180AbiDODvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 23:51:19 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020016.outbound.protection.outlook.com [52.101.61.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38BE8BE16;
        Thu, 14 Apr 2022 20:48:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqLJ5QdqZG0O5GfbeMQCH6ANLRfl/gwBrl19ZFgBs1riG7WBOky2hxdCBOCW5PnfJPwlhAC9ybBylvanwJiSvXHwhYcKGy+PiM6mvY6HxS8/yc94L/m46i0fgvNG9jvLDmni0WoCqY9j9a+IGKO3bVFIUATBkCDV1lmchB3dXuk9zDmOdFN5vXV9Ugtqbi6WEIWLBzwGU3NGPwhWdPfIB1ITrMBXsIveZpmBW/p2RzAp1cMvPndPmY9mDKiTENId9Aw1o8zK4mL+eJJESrT1zLTW+iex8G6bZ13509GcSiucrvIiYGw69ssAwlgVMCebAvZBoXrbx8mqRC+BKRPMfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BBfXCpwZ3cmNpWytpm205dlC1h4SQrTDvz567h6/pDI=;
 b=K99OKO13fQGn14vrihq5f085ggC/NhE1tqqkOZK2pbGzyuDdq6fJyFju7Etn4x+ssV67GO1RI6LWOz3C8PmbdJKwEoStrR1SUVPKWJpwPTEktwRP6mW+ZVMlSsPIWNJmvXouPw0chQifCIhiS2sKFglU0Yn6kXW1vhjpnd3UeoTuGHpMT6oKUtPVDQFYiBJLKYuLFQYQ7qO0AivxBTsR4I/zLDfpiPdr1enz+xQpnKa21DguMdB3iFFGsMqI0MZ6inN824eX33B7p1O6KSCAIW0DX+PCMRNStvo+l6IK9nGzHMWHsjpIutDgGSbdqgmX4VrgWsnwFm1EmuGQ4WVMgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BBfXCpwZ3cmNpWytpm205dlC1h4SQrTDvz567h6/pDI=;
 b=M92QrNfjgB7FUs0bifn4/DNBUjrizC+Lz7d3QG2NUAXYgEE3SeRi5huwWPMWAkeolv2w1F0XtXYUmHHHQVrwu+A54jiEOgDXn6dY2toV4aPD7iVqgBmr3/Na1dfhx8T3Af/Ti3GoxHyL3br7kt9qEvjaFlPV7AeM/JlVmLvy4k0=
Received: from PH0PR21MB3025.namprd21.prod.outlook.com (2603:10b6:510:d2::21)
 by BL1PR21MB3256.namprd21.prod.outlook.com (2603:10b6:208:398::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.6; Fri, 15 Apr
 2022 03:34:06 +0000
Received: from PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ac09:6e1b:de72:2b2f]) by PH0PR21MB3025.namprd21.prod.outlook.com
 ([fe80::ac09:6e1b:de72:2b2f%9]) with mapi id 15.20.5186.009; Fri, 15 Apr 2022
 03:34:06 +0000
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
Subject: RE: [RFC PATCH 6/6] Drivers: hv: vmbus: Refactor the ring-buffer
 iterator functions
Thread-Topic: [RFC PATCH 6/6] Drivers: hv: vmbus: Refactor the ring-buffer
 iterator functions
Thread-Index: AQHYT3fNSP/rWeVvYk6P66NWBULOUKzwUztw
Date:   Fri, 15 Apr 2022 03:34:06 +0000
Message-ID: <PH0PR21MB302516C5334076716966B7EED7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-7-parri.andrea@gmail.com>
In-Reply-To: <20220413204742.5539-7-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9d247b11-9b73-42f1-aee8-9d7854ab4de3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-04-15T03:29:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1de2120e-dc72-438b-03ef-08da1e90cb6a
x-ms-traffictypediagnostic: BL1PR21MB3256:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <BL1PR21MB3256EB4EBD31169B3DFAA318D7EE9@BL1PR21MB3256.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gf4RfzRk0TsGzvBLjrv55L8vkRggycr7ReUDAcUswROWVn71uFgZCW0KTpMr6caJ7uiGex2+nE+j0Z1KOQppYrGvKCfNa7qTKyeHzT9Jw0EuhmpS+qODQedZNN0l+w078cCth/pjHkFBKVLudsc6Hf495UJb4iyUh+WbwVqkiPIWIT0oqzgercZJGTAkGTbwoY3XmfH8+9/dzYE3vcfCcjyi6LSxBXGccvwsWQTKvVRTW1gZVGE7VIsCnyaYnU+WOY5dV3w0TZDoGEZv9lxtaOh2+/8H4PrDUxDxx8ew4znyivGYu6rEDF2zBnauonbOrfCk44+besdmRfHZOaNtBhle1Di1ILM9W73kwVAUK2zSQC/Wkw4qioK5rFRSjEJizQajRWvPXewXT+MMBDEQve+aeQ9fkJkqlHGHo2+A9P4Z6TabUPcvrsmyZd+QLA8UGW4lIOPvlO9JGCBG9vA91z0U+fTQo3tjpv+UzqMEovJGJWDhndc1UicFvi3iIZ+FycRarM9mz4YyvmAxajxrd60BGN6h8DjJmpwMi1Ia7hXnuYvhNKVmPmhNMw0559oqb9bUc5e005elGOMWwy8W6C/uGSCWqx+U/OotF3LyRNn12VcqCchYSOJAB0ZRjt5nNmRR53hqIJm45PGDjSzcx+PMdJWDWqV+fZuexDjizIIZ6ypXd/AhMahj3aF52S8Jhrkr7wPs8MQNNVHLfEG17yXBfRkfihaB/08ztvKRS2jUPEdK7TUHFKV5y7dzvPjQaj826R1pNCZOSw6qGiUD/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR21MB3025.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(508600001)(921005)(55016003)(82950400001)(82960400001)(38100700002)(38070700005)(10290500003)(66476007)(7696005)(122000001)(6506007)(316002)(66556008)(66946007)(54906003)(110136005)(71200400001)(76116006)(4326008)(66446008)(64756008)(8676002)(86362001)(52536014)(8990500004)(83380400001)(33656002)(7416002)(5660300002)(8936002)(2906002)(186003)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pkEsGk8T7BbRHOfik+EsJ/LYWrW3eThHr24XJuur/OYGnb/1SeqlaDvPULkM?=
 =?us-ascii?Q?ONODsT2ZcTJjE/nOjbvoY+zb9OVVCpb14TWRGwK+eUiBM8EdCaiPul97DsYy?=
 =?us-ascii?Q?EzGxucwPsHpJGlCyYJgH+mGhKHwUz9Ss4ZJsPPVP1prjOV0ANzDJjjO9Wtz7?=
 =?us-ascii?Q?8un8BLrSuqEp3XytCuPrfhdtb9fJdlUShLQJuqcfeDCAcTL1ipC77xWAnZ0h?=
 =?us-ascii?Q?GGCDrXd1iJRaIoFeM2ZOomCXHdfgQ7HTODE99Md2kaZzQSW0J43zKUOXUDJq?=
 =?us-ascii?Q?6Fg+FlADQ+FuxjmupY2gVdrNTz/elJStqswY0WGutDuhKy57EdtOOD0SjuI2?=
 =?us-ascii?Q?YbF3DxZfyOVxcP9Wc9mzL28TKeyd+3a+kidb5cjcbl4VZ03FdIAyFUJvzIuk?=
 =?us-ascii?Q?gILeUnxKsoE8Md+CD8lR53DtN6j7SIOBxKdLVvJxH2VgFIGyourJ8KcfUanR?=
 =?us-ascii?Q?Qr/n7BraU4qA5bPavLRuBon94LX3/kOoHuNajt9WdvvJIM+sln+c2IFlzlH9?=
 =?us-ascii?Q?rD5S2C97V8c0Nj69I6tPSefmUTa8+4s7DHYtZCg/dXY7b6SQE5jG85hLZufp?=
 =?us-ascii?Q?0dC9WBKQbUhSlVJKdaTuUgTJlMc1OcYzS35SzXZnvnpAa1vTi7gmoH6m4MU2?=
 =?us-ascii?Q?dva/DEiHyo5hM/lJ9s0qGmvEC1oAxNgOs55fiFBf8A4FVshihYG2cy2FAopW?=
 =?us-ascii?Q?kqhq6CO+wWigjg37Z/wFqZ4C6t8njPJXEw6fyNzyfrc9Wxr5I6Oup6T1IIgb?=
 =?us-ascii?Q?GwqOdOKHP1WsPdH3d23XvlWQO+ghhgp+75IZZN3o1I4dpmWOaWUNuKKuzyw0?=
 =?us-ascii?Q?tj/BAeX09K2IzLsfhRp3Sqg781BaPRB8zE2bjAaBP9/kiyJ2p6bJ0wGLPgcU?=
 =?us-ascii?Q?WiKXGtEulj1GKyl8kIpA6KcB9khAKxY9aPW3a3T3pZtNYZu84+TcgY6Z51mC?=
 =?us-ascii?Q?M2tdwNB2l6AXc0chhG1NFWjSPtBMpzRPAsSCelxg+ysAB09vRABuG2wEJrCj?=
 =?us-ascii?Q?YiBaC0YJ6F+u9GCAuDZkHREttJeNlE5RNmslVhIOCFtF/xI/2d/m+7/4me6F?=
 =?us-ascii?Q?rc39iCQu6i85MdWg7ILQjtbR8gcKYKrZ1NywZdtUk1gvEGUH/QYKhTEUkZgh?=
 =?us-ascii?Q?NkmQo3Lh80OLpSzg2Jc2yTGlIGEnKE0mjt86TA6UW94TSM2pWcHB588ih5wn?=
 =?us-ascii?Q?V2Mki/78aN7zlmpxN3hx/5D0tLUpRLMMo/GK5yfqhMdWgHHVbnfraw8g412N?=
 =?us-ascii?Q?P1qv851iffgyrBOBEJqFu4kBU27/d++RPw6nAAkpdaPtdnhigCQcl+QPOZE4?=
 =?us-ascii?Q?OPV+CRzHsI9CF5fTfNQOik3kzlFTmlB2qBeSXh1hBUxy5nGBI6+0BBFULFT3?=
 =?us-ascii?Q?x5Vc+MfoLT2ozWkIFFzCR+P1v3flXCdqYUlShb1cm/vq5onVnbB8wg88W0l+?=
 =?us-ascii?Q?7roxtStUD0VboU1KThYQjnkXmc1iJHBkCVPXfJjTfs8cIxevhFDKVzYFQYlS?=
 =?us-ascii?Q?+jgbKPesyzkoNlDZUSMZt9wujxJl3tUDeS9nkFP3VfiB5mFm9qSIJ5sN53SL?=
 =?us-ascii?Q?zgB+SL0U8mUN2dk9m2K9ILezA+OQ9M5EyfufcXaXPwTrZ3iDgeu8baHFNEvV?=
 =?us-ascii?Q?XK26kvCnwwrtpiMGHQv8TNXNIslzUVFNyp5NSb/fEDJPQAmpzuSNk9qA7Efm?=
 =?us-ascii?Q?NJFc+RkErJaZq+Vl1QOlRMArOBqsOeXZlq6wZ0uWXp+XiJgabSRkzUZ+writ?=
 =?us-ascii?Q?chQyvtUNjxh9KG+wcZYJpL7Po/qX/74=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR21MB3025.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de2120e-dc72-438b-03ef-08da1e90cb6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 03:34:06.2493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3MuRMbGDWig23YB/bYsvBfSkPL0bnEr7Uom2Ah170oDin2oNQUlBg68WXNz2kSJhP+MCJ5aG8zaDg5YahSTt3njliEGvK5LV4g8K85HUp0Q=
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
> With no users of hv_pkt_iter_next_raw() and no "external" users of
> hv_pkt_iter_first_raw(), the iterator functions can be refactored
> and simplified to remove some indirection/code.
>=20
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> ---
>  drivers/hv/ring_buffer.c | 11 +++++------
>  include/linux/hyperv.h   | 35 ++++-------------------------------
>  2 files changed, 9 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
> index 3d215d9dec433..c9357dae2a2c8 100644
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
> @@ -459,7 +459,8 @@ static u32 hv_pkt_iter_avail(const struct hv_ring_buf=
fer_info
> *rbi)
>  /*
>   * Get first vmbus packet without copying it out of the ring buffer
>   */
> -struct vmpacket_descriptor *hv_pkt_iter_first_raw(struct vmbus_channel *=
channel)
> +static struct vmpacket_descriptor *
> +hv_pkt_iter_first_raw(struct vmbus_channel *channel)
>  {
>  	struct hv_ring_buffer_info *rbi =3D &channel->inbound;
>=20
> @@ -470,7 +471,6 @@ struct vmpacket_descriptor *hv_pkt_iter_first_raw(str=
uct
> vmbus_channel *channel)
>=20
>  	return (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + rbi-
> >priv_read_index);
>  }
> -EXPORT_SYMBOL_GPL(hv_pkt_iter_first_raw);

Does hv_pkt_iter_first_raw() need to be retained at all as a
separate function?  I think after these changes, the only caller
is hv_pkt_iter_first(), in which case the code could just go
inline in hv_pkt_iter_first().  Doing that combining would
also allow the elimination of the duplicate call to=20
hv_pkt_iter_avail().

Michael

>=20
>  /*
>   * Get first vmbus packet from ring buffer after read_index
> @@ -534,8 +534,7 @@ EXPORT_SYMBOL_GPL(hv_pkt_iter_first);
>   */
>  struct vmpacket_descriptor *
>  __hv_pkt_iter_next(struct vmbus_channel *channel,
> -		   const struct vmpacket_descriptor *desc,
> -		   bool copy)
> +		   const struct vmpacket_descriptor *desc)
>  {
>  	struct hv_ring_buffer_info *rbi =3D &channel->inbound;
>  	u32 packetlen =3D desc->len8 << 3;
> @@ -548,7 +547,7 @@ __hv_pkt_iter_next(struct vmbus_channel *channel,
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

