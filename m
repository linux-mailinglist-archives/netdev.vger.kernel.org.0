Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51043131B12
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 23:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgAFWHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 17:07:51 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36166 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgAFWHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 17:07:51 -0500
Received: by mail-pl1-f193.google.com with SMTP id a6so21622745plm.3;
        Mon, 06 Jan 2020 14:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pH0bW5L244MhRBbTgYq971yU1s9EHra7myYPhaQViJg=;
        b=U3ESQHwtHWbtFMdfTuDBniP6O0qQcGNps8BjZGNmHiiZ3MjD29QZYDu5t9gA8C6zeI
         kPPUWZwLXplbBsAeo2r3ToaG1hpj4G+zYvoJurqGgzghNPvinzIdQvKHuhuOIqEfUzwj
         SW3cCAxDBUNUZqtW8JwH2zT98ODIthR8aRgPyOQq0ZaJH+tR01uCMUI1rIv0zmKGXAYn
         lQBX/Yvvhz+hbrEldYo3kxC4hQkMFIHlNkyy00qRpKY+PcbUBLtBYFC2UPvJ3WrXCnOf
         Oa8OANHUEqg6Ary+vPRYwfzGyvRZHdUrMx4G8XeEPQZ/z2j+fBQE9bB0rxLNQyy/3t2T
         IhLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pH0bW5L244MhRBbTgYq971yU1s9EHra7myYPhaQViJg=;
        b=cPc+Wf/s+V2Ky+2m5XyDECmXdzMEkBlld7TqavuWA0JJuP+3zI1zEC3ln9U3IJIoOt
         nFDdLne8Qpjgxa8wCc0rKGfv1WfTzFJlvgVfeewg9Mmc78ISTd+cHQGcIei4nR1lmiNw
         4H6kqiNgL8qFht6FI8db5aDMQ6e/8nm1up6yNQpqlQZKikJaKBrA2HWYkMdvAtYNuJCw
         Gyl/838EvPInaFjbThRO7Y8+EzoQUH5L93QouqVSfVSfuavg8+cCVIjFHuOe+UY70tvk
         BCB6ic9j+UqMRZm2TjpF0O6ZlCrhy9c0/cRvWrnz1UOapXmJOAxX2c2btcR9D0iIPK56
         /TKA==
X-Gm-Message-State: APjAAAUMzWdXdgpq9j4iOle23hMMmT5uJdXEUXX9FFLGjBgmdfZHn4p9
        PQ3JzhnxDc6eFzrIpgSK4K0=
X-Google-Smtp-Source: APXvYqz59p5J+wJOEJOLpGeB4wIJfEe9IM9k8rTohNejmSeefpox5Hm1VCMzuUD+KYDflhtOTh7liQ==
X-Received: by 2002:a17:902:8ec4:: with SMTP id x4mr93239772plo.234.1578348470494;
        Mon, 06 Jan 2020 14:07:50 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::1:2bf6])
        by smtp.gmail.com with ESMTPSA id n1sm79713492pfd.47.2020.01.06.14.07.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 14:07:49 -0800 (PST)
Date:   Mon, 6 Jan 2020 14:07:48 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Roman Gushchin <guro@fb.com>
Cc:     "tj@kernel.org" <tj@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf: cgroup: prevent out-of-order release of cgroup
 bpf
Message-ID: <20200106220746.fm3hp3zynaiaqgly@ast-mbp>
References: <20191227215034.3169624-1-guro@fb.com>
 <20200104003523.rfte5rw6hbnncjes@ast-mbp>
 <20200104011318.GA11376@localhost.localdomain>
 <20200104023112.6edfdvsff6cgsstn@ast-mbp>
 <20200104030041.GA12685@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200104030041.GA12685@localhost.localdomain>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 04, 2020 at 03:00:46AM +0000, Roman Gushchin wrote:
> On Fri, Jan 03, 2020 at 06:31:14PM -0800, Alexei Starovoitov wrote:
> > On Sat, Jan 04, 2020 at 01:13:24AM +0000, Roman Gushchin wrote:
> > > On Fri, Jan 03, 2020 at 04:35:25PM -0800, Alexei Starovoitov wrote:
> > > > On Fri, Dec 27, 2019 at 01:50:34PM -0800, Roman Gushchin wrote:
> > > > > Before commit 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf
> > > > > from cgroup itself") cgroup bpf structures were released with
> > > > > corresponding cgroup structures. It guaranteed the hierarchical order
> > > > > of destruction: children were always first. It preserved attached
> > > > > programs from being released before their propagated copies.
> > > > > 
> > > > > But with cgroup auto-detachment there are no such guarantees anymore:
> > > > > cgroup bpf is released as soon as the cgroup is offline and there are
> > > > > no live associated sockets. It means that an attached program can be
> > > > > detached and released, while its propagated copy is still living
> > > > > in the cgroup subtree. This will obviously lead to an use-after-free
> > > > > bug.
> > > > ...
> > > > > @@ -65,6 +65,9 @@ static void cgroup_bpf_release(struct work_struct *work)
> > > > >  
> > > > >  	mutex_unlock(&cgroup_mutex);
> > > > >  
> > > > > +	for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
> > > > > +		cgroup_bpf_put(p);
> > > > > +
> > > > 
> > > > The fix makes sense, but is it really safe to walk cgroup hierarchy
> > > > without holding cgroup_mutex?
> > > 
> > > It is, because we're holding a reference to the original cgroup and going
> > > towards the root. On each level the cgroup is protected by a reference
> > > from their child cgroup.
> > 
> > cgroup_bpf_put(p) can make bpf.refcnt zero which may call cgroup_bpf_release()
> > on another cpu which will do cgroup_put() and this cpu p = cgroup_parent(p)
> > would be use-after-free?
> > May be not due to the way work_queues are implemented.
> > But it feels dangerous to have such delicate release logic.
> 
> If I understand your concern correctly: you assume that parent's
> cgroup_bpf_release() can be finished prior to the child's one and
> the final cgroup_put() will release the parent?
> 
> If so, it's not possible, because the child hold a reference to the
> parent (independent to all cgroup bpf stuff), which exists at least
> until the final cgroup_put() in cgroup_bpf_release(). Please, look
> at css_free_rwork_fn() for details.
> 
> > Why not to move the loop under the mutex and make things obvious?
> 
> Traversing the cgroup tree to the root cgroup without additional
> locking seems pretty common to me. You can find a ton of examples in
> mm/memcontrol.c. So it doesn't look scary or adventurous to me.
> 
> I think it doesn't matter that much here, so I'm ok with putting it
> under the mutex, but IMO it won't make the code any safer.
> 
> 
> cc Tejun for the second opinion on cgroup locking

Checked with TJ offline. This seems fine.

I tweaked commit log:
- extra 'diff' lines were confusing 'git am'
- commit description shouldn't be split into multiline

And applied to bpf tree. Thanks
