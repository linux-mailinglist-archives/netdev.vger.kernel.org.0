Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405CE1645DC
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 14:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbgBSNnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 08:43:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43086 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726558AbgBSNnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 08:43:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582119791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ogUgNQHMZGphvFbHLWSXZKUdZldeedaIJcgIFpDuE+4=;
        b=LGou5nXWPowBFdKeyD6YqWIlQ88pSSemR09EgY7sNaHZuTMDczhbUvU5+gggkKom+Qg8yf
        15oCTc0Xu+xYVZ8BV4eOOL7QnUo390Fvkfej9HE8ns+SzIHvq1ue8lgYPSWfyEK65A57Qw
        cwNbvfDMQrHj5y1uEKExsaSjhSHaHFo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-1C0NK7uANj6M3v3QxALrfQ-1; Wed, 19 Feb 2020 08:43:06 -0500
X-MC-Unique: 1C0NK7uANj6M3v3QxALrfQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C36288DE74D;
        Wed, 19 Feb 2020 13:43:04 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D08A90F76;
        Wed, 19 Feb 2020 13:42:55 +0000 (UTC)
Date:   Wed, 19 Feb 2020 14:42:54 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4?= =?UTF-8?B?cmdlbnNlbg==?= 
        <toke@redhat.com>, brouer@redhat.com
Subject: Re: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
Message-ID: <20200219144254.36c3921b@carbon>
In-Reply-To: <20200219132856.GA2836367@kroah.com>
References: <20200219133012.7cb6ac9e@carbon>
        <20200219132856.GA2836367@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Feb 2020 14:28:56 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Wed, Feb 19, 2020 at 01:30:12PM +0100, Jesper Dangaard Brouer wrote:
> > Hi Andrii,
> > 
> > Downloaded tarball for kernel release 5.5.4, and I cannot compile
> > tools/testing/selftests/bpf/ with latest LLVM release version 9.  
> 
> Is this something that recently broke?  If so, what commit caused it?

Digging through, it seems several commits.

> And has llvm 9 always worked here?

Yes, llvm-9 used to work for tools/testing/selftests/bpf/.


> > Looking closer at the build error messages, I can see that this is
> > caused by using LLVM features that (I assume) will be avail in release
> > 10. I find it very strange that we can release a kernel that have build
> > dependencies on a unreleased version of LLVM.  
> 
> Is this the first time you have tried using llvm to build a kernel?
> This isn't a new thing :)

LOL - we are talking past each-other... I'm not building the entire
kernel with LLVM.  Notice I'm talking about the BPF-selftests located
in directory tools/testing/selftests/bpf/.  Building the selftests
programs are broken

We always use LLVM to build BPF programs (both samples/bpf/ and selftests).

 
> > I love the new LLVM BTF features, but we cannot break users/CI-systems
> > that wants to run the BPF-selftests.  

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

