Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A81ED190B5C
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgCXKrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 06:47:06 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:45850 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgCXKrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 06:47:05 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02OAki5v093112;
        Tue, 24 Mar 2020 05:46:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1585046804;
        bh=D2ALQtCg+SKfnDlQYR3fcQQukI+ow4R5PvsOSa39z0E=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=hpmbjgLoY8bMHGPi0LXG8dO1pAFHKJNRRZRsF7GbOz9a3z0PC2n89l54fhH5+khmt
         /1K+exq0Q1+0+RHl71GDR5UEuspxqWF8P60yNonQL1UtXxVZXpbMcQjYI6kO/JeT9A
         aA5F0oKzFbQKPy6zVZt126tBepHUgU5JDKgynSio=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02OAkiEp100135
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Mar 2020 05:46:44 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 24
 Mar 2020 05:46:44 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 24 Mar 2020 05:46:44 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02OAkfLj024660;
        Tue, 24 Mar 2020 05:46:42 -0500
Subject: Re: [PATCH] kthread: Mark timer used by delayed kthread works as IRQ
 safe
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Tejun Heo <tj@kernel.org>, Petr Mladek <pmladek@suse.com>
CC:     <linux-rt-users@vger.kernel.org>, <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
References: <20200217120709.1974-1-pmladek@suse.com>
 <20200219152248.GC698990@mtj.thefacebook.com>
 <6a4c07df-8971-8637-5251-ce177c3a08ce@ti.com>
Message-ID: <99c75f39-1f27-ad3c-1605-397b69760d07@ti.com>
Date:   Tue, 24 Mar 2020 12:46:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6a4c07df-8971-8637-5251-ce177c3a08ce@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

On 16/03/2020 14:23, Grygorii Strashko wrote:
> Hi Petr,
> 
> On 19/02/2020 17:22, Tejun Heo wrote:
>> On Mon, Feb 17, 2020 at 01:07:09PM +0100, Petr Mladek wrote:
>>> The timer used by delayed kthread works are IRQ safe because the used
>>> kthread_delayed_work_timer_fn() is IRQ safe.
>>>
>>> It is properly marked when initialized by KTHREAD_DELAYED_WORK_INIT().
>>> But TIMER_IRQSAFE flag is missing when initialized by
>>> kthread_init_delayed_work().
>>>
>>> The missing flag might trigger invalid warning from del_timer_sync()
>>> when kthread_mod_delayed_work() is called with interrupts disabled.
>>>
>>> Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>> Signed-off-by: Petr Mladek <pmladek@suse.com>
>>> Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>
>> Acked-by: Tejun Heo <tj@kernel.org>
> 
> I'm worry shouldn't this patch have "fixes" tag?
> 

Sorry, the I'm disturbing you, but I have dependency from this path [1].
I can see it in -next: commit d7c8c7de96de ("kthread: mark timer used by
delayed kthread works as IRQ safe"), but it does not present in net-next.

Any way this can be resolved?

[1] https://patchwork.ozlabs.org/cover/1259207/
-- 
Best regards,
grygorii
