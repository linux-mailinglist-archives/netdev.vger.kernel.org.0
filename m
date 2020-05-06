Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7021C6B79
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbgEFIV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:21:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37746 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728608AbgEFIV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:21:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588753288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nF+0VU5uQHo07GYFoGqtLNbg64uaIEB/qw6oVIMZLHo=;
        b=OgYb0KwvGTV8a2ylKpntvvLVomBOVTojFUiLGqIHZV5Q62X3qxI67gzZjkwtcWIl2EjkiY
        lR4GFCgK70vXUUNMscsEuM030E26aXN9ZMf/h17kXERH5FSt78To8hbOrSqrqhJtCrvUEE
        OFWk3JwLLkqTUCuEtarJuKDqc/pMuPk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-wJzohBH7M3qY_BjjNFOlpA-1; Wed, 06 May 2020 04:21:26 -0400
X-MC-Unique: wJzohBH7M3qY_BjjNFOlpA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 315A745F;
        Wed,  6 May 2020 08:21:25 +0000 (UTC)
Received: from [10.72.13.165] (ovpn-13-165.pek2.redhat.com [10.72.13.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30289579AD;
        Wed,  6 May 2020 08:21:17 +0000 (UTC)
Subject: Re: [PATCH net-next 2/2] virtio-net: fix the XDP truesize calculation
 for mergeable buffers
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <20200506061633.16327-1-jasowang@redhat.com>
 <20200506061633.16327-2-jasowang@redhat.com>
 <20200506033259-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <789fc6e6-9667-a609-c777-a9b1fed72f41@redhat.com>
Date:   Wed, 6 May 2020 16:21:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506033259-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/6 =E4=B8=8B=E5=8D=883:37, Michael S. Tsirkin wrote:
> On Wed, May 06, 2020 at 02:16:33PM +0800, Jason Wang wrote:
>> We should not exclude headroom and tailroom when XDP is set. So this
>> patch fixes this by initializing the truesize from PAGE_SIZE when XDP
>> is set.
>>
>> Cc: Jesper Dangaard Brouer<brouer@redhat.com>
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
> Seems too aggressive, we do not use up the whole page for the size.
>
>
>

For XDP yes, we do:

static unsigned int get_mergeable_buf_len(struct receive_queue *rq,
 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=
=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 struct ewma_pkt_len *avg_pkt_len,
 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=
=A0 =C2=A0=C2=A0=C2=A0 =C2=A0 unsigned int room)
{
 =C2=A0=C2=A0=C2=A0 const size_t hdr_len =3D sizeof(struct virtio_net_hdr=
_mrg_rxbuf);
 =C2=A0=C2=A0=C2=A0 unsigned int len;

 =C2=A0=C2=A0=C2=A0 if (room)
 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return PAGE_SIZE - room;

...

Thanks

