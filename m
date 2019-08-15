Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD398EE3C
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732953AbfHOOch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:32:37 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35959 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732945AbfHOOcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 10:32:36 -0400
Received: by mail-wm1-f68.google.com with SMTP id g67so1433700wme.1
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 07:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JPzzk5lRmjCdOAS6zNQJ1VhVCQa5IynB25ENpGskCeY=;
        b=TupD/Gh2d8qyh3RllnYSH0OpkdcfRETSxHt3xZHCA12yunZqr9yvxmWuGKZ9/rhCPq
         JCLcpZR/MuQYpfYkzTKFxT+/jFwTcxyXOs3nIMAsfleRIp7BlNHHLMbv4ZSkcLjmMtl2
         uZbnrJ9QnGcY+BLcdoytpamUQ//0CfHxjSV2ROqGHeCcC7nRN8loHTACUdt6qDlgcYHf
         kCXCOKRNpFXKjkZnsXlPJzhZA89e78anKQXUZXnzzz3d8zWLvr+MR/146/8SD9/YWOVs
         aUGHugQgDvqZY4KHw36yGVVB+iheS1oysDfp+BH1bvc7UrDlo/fAVilRT9UTQtbLJ39q
         n58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JPzzk5lRmjCdOAS6zNQJ1VhVCQa5IynB25ENpGskCeY=;
        b=PnUSEHAlAotO9KmLwhVsCHcIJsaD0x+VtkPd4pMahPtQSm57JdrLT/Oxsl1IhqJuE2
         A/UqU4fZxSi6bTVD4QtNyo35zNTjmz0l2jvQDL5nIZduFXR48W9UqHMAfU2cXH+XpBa5
         MBgCyPiIHOSXWcI4sjly3SwammqXnTUocVPAW4qFscgi62Xc5wwSMBlGtBZ+uMt6IDTL
         rh0C0ggHiK4Csd9b9XKCdRi6Rqjpqj9nL+aed2xpc0GjXvg4OhSC0u3h6DiOWEEaKFB+
         8iSi59L5eTXmsC7BcDuSTjI8FU8imiQaWo8uJHIrwmPFD9Z7DPV3i2TXJGOnOFOYBkvv
         6qSA==
X-Gm-Message-State: APjAAAUlNhGWt9sPbzMFc/C39R3WCSLDWnaU0ZYLp9SW9OnsBXD3c1GH
        0OTNugdyuMFVNw8qEDfiF54j5g==
X-Google-Smtp-Source: APXvYqwI9FQz5QfncZdStumoW6LrAu7+/jwRFiHcqXzZLnZOeEWkUGaCqJBs73aFI71k6s+VlZpyUA==
X-Received: by 2002:a05:600c:551:: with SMTP id k17mr3102790wmc.53.1565879554404;
        Thu, 15 Aug 2019 07:32:34 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id a19sm8857463wra.2.2019.08.15.07.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 07:32:33 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf 4/6] tools: bpftool: fix format string for p_err() in query_flow_dissector()
Date:   Thu, 15 Aug 2019 15:32:18 +0100
Message-Id: <20190815143220.4199-5-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815143220.4199-1-quentin.monnet@netronome.com>
References: <20190815143220.4199-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The format string passed to one call to the p_err() function in
query_flow_dissector() does not match the value that should be printed,
resulting in some garbage integer being printed instead of
strerror(errno) if /proc/self/ns/net cannot be open. Let's fix the
format string.

Fixes: 7f0c57fec80f ("bpftool: show flow_dissector attachment status")
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/bpf/bpftool/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 67e99c56bc88..e3b770082a39 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -197,7 +197,7 @@ static int query_flow_dissector(struct bpf_attach_info *attach_info)
 
 	fd = open("/proc/self/ns/net", O_RDONLY);
 	if (fd < 0) {
-		p_err("can't open /proc/self/ns/net: %d",
+		p_err("can't open /proc/self/ns/net: %s",
 		      strerror(errno));
 		return -1;
 	}
-- 
2.17.1

