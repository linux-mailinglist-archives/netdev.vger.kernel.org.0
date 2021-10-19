Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06DD433D11
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 19:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhJSRMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 13:12:43 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36142 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhJSRMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 13:12:42 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 65A2E21A76;
        Tue, 19 Oct 2021 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634663428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1eyKSX2/7swyCKXn7z9fVjzybvXll+tbtLpZFqDx1m8=;
        b=RVz/tL02sPQdjtNeumX2ZM+VtIFyIcTOEASFvv6I0/FVlHvZ4o9I/0RJ7QO2xcZDmai6xU
        4h/KSMw/yrIULI7jwk8EkRvwcpYQFzka8UE4eirJd7G1eClI5pV5rYNy+uIttiWykEFB+n
        aMD35+up03LH+YwZPGz6j/iIN4qa1fE=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F310A13E8E;
        Tue, 19 Oct 2021 17:10:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YBKFOQP8bmGfIgAAMHmgww
        (envelope-from <mkoutny@suse.com>); Tue, 19 Oct 2021 17:10:27 +0000
Date:   Tue, 19 Oct 2021 19:10:26 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Quanyang Wang <quanyang.wang@windriver.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Roman Gushchin <guro@fb.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
Message-ID: <YW78AohHqgqM9Cuw@blackbook>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590>
 <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
 <YW1vuXh4C4tX9ZHP@T590>
 <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi.

On Tue, Oct 19, 2021 at 06:41:14PM +0800, Quanyang Wang <quanyang.wang@windriver.com> wrote:
> So I add 2 "Fixes tags" here to indicate that 2 commits introduce two
> different issues.

AFAIU, both the changes are needed to cause the leak, a single patch
alone won't cause the issue. Is that correct? (Perhaps not as I realize,
see below.)

But on second thought, the problem is the missing percpu_ref_exit() in
the (root) cgroup release path and percpu counter would allocate the
percpu_count_ptr anyway, so 4bfc0bb2c60e is only making the leak more
visible. Is this correct?

I agree the commit 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of
percpu_ref in fast path") alone did nothing wrong.

[On a related (but independent) note, there seems to be an optimization
opportunity in not dealing with cgroup_bpf at all on the non-default
hierarchies.]

Regards,
Michal
