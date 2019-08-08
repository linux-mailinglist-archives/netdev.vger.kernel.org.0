Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F22985BC9
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 09:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731333AbfHHHpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 03:45:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37744 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbfHHHpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 03:45:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=33Ef3Sm7bpdfJwlyTclvqrfYhhmgGkQP65uyo6ml4Es=; b=ha5wQch0HRlEFijHatH94E6n+
        M6IfVEh8p0GGxYincxjuS/UxV5rB1M3RR49E+HU/qbJsrW4PlEyeLjAKK6mP3Id6uAFlIqqOspQOu
        RlqYAZpw8+GPi0BlsToQxbEm7nUF1waXZ2irBUVTUl0urWZkaSXoC+R3vcRS/h54ldRYTwhy3SRwm
        CD0UmiJaGme30DAtNmj3uNTVWIEqLhAFQkpoTHTandVGpwK/cwWJhPaOZQXfKNGye2X9Wucbj4cQc
        FboTbJrZJVVrsu9VVV4oA+S9Z7745mbFXF9T02fpDUDc/Vl3a7NgWGCVgNRKEp0WYJAFapaZriWlE
        xtTqKlV+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hvd6h-0000CR-CS; Thu, 08 Aug 2019 07:45:07 +0000
Date:   Thu, 8 Aug 2019 00:45:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Amit Pundir <amit.pundir@linaro.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH] kbuild: re-implement detection of CONFIG options
 leaked to user-space
Message-ID: <20190808074507.GA22720@infradead.org>
References: <20190806043729.5562-1-yamada.masahiro@socionext.com>
 <CAK8P3a2POcb+AReLKib513i_RTN9kLM_Tun7+G5LOacDuy7gjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2POcb+AReLKib513i_RTN9kLM_Tun7+G5LOacDuy7gjQ@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 11:00:19AM +0200, Arnd Bergmann wrote:
> > I was playing with sed yesterday, but the resulted code might be unreadable.
> >
> > Sed scripts tend to be somewhat unreadable.
> > I just wondered which language is appropriate for this?
> > Maybe perl, or what else? I am not good at perl, though.
> 
> I like the sed version, in particular as it seems to do the job and
> I'm not volunteering to write it in anything else.

Did anyone not like sed?  I have to say I do like scripts using sed and
awk because they are fairly readable and avoid dependencies on "big"
scripting language and their optional modules that sooner or later get
pulled in.

> This one is nontrivial, since it defines two incompatible layouts for
> this structure,
> and the fdpic version is currently not usable at all from user space. Also,
> the definition breaks configurations that have both CONFIG_BINFMT_ELF
> and CONFIG_BINFMT_ELF_FDPIC enabled, which has become possible
> with commit 382e67aec6a7 ("ARM: enable elf_fdpic on systems with an MMU").
> 
> The best way forward I see is to duplicate the structure definition, adding
> a new 'struct elf_fdpic_prstatus', and using that in fs/binfmt_elf_fdpic.c.
> The same change is required in include/linux/elfcore-compat.h.

Yeah, this is a mess.  David Howells suggested something similar when
I brought the issue to his attention last time.
