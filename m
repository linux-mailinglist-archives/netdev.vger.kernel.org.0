Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF72F091B
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbfKEWL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:11:59 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:36257 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbfKEWL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:11:59 -0500
Received: by mail-pg1-f202.google.com with SMTP id h12so16170731pgd.3
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OHORrEy6ebWVURRsorIjz0MZjixPYCvrTA07+IkPjiM=;
        b=n93jQlGkfoZN81/1hsAFwMAMZ0RIBnty22sjAsWWBlPoEjPwRLIFANgLjLziU6xoVh
         FF2sqd4wDyT+l32QXzEwBC2234fHmrb2indpTCLaTvokY302nIsgKgplABDdEEESQ/DI
         rV89BUN1ROjDaoUrxan/c/Gt5ku9vkyHaFEcmNFe8MMhMLBOeRddjjs7fq1aM57WQxVU
         AU5VVINQ1NsVi3QoYYbYDIBtO9qw98KdT4uRP7pnRY+HEla6TPBNlKr6C/dYrT8AbkZ0
         F9fDlisFkFSvC8blRGXpu3dam3IoPiSIyXNL3aq7qxUDMEhj3jpyhw6mjJQA9F5zOaAh
         QCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OHORrEy6ebWVURRsorIjz0MZjixPYCvrTA07+IkPjiM=;
        b=ndktR6hJWE9doWjD3hlvyygt9KvvEzY5elWFmVNsarEE8y8Hsk3Ud1oJ2wyyn9DmrZ
         mBP18o+A9rzFivCaSb8D4bVAcI/Oi1lr8iRyWU+4KM1kNPC6kczNUy/+eb8kQfSAGiCE
         hKfrXBWnb4MShpfdtoqoruGyk98V8QMwq2xAYxlFp4byBnF2+HNl107acW1gv/y09zmv
         7AX//c9pbk6i8owTmglhIWFdQlZuITAEnKVyTZ78/ZiQnZIiNaeayG7kTAB5xlDY3v5C
         zOfuoRbyndXod0GT20nsL8Z35z8jtBCrobH39G8+Onbj3gKaSgO2+1pHREXml8xaFbEF
         /b4w==
X-Gm-Message-State: APjAAAWdPYafxbinuIYQMFxCbhJw9DPqIEybJOVFiVyqS6Ye014LXWIV
        nkOlk9fVDVa4JmYfgpgrtL//2iKN0I/zEg==
X-Google-Smtp-Source: APXvYqyHdWQ4DuBbObDxlRpJgZjALPO77q8Jlj0ZbGVpf2glW9tmvJu/EzwMnPaCPDa/X2+9ktDguQ9CdczKow==
X-Received: by 2002:a65:4489:: with SMTP id l9mr20495820pgq.106.1572991918269;
 Tue, 05 Nov 2019 14:11:58 -0800 (PST)
Date:   Tue,  5 Nov 2019 14:11:48 -0800
Message-Id: <20191105221154.232754-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net-next 0/6] net: various KCSAN inspired fixes
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a series of minor fixes, mostly dealing with
lockless accesses to socket 'sk_ack_backlog', 'sk_max_ack_backlog'
ane neighbour 'confirmed' fields.

Eric Dumazet (6):
  net: neigh: use long type to store jiffies delta
  inet_diag: use jiffies_delta_to_msecs()
  net: avoid potential false sharing in neighbor related code
  net: use helpers to change sk_ack_backlog
  net: annotate lockless accesses to sk->sk_ack_backlog
  net: annotate lockless accesses to sk->sk_max_ack_backlog

 include/net/arp.h                       |  4 ++--
 include/net/ndisc.h                     |  8 ++++----
 include/net/sock.h                      | 18 +++++++++---------
 net/atm/signaling.c                     |  2 +-
 net/atm/svc.c                           |  2 +-
 net/ax25/af_ax25.c                      |  2 +-
 net/ax25/ax25_in.c                      |  2 +-
 net/bluetooth/af_bluetooth.c            |  4 ++--
 net/core/neighbour.c                    |  4 ++--
 net/dccp/proto.c                        |  2 +-
 net/decnet/af_decnet.c                  |  2 +-
 net/decnet/dn_nsp_in.c                  |  2 +-
 net/ipv4/af_inet.c                      |  2 +-
 net/ipv4/inet_connection_sock.c         |  2 +-
 net/ipv4/inet_diag.c                    | 15 ++++++---------
 net/ipv4/tcp.c                          |  4 ++--
 net/ipv4/tcp_diag.c                     |  4 ++--
 net/ipv4/tcp_ipv4.c                     |  2 +-
 net/ipv6/tcp_ipv6.c                     |  2 +-
 net/llc/af_llc.c                        |  2 +-
 net/rose/af_rose.c                      |  4 ++--
 net/sched/em_meta.c                     |  4 ++--
 net/sctp/associola.c                    |  4 ++--
 net/sctp/diag.c                         |  4 ++--
 net/sctp/endpointola.c                  |  2 +-
 net/sctp/socket.c                       |  4 ++--
 net/vmw_vsock/af_vsock.c                |  4 ++--
 net/vmw_vsock/hyperv_transport.c        |  2 +-
 net/vmw_vsock/virtio_transport_common.c |  2 +-
 net/vmw_vsock/vmci_transport.c          |  2 +-
 net/x25/af_x25.c                        |  4 ++--
 31 files changed, 59 insertions(+), 62 deletions(-)

-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

