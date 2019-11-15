Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED7AFD450
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfKOFaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:30:03 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32977 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbfKOF3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 00:29:43 -0500
Received: by mail-pl1-f195.google.com with SMTP id ay6so3855223plb.0
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 21:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=lIff/HsuYUX4uhwWTx3aVYOPFjp52ImXeumnDjDhshw=;
        b=ZdTwm1d9Efmg5RBCb17XYd2ALis+3DV0tULR7SyLWLxP+EZEDSbYJw1GwgFrS5k7gr
         ZgOx0JDnwMInLiyLce5YAK+7xftVVhpwBFj1PPNIOV2rsfdXiE9FWu6snqZtBcn8xqjY
         kZyZbbHrGojcc/ySkh6p1kBCxP1A8tatQW4iA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lIff/HsuYUX4uhwWTx3aVYOPFjp52ImXeumnDjDhshw=;
        b=lqP4W7PmVx2/m4O23gyY4k+WqgjcA36Iy/WYRlWv/d3yYnvxruKRblY5hH9syru9ok
         GnV69Rm5VqJZGJ0yvlEiyWbW9GRQ+iUWxXzG63F9UmRs9mRiMi7OTsY0/AA4fUrhiTm8
         m6jrKOKwVSRqN9NHbOIvvFTw7yDAwmgMMIbjq5i7KNRFMjZXS3Fme6eVWg2iZnAa8oUr
         /1IPpY+sdYsoFttRZjySIrPiyxsL6BCX0fQZR+2d1nCIhrnKwRZPtJ3+xm7I8wYwZ+PA
         B+fll3d9nBHb+Ah8y4ESips2XJb3AUp8Lzrrs3XS/1dvBjhgmpp3gePBUtDXgeVMZtTa
         XHoQ==
X-Gm-Message-State: APjAAAUxkl4dwZ/7MlWuiPKNhJtWs94Z2btMBf0Hxtrs0VPQZD2oWcfY
        bGDmwkdHRJ+61L1M1JrhSsJOJQ==
X-Google-Smtp-Source: APXvYqy1G7d5ZLVqWMGLxX/au94Dv620lNHG5W446Zfu+MhtTYOS4k1eWDSBXwuFhLnBKVd1HLzF3w==
X-Received: by 2002:a17:90a:a616:: with SMTP id c22mr17732430pjq.46.1573795781306;
        Thu, 14 Nov 2019 21:29:41 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l33sm8120333pgb.79.2019.11.14.21.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 21:29:38 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Kees Cook <keescook@chromium.org>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        Sami Tolvanen <samitolvanen@google.com>,
        netdev@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] bnx2x: Remove function casts
Date:   Thu, 14 Nov 2019 21:07:10 -0800
Message-Id: <20191115050715.6247-1-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to make the entire kernel usable under Clang's Control Flow
Integrity protections, function prototype casts need to be avoided
because this will trip CFI checks at runtime (i.e. a mismatch between
the caller's expected function prototype and the destination function's
prototype). Many of these cases can be found with -Wcast-function-type,
which found that bnx2x had a bunch of needless (or at least confusing)
function casts. This series removes them all.

-Kees

Kees Cook (5):
  bnx2x: Drop redundant callback function casts
  bnx2x: Remove read_status_t function casts
  bnx2x: Remove config_init_t function casts
  bnx2x: Remove format_fw_ver_t function casts
  bnx2x: Remove hw_reset_t function casts

 .../net/ethernet/broadcom/bnx2x/bnx2x_link.c  | 351 +++++++++---------
 .../net/ethernet/broadcom/bnx2x/bnx2x_link.h  |   6 +-
 2 files changed, 171 insertions(+), 186 deletions(-)

-- 
2.17.1

