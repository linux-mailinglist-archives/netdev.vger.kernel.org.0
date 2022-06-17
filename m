Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A30454F4D4
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381406AbiFQKF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235899AbiFQKF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:05:57 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764026973B;
        Fri, 17 Jun 2022 03:05:56 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w21so3805662pfc.0;
        Fri, 17 Jun 2022 03:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UsSZBHD+dC7GrwKTJVORhTtMkWQaUMYhTHlNEePAZE4=;
        b=qdReN3dAz1mYJBHqwTdhlnBd74ohn3O1tlw2IudfGirZbjlJ61PQe4r+hnXuBs3V68
         +I5XerQ+d0Bd/iiFZErv8Vsksox4LxB2KdiLRyEJIaGDf9zuKWtWNA8Gygb+BHQMCLwH
         NctofkCWXLiKqqf/Oi7f2azfE6DIRgiRUPDwUHWe+7W7IJOIxOKbFfpneFKR8RyGA0pG
         chCr+34GfOvcBdUBm+psUKm0lOZ79FARQ+wHH7qu/cj5RzIsJCFE25mfMB+9od5Fh9N0
         1HZpi3p0u0gMkk1qQt3WrIGER+fTwkwa0L53gnkFsfte0NMGU+ApQPPKiFcZTz6R2/lp
         N11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UsSZBHD+dC7GrwKTJVORhTtMkWQaUMYhTHlNEePAZE4=;
        b=lhDxfQ8StUKoXWO5M/ZhkyGC3NoJvJzL0MB9XI04ffbIo/VqIOUSPy9puEDXygHGw9
         IeoePIAsPq4sdw6RKcn+/9IqnD+sxmxpj6yCP1tkKOB7xljGjwpGNtf8AmcvspPvjEvh
         wpRUYCxciHVW+HGw0bh1FmaYNwPLC3yjK47JlD+GJf6DLFWO9fLzIRqNqXXbF/wChTjG
         PESLT2dB2jEx3U02FalBoJ69rHw5na5WUI1GsK4DtSVelCMyM5ll/E7zEntTVUOZqBbZ
         Ml2WuWz2cUPshSntm9EMV2QqB+Z/751CpxW5QqXuG51foP4EsPdTXQSpYXRFQj5baCng
         Wl/w==
X-Gm-Message-State: AJIora8s7MKnOgYZBumGqTg3z2WPzbb4HIthapFc7Z31bWhaNCAFbuSs
        kbqBNqfzNrHFDDTl6INBR2E=
X-Google-Smtp-Source: AGRyM1tkVsndYhxOI0C8m0x1TrG9buGTLA1YBx//u8Q+tvAXNHQF4MMquwwOAnZChIUKtAnRUER+mw==
X-Received: by 2002:a05:6a00:2349:b0:51c:29c0:82f6 with SMTP id j9-20020a056a00234900b0051c29c082f6mr9393082pfj.32.1655460355918;
        Fri, 17 Jun 2022 03:05:55 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.10])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f7ca00b001621ce92196sm3126210plw.86.2022.06.17.03.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:05:55 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v4 0/8] net: tcp: add skb drop reasons to tcp state change
Date:   Fri, 17 Jun 2022 18:05:06 +0800
Message-Id: <20220617100514.7230-1-imagedong@tencent.com>
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
In the 6th patch, skb drop reasons are add to
tcp_timewait_state_process() by adding a function argument to it. In the
origin code, all skb are dropped for tw socket. In order to make less
noise, use consume_skb() for the 'good' skb. This can be checked by the
caller of tcp_timewait_state_process() from the value of drop reason.
If the drop reason is SKB_NOT_DROPPED_YET, it means this skb should not
be dropped.

=============================
In the 7th patch, skb drop reasons are add to the route_req() in struct
tcp_request_sock_ops. Following functions are involved:

  tcp_v4_route_req()
  tcp_v6_route_req()
  subflow_v4_route_req()
  subflow_v6_route_req()

In this series patches, following new drop reasons are added:

- SOCKET_DESTROYED
- LISTENOVERFLOWS
- TCP_REQQFULLDROP
- TIMEWAIT
- LSM

Changes since v3:
- Eric says what I did to tcp_rcv_state_process() is too invasive, so I
  removed that part (for now).
- As Eric suggested, make kfree_skb_reason(skb, SKB_NOT_DROPPED) the same
  as consume_skb(skb), which make code simplier. This is used in
  5th and 6th patch.

Changes since v2:
- move drop reasons to standalone header in another series

Changes since v1:
6/9 - fix the compile errors of dccp and mptcp (kernel test robot)
7/9 - skb is not freed on TCP_TW_ACK and 'ret' is not initizalized, fix
      it (Eric Dumazet)

Menglong Dong (8):
  net: skb: use SKB_NOT_DROPPED in kfree_skb_reason() as consume_skb()
  net: skb: introduce __skb_queue_purge_reason()
  net: sock: introduce sk_stream_kill_queues_reason()
  net: inet: add skb drop reason to inet_csk_destroy_sock()
  net: tcp: add skb drop reasons to tcp connect requesting
  net: tcp: add skb drop reasons to tcp tw code path
  net: tcp: add skb drop reasons to route_req()
  net: tcp: use LINUX_MIB_TCPABORTONLINGER in tcp_rcv_state_process()

 include/linux/skbuff.h             | 12 ++++++++---
 include/net/dropreason.h           | 23 +++++++++++++++++++++
 include/net/inet_connection_sock.h |  3 ++-
 include/net/sock.h                 |  8 +++++++-
 include/net/tcp.h                  | 19 +++++++++--------
 net/core/skbuff.c                  | 11 ++++++++--
 net/core/stream.c                  |  7 ++++---
 net/dccp/dccp.h                    |  3 ++-
 net/dccp/input.c                   |  3 ++-
 net/dccp/ipv4.c                    |  3 ++-
 net/dccp/ipv6.c                    |  5 +++--
 net/ipv4/inet_connection_sock.c    |  2 +-
 net/ipv4/tcp_input.c               | 26 ++++++++++++++---------
 net/ipv4/tcp_ipv4.c                | 31 ++++++++++++++++++++--------
 net/ipv4/tcp_minisocks.c           | 23 +++++++++++++++++----
 net/ipv6/tcp_ipv6.c                | 33 ++++++++++++++++++++++--------
 net/mptcp/subflow.c                | 18 +++++++++-------
 17 files changed, 168 insertions(+), 62 deletions(-)

-- 
2.36.1

