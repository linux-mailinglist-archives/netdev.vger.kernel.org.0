Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948422AF0BD
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 13:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgKKMhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 07:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726220AbgKKMhm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 07:37:42 -0500
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 135BD20659;
        Wed, 11 Nov 2020 12:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605098261;
        bh=tbOZUZNuGJOHeVqF2TBi+RYW50P2S55MdCC4L43u0hI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FT+v6OSpE4nVDjsHUiMMnUAdR1DpOA2ldxpKqnCLRaS3SwF7upyYrowUcRyHmjix7
         8zIlK33+YiZwq+7IpEZ3jzze9HgnWnDHmY2R5SLPw8H1SVBnlzJ29GbBPZs/D4nhP9
         4eslVMTuf+owBRe69cBOiMZFfvZPdxfcKzNqzReg=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 4CBDD411D1; Wed, 11 Nov 2020 09:37:38 -0300 (-03)
Date:   Wed, 11 Nov 2020 09:37:38 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCHv6 bpf] bpf: Move iterator functions into special init
 section
Message-ID: <20201111123738.GE355344@kernel.org>
References: <20201110154017.482352-1-jolsa@kernel.org>
 <2a71a0b4-b5de-e9fb-bacc-3636e16245c5@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a71a0b4-b5de-e9fb-bacc-3636e16245c5@iogearbox.net>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Nov 11, 2020 at 12:26:29PM +0100, Daniel Borkmann escreveu:
> On 11/10/20 4:40 PM, Jiri Olsa wrote:
> > With upcoming changes to pahole, that change the way how and
> > which kernel functions are stored in BTF data, we need a way
> > to recognize iterator functions.
> > 
> > Iterator functions need to be in BTF data, but have no real
> > body and are currently placed in .init.text section, so they
> > are freed after kernel init and are filtered out of BTF data
> > because of that.
> > 
> > The solution is to place these functions under new section:
> >    .init.bpf.preserve_type
> > 
> > And add 2 new symbols to mark that area:
> >    __init_bpf_preserve_type_begin
> >    __init_bpf_preserve_type_end
> > 
> > The code in pahole responsible for picking up the functions will
> > be able to recognize functions from this section and add them to
> > the BTF data and filter out all other .init.text functions.
> > 
> > Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> > Suggested-by: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> LGTM, applied, thanks! Also added a reference to the pahole commit

Applied to what branch? I'm trying to test it now :-)

- Arnaldo

> to the commit log so that this info doesn't get lost in the void
> plus carried over prior Acks given nothing changed logically in the
> patch.
> 
> P.s.: I've been wondering whether we also need to align the begin/end
> symbols via ALIGN_FUNCTION() in case ld might realign to a different
> boundary on later passes but this seems neither the case for .init.text
> right now, likely since it doesn't matter for kallsyms data in our
> particular case.

-- 

- Arnaldo
