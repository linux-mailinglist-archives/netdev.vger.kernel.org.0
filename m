Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C097D100EFE
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 23:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfKRWzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 17:55:35 -0500
Received: from mail-qk1-f201.google.com ([209.85.222.201]:54092 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKRWzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 17:55:35 -0500
Received: by mail-qk1-f201.google.com with SMTP id s144so12419257qke.20
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 14:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=T32Rb6g2SHamfdiMAguvghJ70n8sNGBtor6Z7vA/pVE=;
        b=Xd/9mGAk975A7EnlmwTCTWXg1Ew73ijveVbvpIPTfZdKVWbTJrEGLXfcLQwx4Wn3jU
         Sets0gqPv0zrJv9/WnzaoJY+rSrqbhlVEUN5WGxujBtxABTjSEva2smGUBJFptyLCKb3
         fVGJ0xTWnhB4C2zCvcJQuLJ3pb+/1H5c5HXcZkPT2XbiaElzOEyOgGraKEFZfSiCgM8W
         T1OnLDfA1nMoOf5B9tMcbno9BKmOSarO8rH6sz547/u7rMCAf8INJnXB/QgDQvbUqlCM
         k589p5niyRXGkyXIzTqDvgRY2bZc47AvSWF7ihzGwlBmLunIZFF2AOMowwBoVb4Kq8sj
         lFkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=T32Rb6g2SHamfdiMAguvghJ70n8sNGBtor6Z7vA/pVE=;
        b=QkYVtAZxtkXqVp4GuyelcQyZgzjKrp9XZL0lXG+l7bqygY8AfJjy5StdIl7WVC6Y0h
         oyFVxs6EU0HOesiQ7NGMM2t+7hijIXrZaLlnzVLvb/hho3jFVYiJksx8RMKT5YeBtpVN
         Zl91pI3q16jVemkbU6DCGyGIEfS+eSwPEIvz4qPMFfaVGnDTPCWcdhOscdHhApy5i6T8
         C1eZK90R+buJ8MDGc/6JCbPKqdCCawOAlG4OR3aawVClz6Fl6w0p+1SCF54/irnE6wi5
         EvQgfx8q37msFLcCnpJAV9APvc8xxKyXGqm/mwxTjREvwlwjV6laAYJ4kiagTOt49TBO
         BE+w==
X-Gm-Message-State: APjAAAW1YLUuXCZJdtOkx1UJ52QocyisjWmnG7yIctHEsi7tKRqYwgzk
        eEhU1M/6MbPl7NUZg8naHSdsDMrfHxE=
X-Google-Smtp-Source: APXvYqzjGajv3e44C7N5V7bO1h7NEzSi6kSFeUIiJ6Lev7MjXXPlxmqfsZUQNSArrHpqBEMPgMfezJDQ33Q=
X-Received: by 2002:a0c:94fb:: with SMTP id k56mr28781169qvk.127.1574117732372;
 Mon, 18 Nov 2019 14:55:32 -0800 (PST)
Date:   Mon, 18 Nov 2019 14:55:23 -0800
Message-Id: <20191118225523.41697-1-lrizzo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH] net-af_xdp: use correct number of channels from ethtool
From:   Luigi Rizzo <lrizzo@google.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        jonathan.lemon@gmail.com, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, rizzo@iet.unipi.it,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers use different fields to report the number of channels, so take
the maximum of all fields (rx, tx, other, combined) when determining the
size of the xsk map. The current code used only 'combined' which was set
to 0 in some drivers e.g. mlx4.

Tested: compiled and run xdpsock -q 3 -r -S on mlx4
Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 tools/lib/bpf/xsk.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 74d84f36a5b24..8e12269428d08 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -412,6 +412,11 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 	return 0;
 }
 
+static inline int max_i(int a, int b)
+{
+	return a > b ? a : b;
+}
+
 static int xsk_get_max_queues(struct xsk_socket *xsk)
 {
 	struct ethtool_channels channels = { .cmd = ETHTOOL_GCHANNELS };
@@ -431,13 +436,18 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 		goto out;
 	}
 
-	if (err || channels.max_combined == 0)
+	if (err) {
 		/* If the device says it has no channels, then all traffic
 		 * is sent to a single stream, so max queues = 1.
 		 */
 		ret = 1;
-	else
-		ret = channels.max_combined;
+	} else {
+		/* Take the max of rx, tx, other, combined. Drivers return
+		 * the number of channels in different ways.
+		 */
+		ret = max_i(max_i(channels.max_rx, channels.max_tx),
+			      max_i(channels.max_other, channels.max_combined));
+	}
 
 out:
 	close(fd);
-- 
2.24.0.432.g9d3f5f5b63-goog

