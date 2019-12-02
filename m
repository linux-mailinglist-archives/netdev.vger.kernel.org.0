Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF9110F172
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 21:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbfLBUUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 15:20:45 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44651 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbfLBUUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 15:20:44 -0500
Received: by mail-lf1-f66.google.com with SMTP id v201so862653lfa.11
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 12:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=A7xwm8gC8IFcmIwrDFz1mUiBMU42HvgoLpPYOdX1CWQ=;
        b=ZOtyJo+O+ea+CUdCTEPU394bFqI2NW2JOOFXR228offjrOPoiKp17JEx7YHrvCwtxL
         ayfcNnftnWN18v0ZWzqlEVSXvl0U0g6v+VfVLIsH1m6m9VNtPL7xBsrJ0HhQ/HWCx51P
         Zlt6UvKJNGWGnBcUfO9q/briMSRbhlOnfg3UU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A7xwm8gC8IFcmIwrDFz1mUiBMU42HvgoLpPYOdX1CWQ=;
        b=Nb5PbQ33GoioZ1k57XTN8vuD34rORk4+in0It2iXqNgtm0f6xGQk6XPWBAHGLK8O+V
         qynrOvln07Qr9s1HJWgmYoLmwn3QUgC2hxxmHepNGN6+j3LwpGsMwKT+safEk7O0+4xh
         xT9VtI7aVHZop17Hsc6v7n1YaL7BLbQlbFbEaeq9kWDGD3XHMsOe5FXY3eq0XHVeqssB
         29W9X4ybpDGeKy7MOz80VFOvPlfvoXJQz2j1FPytAsTBJdvs3SJLRYKtVjynHlsr8w0p
         rpRlONRzcPLTMrX+8QHTIUdo6fv6O0fye2rfU4ScxRMFYpaxR4PXN14gEEEl1a4AeXgK
         Ku+g==
X-Gm-Message-State: APjAAAXWMaTsDumvYL8YYqY/Ssz2nmEYr0CelSd+NtJYV6Rb7NiQRRQO
        nEf4R6Z3Ai6mlsahWK3lMXPC0Q==
X-Google-Smtp-Source: APXvYqzYCEj2kZH16mtMuXRGmli0G8tPPG/NBLbJgg0WFCJMLXzE9JuYVqkrlEByD7jomy4ge/9QiA==
X-Received: by 2002:ac2:5462:: with SMTP id e2mr522201lfn.181.1575318041077;
        Mon, 02 Dec 2019 12:20:41 -0800 (PST)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r4sm272840ljn.64.2019.12.02.12.20.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 12:20:40 -0800 (PST)
Subject: Re: memory leak in fdb_create (2)
To:     syzbot <syzbot+2add91c08eb181fea1bf@syzkaller.appspotmail.com>,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com, syzkaller-bugs@googlegroups.com
References: <0000000000001821bf0598bb955c@google.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <76434004-ca0b-0917-78bd-a0332af2a716@cumulusnetworks.com>
Date:   Mon, 2 Dec 2019 22:20:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <0000000000001821bf0598bb955c@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/12/2019 19:05, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    ceb30747 Merge tag 'y2038-cleanups-5.5' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=142b3e7ee00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=26f873e40f2b4134
> dashboard link: https://syzkaller.appspot.com/bug?extid=2add91c08eb181fea1bf
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12976feee00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10604feee00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+2add91c08eb181fea1bf@syzkaller.appspotmail.com
> 
> BUG: memory leak
> unreferenced object 0xffff888124fa7080 (size 128):
>   comm "syz-executor163", pid 7170, jiffies 4294954254 (age 12.500s)

I'll look into this tomorrow, I think see the issue.

Thanks!
