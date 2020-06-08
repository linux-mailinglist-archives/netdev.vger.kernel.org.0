Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D731B1F2000
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 21:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgFHThU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 15:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgFHThU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 15:37:20 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11314C08C5C2
        for <netdev@vger.kernel.org>; Mon,  8 Jun 2020 12:37:20 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id g62so12168698qtd.5
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 12:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=by8cJEioFTpEdRbqT2mRW0Cy3MJHn3+LTVQ596HzNBo=;
        b=bly4NsdGLSqNbcYttzr9rv6ARVwuzyXqmH3GJttIK6RK/BvOaGeFKMFOIAI8e99dFZ
         MPxJPI3IpZAEEp558C6x+ZWEWznTiGsxJh/Lhz+NUA8qrHRrVcNFGEEcbDU46QdQEMmU
         Wuz7/2YSx7qt853C8AlnaxiOdZEnXVFHyCPZ2hF2bP+jnPx4FGqljusP/TE0+9AIlwKI
         65NbJG/Hi9GUe1UmAk5veJINppNzl1YjLPLvo81qp44rduPxR0KJHiA0BgU75myTCtay
         0UzmGiXu4UrKp/aznlGwucPPG34hRkkBa6Iw81rIIGVZYINqYAv2ATBQDuFpfdjr2Y8o
         UAxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=by8cJEioFTpEdRbqT2mRW0Cy3MJHn3+LTVQ596HzNBo=;
        b=BuyuN9i15Z7f1MSvNyylbb495LibvW05Q45/sv8Vg9JokD8zASUlWPo6EWHjKv01Zx
         qocVoRLrFA/Hsv8d480pxsyJUd9gVHLXvOOuoALunA30epD6qjZVdDe7qbf6HVZ0wFVo
         ABpczwY9OEiauoJWRR5u2oQD9YmAdCDzP9JkylAOH0krxBhir24ruyGfBajMwQ7qJByD
         dKCCdZqcSlb0LEwvGdtVk55xXwthDXncjFOHveuRCOXHBJRSEPbSi7NFesO3LaMP6zBZ
         bHvGiip/M77acqUsWhOR056e7WSXrl3lzqOvY3fguVpbSbJXcHUQL0jOH+vScEXl+u/N
         ngBg==
X-Gm-Message-State: AOAM533suAM3AuncS4sgoZmbObogznHXsvtlnjGvM4t3BRxIPbh1s04n
        rFQfYaOlY5aXpZbef1TAIPqzksVI
X-Google-Smtp-Source: ABdhPJyE1bHYO6V4rh2BLqeUn56HRWT4MnmmupFa5trBpUFOUihfTauXV0NVZJ9dRRWPA6X74I+tAg==
X-Received: by 2002:ac8:27e3:: with SMTP id x32mr7261928qtx.322.1591645039120;
        Mon, 08 Jun 2020 12:37:19 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:6db4:c56e:8332:4abd])
        by smtp.gmail.com with ESMTPSA id l19sm8046859qtq.13.2020.06.08.12.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 12:37:18 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, tannerlove <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] selftests/net: in timestamping, strncpy needs to preserve null byte
Date:   Mon,  8 Jun 2020 15:37:15 -0400
Message-Id: <20200608193715.122785-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: tannerlove <tannerlove@google.com>

If user passed an interface option longer than 15 characters, then
device.ifr_name and hwtstamp.ifr_name became non-null-terminated
strings. The compiler warned about this:

timestamping.c:353:2: warning: ‘strncpy’ specified bound 16 equals \
destination size [-Wstringop-truncation]
  353 |  strncpy(device.ifr_name, interface, sizeof(device.ifr_name));

Fixes: cb9eff097831 ("net: new user space API for time stamping of incoming and outgoing packets")
Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/timestamping.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/timestamping.c b/tools/testing/selftests/net/timestamping.c
index aca3491174a1..f4bb4fef0f39 100644
--- a/tools/testing/selftests/net/timestamping.c
+++ b/tools/testing/selftests/net/timestamping.c
@@ -313,10 +313,16 @@ int main(int argc, char **argv)
 	int val;
 	socklen_t len;
 	struct timeval next;
+	size_t if_len;
 
 	if (argc < 2)
 		usage(0);
 	interface = argv[1];
+	if_len = strlen(interface);
+	if (if_len >= IFNAMSIZ) {
+		printf("interface name exceeds IFNAMSIZ\n");
+		exit(1);
+	}
 
 	for (i = 2; i < argc; i++) {
 		if (!strcasecmp(argv[i], "SO_TIMESTAMP"))
@@ -350,12 +356,12 @@ int main(int argc, char **argv)
 		bail("socket");
 
 	memset(&device, 0, sizeof(device));
-	strncpy(device.ifr_name, interface, sizeof(device.ifr_name));
+	memcpy(device.ifr_name, interface, if_len + 1);
 	if (ioctl(sock, SIOCGIFADDR, &device) < 0)
 		bail("getting interface IP address");
 
 	memset(&hwtstamp, 0, sizeof(hwtstamp));
-	strncpy(hwtstamp.ifr_name, interface, sizeof(hwtstamp.ifr_name));
+	memcpy(hwtstamp.ifr_name, interface, if_len + 1);
 	hwtstamp.ifr_data = (void *)&hwconfig;
 	memset(&hwconfig, 0, sizeof(hwconfig));
 	hwconfig.tx_type =
-- 
2.27.0.278.ge193c7cf3a9-goog

