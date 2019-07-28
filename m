Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01A1278086
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 18:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfG1QvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 12:51:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40293 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfG1QvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 12:51:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so59262666wrl.7
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 09:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5K+SuxpGvXfQ///N9XK1+tF5GqeC/HVgCK0aC6WVZtU=;
        b=OfC8vdkx64xyhbGpo8KCxYo+Lm9vikgIF+jEkc9Nv6Yxn4gP0DjP/kIQg51vfl7xGC
         jV8WoJ2HAmWTP3kg4XrVF4jk+AGlMOm8gSNklsPETgCIJkZwo7ReZmIX238PnP9Qyin9
         yd0vAmYMJBw9QIB5VddDz14pj4cZtz7R9nCvg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5K+SuxpGvXfQ///N9XK1+tF5GqeC/HVgCK0aC6WVZtU=;
        b=UC/wQrLYxdc/xoNlV1fdoZcDNN+JSAyd9khrXg3qjiYBQYKDCgCPhUAtNGMRukmYWR
         Y1rMEZ13481LSr9XGEtgjg7nOM72n4tOca8Hi90iHnf2YgAEq1aZ2S8GSe9CwzIWWhPS
         +zU33pSSqiG6yO/snAxEg+c2TFAiZplT8bvhPVvYkSIY8vkZBv48KpmvnHymZ8RR/x8E
         8oZg4K4ZFgWtNMi3uvukpyjF0d1uP59qig0+9/EBshVbgdr/79p9s9w1uytrRNjTTjH0
         2O5AbkovHK73vlAAUzl3JY+fAwH42Vq49J7MLOea0gHvupifb01skKbZr9RlX5mLoAUt
         cu/g==
X-Gm-Message-State: APjAAAX2i/3HvmpL/VnxTUNUN0U2wT+1w0poms15/gUVxeNk6xHEw9aa
        7T6ZgseHfijgR4rKWXA4vaSg4A==
X-Google-Smtp-Source: APXvYqw83tJg77hrak37KuOXdaRIdcSuKl5v2EFRFUxMzT6hdmsmAZ/ogHbPEp7hpFDY2TYo5CjGUQ==
X-Received: by 2002:adf:ea87:: with SMTP id s7mr116716538wrm.24.1564332666403;
        Sun, 28 Jul 2019 09:51:06 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i12sm69356215wrx.61.2019.07.28.09.51.04
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 09:51:05 -0700 (PDT)
Subject: Re: memory leak in fdb_create
To:     syzbot <syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com>,
        bridge@lists.linux-foundation.org, bsingharora@gmail.com,
        coreteam@netfilter.org, davem@davemloft.net, duwe@suse.de,
        kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, mingo@redhat.com, mpe@ellerman.id.au,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, roopa@cumulusnetworks.com,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com
References: <0000000000008be1b2058ebe7805@google.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <d16a3297-d651-0a32-e803-774a9c8c61bf@cumulusnetworks.com>
Date:   Sun, 28 Jul 2019 19:51:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0000000000008be1b2058ebe7805@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/07/2019 17:20, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 04cf31a759ef575f750a63777cee95500e410994
> Author: Michael Ellerman <mpe@ellerman.id.au>
> Date:   Thu Mar 24 11:04:01 2016 +0000
> 
>     ftrace: Make ftrace_location_range() global
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1538c778600000
> start commit:   abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1738c778600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1338c778600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=56f1da14935c3cce
> dashboard link: https://syzkaller.appspot.com/bug?extid=88533dc8b582309bf3ee
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16de5c06a00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10546026a00000
> 
> Reported-by: syzbot+88533dc8b582309bf3ee@syzkaller.appspotmail.com
> Fixes: 04cf31a759ef ("ftrace: Make ftrace_location_range() global")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

I see the problem, it'd happen if the multicast stats memory allocation fails on bridge
init then the fdb added due to the default vlan would remain and the bridge kmem cache
would be destroyed while not empty (you can even trigger a BUG because of that).
I'll post a patch shortly after running a few tests.

Thanks,
 Nik

