Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AABE42A4077
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgKCJl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCJl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:41:56 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A236FC0613D1;
        Tue,  3 Nov 2020 01:41:56 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id u4so1434343pgr.9;
        Tue, 03 Nov 2020 01:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=71pEoABsLOEAuijMMTA3hRAUwqnBuXZOUGcdfoF5GQ0=;
        b=UU1TEjmrUmCLXP6heyM5/FGX8qbADy9djjoC56rwgBHcyrdoRNlnQwbxEk/XHVAeI4
         eciwHUQ9ovyn8rn+Id6xbj/UHY7xXp4lIZ88XuGigjExJZgFv0iBWZdRaESVnqJ3hV9z
         HxX1oP9wHbYuEEBz9GmNHT5uN65QYuAHAk1it3sUxGwuvxefvjTX5JPtUGsYFH4fNYxQ
         vVJ9dYPDVwr2xCNZKkXrUrCZLAJgbRxXG5f2LjrSTaouRm8BA/6RsptdHurCuSkH8NXG
         SC7ZfBFU61Xj3NEcKcZhtGGJldKwOO8pv1zrB4DAkXi63jcX2rnchCZC/xpI45anfvSF
         cJLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=71pEoABsLOEAuijMMTA3hRAUwqnBuXZOUGcdfoF5GQ0=;
        b=LEoDVXftjfb5lIeRCz9ctZa6OJ5k882yhQ91b/gSX3GXH7Xr5AlAbw5ycrCVL3BQ1i
         y9uHMQoaZs43+KlLaeq2IwvhhGt5kITh7mH1TMKIS0bXcwHq3fnYqT2uBbeKcQvrTiAV
         mdSvdp08NrK4kpzI+++25oiIbhJzX6wCpO+pM09QP5PdsKJuHqD2VuVbUf47++2CGAxo
         pMpj+tzoMS/h0Ad72lRvW9wKLzbsj7FDjWk1Hb2Ff9wCKLEuHSVgoSg9bAZj2x97Ixka
         iXb11CWozQKoyQH7Vsu6Wmq7IXZIXUtYIZ/KeWApg3H5XtetfhAjz8rYIMdqV93KVATY
         9IRQ==
X-Gm-Message-State: AOAM530RiQ8oUQklI+yP9uhBXygKR88tEFYInGZEiFlqfErZ/mCM/hGJ
        wceFPFm8/5MKWGWErw2MU++xlZa446BTcAKb9xc=
X-Google-Smtp-Source: ABdhPJwu0zWoU0g7+5SWR2aoKpI3hIkyU6fCeF+qO7sLpaTKzMBfWWenvQFIOVymjzLG/C8/xmwbOw==
X-Received: by 2002:a17:90a:540f:: with SMTP id z15mr2860609pjh.111.1604396516323;
        Tue, 03 Nov 2020 01:41:56 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id b16sm16419842pfp.195.2020.11.03.01.41.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2020 01:41:55 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, andrii.nakryiko@gmail.com
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH bpf 0/2] libbpf: fix two bugs in xsk_socket__delete
Date:   Tue,  3 Nov 2020 10:41:28 +0100
Message-Id: <1604396490-12129-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series fixes two bugs in xsk_socket__delete. Details can be
found in the individual commit messages, but a brief summary follows:

Patch 1: fix null pointer dereference in xsk_socket__delete
Patch 2: fix possible use after free in xsk_socket__delete

This patch has been applied against commit 7a078d2d1880 ("libbpf, hashmap: Fix undefined behavior in hash_bits")

Thanks: Magnus

Magnus Karlsson (2):
  libbpf: fix null dereference in xsk_socket__delete
  libbpf: fix possible use after free in xsk_socket__delete

 tools/lib/bpf/xsk.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--
2.7.4
