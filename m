Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA1FE10E494
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 03:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfLBCpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 21:45:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22828 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727298AbfLBCpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 21:45:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575254754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A5SS3ilN57be+dKCEWLuoWs9cfIT9f/3tFpS4mzNsu0=;
        b=IvI9i81OZBUfTWD+PCELdh0wzQNPh6lePAGj3ZyzbGeZZuggLZM0eDRSYhb046qcO5l/I6
        C0ye1RwrtEICEKySmliNnOJQBHuiUyccyPFVU6fqA4qfaCYso/AORaWKEF/TFJRy4q6mUr
        7SpkwaZMpobfAWCH87jhmlKnEHixduM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-M13GqMyeMo-aN-w95nrSwQ-1; Sun, 01 Dec 2019 21:45:52 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1950E107ACC4;
        Mon,  2 Dec 2019 02:45:49 +0000 (UTC)
Received: from [10.72.12.226] (ovpn-12-226.pek2.redhat.com [10.72.12.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CFB260BFB;
        Mon,  2 Dec 2019 02:45:41 +0000 (UTC)
Subject: Re: [RFC net-next 08/18] tun: run offloaded XDP program in Tx path
To:     David Ahern <dsahern@gmail.com>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
 <20191126100744.5083-9-prashantbhole.linux@gmail.com>
 <f39536e4-1492-04e6-1293-302cc75e81bf@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <af0ce325-15ea-e3fd-9c20-fd4296266e63@redhat.com>
Date:   Mon, 2 Dec 2019 10:45:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f39536e4-1492-04e6-1293-302cc75e81bf@gmail.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: M13GqMyeMo-aN-w95nrSwQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/12/2 =E4=B8=8A=E5=8D=8812:39, David Ahern wrote:
> On 11/26/19 4:07 AM, Prashant Bhole wrote:
>> run offloaded XDP program as soon as packet is removed from the ptr
>> ring. Since this is XDP in Tx path, the traditional handling of
>> XDP actions XDP_TX/REDIRECT isn't valid. For this reason we call
>> do_xdp_generic_core instead of do_xdp_generic. do_xdp_generic_core
>> just runs the program and leaves the action handling to us.
> What happens if an offloaded program returns XDP_REDIRECT?
>
> Below you just drop the packet which is going to be a bad user
> experience. A better user experience is to detect XDP return codes a
> program uses, catch those that are not supported for this use case and
> fail the install of the program.


Yes, this could be done in the guest.

Thanks

