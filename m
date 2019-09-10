Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 320E9AE1F1
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 03:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392336AbfIJBfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 21:35:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43514 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388210AbfIJBfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 21:35:42 -0400
Received: by mail-wr1-f66.google.com with SMTP id q17so12009641wrx.10
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 18:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hJDPVAoAGf1//gWGZS3c1fiTNSRPL5dnyQkTcKAGkQg=;
        b=Vxx1X+BS5PMrWubyqerW1cw7KZSVjiwnlPW0kPl+iIwyfSfPb2i0PtnwhlgPGt7FIu
         saJQWg/wVNo8upKAkQ8LFqUPL7NDmCdP3Qr5PDqjsrIBSvcenE8FzlbVrNoZ9Cu3ZZTT
         snrtUPDZyn5sLM9GmV74QVc7n5G9IOHZl9WmS0zezZMR7ID+QbNaW0+g8pt9q4Rr2sAg
         Rd2cDb0sESYV92nASaKXyDpFNvGkTysSh9LclbQ/DgTLGDFtBUF2796ioSfH+p1AJmh0
         O+rs9ip0Cu7s4pqxwlAAJhjteDQQIZXR+qwjGApoDGwVBEXWXNGUxcMDTD/XNiG1sO+k
         A+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hJDPVAoAGf1//gWGZS3c1fiTNSRPL5dnyQkTcKAGkQg=;
        b=fhKKAauwqtozFvrpE5TGcqChYHbVr5QLCRHBywgRmPMxjX7vI5hSt8fXChDPzfMnZ4
         gKN/5JP/1ayHoNo4jOMh/wa8ECE2M6YDqtXS3YWG8WZn+lQRKxhtxHkByGa5S1TDOXs5
         Ooywvd8v2L9/txtA2Lyz+aWa34S3xt7fGdfzGIlViMlv409Oq62rjwxk29JDe7K5Q59i
         XPCSMAlYbBeN2pln4BB8mT9DK9yXnKPXajwufZRxhLm5tF1wKnEVjgoUTfr+wtgcpH1W
         POnaeKu10x8Q+lG5zZMTflWDjyHEZkmOiwDjrJLKAWXjvHCjTuxReYWfJ4rR6CH9VsAr
         ChuA==
X-Gm-Message-State: APjAAAVm2IxGRKNcJ4M0LO7ugdBnUJ7r/Z2eyYCl+3G1zDpZFLvWmCcx
        finBHu++VFyBwuiN4oDbfsY=
X-Google-Smtp-Source: APXvYqxJ+q6PvgoDN2gGaXjySTBdkRRe/+ZYlw36XVK6qA5aQItWWhERoS4RSiys1dOZu+I6l+TjGQ==
X-Received: by 2002:a05:6000:b:: with SMTP id h11mr22981721wrx.270.1568079340017;
        Mon, 09 Sep 2019 18:35:40 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id b1sm1254597wmj.4.2019.09.09.18.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 18:35:39 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 2/7] net: dsa: sja1105: Change the PTP command access pattern
Date:   Tue, 10 Sep 2019 04:34:56 +0300
Message-Id: <20190910013501.3262-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190910013501.3262-1-olteanv@gmail.com>
References: <20190910013501.3262-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PTP command register contains enable bits for:
- Putting the 64-bit PTPCLKVAL register in add/subtract or write mode
- Taking timestamps off of the corrected vs free-running clock
- Starting/stopping the TTEthernet scheduling
- Starting/stopping PPS output
- Resetting the switch

When a command needs to be issued (e.g. "change the PTPCLKVAL from write
mode to add/subtract mode"), one cannot simply write to the command
register setting the PTPCLKADD bit to 1, because that would zeroize the
other settings. One also cannot do a read-modify-write (that would be
too easy for this hardware) because not all bits of the command register
are readable over SPI.

So this leaves us with the only option of keeping the value of the PTP
command register in the driver, and operating on that.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h     | 5 +++++
 drivers/net/dsa/sja1105/sja1105_ptp.c | 6 +-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 78094db32622..d8a92646e80a 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -50,6 +50,10 @@ struct sja1105_regs {
 	u64 qlevel[SJA1105_NUM_PORTS];
 };
 
+struct sja1105_ptp_cmd {
+	u64 resptp;		/* reset */
+};
+
 struct sja1105_info {
 	u64 device_id;
 	/* Needed for distinction between P and R, and between Q and S
@@ -89,6 +93,7 @@ struct sja1105_private {
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
 	struct sja1105_port ports[SJA1105_NUM_PORTS];
+	struct sja1105_ptp_cmd ptp_cmd;
 	struct ptp_clock_info ptp_caps;
 	struct ptp_clock *clock;
 	/* The cycle counter translates the PTP timestamps (based on
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index d0c93d0449dc..13f9f5799e46 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -54,10 +54,6 @@
 #define cc_to_sja1105(d) container_of((d), struct sja1105_private, tstamp_cc)
 #define dw_to_sja1105(d) container_of((d), struct sja1105_private, refresh_work)
 
-struct sja1105_ptp_cmd {
-	u64 resptp;       /* reset */
-};
-
 int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 			struct ethtool_ts_info *info)
 {
@@ -218,8 +214,8 @@ int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts)
 
 int sja1105_ptp_reset(struct sja1105_private *priv)
 {
+	struct sja1105_ptp_cmd cmd = priv->ptp_cmd;
 	struct dsa_switch *ds = priv->ds;
-	struct sja1105_ptp_cmd cmd = {0};
 	int rc;
 
 	mutex_lock(&priv->ptp_lock);
-- 
2.17.1

