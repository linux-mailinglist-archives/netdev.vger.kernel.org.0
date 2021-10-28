Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B57943DDDB
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 11:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhJ1JjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 05:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhJ1JjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 05:39:11 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A01C061570;
        Thu, 28 Oct 2021 02:36:44 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s1so22270129edd.3;
        Thu, 28 Oct 2021 02:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=erzUkbCpRs7mF8JPNwqvfUrlKic2ZgXPblnwsdv+efU=;
        b=MLNAvumxitgWuRAjxQ9/9P1koVG/jxp+b6oW6HYvMbH2nOvmkcRY1p9y9xm2JJknq0
         jf3aYDDd6mO17go3YScwTYBmhIz5V6TCiUTVwHcTMQQuH3uJYELsA4b2t6Ux2XXnQLff
         jODYPzvqFRICTxDWliVjgZUecMICPopGIFIncfVYMdnjKFyQ0wde6sixpU9SZQrdqOQ2
         sCyTXOndItzrh0wgB+eo81eklooqHMA1oNp8f3rXJ5ZBI2dADFFremFk+XQ72vo5ctOz
         OJ7hI4cHDVPdIC5uSl9j/Zdu8aC3ryz/yjEuG4gseyGBok4KJtldT2Q9FRBJEGrl8L8r
         YWsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=erzUkbCpRs7mF8JPNwqvfUrlKic2ZgXPblnwsdv+efU=;
        b=st5FUilPOb0o5R9H9BaLpy3uS1Sr+wohpDKFLtPrpHq/tP3Nofn3hYuyllsrSXrsnI
         qdDbzQ4Xl6OpgdC/VycpO0JymFeAXFZsM3In69X2j17dDmL8P8ZJEs3Zlg4tTKUfH+gQ
         Z8qR7vJFW7hqmVFsFuLNj9Iov+Pq4RsPrel/dhw631/6YAz2swxgIjFoz7bl6Y7MAyK6
         5BDofMtpiw9rB2JOR/zMIk0jiPXJ2nYlKmMYvaALJsgngVW0oWHcBq589EcfyfTdd/JP
         yUSLk0wEJWOUpKYXb+QZQ0kT8RhrqjKmnBLeszKo2pmj+WmFU8lX8bX2L3Xmbef1IQvX
         McBw==
X-Gm-Message-State: AOAM532TxdziywyfUNEehOlxjpUOe8cSYmAdTA29fr+d4mi0TAW1B1il
        a+RTy4xsIV+xqLQlpGjm+hvAx6A4ExcWrg==
X-Google-Smtp-Source: ABdhPJwbegGbH3srxiy6hE5wkZLO76uMPbTh/63SidwxvB5um/gYvD+6UgLd4zxu75j137TOLDOMKg==
X-Received: by 2002:a05:6402:270e:: with SMTP id y14mr4567070edd.3.1635413802572;
        Thu, 28 Oct 2021 02:36:42 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id s12sm1379865edc.48.2021.10.28.02.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 02:36:42 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net 0/4] sctp: a couple of fixes for PLPMTUD
Date:   Thu, 28 Oct 2021 05:36:00 -0400
Message-Id: <cover.1635413715.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Four fixes included in this patchset:

  - fix the packet sending in Error state.
  - fix the timer stop when transport update dst.
  - fix the outer header len calculation.
  - fix the return value for toobig processing.

Xin Long (4):
  sctp: allow IP fragmentation when PLPMTUD enters Error state
  sctp: reset probe_timer in sctp_transport_pl_update
  sctp: subtract sctphdr len in sctp_transport_pl_hlen
  sctp: return true only for pathmtu update in sctp_transport_pl_toobig

 include/net/sctp/sctp.h |  7 +++----
 net/sctp/output.c       | 13 ++++++++-----
 net/sctp/transport.c    | 11 ++++++-----
 3 files changed, 17 insertions(+), 14 deletions(-)

-- 
2.27.0

