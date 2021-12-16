Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A1547671C
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 01:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhLPArQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 19:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhLPArO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 19:47:14 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0CCC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:14 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id r23-20020a17090a941700b001a74be6cf80so12970177pjo.2
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AMeUDlbCvaNPe5VdCo2WIv1gI6blTnglwzNMgHnGKkc=;
        b=hgUh044JOm51muZn7OfflhgNaKhdAYIIzwmqQ1QsH4ILUP3jZy/SZIPre7PN4MnJuK
         4cLLzlZrOFZrOycC82Pzhs6tuN5C9UIBFHFaaoQkLuWNRxcxUJ8kKEFYpGkhPyh9QHST
         vk38u5r60pTdnVVdi2UsH53iW+xPvcfs9+GndvYUMiQqhIOV4vR79yRK3WyGC98IZ0wN
         nOrwDVwDTDPRSuTb6dwft/feFZkPSA0Be1MQGHss3IOoh/DfQPmKRen39HR9YBsnRbP0
         eQ0jW7tDcODJNdHKuv3czjnayHJHuWhCMrzzMFtVkBgD/s0DtSTV1i7NMjKe7Nkc71l7
         jApw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AMeUDlbCvaNPe5VdCo2WIv1gI6blTnglwzNMgHnGKkc=;
        b=qMpYjYMG96lycyC5Q0ls+QeDz+3N59wK23K4L5udfaolf6HcdN5yDH2brANGJYAfej
         ZKl3UsgTeBxmWfkbZqre1wIdN7c/r5b3+RGYIfLh6hEGVk//Wwx/V3CLWp4T8Mp3QkG4
         H+qzt8PpdYgSeSOSbcq4RyLRI1TWLEkrY3q3BTkxCD3dasatmC8l3qfJau52gauXCGiQ
         O16rio1DcqH2u+0dd3pJpRm5y6rIuqSyJpIY/N26hlAWVeQdVubJXE4fxadIECAgIsAI
         Bw8KIz0HP98l9esAL+RcMqg/AlOD+pnzRROZf7JLgs5ZaNXY9k72yn1UYQBZXQ4g2abG
         eTkQ==
X-Gm-Message-State: AOAM531aIyGCNk2Ek8xbSgjJGQaNVCATOAu2XSIHIl5WKVO3QCO5hbYk
        c/wqMuJJX6bIKRxIw3HPWMyk7Ic9ZnNqj7PhMkOEuPfO8nm5nICTYxwr4pjfD1HBklujcYsoyl5
        5UgMfhVtBH6vaqw5iwozpjDIUEBgblTR+590e39ET2o8jPR5tBlOzViEVH7sRzdTBg5U=
X-Google-Smtp-Source: ABdhPJz/cRZlfXqiDAaoG605N+g/rorna5opbT8m5E5S+DnVi1C2q1cjPI/bRAoYF8DXtVLfsHan2OnKk/4CoA==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:964d:9084:bbdd:97a9])
 (user=jeroendb job=sendgmr) by 2002:a17:90b:1a88:: with SMTP id
 ng8mr2865349pjb.180.1639615633903; Wed, 15 Dec 2021 16:47:13 -0800 (PST)
Date:   Wed, 15 Dec 2021 16:46:48 -0800
In-Reply-To: <20211216004652.1021911-1-jeroendb@google.com>
Message-Id: <20211216004652.1021911-5-jeroendb@google.com>
Mime-Version: 1.0
References: <20211216004652.1021911-1-jeroendb@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH net-next 4/8] gve: remove memory barrier around seqno
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

No longer needed after we introduced the barrier in gve_napi_poll.

Signed-off-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 3d04b5aff331..9ddcc497f48e 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -639,8 +639,6 @@ bool gve_rx_work_pending(struct gve_rx_ring *rx)
 	desc = rx->desc.desc_ring + next_idx;
 
 	flags_seq = desc->flags_seq;
-	/* Make sure we have synchronized the seq no with the device */
-	smp_rmb();
 
 	return (GVE_SEQNO(flags_seq) == rx->desc.seqno);
 }
-- 
2.34.1.173.g76aa8bc2d0-goog

