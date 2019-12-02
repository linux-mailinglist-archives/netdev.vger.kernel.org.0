Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A805A10E4A2
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 03:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfLBCth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 21:49:37 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34696 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbfLBCtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 21:49:36 -0500
Received: by mail-pl1-f193.google.com with SMTP id h13so15587833plr.1;
        Sun, 01 Dec 2019 18:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QJDlHz3W25QqCMl50UJG03dGYBHfruZP1Z/GZ6lchOo=;
        b=Zpl5/KnWTiRPBCz7n3gtkj+rv+mkxAI4d+XRgi1A6Fyh9FJXkGKMNHPPxVVxDbBe6+
         jfy4JWmRausm5HVYbDNjpX71MtwVm2/P+BQ0zqHKsR0xnbLkG2WRvACYslQj2lmCgFAr
         A+Wt7onaCX25zM21eBFMGqe3pHR5s0FcONPaE4O2ZsRDXxsoDR/x2jXskHXGDVA6ANM+
         Zydr1cMGNtzR+xzMNr/f4NSLB9fx/R+/kOY2khJUcw3FpIsKPy7bHsOGkqDcOByyEq01
         eGkMawqLFVXILVnwgD1sRjyu+lzzv5e15hVZ7wXhXbu86KPzyP0pHIXzXNzH84s65DbX
         f6Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QJDlHz3W25QqCMl50UJG03dGYBHfruZP1Z/GZ6lchOo=;
        b=ZlJRo3d7hcPu6eHSyQEZgacxaCKK9DgSjfiW7Rr356vfMV3pAbTFEBe1rRrbgCOauY
         +rYsD0C1xSXTO2zCYCqNB3aBiLQcj18kvL7slzj/c70pnVaiGtS/ydYtO3l3PJ/1fRaO
         f9NpgSFQO/s1EOR/z4Xdn9slssE/9mFYtaBnU2N4ah+/r2k1PJTCIYvmSH4xEyffLHLl
         H0LpFOBExrL9DjxESpeZI1aeFAaP4w7zHDrlMyrVwmyP6UBVLIIc9KgplPtaa3XJnqei
         oxmLzUGUucZkmxvfW2u12L1KGVHvA7RqpnRksbWFuNXd3/DYmsGOJCNANm0I/8nNdchw
         Lohg==
X-Gm-Message-State: APjAAAVuUN5VJWdtCVWvpkPXl0O4vGepQtZ6fy/x5T0Ly9upE7BnGjP2
        ZFfUTb8FTsdrAb7KAKbFTVwukmEC
X-Google-Smtp-Source: APXvYqx/7zqUcRahTULlxciAq5BjnxBAyOaLpB5GMfxSZhelkbHBNwCYAe1P2xKz4JwgTwM/xnSIow==
X-Received: by 2002:a17:902:8649:: with SMTP id y9mr25238840plt.67.1575254974778;
        Sun, 01 Dec 2019 18:49:34 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id d85sm16913720pfd.146.2019.12.01.18.49.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Dec 2019 18:49:34 -0800 (PST)
Subject: Re: [PATCH bpf] bpf: avoid setting bpf insns pages read-only when
 prog is jited
To:     Daniel Borkmann <daniel@iogearbox.net>,
        alexei.starovoitov@gmail.com
Cc:     peterz@infradead.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20191129222911.3710-1-daniel@iogearbox.net>
 <ec8264ad-8806-208a-1375-51e7cad1866e@gmail.com>
 <10d4c87c-3d53-2dbf-d8c0-8b36863fec60@iogearbox.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <adc89dbf-361a-838f-a0a5-8ef7ea619848@gmail.com>
Date:   Sun, 1 Dec 2019 18:49:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <10d4c87c-3d53-2dbf-d8c0-8b36863fec60@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/30/19 1:52 AM, Daniel Borkmann wrote:
> On 11/30/19 2:37 AM, Eric Dumazet wrote:
>> On 11/29/19 2:29 PM, Daniel Borkmann wrote:
>>> For the case where the interpreter is compiled out or when the prog is jited
>>> it is completely unnecessary to set the BPF insn pages as read-only. In fact,
>>> on frequent churn of BPF programs, it could lead to performance degradation of
>>> the system over time since it would break the direct map down to 4k pages when
>>> calling set_memory_ro() for the insn buffer on x86-64 / arm64 and there is no
>>> reverse operation. Thus, avoid breaking up large pages for data maps, and only
>>> limit this to the module range used by the JIT where it is necessary to set
>>> the image read-only and executable.
>>
>> Interesting... But why the non JIT case would need RO protection ?
> 
> It was done for interpreter around 5 years ago mainly due to concerns from security
> folks that the BPF insn image could get corrupted (through some other bug in the
> kernel) in post-verifier stage by an attacker and then there's nothing really that
> would provide any sort of protection guarantees; pretty much the same reasons why
> e.g. modules are set to read-only in the kernel.
> 
>> Do you have any performance measures to share ?
> 
> No numbers, and I'm also not aware of any reports from users, but it was recently
> brought to our attention from mm folks during discussion of a different set:
> 
> https://lore.kernel.org/lkml/1572171452-7958-2-git-send-email-rppt@kernel.org/T/
> 

Thanks for the link !

Having RO protection as a debug feature would be useful.

I believe we have CONFIG_STRICT_MODULE_RWX (and CONFIG_STRICT_KERNEL_RWX) for that already.

Or are we saying we also want to get rid of them ?
