Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A30229BD0
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732910AbgGVPwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgGVPwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:52:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46642C0619DC;
        Wed, 22 Jul 2020 08:52:22 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 1so1497105pfn.9;
        Wed, 22 Jul 2020 08:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=b9pEP+t14gaVl+SxUPRV7rIzQh2/jV47Fd73cy9kCf8=;
        b=fFZGWCsAWrlhtSgmydklRV2+KSEHh1Ii1xlfwITdn5tWyPutjJQP22WDZzd5yD78I7
         6sd2lH9SYtHkxBqikw8ljaA7j0dyo2Mjnjuxr0SRzJYFGZAdZ2Jfw9DDKF0lBArTzUJv
         ENJdTj84myYVw664UsibjTSrNk/qxpOCw/uO+pmP2st4olRaVS1RZzeF+hr93em1nhEx
         SBvhcy3e4LJKyqNQpBC8pCoo8wI2MXHDu92k+8IWTdzyhzBSpQEJRWOTnAKWLhWfB8bl
         vehUBsLyUTR43NsAoS8YDA3c9xxfcfVutrOVXZ1t81TPxfsOKmlgyAG+xL9NA7yrRokY
         tHQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=b9pEP+t14gaVl+SxUPRV7rIzQh2/jV47Fd73cy9kCf8=;
        b=sEQK0TGc21wP49dvEBqSUVusvvihgKIvNh0cRO65ngjDLgVn6K/813ErFnA9WANlLf
         9uM+9561I4iBhMQoRUX2Azqm1B/IG7OmQXXtOP0Km9nkqHP8ms3zpEzMVEHpA3T0kaSK
         CGuYU+rua4LkGiNUnZFRdykQXE6RP5a3YVFaHRXQRaNALo4K1CvH4fz8AjleLnOVBTxn
         bac21YdgfDakDPkKVd4wMuQoPaP6K3p3JDHQe0PZPlMw8NltOMIdfdHVj2N94i6grfsK
         LQqSk3jng4yUdzpgNNbGTFC8YmhskJCLCCf6sPZzbLc5Pi/VutNhWMXJYpFQ3GK9XKVK
         Nb6g==
X-Gm-Message-State: AOAM530Gus4pKdeczuO29EUpdJjLU2+efy51QLSEUhigL2CUQRN66btj
        R9gZkTrJJF+8N8WsjD3aLlNJ6WCT
X-Google-Smtp-Source: ABdhPJx65HEuTVbsGcuOfM0uHth7EwWGqgE7uO4tWqFSifmGhcp/yHCyA8IYQIkMoYuTgkWIjSQrfw==
X-Received: by 2002:a63:4c48:: with SMTP id m8mr444835pgl.290.1595433141462;
        Wed, 22 Jul 2020 08:52:21 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q17sm26916pfk.0.2020.07.22.08.52.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2020 08:52:20 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net 0/2] sctp: shrink stream outq in the right place
Date:   Wed, 22 Jul 2020 23:52:10 +0800
Message-Id: <cover.1595433039.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 is an improvement, and Patch 2 is a bug fix.

Xin Long (2):
  sctp: shrink stream outq only when new outcnt < old outcnt
  sctp: shrink stream outq when fails to do addstream reconf

 net/sctp/stream.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

-- 
2.1.0

