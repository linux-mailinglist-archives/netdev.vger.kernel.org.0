Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0042D84D8
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 02:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbfJPAcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 20:32:03 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:43756 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbfJPAcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 20:32:02 -0400
Received: by mail-qt1-f173.google.com with SMTP id t20so28153132qtr.10
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 17:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=YPGifKmHSiXO47bvZWE4xIDUkFQiKzQ+ay2ENUH2BTY=;
        b=rVecFe7Yg0Ek5r3F6WtYuUQz8eMI6ssw6S4uk2jiRtYzyLtMMtaiNlJ+mgPSq3TMep
         O1BmzBW5X4bJb+hFaT60bjfL0Os3RWyjiU+jBXHuxPoDDHf8sX5zjE/j2Q3LUxMkqtlK
         kQzLnuDja43nrbPjUj8AkB0AbxABwuMeAK+OYj+SiQoPj19ofGUIfDXos0oNovH9QGsd
         kYijX4XJXBlp/yZ7RkM/uV5fhH2hdMQ7Gdj5JQxprd7Ig5sGksQKy8H033DPVhOOuSFw
         dXMwzVjjr4Gf65uG2Yq/Myg60t0xd2uUUZm3+w7NP+eMwaOP3/tGcjDFNiHQHLAFFsrr
         Rsow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=YPGifKmHSiXO47bvZWE4xIDUkFQiKzQ+ay2ENUH2BTY=;
        b=rMlPO7dHqu/5tV9Ta+0svBZ4ft8syvtSlhUI1/k12pnaUO1CAc22QAL4qdyYZPObQE
         FsQHpTExUS8PTrtaDNry6O98cvj2nrfJV9SrUY9McmiOzSiMn/zJFUyuF0o826JUxLRi
         2g3ofivLkIqenNN0b6TGRv8S5zOkS/yNzVS5NOwijn+09oShUYts5e64lpm5Xcol06qv
         j6lJrxfd/jrNV1nzBasyYlaxcFCt83MOwFArIfRkzb5A77UTqfdy65Pjn0Mh1qYh/QGZ
         qHjGzk/rDFgiRY1S9NaNYVEDXlVJy2v8zhsB+VTZ61R2U96ZXjVzna4i65lo712dLfZ7
         JhLA==
X-Gm-Message-State: APjAAAWJNzT+ud/g2GNIpwWkUHntu3tqK9HwESzoJdI8la2E8Suk0j5w
        zoNWkMFbBa5HD3eGJRbd6d/M5lKTDIaPQBh0UPZbvovI
X-Google-Smtp-Source: APXvYqyQjnw9N380Ce4/Ue0mUJSO4fsdQP1e6Wu4tAhB8GY9p7G5bEBkTm/1ANks4ATv8Ze1xhXeJf/nnojjZNiBT6s=
X-Received: by 2002:aed:23b1:: with SMTP id j46mr43007971qtc.188.1571185920129;
 Tue, 15 Oct 2019 17:32:00 -0700 (PDT)
MIME-Version: 1.0
From:   Rajendra Dendukuri <rajen83@gmail.com>
Date:   Tue, 15 Oct 2019 20:31:49 -0400
Message-ID: <CAN1eFqgZQ4exQSbZVk+dPMQHEjD87Q7C5C5ADqgD_-0_rZ7GDg@mail.gmail.com>
Subject: Crash in in __skb_unlink during net_rx_action
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Observed below kernel oops on "Linux version 4.9.0-9-2-amd64" from Debian 9.

This was observed when bridge vlan netdevs were getting deleted while
packets were being received. I observed this only once, but wanted to
put it out there for the record. Below is the decoded call path. It
appears to be in the elementary pkt handling function. I searched for
upstream commits for any patches around this code but could not find
anything. Any thoughts on what it might be about while I try to figure
out the test case to simulate the panic condition again.

process_backlog()  ---- __skb_dequeue()  --- __skb_unlink()  --
next->prev = prev; (Panic)


[12106.283243] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000008
[12106.292014] IP: [<ffffffff9ab1265c>] process_backlog+0x7c/0x130
[12106.298643] PGD 0 [12106.300691]
[12106.302356] Oops: 0002 1 SMP
<SNIP>
[12106.456408] task: ffff8a0aad1ed140 task.stack: ffff950741980000
[12106.463027] RIP: 0010:[<ffffffff9ab1265c>] [<ffffffff9ab1265c>]
process_backlog+0x7c/0x130
<SNIP>
[12106.584667] Call Trace:
[12106.587403] [<ffffffff9ab11df6>] ? net_rx_action+0x246/0x380
[12106.593827] [<ffffffff9ac1e81d>] ? __do_softirq+0x10d/0x2b0
[12106.600152] [<ffffffff9a69d560>] ? sort_range+0x20/0x20
[12106.606090] [<ffffffff9a67ff5e>] ? run_ksoftirqd+0x1e/0x40
[12106.612318] [<ffffffff9a69d66e>] ? smpboot_thread_fn+0x10e/0x160
[12106.619130] [<ffffffff9a699dd9>] ? kthread+0xd9/0xf0
[12106.624776] [<ffffffff9a699d00>] ? kthread_park+0x60/0x60
[12106.630908] [<ffffffff9ac1aeb7>] ? ret_from_fork+0x57/0x70
