Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 296D22C036
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 09:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfE1HjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 03:39:01 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57929 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbfE1HjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 03:39:00 -0400
Received: from fsav102.sakura.ne.jp (fsav102.sakura.ne.jp [27.133.134.229])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x4S7cwc5064960;
        Tue, 28 May 2019 16:38:58 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav102.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav102.sakura.ne.jp);
 Tue, 28 May 2019 16:38:58 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav102.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126012062002.bbtec.net [126.12.62.2])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x4S7crXl064921
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Tue, 28 May 2019 16:38:58 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: KASAN: invalid-free in tomoyo_realpath_from_path
To:     syzbot <syzbot+9742b1c6c7aedf18beda@syzkaller.appspotmail.com>
References: <000000000000785e9d0589ec359a@google.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        serge@hallyn.com, syzkaller-bugs@googlegroups.com,
        takedakn@nttdata.co.jp
Message-ID: <fb152725-1694-3412-9757-902f550f07f1@i-love.sakura.ne.jp>
Date:   Tue, 28 May 2019 16:38:50 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <000000000000785e9d0589ec359a@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Well, I don't think this is a TOMOYO's problem.

On 2019/05/28 14:48, syzbot wrote:
> CPU: 1 PID: 11697 Comm: syz-executor.3 Not tainted 5.2.0-rc1+ #2
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
(...snipped...)
>  kfree+0xcf/0x220 mm/slab.c:3755
>  tomoyo_realpath_from_path+0x1de/0x7a0 security/tomoyo/realpath.c:319
(...snipped...)
> Allocated by task 11696:
(...snipped...)
>  kmalloc include/linux/slab.h:552 [inline]
>  tomoyo_realpath_from_path+0xcd/0x7a0 security/tomoyo/realpath.c:277
(...snipped...)
> 
> Freed by task 11696:
(...snipped...)
>  kfree+0xcf/0x220 mm/slab.c:3755
>  tomoyo_realpath_from_path+0x1de/0x7a0 security/tomoyo/realpath.c:319

Since the "buf" variable is a local variable, it cannot be shared between
two threads. Since "buf" is assigned as

  buf = kmalloc(buf_len, GFP_NOFS);

and nobody else is reassigning "buf",

  kfree(buf);

can't become an invalid free.

Let's wait for a reproducer...

