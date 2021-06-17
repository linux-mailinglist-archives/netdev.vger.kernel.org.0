Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552693AB19B
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 12:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhFQKqz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 17 Jun 2021 06:46:55 -0400
Received: from wildebeest.demon.nl ([212.238.236.112]:52526 "EHLO
        gnu.wildebeest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhFQKqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 06:46:52 -0400
Received: from tarox.wildebeest.org (83-87-18-245.cable.dynamic.v4.ziggo.nl [83.87.18.245])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by gnu.wildebeest.org (Postfix) with ESMTPSA id 1936F3000D18;
        Thu, 17 Jun 2021 12:44:43 +0200 (CEST)
Received: by tarox.wildebeest.org (Postfix, from userid 1000)
        id CD625413C28B; Thu, 17 Jun 2021 12:44:42 +0200 (CEST)
Message-ID: <46f035765fa4ee139fa5ec387d9395f1f466bb5e.camel@klomp.org>
Subject: Re: [PATCH bpf v1] bpf: fix libelf endian handling in resolv_btfids
From:   Mark Wielaard <mark@klomp.org>
To:     Jiri Olsa <jolsa@redhat.com>,
        Tony Ambardar <tony.ambardar@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Stable <stable@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Frank Eigler <fche@redhat.com>
Date:   Thu, 17 Jun 2021 12:44:42 +0200
In-Reply-To: <YMsRa3nT4tlzO6DJ@krava>
References: <20210616092521.800788-1-Tony.Ambardar@gmail.com>
         <caf1dcbd-7a07-993c-e940-1b2689985c5a@fb.com> <YMopCb5CqOYsl6HR@krava>
         <CAPGftE-CqfycuyTRpFvHwe5kR5gG8WGyLSgdLTat5XnxmqQ3GQ@mail.gmail.com>
         <YMsRa3nT4tlzO6DJ@krava>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
X-Spam-Flag: NO
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.0
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on gnu.wildebeest.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-17 at 11:10 +0200, Jiri Olsa wrote:
> On Wed, Jun 16, 2021 at 03:09:13PM -0700, Tony Ambardar wrote:
> > On Wed, 16 Jun 2021 at 09:38, Jiri Olsa <jolsa@redhat.com> wrote:
> > > I have no idea how is this handled in libelf (perhaps it's ok),
> > > but just that comment above suggests it could be also 64 bits,
> > > cc-ing Frank and Mark for more insight
> > > 
> > 
> > One other area I'd like to confirm is with section compression. Is
> > it safe
> > to ignore this for .BTF_ids? I've done so because
> > include/linux/btf_ids.h
> > appears to define the section with SHF_ALLOC flag set, which is
> > incompatible with compression based on "libelf.h" comments.
> 
> not sure what you mean.. where it wouldn't be safe?
> what workflow/processing

I haven't looked at the code/patch, but Tony is correct that if a
section has SHF_ALLOC set it cannot be a compressed section.
SHF_COMPRESSED is incompatbile with SHF_ALLOC (or SHF_NOBITS) sections,
because it would be unclear what a loader would need to do with them
(uncompress the data first, then map it, or map the compressed data as
is into memory).

So ignoring whether or not a section is compressed for SHF_ALLOC
sections is fine.

Cheers,

Mark
