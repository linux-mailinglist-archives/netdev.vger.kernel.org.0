Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B3A1B5408
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgDWFOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:14:20 -0400
Received: from mail.fudan.edu.cn ([202.120.224.73]:47856 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725562AbgDWFOU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 01:14:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=Okr1Fx61CqRQHqsqacwoHRH3hW6+tUVcDNggnI32oKg=; b=d
        0l07vLQn/iqIHGeiIzIqKWM8kBpWhg+MvdHKY7v2EDcF//Hk5oALYOkfSecRVwXi
        FsCN01XQfR2iXyb48Hjgcx7k7BCS987yXBbVspQOYy2zLuzHjz41y7qvpMxFTEQt
        umM+TVg/Asdy1G+6CzsI/zM/gCxYkxfIWs/OjjoBzo=
Received: from localhost.localdomain (unknown [120.229.255.80])
        by app2 (Coremail) with SMTP id XQUFCgC3UgkbJKFe17NPAA--.25232S3;
        Thu, 23 Apr 2020 13:14:04 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH 1/2] net/x25: Fix x25_neigh refcnt leak when x25_connect() fails
Date:   Thu, 23 Apr 2020 13:13:40 +0800
Message-Id: <1587618822-13544-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XQUFCgC3UgkbJKFe17NPAA--.25232S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZrykKr4DtryfGrWDtry3XFb_yoW8JF4kpF
        Wak393XFyrXF1UXFs7Aw4kWFy0yw4DXr18u348Ca4rA34DW345Aw4FgFs8XF17ZFZ5Ary7
        WrWj9rs8uan8Ca7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9K14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
        6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVW8WwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAv
        wI8IcIk0rVW8JVW3JwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
        v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYR6wDUUUU
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

x25_connect() invokes x25_get_neigh(), which returns a reference of the
specified x25_neigh object to "x25->neighbour" with increased refcnt.

When x25_connect() returns, local variable "x25" and "x25->neighbour"
become invalid, so the refcount should be decreased to keep refcount
balanced.

The reference counting issue happens in one exception handling path of
x25_connect(). When sock state is not TCP_ESTABLISHED and its flags
include O_NONBLOCK, the function forgets to decrease the refcnt
increased by x25_get_neigh(), causing a refcnt leak.

Fix this issue by jumping to "out_put_neigh" label when x25_connect()
fails.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index d5b09bbff375..e6571c56209b 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -816,7 +816,7 @@ static int x25_connect(struct socket *sock, struct sockaddr *uaddr,
 	/* Now the loop */
 	rc = -EINPROGRESS;
 	if (sk->sk_state != TCP_ESTABLISHED && (flags & O_NONBLOCK))
-		goto out;
+		goto out_put_neigh;
 
 	rc = x25_wait_for_connection_establishment(sk);
 	if (rc)
-- 
2.7.4

