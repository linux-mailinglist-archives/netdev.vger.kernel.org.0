Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9312E131A3
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbfECP7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:59:13 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41544 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfECP7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:59:12 -0400
Received: by mail-lf1-f65.google.com with SMTP id d8so4750411lfb.8
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 08:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3o/o9Wc+i05gWUMl12G5TQaFi1wWViaqL3LXw2ZdFpY=;
        b=E5KHFL7JKyhLxr+v+dvhVFHhEncfjQXeBwdl7UM821+nj9BKH9ZE0DPTDqWuEc62Ng
         YOsj29kX9oZDDPoj8zTSEZEtLQPOypDn96D8Try4NSNf1iYNP30hZoDS9bXp7D1CrX3p
         yy+hG2NRG/1DJx7WbV09vGeg00SdP4ialPZJQ+whe1TSSw9oAlng2GHaXHaJNJAWTg8i
         6fWsdmgr+/2SkdWbtAjcNlXiUTacP5khbttmPxILSGRImE4WOkZUmHhgNa/+UF2bR2I2
         OwbVn/Re35QxbfOlCdgH1jiB9lQ8CWatlnPI2D+2XgMpO6HkueBdtEXMlfDmI45Lec/H
         UyLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3o/o9Wc+i05gWUMl12G5TQaFi1wWViaqL3LXw2ZdFpY=;
        b=gohHpcV2aHg/3WrPGoAFZjis2W3c0dRvzKXl82Oj5uOkRvapqbn6AT1fb+5ri3HNDO
         2g6d9w6sbuibLoDqe0Zrm2ZUcijOfPEGqLF1FCM3PIS8YwdB4a70br3SaB4z/xLlEYGO
         FGe2x7xExfKjwNr6ChT/7fnSDRaBxT/6YuSliGBW2xdDDof3C5rO74yIt3mKQphIR3M+
         LslmYSAASLZePT0s6CL46nM92QhjrVAx1oKANmg8RuoR6PLQ8lBCf5xIpliMr4DMtu3p
         s7ORjHwwcpfsrSliEi/QtwnT3BYC15aSSZcv1O++dZhmbh0e1d8zTBtbMDAwmQKnD0Cf
         CSzQ==
X-Gm-Message-State: APjAAAUxl1JJLXstL9vmrPCuNnYolKJc3bz3Ql9kKEv1hUQzvnvYs8Ru
        0+oag6vX5o0slV+frqBGl73ShhDPuz/gIUGppXVmzw==
X-Google-Smtp-Source: APXvYqymSUn9yTJAChRfDC3jj7CeSLXTk/1MrgAExZsZ/PYG35j9MYvmpBBKIpdfhK/p9hW+qHN5ngpdmfiXdiKqT4Q=
X-Received: by 2002:ac2:596f:: with SMTP id h15mr2629686lfp.18.1556899150572;
 Fri, 03 May 2019 08:59:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190503114721.10502-1-edumazet@google.com> <CAPNVh5c-xeSaRkQgFtFUL1h3u0DpEozBXDP+xf-XEvXKbDgCYg@mail.gmail.com>
 <CANn89i+cRBCg=7Q4W45z9HuwJoCHspMNRKZJw9ztigjUDryY7w@mail.gmail.com>
In-Reply-To: <CANn89i+cRBCg=7Q4W45z9HuwJoCHspMNRKZJw9ztigjUDryY7w@mail.gmail.com>
From:   Peter Oskolkov <posk@google.com>
Date:   Fri, 3 May 2019 08:58:59 -0700
Message-ID: <CAPNVh5c88ZSAuhjdpf6_AULufZqjSkjWB7W8tguKzRTwYJbTWA@mail.gmail.com>
Subject: Re: [PATCH net] ip6: fix skb leak in ip6frag_expire_frag_queue()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stfan Bader <stefan.bader@canonical.com>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 3, 2019 at 8:52 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, May 3, 2019 at 11:33 AM Peter Oskolkov <posk@google.com> wrote:
> >
> > This skb_get was introduced by commit 05c0b86b9696802fd0ce5676a92a63f1b455bdf3
> > "ipv6: frags: rewrite ip6_expire_frag_queue()", and the rbtree patch
> > is not in 4.4, where the bug is reported at.
> > Shouldn't the "Fixes" tag also reference the original patch?
>
> No, this bug really fixes a memory leak.
>
> Fact that it also fixes the XFRM issue is secondary, since all your
> patches are being backported in stable
> trees anyway for other reasons.

There are no plans to backport rbtree patches to 4.4 and earlier at
the moment, afaik.

>
> There is no need to list all commits and give a complete context for a
> bug fix like this one,
> this would be quite noisy.
