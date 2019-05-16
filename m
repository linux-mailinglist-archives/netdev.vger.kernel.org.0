Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7339A20EBE
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 20:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfEPSfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 14:35:15 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40257 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbfEPSfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 14:35:15 -0400
Received: by mail-lf1-f66.google.com with SMTP id h13so3415107lfc.7
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 11:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=24KEV7AvuVgPUW6kF7Ly1e4ed97PWgChHQxd5CoaBlY=;
        b=ZC8lE5+94i1w47wzG/UXF0CByrlxXgvHjzhXd66NeA8jUYFY8HnPCG8xlgcipvxhMK
         +donu2A5M2fZnxxsvNHhG2YivKbOsuVC5/x+8hMFj+gHt8o0h+WHI+GcfzXb+qbTWObA
         JHZ1Ib/phlGbQ61qVNAI6+6rH4cXZky1GCZgtnHoJUJQLq18uMKPNJ5AZdrj5AagcBTG
         xyGOhoybe1R2xMzeGT+t1qTYyhKvQupYyT80HNBg7WNfjRlyLVfQ5R0grbSkJ2LBR9c4
         WjvArAumQ8/k43J7IIl2AqtHW1LjsHPd78H38WTZj5cXchJxpnPsZTli2uTnh+eUtGvz
         XLvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=24KEV7AvuVgPUW6kF7Ly1e4ed97PWgChHQxd5CoaBlY=;
        b=NTft/ZROZm6eHyh3WrRx94Bt8/u84uAyLXYp1lciJxHtFLuub7p8xk9xVBFMNtwfuS
         UzHnmrIvbjKXr3kOIQ6Le7gbU6Bw8U0QhIO2llKAgKxpP0HDcKOQGgALU2HNhZGgVJ2k
         J+ARnqJFLpMT37Ow5w4MH025HHoN8bUjiNV7CPdo7bGjpxbpd+d52dyfLfyv/AQKSgXP
         Rvrf+MWlcaYFc3B7BvHmIMrrXIPe9T0pyH4K0wz9/eaN/bRJ6fiZdFzmc8WifE39gSEx
         BORJh8lE+QJY5AczuJzeoLnAncxiH8ZPNBacTqJYsvJPUVNIWVFHJAQ8DGpYz4YvIGQm
         uAtw==
X-Gm-Message-State: APjAAAWPAbhWCieZAOO36AkG4Dra146NdU5QJ66E6IxhZfheNcZfBDCV
        hRkpwZ5WxpqIbnX9r51Em/e0ZlTGtbG01LtjCIWIdw==
X-Google-Smtp-Source: APXvYqzUd8B1jCrE7Zp2IuCO9DNvFpYODPgs/L/s4jcCdfEdZFlUe1EweJewrqwJ4RYGSmakTJjuKxBmnDnm81x5cD0=
X-Received: by 2002:a19:81d4:: with SMTP id c203mr24913287lfd.160.1558031713959;
 Thu, 16 May 2019 11:35:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190515024257.36838-1-fengc@google.com>
In-Reply-To: <20190515024257.36838-1-fengc@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 16 May 2019 11:35:02 -0700
Message-ID: <CAADnVQJ6Ezugas2OE1UqMHJP_L-G0LEt1KFCYPE5xLFmF+BXLw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: relax inode permission check for retrieving bpf program
To:     Chenbo Feng <fengc@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 7:43 PM Chenbo Feng <fengc@google.com> wrote:
>
> For iptable module to load a bpf program from a pinned location, it
> only retrieve a loaded program and cannot change the program content so
> requiring a write permission for it might not be necessary.
> Also when adding or removing an unrelated iptable rule, it might need to
> flush and reload the xt_bpf related rules as well and triggers the inode
> permission check. It might be better to remove the write premission
> check for the inode so we won't need to grant write access to all the
> processes that flush and restore iptables rules.
>
> Signed-off-by: Chenbo Feng <fengc@google.com>

Applied. The fix makes sense to me.
