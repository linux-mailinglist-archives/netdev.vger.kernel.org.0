Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD7D512CFC
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245397AbiD1Hhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 03:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245388AbiD1Hhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 03:37:52 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED229BAD3;
        Thu, 28 Apr 2022 00:34:38 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s14so3610725plk.8;
        Thu, 28 Apr 2022 00:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hqCwhqdyOpGzpM+/dpGCOkapfU9sAS+BTex7vnBXMo8=;
        b=LPO1mk0wVnnmzjq3um3erRuW9AINRRPdKIuGhm8TGEMm7W+7DF5bzyBTD3PG6ke65r
         asgJWFCa9xV/5UkLUNPf39ihmWgLlQuy898eTvVsru7EHH/S85eqP8iuj3sgz8eJTX3b
         bmu00ej+SLxF2YnGaH4sSwSJULG+K0v0KYf49JmanFXh8BfA7+kwqONEUcDepriRFZAf
         ip1Yuc6i/q63Ht4d5dy+geWLKDYJWptLh06Ml53If/9HQujSoPCTthlqfSOA2Le1bJlT
         RO4ambGYhW+rVCa2n7n1rFgqsD9j1trA/zE20QkVEHlLb75hNSuYQfNWBbOvhCpRyai3
         qk9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hqCwhqdyOpGzpM+/dpGCOkapfU9sAS+BTex7vnBXMo8=;
        b=bdgKGUe7mDCVrgJEE5calMEABtyGGnAn1AoykfEv1tcTYgPH+Bi3KTNBR7zMK9ea8X
         dyBDlo6XlFvFzhWEvxHOK36FRlEv2x+7BqoXo7KbuMbBG0vlnTS7A2Tp4VJhtR6Hbl/o
         e1xme3Ruti4/lCeMCiJ+VuB7AiAY5auQaV0qq3mw9flZYr4V6u2EPfk9J1vgTIew7l4v
         3Iyn/yvZd0OqaoRq4JvCI5yd73HC9NieFWNo7JzpYgVoJzRC9tZiznW8tAjrbSB1gt/q
         Re2zbSvj58VJW14uXupmiVU8GEKtRL+1xpqFEGgtsipvOOoeh4a7swN0CJ5qxOlo3kZ2
         axPQ==
X-Gm-Message-State: AOAM530DRX2DXwEWsnZWLa+qP5cvTbkyrhrHI66mGpfNfzdvpu5G0j2J
        ne40UzYUIdGWXl2YJrpJPNIa4J//hOM=
X-Google-Smtp-Source: ABdhPJzmYLfnIaRuDo+oJ+u6mhrk7lGNUZzaK4uc3cDzMUTXTbPStK5nBZhIk0OstfPiDV+BIBk23g==
X-Received: by 2002:a17:903:11c7:b0:154:b936:d1d4 with SMTP id q7-20020a17090311c700b00154b936d1d4mr32225591plh.78.1651131278424;
        Thu, 28 Apr 2022 00:34:38 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id a9-20020aa78649000000b004fe3d6c1731sm21369511pfo.175.2022.04.28.00.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 00:34:37 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/2] net: tcp: add skb drop reasons to connect request
Date:   Thu, 28 Apr 2022 15:33:38 +0800
Message-Id: <20220428073340.224391-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Seems now the reasons of skb drop in TCP layer are almost supported,
except the path of connect requesting. So let's just finish it.

The TCP connect requesting is processed by
'inet_csk(sk)->icsk_af_ops->conn_request()'. Yeah, it's a function
pointer, so it's not easy to add function param to it. Luckily, it's
return value can be reused. For now, 0 means a call of 'consume_skb()'
and -1 means 'kfree_skb()', with a RESET be send. Therefore, we can
return the drop reasons directly, as the positive is not used yet. With
drop reasons returned, kfree_skb_reason() will be called instead of
consume_skb() in tcp_rcv_state_process().

And in the 2th patch, skb drop reasons are added to route_req() in
struct tcp_request_sock_ops by adding a function param to it.

Following new skb drop reasons are added:

  SKB_DROP_REASON_LISTENOVERFLOWS
  SKB_DROP_REASON_TCP_REQQFULLDROP
  SKB_DROP_REASON_SECURITY

Changes since v1:
- don't free skb in conn_request, as Eric suggested, and use it's
  return value to pass drop reasons in the 1th patch.

Menglong Dong (2):
  net: tcp: add skb drop reasons to tcp connect request
  net: tcp: add skb drop reasons to route_req()

 include/linux/skbuff.h     |  5 +++++
 include/net/tcp.h          |  3 ++-
 include/trace/events/skb.h |  3 +++
 net/ipv4/tcp_input.c       | 22 +++++++++++++++-------
 net/ipv4/tcp_ipv4.c        | 16 ++++++++++++----
 net/ipv6/tcp_ipv6.c        | 18 +++++++++++++-----
 net/mptcp/subflow.c        | 10 ++++++----
 7 files changed, 56 insertions(+), 21 deletions(-)

-- 
2.36.0

