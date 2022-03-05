Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D615E4CE625
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 17:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbiCEQ6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 11:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiCEQ6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 11:58:53 -0500
Received: from gofer.mess.org (gofer.mess.org [IPv6:2a02:8011:d000:212::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5408E41FA9;
        Sat,  5 Mar 2022 08:58:02 -0800 (PST)
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 47BBB101CB3; Sat,  5 Mar 2022 16:58:00 +0000 (UTC)
Date:   Sat, 5 Mar 2022 16:58:00 +0000
From:   Sean Young <sean@mess.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Song Liu <song@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 01/28] bpf: add new is_sys_admin_prog_type()
 helper
Message-ID: <YiOWmG2oARiYmRHr@gofer.mess.org>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-2-benjamin.tissoires@redhat.com>
 <CAPhsuW4otgwwDN6+xcjPXmZyUDiynEKFtXjaFb-=kjz7HzUmZw@mail.gmail.com>
 <CAO-hwJJjDMaTXH9i1UkO7Qy+sbNprDyW67cRp8HryMMWMi5H9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO-hwJJjDMaTXH9i1UkO7Qy+sbNprDyW67cRp8HryMMWMi5H9w@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 05, 2022 at 11:07:04AM +0100, Benjamin Tissoires wrote:
> On Sat, Mar 5, 2022 at 12:12 AM Song Liu <song@kernel.org> wrote:
> >
> > On Fri, Mar 4, 2022 at 9:30 AM Benjamin Tissoires
> > <benjamin.tissoires@redhat.com> wrote:
> > >
> > > LIRC_MODE2 does not really need net_admin capability, but only sys_admin.
> > >
> > > Extract a new helper for it, it will be also used for the HID bpf
> > > implementation.
> > >
> > > Cc: Sean Young <sean@mess.org>
> > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > >
> > > ---
> > >
> > > new in v2
> > > ---
> > >  kernel/bpf/syscall.c | 14 +++++++++++++-
> > >  1 file changed, 13 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > index db402ebc5570..cc570891322b 100644
> > > --- a/kernel/bpf/syscall.c
> > > +++ b/kernel/bpf/syscall.c
> > > @@ -2165,7 +2165,6 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
> > >         case BPF_PROG_TYPE_LWT_SEG6LOCAL:
> > >         case BPF_PROG_TYPE_SK_SKB:
> > >         case BPF_PROG_TYPE_SK_MSG:
> > > -       case BPF_PROG_TYPE_LIRC_MODE2:
> > >         case BPF_PROG_TYPE_FLOW_DISSECTOR:
> > >         case BPF_PROG_TYPE_CGROUP_DEVICE:
> > >         case BPF_PROG_TYPE_CGROUP_SOCK:
> > > @@ -2202,6 +2201,17 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
> > >         }
> > >  }
> > >
> > > +static bool is_sys_admin_prog_type(enum bpf_prog_type prog_type)
> > > +{
> > > +       switch (prog_type) {
> > > +       case BPF_PROG_TYPE_LIRC_MODE2:
> > > +       case BPF_PROG_TYPE_EXT: /* extends any prog */
> > > +               return true;
> > > +       default:
> > > +               return false;
> > > +       }
> > > +}
> >
> > I am not sure whether we should do this. This is a behavior change, that may
> > break some user space. Also, BPF_PROG_TYPE_EXT is checked in
> > is_perfmon_prog_type(), and this change will make that case useless.
> 
> Sure, I can drop it from v3 and make this function appear for HID only.

For BPF_PROG_TYPE_LIRC_MODE2, I don't think this change will break userspace.
This is called from ir-keytable(1) which is called from udev. It should have
all the necessary permissions.

In addition, the vast majority IR decoders are non-bpf. bpf ir decoders have
very few users at the moment.

I am working on completely new userspace tooling which will make extensive
use of bpf ir decoding with full lircd and IRP compatibility, but this is not
finished yet (see https://github.com/seanyoung/cir).

Thanks

Sean
