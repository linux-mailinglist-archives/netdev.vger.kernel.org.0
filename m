Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AD7222B9D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgGPTM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbgGPTMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:12:54 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFB1C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 12:12:53 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id 13so4432745qks.11
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 12:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=15PxXirdYPGH8nNqmKnIrkzrhtMUZqRV2iyOm02XE34=;
        b=CDK1ZXMgz6StLpm4Wt5WKYyCwh8dY6AnRZcniRl621fZvifhjKx+cNM+gWz4d3o+UJ
         X9Zt4iTdU+P6DhywaCf8k0CrgNVjmBTtDhTxEMmiBXgkALQ02d0qNV3eVjSA2XmgiMXm
         yCtRfdPerUdHHAsJcTqLmCfGoRuTNgjP9jmuxvFFl09i7HRRz5JafkpYx+VVlcdOQUp0
         zV8aDDCnzajZfDbZ0ZwZ0jYEX4ATRWj3RlXQ6ham8zBuMIZIm6MSEeY1Ho5U2vssowRC
         4MQ3IfPLrD+FsoOurwUubKFTOBG4ISalvOvVKQnfMGl2Q/qEKJxT+0qeezx5qgsmzlIM
         HHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=15PxXirdYPGH8nNqmKnIrkzrhtMUZqRV2iyOm02XE34=;
        b=pEG0kvLNnvomGtSSJ5mz+3MNid8h47KdvwGoOlQJvMl5xbs425JUC7fPcNQGskkBVz
         OZTSWnie6vGvCZ6oll6bWfcbRgO2oEiHZXHOaennJ6uY91vdZCIW5tx7a37drHvEy9sU
         SblPOCoUu5TG7lVJqV4sSgqob1mBTv2AtpTqdwr48/bjRoDnBeT189UO4QkuJnQvGvwD
         mzwjWra91ulajnny9/IvwYUAAzJQDkV3cY37v8RIqRQXzh9YiVar7bxh+TjnPdOEqaxM
         7/0ds5it7YjfqfSiW6KNeMwNK5MTu530N5RQokpVwjOzj+3Evy54+LCq4scW9DcsUOZ5
         086Q==
X-Gm-Message-State: AOAM533OscdSXC/1THS2xOxx+4DyPTuV2x3UJdS4yuad7nzst6Dp5fx8
        Ku3gQCiZCfdn4cWBHtQwly4dmbWKVM751dI=
X-Google-Smtp-Source: ABdhPJynqWOztbuSHaFs9ol8hnWQdYNtEfAgzTM8XPLhFqqzjXO3v5BmQG+JZRBEPtaYl+hBWQJ+apxUIBpo8XE=
X-Received: by 2002:a0c:e78e:: with SMTP id x14mr5881057qvn.65.1594926772812;
 Thu, 16 Jul 2020 12:12:52 -0700 (PDT)
Date:   Thu, 16 Jul 2020 12:12:33 -0700
Message-Id: <20200716191235.1556723-1-priyarjha@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH net-next 0/2] tcp: improve handling of DSACK covering multiple segments
From:   Priyaranjan Jha <priyarjha@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Priyaranjan Jha <priyarjha@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, while processing DSACK, we assume DSACK covers only one
segment. This leads to significant underestimation of no. of duplicate
segments with LRO/GRO. Also, the existing SNMP counters, TCPDSACKRecv
and TCPDSACKOfoRecv, make similar assumption for DSACK, which makes them
unusable for estimating spurious retransmit rates.

This patch series fixes the segment accounting with DSACK, by estimating
number of duplicate segments based on: (DSACKed sequence range) / MSS.
It also introduces a new SNMP counter, TCPDSACKRecvSegs, which tracks
the estimated number of duplicate segments.

Priyaranjan Jha (2):
  tcp: fix segment accounting when DSACK range covers multiple segments
  tcp: add SNMP counter for no. of duplicate segments reported by DSACK

 include/uapi/linux/snmp.h |  1 +
 net/ipv4/proc.c           |  1 +
 net/ipv4/tcp_input.c      | 81 ++++++++++++++++++++++-----------------
 3 files changed, 47 insertions(+), 36 deletions(-)

-- 
2.27.0.389.gc38d7665816-goog

