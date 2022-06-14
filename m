Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6AE054AED4
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239524AbiFNKwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241029AbiFNKwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:52:17 -0400
Received: from mailrelay.tu-berlin.de (mailrelay.tu-berlin.de [130.149.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657F74925A;
        Tue, 14 Jun 2022 03:52:15 -0700 (PDT)
Received: from SPMA-02.tubit.win.tu-berlin.de (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 0F7E238902_2A8685EB;
        Tue, 14 Jun 2022 10:52:14 +0000 (GMT)
Received: from mail.tu-berlin.de (mail.tu-berlin.de [141.23.12.141])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "exchange.tu-berlin.de", Issuer "DFN-Verein Global Issuing CA" (not verified))
        by SPMA-02.tubit.win.tu-berlin.de (Sophos Email Appliance) with ESMTPS id 90CC38C145_2A8685DF;
        Tue, 14 Jun 2022 10:52:13 +0000 (GMT)
Received: from [192.168.178.14] (89.12.240.121) by ex-06.svc.tu-berlin.de
 (10.150.18.10) with Microsoft SMTP Server id 15.2.986.22; Tue, 14 Jun 2022
 12:52:13 +0200
Message-ID: <a246494232612c20e2a6952e3dd0a2d9fbbabf21.camel@mailbox.tu-berlin.de>
Subject: Re: [PATCH bpf-next v2 2/2] bpf: Require only one of cong_avoid()
 and cong_control() from a TCP CC
From:   =?ISO-8859-1?Q?J=F6rn-Thorben?= Hinz <jthinz@mailbox.tu-berlin.de>
To:     Martin KaFai Lau <kafai@fb.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>
Date:   Tue, 14 Jun 2022 12:52:11 +0200
In-Reply-To: <20220613171703.xoetc7dlr4qkss43@kafai-mbp>
References: <20220608174843.1936060-1-jthinz@mailbox.tu-berlin.de>
         <20220609204702.2351369-1-jthinz@mailbox.tu-berlin.de>
         <20220609204702.2351369-3-jthinz@mailbox.tu-berlin.de>
         <20220613171703.xoetc7dlr4qkss43@kafai-mbp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SASI-RCODE: 200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=campus.tu-berlin.de; h=message-id:subject:from:to:cc:date:in-reply-to:references:content-type:mime-version:content-transfer-encoding; s=dkim-tub; bh=2nfOabUdxmunixYt8omzm+xSx1kqwfwuSOXrKjF3L78=; b=eo3KEteusuAlBB8h+t3vf8Yw+UEaF0eqJbdz4R4R7VvPjq7vvZSJhivnRU7gN1nbox6l+fyvD6XPA+9j+nDsG1DFHRn0AkcrQ+FtM2C4623jv4Z8Zj4bQCv1qi7ogPdq09PcZliFidzXi7kZTH7qV7B36tEnYZxZny5JJjLn2vI=
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-06-13 at 10:17 -0700, Martin KaFai Lau wrote:
> On Thu, Jun 09, 2022 at 10:47:02PM +0200, Jörn-Thorben Hinz wrote:
> > Remove the check for required and optional functions in a struct
> > tcp_congestion_ops from bpf_tcp_ca.c. Rely on
> > tcp_register_congestion_control() to reject a BPF CC that does not
> > implement all required functions, as it will do for a non-BPF CC.
> > 
> > When a CC implements tcp_congestion_ops.cong_control(), the
> > alternate
> > cong_avoid() is not in use in the TCP stack. Previously, a BPF CC
> > was
> > still forced to implement cong_avoid() as a no-op since it was
> > non-optional in bpf_tcp_ca.c.
> > 
> > Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
> > ---
> >  net/ipv4/bpf_tcp_ca.c | 32 --------------------------------
> >  1 file changed, 32 deletions(-)
> > 
> > diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
> > index 1f5c53ede4e5..39b64f317499 100644
> > --- a/net/ipv4/bpf_tcp_ca.c
> > +++ b/net/ipv4/bpf_tcp_ca.c
> > @@ -14,18 +14,6 @@
> >  /* "extern" is to avoid sparse warning.  It is only used in
> > bpf_struct_ops.c. */
> >  extern struct bpf_struct_ops bpf_tcp_congestion_ops;
> >  
> > -static u32 optional_ops[] = {
> > -       offsetof(struct tcp_congestion_ops, init),
> > -       offsetof(struct tcp_congestion_ops, release),
> > -       offsetof(struct tcp_congestion_ops, set_state),
> > -       offsetof(struct tcp_congestion_ops, cwnd_event),
> > -       offsetof(struct tcp_congestion_ops, in_ack_event),
> > -       offsetof(struct tcp_congestion_ops, pkts_acked),
> > -       offsetof(struct tcp_congestion_ops, min_tso_segs),
> > -       offsetof(struct tcp_congestion_ops, sndbuf_expand),
> > -       offsetof(struct tcp_congestion_ops, cong_control),
> > -};
> > -
> >  static u32 unsupported_ops[] = {
> >         offsetof(struct tcp_congestion_ops, get_info),
> >  };
> > @@ -51,18 +39,6 @@ static int bpf_tcp_ca_init(struct btf *btf)
> >         return 0;
> >  }
> >  
> > -static bool is_optional(u32 member_offset)
> > -{
> > -       unsigned int i;
> > -
> > -       for (i = 0; i < ARRAY_SIZE(optional_ops); i++) {
> > -               if (member_offset == optional_ops[i])
> > -                       return true;
> > -       }
> > -
> > -       return false;
> > -}
> > -
> >  static bool is_unsupported(u32 member_offset)
> >  {
> >         unsigned int i;
> > @@ -268,14 +244,6 @@ static int bpf_tcp_ca_init_member(const struct
> > btf_type *t,
> >                 return 1;
> >         }
> >  
> > -       if (!btf_type_resolve_func_ptr(btf_vmlinux, member->type,
> > NULL))
> > -               return 0;
> > -
> > -       /* Ensure bpf_prog is provided for compulsory func ptr */
> > -       prog_fd = (int)(*(unsigned long *)(udata + moff));
> > -       if (!prog_fd && !is_optional(moff) &&
> > !is_unsupported(moff))
> !is_unsupported() is still needed.
I don’t think it is necessary here.

There is also bpf_tcp_ca_check_member(), which also and only tests for
is_unsupported(). And check_member() will be called even earlier than
init_member() when loading a struct_ops. This deleted is_unsupported()
call should have been there only to test for missing but required &&
supported functions.

I added a test in v3 to make sure the check for the unsupported
get_info() (still) works.

Please correct me, if I misread/misfollowed the code paths!

> 
> and remove 'int prog_fd' as reported by the test bot.
Of course, sorry about that … Oversight on my side.

> 
> Test is still needed.  You can copy the simpler "bpf_dctcp"
> to another tcp_congestion_ops.  Write+read the sk_packing
> and also use .cong_control instead of .cong_avoid.  I think rs-
> >acked_sacked
> is the 'delivered' and the 'ack' is not used.
Added tests in v3 of the patch series. I’m open for further feedback.


