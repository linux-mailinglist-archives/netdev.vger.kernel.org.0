Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B9636F991
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 13:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhD3Lsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 07:48:55 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50132 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhD3Lsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 07:48:55 -0400
Received: from fsav303.sakura.ne.jp (fsav303.sakura.ne.jp [153.120.85.134])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 13UBm58U016239;
        Fri, 30 Apr 2021 20:48:05 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav303.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav303.sakura.ne.jp);
 Fri, 30 Apr 2021 20:48:05 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav303.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 13UBm4Lq016232
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 30 Apr 2021 20:48:05 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH] rtnetlink: add rtnl_lock debug log
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     Peter Enderborg <peter.enderborg@sony.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Vitor Massaru Iha <vitor@massaru.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Di Zhu <zhudi21@huawei.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upsream@mediatek.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        peterz@infradead.org
References: <20210429070237.3012-1-rocco.yue@mediatek.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <27fa19c9-81b2-3604-033c-b7fe5d14b620@i-love.sakura.ne.jp>
Date:   Fri, 30 Apr 2021 20:48:02 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210429070237.3012-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/04/29 16:02, Rocco Yue wrote:
> +static void rtnl_print_btrace(struct timer_list *unused)
> +{
> +	pr_info("----------- %s start -----------\n", __func__);
> +	pr_info("%s[%d][%c] hold rtnl_lock more than 2 sec, start time: %llu\n",
> +		rtnl_instance.task->comm,
> +		rtnl_instance.pid,
> +		task_state_to_char(rtnl_instance.task),
> +		rtnl_instance.start_time);
> +	stack_trace_print(rtnl_instance.addrs, rtnl_instance.nr_entries, 0);

Do we want to print same traces every 2 seconds? 

Since it is possible to stall for e.g. 30 seconds, printing either only upon
first call to rtnl_print_btrace() for each stalling duration or only upon
end of stalling duration (i.e. from rtnl_relase_btrace()) is better?

> +	show_stack(rtnl_instance.task, NULL, KERN_DEBUG);

Why KERN_DEBUG ?

If you retrieve the output via dmesg, KERN_DEBUG would be fine.
But for syzkaller (which counts on printk() messages being printed to
consoles), KERN_INFO (or default) is expected.

> +	pr_info("------------ %s end -----------\n", __func__);
> +}
> +
> +static void rtnl_relase_btrace(void)
> +{
> +	rtnl_instance.end_time = sched_clock();
> +

You should del_timer_sync() here than

> +	if (rtnl_instance.end_time - rtnl_instance.start_time > 2000000000ULL) {
> +		pr_info("rtnl_lock is held by [%d] from [%llu] to [%llu]\n",
> +			rtnl_instance.pid,
> +			rtnl_instance.start_time,
> +			rtnl_instance.end_time);
> +	}
> +
> +	del_timer(&rtnl_chk_timer);

here in order to make sure that end message is printed only after
rtnl_print_btrace() messages are printed.

> +}
> +#endif
> +

