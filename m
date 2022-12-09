Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B553648B68
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 00:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiLIXev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 18:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiLIXeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 18:34:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28916F4A5;
        Fri,  9 Dec 2022 15:34:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BC3AB829BD;
        Fri,  9 Dec 2022 23:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4822CC433D2;
        Fri,  9 Dec 2022 23:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670628886;
        bh=AkVK/rY6tpVEJi9WGUCZ3St66jkh+zvB7lm647zQjhg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SN4ycjIa71P6cIrIn4KxTO6jglUuhdxTfl72zKSE2Gh+dwZxlhXpJNm48aFv+5RAU
         TiHH1XMZ/MMQhwpmeVR4yPiL9mEFG/Ob/g/l8C2N/sSCfz4ibDtATwNXWnovXZ+C2R
         cMojI+oR2hMvVWkXWa4LF8RnjSfLdEeWweUJRqrk5Ij+zBDu01l0I0R+BNMF76Huoe
         GIwJoRid+Tw/7C0Ed2L2w/ig86XLqH1//G2lVNPhBiJem9oMExtAmCvRfRLIYfHr0t
         Xgtq9hLK5xUeiqG0+EgZwagVc/uOc5/MZ7o3Aa8yN9RQflnW3YylHE/ouY9yJQ6O05
         eRPkoGqSH9DBw==
Date:   Fri, 9 Dec 2022 15:34:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Yonghong Song <yhs@meta.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>, Hao Sun <sunhao.th@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: BUG: unable to handle kernel paging request in
 bpf_dispatcher_xdp
Message-ID: <20221209153445.22182ca5@kernel.org>
In-Reply-To: <96b0d9d8-02a7-ce70-de1e-b275a01f5ff3@iogearbox.net>
References: <Y5Inw4HtkA2ql8GF@krava>
        <Y5JkomOZaCETLDaZ@krava>
        <Y5JtACA8ay5QNEi7@krava>
        <Y5LfMGbOHpaBfuw4@krava>
        <Y5MaffJOe1QtumSN@krava>
        <Y5M9P95l85oMHki9@krava>
        <Y5NSStSi7h9Vdo/j@krava>
        <5c9d77bf-75f5-954a-c691-39869bb22127@meta.com>
        <Y5OuQNmkoIvcV6IL@krava>
        <ee2a087e-b8c5-fc3e-a114-232490a6c3be@iogearbox.net>
        <Y5O/yxcjQLq5oDAv@krava>
        <96b0d9d8-02a7-ce70-de1e-b275a01f5ff3@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Dec 2022 00:32:07 +0100 Daniel Borkmann wrote:
> fwiw, these should not be necessary, Documentation/RCU/checklist.rst :
> 
>    [...] One example of non-obvious pairing is the XDP feature in networking,
>    which calls BPF programs from network-driver NAPI (softirq) context. BPF
>    relies heavily on RCU protection for its data structures, but because the
>    BPF program invocation happens entirely within a single local_bh_disable()
>    section in a NAPI poll cycle, this usage is safe. The reason that this usage
>    is safe is that readers can use anything that disables BH when updaters use
>    call_rcu() or synchronize_rcu(). [...]

FWIW I sent a link to the thread to Paul and he confirmed 
the RCU will wait for just the BH.
