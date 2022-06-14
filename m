Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCCF554BB01
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 21:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbiFNT6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 15:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbiFNT6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 15:58:52 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B4F4AE0D;
        Tue, 14 Jun 2022 12:58:50 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o1CgU-0009CI-6z; Tue, 14 Jun 2022 21:58:42 +0200
Received: from [85.1.206.226] (helo=linux-3.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1o1CgT-000JO7-On; Tue, 14 Jun 2022 21:58:41 +0200
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 sk_psock_stop
To:     wangyufen <wangyufen@huawei.com>,
        syzbot <syzbot+140186ceba0c496183bc@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, jakub@cloudflare.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <0000000000002d6bc305e118ae24@google.com>
 <c9adfe67-9424-2d58-7b3e-c457ac604ef0@iogearbox.net>
 <05a652f3-35a5-9bc6-e04d-bd03fc67a9af@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <84bbbd44-9b91-c41e-9394-e6758e684406@iogearbox.net>
Date:   Tue, 14 Jun 2022 21:58:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <05a652f3-35a5-9bc6-e04d-bd03fc67a9af@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26572/Tue Jun 14 10:17:51 2022)
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/22 12:52 PM, wangyufen wrote:
> 在 2022/6/10 22:35, Daniel Borkmann 写道:
>> On 6/10/22 4:23 PM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    ff539ac73ea5 Add linux-next specific files for 20220609
>>> git tree:       linux-next
>>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=176c121bf00000
>>> kernel config: https://syzkaller.appspot.com/x/.config?x=a5002042f00a8bce
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=140186ceba0c496183bc
>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>> syz repro: https://syzkaller.appspot.com/x/repro.syz?x=13083353f00000
>>> C reproducer: https://syzkaller.appspot.com/x/repro.c?x=173e67f0080000
>>>
>>> The issue was bisected to:
>>>
>>> commit d8616ee2affcff37c5d315310da557a694a3303d
>>> Author: Wang Yufen <wangyufen@huawei.com>
>>> Date:   Tue May 24 07:53:11 2022 +0000
>>>
>>>      bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues
>>
>> Same ping to Wang: Please take a look, otherwise we might need to revert if it stays unfixed.
> 
> Thanks for Hillf's fix : https://groups.google.com/g/syzkaller-bugs/c/zunoClAqFQo/m/6SP7LIQoCQAJ
> 
> and sorry for the delay.

Please send this as a proper fix then, so it lands in patchwork and can be applied.

Thanks,
Daniel
