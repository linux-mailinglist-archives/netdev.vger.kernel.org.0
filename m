Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F43E567490
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 18:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiGEQjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 12:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiGEQjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 12:39:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C3019C30;
        Tue,  5 Jul 2022 09:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 319CFB8184A;
        Tue,  5 Jul 2022 16:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBC8C341C7;
        Tue,  5 Jul 2022 16:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657039190;
        bh=yh6ho/I9Easg45efAjcjXhmjoEVVloWhd5h1kDc+BuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J6oB/6FmOqrzEPGosLm/BuEXHlJ1fH5J0iuxnnd04Zz2XgSNHKXlmpUagdkqu2PZ9
         oNIbKkEAAiH26bCLCkBt9OaU3jdkXjuTIzm2k/p6JI7quVtlyvSXfnDbtXAbpZH26j
         TYKDNGzUBu1kB/hN8eNv9qnIdPYn7GVrwKphsUVF1hyagmMRyBj4y0dBmtqcO9DlEI
         9rLHTwwahd6WsWj+SZgxux8kWhT5BXvgAnKZJyeQ+jJqazQsA/4OeMy6sxovhOP1/h
         +brVdBiChvLBM00b9dNXfSUA/TukQ0ULR93hOnGsYQ2xd/WZtNJFIHWYlcN/K3vjYS
         yfnl+xoDZ/NFQ==
Date:   Tue, 5 Jul 2022 17:39:41 +0100
From:   Will Deacon <will@kernel.org>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>
Subject: Re: [PATCH bpf-next v6 2/4] arm64: Add LDR (literal) instruction
Message-ID: <20220705163941.GA1339@willie-the-truck>
References: <20220625161255.547944-1-xukuohai@huawei.com>
 <20220625161255.547944-3-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220625161255.547944-3-xukuohai@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 25, 2022 at 12:12:53PM -0400, Xu Kuohai wrote:
> Add LDR (literal) instruction to load data from address relative to PC.
> This instruction will be used to implement long jump from bpf prog to
> bpf rampoline in the follow-up patch.

typo: trampoline

> 
> The instruction encoding:
> 
>     3       2   2     2                                     0        0
>     0       7   6     4                                     5        0
> +-----+-------+---+-----+-------------------------------------+--------+
> | 0 x | 0 1 1 | 0 | 0 0 |                imm19                |   Rt   |
> +-----+-------+---+-----+-------------------------------------+--------+
> 
> for 32-bit, variant x == 0; for 64-bit, x == 1.
> 
> branch_imm_common() is used to check the distance between pc and target
> address, since it's reused by this patch and LDR (literal) is not a branch
> instruction, rename it to aarch64_imm_common().

nit, but I think "label_imm_common()" would be a better name.

Anyway, I checked the encodings and the code looks good, so:

Acked-by: Will Deacon <will@kernel.org>

Will
