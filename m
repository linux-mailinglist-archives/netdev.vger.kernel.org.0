Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7BA18C53B
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgCTCWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:22:24 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:43035 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgCTCWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 22:22:24 -0400
Received: by mail-pg1-f181.google.com with SMTP id u12so2290318pgb.10
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 19:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qCNkHoQNwa71qulU8NIJc7TngKnFoxCGtoO6mKnH3LE=;
        b=q2FrPp+bSs6EwM+SWhOfTDMi8/cRSbXLSdIkkVNkKsD7QW++0nNzsVbUFiEKjbgVJ+
         1vmO15I35ZSrtec0zswcq06Wh/dzj7TNPrz3u0dAkC8dsUx3kYQJHbDnt4Xal0s+bv2x
         ui88+kpfkmQoLEC0il3JgupBG4v0U6+I3wAFE+psOvBGX6GC2JS6GZg6M6zymNqgElsc
         M/0voQt1Q4vFeQhQqbvs6A3bsm1mR92u3leg//Bf7UhyVq32VjdgLh5eydmlvElklTmj
         sI82TdG3LmX3LoFgll3Yme2JDM1sYBqoAEiS9IGDLHVYiyaM1t1vlv7FQ19R3FLHWxLN
         Y8AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qCNkHoQNwa71qulU8NIJc7TngKnFoxCGtoO6mKnH3LE=;
        b=r3QCXiqh+uDSRv/VSLejtUePjyElYfJg8BDi1faCKArXvTJFeJLeqyzu7+A07cr5nE
         hKgPepzuLn2ae1oa/4gHGaVdim0or3aVTu8MTkCrc8/BZo02LN4d58iyixWctSTsa5f5
         Zv+fdjua+jtZaZIlP9jQ2mEhKgwKs3JWqyFNvcu90oS5iXMQilNKGCQiHX2W3Btui8aZ
         3gBsvlKnRENQNxy1kEn3ch1dD1OkTz1o97Bc1tK9Rq1ssvvAmQGEEBZ+RW+yM30xC9S+
         HODqlzBD4tcPvoz8xucXrxmdYQBmLjVjcFeJxQ/J0WWNI9MbM6hswXZo5GGlhmib/BhO
         0ivA==
X-Gm-Message-State: ANhLgQ1uYgqtIYNkhnSYEIveUwcnZ0kEp1kbGgSISMaMqMpXuewNt+sJ
        FbU4eboS6KW00n1Ci4LGM6h/3Q==
X-Google-Smtp-Source: ADFU+vvDuc7MmazMvf4okj3GW4SYtH4UbV8g2zX3svcSLRTwLfXAGx6L+ggohvSx4m9jIJKXVlBpvA==
X-Received: by 2002:a65:44c1:: with SMTP id g1mr6453673pgs.362.1584670942961;
        Thu, 19 Mar 2020 19:22:22 -0700 (PDT)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id mq18sm3423993pjb.6.2020.03.19.19.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 19:22:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCHSET] Fix io_uring async rlimit(RLIMIT_NOFILE)
Date:   Thu, 19 Mar 2020 20:22:14 -0600
Message-Id: <20200320022216.20993-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we handle openat/openat2/accept in an async manner, then we need
to ensure that the max open file limit is honored. All of these end
up boiling down to the check in get_unused_fd_flags(), which does
rlimit(RLIMIT_NOFILE), which uses the current->signal->rlim[] limits.

Instead of fiddling with the task ->signal pointer, just allow us to
pass in the correct value as set from the original task at request
prep time.

-- 
Jens Axboe


