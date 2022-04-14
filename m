Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A005009E9
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241796AbiDNJdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235687AbiDNJdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:33:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E677004C;
        Thu, 14 Apr 2022 02:31:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5416B828F4;
        Thu, 14 Apr 2022 09:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E84C385A1;
        Thu, 14 Apr 2022 09:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649928660;
        bh=eKxugoykMlS9M7TCOm7EbIUTc4/yNGVdEoj95mtC7SA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T+lwpYC2jvBJ+ljIhrHsEdaRg1OTgVbiu8Q9ckV4iPAwLQ76lRt35OIox104VBl7I
         8SJLRWqe4cEftCbFua750LmG0rUtThFF2Dfs5wkRnIZFb1aic3LGauaOdIKfc4T+Ji
         j2i0AQ/bs0VwgeIFAOs7UiM6m6j2xY0ZEsNHLjybmgmcDiniYP7RcLQo8+Gy2Q+a+k
         WijOvqj+Ep4WNuJ4SNwZK57SVQ74BL29/CChZQptNS0kEyDE9x3DHCr9uTAjaOeKaG
         hfUWPuYc2LvSIykaEWlhneRTzVjwhEH3dmuTE9AOuu41A10lqWDnqn9Nk5pGbKrFkr
         nRo2brZK97Eig==
Date:   Thu, 14 Apr 2022 11:30:52 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     sdf@google.com
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH bpf-next] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
Message-ID: <20220414113052.046ec83d@kernel.org>
In-Reply-To: <YldUIipJvL/7tK4P@google.com>
References: <20220413183256.1819164-1-sdf@google.com>
        <CAEf4Bzb_-KMy7GBN_NsJCKXHfDnGTtVEZb7i4dmcN-8=cLhO+A@mail.gmail.com>
        <Ylcm/dfeU3AEYqlV@google.com>
        <CAEf4BzYuTd9m4_J9nh5pZ9baoMMQK+m6Cum8UMCq-k6jFTJwEA@mail.gmail.com>
        <20220413223216.7lrdbizxg4g2bv5i@kafai-mbp.dhcp.thefacebook.com>
        <YldUIipJvL/7tK4P@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Apr 2022 15:52:18 -0700 sdf@google.com wrote:
> I guess including cgroup-defs.h/bpf-cgroup-defs.h into bpf.h might still
> be somewhat problematic?

FWIW including -defs.h into bpf.h should be fine.  Obviously fewer
cross-header deps the better. But the main point is that we don't 
want bpf.h to be included in too many places, so opposite direction 
to what you're asking IIUC.
