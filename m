Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7F84E3666
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 17:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503065AbfJXPTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 11:19:45 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34506 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503056AbfJXPTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 11:19:44 -0400
Received: by mail-lj1-f193.google.com with SMTP id j19so25473574lja.1;
        Thu, 24 Oct 2019 08:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1t544pKz3rusMWal9pf8jw+gs1rXlE3UQttJtNVmUxo=;
        b=EvCruDnLDFctZm0Hh9LOi28zKxLhhZDFcZo+Uz/+ckNof3/pkuytzB6JxDCOYg3jZn
         BKeLQwR1YgYzb/deZCWbtNMTVE61ijZyylbNQhYggG5lLuBaLWHmN0e4jqw1N8omy283
         Hmgn1LneasO16yyQA4UKMESunD0UE5XCIhjOv6art0mjYGccc8fiTMo3gR/YltB8ul3A
         UI5HH73GsAtE7nlIyOjY+17I6Avx/qEjj150Z5kPaXoReoXiofGzzY724kMrkCDk85J9
         MhIYX3+DTTmaNOHabcY7cttd3jN6glTF0EefqOrPQcTAhZvDAoOJMTGCnNmCyvEaDusk
         h8Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1t544pKz3rusMWal9pf8jw+gs1rXlE3UQttJtNVmUxo=;
        b=YCV0mr56sqBHAfBfZ5ChVIw0dh2tJYRzwhTrodIJoKMD1v/IiqFlFyW+FpYPqIx6Nf
         EMxAtvxlEpoq5vxmzW6WerNq02Uv+gtRH6J30fS3orL57nWkuhI80Xr9+PX0v+gtfBWk
         5iOPTGH3Sw6vxee3B1e3IKa5v8p+f4n2ZzofWKq0cSEu43D+uvhUipDJgIIARUkDGcre
         03zrrqYR97isyE293vJ97+QbhFXPtkA2ItETYS0xN9uazMPUI2c6QEBMtLh50Ep2iPcs
         AeqEWZEm+8FvNWn4M4zHQfXoVzj9GilREhc+KDH46xEeIeyDKTAa5pHCdcVGMhSl3gVz
         HTUQ==
X-Gm-Message-State: APjAAAU8mIgnRkUjsLnRq5IRiMOb4WQvknq8nYZcjJAH/g1syc+hIMlh
        p5Mx/OgR/r7lbNusko6fNhSvIuaeNVw1D2LdTH0=
X-Google-Smtp-Source: APXvYqxuCJJKLbEI+NgLhoqygzcbEGtkhd//8wsqeTOLMYGBXpFlONfsTHytkkxfXvYhi8jv+4o9YSwhDSK+2WiWyt0=
X-Received: by 2002:a2e:9cc9:: with SMTP id g9mr25912048ljj.188.1571930382216;
 Thu, 24 Oct 2019 08:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <1571645818-16244-1-git-send-email-magnus.karlsson@intel.com>
 <B551C016-76AE-46D3-B2F5-15AFF9073735@gmail.com> <CAJ8uoz2FDkygCG5myz_OzAPHSiCPGR1Y-OHEi6xNjQEHoAia8w@mail.gmail.com>
In-Reply-To: <CAJ8uoz2FDkygCG5myz_OzAPHSiCPGR1Y-OHEi6xNjQEHoAia8w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 24 Oct 2019 08:19:30 -0700
Message-ID: <CAADnVQKYME2GgSPs_DTS97c05BT=L49KJ+XUXEStgK5Sg3UOmA@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix registration of Rx-only sockets
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Kal Cutter Conley <kal.conley@dectris.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 5:53 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Thu, Oct 24, 2019 at 12:47 PM Jonathan Lemon
> <jonathan.lemon@gmail.com> wrote:
> >
> > On 21 Oct 2019, at 1:16, Magnus Karlsson wrote:
> >
> > > Having Rx-only AF_XDP sockets can potentially lead to a crash in the
> > > system by a NULL pointer dereference in xsk_umem_consume_tx(). This
> > > function iterates through a list of all sockets tied to a umem and
> > > checks if there are any packets to send on the Tx ring. Rx-only
> > > sockets do not have a Tx ring, so this will cause a NULL pointer
> > > dereference. This will happen if you have registered one or more
> > > Rx-only sockets to a umem and the driver is checking the Tx ring even
> > > on Rx, or if the XDP_SHARED_UMEM mode is used and there is a mix of
> > > Rx-only and other sockets tied to the same umem.
> > >
> > > Fixed by only putting sockets with a Tx component on the list that
> > > xsk_umem_consume_tx() iterates over.
> >
> > A future improvement might be renaming umem->xsk_list to umem->xsk_tx_list
> > or similar, in order to make it clear that the list is only used on the
> > TX path.
>
> Agreed. Had that exact name in my first internal version of the patch
> :-), but that rename touched a lot of places so it obfuscated the fix
> and therefore I removed it to make it clearer. But I can submit a
> patch with the rename to bpf-next.

please do so after bpf fixes will travel to net->linus->net-next->bpf-next
Dealing with merge conflicts is not worth it otherwise.
