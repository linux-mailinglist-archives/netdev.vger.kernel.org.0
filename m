Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBE611973E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbfLJVb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:31:56 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39079 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbfLJVbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:31:52 -0500
Received: by mail-pl1-f193.google.com with SMTP id o9so376161plk.6;
        Tue, 10 Dec 2019 13:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=WtDhoZ5ivvcVrikLoCcOpbuCN5K2xI6ePb8PHhBX/qY=;
        b=bNBHfHD03h3hmMV1w1mftAhHlsANzeRmCm5ntICoRhmQwAgj90TCYu0exwqE/pdhgE
         GdNZfSlxmS9+MnUMV7dWFoxBeYeAAQf7p2crlgBjwXDwXG1sXMJ6b1MjtryjbQIVfa8o
         1SX/XqQOGXbyT71gHQYIa2IRm8lwQVeIcfLSC6L0EJSb4weQ0dZWQ4IVIG1HfR5u32U9
         aDDBA5mO5vSpt3tWu9JReI7ZfKo8J0rhq/a1azkAzqGLiHXA4pg5d+2U8UoGB8QCy25N
         AU5WmUYt1keRgOs0PN80AM32Fz5sEXch3w0CfnU5IBM5wCHJ0QTur7PEqplqQGIDlFXt
         Nzbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=WtDhoZ5ivvcVrikLoCcOpbuCN5K2xI6ePb8PHhBX/qY=;
        b=PthU7trMwPI5ZXqCmeKtyLsdZcrh3Vdx/4PWVmPDTk7pykpqLeJ5f6edfbu68Pgu//
         mvHgnVpqNyt7vc5pFeIVCFqV00U0W4yyQNZC/RiqTcY+fOvhUN7rK8PwU1B/yuG9wA3w
         rV7LU7w/C7tG9oJE/++LjXGJ1c5hhUWl/M3uraws3F6+XaTeXA4toUyKohpEQlxW0dfo
         5NAHc+qnOSBc7Gj7w+9EA9/qCt+TF+RGhK2wiOBTwzqHkZrs92X0Nv/7nhVQ/g1WMr+L
         mykBDZafrk6q1+OkV+Tm4HZWQ6rUEWUJUZGs/ss7CHBHatziXGQbm0IPSzO8cMJeOVdH
         +N2g==
X-Gm-Message-State: APjAAAVM48o/V+aK1nBZihPzmCeW8GgP+hTYVksQKsUtqqvIEYXNJfjr
        WdiAOY3Ro7Gfmpgp1PzWeE4=
X-Google-Smtp-Source: APXvYqwfHN9VmCdq6yL7ojouBK+46iwUO9cnHFSBSdaffvPSJZPzqJgNYzlxRmyGh/W0xuYKtbYMlw==
X-Received: by 2002:a17:90a:8986:: with SMTP id v6mr7783380pjn.63.1576013511889;
        Tue, 10 Dec 2019 13:31:51 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:a25c])
        by smtp.gmail.com with ESMTPSA id o3sm3613026pju.13.2019.12.10.13.31.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Dec 2019 13:31:51 -0800 (PST)
Date:   Tue, 10 Dec 2019 13:31:50 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf v2] bpftool: Don't crash on missing jited insns or
 ksyms
Message-ID: <20191210213148.kqd6xdvqjkh3zxst@ast-mbp.dhcp.thefacebook.com>
References: <20191210181412.151226-1-toke@redhat.com>
 <20191210125457.13f7821a@cakuba.netronome.com>
 <87eexbhopo.fsf@toke.dk>
 <20191210132428.4470a7b0@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191210132428.4470a7b0@cakuba.netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 01:24:28PM -0800, Jakub Kicinski wrote:
> On Tue, 10 Dec 2019 22:09:55 +0100, Toke Høiland-Jørgensen wrote:
> > Jakub Kicinski <jakub.kicinski@netronome.com> writes:
> > > On Tue, 10 Dec 2019 19:14:12 +0100, Toke Høiland-Jørgensen wrote:  
> > >> When the kptr_restrict sysctl is set, the kernel can fail to return
> > >> jited_ksyms or jited_prog_insns, but still have positive values in
> > >> nr_jited_ksyms and jited_prog_len. This causes bpftool to crash when trying
> > >> to dump the program because it only checks the len fields not the actual
> > >> pointers to the instructions and ksyms.
> > >> 
> > >> Fix this by adding the missing checks.
> > >> 
> > >> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>  
> > >
> > > Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
> > >
> > > and
> > >
> > > Fixes: f84192ee00b7 ("tools: bpftool: resolve calls without using imm field")
> > >
> > > ?  
> > 
> > Yeah, guess so? Although I must admit it's not quite clear to me whether
> > bpftool gets stable backports, or if it follows the "only moving
> > forward" credo of libbpf?
> 
> bpftool does not have a GH repo, and seeing strength of Alexei's
> arguments in the recent discussion - I don't think it will. So no
> reason for bpftool to be "special"

bpftool always was and will be a special user of libbpf.

