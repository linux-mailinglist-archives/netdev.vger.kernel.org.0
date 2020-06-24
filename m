Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4945E2069EC
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 04:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388038AbgFXCH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 22:07:26 -0400
Received: from mail.loongson.cn ([114.242.206.163]:53852 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730898AbgFXCHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 22:07:25 -0400
Received: from [10.130.0.66] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxr2tUtfJeAAlJAA--.285S3;
        Wed, 24 Jun 2020 10:07:18 +0800 (CST)
Subject: Re: [PATCH RESEND] net/cisco: Fix a sleep-in-atomic-context bug in
 enic_init_affinity_hint()
To:     Jakub Kicinski <kuba@kernel.org>
References: <1592899989-22049-1-git-send-email-likaige@loongson.cn>
 <20200623135007.3105d067@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
From:   Kaige Li <likaige@loongson.cn>
Message-ID: <f12f40fe-7c9a-6ba8-f2ff-daf315030258@loongson.cn>
Date:   Wed, 24 Jun 2020 10:07:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20200623135007.3105d067@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9Dxr2tUtfJeAAlJAA--.285S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKr4DJw43uF1fWw1DCFWfXwb_yoWDuFXE9r
        4j9F93Cw4UJw43Kw4vyw40qr9a9Fy3X34kC3W29398J34fX34ru3Z8CFy3Jw1rWr47Ar1Y
        yF12ga4rA342gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
        1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CE
        bIxvr21lc2xSY4AK67AK6r4UMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VU1sYFtUUUUU==
X-CM-SenderInfo: 5olntxtjh6z05rqj20fqof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/24/2020 04:50 AM, Jakub Kicinski wrote:
> On Tue, 23 Jun 2020 16:13:09 +0800 Kaige Li wrote:
>> The kernel module may sleep with holding a spinlock.
>>
>> The function call paths (from bottom to top) are:
>>
>> [FUNC] zalloc_cpumask_var(GFP_KERNEL)
>> drivers/net/ethernet/cisco/enic/enic_main.c, 125: zalloc_cpumask_var in enic_init_affinity_hint
>> drivers/net/ethernet/cisco/enic/enic_main.c, 1918: enic_init_affinity_hint in enic_open
>> drivers/net/ethernet/cisco/enic/enic_main.c, 2348: enic_open in enic_reset
>> drivers/net/ethernet/cisco/enic/enic_main.c, 2341: spin_lock in enic_reset
>>
>> To fix this bug, GFP_KERNEL is replaced with GFP_ATOMIC.
>>
>> Signed-off-by: Kaige Li <likaige@loongson.cn>
> I don't think this is sufficient. Calling open with a spin lock held
> seems like a very bad idea. At a quick look the driver also calls
> request_irq() from open - request_irq() can sleep.

You are right. Should I do spin_unlock before the enic_open, or remove
spin_lock in enic_reset?

Thank you.

