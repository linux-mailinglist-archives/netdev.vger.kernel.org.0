Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEB329EAD0
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 12:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgJ2Li2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 07:38:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58669 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725784AbgJ2Li2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 07:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603971506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E1OsI9+0ufJfUC1jeB2NLu/WC2DUTtDv3THSmVQYT7I=;
        b=ap49tgmVR0sS5R0oK9BustpijuQNa9k98RR+W6gqz/25xQHmuMKqv7TXFWJRT0qfZwhwQX
        NxmcycarXkvc1DpzyoOXhVGz2xGJ+8nttqe89z6wl+dJovBsug6A6jmXsEQZ/7xgTH40Ga
        7jna5L19vG0cXzAfIcdgIs8zSQOIS8Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-zhl3NQARPiqTxGahnpShQw-1; Thu, 29 Oct 2020 07:38:24 -0400
X-MC-Unique: zhl3NQARPiqTxGahnpShQw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30A4218B9F13;
        Thu, 29 Oct 2020 11:38:22 +0000 (UTC)
Received: from carbon (unknown [10.36.110.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0CAA5D9EF;
        Thu, 29 Oct 2020 11:38:02 +0000 (UTC)
Date:   Thu, 29 Oct 2020 12:38:01 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <haliu@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201029123801.4d03ebb5@carbon>
In-Reply-To: <CAEf4BzY1gz2fR0DXOYgbheDArdYhWA66YRFuy=xMRveHTx=VVQ@mail.gmail.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
        <20201028132529.3763875-1-haliu@redhat.com>
        <7babcccb-2b31-f9bf-16ea-6312e449b928@gmail.com>
        <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
        <CAEf4BzZR4MqQJCD4kzFsbhpfmp4RB7SHcP5AbAiqzqK7to2u+g@mail.gmail.com>
        <20201028193438.21f1c9b0@hermes.local>
        <CAEf4BzY1gz2fR0DXOYgbheDArdYhWA66YRFuy=xMRveHTx=VVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 19:50:51 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Wed, Oct 28, 2020 at 7:34 PM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Wed, 28 Oct 2020 19:27:20 -0700
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >  
> > > On Wed, Oct 28, 2020 at 7:06 PM Hangbin Liu <haliu@redhat.com> wrote:  
> > > >
> > > > On Wed, Oct 28, 2020 at 05:02:34PM -0600, David Ahern wrote:  
> > > > > fails to compile on Ubuntu 20.10:
> > > > >
[...]
> > > > You need to update libbpf to latest version.  
> > >
> > > Why not using libbpf from submodule?  
> >
> > Because it makes it harder for people downloading tarballs and distributions.  
> 
> Genuinely curious, making harder how exactly? When packaging sources
> as a tarball you'd check out submodules before packaging, right?
> 
> > Iproute2 has worked well by being standalone.  
> 
> Again, maybe I'm missing something, but what makes it not a
> standalone, if it is using a submodule? Pahole, for instance, is using
> libbpf through submodule and just bypasses all the problems with
> detection of features and library availability. I haven't heard anyone
> complaining about it made working with pahole harder in any way.

I do believe you are missing something.  I guess I can be the relay for
complains, so you will officially hear about this.  Red Hat and Fedora
security is complaining that we are packaging a library (libbpf)
directly into the individual packages.  They complain because in case
of a security issue, they have to figure out to rebuild all the software
packages that are statically compiled with this library.

Maybe you say I don't care that Distro security teams have to do more
work and update more packages.  Then security team says, we expect
customers will use this library right, and if we ship it as a dynamic
loadable (.so) file, then we can update and fix security issues in
library without asking customers to recompile. (Notice the same story
goes if we can update the base-image used by a container).


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

