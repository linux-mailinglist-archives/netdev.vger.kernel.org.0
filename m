Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00386153D8B
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 04:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgBFDUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 22:20:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24824 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727474AbgBFDUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 22:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580959243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VAlJIEy4W7LryrILkAsZre4wcOnjEJkFgrUe9djfLWE=;
        b=XSbHL1bar6p/nHe58e+pwX/oF8IcGjMWvFXVkvvxHfTs3xdcACQQTODNcO4SlACo1SPqwL
        oRDmNzunvmCe5vzOIFtYjw8leF9B9DiqUhKvnltV+wx3X93/PkI71b5g3XHYcdszOK6M2w
        /Lpt05UDegAENxct1XyuCs9RiUEZ650=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-raeigLSNMYihxScUEsnOvQ-1; Wed, 05 Feb 2020 22:20:39 -0500
X-MC-Unique: raeigLSNMYihxScUEsnOvQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D462F8018A1;
        Thu,  6 Feb 2020 03:20:36 +0000 (UTC)
Received: from [10.72.13.85] (ovpn-13-85.pek2.redhat.com [10.72.13.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE12F790CF;
        Thu,  6 Feb 2020 03:20:27 +0000 (UTC)
Subject: Re: [PATCH bpf-next v4] virtio_net: add XDP meta data support
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        mst@redhat.com, songliubraving@fb.com, yhs@fb.com, kuba@kernel.org,
        andriin@fb.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <8da1b560-3128-b885-b453-13de5c7431fb@redhat.com>
 <20200204071655.94474-1-yuya.kusakabe@gmail.com>
 <9a0a1469-c8a7-8223-a4d5-dad656a142fc@redhat.com>
 <1100837f-075f-dc97-cd14-758c96f2ac1d@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0c5eaba2-dd5a-fc3f-0e8f-154f7ad52881@redhat.com>
Date:   Thu, 6 Feb 2020 11:20:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1100837f-075f-dc97-cd14-758c96f2ac1d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/5 =E4=B8=8B=E5=8D=885:18, Yuya Kusakabe wrote:
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case XDP_TX:
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 stats->xdp_tx++;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 x=
dp.data_meta =3D xdp.data;
>> Any reason for doing this?
> XDP_TX can not support metadata for now, because if metasize > 0, __vir=
tnet_xdp_xmit_one() returns EOPNOTSUPP.
>
> static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
> 				   struct send_queue *sq,
> 				   struct xdp_frame *xdpf)
> {
> 	struct virtio_net_hdr_mrg_rxbuf *hdr;
> 	int err;
>
> 	/* virtqueue want to use data area in-front of packet */
> 	if (unlikely(xdpf->metasize > 0))
> 		return -EOPNOTSUPP;
>
>

I see.

Then I think it's better to fix __virtnet_xdp_xmit_one() instead.

Thanks


