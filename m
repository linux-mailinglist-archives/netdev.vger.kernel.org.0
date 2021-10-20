Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1D7435146
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhJTRa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:30:59 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41318 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhJTRa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 13:30:57 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3CE511F770;
        Wed, 20 Oct 2021 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634750922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6iR1y/JL3F5bSNnhveF9tZ47D84ZakNWdr4w2O9FyR0=;
        b=puC+JrAjKBLfJWIbDTKsG+jqaPcCcX5u7U5/ZJPdJv9ua4KfXtLpGNpcZ6nDxuFX4QPk29
        tH5H30S6wh9+68I/f9eYApstnc7SF0fwjjwxQUWfmJo/sr8fbVEoANJKKaYLy1XOrjurZr
        3bFQZWUJbGW4YVvD6mjDX9KxSO3oXew=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D480113BBD;
        Wed, 20 Oct 2021 17:28:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yleGMslRcGE4awAAMHmgww
        (envelope-from <mkoutny@suse.com>); Wed, 20 Oct 2021 17:28:41 +0000
Date:   Wed, 20 Oct 2021 19:28:40 +0200
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
Message-ID: <YXBRyJMru/RbUQK5@blackbook>
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590>
 <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
 <YW1vuXh4C4tX9ZHP@T590>
 <a84aedfe-6ecf-7f48-505e-a11acfd6204c@windriver.com>
 <YW78AohHqgqM9Cuw@blackbook>
 <YW98RTBdzqin+9Ko@T590>
 <7a21a20d-eb12-e491-4e69-4e043b3b6d8d@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a21a20d-eb12-e491-4e69-4e043b3b6d8d@windriver.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 01:22:06PM +0800, Quanyang Wang <quanyang.wang@windriver.com> wrote:
> > If only precpu_ref data is leaked, it is fine to add "Fixes: 2b0d3d3e4fcf",
> > I thought cgroup_bpf_release() needs to release more for root cgroup, but
> > looks not true.
> For now, I can only observe that precpu_ref data is leaked when running ltp
> testsuite.

I assume you refer to ref->data. I considered the ref->percpu_count_ptr
allocated with __alloc_percpu_gfp(). Could it be that kmemleak won't
detect leaked percpu allocations?

(The patch you sent resolves this as well, I'm just curious.)

Michal
