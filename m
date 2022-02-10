Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330384B0786
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 08:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbiBJHtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 02:49:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbiBJHte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 02:49:34 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED99103D
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 23:49:35 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B00B020491;
        Thu, 10 Feb 2022 08:49:33 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sFuke06hH3_F; Thu, 10 Feb 2022 08:49:33 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 159E7201A1;
        Thu, 10 Feb 2022 08:49:33 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 0D14080004A;
        Thu, 10 Feb 2022 08:49:33 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 10 Feb 2022 08:49:32 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 10 Feb
 2022 08:49:32 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 115A1318038D; Thu, 10 Feb 2022 08:49:32 +0100 (CET)
Date:   Thu, 10 Feb 2022 08:49:31 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Lina Wang <lina.wang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        "Kernel hackers" <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] net: fix wrong network header length
Message-ID: <20220210074931.GB1223722@gauss3.secunet.de>
References: <20220208025511.1019-1-lina.wang@mediatek.com>
 <0300acca47b10384e6181516f32caddda043f3e4.camel@redhat.com>
 <CANP3RGe8ko=18F2cr0_hVMKw99nhTyOCf4Rd_=SMiwBtQ7AmrQ@mail.gmail.com>
 <a62abfeb0c06bf8be7f4fa271e2bcdef9d86c550.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a62abfeb0c06bf8be7f4fa271e2bcdef9d86c550.camel@redhat.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 05:01:07PM +0100, Paolo Abeni wrote:
> + Steffen
> On Tue, 2022-02-08 at 04:57 -0800, Maciej Żenczykowski wrote:
> > > 
> > > If traversing the segments become too costly, you can try replacing
> > > GRO_FRAGLIST with GRO_UDP_FWD.
> > 
> > Yeah, I don't know...
> > 
> > I've considered that we could perhaps fix the 6to4 helper, and 4to6 helper...
> > but then I think every *other* helper / code path that plays games
> > with the packet header needs fixing as well,
> > ie. everything dealing with encap/decap, vlan, etc..
> > 
> > At that point it seems to me like it's worth fixing here rather than
> > in all those other places.
> > 
> > In general it seems gro fraglist as implemented is just a bad idea...
> > Packets (and things we treat like packets) really should only have 1 header.
> > GRO fraglist - as implemented - violates this pretty fundamental assumption.
> > As such it seems to be on the gro fraglist implementation to deal with it.
> > That to me seems to mean it should be fixed here, and not elsewhere.
> 
> @Steffen: IIRC GRO_FRAGLIST was originally added to support some
> forwarding scenarios. Now we have GRO_UDP_FWD which should be quite
> comparable. I'm wondering if the latter feature addresses your use
> case, too.

The advantage of GRO_FRAGLIST for forwarding is that GRO and GSO
happen with almost no overhead, because the packets are left in
the skbs we received them and are not mangled during processing.

So if there is no hardware segmentation support, GRO_FRAGLIST is
still much faster than GRO_UDP_FWD.

> If so, could we consider deprecating (and in a longer run, drop) the
> GRO_FRAGLIST feature? 

Maybe we can make it exclusive for forwarding or bring the header
processing a bit closer to GRO_UDP_FWD, but I'd like to keep that
feature.
