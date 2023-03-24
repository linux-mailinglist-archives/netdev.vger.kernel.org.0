Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D4A6C78CC
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 08:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbjCXH1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 03:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjCXH04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 03:26:56 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FF8E188;
        Fri, 24 Mar 2023 00:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=+R2EEWNBVNSx6himSgCrBinYUox/jg6m2XRma6qQqh8=; b=GUeFr6cWMlom5ypuD40BsCuz/H
        1NxWCEoVOAFqAvFeZnJs8cw3DrQ2Qp1nJn3qjzUHa4p3RyqiPS0ezsqtSTmizm8jaSwWBG0tNapMd
        yh928cuyT+ho/lJErYwZKaxOrgVAVScmm/n4B3BH0mQJk145sSdftwt55fxctWmhFxpKL7YCxfVTd
        mBjQ5eB9yBrDn6TNS1OuzMK0/LlhGkgjiLkBu7bdOQV/1slPTsNj6+7nmJjp49aeu3LHuK/1R2xW8
        V1Ue4d+IvlTFktlnr6+g+VTUsjkoHg1HikAfRhgZ45560CuxLyu9Yzit7MCMY6EqtF9sqicYz1Ljj
        KvWsCmWQ==;
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pfbot-000Bfu-3O; Fri, 24 Mar 2023 08:26:39 +0100
Received: from [77.58.94.13] (helo=localhost.localdomain)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pfbos-0006oR-Fw; Fri, 24 Mar 2023 08:26:38 +0100
Subject: Re: [syzbot] [bpf?] [net?] general protection fault in
 bpf_struct_ops_link_create
To:     syzbot <syzbot+71ccc0fe37abb458406b@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        haoluo@google.com, john.fastabend@gmail.com, jolsa@kernel.org,
        kpsingh@kernel.org, kuifeng@meta.com, linux-kernel@vger.kernel.org,
        martin.lau@kernel.org, martin.lau@linux.dev,
        netdev@vger.kernel.org, sdf@google.com, song@kernel.org,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <00000000000091ae5305f79f447f@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c1b903c0-7089-cefb-dbd3-5dbe1b941a5f@iogearbox.net>
Date:   Fri, 24 Mar 2023 08:26:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <00000000000091ae5305f79f447f@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26852/Thu Mar 23 08:22:35 2023)
X-Spam-Status: No, score=2.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 7:11 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    226bc6ae6405 Merge branch 'Transit between BPF TCP congest..
> git tree:       bpf-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=139c727ac80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cab35c936731a347
> dashboard link: https://syzkaller.appspot.com/bug?extid=71ccc0fe37abb458406b
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ef67a1c80000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=119c20fec80000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ac055f681ed7/disk-226bc6ae.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/3895cc8a51d2/vmlinux-226bc6ae.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/1b18bb9fae05/bzImage-226bc6ae.xz
> 
> The issue was bisected to:
> 
> commit 68b04864ca425d1894c96b8141d4fba1181f11cb
> Author: Kui-Feng Lee <kuifeng@meta.com>
> Date:   Thu Mar 23 03:24:00 2023 +0000
> 
>      bpf: Create links for BPF struct_ops maps.
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=116731b1c80000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=136731b1c80000
> console output: https://syzkaller.appspot.com/x/log.txt?x=156731b1c80000

Kui-Feng, please take a look & fix.

> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+71ccc0fe37abb458406b@syzkaller.appspotmail.com
> Fixes: 68b04864ca42 ("bpf: Create links for BPF struct_ops maps.")

Thanks,
Daniel
