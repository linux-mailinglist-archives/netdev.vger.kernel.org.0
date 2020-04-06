Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C365F19EFDD
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 06:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgDFE10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 00:27:26 -0400
Received: from mout02.posteo.de ([185.67.36.66]:59357 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgDFE1Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 00:27:25 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 60EF52400FF
        for <netdev@vger.kernel.org>; Mon,  6 Apr 2020 06:27:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1586147242; bh=70a++uSvv2qdkM5jAGcOFLiP/g5Cl2dfP85Qllm6F34=;
        h=Date:From:To:Cc:Subject:From;
        b=cjwiK+WItkR04byOQUNyd7wqZowBinT5qssQZXriTReqtQEsBM7hsP7gJGWIAm8kQ
         vngdpkbEcPaIoX6gF2fpkNd1Esm1SuvTRspv5xY1h/8e7hEcya9JGbYA5Mzi6Tw4+H
         iHvobzW/lzwrcJArEWIipG8Yb+7ohdlyrmrDw84lUNwIetkR4KEnRKzkD/wnBcnWow
         EPJIKbgy/f1O7ueEa7UxPM2ZPHIJVNdNTd009GYOGuXwnD8jYA8C4/8tak3aphDOEW
         7DpKMkJbZEVj+5yxHSRvJNihbzMPa6BpmfUP4DbK8cqPWrjvcS7jJYgGEhsO9d2mM9
         kX/DN7XJ+JKrg==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 48wcvN4HXhz9rxN;
        Mon,  6 Apr 2020 06:27:12 +0200 (CEST)
Date:   Mon, 6 Apr 2020 00:27:09 -0400
From:   Kevyn-Alexandre =?utf-8?B?UGFyw6k=?= <kapare@posteo.net>
To:     Alex Belits <abelits@marvell.com>
Cc:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>
Subject: Re: [PATCH v2 10/12] task_isolation: ringbuffer: don't interrupt
 CPUs running isolated tasks on buffer resize
Message-ID: <20200406042709.e4isjrvrrwsusjc4@x1>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
 <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
 <5add46d3bfbdac3fb42dcef6b6e4ea0e39abe11f.camel@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5add46d3bfbdac3fb42dcef6b6e4ea0e39abe11f.camel@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 08, 2020 at 03:55:24AM +0000, Alex Belits wrote:
> From: Yuri Norov <ynorov@marvell.com>
> 
> CPUs running isolated tasks are in userspace, so they don't have to
> perform ring buffer updates immediately. If ring_buffer_resize()
> schedules the update on those CPUs, isolation is broken. To prevent
> that, updates for CPUs running isolated tasks are performed locally,
> like for offline CPUs.
> 
> A race condition between this update and isolation breaking is avoided
> at the cost of disabling per_cpu buffer writing for the time of update
> when it coincides with isolation breaking.
> 
> Signed-off-by: Yuri Norov <ynorov@marvell.com>
> [abelits@marvell.com: updated to prevent race with isolation breaking]
> Signed-off-by: Alex Belits <abelits@marvell.com>
> ---
>  kernel/trace/ring_buffer.c | 62 ++++++++++++++++++++++++++++++++++----
>  1 file changed, 56 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 61f0e92ace99..593effe40183 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -21,6 +21,7 @@
>  #include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <linux/init.h>
> +#include <linux/isolation.h>
>  #include <linux/hash.h>
>  #include <linux/list.h>
>  #include <linux/cpu.h>
> @@ -1701,6 +1702,37 @@ static void update_pages_handler(struct work_struct *work)
>  	complete(&cpu_buffer->update_done);
>  }
>  
> +static bool update_if_isolated(struct ring_buffer_per_cpu *cpu_buffer,
> +			       int cpu)
> +{
> +	bool rv = false;
> +
> +	if (task_isolation_on_cpu(cpu)) {
> +		/*
> +		 * CPU is running isolated task. Since it may lose
> +		 * isolation and re-enter kernel simultaneously with
> +		 * this update, disable recording until it's done.
> +		 */
> +		atomic_inc(&cpu_buffer->record_disabled);
> +		/* Make sure, update is done, and isolation state is current */
> +		smp_mb();
> +		if (task_isolation_on_cpu(cpu)) {
> +			/*
> +			 * If CPU is still running isolated task, we
> +			 * can be sure that breaking isolation will
> +			 * happen while recording is disabled, and CPU
> +			 * will not touch this buffer until the update
> +			 * is done.
> +			 */
> +			rb_update_pages(cpu_buffer);
> +			cpu_buffer->nr_pages_to_update = 0;
> +			rv = true;
> +		}
> +		atomic_dec(&cpu_buffer->record_disabled);
> +	}
> +	return rv;
> +}
> +
>  /**
>   * ring_buffer_resize - resize the ring buffer
>   * @buffer: the buffer to resize.
> @@ -1784,13 +1816,22 @@ int ring_buffer_resize(struct trace_buffer *buffer, unsigned long size,
>  			if (!cpu_buffer->nr_pages_to_update)
>  				continue;
>  
> -			/* Can't run something on an offline CPU. */
> +			/*
> +			 * Can't run something on an offline CPU.
> +			 *
> +			 * CPUs running isolated tasks don't have to
> +			 * update ring buffers until they exit
> +			 * isolation because they are in
> +			 * userspace. Use the procedure that prevents
> +			 * race condition with isolation breaking.
> +			 */
>  			if (!cpu_online(cpu)) {
>  				rb_update_pages(cpu_buffer);
>  				cpu_buffer->nr_pages_to_update = 0;
>  			} else {
> -				schedule_work_on(cpu,
> -						&cpu_buffer->update_pages_work);
> +				if (!update_if_isolated(cpu_buffer, cpu))
> +					schedule_work_on(cpu,
> +					&cpu_buffer->update_pages_work);
>  			}
>  		}
>  
> @@ -1829,13 +1870,22 @@ int ring_buffer_resize(struct trace_buffer *buffer, unsigned long size,
>  
>  		get_online_cpus();
>  
> -		/* Can't run something on an offline CPU. */
> +		/*
> +		 * Can't run something on an offline CPU.
> +		 *
> +		 * CPUs running isolated tasks don't have to update
> +		 * ring buffers until they exit isolation because they
> +		 * are in userspace. Use the procedure that prevents
> +		 * race condition with isolation breaking.
> +		 */
>  		if (!cpu_online(cpu_id))
>  			rb_update_pages(cpu_buffer);
>  		else {
> -			schedule_work_on(cpu_id,
> +			if (!update_if_isolated(cpu_buffer, cpu_id))
> +				schedule_work_on(cpu_id,
>  					 &cpu_buffer->update_pages_work);
> -			wait_for_completion(&cpu_buffer->update_done);
> +				wait_for_completion(&cpu_buffer->update_done);
> +			}
>  		}
>  
>  		cpu_buffer->nr_pages_to_update = 0;

gcc output:

kernel/trace/ring_buffer.c: In function 'ring_buffer_resize':
kernel/trace/ring_buffer.c:1884:4: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
    if (!update_if_isolated(cpu_buffer, cpu_id))
    ^~
kernel/trace/ring_buffer.c:1887:5: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
     wait_for_completion(&cpu_buffer->update_done);
     ^~~~~~~~~~~~~~~~~~~
kernel/trace/ring_buffer.c:1858:4: error: label 'out' used but not defined
    goto out;
    ^~~~
kernel/trace/ring_buffer.c:1868:4: error: label 'out_err' used but not defined
    goto out_err;
    ^~~~

My fix:

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 593effe40183..8b458400ac31 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1881,9 +1881,8 @@ int ring_buffer_resize(struct trace_buffer *buffer, unsigned long size,
                if (!cpu_online(cpu_id))
                        rb_update_pages(cpu_buffer);
                else {
-                       if (!update_if_isolated(cpu_buffer, cpu_id))
-                               schedule_work_on(cpu_id,
-                                        &cpu_buffer->update_pages_work);
+                       if (!update_if_isolated(cpu_buffer, cpu_id)) {
+                               schedule_work_on(cpu_id, &cpu_buffer->update_pages_work);
                                wait_for_completion(&cpu_buffer->update_done);
                        }
                }


thx,

-- Kevyn-Alexandre Paré 
