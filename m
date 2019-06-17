Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7BBD48995
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfFQRE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:04:29 -0400
Received: from mail-ot1-f73.google.com ([209.85.210.73]:39222 "EHLO
        mail-ot1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbfFQRE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:04:28 -0400
Received: by mail-ot1-f73.google.com with SMTP id x27so5172455ote.6
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JqBZQ8VEOSDyfbiQWC8fU8SqzSy8ioAWvekiIEW8Kbk=;
        b=V0cVkplByGOjX1iZo+ocVhqpQX7fdQDfuYdUvyLEeFwDIRWvC9EDZMKY00nHqabNQk
         R9cX2S/RfVhut0zzJnPqLjHBnA80FUAyOq8OGxj0gdBIj2Ube8ew71T17sFRkXH+uHKG
         Bi6chxF+JgBEUDDmTuVT/v3hZyUCGUJe72Av6i6sqUYJ/2Rn3jhLBgnLLaYhzXe2o97P
         rdLmh8Kxx42tjyAibbsM8X0mythtC97Joa/oEgTSQBE3De4OFlRqWhz6x+ltBBo49A0P
         hYddSBz1pp1VNM0Jkw8cf9IuEfzObOBdje1MMufHFMSD8hZWiCI2to1gNnokmwBNbua6
         dyKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JqBZQ8VEOSDyfbiQWC8fU8SqzSy8ioAWvekiIEW8Kbk=;
        b=IqeAiAQUiSpYD82iBtGHKLwNCpL9qPsFmPyeIAudL5/BrQJYjybCNAytCn5oJYAsfV
         GYflyombLn/k85NO9tgfjXXB8nWACCB0kufgItTwQsDEvQhftDfvjzhNIZCmD0f4xoke
         pziRj1wmk67PxPVOJM99Sz2pEDlF1qdvV1ZwUBuIM22uyQRT7suyOfj/N4NKEbXf4up4
         ZfPvMUL2uEDCoHnOVhXPXm/MeIDfTdb2Q46/bHhj2L9c1NyuuI1ijRzlkmvI7Ok/jzER
         vP0seyNUfzNuQB8e34mEll0VcwV+Xvi7AL0r0YihbjHyOWDYW0e/wDEkdKuLwC165o2U
         D0nw==
X-Gm-Message-State: APjAAAUGHm4Pb5+4S1QtNz31aKAM4/urkcctUTMqHRMKattMootiY1jd
        3XAWSvV6S6JMk8g4hUSF4QWkYCvLkLXwmg==
X-Google-Smtp-Source: APXvYqzYfuJnixcXgwJqhwjV1yc3dsUnR1rxZZ9bBs5JIJjH5j8JOwZZW0j1tNpZdIEZjYOXKJxd5Ban1oPIXg==
X-Received: by 2002:aca:36c5:: with SMTP id d188mr11072102oia.39.1560791067872;
 Mon, 17 Jun 2019 10:04:27 -0700 (PDT)
Date:   Mon, 17 Jun 2019 10:03:50 -0700
Message-Id: <20190617170354.37770-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net 0/4] tcp: make sack processing more robust
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Looney brought to our attention multiple problems
in TCP stack at the sender side.

SACK processing can be abused by malicious peers to either
cause overflows, or increase of memory usage.

First two patches fix the immediate problems.

Since the malicious peers abuse senders by advertizing a very
small MSS in their SYN or SYNACK packet, the last two
patches add a new sysctl so that admins can chose a higher
limit for MSS clamping.

Eric Dumazet (4):
  tcp: limit payload size of sacked skbs
  tcp: tcp_fragment() should apply sane memory limits
  tcp: add tcp_min_snd_mss sysctl
  tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()

 Documentation/networking/ip-sysctl.txt |  8 ++++++++
 include/linux/tcp.h                    |  4 ++++
 include/net/netns/ipv4.h               |  1 +
 include/net/tcp.h                      |  2 ++
 include/uapi/linux/snmp.h              |  1 +
 net/ipv4/proc.c                        |  1 +
 net/ipv4/sysctl_net_ipv4.c             | 11 +++++++++++
 net/ipv4/tcp.c                         |  1 +
 net/ipv4/tcp_input.c                   | 26 ++++++++++++++++++++------
 net/ipv4/tcp_ipv4.c                    |  1 +
 net/ipv4/tcp_output.c                  | 10 +++++++---
 net/ipv4/tcp_timer.c                   |  1 +
 12 files changed, 58 insertions(+), 9 deletions(-)

-- 
2.22.0.410.gd8fdbe21b5-goog

