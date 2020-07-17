Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98F722408C
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 18:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGQQZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 12:25:30 -0400
Received: from verein.lst.de ([213.95.11.211]:39423 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgGQQZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 12:25:30 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 29CBD68BEB; Fri, 17 Jul 2020 18:25:27 +0200 (CEST)
Date:   Fri, 17 Jul 2020 18:25:26 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: how is the bpfilter sockopt processing supposed to work
Message-ID: <20200717162526.GA17072@lst.de>
References: <20200717055245.GA9577@lst.de> <CAADnVQ+rD+7fAsLZT4pG7AN4iO7-dQ+3adw0tBhrf8TGbtLjtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+rD+7fAsLZT4pG7AN4iO7-dQ+3adw0tBhrf8TGbtLjtA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 09:13:07AM -0700, Alexei Starovoitov wrote:
> On Thu, Jul 16, 2020 at 10:52 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Hi Alexei,
> >
> > I've just been auditing the sockopt code, and bpfilter looks really
> > odd.  Both getsockopts and setsockopt eventually end up
> > in__bpfilter_process_sockopt, which then passes record to the
> > userspace helper containing the address of the optval buffer.
> > Which depending on bpf-cgroup might be in user or kernel space.
> > But even if it is in userspace it would be in a different process
> > than the bpfiler helper.  What makes all this work?
> 
> Hmm. Good point. bpfilter assumes user addresses. It will break
> if bpf cgroup sockopt messes with it.
> We had a different issue with bpf-cgroup-sockopt and iptables in the past.
> Probably the easiest way forward is to special case this particular one.
> With your new series is there a way to tell in bpfilter_ip_get_sockopt()
> whether addr is kernel or user? And if it's the kernel just return with error.

Yes, I can send a fix.  But how do even the user space addressed work?
If some random process calls getsockopt or setsockopt, how does the
bpfilter user mode helper attach to its address space?
