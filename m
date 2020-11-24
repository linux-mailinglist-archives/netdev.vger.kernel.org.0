Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754E22C2AC0
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389498AbgKXPEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:04:13 -0500
Received: from z5.mailgun.us ([104.130.96.5]:61567 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388176AbgKXPEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 10:04:12 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606230252; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=HbEXkE4/5qcA3cH25AXK1z4uk2ABDyVF5WqikAQO1x4=;
 b=WliYkEObEXo1VZf68x7p90yF+wkee1i2sPxngs2GPqqM16wvWASVJbntykk4xkCbxx/4dalD
 YPcGpUoo3tfsvHtEK8O7pOuxtB7ok99AGxfhwwAxRSOy2ssw3BPmMq7e03QbzqiIExCh8dZB
 dDTBIlcerO9LUmf75tdCbQtvKik=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fbd20eb4146c5eefdf7be91 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 24 Nov 2020 15:04:11
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F3D99C43468; Tue, 24 Nov 2020 15:04:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 42D52C43460;
        Tue, 24 Nov 2020 15:04:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 42D52C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: ampdu: Check BA window size before checking
 block
 ack
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201116030635.645811-1-dima@arista.com>
References: <20201116030635.645811-1-dima@arista.com>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        Dmitry Safonov <dima@arista.com>,
        Yuji Nakao <contact@yujinakao.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201124150410.F3D99C43468@smtp.codeaurora.org>
Date:   Tue, 24 Nov 2020 15:04:10 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Safonov <dima@arista.com> wrote:

> bindex can be out of BA window (64):
>   tid 0 seq 2983, start_seq 2915, bindex 68, index 39
>   tid 0 seq 2984, start_seq 2915, bindex 69, index 40
>   tid 0 seq 2985, start_seq 2915, bindex 70, index 41
>   tid 0 seq 2986, start_seq 2915, bindex 71, index 42
>   tid 0 seq 2879, start_seq 2915, bindex 4060, index 63
>   tid 0 seq 2854, start_seq 2915, bindex 4035, index 38
>   tid 0 seq 2795, start_seq 2915, bindex 3976, index 43
>   tid 0 seq 2989, start_seq 2924, bindex 65, index 45
>   tid 0 seq 2992, start_seq 2924, bindex 68, index 48
>   tid 0 seq 2993, start_seq 2924, bindex 69, index 49
>   tid 0 seq 2994, start_seq 2924, bindex 70, index 50
>   tid 0 seq 2997, start_seq 2924, bindex 73, index 53
>   tid 0 seq 2795, start_seq 2941, bindex 3950, index 43
>   tid 0 seq 2921, start_seq 2941, bindex 4076, index 41
>   tid 0 seq 2929, start_seq 2941, bindex 4084, index 49
>   tid 0 seq 3011, start_seq 2946, bindex 65, index 3
>   tid 0 seq 3012, start_seq 2946, bindex 66, index 4
>   tid 0 seq 3013, start_seq 2946, bindex 67, index 5
> 
> In result isset() will try to dereference something on the stack,
> causing panics:
>   BUG: unable to handle page fault for address: ffffa742800ed01f
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 6a4e9067 P4D 6a4e9067 PUD 6a4ec067 PMD 6a4ed067 PTE 0
>   Oops: 0000 [#1] PREEMPT SMP PTI
>   CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Not tainted 5.8.5-arch1-1-kdump #1
>   Hardware name: Apple Inc. MacBookAir3,1/Mac-942452F5819B1C1B, BIOS    MBA31.88Z.0061.B07.1201241641 01/24/12
>   RIP: 0010:brcms_c_ampdu_dotxstatus+0x343/0x9f0 [brcmsmac]
>   Code: 54 24 20 66 81 e2 ff 0f 41 83 e4 07 89 d1 0f b7 d2 66 c1 e9 03 0f b7 c9 4c 8d 5c 0c 48 49 8b 4d 10 48 8b 79 68 41 57 44 89 e1 <41> 0f b6 33 41 d3 e0 48 c7 c1 38 e0 ea c0 48 83 c7 10 44 21 c6 4c
>   RSP: 0018:ffffa742800ecdd0 EFLAGS: 00010207
>   RAX: 0000000000000019 RBX: 000000000000000b RCX: 0000000000000006
>   RDX: 0000000000000ffe RSI: 0000000000000004 RDI: ffff8fc6ad776800
>   RBP: ffff8fc6855acb00 R08: 0000000000000001 R09: 00000000000005d9
>   R10: 00000000fffffffe R11: ffffa742800ed01f R12: 0000000000000006
>   R13: ffff8fc68d75a000 R14: 00000000000005db R15: 0000000000000019
>   FS:  0000000000000000(0000) GS:ffff8fc6aad00000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: ffffa742800ed01f CR3: 000000002480a000 CR4: 00000000000406e0
>   Call Trace:
>    <IRQ>
>    brcms_c_dpc+0xb46/0x1020 [brcmsmac]
>    ? wlc_intstatus+0xc8/0x180 [brcmsmac]
>    ? __raise_softirq_irqoff+0x1a/0x80
>    brcms_dpc+0x37/0xd0 [brcmsmac]
>    tasklet_action_common.constprop.0+0x51/0xb0
>    __do_softirq+0xff/0x340
>    ? handle_level_irq+0x1a0/0x1a0
>    asm_call_on_stack+0x12/0x20
>    </IRQ>
>    do_softirq_own_stack+0x5f/0x80
>    irq_exit_rcu+0xcb/0x120
>    common_interrupt+0xd1/0x200
>    asm_common_interrupt+0x1e/0x40
>   RIP: 0010:cpuidle_enter_state+0xb3/0x420
> 
> Check if the block is within BA window and only then check block's
> status. Otherwise as Behan wrote: "When I came back to Dublin I
> was courtmartialed in my absence and sentenced to death in my absence,
> so I said they could shoot me in my absence."
> 
> Also reported:
> https://bbs.archlinux.org/viewtopic.php?id=258428
> https://lore.kernel.org/linux-wireless/87tuwgi92n.fsf@yujinakao.com/
> 
> Reported-by: Yuji Nakao <contact@yujinakao.com>
> Signed-off-by: Dmitry Safonov <dima@arista.com>

Patch applied to wireless-drivers-next.git, thanks.

01c195de620b brcmsmac: ampdu: Check BA window size before checking block ack

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201116030635.645811-1-dima@arista.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

