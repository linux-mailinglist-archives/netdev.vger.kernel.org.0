Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3501529BE8
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242559AbiEQIMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242881AbiEQILs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:11:48 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AAA3CA57;
        Tue, 17 May 2022 01:11:47 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id c14so16247566pfn.2;
        Tue, 17 May 2022 01:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KaVA8k5Psvv7+eoSfgoNw+H8JyuA0Kach9rgrgx4BUQ=;
        b=YIszghxceyWCmAKXujx2etXlWewZX9+eCJFqQ/DgVzY1WyMfgIcCXV4JqtrVxTaaHu
         3jTocN/gSJBbIXaWCT4AOPAWghimrZlsrDeyw/dBc/yStB5t37EZ3s3LEQx2rOYd4V9x
         2gvnEjY4SSQicBFSwCUoAUIavO8V87D8rzVX73EAo/I/OAfgP8zgbivljQssuDFKl9iK
         lfWZ6zm329NxabRLDRePSwGFuj/8wkrqKLzalYm99Jei7CtEXJNaGul2rNXK4QR9Vyy4
         PoqrFVN387jhL8/YbigEJrG34K5p3Q2jo1q6rovQjtw9xbQHSwslkVHwsi6qN1Qcgk9f
         asng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KaVA8k5Psvv7+eoSfgoNw+H8JyuA0Kach9rgrgx4BUQ=;
        b=sNJI6m+Th96DsCSFU31mo9ZWLEBn7cMU1Jk13X09oU8Zac+QjX5KzhCVuvqtAMxXbN
         U/ubBQ9DHNktnC8e0XquzMBORN541oPhaV1ZgI2UNFGf185/9gtwWK4uD4SJp852SNO5
         AHuV26Na2k83ibUL76lWmRtMAJPT8vCi8YdyFrU+WsL3FAQBFDBZ61DaOdbBg96sqlWo
         KO4auv0b3ba20C0tfqg2oZEtgw1SNG6BmIN6i756tUN/kiA9+ZIRoPPxOdEMGgCJ318+
         UCzBdhqHs/Y+6hWtHL7lLzxdj6a0VzcmQ/bhcRnNwfAUz4Nljpi0kVzE8ZBQkpUrJ9Bk
         Kxag==
X-Gm-Message-State: AOAM530jxfi7KvsjdiYRB4a7h6cnoUW6gYgpaj67VbQn39jLksQ5+eu8
        NGID2THBG+7PL1eBw69dk9Q=
X-Google-Smtp-Source: ABdhPJyPKFchqOkLd64LDqu1zjukIygemahvdluabS+VPne5kGdgZ3AEERVHKuhULPhYOAxOubHzWw==
X-Received: by 2002:a63:ea0c:0:b0:3f5:d221:1f2f with SMTP id c12-20020a63ea0c000000b003f5d2211f2fmr647708pgi.125.1652775107222;
        Tue, 17 May 2022 01:11:47 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id c14-20020a170902c2ce00b0015e8d4eb2easm8336306pla.308.2022.05.17.01.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:11:46 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/9] net: tcp: add skb drop reasons to tcp state change
Date:   Tue, 17 May 2022 16:09:59 +0800
Message-Id: <20220517081008.294325-1-imagedong@tencent.com>
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

Changes since v1:
7/9 - fix the compile errors of dccp and mptcp (kernel test robot)
8/9 - skb is not freed on TCP_TW_ACK and 'ret' is not initizalized, fix
      it (Eric Dumazet)

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
 net/dccp/dccp.h                    |   3 +-
 net/dccp/input.c                   |   3 +-
 net/dccp/ipv4.c                    |   3 +-
 net/dccp/ipv6.c                    |   5 +-
 net/ipv4/inet_connection_sock.c    |   2 +-
 net/ipv4/tcp_input.c               |  56 ++--
 net/ipv4/tcp_ipv4.c                |  54 +++-
 net/ipv4/tcp_minisocks.c           |  35 ++-
 net/ipv6/tcp_ipv6.c                |  56 +++-
 net/mptcp/subflow.c                |  18 +-
 18 files changed, 522 insertions(+), 352 deletions(-)

-- 
2.36.1

