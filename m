Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1072C6E99C2
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjDTQmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjDTQma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:42:30 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D972D45
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:42:29 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54f3e30726cso26023297b3.22
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682008949; x=1684600949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T1mmlYQK0Ax84SlhH64ck5bBrkjS+ny32bkCi7XQTZQ=;
        b=5VtY8k60e5g1tJwzNKEMWu02mAc0iZcoJ60a9EpQjikosZde7KPmrao0fgjSBp74n/
         EugDFzl2b4y1ruxsaSoE3Rg0rt2f0cauXiIJPhaI9Ez6axZLTH52xVYTyUpfZkWuI5yk
         fD0GKtdB4TYGYw7Fk+aDHyKvc7cnqGTtKtVHoJGdQ13FvEzI9KFXUd3OXoZZe75zoXli
         idM3GVswA+9gfPRLDXVw5zzVI+o8deBIOs9XUluU0ArdTRe8dxy5oUr3hEyC9FTCRhzo
         5zxZQI7ZLVGNVa7GIYMhzlVpyprBy9dbpqv9F3Ood9nO9WdcalWrwTTDeapsc+PU9cMW
         GdWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682008949; x=1684600949;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T1mmlYQK0Ax84SlhH64ck5bBrkjS+ny32bkCi7XQTZQ=;
        b=OlUbT9/D8ckQI4wDQlvuYdcbNZkKdSMAoSwxJp3FeOq0v6QjocpCapbb/j+vHPzVMd
         5PC6C5QmyucuMrRFMAG2eVcXYgoOwywZc3xyA0IW1y7hsUWNuh7qZJhgZ3aIbSRtmnVV
         PGYMvUQXVpsgUFoKVKIb40+5uDAkop3vzNu3il6G28qhKipCOma3DUUCzrPrIp5P5Wto
         8mGEBnmnD9P0JBQO5gCNzO0f/dQiCBxdcnk2A0auUrXKw9q3/m82iczh3iVyKQ/ueqDk
         eMFsK2NBpSh7kbpbk6aa2yhnSAbvKoQ4Fq31Q0MLHInFJbve8s5eMJljCmXimQL7TRcV
         oSjA==
X-Gm-Message-State: AAQBX9cMbmDYoKPZN6BZm2ZSxU/LQMnbJIl5Sg5ZZ0elI2EPMrlKpeEy
        8TtqfIpspnxWeTwB5KRpaHNO0Xs=
X-Google-Smtp-Source: AKy350YaSf/EF1hYCH6Qty7yMntO448QhciDS+jiloiJxtMJBinKQuK91dMGqLj50RpYgaccxq0TUbw=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a25:d04c:0:b0:b96:106d:5198 with SMTP id
 h73-20020a25d04c000000b00b96106d5198mr1325874ybg.7.1682008948829; Thu, 20 Apr
 2023 09:42:28 -0700 (PDT)
Date:   Thu, 20 Apr 2023 09:42:26 -0700
In-Reply-To: <20230420145041.508434-1-gilad9366@gmail.com>
Mime-Version: 1.0
References: <20230420145041.508434-1-gilad9366@gmail.com>
Message-ID: <ZEFrcoG+QS/PRbew@google.com>
Subject: Re: [PATCH bpf,v2 0/4] Socket lookup BPF API from tc/xdp ingress does
 not respect VRF bindings.
From:   Stanislav Fomichev <sdf@google.com>
To:     Gilad Sever <gilad9366@gmail.com>
Cc:     dsahern@kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
        shuah@kernel.org, hawk@kernel.org, joe@wand.net.nz,
        eyal.birger@gmail.com, shmulik.ladkani@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/20, Gilad Sever wrote:
> When calling socket lookup from L2 (tc, xdp), VRF boundaries aren't
> respected. This patchset fixes this by regarding the incoming device's
> VRF attachment when performing the socket lookups from tc/xdp.
> 
> The first two patches are coding changes which facilitate this fix by
> factoring out the tc helper's logic which was shared with cg/sk_skb
> (which operate correctly).

Why is not relevant for cgroup/egress? Is it already running with
the correct device?

Also, do we really need all this refactoring and separate paths?
Can we just add that bpf_l2_sdif part to the existing code?
It will trigger for tc, but I'm assuming it will be a no-op for cgroup
path?

And regarding bpf_l2_sdif: seems like it's really generic and should
probably be called something like dev_sdif?

> The third patch contains the actual bugfix.
> 
> The fourth patch adds bpf tests for these lookup functions.
> ---
> v2: Fixed uninitialized var in test patch (4).
> 
> Gilad Sever (4):
>   bpf: factor out socket lookup functions for the TC hookpoint.
>   bpf: Call __bpf_sk_lookup()/__bpf_skc_lookup() directly via TC
>     hookpoint
>   bpf: fix bpf socket lookup from tc/xdp to respect socket VRF bindings
>   selftests/bpf: Add tc_socket_lookup tests
> 
>  net/core/filter.c                             | 132 +++++--
>  .../bpf/prog_tests/tc_socket_lookup.c         | 341 ++++++++++++++++++
>  .../selftests/bpf/progs/tc_socket_lookup.c    |  73 ++++
>  3 files changed, 525 insertions(+), 21 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_socket_lookup.c
>  create mode 100644 tools/testing/selftests/bpf/progs/tc_socket_lookup.c
> 
> -- 
> 2.34.1
> 
