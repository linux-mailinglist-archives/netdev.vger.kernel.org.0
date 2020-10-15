Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5452628F0A3
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 13:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgJOLEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 07:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbgJOLEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 07:04:43 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B59C0613D3
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 04:04:42 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id m16so2694291ljo.6
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 04:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=+b/YNm12GlyjKZkrJa+xNKLCvbZwV87rX2QqyldGjws=;
        b=Fs8Ur5yfSGlhm3tkrS8CaTuEgOsMPvCDMHTtKy9DHInI+lZwRQhcOZh2hwlHQqaO7F
         2X6ynm/BaHcMWsp22AP25p2+TmAtD/jrgb5gK5scngcc8AyGkE8U4u10sbpFyvCYlk95
         Dmdy6P23JeOLfAlzCd20iyiEa+yCMdKmmiiN0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=+b/YNm12GlyjKZkrJa+xNKLCvbZwV87rX2QqyldGjws=;
        b=Vg+i2v4ovOK9J2YgFUDGbvnl1ftnGTVsJU3Pg/4eddy1PJDCdOd5bvH8cbbU6DeYGB
         7GYtTuhhC16hf9FrRuQVrNC6qc7Ys9nrnIVcoqpH2zunWPwQuY/JfKLyh85sdBZU55Yo
         0EkDcC4OT57ZZnKvbhASJpuH/L1JfbqoqiR26dhoHQYRnNryK1ExMZLofb2M9BL5fnBA
         ciXGlwSbGeYyepc0nhGoq3GjT/Isgh3ASMC8WfcLgDc3K5lnM9++eSdPtqXeOPG5Hhhu
         94ITk8i/Gf6TXo46HFJnHH8+lmT3+7p77R33YwRhdYLJSP8N5c6fQI1UXioMVHLvgFlV
         kjeg==
X-Gm-Message-State: AOAM533EYwtypyJ6hVIneWBGdfuk8rkQNkpAroPUFNhni3DWVa3ZTtCG
        MLwwCj+YTjbHpVWFvU4exaxMgA==
X-Google-Smtp-Source: ABdhPJwqoqunynjtcFWpGOq7Yf1tTxX9lASD0Qj/cwux40BxHvQAh3fld0SAKdqEZMLhkeSXHURtXQ==
X-Received: by 2002:a2e:8e8f:: with SMTP id z15mr1100477ljk.238.1602759881002;
        Thu, 15 Oct 2020 04:04:41 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id j12sm929026lfb.28.2020.10.15.04.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 04:04:40 -0700 (PDT)
References: <20201012170952.60750-1-alex.dewar90@gmail.com> <878sc9qi3c.fsf@cloudflare.com> <5f87d37225c32_b7602083@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sockmap: Don't call bpf_prog_put() on NULL pointer
In-reply-to: <5f87d37225c32_b7602083@john-XPS-13-9370.notmuch>
Date:   Thu, 15 Oct 2020 13:04:39 +0200
Message-ID: <875z7brbqw.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 06:43 AM CEST, John Fastabend wrote:

[...]

> Jakub, any opinions on if we should just throw an error if users try to
> add a sock to a map with a parser but no verdict? At the moment we fall
> through and add the socket, but it wont do any receive parsing/verdict.
> At the moment I think its fine with above fix. The useful cases for RX
> are parser+verdict, verdict, and empty. Where empty is just used for
> redirects or other socket account tricks. Just something to keep in mind.

IMO we should not fail because map updates can interleave with sk_skb
prog attachments, like so:

	update_map(map_fd, sock_fd);
	attach_prog(parser_fd, map_fd, BPF_SK_SKB_STREAM_PARSER);
	update_map(map_fd, sock_fd); // OK
	attach_prog(verdict_fd, map_fd, BPF_SK_SKB_STREAM_VERDICT);
	update_map(map_fd, sock_fd);

In practice, I would expect one process/thread to attach the programs,
while another is allowed to update the map at the same time.
