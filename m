Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF4D37004B
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 20:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhD3SQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 14:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhD3SQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 14:16:55 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E68C06174A;
        Fri, 30 Apr 2021 11:16:06 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id j6so9665452pfh.5;
        Fri, 30 Apr 2021 11:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KmcqyDJ2VQg7X8R17cfIVf5UMZAY471KiYxjT85/AL0=;
        b=syhubJjb8+KFZFHqnzoHcpUub+lubOVyLGgEktYGQLSKv9kEu+N6xqWwMkpYyqrhz7
         8f/PwiU9Yufz4u//G2HRzJEDh3wUC97DEBYxhRTPWqy1cUnHg06q8jNpYomUBGSSfukQ
         3jQlGwPviYJtAyFMd713IL4T8lBfXjDSSd8fvIET8TBk4BY63JlxglyqyDGf66dfB5g1
         Y4wIabdINlMHajA7qoXnUz4VruLN2TNUEii8XSqsdEc9VjduejiMiGrIHGTxdMxgBfyJ
         YDb36xTRj7t0YTkDNf1J/7VM1VhiCti5JbWOBhz0S8nCOtwiPF+lAc1ngm8ekyomnEM/
         IY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KmcqyDJ2VQg7X8R17cfIVf5UMZAY471KiYxjT85/AL0=;
        b=VTaW6CZPAf0gguVAFZIFkxqPZXvZG1bSMGJxtjjNb+FVHAih0Fckhj1inKr1oZ70dG
         B9qlnvrBxxUYUselySt6DFUq+kD8qppuOIYUIHPYZ+0QU6tF+barnpfdLtqxAt+0ahzE
         UA+8UYCiI+xyClpUuuv9AUrUXZhHNs9WHJBIX55iMDF5Me4y8HnNZ5Vj0yMupC6K+NXo
         DDR3FXbt7Z43aAn3q756CPRLaoZJ1Q6CkRLUDaEvi98jZ+VvsR3iI7gltCyKT8ulRPOH
         S8xHlckKI9b2ViRoxjBG1jtkgvXDBnjfqhs7nkgzlM35nV9Tub3CCm4V3j2v0iuFcHc7
         LkZg==
X-Gm-Message-State: AOAM530L0vonF3w9gyJ4UJe1+eoAS4s+71kaNK9qyahCG93vWhf5mNp+
        8BiC+ycstsV6Gy91YJ42GzocZk2Xb4J6Tbcb
X-Google-Smtp-Source: ABdhPJyU/RsvMVmlYmuNWDrQfOJdUhkBbNlCMGMfSIuGvat4II0f5y4IeKMNYL1e7l97ao9D2ilMkA==
X-Received: by 2002:a63:ff66:: with SMTP id s38mr5685615pgk.154.1619806566189;
        Fri, 30 Apr 2021 11:16:06 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t10sm8968166pju.18.2021.04.30.11.16.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Apr 2021 11:16:05 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        jere.leppanen@nokia.com,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: [PATCH net 0/3] sctp: always send a chunk with the asoc that it belongs to
Date:   Sat,  1 May 2021 02:15:54 +0800
Message-Id: <cover.1619806333.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when processing a duplicate COOKIE-ECHO chunk, a new temp
asoc would be created, then it creates the chunks with the new asoc.
However, later on it uses the old asoc to send these chunks, which
has caused quite a few issues.

This patchset is to fix this and make sure that the COOKIE-ACK and
SHUTDOWN chunks are created with the same asoc that will be used to
send them out.

Xin Long (3):
  sctp: do asoc update earlier in sctp_sf_do_dupcook_a
  Revert "sctp: Fix bundling of SHUTDOWN with COOKIE-ACK"
  sctp: do asoc update earlier in sctp_sf_do_dupcook_b

 include/net/sctp/command.h |  1 -
 net/sctp/sm_sideeffect.c   | 26 ------------------------
 net/sctp/sm_statefuns.c    | 50 ++++++++++++++++++++++++++++++++++++----------
 3 files changed, 39 insertions(+), 38 deletions(-)

-- 
2.1.0

