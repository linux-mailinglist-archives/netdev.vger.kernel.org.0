Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8942FD9A3
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 10:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfKOJoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 04:44:30 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:56755 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbfKOJo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 04:44:29 -0500
Received: from fsav102.sakura.ne.jp (fsav102.sakura.ne.jp [27.133.134.229])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id xAF9hluQ013037;
        Fri, 15 Nov 2019 18:43:47 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav102.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav102.sakura.ne.jp);
 Fri, 15 Nov 2019 18:43:47 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav102.sakura.ne.jp)
Received: from [192.168.1.9] (softbank126040052248.bbtec.net [126.40.52.248])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id xAF9hfEU013011
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Fri, 15 Nov 2019 18:43:46 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        ddstreet@ieee.org, Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>
References: <00000000000056268e05737dcb95@google.com>
 <0000000000007d22100573d66078@google.com>
 <063a57ba-7723-6513-043e-ee99c5797271@I-love.SAKURA.ne.jp>
 <CAADnVQJ7BZMVSt9on4updWrWsFWq6b5J1qEGwTdGYV+BLqH7tg@mail.gmail.com>
 <87imopgere.fsf@toke.dk>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <6f69f704-b51d-c3cb-02c6-8e6eb93f4194@i-love.sakura.ne.jp>
Date:   Fri, 15 Nov 2019 18:43:36 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <87imopgere.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

syzbot is still reporting that bpf(BPF_MAP_UPDATE_ELEM) causes
unregister_netdevice() to hang. It seems that commit 546ac1ffb70d25b5
("bpf: add devmap, a map for storing net device references") assigned
dtab->netdev_map[i] at dev_map_update_elem() but commit 6f9d451ab1a33728
("xdp: Add devmap_hash map type for looking up devices by hashed index")
forgot to assign dtab->netdev_map[idx] at __dev_map_hash_update_elem()
when dev is newly allocated by __dev_map_alloc_node(). As far as I and
syzbot tested, https://syzkaller.appspot.com/x/patch.diff?x=140dd206e00000
can avoid the problem, but I don't know whether this is right location to
assign it. Please check and fix.

