Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE114F2F40
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 14:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240511AbiDEJed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 05:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345737AbiDEJW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 05:22:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E63C6EB3C;
        Tue,  5 Apr 2022 02:12:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 494E8210F4;
        Tue,  5 Apr 2022 09:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649149920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mVhpyElouVHiShzfKiMDpwTUsMQzwG3WoSbwcyg24Hk=;
        b=o2qv6btz8dqtGvXVklb2rUqFn4/SpHgk1qtD2cB+/Na3YKuaNPlK0xJA+XEQs3GqIfrsWJ
        i5L+/jIZaEkmbNq7j3ojQvfVjcdznGe3XGW3hPoaj5Cvjj6e/6zVr9wJq6IhUPdXrtTXij
        3F5YLiidr96TCatmJROASTwlYMUqf9U=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 029C0132B7;
        Tue,  5 Apr 2022 09:11:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xLx0O98HTGJgKwAAMHmgww
        (envelope-from <mkoutny@suse.com>); Tue, 05 Apr 2022 09:11:59 +0000
Date:   Tue, 5 Apr 2022 11:11:58 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Tejun Heo <tj@kernel.org>
Cc:     Bui Quang Minh <minhquangbui99@gmail.com>, cgroups@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] cgroup: Kill the parent controller when its last
 child is killed
Message-ID: <20220405091158.GA13806@blackbody.suse.cz>
References: <20220404142535.145975-1-minhquangbui99@gmail.com>
 <Ykss1N/VYX7femqw@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ykss1N/VYX7femqw@slm.duckdns.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 04, 2022 at 07:37:24AM -1000, Tejun Heo <tj@kernel.org> wrote:
> And the suggested behavior doesn't make much sense to me. It doesn't
> actually solve the underlying problem but instead always make css
> destructions recursive which can lead to surprises for normal use cases.

I also don't like the nested special-case use percpu_ref_kill().

I looked at this and my supposed solution turned out to be a revert of
commit 3c606d35fe97 ("cgroup: prevent mount hang due to memory
controller lifetime"). So at the unmount time it's necessary to distinguish
children that are in the process of removal from children than are online or
pinned indefinitely.

What about:

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2205,11 +2205,14 @@ static void cgroup_kill_sb(struct super_block *sb)
        struct cgroup_root *root = cgroup_root_from_kf(kf_root);

        /*
-        * If @root doesn't have any children, start killing it.
+        * If @root doesn't have any children held by residual state (e.g.
+        * memory controller), start killing it, flush workqueue to filter out
+        * transiently offlined children.
         * This prevents new mounts by disabling percpu_ref_tryget_live().
         *
         * And don't kill the default root.
         */
+       flush_workqueue(cgroup_destroy_wq);
        if (list_empty(&root->cgrp.self.children) && root != &cgrp_dfl_root &&
            !percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
                cgroup_bpf_offline(&root->cgrp);

(I suspect there's technically still possible a race between concurrent unmount
and the last rmdir but the flush on kill_sb path should be affordable and it
prevents unnecessarily conserved cgroup roots.)

Michal
