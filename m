Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA65CCAE84
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 20:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbfJCStg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Oct 2019 14:49:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbfJCStg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 14:49:36 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ED8012A09D8;
        Thu,  3 Oct 2019 18:49:35 +0000 (UTC)
Received: from carbon (ovpn-200-24.brq.redhat.com [10.40.200.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AABB75C226;
        Thu,  3 Oct 2019 18:49:27 +0000 (UTC)
Date:   Thu, 3 Oct 2019 20:49:26 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
Message-ID: <20191003204926.113813f5@carbon>
In-Reply-To: <1c9b72f9-1b61-d89a-49a4-e0b8eead853d@solarflare.com>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
        <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com>
        <A754440E-07BF-4CF4-8F15-C41179DCECEF@fb.com>
        <87r23vq79z.fsf@toke.dk>
        <20191003105335.3cc65226@carbon>
        <CAADnVQKTbaxJhkukxXM7Ue7=kA9eWsGMpnkXc=Z8O3iWGSaO0A@mail.gmail.com>
        <87pnjdq4pi.fsf@toke.dk>
        <1c9b72f9-1b61-d89a-49a4-e0b8eead853d@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 03 Oct 2019 18:49:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Oct 2019 15:53:50 +0100
Edward Cree <ecree@solarflare.com> wrote:

> On 03/10/2019 15:33, Toke Høiland-Jørgensen wrote:
> > In all cases, the sysadmin can't (or doesn't want to) modify any of the
> > XDP programs. In fact, they may just be installed as pre-compiled .so
> > BPF files on his system. So he needs to be able to configure the call
> > chain of different programs without modifying the eBPF program source
> > code.  
>
> Perhaps I'm being dumb, but can't we solve this if we make linking work?
> I.e. myIDS.so has ids_main() function, myFirewall.so has firewall()
>  function, and sysadmin writes a little XDP prog to call these:
> 
> int main(struct xdp_md *ctx)
> {
>         int rc = firewall(ctx), rc2;
> 
>         switch(rc) {
>         case XDP_DROP:
>         case XDP_ABORTED:
>         default:
>                 return rc;
>         case XDP_PASS:
>                 return ids_main(ctx);
>         case XDP_TX:
>         case XDP_REDIRECT:
>                 rc2 = ids_main(ctx);
>                 if (rc2 == XDP_PASS)
>                         return rc;
>                 return rc2;
>         }
> }
> 
> Now he compiles this and links it against those .so files, giving him
> a new object file which he can then install.

Sorry, but I don't think this makes sense. 

We are not dealing with .so (shared-object) files.  These are BPF
ELF-object files, which is not really ELF-objects in a normal sense.
The role of libbpf is to load the BPF elements in the ELF-file, via the
BPF-syscall.  First the maps are loaded (gets back a FD from
BPF-syscall), and then program sections are "opened" and ELF-relocation
is preformed replacing map accesses with map-FD's, before loading the
BPF byte-code via BPF-syscall.

Next issue is that the program loading the BPF-ELF object will get the
map FD's, which it expect and need to query and also populate with for
example its config.  Thus, you would need to pass the FD to the
original userspace application.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
