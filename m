Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F091DF382
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387451AbgEWA3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:29:01 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51706 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731183AbgEWA3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 20:29:00 -0400
Received: from fsav104.sakura.ne.jp (fsav104.sakura.ne.jp [27.133.134.231])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 04N0Sx3f085256;
        Sat, 23 May 2020 09:28:59 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav104.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav104.sakura.ne.jp);
 Sat, 23 May 2020 09:28:59 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav104.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 04N0SlHv085168
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Sat, 23 May 2020 09:28:59 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH net] tipc: block BH before using dst_cache
To:     Eric Dumazet <edumazet@google.com>, Jon Maloy <jmaloy@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net
References: <20200521182958.163436-1-edumazet@google.com>
 <CADvbK_cdSYZvTj6jFCXHEU0VhD8K7aQ3ky_fvUJ49N-5+ykJkg@mail.gmail.com>
 <CANn89i+x=xbXoKekC6bF_ZMBRMY_mkmuVbNSW3LcRncsiZGd_g@mail.gmail.com>
 <CANn89iJVSb3BWO=VGRX0KkvrxZ7=ZYaK6HwsexK8y+4NJqXopA@mail.gmail.com>
 <CADvbK_eJx=PyH8MDCWQJMRW-p+nv9QtuQGG2TtYX=9n9oY7rJg@mail.gmail.com>
 <76d02a44-91dd-ded6-c3dc-f86685ae1436@redhat.com>
 <217375c0-d49d-63b1-0628-9aaf7e4e42d0@gmail.com>
 <bebc5293-d5be-39b5-8ee4-871dd3aa7240@redhat.com>
 <2084be57-be94-6630-5623-2bd7bd7b7da2@gmail.com>
 <400644e2-7dac-103c-a07a-88287b1905d5@redhat.com>
 <CANn89iL+gT7PSwuWhhWf8o7f1SgbqJ5+mdJ_bfBxOMbzjo_oMA@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <600a753d-6cf1-4d02-d6f4-ff8e68a42d58@i-love.sakura.ne.jp>
Date:   Sat, 23 May 2020 09:28:43 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CANn89iL+gT7PSwuWhhWf8o7f1SgbqJ5+mdJ_bfBxOMbzjo_oMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 2:30 AM Eric Dumazet <edumazet@google.com> wrote:
> dst_cache_get() documents it must be used with BH disabled.

Since the report was complaining about preemption at this_cpu_ptr(), and "#syz test"
request with my preemption-disable patch no longer complained, I didn't realize that
it is documented in dst_cache.h that dst_cache_get() must be called with BH disabled.
It is bug-prone that we don't have a check for complaining that BH is not disabled.
