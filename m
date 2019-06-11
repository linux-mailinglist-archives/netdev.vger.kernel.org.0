Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7EDE3D3BF
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 19:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405952AbfFKRQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 13:16:50 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:46582 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405476AbfFKRQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 13:16:50 -0400
Received: by mail-pg1-f178.google.com with SMTP id v9so5605688pgr.13
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 10:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NP0gA1ABckvdSxnswrfwtyDrSN1dU2orYg+qwnAaWU0=;
        b=fCnawsruKXMsyZtdZkLLbAjxXjcWO7UUBt6Go6jNPSUFC0x6uMTddfjQjosUqRo3cO
         Jc0jXjHQrSrU42XNdeRKNRnGLYlRL4ojHXgGpbQbQ2qKmZdFzo/4AHYalAdrhYHi7C3U
         DIE8zAxwbLxyv3krKFvNGd5ECXkYPMKwYaTKLgpvNZ29I7kb9E+A7gnrB2sDf9UTInwx
         bGNgHFFd2sThfwGOP0ESd+1aNMgcut0JC8e11UOnxvAr+PmZX4AE8NB21aH/ZEZeYhZX
         oJWJJ0nyehTcFjqj1YeRUYHo64MDB75LhR3TZucrAmzzKZMykDbkrd4HHajGzSZKqdPB
         BAog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NP0gA1ABckvdSxnswrfwtyDrSN1dU2orYg+qwnAaWU0=;
        b=cS8tQQo2FZWldu+5x8N0XbGl4hG6hRhejtr2US+dZBC31JsjduwnYh07t2P9CVdvzl
         U70xoPCyYptb2Fx2bV0zlKFY3aNsXiIqVuQ14htqxJTGviqEge+JJP3uR1dibh6zRB5t
         NY+C69hfJTzlO8HMYjHBCPKnFqIPEpcHCjqwQ9dR3ElHPGphBX3g4DEoQeQ2TMKraj0+
         28y0WVHJRT+U5kU19RXinW9eFIwnRmFRhgzGMK8/S9rdqncmZcdbYWbJSOnRHKQiYAN7
         C9UvGc86/QMyZ3/NRPiUnO9dlzgnztOMaXmq7KcpTrCqgiOswrGXXOW8XEquwFBjG+pe
         cTEA==
X-Gm-Message-State: APjAAAURb3LO8cLDeR57Gx7bnBQYeE+ASn3SpT/+qzkyfR9Qnp2PDvLJ
        jtpWkc4YD7YHT43UCYJkpOTzlg==
X-Google-Smtp-Source: APXvYqxtEattJ3/+CA3rv8tUikfccZabdw+tyfqO2UmRi4gT3U9+ViUAnX/16vxoTmntuqCAWtc2sg==
X-Received: by 2002:a63:4813:: with SMTP id v19mr14934308pga.124.1560273409434;
        Tue, 11 Jun 2019 10:16:49 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j37sm13040375pgj.58.2019.06.11.10.16.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 10:16:49 -0700 (PDT)
Date:   Tue, 11 Jun 2019 10:16:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+06537213db7ba2745c4a@syzkaller.appspotmail.com>,
        aviadye@mellanox.com, borisp@mellanox.com,
        Daniel Borkmann <daniel@iogearbox.net>, davejwatson@fb.com,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        bpf <bpf@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
Subject: Re: memory leak in create_ctx
Message-ID: <20190611101644.267d8e9c@cakuba.netronome.com>
In-Reply-To: <CACT4Y+YX4biKo1nEKh32pJoS9ANNV06hQp5=+w+3GpWQB1worg@mail.gmail.com>
References: <20190609025641.11448-1-hdanton@sina.com>
        <CACT4Y+YX4biKo1nEKh32pJoS9ANNV06hQp5=+w+3GpWQB1worg@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 13:45:11 +0200, Dmitry Vyukov wrote:
> Do you see the bug? Jakub said he can't repro.
> The repro has these suspicious bpf syscalls and there is currently
> some nasty bpf bug that plagues us and leads to random assorted
> splats.

Ah, must be the BPF interaction indeed :S The reproducer text uses
incorrect names:

bpf$MAP_CREATE(0x0, &(0x7f0000000280)={0xf, 0x4, 0x4, 0x400, 0x0, 0x1}, 0x3c)

# ^ this is a map create SOCKMAP

socket$rxrpc(0x21, 0x2, 0x800000000a)
r0 = socket$inet6_tcp(0xa, 0x1, 0x0)
setsockopt$inet6_tcp_int(r0, 0x6, 0x13, &(0x7f00000000c0)=0x100000001, 0x1d4)
connect$inet6(r0, &(0x7f0000000140), 0x1c)
bpf$MAP_CREATE(0x0, &(0x7f0000000000)={0x5, 0x0, 0x0, 0x0, 0x80}, 0x3c)

# ^ another map create (perf event array?)

bpf$MAP_CREATE(0x2, &(0x7f0000003000)={0x3, 0x0, 0x77fffb, 0x0, 0x10020000000, 0x0}, 0x2c)

# ^ but this is MAP_UPDATE, not MAP_CREATE, it probably inserts the r0
#   into the map

setsockopt$inet6_tcp_TCP_ULP(r0, 0x6, 0x1f, &(0x7f0000000040)='tls\x00', 0x4)


That threw me off.

> I've run the repro as "./syz-execprog -repeat=0 -procs=6 repro"  and
> in 10 mins I got the following splat, which indeed suggests a bpf bug.
> But we of course can have both bpf stack overflow and a memory leak in tls.
