Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3AAA2B9E
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfH3ArC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:47:02 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40573 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbfH3Aq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:46:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id t9so5573915wmi.5
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=byOve4hK9MD9IaKQiPRozkAVI6p2OHZpeb9FYCyxWzo=;
        b=uFB8t/T/tAidqe01wunpd4FmCb/n3VU6NewGCprHfzwl9F9xC71Uy9FdSE0VDcqlAR
         zhRVXHtfaxH9NfiMFPShic7WoF1F/nUdf/wORLosy8XVFtMe/AOhmnQY3HueW+hpMbQO
         WKnx5yCECsBj7mCdl8QB2LWgqNIzI92Lai+X+dCRYRPnn5qDEm4/SvVU0umcIkGToebA
         yodKfOZFd5/Dg8P8EaG6OnyzI2Kpq1kZEsYgXhVTEIIkcH12aPLwVAChS+qh6tn6TYIZ
         mF0g/WA9D02f7R9NvyrxGAkRt64mqw0CsLg2GoDU+k6u0NtHiTzE1cjURr3NsgXPXJXP
         XTyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=byOve4hK9MD9IaKQiPRozkAVI6p2OHZpeb9FYCyxWzo=;
        b=L2puGT+apfkA80UzMKt7geTYomc7omRtan9jX8GdUxcJLttErCTagSo9M8TkNfsBDe
         bV2Q8U9ny339B+7aQnmPiB0aKrtVCxG8oUOropTE5Q9J6YbAoAoJ1s/gp1zoNqkHsKY1
         Qpm2SQixstOgxHqHFlGUA26+mnXaDy2AnsVnBM7PLDrnlCvrw4rtiOegnc9OIQNuSb7/
         3qhU35KLcjkmIgLaf0LkIoE6IPxvT4/N6renoaudkVjh/Dn/tcrsvXO4bC5mbc8YDtlV
         B49kNDVue2Z8CFbQjP0Sb7ujE4f0IVsZ+DiOPPqLO8kcOACDOxLie+krnjTrJHscANXK
         QrBg==
X-Gm-Message-State: APjAAAV/ugxmpw7fpQZv7TIqRh5XKEiBeigTwfuF6d3dbyF0/RZ5FO80
        5+yg+q8TH/k96hzaNJlVM4Y=
X-Google-Smtp-Source: APXvYqyu2Od/xLv0ZXlD7Z1LVDk+CAUjr9MmhOUBo4R1bZjpMoFLQGRB4kWvhmduWQB/o5kXvz4OqQ==
X-Received: by 2002:a7b:cd17:: with SMTP id f23mr15001392wmj.177.1567126015673;
        Thu, 29 Aug 2019 17:46:55 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id y3sm9298442wmg.2.2019.08.29.17.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:46:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        --to=jhs@mojatatu.com, --to=xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH v2 net-next 06/15] net: dsa: sja1105: Disallow management xmit during switch reset
Date:   Fri, 30 Aug 2019 03:46:26 +0300
Message-Id: <20190830004635.24863-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830004635.24863-1-olteanv@gmail.com>
References: <20190830004635.24863-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose here is to avoid ptp4l fail due to this condition:

  timed out while polling for tx timestamp
  increasing tx_timestamp_timeout may correct this issue, but it is likely caused by a driver bug
  port 1: send peer delay request failed

So either reset the switch before the management frame was sent, or
after it was timestamped as well, but not in the middle.

The condition may arise either due to a true timeout (i.e. because
re-uploading the static config takes time), or due to the TX timestamp
actually getting lost due to reset. For the former we can increase
tx_timestamp_timeout in userspace, for the latter we need this patch.

Locking all traffic during switch reset does not make sense at all,
though. Forcing all CPU-originated traffic to potentially block waiting
for a sleepable context to send > 800 bytes over SPI is not a good idea.
Flows that are autonomously forwarded by the switch will get dropped
anyway during switch reset no matter what. So just let all other
CPU-originated traffic be dropped as well.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index abb22f0a9884..d92f15b3aea9 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1391,6 +1391,8 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 	s64 t12, t34;
 	int rc, i;
 
+	mutex_lock(&priv->mgmt_lock);
+
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
 	/* Back up the dynamic link speed changed by sja1105_adjust_port_config
@@ -1447,6 +1449,8 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 			goto out;
 	}
 out:
+	mutex_unlock(&priv->mgmt_lock);
+
 	return rc;
 }
 
-- 
2.17.1

