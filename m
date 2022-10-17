Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10485601120
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 16:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiJQOaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 10:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiJQOaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 10:30:13 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82DD4B98D;
        Mon, 17 Oct 2022 07:30:10 -0700 (PDT)
Received: from fsav119.sakura.ne.jp (fsav119.sakura.ne.jp [27.133.134.246])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 29HET4N6008933;
        Mon, 17 Oct 2022 23:29:04 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav119.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav119.sakura.ne.jp);
 Mon, 17 Oct 2022 23:29:04 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav119.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 29HET4ge008929
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 17 Oct 2022 23:29:04 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <4a3a6527-4a19-699a-d7a5-21249254522b@I-love.SAKURA.ne.jp>
Date:   Mon, 17 Oct 2022 23:29:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [syzbot] general protection fault in security_inode_getattr
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org
Cc:     dvyukov@google.com, hdanton@sina.com,
        linux-fsdevel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+f07cc9be8d1d226947ed@syzkaller.appspotmail.com>,
        yhs@fb.com, omosnace@redhat.com
References: <0000000000008caae305ab9a5318@google.com>
 <000000000000618a8205eb160404@google.com>
 <CAHC9VhRt2vpArZ=bOrkBOGiAuoTdEcp2PRP5NtbyEZkuMHvopA@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CAHC9VhRt2vpArZ=bOrkBOGiAuoTdEcp2PRP5NtbyEZkuMHvopA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/10/16 23:52, Paul Moore wrote:
> It doesn't look like this is a problem with
> security_inode_getattr()/d_backing_inode() as it appears that the
> passed path struct pointer has a bogus/NULL path->dentry pointer and
> to the best of my knowledge it would appear that vfs_getattr() (the
> caller) requires a valid path->dentry value.
> 
> Looking quickly at the code, I wonder if there is something wonky
> going on in the overlayfs code, specifically ovl_copy_up_flags() and
> ovl_copy_up_one() as they have to play a number of tricks to handle
> the transparent overlays and copy up operations.  I'm not an overlayfs
> expert, but that seems like a good place to start digging further into
> this.

Right. This is a bug in overlayfs code. Probably due to some race condition,
ovl_copy_up_flags() is calling ovl_copy_up_one() with "next" dentry with
"struct ovl_entry"->numlower == 0. As a result, ovl_path_lower() from
ovl_copy_up_one() fills ctx.lowerpath with NULLs, and vfs_getattr() gets
surprised by ctx.lowerpath.dentry == NULL.

If we can't avoid selecting a dentry with "struct ovl_entry"->numlower == 0 using
some lock, I guess that we would need to use a workaround suggested by Hillf Danton
at https://groups.google.com/g/syzkaller-bugs/c/xDcxFKSppfE/m/b38Tv7LoAAAJ .

