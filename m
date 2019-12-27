Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B10312B015
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 02:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfL0BCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 20:02:00 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50451 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfL0BCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 20:02:00 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so6992076wmb.0
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dgQKtxP/R03TWq5DIxr766UAp5B0TjINbFtQVtJEbiI=;
        b=J61nfOGxd0phbmfM3r7CzuCy1gSp2P0Nx83Q7GmOdgETyMx+DUp7hSxPdcM1Tj8RO0
         R59vWfdpj1gqSQSJBGGwwe7JObHHbzTRn9TG4JT5h4WnwN8PIrJ4Rwo/jofh58aC3I4+
         FhrGwD5915I+V22pVYhC9jHPyuRVrLkaj4U16LA9GtztoRNaXvFP4IHHhpqFW4cmvV42
         8XLs02bRk9RQ3+DP7kd1zf9vWveWMDk8LnDjrfrft/VV6M6sg1C2VQbg3J/SrTI69e5q
         +uuFr0I3kZVCjsKlDsL/6eQjEtUnr59CSCfxFhGA3fjTQEYSNGCYpVGqTaqgZKdSFW0W
         jajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dgQKtxP/R03TWq5DIxr766UAp5B0TjINbFtQVtJEbiI=;
        b=bT6+SusyQr2qxLiZ8tgWCnJA2NWbiaqb40EHEqSlUirrRoBrD9ckuP3NdV4bZtKLED
         7yIXcXvUD1MdrEA/YrP1IPGEOdKfau8VWTj6kVF+lG84VXw4WfZfDqUaoxfYvFua+x+w
         8Anoq/pvsJFlBv45rBhbxTOdN4JVlwZdmjuGRcc4orrlWhldSMNhNnykKblvvu4RY1Ac
         VQj40MKZkFxck9sBBv5+0Wgw0cAYi5e/gFyyyWmOeex8rT1+EfwiZlneNZu0pR63vqG9
         qxduqFMhn2TlQdohQ8sZEucEaIDJNgYUU8IchZmhyDO3jUO/ZOiw+gx7b3XMPChlbjvg
         yMog==
X-Gm-Message-State: APjAAAUnBX0imW1ykAsCQ5OXoxkkaUyl44Q3UNSx7qzpqBfEFVO29PoA
        P31uUd8gOOdfEwOM4tPW6mo=
X-Google-Smtp-Source: APXvYqwgtI993T7c3PXdVfI8mL5tUiwAvLZb+WRjKZr+rTcx2/QSC1GQ7GuCVlqpam1EeKb35T+LqQ==
X-Received: by 2002:a1c:a78c:: with SMTP id q134mr15315866wme.98.1577408518231;
        Thu, 26 Dec 2019 17:01:58 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id a16sm32457162wrt.37.2019.12.26.17.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 17:01:57 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: sja1105: Really make the PTP command read-write
Date:   Fri, 27 Dec 2019 03:01:50 +0200
Message-Id: <20191227010150.26034-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When activating tc-taprio offload on the switch ports, the TAS state
machine will try to check whether it is running or not, but will find
both the STARTED and STOPPED bits as false in the
sja1105_tas_check_running function. So the function will return -EINVAL
(an abnormal situation) and the kernel will keep printing this from the
TAS FSM workqueue:

[   37.691971] sja1105 spi0.1: An operation returned -22

The reason is that the underlying function that gets called,
sja1105_ptp_commit, does not actually do a SPI_READ, but a SPI_WRITE. So
the command buffer remains initialized with zeroes instead of retrieving
the hardware state. Fix that.

Fixes: 41603d78b362 ("net: dsa: sja1105: Make the PTP command read-write")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 56f18ff60a41..c373513127d3 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -237,7 +237,7 @@ int sja1105_ptp_commit(struct dsa_switch *ds, struct sja1105_ptp_cmd *cmd,
 	if (rw == SPI_WRITE)
 		priv->info->ptp_cmd_packing(buf, cmd, PACK);
 
-	rc = sja1105_xfer_buf(priv, SPI_WRITE, regs->ptp_control, buf,
+	rc = sja1105_xfer_buf(priv, rw, regs->ptp_control, buf,
 			      SJA1105_SIZE_PTP_CMD);
 
 	if (rw == SPI_READ)
-- 
2.17.1

