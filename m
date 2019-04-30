Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71CCAF929
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 14:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfD3MqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 08:46:07 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38575 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfD3MqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 08:46:06 -0400
Received: by mail-pl1-f196.google.com with SMTP id f36so6678542plb.5;
        Tue, 30 Apr 2019 05:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+SHDYhoT7yzWGQoKK7GNVw6jL5ApU1S48wIix1XWmW0=;
        b=HyGhI8ysHdGGF0okgTADzSVz0l5itILr0VjXof3cbCjjRHdUP69FmO+07lNmbriub9
         yxwxa2hA+K9nBqfRfB4rpsV5debt0waUyKho6gSj6iIbko9C/6HsvyDdbVDj7pMBBD7P
         G3U7eXu7HCbAFsvhTrMdeDe1t7HWMX7fQDDL0jMFjCu5s5Fk9h8kSsFUsYNnikzrerjG
         Xd9okNOQb0t+RXm58W79mmVDR9V+lm0w9ndqH2DvbkaGC8yDA4qGDMxA2HkeZ0vn9DC9
         OI1lhtz5/McKP0yRYxr+/hc1n6u1Gb0/BN2jUGTVoX3v/TzO31HKfadu+WI5t7sIXpB2
         wOkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+SHDYhoT7yzWGQoKK7GNVw6jL5ApU1S48wIix1XWmW0=;
        b=P5FYrOmwVqRQ9T4O+ZoeHrA0MADdVFqZqamSjrRnt20WMidIHFOpCW9dRyaBwSxL90
         gx8jisAUSocEC/ZjVB8OifVxEC5TmtjjDayQUyGaniSDGFx5/XDeJVqFqtUC4PQakveF
         6WN2U1cs8eCz7cPiHsh/vNdJLxVF7vE/fx3UffjrG4hXf+OfD2fPnA6i5YJY1AZNdt0G
         Cx0xq2oo+RsAt/2+Z+aM855ukoP8s0H6fJuHnOTSSMV0pWfYcl7AcAchZ673HpPjGYTn
         4mJfLDAvGqKVBDk5Fja0+HL9A7A6dW/cd6IkCr/o7ONs6XrIf25sIEp4hCbshLeAgwVx
         UToA==
X-Gm-Message-State: APjAAAVR8PPfLAEeHjf782OWXSyWQOs/v7kAFIvxOqTJlM7yDzvwZQ9e
        W0PWElFlwxioYLmz7YDuyt8=
X-Google-Smtp-Source: APXvYqzOMyUVpg2lNVH7XtnfgKclpcjZPDGAAqnrGtZkFgcEOLW2ijFjH3n3QU1WikIeqEYFXSM6Bg==
X-Received: by 2002:a17:902:6949:: with SMTP id k9mr11655994plt.59.1556628366306;
        Tue, 30 Apr 2019 05:46:06 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.41])
        by smtp.gmail.com with ESMTPSA id u5sm52334523pfa.169.2019.04.30.05.46.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 05:46:05 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, u9012063@gmail.com
Subject: [PATCH bpf 0/2] libbpf: fixes for AF_XDP teardown
Date:   Tue, 30 Apr 2019 14:45:34 +0200
Message-Id: <20190430124536.7734-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

William found two bugs, when doing socket teardown within the same
process.

The first issue was an invalid munmap call, and the second one was an
invalid XSKMAP cleanup. Both resulted in that the process kept
references to the socket, which was not correctly cleaned up. When a
new socket was created, the bind() call would fail, since the old
socket was still lingering, refusing to give up the queue on the
netdev.

More details can be found in the individual commits.

Thanks,
Björn


Björn Töpel (2):
  libbpf: fix invalid munmap call
  libbpf: proper XSKMAP cleanup

 tools/lib/bpf/xsk.c | 192 +++++++++++++++++++++++---------------------
 1 file changed, 100 insertions(+), 92 deletions(-)

-- 
2.20.1

