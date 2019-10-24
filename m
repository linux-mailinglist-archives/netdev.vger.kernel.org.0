Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFBE0E331C
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 14:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502202AbfJXMxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 08:53:24 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44916 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502191AbfJXMxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 08:53:24 -0400
Received: by mail-ot1-f65.google.com with SMTP id n48so5601281ota.11;
        Thu, 24 Oct 2019 05:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iLUdayC1zl/A71isLCny+Z1Qkj5ghZH/Yn9ahtTVvRA=;
        b=dVR4ac4VrRYtlXkGqUqO1Eat2FSFFubXhmsJwduZgw5eXmuFUmJvfXtZDp4xGBmUi1
         G32ArzXx8HnI+0H7LX+ElVxTNizz4o+uJt+SXkE0UHDKK2qbqmqEcH56oTnBUa2dtbcr
         EogZKcUH2r5GYYraPuNuoKU9DzFv92/pbj9eRGr7XYsuo4J3rgJVdt/oqdR9QwkeDpBH
         R1kXcYQ0wwZmLJMBo/d5wNxoZhq6Bqn6UQneHOvXiwde4UMh3ksftpnybc+nVMyGR3lK
         BzO+3fKDIigbBN61S9Z3w/MBmZhhQ1UcyuHl//mLzmJIpMjwAi8lei53A4pejwAWWvze
         i6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iLUdayC1zl/A71isLCny+Z1Qkj5ghZH/Yn9ahtTVvRA=;
        b=nahb+STzdNiTIlS4Rbcz/1ueVbzAPq19AWugVgxeq46OUdxtE/SNU7o1ssvpngbz8t
         T9CU++EXqUU60N8zrAxeYzcTeslLDcaN67gh8fd+p5HWconYR9qS+bnF0VgyCfBtJYmD
         9yCi7eMbSp7dS4VL4BQ/8e4rpQ2Jb5LjqK8rz/yI0Re2YOuO18I1aBSJx6T8PI24fiDj
         iKo6t1Jb8wkbcDHhKegxVF5k1yYqbv8PxsNZ8sN+CUKsmvc1d0r3FMZqaR/IlGf/4Jbw
         az228sqPDl95RpZuxKl8PTunut9kUUZ6WZCHAs92mUT9To1lWT59MwLMWsCHJKZ/aQ3V
         s24Q==
X-Gm-Message-State: APjAAAWSfXBRZq6Rm+T8wIKr2DphjVUaiqL70TcvB7rDfTbt3W8AoQ88
        2SaHSHX3zOUki2W4hFU8vtLgSJX425mdZ1nyGoc=
X-Google-Smtp-Source: APXvYqwr1zO7v3Xyinzs9OZoZjfQgjDfEuqNcfbY28COpLbGRAK4iXjZ3A1DurXICx0+wPvcpd1vuAynlQFm45PZvr4=
X-Received: by 2002:a9d:286:: with SMTP id 6mr11758074otl.192.1571921601960;
 Thu, 24 Oct 2019 05:53:21 -0700 (PDT)
MIME-Version: 1.0
References: <1571645818-16244-1-git-send-email-magnus.karlsson@intel.com> <B551C016-76AE-46D3-B2F5-15AFF9073735@gmail.com>
In-Reply-To: <B551C016-76AE-46D3-B2F5-15AFF9073735@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 24 Oct 2019 14:53:10 +0200
Message-ID: <CAJ8uoz2FDkygCG5myz_OzAPHSiCPGR1Y-OHEi6xNjQEHoAia8w@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: fix registration of Rx-only sockets
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Kal Cutter Conley <kal.conley@dectris.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 12:47 PM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> On 21 Oct 2019, at 1:16, Magnus Karlsson wrote:
>
> > Having Rx-only AF_XDP sockets can potentially lead to a crash in the
> > system by a NULL pointer dereference in xsk_umem_consume_tx(). This
> > function iterates through a list of all sockets tied to a umem and
> > checks if there are any packets to send on the Tx ring. Rx-only
> > sockets do not have a Tx ring, so this will cause a NULL pointer
> > dereference. This will happen if you have registered one or more
> > Rx-only sockets to a umem and the driver is checking the Tx ring even
> > on Rx, or if the XDP_SHARED_UMEM mode is used and there is a mix of
> > Rx-only and other sockets tied to the same umem.
> >
> > Fixed by only putting sockets with a Tx component on the list that
> > xsk_umem_consume_tx() iterates over.
>
> A future improvement might be renaming umem->xsk_list to umem->xsk_tx_list
> or similar, in order to make it clear that the list is only used on the
> TX path.

Agreed. Had that exact name in my first internal version of the patch
:-), but that rename touched a lot of places so it obfuscated the fix
and therefore I removed it to make it clearer. But I can submit a
patch with the rename to bpf-next.

> >
> > Fixes: ac98d8aab61b ("xsk: wire upp Tx zero-copy functions")
> > Reported-by: Kal Cutter Conley <kal.conley@dectris.com>
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>
> --
> Jonathan
