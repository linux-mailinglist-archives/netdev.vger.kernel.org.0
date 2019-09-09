Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF205AD60B
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 11:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390012AbfIIJsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 05:48:40 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39459 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728780AbfIIJsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 05:48:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so13076787wra.6;
        Mon, 09 Sep 2019 02:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a6wvOg7fIlbqK8IjGTT61M8qMgTdSFY/62MhioXnnvk=;
        b=I76+uX3UaaeFwRMicmaNEb73kibZ6MxG0CH6BvDGug79V8TLbh/dt2onXnp5gLuzuW
         nrDO9YCdI9dENNNCETlsenpUisyPp36o7mYOMfHIP6h6cDXATjtorpFVFJGDoSi58FAQ
         kWwUBsILrBxDL4xOUJsvIiEQOGhvWMtPft0ybEzWyi1ZTnSyqntUKBwR2M3CT7yMEBX+
         KP40E8SEUuNIky6x6IPV22WhAkRc2h/w6Tk7ORY1js2VJfT2pDbVucFseIdzVHBjt+Lz
         ChMHs1EboyLkoCtiH/tjUabxPO09HPby8+gX26ZZ+FL99ljrqPNon3Hobb7C0o4SMmSo
         wXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a6wvOg7fIlbqK8IjGTT61M8qMgTdSFY/62MhioXnnvk=;
        b=BWq/xIdjMzPbrYx9OAZWpkoI+EcoXaAUuCTG9ntOU6TyL97K0X8wkQSeTeHy5712Ce
         QSFDb8ueX7YsQYPIIi5PD7IMLrth775dbmHerE6cjpEu4OGjDKv9lfRrY5H5Xqe0CHEA
         sKwEPBbwEXCB1dtGFAFEvBtkgelin6KsFXH2KCgpLs8YT46dBpftoCBhfgXWe6WJh23X
         3VP7JhRWixRppbf0dt9sfPovbX1dBi+/mx+3qci+myD+PsLUfLQIiu3UD1LjD4kkZTAV
         DkxwEku+3f+6eBpWtyxC/1mcSXIWSFsj+kU7RvXQbjdfaJdP8r5Vr+BHI8BTOTyn1HAz
         czlA==
X-Gm-Message-State: APjAAAVGB6a126nDDDr9kwqW+4Ao+AtnTY5OXyIWSBR9OJ5phiryB06b
        qmRdVnDnTESpxdxTL0t/1yBUCnQdUrTWKau+valUhZHUU1Y=
X-Google-Smtp-Source: APXvYqwCXP+qbeJAlUt+X+Ogbxyqdy/MdC/qyT1GjhkoOc064s1LGfxNPM25GRZDKfUAujchcDc4gArN3Ok95B8WdT4=
X-Received: by 2002:a5d:628f:: with SMTP id k15mr3643725wru.124.1568022517638;
 Mon, 09 Sep 2019 02:48:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190822195132.GA2100@bharath12345-Inspiron-5559>
In-Reply-To: <20190822195132.GA2100@bharath12345-Inspiron-5559>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 9 Sep 2019 17:48:25 +0800
Message-ID: <CADvbK_c5+1-qDohRtFap25ih6XoAD3JirUz-impy7jvNZYpdvg@mail.gmail.com>
Subject: Re: net/dst_cache.c: preemption bug in net/dst_cache.c
To:     Bharath Vedartham <linux.bhar@gmail.com>
Cc:     davem <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        allison@lohutok.net, tglx@linutronix.de,
        network dev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jon Maloy <jon.maloy@ericsson.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 3:58 PM Bharath Vedartham <linux.bhar@gmail.com> wrote:
>
> Hi all,
>
> I just want to bring attention to the syzbot bug [1]
>
> Even though syzbot claims the bug to be in net/tipc, I feel it is in
> net/dst_cache.c. Please correct me if I am wrong.
>
> This bug is being triggered a lot of times by syzbot since the day it
> was reported. Also given that this is core networking code, I felt it
> was important to bring this to attention.
>
> It looks like preemption needs to be disabled before using this_cpu_ptr
> or maybe we would be better of using a get_cpu_var and put_cpu_var combo
> here.
b->media->send_msg (tipc_udp_send_msg)
-> tipc_udp_xmit() -> dst_cache_get()

send_msg() is always called under the protection of rcu_read_lock(), which
already disabled preemption. If not, there must be some unbalanced calls of
disable/enable preemption elsewhere.

Agree that this could be a serious issue, do you have any reproducer for this?

Thanks.

>
> [1] https://syzkaller.appspot.com/bug?id=dc6352b92862eb79373fe03fdf9af5928753e057
>
> Thank you
> Bharath
