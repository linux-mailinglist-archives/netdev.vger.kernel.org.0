Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4653261473
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbgIHQVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731442AbgIHQUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:20:34 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454E1C061755;
        Tue,  8 Sep 2020 09:20:34 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id k25so8241784ljk.0;
        Tue, 08 Sep 2020 09:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+wPlOm5QGCDqS1iz36b73Yrjc2ZOjFBBzVPqfqSTkRU=;
        b=q9ep2VefGV3tnh1gc6k2bD4tOieJ9IWqWneNunCFsbLBb4ERqckJ+2JeLGZEK4XW/a
         JJEfzALL4HkOtfXCEc6yb/WPGrI38fGy7D7rIN+RZCeFkc9lS716ATlu/6BP8T0+HMO3
         qZrgQNobDnTlp+5/Pe67V8RekhvXZdWT4PnihyvRuo6mO5JjenjIfxpr0j2K0Se1oMic
         rBYc6FOCdLoc+vcEuYQztTqYYE5mARtYmSyCSU/U8WKotCPvtsDA0kmCVB5LpR/s72i9
         j6k0emAoVQbnPDgWntWVPGO+mtgoO/gTfOEe3Jxz4mhhsxvdVpWY0qQbNprMD/srILNx
         37gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+wPlOm5QGCDqS1iz36b73Yrjc2ZOjFBBzVPqfqSTkRU=;
        b=K4XhcKkD1FceLECP1km0SQ01x0TWty67O6hPK5sv38nKtdVCWpphDjXByzPQgzZGi5
         uUAAc16QiiTbjSnvJ27gcO7qktJbFSYLAoEjz7pwpiIWtDBwb7/pLdR1dD+UYVoaAR4r
         bq6BqQ0bG7ghEVTJSUHwSbjnG/XXggbV2Qj6xPPZ7JEdsBKDfMRTW7BK2q73PiIMxNLE
         NychsvSjfh0kdEtXzhRoY9Ou8ZgdywkAyEfqEUb+dzXQl++9kzg3KAzpSKD7AMtNMzqe
         IKk0KTwIFNjXKq1//Jn8ATD6A6HzKFRTctjiUTbCcVzqlqPanOgThMKywkP1ZYTsCnhm
         AZAg==
X-Gm-Message-State: AOAM530FoZgc2r/6v51FvSGi7DSEwqRR2LHQTOtGum2IBVrrjsObI1kk
        26Pzl60PUCASTZbD7Y5szX45jTVXLKeIC/D6ljQ=
X-Google-Smtp-Source: ABdhPJza0z8ybBhHjq6D1GgCSx5raB9QWiBPxOGch4dtPYCzvpBunYHBeGM0H23wmyTQrtglEspqjh6+FU+Y/dC/qkw=
X-Received: by 2002:a2e:9782:: with SMTP id y2mr13292774lji.91.1599582032702;
 Tue, 08 Sep 2020 09:20:32 -0700 (PDT)
MIME-Version: 1.0
References: <cace836e4d07bb63b1a53e49c5dfb238a040c298.1599512096.git.daniel@iogearbox.net>
In-Reply-To: <cace836e4d07bb63b1a53e49c5dfb238a040c298.1599512096.git.daniel@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 8 Sep 2020 09:20:21 -0700
Message-ID: <CAADnVQ+woTCQ5JaEJvtWWsgU5OC+EA9NuRXhd2RmywU6mEYoEg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Fix clobbering of r2 in bpf_gen_ld_abs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bryce.kahle@datadoghq.com,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 7, 2020 at 3:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Bryce reported that he saw the following with:
>
>   0:  r6 = r1
>   1:  r1 = 12
>   2:  r0 = *(u16 *)skb[r1]
>
> The xlated sequence was incorrectly clobbering r2 with pointer
> value of r6 ...
>
>   0: (bf) r6 = r1
>   1: (b7) r1 = 12
>   2: (bf) r1 = r6
>   3: (bf) r2 = r1
>   4: (85) call bpf_skb_load_helper_16_no_cache#7692160
>
> ... and hence call to the load helper never succeeded given the
> offset was too high. Fix it by reordering the load of r6 to r1.
>
> Other than that the insn has similar calling convention than BPF
> helpers, that is, r0 - r5 are scratch regs, so nothing else
> affected after the insn.
>
> Fixes: e0cea7ce988c ("bpf: implement ld_abs/ld_ind in native bpf")
> Reported-by: Bryce Kahle <bryce.kahle@datadoghq.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Applied. Thanks
