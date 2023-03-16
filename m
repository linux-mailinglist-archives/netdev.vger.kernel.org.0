Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B166BC31C
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjCPBKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCPBKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:10:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4929C22DD6
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m13-20020a25800d000000b00b3dfeba6814so196935ybk.11
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678929020;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NfFvt9JZGA5UC/xqDV44zP+BrJxbG4GDQBAAsyoUR0I=;
        b=HazYNkhGW0kV8CxoFPrgs/ArTI+aUw1gPdeX1tdM8xziiltsZrYl1eKQk3qrAJenpg
         IxD35oL3VIXQA1CXcMAz92MO7oTIdjQBT/MjoLHQEctvnI2hB5G5AjWFn+QOQD60RQp6
         CD9FZg+gmSY10bARisl+N2sS4OjE40fXowq6fEXBAEZcgr5TpAhrdZDEO+H8EBjYS/CK
         l3CVM0oak6zvbFk2+vvx4zUd4/uF6Unb7G9aDCL8bY4AvDNBKT5RF5K5xw5doZjdc8pd
         lD9eNaZwz9Ax9DRrePiaK8p+SuROntUf1YbASmgI/uDiqx916AaAL2GY0cOYs4iyMcqX
         XCxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678929020;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NfFvt9JZGA5UC/xqDV44zP+BrJxbG4GDQBAAsyoUR0I=;
        b=FHqsO4j1oxMyReoL6aha3yFbYPH7gp9o1p4nvO8qzHmqnJ4ogxj95pLLN6vlul8NHJ
         OSGvdUS4XlENLoziRXwuUOywAqRmiozxlIm4uZDLVgHXeUdSpkKSgcLmD8DjxSRyr46a
         exRm10tZIUqIHr9/PHchqN/kpeoHbNaQveUkSDc8aWoA9/g8FhGyGJQfwwBYIi06628Z
         grzzrnc+WTON3UR0nFqEysxrzwdRk25auRpTmM8bIwAratvAcOq1RwwxEzDt9FkSHXn1
         LN/fVKKscX+RaARH3kyIKutjEEkWyYZ5+YDE6yYvvpT6Z8EkUYzePcFzFlyipE8Rq6Mn
         XaaA==
X-Gm-Message-State: AO0yUKWcRJSInskrrJvuZL6RwXZW+muT76qL4+8pv+y5saohYRofKpgb
        9PrCunNFmUFleFTXKn9TJQUB18kdHzqDjA==
X-Google-Smtp-Source: AK7set+nolwTyI60DU+id/JMrfpD2KfUOjSVtd11KTBz4Mdlda0QxXPG2ka0Ii69Oi/MgoE9A2jgwoSa31I/jQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:8f82:0:b0:b39:be7e:30c8 with SMTP id
 u2-20020a258f82000000b00b39be7e30c8mr7914307ybl.2.1678929020554; Wed, 15 Mar
 2023 18:10:20 -0700 (PDT)
Date:   Thu, 16 Mar 2023 01:10:05 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316011014.992179-1-edumazet@google.com>
Subject: [PATCH net-next 0/9] net/packet: KCSAN awareness
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is based on one syzbot report [1]

Seven 'flags/booleans' are converted to atomic bit variant.

po->xmit and po->tp_tstamp accesses get annotations.

[1]
BUG: KCSAN: data-race in packet_rcv / packet_setsockopt

read-write to 0xffff88813dbe84e4 of 1 bytes by task 12312 on cpu 0:
packet_setsockopt+0xb77/0xe60 net/packet/af_packet.c:3900
__sys_setsockopt+0x212/0x2b0 net/socket.c:2252
__do_sys_setsockopt net/socket.c:2263 [inline]
__se_sys_setsockopt net/socket.c:2260 [inline]
__x64_sys_setsockopt+0x62/0x70 net/socket.c:2260
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffff88813dbe84e4 of 1 bytes by task 1911 on cpu 1:
packet_rcv+0x4b1/0xa40 net/packet/af_packet.c:2187
deliver_skb net/core/dev.c:2189 [inline]
dev_queue_xmit_nit+0x3a9/0x620 net/core/dev.c:2259
xmit_one+0x71/0x2a0 net/core/dev.c:3586
dev_hard_start_xmit+0x72/0x120 net/core/dev.c:3606
__dev_queue_xmit+0x91c/0x11c0 net/core/dev.c:4256
dev_queue_xmit include/linux/netdevice.h:3008 [inline]
neigh_hh_output include/net/neighbour.h:530 [inline]
neigh_output include/net/neighbour.h:544 [inline]
ip6_finish_output2+0x9e9/0xc30 net/ipv6/ip6_output.c:134
__ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
ip6_finish_output+0x395/0x4f0 net/ipv6/ip6_output.c:206
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip6_output+0x10e/0x210 net/ipv6/ip6_output.c:227
dst_output include/net/dst.h:445 [inline]
ip6_local_out+0x60/0x80 net/ipv6/output_core.c:161
ip6tunnel_xmit include/net/ip6_tunnel.h:161 [inline]
udp_tunnel6_xmit_skb+0x321/0x4a0 net/ipv6/ip6_udp_tunnel.c:109
send6+0x2ed/0x3b0 drivers/net/wireguard/socket.c:152
wg_socket_send_skb_to_peer+0xbb/0x120 drivers/net/wireguard/socket.c:178
wg_packet_create_data_done drivers/net/wireguard/send.c:251 [inline]
wg_packet_tx_worker+0x142/0x360 drivers/net/wireguard/send.c:276
process_one_work+0x3d3/0x720 kernel/workqueue.c:2289
worker_thread+0x618/0xa70 kernel/workqueue.c:2436
kthread+0x1a9/0x1e0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

value changed: 0x00 -> 0x01

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 1911 Comm: kworker/1:3 Not tainted 6.1.0-rc8-syzkaller-00164-g4cee37b3a4e6-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: wg-crypt-wg0 wg_packet_tx_worker

Eric Dumazet (9):
  net/packet: annotate accesses to po->xmit
  net/packet: convert po->origdev to an atomic flag
  net/packet: convert po->auxdata to an atomic flag
  net/packet: annotate accesses to po->tp_tstamp
  net/packet: convert po->tp_tx_has_off to an atomic flag
  net/packet: convert po->tp_loss to an atomic flag
  net/packet: convert po->has_vnet_hdr to an atomic flag
  net/packet: convert po->running to an atomic flag
  net/packet: convert po->pressure to an atomic flag

 net/packet/af_packet.c | 104 +++++++++++++++++++++--------------------
 net/packet/diag.c      |  12 ++---
 net/packet/internal.h  |  34 +++++++++++---
 3 files changed, 87 insertions(+), 63 deletions(-)

-- 
2.40.0.rc2.332.ga46443480c-goog

