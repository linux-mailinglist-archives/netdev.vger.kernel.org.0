Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AE11C1234
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 14:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgEAMdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 08:33:04 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42282 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728682AbgEAMdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 08:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588336382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nLTDnYI3TbHO0ht913JlpD3olsc8lxgjKyl7i+ZjAHs=;
        b=ihga4zjkmv3v2Uv8NFHXMsy9/fURxfdcDy58ZD8qwgQQFWYqpQuRT3weF7G2+MWwjk77ie
        Pe6wxjJRMJp6gk/8g+zyb1e2GSyZC7GuM+VW+rS9nfP0JYOnGzI3sMDabcVmTdnAQ+WhEr
        rIK6XrlQOr06iUaV2/smOtXFfZEHLZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-QleQ580qOFqYePzlMcnqOA-1; Fri, 01 May 2020 08:32:46 -0400
X-MC-Unique: QleQ580qOFqYePzlMcnqOA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FF2880183C;
        Fri,  1 May 2020 12:32:44 +0000 (UTC)
Received: from carbon (unknown [10.40.208.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE18F648CF;
        Fri,  1 May 2020 12:32:33 +0000 (UTC)
Date:   Fri, 1 May 2020 14:32:32 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     sameehj@amazon.com, Saeed Mahameed <saeedm@mellanox.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4?= =?UTF-8?B?cmdlbnNlbg==?= 
        <toke@redhat.com>, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        steffen.klassert@secunet.com, brouer@redhat.com
Subject: Re: [PATCH net-next v2 28/33] mlx5: rx queue setup time determine
 frame_sz for XDP
Message-ID: <20200501143232.157dadb9@carbon>
In-Reply-To: <7e391f37-0db7-c034-cb97-2e8bf60fd33f@mellanox.com>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
        <158824576377.2172139.12065840702900641458.stgit@firesoul>
        <a5be329e-39e3-fdfc-500d-383953546d40@mellanox.com>
        <7e391f37-0db7-c034-cb97-2e8bf60fd33f@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Apr 2020 20:12:11 +0300
Tariq Toukan <tariqt@mellanox.com> wrote:

> >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h=20
> >> b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> >> index 23701c0e36ec..ba6a0ee297c6 100644
> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> >> @@ -652,6 +652,7 @@ struct mlx5e_rq {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct {
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 umem_headroom;
> >> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u16=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 headroom;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 first_frame_sz; =20
>=20
> I also think that a better name would be: frame0_sz, or frag0_sz.

You do realize that the name "first_frame_sz" was your suggestion last
time... Now you give me two options, can please select one of them so I
can update the patch for a V3 with that?

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

