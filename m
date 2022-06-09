Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03115446AC
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242823AbiFII4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242207AbiFII4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:56:21 -0400
Received: from mailrelay.tu-berlin.de (mailrelay.tu-berlin.de [130.149.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B527A158767;
        Thu,  9 Jun 2022 01:55:30 -0700 (PDT)
Received: from SPMA-04.tubit.win.tu-berlin.de (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 8074E973B0F_2A1B57FB;
        Thu,  9 Jun 2022 08:55:27 +0000 (GMT)
Received: from mail.tu-berlin.de (postcard.tu-berlin.de [141.23.12.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "exchange.tu-berlin.de", Issuer "DFN-Verein Global Issuing CA" (not verified))
        by SPMA-04.tubit.win.tu-berlin.de (Sophos Email Appliance) with ESMTPS id 25C6E973B01_2A1B57FF;
        Thu,  9 Jun 2022 08:55:27 +0000 (GMT)
Received: from [192.168.178.14] (77.11.250.240) by ex-03.svc.tu-berlin.de
 (10.150.18.7) with Microsoft SMTP Server id 15.2.986.22; Thu, 9 Jun 2022
 10:55:26 +0200
Message-ID: <f7ea082a99224e12e085e879e7c067f23844874c.camel@mailbox.tu-berlin.de>
Subject: Re: [PATCH bpf-next 2/2] bpf: Require only one of cong_avoid() and
 cong_control() from a TCP CC
From:   =?ISO-8859-1?Q?J=F6rn-Thorben?= Hinz <jthinz@mailbox.tu-berlin.de>
To:     Martin KaFai Lau <kafai@fb.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>
Date:   Thu, 9 Jun 2022 10:55:25 +0200
In-Reply-To: <20220608183356.6lzoxkrfskmvhod2@kafai-mbp>
References: <20220608174843.1936060-1-jthinz@mailbox.tu-berlin.de>
         <20220608174843.1936060-3-jthinz@mailbox.tu-berlin.de>
         <20220608183356.6lzoxkrfskmvhod2@kafai-mbp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SASI-RCODE: 200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=campus.tu-berlin.de; h=message-id:subject:from:to:cc:date:in-reply-to:references:content-type:mime-version:content-transfer-encoding; s=dkim-tub; bh=z2HrPWzhmVXxkOwjzVOwPO5dlg/mYzIleEV4LqLTjZU=; b=k+zOqCDB/HZ6mnE0Fk36Jd6fZCKtYF5C1Jz33VUBFFUbICVgiy6fw/Cr7Pd9dHy4PKfh7E2DljpoQ8NuFJ1WFYA//3ogP8QzReYfyKU5MwIgj3sgoSwIvzNlyzh/R2EQ0CHCyeaSDu+mZkPPm9Qwf7pE7EmV5lIxVO2U69/Vfjk=
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the feedback, Martin.

On Wed, 2022-06-08 at 11:33 -0700, Martin KaFai Lau wrote:
> On Wed, Jun 08, 2022 at 07:48:43PM +0200, Jörn-Thorben Hinz wrote:
> > When a CC implements tcp_congestion_ops.cong_control(), the
> > alternate
> > cong_avoid() is not in use in the TCP stack. Do not force a BPF CC
> > to
> > implement cong_avoid() as a no-op by always requiring it.
> > 
> > An incomplete BPF CC implementing neither cong_avoid() nor
> > cong_control() will still get rejected by
> > tcp_register_congestion_control().
> > 
> > Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
> > ---
> >  net/ipv4/bpf_tcp_ca.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
> > index 1f5c53ede4e5..37290d0bf134 100644
> > --- a/net/ipv4/bpf_tcp_ca.c
> > +++ b/net/ipv4/bpf_tcp_ca.c
> > @@ -17,6 +17,7 @@ extern struct bpf_struct_ops
> > bpf_tcp_congestion_ops;
> >  static u32 optional_ops[] = {
> >         offsetof(struct tcp_congestion_ops, init),
> >         offsetof(struct tcp_congestion_ops, release),
> > +       offsetof(struct tcp_congestion_ops, cong_avoid),
> At least one of the cong_avoid() or cong_control() is needed.
> It is better to remove is_optional(moff) check and its optional_ops[]
> here.  Only depends on the tcp_register_congestion_control() which
> does a similar check at the beginning.
You mean completely remove this part of the validation from
bpf_tcp_ca.c and just rely on tcp_register_congestion_control()? True,
that would be even easier to maintain at this point, make
tcp_register_congestion_control() the one-and-only place that has to
know about required and optional functions.

Will rework the second patch.

> 
> Patch 1 looks good.  tcp_bbr.c also needs the sk_pacing fields.
> 
> A selftest is needed.  Can you share your bpf tcp-cc and
> use it as a selftest to exercise the change in this patch
> set ?
I cannot do that just now, unfortunately. It’s still earlier work in
progress. Also, it will have an additional, external dependency which
might make it unfit to be included here/as a selftest. I will keep it
in mind for later this year, though.

In the meantime, I could look into adding a more naive/trivial test,
that implements cong_control() without cong_avoid() and relies on
sk_pacing_* being writable, if you would prefer that? Would that be
fine as a follow-up patch (might take me a moment) or better be
included in this series?

> 
> 
> >         offsetof(struct tcp_congestion_ops, set_state),
> >         offsetof(struct tcp_congestion_ops, cwnd_event),
> >         offsetof(struct tcp_congestion_ops, in_ack_event),
> > -- 
> > 2.30.2
> > 


