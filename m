Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF4934B77D
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 15:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhC0OHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 10:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhC0OHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 10:07:08 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0B3C0613B1
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 07:07:08 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id j25so6841951pfe.2
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 07:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=V9VJMU9ehW1A/+IJWSyBpvu114UBASSxiTstYItx3Gw=;
        b=WuwakWVzvJQ+L1Hr+HqQRRhr5KXNMpvZNlPYKjYQ7F3naTg2n4OUiFeR7fhcD174tx
         0JnfVy6cHMF9gVRA73AKPAJDkdj8RgBr0WCV9vq0kydDdqPNMh6k+z7HQ5Cm5R2x9C0G
         Gpw3krzj+dj88wAUcaaT84fHx+DSb7AceYIVPxZN5nPGjcjS23J1Hm5JPrjUyxULP1XC
         CdJmiv/qPc4Vmyi5BXGi1isiVwfYcUf9wgB4UG7WdVBZ0V+BuMqaV7xc81ahCLfE+59j
         1ioxLeFb9LprNZrqTWbe5OpO2xAN3g+ZiQYxM77nBmm43QO19/QfSVwN1kG1ctfcdhFK
         0Quw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=V9VJMU9ehW1A/+IJWSyBpvu114UBASSxiTstYItx3Gw=;
        b=iz/bzQtADXqx/jToBRx8GIMQyM4cyOb3lcdOAWo3rczxo6waB0r+tqHx+60WeZPERf
         ezplGMNPqZMYhfhm7mEfA7E9E9Hj2V2RrysFuF5OLgB9fsByZ6wZITMCf8diM+RCnY+2
         HhOjLx32UODK4tczckPdpMJdIstmmQFQF2oj0y+ti63m8nQ1vmn8y0ohb3cpP90DN9cL
         OXcEUKMuLipN5xFHU6B0PS9eF1qrmGbeuzTknYRVBFV6N+Q/xJI2rZeVFtrRflLyQo1i
         KqwNd44UkEFv8tZhGfoZrglEMeiJlNU20YxixqHH9a2zQkaLheLthfN3OLxBNLkS/RZD
         MeYA==
X-Gm-Message-State: AOAM532YFJCHDKQVfYjEi+vrhAU15nyVHk5LyEix8G8lSoRWDN5t2vKU
        rZTXH2t9yJcWeEIER03l5G0=
X-Google-Smtp-Source: ABdhPJynY+clJBGV1vq+9b6A6dAwk4qGWhwgmZH1HI3cGywa+8dVGOu8gRNMJwPy8GxEaPbqhP1IrQ==
X-Received: by 2002:a62:e114:0:b029:20d:a7ca:3a36 with SMTP id q20-20020a62e1140000b029020da7ca3a36mr17432474pfh.24.1616854027565;
        Sat, 27 Mar 2021 07:07:07 -0700 (PDT)
Received: from ThinkCentre-M83.wg.ducheng.me ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id o3sm6165629pjm.30.2021.03.27.07.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 07:07:07 -0700 (PDT)
From:   Du Cheng <ducheng2@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Du Cheng <ducheng2@gmail.com>,
        syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
Subject: [PATCH v2] net:qrtr: fix atomic idr allocation in qrtr_port_assign()
Date:   Sat, 27 Mar 2021 22:07:02 +0800
Message-Id: <20210327140702.4916-1-ducheng2@gmail.com>
X-Mailer: git-send-email 2.27.0
Reply-To: <YF8bDngTPVRVx1ZY@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add idr_preload() and idr_preload_end() around idr_alloc_u32(GFP_ATOMIC)
due to internal use of per_cpu variables, which requires preemption
disabling/enabling.

reported as "BUG: "using smp_processor_id() in preemptible" by syzkaller

Reported-by: syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com
Signed-off-by: Du Cheng <ducheng2@gmail.com>
---
changelog
v1: change to GFP_KERNEL for idr_alloc_u32() but might sleep
v2: revert to GFP_ATOMIC but add preemption disable/enable protection

 net/qrtr/qrtr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index edb6ac17ceca..6361f169490e 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -722,17 +722,23 @@ static int qrtr_port_assign(struct qrtr_sock *ipc, int *port)
 	mutex_lock(&qrtr_port_lock);
 	if (!*port) {
 		min_port = QRTR_MIN_EPH_SOCKET;
+		idr_preload(GFP_ATOMIC);
 		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, QRTR_MAX_EPH_SOCKET, GFP_ATOMIC);
+		idr_preload_end();
 		if (!rc)
 			*port = min_port;
 	} else if (*port < QRTR_MIN_EPH_SOCKET && !capable(CAP_NET_ADMIN)) {
 		rc = -EACCES;
 	} else if (*port == QRTR_PORT_CTRL) {
 		min_port = 0;
+		idr_preload(GFP_ATOMIC);
 		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, 0, GFP_ATOMIC);
+		idr_preload_end();
 	} else {
 		min_port = *port;
+		idr_preload(GFP_ATOMIC);
 		rc = idr_alloc_u32(&qrtr_ports, ipc, &min_port, *port, GFP_ATOMIC);
+		idr_preload_end();
 		if (!rc)
 			*port = min_port;
 	}
-- 
2.27.0

