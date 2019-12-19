Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36101125D61
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 10:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfLSJOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 04:14:23 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44914 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfLSJOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 04:14:22 -0500
Received: by mail-wr1-f66.google.com with SMTP id q10so5150234wrm.11;
        Thu, 19 Dec 2019 01:14:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S665pIJS3c5uCPmPgzBwkP3LU07+b+t424iKJ7p8WuI=;
        b=q19B2cii8UHuaVoH1Z7GhGc0xwaH5gIeq4MDPVNlIC4PyH2fyB/CdrAV7I2q8SCp9Q
         uIdKs7ru5EiD5tdJbUzDCKB9Yfex4h3NkeViqTTwPxvhxzZfVtNZRI0Ki3quxFhEFNeX
         7K1y6sGO/vhbsgAI5Pq9STq2ERhDmp9eLCc6im49TOK37Xb9EyzBuMp23XOhwz4GmhW4
         4AtdHimMF7aRUoc/+URI+6OtRtnBnATuWbRnsMga8vcpIusmOC7cfA9/9x9q3NGQgTsR
         mgg+fSkqoF0Zdr4Tuu9Zj9uOT/e6Cs3UIBfzExZyxtTtVgHVS3thTJw6ht135kU0My/K
         2Mpg==
X-Gm-Message-State: APjAAAWUwQE2qw59Y6NdARbdXrGPXalgV9sIsmOOItbK5c/Kh2yEjDx7
        h5+M+e2Kv+EId5H7IUztXi8=
X-Google-Smtp-Source: APXvYqyxnlaH4Rd9JEvTobmsyRjoTlGJORS1lnWlaZIjisRjmr6Dn/QCguA4BOgpiX2fM5yaMPfW2A==
X-Received: by 2002:adf:fd87:: with SMTP id d7mr8262096wrr.226.1576746859928;
        Thu, 19 Dec 2019 01:14:19 -0800 (PST)
Received: from Omicron ([217.76.31.1])
        by smtp.gmail.com with ESMTPSA id g23sm5476207wmk.14.2019.12.19.01.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 01:14:19 -0800 (PST)
Date:   Thu, 19 Dec 2019 10:14:18 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, paul.chaignon@gmail.com,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Single-cpu updates for per-cpu maps
Message-ID: <20191219091418.GA6322@Omicron>
References: <cover.1576673841.git.paul.chaignon@orange.com>
 <ec8fd77bb20881e7149f7444e731c510790191ce.1576673842.git.paul.chaignon@orange.com>
 <20191218180042.2ktkmok5ugeahczn@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218180042.2ktkmok5ugeahczn@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks everyone for the reviews and suggestions!

On Wed, Dec 18, 2019 at 10:00:44AM -0800, Alexei Starovoitov wrote:
> On Wed, Dec 18, 2019 at 03:23:04PM +0100, Paul Chaignon wrote:
> > Currently, userspace programs have to update the values of all CPUs at
> > once when updating per-cpu maps.  This limitation prevents the update of
> > a single CPU's value without the risk of missing concurrent updates on
> > other CPU's values.
> > 
> > This patch allows userspace to update the value of a specific CPU in
> > per-cpu maps.  The CPU whose value should be updated is encoded in the
> > 32 upper-bits of the flags argument, as follows.  The new BPF_CPU flag
> > can be combined with existing flags.
> 
> In general makes sense. Could you elaborate more on concrete issue?

Sure.  I have a BPF program that matches incoming packets against
packet-filtering rules, with a NIC that steers some flows (correspond to
different tenants) to specific CPUs.  Rules are stored in a per-cpu
hashmap with a counter (counting matching packets) and an off/on switch.
To enable a rule on a new CPU, I lookup the value for that rule, switch
the on/off variable in the value corresponding to the given CPU and
update the map.  However, the counters corresponding to other CPUs for
that same rule might have been updated between the lookup and the
update.

Other BPF users have requested the same feature before on the bcc
repository [1].  They probably have different (tracing-related?) use
cases.

1 - https://github.com/iovisor/bcc/issues/1886

> 
> >   bpf_map_update_elem(..., cpuid << 32 | BPF_CPU)
> > 
> > Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
> > ---
> >  include/uapi/linux/bpf.h       |  4 +++
> >  kernel/bpf/arraymap.c          | 19 ++++++++-----
> >  kernel/bpf/hashtab.c           | 49 ++++++++++++++++++++--------------
> >  kernel/bpf/local_storage.c     | 16 +++++++----
> >  kernel/bpf/syscall.c           | 17 +++++++++---
> >  tools/include/uapi/linux/bpf.h |  4 +++
> >  6 files changed, 74 insertions(+), 35 deletions(-)
> > 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index dbbcf0b02970..2efb17d2c77a 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -316,6 +316,10 @@ enum bpf_attach_type {
> >  #define BPF_NOEXIST	1 /* create new element if it didn't exist */
> >  #define BPF_EXIST	2 /* update existing element */
> >  #define BPF_F_LOCK	4 /* spin_lock-ed map_lookup/map_update */
> > +#define BPF_CPU		8 /* single-cpu update for per-cpu maps */
> 
> BPF_F_CPU would be more consistent with the rest of flags.
> 
> Can BPF_F_CURRENT_CPU be supported as well?

You mean to update the value corresponding to the CPU on which the
userspace program is running?  BPF_F_CURRENT_CPU is a mask on the lower 
32 bits so it would clash with existing flags, but there's probably
another way to implement the same.  Not sure I see the use case though;
userspace programs can easily update the value for the current CPU with
BPF_F_CPU.

> 
> And for consistency support this flag in map_lookup_elem too?

Sure, I'll add it to the v2.

> 
> > +
> > +/* CPU mask for single-cpu updates */
> > +#define BPF_CPU_MASK	0xFFFFFFFF00000000ULL
> 
> what is the reason to expose this in uapi?

No reason; that's a mistake.

> 
> >  /* flags for BPF_MAP_CREATE command */
> >  #define BPF_F_NO_PREALLOC	(1U << 0)
> > diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> > index f0d19bbb9211..a96e94696819 100644
> > --- a/kernel/bpf/arraymap.c
> > +++ b/kernel/bpf/arraymap.c
> > @@ -302,7 +302,8 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
> >  	u32 index = *(u32 *)key;
> >  	char *val;
> >  
> > -	if (unlikely((map_flags & ~BPF_F_LOCK) > BPF_EXIST))
> > +	if (unlikely((map_flags & ~BPF_CPU_MASK & ~BPF_F_LOCK &
> > +				  ~BPF_CPU) > BPF_EXIST))
> 
> that reads odd.
> More traditional would be ~ (A | B | C)
> 
