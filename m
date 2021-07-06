Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE8B3BDB6E
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 18:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhGFQef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 12:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhGFQef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 12:34:35 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FE4C061574;
        Tue,  6 Jul 2021 09:31:56 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f5so12588812pgv.3;
        Tue, 06 Jul 2021 09:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OE8Ug0nHbV0oYFi/5TL+dbVFHW3KswNUaumYncqBNAc=;
        b=hdWzUiRJGT6RAe9LFzEFDYoYlHcoHFhBIXkfKNUu4XksNqHogu54HAJsRnRqZv/h79
         /qWd7ooqHruDyDZI/e8RE5Cs4TJqAEOzl0ZMGBZtsdWM8QzBzTNvZ2v4W7+LW4vL2iiq
         OQi62C//DFHzLhiA1wl71xXqX1/AHVeozfhd46RRiPTOPvRattuHMXiocuxnOu6n4wzG
         +e9cFO6uKGLqHkNl61FFkeaW5oV2ROkSW030MsewstmC72zijJwcqcxM9gPYEYOT0swD
         SsP+xj9VfKSQ9xuW0fAs4s7H6Ro4BhObJfaTR+V/FNE3bEwdOCvQUiEJ9k9Yil6qAkmu
         KF4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OE8Ug0nHbV0oYFi/5TL+dbVFHW3KswNUaumYncqBNAc=;
        b=UGk/kdRIJzKUtG/d0aFh3yTIJ4keZBbJAnjnqEfSsJiRo1XEk3waSo0x+d5/d6k94s
         xN/K4KdL0nKutTIuwtPk0cJOPyqcs9tchmdfeXoehfM7RCBeROkACP4aZTfKDXH7TFH9
         TOV/yh+2k9fh/xTWGpuW0VWNYJ7R009ALjPDsFPTSi4hNAn5gCwHlsAx2QV20Lda73pN
         KJ7BIBrnXH/B7VGsZtuBp7GjDRdDPFTP4wuBEVoh9p4RLk2M6KH/JGfgMcZuWfIffqpM
         0M/dMNedaeIq7Z2Bdd6xGcVjoYAaA+P6Rkfwft6jbdwWQU/GORGtQkDT5QLX18C9DmX3
         YAgw==
X-Gm-Message-State: AOAM530jpl+edkEhouca64eet2/ILztj0RCJyfuzYYPByG76mISaShRX
        z+hjEtNdubGR0foPbqO0Gv0=
X-Google-Smtp-Source: ABdhPJw8YftT210m0Ez6BjT2PVc2eNhUo+BHasviAbB5epSUcOe/iX9pXoM3CTfNac1jYGlQIZJBNw==
X-Received: by 2002:a63:1f25:: with SMTP id f37mr21476177pgf.61.1625589115908;
        Tue, 06 Jul 2021 09:31:55 -0700 (PDT)
Received: from localhost.localdomain (51.sub-174-204-201.myvzw.com. [174.204.201.51])
        by smtp.gmail.com with ESMTPSA id b4sm14942570pji.52.2021.07.06.09.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 09:31:55 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        xiyou.wangcong@gmail.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf v3 0/2] potential sockmap memleak and proc stats fix
Date:   Tue,  6 Jul 2021 09:31:48 -0700
Message-Id: <20210706163150.112591-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While investigating a memleak in sockmap I found these two issues. Patch
1 found doing code review, I wasn't able to get KASAN to trigger a
memleak here, but should be necessary. Patch 2 fixes proc stats so when
we use sockstats for debugging we get correct values.

The fix for observered memleak will come after these, but requires some
more discussion and potentially patch revert so I'll try to get the set
here going now.

John Fastabend (2):
  bpf, sockmap: fix potential memory leak on unlikely error case
  bpf, sockmap: sk_prot needs inuse_idx set for proc stats

 net/core/skmsg.c    | 10 ++++++----
 net/core/sock_map.c | 11 ++++++++++-
 2 files changed, 16 insertions(+), 5 deletions(-)

-- 
2.25.1

