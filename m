Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C06D5D9336
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 16:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393748AbfJPOBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 10:01:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:34726 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388087AbfJPOBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 10:01:24 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iKjrV-00075a-3a; Wed, 16 Oct 2019 16:01:13 +0200
Date:   Wed, 16 Oct 2019 16:01:12 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Yonghong Song <yhs@fb.com>
Subject: Re: debug annotations for bpf progs. Was: [PATCH bpf-next 1/3] bpf:
 preserve command of the process that loaded the program
Message-ID: <20191016140112.GF21367@pc-63.home>
References: <20191011162124.52982-1-sdf@google.com>
 <CAADnVQLKPLXej_v7ymv3yJakoFLGeQwdZOJ5cZmp7xqOxfebqg@mail.gmail.com>
 <20191012003819.GK2096@mini-arch>
 <CAADnVQKuysEvFAX54+f0YPJ1+cgcRJbhrpVE7xmvLqu-ADrk+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKuysEvFAX54+f0YPJ1+cgcRJbhrpVE7xmvLqu-ADrk+Q@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25604/Wed Oct 16 10:53:05 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 02:21:50PM -0700, Alexei Starovoitov wrote:
> On Fri, Oct 11, 2019 at 5:38 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > On 10/11, Alexei Starovoitov wrote:
> > > On Fri, Oct 11, 2019 at 9:21 AM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > Even though we have the pointer to user_struct and can recover
> > > > uid of the user who has created the program, it usually contains
> > > > 0 (root) which is not very informative. Let's store the comm of the
> > > > calling process and export it via bpf_prog_info. This should help
> > > > answer the question "which process loaded this particular program".
> > > >
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > ---
> > > >  include/linux/bpf.h      | 1 +
> > > >  include/uapi/linux/bpf.h | 2 ++
> > > >  kernel/bpf/syscall.c     | 4 ++++
> > > >  3 files changed, 7 insertions(+)
> > > >
> > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > index 5b9d22338606..b03ea396afe5 100644
> > > > --- a/include/linux/bpf.h
> > > > +++ b/include/linux/bpf.h
> > > > @@ -421,6 +421,7 @@ struct bpf_prog_aux {
> > > >                 struct work_struct work;
> > > >                 struct rcu_head rcu;
> > > >         };
> > > > +       char created_by_comm[BPF_CREATED_COMM_LEN];
> > > >  };
> > > >
> > > >  struct bpf_array {
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index a65c3b0c6935..4e883ecbba1e 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -326,6 +326,7 @@ enum bpf_attach_type {
> > > >  #define BPF_F_NUMA_NODE                (1U << 2)
> > > >
> > > >  #define BPF_OBJ_NAME_LEN 16U
> > > > +#define BPF_CREATED_COMM_LEN   16U
> > >
> > > Nack.
> > > 16 bytes is going to be useless.
> > > We found it the hard way with prog_name.
> > > If you want to embed additional debug information
> > > please use BTF for that.
> > BTF was my natural choice initially, but then I saw created_by_uid and
> > thought created_by_comm might have a chance :-)
> >
> > To clarify, by BTF you mean creating some unused global variable
> > and use its name as the debugging info? Or there is some better way?
> 
> I was thinking about adding new section to .btf.ext with this extra data,
> but global variable is a better idea indeed.
> We'd need to standardize such variables names, so that
> bpftool can parse and print it while doing 'bpftool prog show'.

+1, much better indeed.

> We see more and more cases where services use more than
> one program in single .c file to accomplish their goals.
> Tying such debug info (like 'created_by_comm') to each program
> individually isn't quite right.
> In that sense global variables are better, since they cover the
> whole .c file.
> Beyond 'created_by_comm' there are others things that people
> will likely want to know.
> Like which version of llvm was used to compile this .o file.
> Which unix user name compiled it.
> The name of service/daemon that will be using this .o
> and so on.

Also latest git sha of the source repo, for example.

> May be some standard prefix to such global variables will do?
> Like "bpftool prog show" can scan global data for
> "__annotate_#name" and print both name and string contents ?
> For folks who regularly ssh into servers to debug bpf progs
> that will help a lot.
> May be some annotations llvm can automatically add to .o.
> Thoughts?

One thing that might be less clear is how information such as comm
or comm args would be stuffed into BTF here, but perhaps these two
wouldn't necessarily need to be part of it since these can be retrieved
today (as in: "which program is currently holding a reference via fd
to a certain prog/map"). For that bpftool could simply walk procfs
once and correlate via fdinfo on unique prog/map id, so we could list
comms in the dump which should be trivial to add:

  # ls -la /proc/30651/fd/10
  lrwx------ 1 root root 64 Oct 16 15:53 /proc/30651/fd/10 -> anon_inode:bpf-map
  # cat /proc/30651/fdinfo/10
  pos:	0
  flags:	02000002
  mnt_id:	15
  map_type:	1
  key_size:	24
  value_size:	12
  max_entries:	65536
  map_flags:	0x0
  memlock:	6819840
  map_id:	384          <---
  frozen:	0
  # cat /proc/30651/comm 
  cilium-agent
  # cat /proc/30651/cmdline 
  ./daemon/cilium-agent--ipv4-range10.11.0.0/16[...]--enable-node-port=true

... and similar for progs. Getting the cmdline from kernel side seems
rather annoying from looking into what detour procfs needs to perform.

But aside from these, such annotations via BTF would be really useful.

Thanks,
Daniel
