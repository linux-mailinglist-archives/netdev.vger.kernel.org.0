Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE7321A454
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 18:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgGIQFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 12:05:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49454 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgGIQFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 12:05:30 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069FpnaO160519;
        Thu, 9 Jul 2020 16:04:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Iaxp8WVU9LYuQViXmfxKLlsL1ZcMCICKq4clfeVvLdI=;
 b=wjcjVJysydjM0e+dD3PbW+CL84+4mYqCPzUGYmwDhtcm8Y+4h5kP7QksnI8PsblfZGj6
 b161l4lUWtJGLDD8CfZKSMgUQYwtPoB7B9YrnZRIYFTosL7/cO/S/oYDHaI24EVgBLbV
 uEVmLqZ6yK+4vIWxUN/qyFp6Ie6/mCQMcetWRIqL+iPCuJfcJ+0KjKufHkYFfbZJJRWV
 qTYxbV/utsJu958isB2UEGE8hLiIdRfofK+DaWLrIcCkN6sUyCj4sWlyfqwMeWQScuEF
 LqjFwPEB6tlclKknEO5VkwxAi3BJK3PYXXm0iH8enKjclAxZ8dINektHtkYlBH+RxpZw YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 325y0ajqxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 09 Jul 2020 16:04:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069FnGUO132786;
        Thu, 9 Jul 2020 16:04:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 325k3h9c1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jul 2020 16:04:22 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 069G4Lg7001625;
        Thu, 9 Jul 2020 16:04:21 GMT
Received: from dhcp-10-175-207-152.vpn.oracle.com (/10.175.207.152)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jul 2020 09:04:21 -0700
Date:   Thu, 9 Jul 2020 17:04:13 +0100 (IST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/2] bpf: use dedicated bpf_trace_printk event
 instead of trace_printk()
In-Reply-To: <CAEf4BzaGWZGYQf6C0GT3mwhjh8PSVLwgoFiHtpx6zaTny3B_gw@mail.gmail.com>
Message-ID: <alpine.LRH.2.21.2007091656240.16404@localhost>
References: <1593787468-29931-1-git-send-email-alan.maguire@oracle.com> <1593787468-29931-2-git-send-email-alan.maguire@oracle.com> <CAEf4BzaGWZGYQf6C0GT3mwhjh8PSVLwgoFiHtpx6zaTny3B_gw@mail.gmail.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007090115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007090115
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 7 Jul 2020, Andrii Nakryiko wrote:

> On Fri, Jul 3, 2020 at 7:47 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > The bpf helper bpf_trace_printk() uses trace_printk() under the hood.
> > This leads to an alarming warning message originating from trace
> > buffer allocation which occurs the first time a program using
> > bpf_trace_printk() is loaded.
> >
> > We can instead create a trace event for bpf_trace_printk() and enable
> > it in-kernel when/if we encounter a program using the
> > bpf_trace_printk() helper.  With this approach, trace_printk()
> > is not used directly and no warning message appears.
> >
> > This work was started by Steven (see Link) and finished by Alan; added
> > Steven's Signed-off-by with his permission.
> >
> > Link: https://lore.kernel.org/r/20200628194334.6238b933@oasis.local.home
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > ---
> >  kernel/trace/Makefile    |  2 ++
> >  kernel/trace/bpf_trace.c | 41 +++++++++++++++++++++++++++++++++++++----
> >  kernel/trace/bpf_trace.h | 34 ++++++++++++++++++++++++++++++++++
> >  3 files changed, 73 insertions(+), 4 deletions(-)
> >  create mode 100644 kernel/trace/bpf_trace.h
> >
> 
> [...]
> 
> > +static DEFINE_SPINLOCK(trace_printk_lock);
> > +
> > +#define BPF_TRACE_PRINTK_SIZE   1024
> > +
> > +static inline int bpf_do_trace_printk(const char *fmt, ...)
> > +{
> > +       static char buf[BPF_TRACE_PRINTK_SIZE];
> > +       unsigned long flags;
> > +       va_list ap;
> > +       int ret;
> > +
> > +       spin_lock_irqsave(&trace_printk_lock, flags);
> > +       va_start(ap, fmt);
> > +       ret = vsnprintf(buf, BPF_TRACE_PRINTK_SIZE, fmt, ap);
> > +       va_end(ap);
> > +       if (ret > 0)
> > +               trace_bpf_trace_printk(buf);
> 
> Is there any reason to artificially limit the case of printing empty
> string? It's kind of an awkward use case, for sure, but having
> guarantee that every bpf_trace_printk() invocation triggers tracepoint
> is a nice property, no?
>

True enough; I'll modify the above to support empty string display also.
 
> > +       spin_unlock_irqrestore(&trace_printk_lock, flags);
> > +
> > +       return ret;
> > +}
> > +
> >  /*
> >   * Only limited trace_printk() conversion specifiers allowed:
> >   * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pB %pks %pus %s
> > @@ -483,8 +510,7 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
> >   */
> >  #define __BPF_TP_EMIT()        __BPF_ARG3_TP()
> >  #define __BPF_TP(...)                                                  \
> > -       __trace_printk(0 /* Fake ip */,                                 \
> > -                      fmt, ##__VA_ARGS__)
> > +       bpf_do_trace_printk(fmt, ##__VA_ARGS__)
> >
> >  #define __BPF_ARG1_TP(...)                                             \
> >         ((mod[0] == 2 || (mod[0] == 1 && __BITS_PER_LONG == 64))        \
> > @@ -518,13 +544,20 @@ static void bpf_trace_copy_string(char *buf, void *unsafe_ptr, char fmt_ptype,
> >         .arg2_type      = ARG_CONST_SIZE,
> >  };
> >
> > +int bpf_trace_printk_enabled;
> 
> static?
> 

oops, will fix.

> > +
> >  const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
> >  {
> >         /*
> >          * this program might be calling bpf_trace_printk,
> > -        * so allocate per-cpu printk buffers
> > +        * so enable the associated bpf_trace/bpf_trace_printk event.
> >          */
> > -       trace_printk_init_buffers();
> > +       if (!bpf_trace_printk_enabled) {
> > +               if (trace_set_clr_event("bpf_trace", "bpf_trace_printk", 1))
> 
> just to double check, it's ok to simultaneously enable same event in
> parallel, right?
>

From an ftrace perspective, it looks fine since the actual enable is 
mutex-protected. We could grab the trace_printk_lock here too I guess,
but I don't _think_ there's a need. 
 
Thanks for reviewing! I'll spin up a v2 with the above fixes shortly
plus I'll change to using tp/raw_syscalls/sys_enter in the test as you 
suggested.

Alan
