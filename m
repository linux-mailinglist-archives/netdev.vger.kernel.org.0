Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5923EF8CD
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 05:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbhHRDlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 23:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236496AbhHRDlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 23:41:22 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57677C0613C1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 20:40:48 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n12so975029plf.4
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 20:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BsdVXbhtWjUQaskCMlUgEBNS4pC3NCkpK2fi3WMsLKs=;
        b=Ljf+4KWeVggSI4Lf6tc0A3nHEXXDjCM1/9HKrlbPRAGljqsAxLc2XrTWzSUlDcrMPh
         P6DnuN3vSN0v5bJ/HdgOf94oR/ORI+tgmH6XRTm2wnfkm5667m2RKbNnJ77J82+Nx5pX
         bpu+zhJrfZSTkVjY8NK3lNiH6W5lAUhuFMu7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BsdVXbhtWjUQaskCMlUgEBNS4pC3NCkpK2fi3WMsLKs=;
        b=i/bLRjkPQ27Eu4294xtI7BcSjtHeXYKDs0ZmNA0BZjahASkDpT1LQewD0t/3V25ijb
         3str5krKKJOQDeS0vS7FD5G4n8JzXMNaOdBsDQNlCMzgUxo0jUgiRee+tWuw2fY3cXOz
         +EGymQLlqU/u/AZywoJ6vc3KjJxtjlzd1/d10PaEsn9q7lleBrEejU1OM20ERa+9PTuT
         rZoho8ZvDqElRvP6ums2Sj0t5QhYPTYwFS2kIjkz5ybcBT3iQyGjimjQ+RGxQzfkpAEb
         vFkmfkykOPobmZUwvwpAlXP2KAWC2s6TplU/CEvlU8CcSBaaVG1SWCrEpTLcYer3ZgFl
         0Phg==
X-Gm-Message-State: AOAM530vFt+iKUW/unB66oOaPoJUizNk0j3FtSHNtk71Tf+wKvlgbNiH
        iNXqc91/be84m+ogQ3oDkswVew==
X-Google-Smtp-Source: ABdhPJw24WGCJrWQghLliT0HNHXvdWx3O8W8rtadIm9NJXzk0hbgrpwKdgVNf6ToS1Ukehs1HtNQaw==
X-Received: by 2002:a17:90a:6888:: with SMTP id a8mr7162828pjd.91.1629258047889;
        Tue, 17 Aug 2021 20:40:47 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y5sm3790937pfa.5.2021.08.17.20.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 20:40:47 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Wolfgang Grandegger <wg@grandegger.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] can: etas_es58x: Replace 0-element raw_msg array
Date:   Tue, 17 Aug 2021 20:40:10 -0700
Message-Id: <20210818034010.800652-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2405; h=from:subject; bh=2pghWRFPuQ+zVAOzO5gfNiPmiJDuiTH+Yfm+Ryq/M0I=; b=owEBbAKT/ZANAwAKAYly9N/cbcAmAcsmYgBhHIEaiZ+lXRC4QwUOqC71mOhS6HSGOj3Caw1KKYLF 7L2JZyaJAjIEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyBGgAKCRCJcvTf3G3AJsVpD/ j7xXbwKjJwKT2/GO+ODaujdBGdL6Osu0WV1eU4XmqS5JfJkc+l2PFtKNfj6weSU0gXlOjRX8zQo9Vk RGTXtjXdt7Cw6atuK6aFxzGJuFRek6LadYkYs7hUunrsAuHTyoV++Q/ltnSzptbX6zTZtKkzjT4Mnb 1sbL6mA+MGtTnYFO6cqc5IPv9qZZFZr7lOyYkpiztuUQjj1Lb8Zqj+/IP6sh7ePDPksNRFqHcIeEx4 u+cDgj0hCPPHdE4WRYbK2CSXjL5m9stprftBB5AfmdxXblnZIPW9w26iSWTVSKoyej3pB/f1upjQxs YUs4j6qklJb8pe1DGwrudFdZtGtFImGSL7ap+9UXyYhkU2txwLCOMZbwHhrSKTGw7C2c/GLTO+rceS qa/qXMGgpT1cMAkKX2yL1XK/wg4yCEbT00q4oj7XPLEcadol2gXH3dafW+/ydbcaY4kgxvYvBSewsP rXPTtLeoN4RpHB+kHdSXET3oed3KzRg6hS2x1078wD2iCE/RKQtbEyGHXPlpq8HOkHjCazT9CMbR9L cpAmLTqZeddlhGnvs0rlgQ8LxHHeEPEPCzyK+2blJZjg7aYahRjZlUm05YoPSQUN0XhInmO7oJIutG lbwOtuCNS2QSeh6mvvNab0mm/3Ibe3VZ8Kq/+P1m+l1sisDz595D+GbIOg
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While raw_msg isn't a fixed size, it does have a maximum size. Adjust the
struct to represent this and avoid the following warning when building
with -Wzero-length-bounds:

drivers/net/can/usb/etas_es58x/es58x_fd.c: In function 'es58x_fd_tx_can_msg':
drivers/net/can/usb/etas_es58x/es58x_fd.c:360:35: warning: array subscript 65535 is outside the bounds of an interior zero-length array 'u8[0]' {aka 'unsigned char[]'} [-Wzero-length-bounds]
  360 |  tx_can_msg = (typeof(tx_can_msg))&es58x_fd_urb_cmd->raw_msg[msg_len];
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/net/can/usb/etas_es58x/es58x_core.h:22,
                 from drivers/net/can/usb/etas_es58x/es58x_fd.c:17:
drivers/net/can/usb/etas_es58x/es58x_fd.h:231:6: note: while referencing 'raw_msg'
  231 |   u8 raw_msg[0];
      |      ^~~~~~~

Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/can/usb/etas_es58x/es581_4.h  | 2 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es581_4.h b/drivers/net/can/usb/etas_es58x/es581_4.h
index 4bc60a6df697..af38c4938859 100644
--- a/drivers/net/can/usb/etas_es58x/es581_4.h
+++ b/drivers/net/can/usb/etas_es58x/es581_4.h
@@ -192,7 +192,7 @@ struct es581_4_urb_cmd {
 		struct es581_4_rx_cmd_ret rx_cmd_ret;
 		__le64 timestamp;
 		u8 rx_cmd_ret_u8;
-		u8 raw_msg[0];
+		u8 raw_msg[USHRT_MAX];
 	} __packed;
 
 	__le16 reserved_for_crc16_do_not_use;
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.h b/drivers/net/can/usb/etas_es58x/es58x_fd.h
index ee18a87e40c0..e0319b8358ef 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.h
@@ -228,7 +228,7 @@ struct es58x_fd_urb_cmd {
 		struct es58x_fd_tx_ack_msg tx_ack_msg;
 		__le64 timestamp;
 		__le32 rx_cmd_ret_le32;
-		u8 raw_msg[0];
+		u8 raw_msg[USHRT_MAX];
 	} __packed;
 
 	__le16 reserved_for_crc16_do_not_use;
-- 
2.30.2

