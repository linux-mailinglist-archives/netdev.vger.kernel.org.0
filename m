Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A7F632DD6
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiKUUUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiKUUUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:20:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F06BF5AA;
        Mon, 21 Nov 2022 12:20:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B82D4CE18C1;
        Mon, 21 Nov 2022 20:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8978EC433D6;
        Mon, 21 Nov 2022 20:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669061997;
        bh=UuGz2IwXBvI0BbDZ3NR6oeGTtt+ttfHSFxkiX6eMD7s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MxjGoL6zHyMj7IQcaILqqt+4NOkTJv4Xp5tpPsv4sArxmtlFkQNRgdiaZiogTXZD5
         tk3gyDDlO90efbqWv1ut5/UpbdqPcNYOLEE7tqtVuDzy2dsrdM4y41WRDNqqay3mgg
         YdCosODoNEagMiMbaDQnKi90d44yGh5lEm3ZVMVXSPnAaae+Ep2BR7PCPaoea0IaAZ
         3x+hUB3qYL/2FeJrY+tGIthjjEigCEBNBjIb+F0f7gnvfNL8dvuu2oBiSV8Z02pjid
         fLKjs+Gqxib0XC+pesAoZLXMSFAeC4z9cJnXxm30JM+YVeDg7MxoS3dh4vm9s3Hi0H
         tLEa17iD5g/Wg==
Date:   Mon, 21 Nov 2022 12:19:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     xiangxia.m.yue@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
Message-ID: <20221121121939.0e5e2401@kernel.org>
In-Reply-To: <20221121100521.56601-2-xiangxia.m.yue@gmail.com>
References: <20221121100521.56601-1-xiangxia.m.yue@gmail.com>
        <20221121100521.56601-2-xiangxia.m.yue@gmail.com>
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

On Mon, 21 Nov 2022 18:05:21 +0800 xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> The commit 20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked"),
> try to fix deadlock, but in some case, the deadlock occurs:
> 
> * CPUn in task context with K1, and taking lock.
> * CPUn interrupted by NMI context, with K2.
> * They are using the same bucket, but different map_locked.

You should really put bpf@ in the CC line for bpf patches.
