Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4B723E8D9
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 10:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgHGI1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 04:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgHGI1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 04:27:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4886CC061574
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 01:27:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=localhost)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <r.czerwinski@pengutronix.de>)
        id 1k3xiO-00062j-Qp; Fri, 07 Aug 2020 10:27:00 +0200
Message-ID: <b55718ad4e675ed9a9c3eb1c5d952945f8b20c7a.camel@pengutronix.de>
Subject: Re: [PATCH v2 net-next] net/tls: allow MSG_CMSG_COMPAT in sendmsg
From:   Rouven Czerwinski <r.czerwinski@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Aviad Yehezkel <aviadye@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>
Date:   Fri, 07 Aug 2020 10:26:54 +0200
In-Reply-To: <20200806114657.42f1ce8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200806064906.14421-1-r.czerwinski@pengutronix.de>
         <20200806114657.42f1ce8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Organization: Pengutronix e.K.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: r.czerwinski@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-08-06 at 11:46 -0700, Jakub Kicinski wrote:
> On Thu,  6 Aug 2020 08:49:06 +0200 Rouven Czerwinski wrote:
> > Trying to use ktls on a system with 32-bit userspace and 64-bit
> > kernel
> > results in a EOPNOTSUPP message during sendmsg:
> > 
> >   setsockopt(3, SOL_TLS, TLS_TX, …, 40) = 0
> >   sendmsg(3, …, msg_flags=0}, 0) = -1 EOPNOTSUPP (Operation not
> > supported)
> > 
> > The tls_sw implementation does strict flag checking and does not
> > allow
> > the MSG_CMSG_COMPAT flag, which is set if the message comes in
> > through
> > the compat syscall.
> > 
> > This patch adds MSG_CMSG_COMPAT to the flag check to allow the
> > usage of
> > the TLS SW implementation on systems using the compat syscall path.
> > 
> > Note that the same check is present in the sendmsg path for the TLS
> > device implementation, however the flag hasn't been added there for
> > lack
> > of testing hardware.
> > 
> > Signed-off-by: Rouven Czerwinski <r.czerwinski@pengutronix.de>
> 
> I don't know much about the compat stuff, I trust our cmsg handling
> is
> fine?
> 
> Just to be sure - did you run tools/testing/selftests/net/tls ?

After some pains to get this to correctly compile I have two failing
tests, both for multi_chunk_sendfile:

root@192:~ /usr/lib/kselftest/net/tls
[==========] Running 93 tests from 4 test cases.
…
[ RUN      ] tls.12.multi_chunk_sendfile
multi_chunk_sendfile: Test terminated by timeout
[     FAIL ] tls.12.multi_chunk_sendfile
…
[ RUN      ] tls.13.multi_chunk_sendfile
multi_chunk_sendfile: Test terminated by timeout
[     FAIL ] tls.13.multi_chunk_sendfile
…
[==========] 91 / 93 tests passed.
[  FAILED  ]

Looks like the test is hanging within the recv, strace output:

write(1, "[ RUN      ] tls.12.multi_chunk_"..., 41[ RUN      ] tls.12.multi_chunk_sendfile
) = 41
clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLDstrace: Process 674 attached
, child_tidptr=0xf7e557b8) = 674
[pid   668] rt_sigaction(SIGALRM, {sa_handler=0x4b77d9, sa_mask=[], sa_flags=SA_RESTORER|SA_SIGINFO, sa_restorer=0xf7d61a71},  <unfinished ...>
[pid   674] socket(AF_INET, SOCK_STREAM, IPPROTO_IP <unfinished ...>
[pid   668] <... rt_sigaction resumed>{sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0xf7d61a61}, 8) = 0
[pid   674] <... socket resumed>)       = 3
[pid   668] setitimer(ITIMER_REAL, {it_interval={tv_sec=0, tv_usec=0}, it_value={tv_sec=30, tv_usec=0}},  <unfinished ...>
[pid   674] socket(AF_INET, SOCK_STREAM, IPPROTO_IP <unfinished ...>
[pid   668] <... setitimer resumed>{it_interval={tv_sec=0, tv_usec=0}, it_value={tv_sec=0, tv_usec=0}}) = 0
[pid   674] <... socket resumed>)       = 4
[pid   668] wait4(674,  <unfinished ...>
[pid   674] bind(4, {sa_family=AF_INET, sin_port=htons(0), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
[pid   674] listen(4, 10)               = 0
[pid   674] getsockname(4, {sa_family=AF_INET, sin_port=htons(48719), sin_addr=inet_addr("0.0.0.0")}, [16]) = 0
[pid   674] connect(3, {sa_family=AF_INET, sin_port=htons(48719), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
[pid   674] setsockopt(3, SOL_TCP, TCP_ULP, [7564404], 4) = 0
[pid   674] setsockopt(3, SOL_TLS, TLS_TX, "\3\0033\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 40) = 0
[pid   674] accept(4, {sa_family=AF_INET, sin_port=htons(33780), sin_addr=inet_addr("127.0.0.1")}, [16]) = 5                                                                                                                                                                                                                                                                                                                                                                                   [pid   674] setsockopt(5, SOL_TCP, TCP_ULP, [7564404], 4) = 0
[pid   674] setsockopt(5, SOL_TLS, TLS_RX, "\3\0033\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 40) = 0
[pid   674] close(4)                    = 0                                                                                                                                                                                                                                                                                                                                                                                                                                                    [pid   674] clock_gettime(CLOCK_MONOTONIC, {tv_sec=922, tv_nsec=578176800}) = 0
[pid   674] getpid()                    = 674
[pid   674] openat(AT_FDCWD, "/tmp/mytemp.8TBuLa", O_RDWR|O_CREAT|O_EXCL, 0600) = 4                                                                                                                                                                                                                                                                                                                                                                                                            [pid   674] unlink("/tmp/mytemp.8TBuLa") = 0
[pid   674] write(4, "\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1"..., 8192) = 8192
[pid   674] fsync(4)                    = 0                                                                                                                                                                                                                                                                                                                                                                                                                                                    [pid   674] sendfile(3, 4, [0] => [4096], 4096) = 4096
[pid   674] sendfile(3, 4, [4096] => [8192], 4096) = 4096
[pid   674] recv(5, "\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1"..., 8192, MSG_WAITALL) = 8192                                                                                                                                                                                                                                                                                                                                                                           [pid   674] close(4)                    = 0
[pid   674] clock_gettime(CLOCK_MONOTONIC, {tv_sec=922, tv_nsec=579166200}) = 0
[pid   674] getpid()                    = 674                                                                                                                                                                                                                                                                                                                                                                                                                                                  [pid   674] openat(AT_FDCWD, "/tmp/mytemp.yfOW98", O_RDWR|O_CREAT|O_EXCL, 0600) = 4
[pid   674] unlink("/tmp/mytemp.yfOW98") = 0
[pid   674] write(4, "\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1"..., 4096) = 4096                                                                                                                                                                                                                                                                                                                                                                                       [pid   674] fsync(4)                    = 0
[pid   674] sendfile(3, 4, [0] => [4096], 4096) = 4096
[pid   674] recv(5, "\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1"..., 4096, MSG_WAITALL) = 4096
[pid   674] close(4)                    = 0
[pid   674] clock_gettime(CLOCK_MONOTONIC, {tv_sec=922, tv_nsec=579828840}) = 0
[pid   674] getpid()                    = 674
[pid   674] openat(AT_FDCWD, "/tmp/mytemp.90qtNb", O_RDWR|O_CREAT|O_EXCL, 0600) = 4
[pid   674] unlink("/tmp/mytemp.90qtNb") = 0
[pid   674] write(4, "\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1\1"..., 4097) = 4097
[pid   674] fsync(4)                    = 0
[pid   674] sendfile(3, 4, [0] => [4096], 4096) = 4096
[pid   674] sendfile(3, 4, [4096] => [4097], 4096) = 1
[pid   674] recv(5,  <unfinished ...>
[pid   668] <... wait4 resumed>0xffa225b8, 0, NULL) = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
[pid   668] --- SIGALRM {si_signo=SIGALRM, si_code=SI_KERNEL} ---
[pid   668] kill(674, SIGKILL)          = 0
[pid   674] <... recv resumed>"", 4097, MSG_WAITALL) = 0
[pid   668] rt_sigreturn({mask=[]})     = -1 EINTR (Interrupted system call)
[pid   668] setitimer(ITIMER_REAL, {it_interval={tv_sec=0, tv_usec=0}, it_value={tv_sec=0, tv_usec=0}}, {it_interval={tv_sec=0, tv_usec=0}, it_value={tv_sec=0, tv_usec=0}}) = 0
[pid   668] rt_sigaction(SIGALRM, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0xf7d61a61}, NULL, 8) = 0
[pid   668] write(2, "multi_chunk_sendfile: Test termi"..., 49 <unfinished ...>
[pid   674] +++ killed by SIGKILL +++
<... write resumed>)                    = ? ERESTARTSYS (To be restarted if SA_RESTART is set)
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_KILLED, si_pid=674, si_uid=0, si_status=SIGKILL, si_utime=0, si_stime=0} ---
write(2, "multi_chunk_sendfile: Test termi"..., 49multi_chunk_sendfile: Test terminated by timeout
) = 49
write(1, "[     FAIL ] tls.12.multi_chunk_"..., 41[     FAIL ] tls.12.multi_chunk_sendfile

I'll look into the recv failure.

Regards,
Rouven 

