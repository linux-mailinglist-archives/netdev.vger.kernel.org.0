Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DFD2AEFFD
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgKKLvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 06:51:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48151 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726203AbgKKLvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:51:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605095467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fBZlME/NpyU2+DxETmjLqkp/S2r9CBRgxTt3fLfXBVU=;
        b=A9ms+WRVbuiDlJwiguuEEZYbzxvscYXKkkeNxzajjkVzyw63cn+Izi86voeWm6tyGeoqXI
        B6RfUpgxc+VCv+qKxhbPM/e36NJ/oBYpVprqB9sEmueYk4mI2dWL0ZrjmkaKkr2BedTEyK
        lvFQuYWVMFgW5YY+NJA1ByXyAX3VRVY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-2RsBwSU5OpyWTZPXMVWpMA-1; Wed, 11 Nov 2020 06:51:05 -0500
X-MC-Unique: 2RsBwSU5OpyWTZPXMVWpMA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13ACE188C12F;
        Wed, 11 Nov 2020 11:51:04 +0000 (UTC)
Received: from krava (unknown [10.40.194.237])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4AD1527BAE;
        Wed, 11 Nov 2020 11:51:01 +0000 (UTC)
Date:   Wed, 11 Nov 2020 12:51:00 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCHv6 bpf] bpf: Move iterator functions into special init
 section
Message-ID: <20201111115100.GH387652@krava>
References: <20201110154017.482352-1-jolsa@kernel.org>
 <2a71a0b4-b5de-e9fb-bacc-3636e16245c5@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a71a0b4-b5de-e9fb-bacc-3636e16245c5@iogearbox.net>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 12:26:29PM +0100, Daniel Borkmann wrote:
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
> to the commit log so that this info doesn't get lost in the void
> plus carried over prior Acks given nothing changed logically in the
> patch.
> 
> P.s.: I've been wondering whether we also need to align the begin/end
> symbols via ALIGN_FUNCTION() in case ld might realign to a different
> boundary on later passes but this seems neither the case for .init.text
> right now, likely since it doesn't matter for kallsyms data in our
> particular case.
> 

I'll check but I think it's not a problem as you said

thanks,
jirka

