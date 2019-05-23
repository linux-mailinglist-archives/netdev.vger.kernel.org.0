Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29F3728C15
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387810AbfEWVI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:08:57 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:44636 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730547AbfEWVI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 17:08:56 -0400
Received: by mail-pf1-f176.google.com with SMTP id g9so3914751pfo.11
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 14:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=wMax+lenzyUHPsKlaw2Xwz1J2fIjhyjCZs+l8WeZZIk=;
        b=UaMnrdv9kxUyUAoeV3obdkbGuhYqC5UwxazWF+3nuF1UF3pQcc1gr+roilgZcHYFp2
         bvy5U/V0Qg5qe2Vf8zvxxGxiM2RPdhg7SaQAWwaDSYiYW006jUvPXKh2pzgTXNEQqpEg
         lw0XlMmuZgMdv568WatuxBTKK0UtQYWf7pLN0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wMax+lenzyUHPsKlaw2Xwz1J2fIjhyjCZs+l8WeZZIk=;
        b=UwdfXEb7QEmTT8v0srqGd5aSWBPw92A1f7VphP5qwHBw1n9C4mAslP2EsQJlvYx8cd
         nyTaPIXh8DyomBj3h2otevk0m2dUfLD0lIAnLRzvkadvRtXn5rqwI/LEhobHefAtcR9x
         YMG50pLCo6TMvctNi7KmTigJYEkEzi/6bXju43JHL4CIz/1uRrVVEWJ/T+xj0JeBmCD9
         Hey4ctgpA//in3kvIRUlSb26uIBO0VFQON0mHJqzbaMjNPxRI+KwJ4dZWlLyp8zyE9A3
         zbZVFdxgCDaeC01ULpeIEW+GrxwCtPj8iFs+XWwp0GjeWbvLt+zqn732isiOowfVNWvP
         ta3g==
X-Gm-Message-State: APjAAAWMuH0Q+kcqodJnicPDBJXfHNLxCqhFtnj8qVWdUbRs3aFkSv6A
        nS92Xz0lMt802cCTbrNOZ2B+yg==
X-Google-Smtp-Source: APXvYqyjISI5Ny9VN8A309FwPymfZ7VE0AtfDET3WweMMKUW9iebMfPJRFf0OgH8RwPdpvmO2ZLLZw==
X-Received: by 2002:a17:90a:350d:: with SMTP id q13mr4321522pjb.20.1558645735962;
        Thu, 23 May 2019 14:08:55 -0700 (PDT)
Received: from localhost.localdomain (S010620c9d00fc332.vf.shawcable.net. [70.71.167.160])
        by smtp.googlemail.com with ESMTPSA id y17sm333481pfn.79.2019.05.23.14.08.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 14:08:55 -0700 (PDT)
From:   Fred Klassen <fklassen@appneta.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Cc:     Fred Klassen <fklassen@appneta.com>
Subject: [PATCH net 0/4] Allow TX timestamp with UDP GSO
Date:   Thu, 23 May 2019 14:06:47 -0700
Message-Id: <20190523210651.80902-1-fklassen@appneta.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes an issue where TX Timestamps are not arriving on the error queue
when UDP_SEGMENT CMSG type is combined with CMSG type SO_TIMESTAMPING.

Also this updates the UDP GSO selftests to optionally stress test
this condition, and report the reliability and performance of both
TX Timestamping and ZEROCOPY messages.

Fred Klassen (4):
  net/udp_gso: Allow TX timestamp with UDP GSO
  net/udpgso_bench_tx: options to exercise TX CMSG
  net/udpgso_bench_tx: fix sendmmsg on unconnected socket
  net/udpgso_bench_tx: audit error queue

 net/ipv4/udp_offload.c                        |   4 +
 tools/testing/selftests/net/udpgso_bench_tx.c | 376 ++++++++++++++++++++++++--
 2 files changed, 358 insertions(+), 22 deletions(-)

-- 
2.11.0

