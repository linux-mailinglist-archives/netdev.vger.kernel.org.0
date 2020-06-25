Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A29209DEF
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 13:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404674AbgFYLzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 07:55:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58555 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404652AbgFYLzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 07:55:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593086116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wGT3qBYmtlNm7VbabgpoFKFwexBpZntpyA+fDg/nDwk=;
        b=hoNqiT66OK2wafxBqkMHVDdqC76LN6sK8GeX27ChJSjnfoezCZr6AG6H4r5rl7GvgntedF
        SKsQ1S0HzPQO9hRSN/CjLMrWedm2v+2uYPBsxZQi9rMfEfDa3zZFD4W4tkDXwA9+vlwkU3
        3tpu0WhAYK9fPzC3YJk+v8roiV2g/vM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-V82uLNafMo2dli1gsW-Eeg-1; Thu, 25 Jun 2020 07:55:10 -0400
X-MC-Unique: V82uLNafMo2dli1gsW-Eeg-1
Received: by mail-wm1-f72.google.com with SMTP id t18so6849295wmj.5
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 04:55:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=wGT3qBYmtlNm7VbabgpoFKFwexBpZntpyA+fDg/nDwk=;
        b=WcUNS/tnPDXAqBq+G68zul/Dt5JzAi3F7mbR6NNw9j1uImi4Ji0yUynCxHl5WyrkVG
         maYtLbU3QZ1rX96kStca3QWmb2aqcM8fPaLGnEMExMOOXGkrnG2REWWnum+pQ0Er9sao
         n4S550ntmX1dHB79ilFwL8p1hUGU8sRuhJ6u9cctTMQgEGQ5F5MhTI/cGo3eTC7xWzY5
         Au76XlHkHGIFez7Yh2GDMroy6luD8IxgXWxhDXM+K6z46o7XHgzoPnx9dM1XjpaYA+qU
         8tlo7cBWiq44ESz51hlkrtYrIkPqo/QMM897NlX+IwB/oUmOu1EXpV8FCPppiqHd3s36
         AUFQ==
X-Gm-Message-State: AOAM531PWGSvYNNJmGHwLF1CsMWl5o9sV8Gl6mimC2jYzcUzW6lNO5ci
        R70RGX0QXlb4Qm1wWvtemCJaj5mBOV6/todwRBAA1lIfBoqysBet4VWv57ikw0JCeVcO5dKu0S3
        fDIf2E3flwjhkfzQN
X-Received: by 2002:adf:a507:: with SMTP id i7mr39279920wrb.0.1593086109443;
        Thu, 25 Jun 2020 04:55:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGfAxqBQdT54TXBka/hC/Yk1+w80El0LGJCtPMPSOE33IV6f7u7la2SMPi+3u5TRNoTzTQSw==
X-Received: by 2002:adf:a507:: with SMTP id i7mr39279899wrb.0.1593086109201;
        Thu, 25 Jun 2020 04:55:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g16sm27455995wrh.91.2020.06.25.04.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 04:55:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 409631814FA; Thu, 25 Jun 2020 13:55:07 +0200 (CEST)
Subject: [PATCH net-next 4/5] sch_cake: add RFC 8622 LE PHB support to CAKE
 diffserv handling
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Date:   Thu, 25 Jun 2020 13:55:07 +0200
Message-ID: <159308610718.190211.15767931665695188384.stgit@toke.dk>
In-Reply-To: <159308610282.190211.9431406149182757758.stgit@toke.dk>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>

Change tin mapping on diffserv3, 4 & 8 for LE PHB support, in essence
making LE a member of the Bulk tin.

Bulk has the least priority and minimum of 1/16th total bandwidth in the
face of higher priority traffic.

NB: Diffserv 3 & 4 swap tin 0 & 1 priorities from the default order as
found in diffserv8, in case anyone is wondering why it looks a bit odd.

Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
[ reword commit message slightly ]
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/sched/sch_cake.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 958523c777be..78a702a4e1d4 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -312,8 +312,8 @@ static const u8 precedence[] = {
 };
 
 static const u8 diffserv8[] = {
-	2, 5, 1, 2, 4, 2, 2, 2,
-	0, 2, 1, 2, 1, 2, 1, 2,
+	2, 0, 1, 2, 4, 2, 2, 2,
+	1, 2, 1, 2, 1, 2, 1, 2,
 	5, 2, 4, 2, 4, 2, 4, 2,
 	3, 2, 3, 2, 3, 2, 3, 2,
 	6, 2, 3, 2, 3, 2, 3, 2,
@@ -323,7 +323,7 @@ static const u8 diffserv8[] = {
 };
 
 static const u8 diffserv4[] = {
-	0, 2, 0, 0, 2, 0, 0, 0,
+	0, 1, 0, 0, 2, 0, 0, 0,
 	1, 0, 0, 0, 0, 0, 0, 0,
 	2, 0, 2, 0, 2, 0, 2, 0,
 	2, 0, 2, 0, 2, 0, 2, 0,
@@ -334,7 +334,7 @@ static const u8 diffserv4[] = {
 };
 
 static const u8 diffserv3[] = {
-	0, 0, 0, 0, 2, 0, 0, 0,
+	0, 1, 0, 0, 2, 0, 0, 0,
 	1, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0,

