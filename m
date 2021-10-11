Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FD7429771
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 21:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbhJKTTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 15:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234616AbhJKTTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 15:19:06 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A34C061570;
        Mon, 11 Oct 2021 12:17:05 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id j8so7347889ila.11;
        Mon, 11 Oct 2021 12:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Syk1cs8/HrH0SFzZk37fVrdx7LGrWdiOwE99JQB9Dw4=;
        b=lAqNTaPpGGcPvF/iiWYR1N8FzaG4+lYfDLMBesQFPS0XXBozHZBiUb5MVWXEqTII3s
         ezZZ6naNB9C1Jdc2M4piiCYZ6elnXsxorWBUSYIZnRLAMVNE2ZT3p96bo/0CGilrTr6F
         8FjDG+kPHAbDtnbPTlWPnAh1YseBaL8VPz2wEKviCcnNzjEvgZR/7oyL5EpI9HdHCuKf
         pmCsbDyvl6UX2FHRet9VxjPGt0+qgefUGlCzeyC1zuD3xAHkynG0DA2rwxGVURIJTT4q
         wBGK5Q4rcefPU1Qe/WABrRtpqXgWDtCXLKwS7vWUOysm3Gk2Wz1bjqMQU4H/spQn+FSG
         MwFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Syk1cs8/HrH0SFzZk37fVrdx7LGrWdiOwE99JQB9Dw4=;
        b=Mn904NPyPsGIBDfgV83MmcLeJixWqLqAGrJUa3D7K6z3HfaRwUEdyZU1Mdh13/5j+K
         Dmnf23ymSftGMQFA/7NqUZA/J638aYf4Jcz7JuYJcBLNl09+UFkMDBh5ZztXSyGxmU3L
         wCGV/OMoyWB3uZ+0DdNT/SBR2QnK47HXkH5lOfN6PRtgrW2BPVejt08+6m13jlkZ04Em
         l/2HSm7+hdTHuTNLqUvoEtDI8mTmIEJiIYU+qFUKB27VTdeyWmvW3pIoJ8RGfHfx6IYK
         qfBi66j7+NKpz7HpoBGQBoZbdRfGf/hWEPhMl30qvMDPrmskjDGSvSYp1EDft/hVpcki
         Lzpg==
X-Gm-Message-State: AOAM530LAL/UpwevzAZXLea9FvY5Ytt0okoDxzJ/pRRDvWzpMTMBLQke
        eLWiyRl/vNrL8O07CcytWvZz53+g66OA7A==
X-Google-Smtp-Source: ABdhPJxztpgZh0YwXOnCkWpkmffVjQCh+w1ZFzSLU1kvdZ4RW8awUofWJBenSjpk0gV0336xRGxUqw==
X-Received: by 2002:a05:6e02:1a42:: with SMTP id u2mr20929233ilv.214.1633979823600;
        Mon, 11 Oct 2021 12:17:03 -0700 (PDT)
Received: from john.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id n12sm4460077ilj.8.2021.10.11.12.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 12:17:03 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net, joamaki@gmail.com,
        xiyou.wangcong@gmail.com
Subject: [PATCH bpf 0/4] bpf, sockmap: fixes stress testing and regression
Date:   Mon, 11 Oct 2021 12:16:43 -0700
Message-Id: <20211011191647.418704-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Attached are 4 patches that fix issues we found by either stress testing
or updating our CI to LTS kernels. We nearly have CI running on BPF tree
now so hopefully future regressions will be caught much earlier.

Thanks to Jussi for all the hard work tracking down issues and getting
stress testing/CI running.

First two patches are issues discovered by Jussi after writing a stess
testing tool.

The last two fix an issue noticed while reviewing patches and xlated
code paths also discovered by Jussi.


John Fastabend (3):
  bpf, sockmap: Remove unhash handler for BPF sockmap usage
  bpf, sockmap: Fix race in ingress receive verdict with redirect to
    self
  bpf: sockmap, strparser, and tls are reusing qdisc_skb_cb and
    colliding

Jussi Maki (1):
  bpf: sk skb data_end stomps register when src_reg = dst_reg

 include/net/strparser.h   | 20 +++++++++++++-
 net/core/filter.c         | 58 +++++++++++++++++++++++++++++++++++----
 net/ipv4/tcp_bpf.c        | 48 +++++++++++++++++++++++++++++++-
 net/strparser/strparser.c | 10 +------
 4 files changed, 119 insertions(+), 17 deletions(-)

-- 
2.33.0

