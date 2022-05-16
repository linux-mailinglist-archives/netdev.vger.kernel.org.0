Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF58C527C77
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 05:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239716AbiEPDpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 23:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbiEPDpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 23:45:43 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493146581;
        Sun, 15 May 2022 20:45:40 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gj17-20020a17090b109100b001d8b390f77bso16190391pjb.1;
        Sun, 15 May 2022 20:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T8PC9q1tKCwZggjpjUk/0disBLEfU38jdzfw/UEKkEw=;
        b=nInA2umG6VNl+OafQAYkvOxEnvnzi+qnUmRbRZ2rvbzs6IFBy+hkNJIBiPxQLozNG5
         SVH2+HNXtJD4cxiWZ8EM8Qhk67PX6oZc69cs9gSZawakaqQqi0AZ+bLJEcV94qxsf22M
         8DG8It3Io7AA5W8e1qBDepNQd4hXtMJlVkw1rA762Pv2GMsSe4ZwOIYgu6hwW5sOyVjF
         9w/06tKLCIVuQz1MU9EOh7yK+qkVYRIUhakadUiTxIac22n5YUDd0f+gZDRT5meFkJ4h
         B2+KFH0/qW3vKU+N2GbVcxlSlmF2pF9jidnXgy6sAo6/A5nYPpLxILQ7bFqfUavvcFC0
         bRUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T8PC9q1tKCwZggjpjUk/0disBLEfU38jdzfw/UEKkEw=;
        b=mKF/tjAGO2wWNFaSIUs3Tru18OIX0csbUKJcc3m84VEp7IbWuDbrc2PMpLhJ0B6tsN
         ZwxB1UxAY/zTd4Isj4uJ4JwkqV/bpZwlSX7NyVmEn5W4z2ZRl0FQxIrbhEO4WsWUUxe7
         voLse+cutQJN9O59lnWy0j5UTbYGOOmVlCf8g4F+eXtFoRNi/RR0YgWySlXdStpUHVvw
         8KEGQFzJGY1Shv2lyxovCaebZhboyx0E+MKX3mrf/efTddB91V2ODlSJvM308c/T+oc8
         RbZMWPLb1bmJkKX4C+t92d3jN1s8peyKK8V3Z5PD+ff5xYRCrUNTo+Ovrqu+BX04HbXJ
         0+Cw==
X-Gm-Message-State: AOAM532/XTmB6qfmcJ9SxPdyBzpvKZLbVDeI/+Ewix4fUxDhnrjnwdi7
        3cRV58iZ4jE+Tsntjta1HKE=
X-Google-Smtp-Source: ABdhPJxx3oU+13g9HeSyt3LyzZh+AlrD6riQvWZoo72Vo+M5Bj+xzXJTPbQ3N0cI0+7Y1kPZuYO02w==
X-Received: by 2002:a17:90b:17d0:b0:1dc:ddce:9c25 with SMTP id me16-20020a17090b17d000b001dcddce9c25mr28531672pjb.232.1652672739773;
        Sun, 15 May 2022 20:45:39 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.24])
        by smtp.gmail.com with ESMTPSA id x184-20020a6286c1000000b0050dc762819bsm5636854pfd.117.2022.05.15.20.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 20:45:39 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 0/9] net: tcp: add skb drop reasons to tcp state change
Date:   Mon, 16 May 2022 11:45:10 +0800
Message-Id: <20220516034519.184876-1-imagedong@tencent.com>
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
In the 8th patch, skb drop reasons are add to
tcp_timewait_state_process() by adding a function argument to it. In the
origin code, all skb are dropped for tw socket. In order to make less
noise, use consume_skb() for the 'good' skb. This can be checked by the
caller of tcp_timewait_state_process() from the value of drop reason.
If the drop reason is SKB_NOT_DROPPED_YET, it means this skb should not
be dropped.

=============================
In the 9th patch, skb drop reasons are add to the route_req() in struct
tcp_request_sock_ops. Following functions are involved:

  tcp_v4_route_req()
  tcp_v6_route_req()
  subflow_v4_route_req()
  subflow_v6_route_req()

In this series patches, following new drop reasons are added:

  SOCKET_DESTROYED
  TCP_PAWSACTIVEREJECTED
  TCP_ABORTONDATA
  LISTENOVERFLOWS
  TCP_REQQFULLDROP
  TIMEWAIT
  LSM

Menglong Dong (9):
  net: skb: introduce __DEFINE_SKB_DROP_REASON() to simply the code
  net: skb: introduce __skb_queue_purge_reason()
  net: sock: introduce sk_stream_kill_queues_reason()
  net: inet: add skb drop reason to inet_csk_destroy_sock()
  net: tcp: make tcp_rcv_synsent_state_process() return drop reasons
  net: tcp: make tcp_rcv_state_process() return drop reason
  net: tcp: add skb drop reasons to tcp connect requesting
  net: tcp: add skb drop reasons to tcp tw code path
  net: tcp: add skb drop reasons to route_req()

 include/linux/skbuff.h             | 482 +++++++++++++++++++----------
 include/net/inet_connection_sock.h |   3 +-
 include/net/sock.h                 |   8 +-
 include/net/tcp.h                  |  27 +-
 include/trace/events/skb.h         |  89 +-----
 net/core/drop_monitor.c            |  13 -
 net/core/skbuff.c                  |  10 +
 net/core/stream.c                  |   7 +-
 net/dccp/input.c                   |   3 +-
 net/dccp/ipv4.c                    |   3 +-
 net/dccp/ipv6.c                    |   3 +-
 net/ipv4/inet_connection_sock.c    |   2 +-
 net/ipv4/tcp_input.c               |  56 ++--
 net/ipv4/tcp_ipv4.c                |  54 +++-
 net/ipv4/tcp_minisocks.c           |  35 ++-
 net/ipv6/tcp_ipv6.c                |  55 +++-
 net/mptcp/subflow.c                |  16 +-
 17 files changed, 517 insertions(+), 349 deletions(-)

-- 
2.36.1

