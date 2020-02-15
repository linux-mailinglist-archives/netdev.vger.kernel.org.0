Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B4D15FEE0
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 15:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgBOOqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 09:46:47 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39863 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgBOOqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 09:46:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so14408151wrt.6
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 06:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pbM+qc2CjFuZhucRJeTh/1ywTWbQ9Ox/1sBC0C+yFNA=;
        b=KnkV3IES4FhZ5j9zY5rgYX1z8owT4706IDKZKmHTxHsXmOYF7zYTjk0Xtm7HtbQfIn
         l7cL2liaxV5FjqTuBbgJibLh4MVutehh7y62BId8JPPtgFz677AH3wXuBb2j0Vgkuaof
         V5/ZcKxk6YjaaVul0iKS22tHWD2g0T/i91DONSs2mvFGNL06485Ak2rpgUb6FddoRh+m
         CuHRfDVXVf+77WoLk9sPx7MT3JkP8wCPYRNJSm2+sJR0NvKjAiIvPrsXSuLA5O2yJbCa
         S/gvGn4VN/Hdrh+uhpgP43k6yE6gRCxtX/BzpnXy/glimyTTHjOrAuCN+YdcJpWF0x+z
         04zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pbM+qc2CjFuZhucRJeTh/1ywTWbQ9Ox/1sBC0C+yFNA=;
        b=oc7fvRSpkDZ3GcDH3zhsRwOu6ghjj1Jq52n43KRAMf5Qioq7rDw2SU5LHCTXaAlyAm
         8fYulAUzAC0ZLxm5G6PHIs1YX7BTEU0A0HrVgRGI/mNovClRfaXMa6UVHnzZpExIQdVw
         Pieyw5l8XRLUyLoleWyFnVp6Pufc5iqgLr1Od6JvI2TQGo2VMzfDjBfljlm0Ngh9ggpe
         NykWN6SPahpvFJaFy5i77YQiU5nJH5T/8DKnvdQSw01DW+T6Ya53S9m5kGhSBDV7mBy/
         rTp40PoOPd9k0D8Ni4Rhlh0XdYIMenxI0joLo6zp5ugxJ1KzxXG8eo/xSeQarfCcGrq3
         0ZNw==
X-Gm-Message-State: APjAAAVlleHy0lLVZ/2z24Qrcu+j1HpJPY2nCTB+/wMkQlCxc0m8W7Sz
        DVUwj253Fdav40JwegaJx81m/aHML8X8XA==
X-Google-Smtp-Source: APXvYqwdQdGYN13g8C+tsHTO+R4uzmtuxdl7tDeBa0DxwwEJXZ8o8kaDRUDQM2MMZjp20wKI69p90w==
X-Received: by 2002:adf:db48:: with SMTP id f8mr9963034wrj.146.1581778002934;
        Sat, 15 Feb 2020 06:46:42 -0800 (PST)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id d13sm11825830wrc.64.2020.02.15.06.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 06:46:42 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net] mptcp: select CRYPTO
Date:   Sat, 15 Feb 2020 15:45:56 +0100
Message-Id: <20200215144556.956173-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without this modification and if CRYPTO is not selected, we have this
warning:

  WARNING: unmet direct dependencies detected for CRYPTO_LIB_SHA256
    Depends on [n]: CRYPTO [=n]
    Selected by [y]:
    - MPTCP [=y] && NET [=y] && INET [=y]

MPTCP selects CRYPTO_LIB_SHA256 which seems to depend on CRYPTO. CRYPTO
is now selected to avoid this issue.

Even though the config system prints that warning, it looks like
sha256.c is compiled and linked even without CONFIG_CRYPTO. Since MPTCP
will end up needing CONFIG_CRYPTO anyway in future commits -- currently
in preparation for net-next -- we propose to add it now to fix the
warning.

The dependency in the config system comes from the fact that
CRYPTO_LIB_SHA256 is defined in "lib/crypto/Kconfig" which is sourced
from "crypto/Kconfig" only if CRYPTO is selected.

Fixes: 65492c5a6ab5 (mptcp: move from sha1 (v0) to sha256 (v1))
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/Kconfig b/net/mptcp/Kconfig
index 49f6054e7f4e..a9ed3bf1d93f 100644
--- a/net/mptcp/Kconfig
+++ b/net/mptcp/Kconfig
@@ -4,6 +4,7 @@ config MPTCP
 	depends on INET
 	select SKB_EXTENSIONS
 	select CRYPTO_LIB_SHA256
+	select CRYPTO
 	help
 	  Multipath TCP (MPTCP) connections send and receive data over multiple
 	  subflows in order to utilize multiple network paths. Each subflow
-- 
2.25.0

