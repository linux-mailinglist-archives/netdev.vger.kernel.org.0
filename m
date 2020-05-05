Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9D21C6110
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgEETcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:32:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31760 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728737AbgEETcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:32:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588707120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i0caJOHWv/qw9cJJ8Niq+lMoz4pnwFyP/fiTwaMzzC0=;
        b=QCSP76Zw7f3c7KEhOeHj3gYIT2QYThyV+PdpgS/5kB7LzWIALGeCT4DFmEwn//IwiEJDni
        3jODQnA0r7W2X4HiqWCqyXadWHWfh1xaHYlK+fO4oehFlkc9pqNx3U4PxZ7xRVROuI6Pd7
        rqWQzm7JQJikMIqshXiku2dzelL8WPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-jM7WZMLQO1G5tG8kfLwBQg-1; Tue, 05 May 2020 15:31:56 -0400
X-MC-Unique: jM7WZMLQO1G5tG8kfLwBQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FB84872FE0;
        Tue,  5 May 2020 19:31:54 +0000 (UTC)
Received: from treble (ovpn-119-47.rdu2.redhat.com [10.10.119.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3899E60BEC;
        Tue,  5 May 2020 19:31:53 +0000 (UTC)
Date:   Tue, 5 May 2020 14:31:51 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bpf: Tweak BPF jump table optimizations for objtool
 compatibility
Message-ID: <20200505193151.mkluubxvqz7zouf6@treble>
References: <b581438a16e78559b4cea28cf8bc74158791a9b3.1588273491.git.jpoimboe@redhat.com>
 <20200501190930.ptxyml5o4rviyo26@ast-mbp.dhcp.thefacebook.com>
 <20200501192204.cepwymj3fln2ngpi@treble>
 <20200501194053.xyahhknjjdu3gqix@ast-mbp.dhcp.thefacebook.com>
 <20200501195617.czrnfqqcxfnliz3k@treble>
 <20200502030622.yrszsm54r6s6k6gq@ast-mbp.dhcp.thefacebook.com>
 <20200502192105.xp2osi5z354rh4sm@treble>
 <20200505174300.gech3wr5v6kkho35@ast-mbp.dhcp.thefacebook.com>
 <89101da0-20e4-a29f-9796-870aa4d328a6@infradead.org>
 <20200505191405.v3xai47bxeaqsmyg@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200505191405.v3xai47bxeaqsmyg@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 12:14:05PM -0700, Alexei Starovoitov wrote:
> > 
> > Hi,
> > 
> > I see the objtool warning:
> > kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x33: call without frame pointer save/setup
> > 
> > when using:
> > gcc (SUSE Linux) 9.3.1 20200406 [revision 6db837a5288ee3ca5ec504fbd5a765817e556ac2]
> > 
> > with the attached config file.
> 
> Thanks Randy. I reproduced it.

This problem isn't a mystery, it's caused by __attribute__((optimize)).

The only real solution is to revert

  3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()")

Once you do that (and disable retpolines) then you should see the
problem described in my other email.

-- 
Josh

