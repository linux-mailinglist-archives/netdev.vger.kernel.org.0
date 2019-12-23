Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE95129AD2
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfLWU17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:27:59 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:41082 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfLWU17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:27:59 -0500
Received: by mail-pf1-f201.google.com with SMTP id x18so4352445pfo.8
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 12:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IoTuHLvTkppKfGXtFM+TrmI5ccJlB1q4gnJr2t9P38E=;
        b=kjX7EPTjIC8XqZ/tVMDf0Gv0QP3pn69r0xyqaCsZFtd8I4PTf2Y13stG+Ec4nkpImD
         IVyXxD+Y9gu6FYiX4/Z/wN6fxvHbOita6mUJdKqSCHUikLDOIVfEOLtxekma7zjDfxEr
         lzpn+s/2+I+lVAtbZ5ROb+P5NewieKHK+OFghFm7Un+sWd1s5uzFoQyEATrmSx1Dc/NG
         vD9GgB+m/43p6xs7zK5utrn9nqrUQVErK+W1FB+t9h3rbLKpLOY+Ls9/SR9DSKunjGi0
         hzloHwwAbwUYyakvsQS1NNooNzG6SJGrbBBumC3cU8QanlMlMpAaifiyCcFPuMWbhFpf
         T3Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IoTuHLvTkppKfGXtFM+TrmI5ccJlB1q4gnJr2t9P38E=;
        b=s1gEcBIAW1tMNYcY9MBPaxTargOzwtoqg515kgwuV0RJhah1/fzM3vJgepjmvUN3ZX
         Imm80PypOkgaiyT8/M4j+iTBUD6+sA7J+6ACMbpefzO8Af+lBGAVqhew7obHZAkmG5Aw
         mfE2320Pbwj1M+V7AIhlQNer/9dysKNar2oDpIG1FbDqqqhDsRgtaD9g3ajB91cXo/rY
         f2lhnzH+5Eb5N9W9Tw0he/6l6UykvtWnhgIR4DwC+jkOanWqP3rF7QiOc6fvtKxj+BIG
         /bYfOpQGptUGUj6cPK1SiociD97O2aZIg+6rpiE5lt9hbGFQSLKZVemQLOY5s08EAKAL
         jr/g==
X-Gm-Message-State: APjAAAXsOqL3IlCwV+D0/i4uVLZD8PxBoRDjswHZRbV6g5/0jWXCnyOl
        p7esvlXI5dQ68Grwv9p1IZQniUVzwjeTmQ==
X-Google-Smtp-Source: APXvYqw/u/dRyk6K2WWvhkFwSSncLhjD0sinhoDp/7pZ8kLYL6CTbwAjdwW5qd7qglEQVnDjxWxGCy6AgF/Rqg==
X-Received: by 2002:a63:214f:: with SMTP id s15mr34899046pgm.238.1577132878035;
 Mon, 23 Dec 2019 12:27:58 -0800 (PST)
Date:   Mon, 23 Dec 2019 12:27:49 -0800
Message-Id: <20191223202754.127546-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net-next v2 0/5] tcp_cubic: various fixes
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

v2: removed a last-minute debug chunk from last patch

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

