Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED40A2608C4
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 04:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgIHCwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 22:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbgIHCv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 22:51:56 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5168C061573;
        Mon,  7 Sep 2020 19:51:56 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id n14so1798688pff.6;
        Mon, 07 Sep 2020 19:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oYDQkL/bhnoRNoIQa0c7xAEVzjxqq6GJrC183rKt6Lg=;
        b=qjhBzU/ktIT+996SR13I7qu6tR5w4rnVNPI/KdWfzO5x5ovw9FLEPKRhvuPNhfMHMM
         AirY4ODw9Fqn1u4Li8WTehIaR/aehfnENJ1+3kkyVsX7sTienFRV8lh8654MtJrLCwJ9
         EkcBslNcgxj5QbBh2b4DdX7TM0IDOUv0RRbVnmS8cjxQRPdBlckzgvufa9Z0bv6a8CU4
         yiOgKE5BSu9uRsKuo/t7gUFj5gQMv79YtF7AW4HMMvBexEG3mIorXOuIJ5lrVUWzAEd4
         nfW87FtroKxgqFwyAuVQ5UD+VSGfYHJS+HWbQTC2cTnfUxAZOq5yy5s2XvRZsUpCLYVY
         OXcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oYDQkL/bhnoRNoIQa0c7xAEVzjxqq6GJrC183rKt6Lg=;
        b=hC/D0WU0Tqhu1/RmdkrwVb6glLcC4sSmOUkGneaueS3MnEnLfG1I3+xw7Z/jMVLDog
         t/m83Zx2vlNkR5sioibkTMErLhIu0kHgWks+P69l7rpaUEvCQ3GWwA6XHXkcLG0urHh9
         bUFySweVCyeXEm52CHqHpBd8+NhxpyQPqaYyb98yeQeroEHRpllvqLdIj+Y/ASDYcZqY
         pm4PMWWE613OLoN91m+16x2ZSOycLSJfZaj4mYrSH2qjB2I/EWIA0w6ZPWaV75jWIFR+
         28zxyks9UXva6IbR/ldpa3iZ/Ay5gJTPxw77U0iSLoBCOSLDqzuYGD9+FWZjXcVhf6ov
         J/qQ==
X-Gm-Message-State: AOAM531o4mBllAf6+yAYIRzrAqlP1ReFwMXo2eBYX8i0DLilyi7BdW1K
        qzKqVv798yHQI+cX60IGlSCQ0ndP0UicQg==
X-Google-Smtp-Source: ABdhPJwZEF+U6TzpxaWIyfzpAmO3edmRZOifGzPLkRav+uOSiwVxU/nW6Rhna9enTwb9QL4ledEC3A==
X-Received: by 2002:a62:1cc4:0:b029:13c:1611:653d with SMTP id c187-20020a621cc40000b029013c1611653dmr21753392pfc.15.1599533515384;
        Mon, 07 Sep 2020 19:51:55 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id g32sm13275288pgl.89.2020.09.07.19.51.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Sep 2020 19:51:54 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH v2 net 0/2] mptcp: fix subflow's local_id/remote_id issues
Date:   Tue,  8 Sep 2020 10:49:37 +0800
Message-Id: <cover.1599532593.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
 - add Fixes tags;
 - simply with 'return addresses_equal';
 - use 'reversed Xmas tree' way.

Geliang Tang (2):
  mptcp: fix subflow's local_id issues
  mptcp: fix subflow's remote_id issues

 net/mptcp/pm_netlink.c | 17 +++++++++++++++--
 net/mptcp/subflow.c    |  7 +++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

-- 
2.17.1

