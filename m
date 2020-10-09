Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58446288BE2
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 16:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388967AbgJIOyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 10:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388664AbgJIOyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 10:54:19 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F25C0613D2;
        Fri,  9 Oct 2020 07:54:17 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id lw21so13489950ejb.6;
        Fri, 09 Oct 2020 07:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WPLkSeBjE1UNFvhO83o6KlgNgRkw/d3XV3/gLArbGT4=;
        b=ubB/KqJYZzM5j9bfX7vxLEmNhOPSiGG2mpxOk+X66p7Mv1n6uwgV9Urmrt+vvNI1wx
         jFxgeRuJjiAcAhGXnVJvISCBTUru3PAkDuZZiQOzhyzWcfKP+VDRGTzBwbS3evqV3feK
         xW/jupkwDGiqZ4KGcdbn05B3Ktuml5dotOzvxV+iQlBJ2YBP3preI2cvpFErIRvvW+Lf
         4sM4l4QbyhlVWYqaUM5styJp+n4smks6UlLpiV1/x+PqegAgWOI8fpj36IUO3YItiCcW
         bZK0wkpRWlWio1LLi2kcVcoK+dBmMyyqtpEgDIWhf1vxeThxcEvHGMAFt1xXT6yrVD8p
         zZMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WPLkSeBjE1UNFvhO83o6KlgNgRkw/d3XV3/gLArbGT4=;
        b=UUof2J5bTCrhfZuzwjEXGc5of0EIvA3qKdtKeUDt0lfJOpK7TtD+NrxoiV3ufsD5r0
         qAfGSaT/1N1H4qoU/ftVb1vw0w6L92j2mz+L53vl/VnPseVqbpbFl0nfX2lw9rZZuKhG
         Ig4O/QAWiTfJcpEPNiHVk+sVMr3DZ2C/f9P4TydBi26R4oqQwXiLv9VAMd1XdKAuPmZf
         Ucej08Pv7K68JmGNsAToFApvPoYw9c0p8xtz41s2zHOdSHB+H94bjnPS5uTMC55HtDVt
         PwOejDMnIeNG2GWAkzuZGSA0QxZ4KmVl3NcU1eFfHAIsiT+cM3EsbRpgx2G92e5uoe8Y
         P0nA==
X-Gm-Message-State: AOAM530E7t5/mI2xAdCHihg6VMw06GJKXu1TNYQm1HdNz3AnU0ucgdnN
        rwD4V9fP2QbPCHqoSkW6PJkZpAFAYkA/oQ==
X-Google-Smtp-Source: ABdhPJxaaSDSp8k8U2yr8O/442lsP/xXbOLJZ/AiJKc+/39HwEaAgIUrdOEa51Hm7RHJj8j+O2db9w==
X-Received: by 2002:a17:906:d292:: with SMTP id ay18mr14899370ejb.244.1602255256179;
        Fri, 09 Oct 2020 07:54:16 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:e538:757:aee0:c25f? (p200300ea8f006a00e5380757aee0c25f.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:e538:757:aee0:c25f])
        by smtp.googlemail.com with ESMTPSA id t10sm6369824ejc.38.2020.10.09.07.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 07:54:15 -0700 (PDT)
Subject: Re: [PATCH] net: stmmac: Don't call _irqoff() with hardirqs enabled
To:     John Keeping <john@metanate.com>, netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20201008162749.860521-1-john@metanate.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <8036d473-68bd-7ee7-e2e9-677ff4060bd3@gmail.com>
Date:   Fri, 9 Oct 2020 16:54:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201008162749.860521-1-john@metanate.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.10.2020 18:27, John Keeping wrote:
> With threadirqs, stmmac_interrupt() is called on a thread with hardirqs
> enabled so we cannot call __napi_schedule_irqoff().  Under lockdep it
> leads to:
> 
> 	------------[ cut here ]------------
> 	WARNING: CPU: 0 PID: 285 at kernel/softirq.c:598 __raise_softirq_irqoff+0x6c/0x1c8
> 	IRQs not disabled as expected
> 	Modules linked in: brcmfmac hci_uart btbcm cfg80211 brcmutil
> 	CPU: 0 PID: 285 Comm: irq/41-eth0 Not tainted 5.4.69-rt39 #1
> 	Hardware name: Rockchip (Device Tree)
> 	[<c0110d3c>] (unwind_backtrace) from [<c010c284>] (show_stack+0x10/0x14)
> 	[<c010c284>] (show_stack) from [<c0855504>] (dump_stack+0xa8/0xe0)
> 	[<c0855504>] (dump_stack) from [<c0120a9c>] (__warn+0xe0/0xfc)
> 	[<c0120a9c>] (__warn) from [<c0120e80>] (warn_slowpath_fmt+0x7c/0xa4)
> 	[<c0120e80>] (warn_slowpath_fmt) from [<c01278c8>] (__raise_softirq_irqoff+0x6c/0x1c8)
> 	[<c01278c8>] (__raise_softirq_irqoff) from [<c056bccc>] (stmmac_interrupt+0x388/0x4e0)
> 	[<c056bccc>] (stmmac_interrupt) from [<c0178714>] (irq_forced_thread_fn+0x28/0x64)
> 	[<c0178714>] (irq_forced_thread_fn) from [<c0178924>] (irq_thread+0x124/0x260)
> 	[<c0178924>] (irq_thread) from [<c0142ee8>] (kthread+0x154/0x164)
> 	[<c0142ee8>] (kthread) from [<c01010bc>] (ret_from_fork+0x14/0x38)
> 	Exception stack(0xeb7b5fb0 to 0xeb7b5ff8)
> 	5fa0:                                     00000000 00000000 00000000 00000000
> 	5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 	5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> 	irq event stamp: 48
> 	hardirqs last  enabled at (50): [<c085c200>] prb_unlock+0x7c/0x8c
> 	hardirqs last disabled at (51): [<c085c0dc>] prb_lock+0x58/0x100
> 	softirqs last  enabled at (0): [<c011e770>] copy_process+0x550/0x1654
> 	softirqs last disabled at (25): [<c01786ec>] irq_forced_thread_fn+0x0/0x64
> 	---[ end trace 0000000000000002 ]---
> 
> Use __napi_schedule() instead which will save & restore the interrupt
> state.
> 
I'm thinking about a __napi_schedule version that disables hard irq's
conditionally, based on variable force_irqthreads, exported by the irq
subsystem. This would allow to behave correctly with threadirqs set,
whilst not loosing the _irqoff benefit with threadirqs unset.
Let me come up with a proposal.
