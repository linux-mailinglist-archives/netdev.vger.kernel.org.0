Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B344849DD79
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238339AbiA0JNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbiA0JNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:13:32 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1636CC061714;
        Thu, 27 Jan 2022 01:13:32 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id p125so1769353pga.2;
        Thu, 27 Jan 2022 01:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0RkjT3TuOyWwEVOpPIQVPsW4Hb2Nu8eZN8Ji5YobBOo=;
        b=I3R+Jvj96JIadQ2/TT5eD/9ziY+SyLlJrEpPEXILSrAY21PUh8y++4BR48gts9u5Te
         y/5xuwtsIRC+VO75McL3BKrmQ2+rz4Qr+H+zj+u+GgVsm46lLsXpZc4vg3PpS5ylJfq5
         rlv3j5bJltr3ZUNbLEuivEnbbg3HWbqsa2lGnaZFpuAdUdGq3MN2BT9aiVnyF/pAORr/
         srb1nOcHTwh2pYtI0DZwmrVK46LeTtSLkmxMiG5+IV5H/kYCGEujEAgPcsVQD4tDAYHQ
         MkehIW+ui5nKZHfSQ9/lIvzQax1FQOofoJEXLllAVYtVQnTOLAxu0bZXCPfud/HGV4Na
         mW5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0RkjT3TuOyWwEVOpPIQVPsW4Hb2Nu8eZN8Ji5YobBOo=;
        b=sElctzqQYfz3gXjh6IAJetFtKYuNjVIDl2PKDgIpud6/wov3OZjHR07vAfYinuJakI
         WI7ZWpp0PdnhL1/+StuK81LFIykVCodYEqqtMsmQd4CWGdqUWgFq8ZgUhLndcradrcOr
         8QqdwLsuracL3udo+j2fr+7ICvkVL/z0Yjn036WH0vkVul6/6aNjU8bJyeYtBu0VBtay
         omR4Rgz2RE07Wh6VVsQq8YYOJaiUg4DdeYpwuDbD28Wu4hfuX0BPTd+k2YoxwG7C/kSx
         Oe4O3r+f3MiC2wigqNv1cMN5s3IGDUCRghf0nB9IMG5l63s162tx0FJD2LvQa/py5Qjq
         vxIg==
X-Gm-Message-State: AOAM532d++l0qnFA0lO9e0RB3Iaq+4P3xAg2mdpvXLF5Ql31xOg5ZVDy
        cXyqkYSV6XzxBNruVD6+QTI=
X-Google-Smtp-Source: ABdhPJxJ2l6RBR25W/7IOoPhV8coO6DkmGz63345RDkh8A1oNv0yh8M9rplKDGacVoiji7gnbxu+vA==
X-Received: by 2002:a05:6a00:d5c:: with SMTP id n28mr2555266pfv.9.1643274811533;
        Thu, 27 Jan 2022 01:13:31 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id j11sm2046338pjf.53.2022.01.27.01.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 01:13:30 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        alobakin@pm.me, pabeni@redhat.com, cong.wang@bytedance.com,
        talalahmad@google.com, haokexin@gmail.com, keescook@chromium.org,
        memxor@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, mengensun@tencent.com
Subject: [PATCH v2 net-next 0/8] net: use kfree_skb_reason() for ip/udp packet receive
Date:   Thu, 27 Jan 2022 17:13:00 +0800
Message-Id: <20220127091308.91401-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

In this series patches, kfree_skb() is replaced with kfree_skb_reason()
during ipv4 and udp4 packet receiving path, and following drop reasons
are introduced:

SKB_DROP_REASON_SOCKET_FILTER
SKB_DROP_REASON_NETFILTER_DROP
SKB_DROP_REASON_OTHERHOST
SKB_DROP_REASON_IP_CSUM
SKB_DROP_REASON_IP_INHDR
SKB_DROP_REASON_IP_RPFILTER
SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST
SKB_DROP_REASON_XFRM_POLICY
SKB_DROP_REASON_IP_NOPROTO
SKB_DROP_REASON_SOCKET_RCVBUFF
SKB_DROP_REASON_PROTO_MEM

TCP is more complex, so I left it in the next series.

I just figure out how __print_symbolic() works. It doesn't base on the
array index, but searching for symbols by loop. So I'm a little afraid
it's performance.

Changes since v1:
- add document for all drop reasons, as David advised
- remove unreleated cleanup
- remove EARLY_DEMUX and IP_ROUTE_INPUT drop reason
- replace {UDP, TCP}_FILTER with SOCKET_FILTER


Menglong Dong (8):
  net: socket: intrudoce SKB_DROP_REASON_SOCKET_FILTER
  net: skb_drop_reason: add document for drop reasons
  net: netfilter: use kfree_drop_reason() for NF_DROP
  net: ipv4: use kfree_skb_reason() in ip_rcv_core()
  net: ipv4: use kfree_skb_reason() in ip_rcv_finish_core()
  net: ipv4: use kfree_skb_reason() in ip_protocol_deliver_rcu()
  net: udp: use kfree_skb_reason() in udp_queue_rcv_one_skb()
  net: udp: use kfree_skb_reason() in __udp_queue_rcv_skb()

 include/linux/skbuff.h     | 38 ++++++++++++++++++++++++++++++++------
 include/trace/events/skb.h | 13 ++++++++++++-
 net/ipv4/ip_input.c        | 30 ++++++++++++++++++++++--------
 net/ipv4/tcp_ipv4.c        |  2 +-
 net/ipv4/udp.c             | 22 ++++++++++++++++------
 net/netfilter/core.c       |  3 ++-
 6 files changed, 85 insertions(+), 23 deletions(-)

-- 
2.27.0

