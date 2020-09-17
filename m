Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BA626D60E
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 10:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgIQIMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 04:12:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726362AbgIQIMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 04:12:12 -0400
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 04:12:11 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600330330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cBI8f1/R2C8gGei3me+pMyZKfvONcZONLHWJofQzyXM=;
        b=QVunZ4LzdkMwympSJmctTDTszjNFaDZC3qByB2bc4uPDOAAozKGSIYEfy+9LmEv7uMe0fu
        ieb61TZVUdcVsoIXWrU4oJ0o5BSWKTHKTL0793kYyisIZEzZiBhtGQWf2UMRjp+4N6hQYo
        aHVGzTRrm7Kg2vlnoxdJvXEsw2C7dBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-YfU2mhUcN_Cr4TOEz-iS8g-1; Thu, 17 Sep 2020 04:04:56 -0400
X-MC-Unique: YfU2mhUcN_Cr4TOEz-iS8g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05A841018722;
        Thu, 17 Sep 2020 08:04:55 +0000 (UTC)
Received: from krava (ovpn-114-176.ams2.redhat.com [10.36.114.176])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4E6941002D69;
        Thu, 17 Sep 2020 08:04:53 +0000 (UTC)
Date:   Thu, 17 Sep 2020 10:04:52 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Seth Forshee <seth.forshee@canonical.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: resolve_btfids breaks kernel cross-compilation
Message-ID: <20200917080452.GB2411168@krava>
References: <20200916194733.GA4820@ubuntu-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916194733.GA4820@ubuntu-x1>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 02:47:33PM -0500, Seth Forshee wrote:
> The requirement to build resolve_btfids whenever CONFIG_DEBUG_INFO_BTF
> is enabled breaks some cross builds. For example, when building a 64-bit
> powerpc kernel on amd64 I get:
> 
>  Auto-detecting system features:
>  ...                        libelf: [ [32mon[m  ]
>  ...                          zlib: [ [32mon[m  ]
>  ...                           bpf: [ [31mOFF[m ]
>  
>  BPF API too old
>  make[6]: *** [Makefile:295: bpfdep] Error 1
> 
> The contents of tools/bpf/resolve_btfids/feature/test-bpf.make.output:
> 
>  In file included from /home/sforshee/src/u-k/unstable/tools/arch/powerpc/include/uapi/asm/bitsperlong.h:11,
>                   from /usr/include/asm-generic/int-ll64.h:12,
>                   from /usr/include/asm-generic/types.h:7,
>                   from /usr/include/x86_64-linux-gnu/asm/types.h:1,
>                   from /home/sforshee/src/u-k/unstable/tools/include/linux/types.h:10,
>                   from /home/sforshee/src/u-k/unstable/tools/include/uapi/linux/bpf.h:11,
>                   from test-bpf.c:3:
>  /home/sforshee/src/u-k/unstable/tools/include/asm-generic/bitsperlong.h:14:2: error: #error Inconsistent word size. Check asm/bitsperlong.h
>     14 | #error Inconsistent word size. Check asm/bitsperlong.h
>        |  ^~~~~
> 
> This is because tools/arch/powerpc/include/uapi/asm/bitsperlong.h sets
> __BITS_PER_LONG based on the predefinied compiler macro __powerpc64__,
> which is not defined by the host compiler. What can we do to get cross
> builds working again?

could you please share the command line and setup?

thanks,
jirka

