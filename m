Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6296C3AA6A0
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhFPWg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:36:28 -0400
Received: from wildebeest.demon.nl ([212.238.236.112]:38284 "EHLO
        gnu.wildebeest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbhFPWg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 18:36:26 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jun 2021 18:36:26 EDT
Received: from reform (deer0x04.wildebeest.org [172.31.17.134])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by gnu.wildebeest.org (Postfix) with ESMTPSA id D5EFD30012EA;
        Thu, 17 Jun 2021 00:28:00 +0200 (CEST)
Received: by reform (Postfix, from userid 1000)
        id 897182E80738; Thu, 17 Jun 2021 00:28:00 +0200 (CEST)
Date:   Thu, 17 Jun 2021 00:28:00 +0200
From:   Mark Wielaard <mark@klomp.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Frank Eigler <fche@redhat.com>
Subject: Re: [PATCH bpf v1] bpf: fix libelf endian handling in resolv_btfids
Message-ID: <YMp68Dlqwu+wuHV9@wildebeest.org>
References: <20210616092521.800788-1-Tony.Ambardar@gmail.com>
 <caf1dcbd-7a07-993c-e940-1b2689985c5a@fb.com>
 <YMopCb5CqOYsl6HR@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMopCb5CqOYsl6HR@krava>
X-Spam-Flag: NO
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.0
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on gnu.wildebeest.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hoi,

On Wed, Jun 16, 2021 at 06:38:33PM +0200, Jiri Olsa wrote:
> > > diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> > > index d636643ddd35..f32c059fbfb4 100644
> > > --- a/tools/bpf/resolve_btfids/main.c
> > > +++ b/tools/bpf/resolve_btfids/main.c
> > > @@ -649,6 +649,9 @@ static int symbols_patch(struct object *obj)
> > >   	if (sets_patch(obj))
> > >   		return -1;
> > > +	/* Set type to ensure endian translation occurs. */
> > > +	obj->efile.idlist->d_type = ELF_T_WORD;
> > 
> > The change makes sense to me as .BTF_ids contains just a list of
> > u32's.
> > 
> > Jiri, could you double check on this?
> 
> the comment in ELF_T_WORD declaration suggests the size depends on
> elf's class?
> 
>   ELF_T_WORD,                   /* Elf32_Word, Elf64_Word, ... */
> 
> data in .BTF_ids section are allways u32
> 
> I have no idea how is this handled in libelf (perhaps it's ok),
> but just that comment above suggests it could be also 64 bits,
> cc-ing Frank and Mark for more insight

It is correct to use ELF_T_WORD, which means a 32bit unsigned word.

The comment is meant to explain that, but is really confusing if you
don't know that Elf32_Word and Elf64_Word are the same thing (a 32bit
unsigned word). This comes from being "too consistent" in defining all
data types for both 32bit and 64bit ELF, even if those types are the
same in both formats...

Only Elf32_Addr/Elf64_Addr and Elf32_Off/Elf64_Off are different
sizes. But Elf32/Elf_64_Half (16 bit), Elf32/Elf64_Word (32 bit),
Elf32/Elf64_Xword (64 bit) and their Sword/Sxword (signed) variants
are all identical data types in both the Elf32 and Elf64 formats.

I don't really know why. It seems the original ELF spec was 32bit only
and when introducing the ELF64 format "they" simply duplicated all
data types whether or not those data type were actually different
between the 32 and 64 bit format.

Cheers,

Mark

