Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00326D91C0
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbjDFIfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbjDFIfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:35:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04DA4C16
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 01:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680770065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qqVopjdhKQtWOeCmmRx7vAPF7hicoY4lylw2wohZFr0=;
        b=W3r0SIIUXpGvXjFV/HF6aAVukJT/vmt4cNV8V5nMHPs8QZgFVmUmeGMd4jNM1dGzAY7Als
        4hX0uVlj0Thk+oFjptEMw5YHh1DzXEAI4p6nKVoQM8LipMGqGMG0kA9Ze00ZHP18DXx50+
        p+zfG8jnE4LkCjYI0DUjs5GLbTSK/g0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-T-WeZz9LMzGHvbcP4tidZg-1; Thu, 06 Apr 2023 04:34:24 -0400
X-MC-Unique: T-WeZz9LMzGHvbcP4tidZg-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-5a3c1e28e73so2623746d6.0
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 01:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680770064; x=1683362064;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qqVopjdhKQtWOeCmmRx7vAPF7hicoY4lylw2wohZFr0=;
        b=YBQu311BFcU0H1KIHzioVStntIj12BTu49SGa4Kd33wyywQ/7KOvIPXC3VTrXsflBJ
         sahiedMmADHc0e31nL/fNP6eagsBgxcNtLZXht7jNk6PlK773ai1TNbhlGg/akzjHuJW
         iCwXgoZhJkj+QbImUWzhQQjB5KYRLruV9DWmsLe94AJYpA+iucPT4w7LXnuzvXRPmc2l
         ful1jzJaVtjI9BKfDqccFx2fV/nxu6wJ+pw9eTXXeElmtrX1/t8/VVLNX50a/kAOzSQ7
         QG7GpS9LexiGmd1FSTCmqnT3rQAKvoq4VNxXZwWf8JVlzUoiGd3Vd5b+Gxifk8HZSJ4+
         WJaQ==
X-Gm-Message-State: AAQBX9en8/FmCd496f30U+hby95S/Q3QGI4nywRUO+vssCsDku2t0I/G
        SPOp7HGS6RPbrJa2rZ/aEGfkl8cMZ4ShJ4MXteYZlbdt1HHBGn9qPV4VoW3OZ9uKPXK3XODlDAW
        /XrsNcZ1zr9M9HgIF
X-Received: by 2002:a05:6214:410d:b0:5df:4d41:9560 with SMTP id kc13-20020a056214410d00b005df4d419560mr7838489qvb.0.1680770064074;
        Thu, 06 Apr 2023 01:34:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350aMCsJsp9ULlmzN6dAqsXuZqKm2As0dHJqVx9G8xoMb5tPuxZXHbPD2McyYjO+j32f4HwDl6Q==
X-Received: by 2002:a05:6214:410d:b0:5df:4d41:9560 with SMTP id kc13-20020a056214410d00b005df4d419560mr7838467qvb.0.1680770063804;
        Thu, 06 Apr 2023 01:34:23 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-227-151.dyn.eolo.it. [146.241.227.151])
        by smtp.gmail.com with ESMTPSA id s128-20020a372c86000000b0074688c36facsm312744qkh.56.2023.04.06.01.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:34:23 -0700 (PDT)
Message-ID: <656093362eb6a37dff951a424085587a88a357ce.camel@redhat.com>
Subject: Re: [PATCH net] net: qrtr: Fix an uninit variable access bug in
 qrtr_tx_resume()
From:   Paolo Abeni <pabeni@redhat.com>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        andersson@kernel.org, luca@z3ntu.xyz,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 06 Apr 2023 10:34:20 +0200
In-Reply-To: <4d485060-6757-c177-bdc6-25952a49c092@huawei.com>
References: <20230403075417.2244203-1-william.xuanziyang@huawei.com>
         <20230403150107.GB11346@thinkpad>
         <4d485060-6757-c177-bdc6-25952a49c092@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 2023-04-04 at 08:38 +0800, Ziyang Xuan (William) wrote:
> > On Mon, Apr 03, 2023 at 03:54:17PM +0800, Ziyang Xuan wrote:
> > > Syzbot reported a bug as following:
> > >=20
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > > BUG: KMSAN: uninit-value in qrtr_tx_resume+0x185/0x1f0
> > > net/qrtr/af_qrtr.c:230
> > > =C2=A0qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
> > > =C2=A0qrtr_endpoint_post+0xf85/0x11b0 net/qrtr/af_qrtr.c:519
> > > =C2=A0qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
> > > =C2=A0call_write_iter include/linux/fs.h:2189 [inline]
> > > =C2=A0aio_write+0x63a/0x950 fs/aio.c:1600
> > > =C2=A0io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
> > > =C2=A0__do_sys_io_submit fs/aio.c:2078 [inline]
> > > =C2=A0__se_sys_io_submit+0x293/0x770 fs/aio.c:2048
> > > =C2=A0__x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
> > > =C2=A0do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > > =C2=A0do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
> > > =C2=A0entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > >=20
> > > Uninit was created at:
> > > =C2=A0slab_post_alloc_hook mm/slab.h:766 [inline]
> > > =C2=A0slab_alloc_node mm/slub.c:3452 [inline]
> > > =C2=A0__kmem_cache_alloc_node+0x71f/0xce0 mm/slub.c:3491
> > > =C2=A0__do_kmalloc_node mm/slab_common.c:967 [inline]
> > > =C2=A0__kmalloc_node_track_caller+0x114/0x3b0 mm/slab_common.c:988
> > > =C2=A0kmalloc_reserve net/core/skbuff.c:492 [inline]
> > > =C2=A0__alloc_skb+0x3af/0x8f0 net/core/skbuff.c:565
> > > =C2=A0__netdev_alloc_skb+0x120/0x7d0 net/core/skbuff.c:630
> > > =C2=A0qrtr_endpoint_post+0xbd/0x11b0 net/qrtr/af_qrtr.c:446
> > > =C2=A0qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
> > > =C2=A0call_write_iter include/linux/fs.h:2189 [inline]
> > > =C2=A0aio_write+0x63a/0x950 fs/aio.c:1600
> > > =C2=A0io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
> > > =C2=A0__do_sys_io_submit fs/aio.c:2078 [inline]
> > > =C2=A0__se_sys_io_submit+0x293/0x770 fs/aio.c:2048
> > > =C2=A0__x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
> > > =C2=A0do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > > =C2=A0do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
> > > =C2=A0entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > >=20
> > > It is because that skb->len requires at least sizeof(struct
> > > qrtr_ctrl_pkt)
> > > in qrtr_tx_resume(). And skb->len equals to size in
> > > qrtr_endpoint_post().
> > > But size is less than sizeof(struct qrtr_ctrl_pkt) when qrtr_cb-
> > > >type
> > > equals to QRTR_TYPE_RESUME_TX in qrtr_endpoint_post() under the
> > > syzbot
> > > scenario. This triggers the uninit variable access bug.
> > >=20
> >=20
> > I'm not familiar with syzkaller. Can you please share the data that
> > was fuzzed
> > by the bot?
> >=20
> > - Mani
> >=20
> > > Add size check when qrtr_cb->type equals to QRTR_TYPE_RESUME_TX
> > > in
> > > qrtr_endpoint_post() to fix the bug.
> > >=20
> > > Fixes: 5fdeb0d372ab ("net: qrtr: Implement outgoing flow
> > > control")
> > > Reported-by:
> > > syzbot+4436c9630a45820fda76@syzkaller.appspotmail.com
> > > Link:
> > > https://syzkaller.appspot.com/bug?id=3Dc14607f0963d27d5a3d5f4c8639b50=
0909e43540
>=20
> Hello Manivannan Sadhasivam
>=20
> See the above link, it's syzkaller dashboard link, you can find a C
> reproducer that will help you.

Hi Mani,

Are you satisfied with the information above? The patch LGTM and the
syzkaller report looks quite clear.

Thanks!

Paolo

