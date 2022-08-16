Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A8E59624D
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236607AbiHPSVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiHPSVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:21:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B368672F;
        Tue, 16 Aug 2022 11:21:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AE27B816A4;
        Tue, 16 Aug 2022 18:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B529C433D6;
        Tue, 16 Aug 2022 18:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660674109;
        bh=yok4cnVjsxHJqT49gDQ+73c5tXsJfXyLUJssrEQ6TOM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=spP9luuyOM6Sxcq99jQsYp0/VI6NpJRjFFEna9Zg8ocuyM/Xf3hl0pWaSvsHA7ZIA
         1sgYxXaxP921kqeV2olFNot2a0JgxK60pFDBOi5oyh9USl/fBI1rc3QC9BH1+OIFbv
         PLRfqgNenDYPTmYocKZsJ/UM+NBwJVPi7UpFynHZNlqMY1sCTlok7SfnuuNL7pp2Rz
         NfHS7lfWXEbSugJE2wz+yJAwqWnE+n61o+OXeqZSCMYG9/DIFK2NpK/VEvrZa3P+72
         Uk9D8qPobIdwXW+zG4eIERME2KYRnPCUZH9m1//NHizzca9XzEY3t/1Vj0X/IzBr2e
         vDwZJLfepOF2Q==
Date:   Tue, 16 Aug 2022 11:21:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH] net: Fix suspicious RCU usage in
 bpf_sk_reuseport_detach()
Message-ID: <20220816112147.3aa8d35b@kernel.org>
In-Reply-To: <20220816103452.479281-1-yin31149@gmail.com>
References: <166064248071.3502205.10036394558814861778.stgit@warthog.procyon.org.uk>
        <20220816103452.479281-1-yin31149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 18:34:52 +0800 Hawkins Jiawei wrote:
> +__rcu_dereference_sk_user_data_with_flags_check(const struct sock *sk,

This name is insanely long now.
