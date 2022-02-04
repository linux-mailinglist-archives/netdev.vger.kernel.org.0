Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE1A4A921D
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 02:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355351AbiBDBsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 20:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234520AbiBDBsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 20:48:07 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80E7C061714;
        Thu,  3 Feb 2022 17:48:07 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id y17so3835467plg.7;
        Thu, 03 Feb 2022 17:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EN6ct084o48NExErKXMnp0M0dwlsejuVZ1iLXIP3bUU=;
        b=d8958Hl7QKvp+EtP1yg0G4oLSo194br5HSPTklmWQw1wQNejU+6tAOEWocZYAVhFpm
         I/Z0gnV1vp9QOqK7hx0AtsZG56z/qAfwxBsTs5pPq/naC35LI40VayB9tlc+fN2JLgD7
         JNM8RGlwoUnC5zPoL9HpBcF+CLuz2BmohuypM98MFeIkrudC3fzQTd++Nxo4jMzCjXWj
         wvhgiLGu19cvt0A5HUvdG0v4x9SGQSRPWU/hqfWsPui4AVnyLR91XfduXLi/HFtSYQCx
         IlTm5DygRFl4lp37hBWJkfucQoJRtiy9QIzKr70xThc7vl/+qNgrS4ciTVOMhWaVjVgI
         uoEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EN6ct084o48NExErKXMnp0M0dwlsejuVZ1iLXIP3bUU=;
        b=vLmeA9wi/RiFArrkvkrhFQpeSgadFIPIjYzRwxlqJlUlCrzjxyVik+/wii/MeZQmfr
         tQ5p/9Ek0JG1jxg+1afXqI18eMI5D4oqQgSwGk8rACL4HdXAobESxLsacE5uDOhDS330
         9u8sasv52QNG2O0pOf5ztabErpwHBztXREg8OOoNQ+bb5STQFUCmsg7dUBl92f5e/IAF
         6xdo9B1Uz8W35yQXf6EjvHwhwZVctkrZgXXAAzS7zLCsDa72AIc7rgD/DE45SrBW/Lxx
         AkoFE7bMlvnxTMgRYN3UIZ7VD3qYPavWIy1KiL+sBMEdgS50i92/RyVA5T8Q0oPJXIwx
         sjsA==
X-Gm-Message-State: AOAM532orw4eYmzQ8Lit5tbxWjUzjNF7WZ1aI0QvhXjp5LCQ0lYUbujg
        4XyUMIIOg6Ty+v3PlgdQbzlfz1DKWKwNlM/fxPU=
X-Google-Smtp-Source: ABdhPJxnAvmNYdyPWrQ00kz0ma0OyUCXigt/vTSgGYBpGGYlEO1VlntdKgl3Gno9ftHVLAQI8tHBz33SOZl0ZnOI4v8=
X-Received: by 2002:a17:902:e54c:: with SMTP id n12mr654484plf.78.1643939287197;
 Thu, 03 Feb 2022 17:48:07 -0800 (PST)
MIME-Version: 1.0
References: <000000000000df66a505d68df8d1@google.com> <000000000000d4b6fd05d708ab03@google.com>
 <CAADnVQLjvX54EXbiWC2yXAomypwYoc3MmEdp7fHxG+Zse+83Pw@mail.gmail.com> <Yfwa2qsoDT0+zU7v@lore-desk>
In-Reply-To: <Yfwa2qsoDT0+zU7v@lore-desk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 3 Feb 2022 17:47:55 -0800
Message-ID: <CAADnVQLqwumutNcGK92HpiOQL+kpCPc-jyPoii9OSVOXuyNBEQ@mail.gmail.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Write in bpf_prog_test_run_xdp
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     syzbot <syzbot+6d70ca7438345077c549@syzkaller.appspotmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 10:11 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > Lorenzo, please take a look. I suspect it's xdp frags related.
>
> Hi Alexei,
>
> do you think it is worth to add a test for this condition in
> test_xdp_update_frags()?

you mean instead of 9000 and implicit PAGE_SIZE splitting
allocate explicit PAGE_SIZE * MAX_SKB_FRAGS ?
Yeah. Would be nice.
