Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAE5129AC8
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfLWUUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:20:12 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:35310 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfLWUUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:20:12 -0500
Received: by mail-pj1-f74.google.com with SMTP id l8so358522pje.0
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 12:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=atKEf0vDGZiu5CujjYEY85aFuWTborJflBf0MS2/6ag=;
        b=qlzNrvObV6BFT+JjM/Da4iQeWlQ/dhZHevDafTqAhmPtjrxB8DcMLETsQph/I9Oz32
         TpwI0lu3pcbeug/QFs0ExjrFyxjzry9oi1RneFDRHtt0hXwn3xR+ddZ/zio5fw+0PhhC
         c88OR9Z55wF1IIy7EbZoEgb6jku8n2q8Cgltzbzr9Vdr3Nw45f6X3Rx9tT6djKIdctfI
         hM3bbrxobGl4R+IIVK1fDYMDtNGDfbJ4NWyMBn+TuKKjC8ebaN80uXSORMdDvhFfqpSk
         gJYIj1YWboZVIQdLEvAFKXC6+DkTdQeUF+ETEZrLZuUy8LGUur+rWXmRuq/cb8c2+kAJ
         lpDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=atKEf0vDGZiu5CujjYEY85aFuWTborJflBf0MS2/6ag=;
        b=LRS1JOnponF2UcWLAYm+1XvR07eIRun5zTDaw/jqKFHWvshc0rN/CtNVRaXVyCeBiR
         GXtp3S5+pDOpCZq1Zl8cDwNv4/RKcIxqE465hZWBc0lElLBKvCgX7BdSmShxoIC5qKBJ
         TsXc300XtABw/n+M4gJG0iScazikguLJZJkIm0CKKsDKvbtrfsTEd03zC+n+aamqpDN5
         T1Gq67SqMJ4zRNIhQXSKG0yTo+27NmZNM4Sqg+SbYo75qomcCIrWsx+QQB/WCWyM9dO5
         dqExV1Erwm4JkDTA9a8s47j1Z8LfhZGcrA0aJRZMCUHoSeiOecnyJcBeZSXYqMY5Wi9W
         OMmw==
X-Gm-Message-State: APjAAAXFEW22Pg5qxU+mScLMyoItEXSZOGe8KRfz9LPFxRYmYGCR252r
        rYh3GkjP/AEABge8WYNZmku6eHZzg0iIcg==
X-Google-Smtp-Source: APXvYqzI2Z4HAcjCg1laYtomhMm4dgbdvS02bNJWgUIsRth4+SHoYZ04DpsJQ1MyiIZ2yxj1+0Exr/rKNvDKNg==
X-Received: by 2002:a63:455a:: with SMTP id u26mr33845021pgk.282.1577132409485;
 Mon, 23 Dec 2019 12:20:09 -0800 (PST)
Date:   Mon, 23 Dec 2019 12:20:00 -0800
Message-Id: <20191223202005.104713-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net-next 0/5] tcp_cubic: various fixes
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series converts tcp_cubic to usec clock resolution
for Hystart logic.

This makes Hystart more relevant for data-center flows.
Prior to this series, Hystart was not kicking, or was
kicking without good reason, since the 1ms clock was too coarse.

Last patch also fixes an issue with Hystart vs TCP pacing.

Eric Dumazet (5):
  tcp_cubic: optimize hystart_update()
  tcp_cubic: remove one conditional from hystart_update()
  tcp_cubic: switch bictcp_clock() to usec resolution
  tcp_cubic: tweak Hystart detection for short RTT flows
  tcp_cubic: make Hystart aware of pacing

 net/ipv4/tcp_cubic.c | 82 +++++++++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 31 deletions(-)

-- 
2.24.1.735.g03f4e72817-goog

