Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E7A545AC3
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243538AbiFJDos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbiFJDor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:44:47 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6465737B7FD;
        Thu,  9 Jun 2022 20:44:44 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f9so11345205plg.0;
        Thu, 09 Jun 2022 20:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cJjPBfkMlUY/HElBP+o8xBfsAb9UoVlqEQ9zWPVy9sA=;
        b=bX1yUn+5Ei++reWP8d6/ng3eLGRaRleU5ZkVLpqL1K32CNVIF5vLAPpxNjShUemw/3
         ChX2OtMKlvGuL+PZOifLXqIPNzIo7pUPZ5efXOfn/vaf3D8NEDm1NyW7YdYr6rZ7Oyv7
         YUu+EBJgQ/zi7LXRJMTenCqTsCwAAnpE0IStA91HNz0wNboRaUOMV6YqbyuJ3YDTPgyv
         IePvwNEnJhvBsKAhcS00yCVTAy3Zn/LkkuGEKxrpoUA/iGqSSesJOOh7VI5AUoKWK8dB
         Ao/1Kk2+R5FqjkyGni5k2xrdEpvxF0c+FMrwndLcsrN6LN8jMi/Q8xou0o1Z46Brsz1o
         4DDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cJjPBfkMlUY/HElBP+o8xBfsAb9UoVlqEQ9zWPVy9sA=;
        b=QwEtBpNCSnPqlYc9+ZHeNKRr0UHsydWoMLW9O0/IsNuS4TUBqfjbBCEuHWiW6clf5a
         eUUGKKr+9gT/dQQ2mrwG4cnGyhbVqqo6cX+/omV+JL8djZPT5GXQULztqMh5Dch09cz9
         d3RL2yoFmkOGKvRFlAWuk9VVuYFgR/8ktjGCNqqAhHDFSVAp4zXB3n9VeioParRu+5ZF
         CHFSHufhVMrYRNMVQkvu+bPWJjpABBK3bxQlvfTz0VVxj3V8leHjGmSMQuEUMuRTbuuy
         gfiSB3K0oNgf7sg9U/4Fk0t7ZnSLizM8rjIsexXfp6FxrXdBgqkOixTgrxsed47riTNl
         Y9Qg==
X-Gm-Message-State: AOAM533UPM++nAJSrY8VazNE4z0R2SbIuJW030ORWT/yWql9MMQPVKKB
        qchfK9iDbQMUkIlk93K7rQA=
X-Google-Smtp-Source: ABdhPJxDGniPd5bOHlZjHbWm+qdt70BBJ8dBJtqPOq6qCo2ZFnqptI5yI5li4EqH/UFX8MZCJ/VUgw==
X-Received: by 2002:a17:903:2291:b0:164:95f:b512 with SMTP id b17-20020a170903229100b00164095fb512mr42549747plh.120.1654832683794;
        Thu, 09 Jun 2022 20:44:43 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id u30-20020a63b55e000000b003fc136f9a7dsm5908368pgo.38.2022.06.09.20.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 20:44:43 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v3 0/9] net: tcp: add skb drop reasons to tcp state change
Date:   Fri, 10 Jun 2022 11:41:55 +0800
Message-Id: <20220610034204.67901-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

In this series patches, skb drop reasons are add to code path of TCP
state change, which we have not done before. It is hard to pass these
reasons from the function to its caller, where skb is dropped. In order
to do this, we have to make some functions return skb drop reasons, or
pass the pointer of 'reason' to these function as an new function
argument.

=============================
We change the type of the return value of tcp_rcv_synsent_state_process()
and tcp_rcv_state_process() to 'enum skb_drop_reason' and make them
return skb drop reasons in 5th and 6th patch.

=============================
In order to get skb drop reasons during tcp connect requesting code path,
we have to pass the pointer of the 'reason' as a new function argument of
conn_request() in 'struct inet_connection_sock_af_ops'. As the return
value of conn_request() can be positive or negative or 0, it's not
flexible to make it return drop reasons. This work is done in the 7th
patch, and functions that used as conn_request() is also modified:

  dccp_v4_conn_request()
  dccp_v6_conn_request()
  tcp_v4_conn_request()
  tcp_v6_conn_request()
  subflow_v4_conn_request()
  subflow_v6_conn_request()

As our target is TCP, dccp and mptcp are not handled more.

=============================
In the 7th patch, skb drop reasons are add to
tcp_timewait_state_process() by adding a function argument to it. In the
origin code, all skb are dropped for tw socket. In order to make less
noise, use consume_skb() for the 'good' skb. This can be checked by the
caller of tcp_timewait_state_process() from the value of drop reason.
If the drop reason is SKB_NOT_DROPPED_YET, it means this skb should not
be dropped.

=============================
In the 8th patch, skb drop reasons are add to the route_req() in struct
tcp_request_sock_ops. Following functions are involved:

  tcp_v4_route_req()
  tcp_v6_route_req()
  subflow_v4_route_req()
  subflow_v6_route_req()

In this series patches, following new drop reasons are added:

- SOCKET_DESTROYED
- TCP_PAWSACTIVEREJECTED
- TCP_LINGER
- LISTENOVERFLOWS
- TCP_REQQFULLDROP
- TIMEWAIT
- LSM

Changes since v2:
- move drop reasons to standalone header in another series

Changes since v1:
6/9 - fix the compile errors of dccp and mptcp (kernel test robot)
7/9 - skb is not freed on TCP_TW_ACK and 'ret' is not initizalized, fix
      it (Eric Dumazet)

Menglong Dong (9):
  net: skb: introduce __skb_queue_purge_reason()
  net: sock: introduce sk_stream_kill_queues_reason()
  net: inet: add skb drop reason to inet_csk_destroy_sock()
  net: tcp: make tcp_rcv_synsent_state_process() return drop reasons
  net: tcp: make tcp_rcv_state_process() return drop reason
  net: tcp: add skb drop reasons to tcp connect requesting
  net: tcp: add skb drop reasons to tcp tw code path
  net: tcp: add skb drop reasons to route_req()
  net: tcp: use LINUX_MIB_TCPABORTONLINGER in tcp_rcv_state_process()

 include/linux/skbuff.h             | 12 +++--
 include/net/dropreason.h           | 35 +++++++++++++++
 include/net/inet_connection_sock.h |  3 +-
 include/net/sock.h                 |  8 +++-
 include/net/tcp.h                  | 27 ++++++-----
 net/core/stream.c                  |  7 +--
 net/dccp/dccp.h                    |  3 +-
 net/dccp/input.c                   |  3 +-
 net/dccp/ipv4.c                    |  3 +-
 net/dccp/ipv6.c                    |  5 ++-
 net/ipv4/inet_connection_sock.c    |  2 +-
 net/ipv4/tcp_input.c               | 72 +++++++++++++++++++-----------
 net/ipv4/tcp_ipv4.c                | 52 +++++++++++++++------
 net/ipv4/tcp_minisocks.c           | 35 +++++++++++----
 net/ipv6/tcp_ipv6.c                | 53 +++++++++++++++-------
 net/mptcp/subflow.c                | 18 +++++---
 16 files changed, 241 insertions(+), 97 deletions(-)

-- 
2.36.1

