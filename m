Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7253A33F6
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 21:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhFJT0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 15:26:24 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:38619 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhFJT0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 15:26:21 -0400
Received: by mail-io1-f54.google.com with SMTP id b25so28242719iot.5
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 12:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0LR/OcJQA5f3nDTdvxLJUu8ZyXktmwHl0RJH9FX7qQU=;
        b=p8bKXIRy/IYNOEsQHxYEIA9Gjl3E5CCO326wvJDzLigfgsJXy7ISwuK1xQauRVmvjN
         6KcUXBGDXZJ4/UxE1TpcGAj9HIfEIVAtBOlizxO3wXy/VekaZlNeNQ0WBMwvrKGLeBjd
         tggx/s7Ky5VmyD+8uFpROFz6v6wgz6FCCPBBlXqgyU/081ycJMfM5trSt9q+oMIA26rg
         O9dx5NYFoZ1YzkZaJ5/EOdUa+gd/IGff5dtje9OsyJBHBea5UQwi3EzAEvz3JF9k6iY5
         2ePr1RKBXQvuOBqLuFmatvVA5EAFIFCpA/9V46i9MocEBL7EMMoN24j3NlsrLj1hNLHE
         7kqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0LR/OcJQA5f3nDTdvxLJUu8ZyXktmwHl0RJH9FX7qQU=;
        b=oholwY85DlZ1MzIzFxOEfE9mPbWjV0jA+MjcsXO8A+fMkaVsCUcnK7CgG1YL6rlZHs
         ecnvy9c7sTlfo76wpEBnOMOenRSGnTUkwlFGmzyMhVDerwhcJy3yqXCdNNTuLWI/midm
         64UzdiKETNGQSyc8tPe4XPkRU4L2UrWyxQ+B641pnIMH4MZNxRTkJGkCM79LYrfkpbKq
         uYq/aCIuoBvSlwSL4ibJ/d8uyYqnmr5O3nY0RL6ESLLLl2Ws7PdMM4nnIHrYrl8OfOU8
         vlzTXQUCuru4wPWWfbsI36e5kGAfQAeHxkl24SM5RrXMZD4v5hJ7ySJCLuLaCpN03gLe
         SzaQ==
X-Gm-Message-State: AOAM532y3+9iAdXY61p6n4lNwTblAsaXJpJfeMv2Mat+p9/XFkLB+oeV
        wSRBwSjwgHauqM3axYwxgNyWUg==
X-Google-Smtp-Source: ABdhPJxJvAmJ5Aw8IVf8MFUDDyV90tKS6G0r2DQ9J3FnHQN+ENtfoAYGiKjfYY480kvllUsunhoBUg==
X-Received: by 2002:a05:6638:144f:: with SMTP id l15mr169728jad.131.1623352992650;
        Thu, 10 Jun 2021 12:23:12 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w21sm2028684iol.52.2021.06.10.12.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 12:23:12 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/8] net: ipa: memory region rework, part 2
Date:   Thu, 10 Jun 2021 14:23:00 -0500
Message-Id: <20210610192308.2739540-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the second portion of a set of patches updating the IPA
memory region code.

In this portion (part 2), the focus is on adjusting the code so that
it no longer assumes the memory region descriptor array is indexed
by the region identifier.  This brings with it some related cleanup.

Three loops are changed so their loop index variable is an unsigned
rather than an enumerated type.

A set of functions is changed so a region identifier (rather than a
memory region descriptor pointer) is passed as argument, to simplify
their call sites.  This isn't entirely related or required, but I
think it improves the code.

A validation function for filter and route table memory regions is
changed to take memory region IDs, rather than determining which
region to validate based on a set of Boolean flags.

Finally, ipa_mem_find() is created to abstract getting a memory
descriptor based on its ID, and it is used everywhere rather than
indexing the array.  With that implemented, all of the memory
regions can be defined by arrays of entries defined without
providing index designators.

					-Alex

Alex Elder (8):
  net: ipa: don't assume mem array indexed by ID
  net: ipa: clean up header memory validation
  net: ipa: pass mem_id to ipa_filter_reset_table()
  net: ipa: pass mem ID to ipa_mem_zero_region_add()
  net: ipa: pass mem_id to ipa_table_reset_add()
  net: ipa: pass memory id to ipa_table_valid_one()
  net: ipa: introduce ipa_mem_find()
  net: ipa: don't index mem data array by ID

 drivers/net/ipa/ipa_cmd.c         |  50 +++++++++-----
 drivers/net/ipa/ipa_data-v3.5.1.c |  30 ++++-----
 drivers/net/ipa/ipa_data-v4.11.c  |  44 ++++++------
 drivers/net/ipa/ipa_data-v4.2.c   |  36 +++++-----
 drivers/net/ipa/ipa_data-v4.5.c   |  46 ++++++-------
 drivers/net/ipa/ipa_data-v4.9.c   |  46 ++++++-------
 drivers/net/ipa/ipa_mem.c         | 108 ++++++++++++++++--------------
 drivers/net/ipa/ipa_mem.h         |   3 +-
 drivers/net/ipa/ipa_qmi.c         |  32 ++++-----
 drivers/net/ipa/ipa_table.c       |  94 ++++++++++----------------
 drivers/net/ipa/ipa_uc.c          |   3 +-
 11 files changed, 247 insertions(+), 245 deletions(-)

-- 
2.27.0

