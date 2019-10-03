Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B61CB096
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 22:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbfJCU5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 16:57:07 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33407 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728600AbfJCU5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 16:57:07 -0400
Received: by mail-qk1-f195.google.com with SMTP id x134so3844435qkb.0;
        Thu, 03 Oct 2019 13:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bp57aiVPoP/ArarNlq4U/eUFa2mtY+ziQY7Dly9CKtA=;
        b=XEaU6WVAoNoaMzE5jF26Y208agZnDaC/Mtb34NvHfq5gLxwJL+BkztzJl82rbEbZgA
         +LYj4N6kkLoe3lhR3wAcoHNJYvzgj0OVM1LhkV2+mM+PMegEZgsklMY0Lr/qlr/TCy9r
         lRFz9vF5v9nH/N4kiPc3fnwMQkBTNcNgB63ZBRaI4Ssu/upuBwWKmzj1QVj5tmFwLUUL
         ajnCd5DO4m4vzQ40yTTemj8OM5uDK4SErGhDp40vh3mPw64Wkq0uu5H8saFIpBDmfx2G
         YMS+lPu3d0NP+Qc5TKX/if/kH2Eg3UYA175RAxt7B/IWPLYkS1wxggvSFV/9gIKXm0RU
         dg6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bp57aiVPoP/ArarNlq4U/eUFa2mtY+ziQY7Dly9CKtA=;
        b=ueZhtJZP2cqcDHPrnCBpLLph8MgSwhZuOYBGlShpF/NTIZ/pHEHEV/9n4HqedDoBfT
         STu8D3g1Ll63JZL3yrFLzSoGGKaAS4fvdN0VOuXtUS0RcWaTuLhW5HzdQmpiyr2SBBBo
         F3/zzsuWDWs57gdyWNC32QpFAaIxHbN/wjJtgyymo6rue+ajHRSXDFDwEH26gw00xBJc
         v4stCXx8GmdAThEu8eGGyxF/KJ8orW3ERP0Him5uIVz+7MSw3Nw+1I6qbDiINMrMD3iQ
         mepsKn5B3G1rgxmH4PtFmmvaGd9ASeNMneK5pAfBMcApQ8nbbu3+bITi9dwCeWGnjI9t
         Ms7Q==
X-Gm-Message-State: APjAAAWQ8ja0YPY/Kj+d8GR56f0wrPKz29taVpJiLgDn77wzeFSxKbnU
        lJ0ityBEWyg2RdWs1Box4CrEtkC5pk5tE4V4kIs=
X-Google-Smtp-Source: APXvYqz/DqBXRpd/AGAchrTryaQgtTR6yCMcHPgG8vs8W0eES8536bJuxlv3V2bAxKBuS3nGN1jR10T8m1bhqwLKQQ0=
X-Received: by 2002:a05:620a:113a:: with SMTP id p26mr6643276qkk.353.1570136225160;
 Thu, 03 Oct 2019 13:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191002234512.25902-1-daniel@iogearbox.net> <20191002234512.25902-2-daniel@iogearbox.net>
In-Reply-To: <20191002234512.25902-2-daniel@iogearbox.net>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 3 Oct 2019 13:56:53 -0700
Message-ID: <CAPhsuW6oGoBK28JyY3r6a+fzesqa8c7Zki+z33XXV2AS6=JVwQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: Add loop test case with 32 bit reg
 comparison against 0
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 5:30 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Add a loop test with 32 bit register against 0 immediate:
>
>   # ./test_verifier 631
>   #631/p taken loop with back jump to 1st insn, 2 OK
>
> Disassembly:
>
>   [...]
>   1b:   test   %edi,%edi
>   1d:   jne    0x0000000000000014
>   [...]
>
> Pretty much similar to prior "taken loop with back jump to 1st
> insn" test case just as jmp32 variant.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Acked-by: Song Liu <songliubraving@fb.com>
