Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F168F4BA6B0
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 18:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243560AbiBQRFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 12:05:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbiBQRFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 12:05:34 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD052B3575;
        Thu, 17 Feb 2022 09:05:20 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id k60-20020a17090a4cc200b001b932781f3eso6663020pjh.0;
        Thu, 17 Feb 2022 09:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=igdtx/X4r6DHvG4OHrEKeNV0KHoFSbJa+zOn0lpALxk=;
        b=h1OjLZWm6AqbT1qg0+826xPUab9KqGWoba4Xk298WYdrZ8LzbETMyMHVLtQ6HL1AG5
         2nO2RIAJpAcJYQGlhAYIv3SeNTmxNXtGJXTlhl0BmfcTCj0Pbt6p7A54hB+5JgdGyYaj
         EZug/4GxcTPHi2OXVCZvt3s0z/7Ms8pnBnO+JSx5RZTcEhJo8S00fGlGRgZ/g29vsHEs
         /KHCzO17dYyPPkZlZXAIQpekt6irno8BivviWOOtG0EEBoBAQgbbmAJNpWvWv0S9a3Ld
         xku2Ycl0Mr1dmiuKT9aUGcGlSuivfqdN8Wdr+NrOVC9J0Rj13mEB5KkXZwbeLYvdBIaw
         p/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=igdtx/X4r6DHvG4OHrEKeNV0KHoFSbJa+zOn0lpALxk=;
        b=kCu5a+aSk0HiTUky2z41lTix+uGoscercBHSQ6B9wri2zuGnF1nhRJ5RLdaHo/jmf+
         nelVEhkvio1SJw624PuvBGlOqupeD6oTFr0rBwqfAw1c3hIAasB7uUZGxgcujmM1txZ9
         jy9Xc7wbG57dWo5yMFNSxtjHOvBa3E54It1yzfNHIkciHgYAvsuvRF1K3nsXUJ/EuWXI
         kTUkklakqdZr4L4cH0k6Sxjcckk3WhCAp8jhx7SRDP/s5w1X7MYLvoK9lw5UJIObgtkP
         M5ritC5gIu060Dyswq3Qd4gLgoF03JwTEh4tkUe6njSIbJQxrfDeSVON+rUxFw052yoW
         66Bg==
X-Gm-Message-State: AOAM530TS/b/XGWOfe22bv/qsvZblOPomYLm/3MAJJkaoW6DeE7MazME
        ni3u+fjrU+dTA9lkS8ib96XuzBIDkEdeIEKT6YrkkasvhOQ=
X-Google-Smtp-Source: ABdhPJwzgy3e5J9IibSjmbvUM7EdXMF3t4DE7UGqgruUMTFhNWccEXGa2GUfVf7sygbgSmLsGTBoiSAsKgp1SGZ+0a0=
X-Received: by 2002:a17:902:ce12:b0:14e:e18e:80a4 with SMTP id
 k18-20020a170902ce1200b0014ee18e80a4mr3644185plg.34.1645117519650; Thu, 17
 Feb 2022 09:05:19 -0800 (PST)
MIME-Version: 1.0
References: <CAADnVQK78PN8N6c6u_O2BAxdyXwH_HVYMV_x3oGgyfT50a6ymg@mail.gmail.com>
 <20220217070139.30028-1-lina.wang@mediatek.com> <41a3e6e4f9331c6a0a62fe838fc6f9084a5c89bc.camel@redhat.com>
In-Reply-To: <41a3e6e4f9331c6a0a62fe838fc6f9084a5c89bc.camel@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Feb 2022 09:05:08 -0800
Message-ID: <CAADnVQJEXOOH6--uA7BvFUPmXY42zeOQVweHmaMqkbj_g5TLqA@mail.gmail.com>
Subject: Re: [PATCH v3] net: fix wrong network header length
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Lina Wang <lina.wang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 12:45 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Thu, 2022-02-17 at 15:01 +0800, Lina Wang wrote:
> > On Wed, 2022-02-16 at 19:05 -0800, Alexei Starovoitov wrote:
> > > On Tue, Feb 15, 2022 at 11:37 PM Lina Wang <lina.wang@mediatek.com>
> > > wrote:
> > > >
> > > > When clatd starts with ebpf offloaing, and NETIF_F_GRO_FRAGLIST is
> > > > enable,
> > > > several skbs are gathered in skb_shinfo(skb)->frag_list. The first
> > > > skb's
> > > > ipv6 header will be changed to ipv4 after bpf_skb_proto_6_to_4,
> > > > network_header\transport_header\mac_header have been updated as
> > > > ipv4 acts,
> > > > but other skbs in frag_list didnot update anything, just ipv6
> > > > packets.
> > >
> > > Please add a test that demonstrates the issue and verifies the fix.
> >
> > I used iperf udp test to verify the patch, server peer enabled -d to de=
bug
> > received packets.
> >
> > 192.0.0.4 is clatd interface ip, corresponding ipv6 addr is
> > 2000:1:1:1:afca:1b1f:1a9:b367, server peer ip is 1.1.1.1,
> > whose ipv6 is 2004:1:1:1::101:101.
> >
> > Without the patch, when udp length 2840 packets received, iperf shows:
> > pcount 1 packet_count 0
> > pcount 27898727 packet_count 1
> > pcount 3 packet_count 27898727
> >
> > pcount should be 2, but is 27898727(0x1a9b367) , which is 20 bytes put
> > forward.
> >
> > 12:08:02.680299       Unicast to us 2004:1:1:1::101:101   2000:1:1:1:af=
ca:1b1f:1a9:b367 UDP 51196 =E2=86=92 5201 Len=3D2840
> > 0000   20 00 00 01 00 01 00 01 af ca 1b 1f 01 a9 b3 67   ipv6 dst addre=
ss
> > 0000   c7 fc 14 51 0b 20 c7 ab                           udp header
> > 0000   00 00 00 ab 00 0e f3 49 00 00 00 01 08 06 69 d2   00000001 is pc=
ount
> > 12:08:02.682084       Unicast to us   1.1.1.1                  192.0.0.=
4                UDP 51196 =E2=86=92 5201 Len=3D2840
> >
> > After applied the patch, there is no OOO, pcount acted in order.
>
> To clarify: Alexei is asking to add a test under:
>
> tools/testing/selftests/net/
>
> to cover this specific case. You can propbably extend the existing
> udpgro_fwd.sh.

Exactly.
I suspect the setup needs a bit more than just iperf udp test.
Does it need a specific driver and hw?
Can it be reproduced with veth or other virtual netdev?
Also commit talks about bpf_skb_proto_6_to_4.
So that bpf helper has to be somehow involved, but iperf udp test
says nothing about it.
Please craft a _complete_ selftest.

> Please explicitly CC people who gave feedback to previous iterations,
> it makes easier to track the discussion.
>
> /P
>
