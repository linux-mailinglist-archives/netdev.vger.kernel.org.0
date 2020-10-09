Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DCD2899BF
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389972AbgJIU2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388562AbgJIU2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 16:28:53 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1991DC0613D5
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 13:28:53 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id r10so5515530ilm.11
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 13:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uT9ly7TYDXvoKw3E5mo8VQB1vHtS6L18zdPOqqqYv4A=;
        b=L6sg3Q9mjrk/VQLo9OSXexDUrdFSR5THUe2/A0lJ/VXjem88X5a/Q+iO3/MbQehJA2
         PHYlF2uJ1PGt1C7KxNhF7x+2r5/tc5WBZlSAL8sEdgiB81rDk5/PvnMCkEIEVETO6Oqq
         X7R/9xB4b65QSrMUPjs4lJJ/M+j8GaiHew2ujTjEJe9WW0gAD4aOJcAGk7vjE4QdG/UB
         FqH+dJeIkh2ZCFphiSjSdgUHlrRA4ibymt+fA1BXXNjxkXGv6XhusYnkgseUHuhO8L+k
         cKn4Sbt1w0EuFdSJHGnvH7r0fRm1a9IwUOkGpzu+wRKc49UnXlwTkU4ZssN+cWP+ZT2S
         PjeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uT9ly7TYDXvoKw3E5mo8VQB1vHtS6L18zdPOqqqYv4A=;
        b=Ai89eQBRp1kEaByUF6g3nW0cw1A9Kc7CpB5VmhpLh4sXBwfi5hlOg8iY1upFzMTpz6
         1/wVBnTfmFCn688hROt7ROpvKbp0hNGXsAD8UGSd62/WE6mHPuFN6J0qiR67uCVnaJHw
         s3HI/VKnFX59woFz1dTfWRbP/pgERTWNg7BbjGzR4y4j/Lwn8dGWdSNFJ+dwhTp2KF4m
         HIyF81LH/S4RXj/Xxe5v1dXQj/Cld67Ij6MN4QLJhfCtSttoVMOvYc9Np6T0As5Ww5rY
         TRhtk6j9zdgFd+rhWkk71fJEsrI72okL4/P5uRyDV+D7faleMCZYh/xgNoEtGzSBxOMF
         hsBA==
X-Gm-Message-State: AOAM532h6rquBteUWK3SQODvuuci1eAvn5jRH2RPSA1WWIAwWCLQy9GK
        RqDn/GwKQGFmJleBvEP6NQzC1w==
X-Google-Smtp-Source: ABdhPJz2MvMclVY+MloIwHSMGKKurDv7fsoBVrX4M9zDs9F6tq3BHphsYsMO4RJlgaYW4aqt3u1iNA==
X-Received: by 2002:a92:a307:: with SMTP id a7mr10506517ili.97.1602275332398;
        Fri, 09 Oct 2020 13:28:52 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e17sm4654235ile.60.2020.10.09.13.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 13:28:51 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        mka@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: ipa: skip suspend/resume activities if not set up
Date:   Fri,  9 Oct 2020 15:28:48 -0500
Message-Id: <20201009202848.29341-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When processing a system suspend request we suspend modem endpoints
if they are enabled, and call ipa_cmd_tag_process() (which issues
IPA commands) to ensure the IPA pipeline is cleared.  It is an error
to attempt to issue an IPA command before setup is complete, so this
is clearly a bug.  But we also shouldn't suspend or resume any
endpoints that have not been set up.

Have ipa_endpoint_suspend() and ipa_endpoint_resume() immediately
return if setup hasn't completed, to avoid any attempt to configure
endpoints or issue IPA commands in that case.

Fixes: 84f9bd12d46d ("soc: qcom: ipa: IPA endpoints")
Tested-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
v2:  Patch posted alone (Jakub pointed out the other was unnecessary)

 drivers/net/ipa/ipa_endpoint.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index b7efd7c95e9c8..ed60fa5bcdaca 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1471,6 +1471,9 @@ void ipa_endpoint_resume_one(struct ipa_endpoint *endpoint)
 
 void ipa_endpoint_suspend(struct ipa *ipa)
 {
+	if (!ipa->setup_complete)
+		return;
+
 	if (ipa->modem_netdev)
 		ipa_modem_suspend(ipa->modem_netdev);
 
@@ -1482,6 +1485,9 @@ void ipa_endpoint_suspend(struct ipa *ipa)
 
 void ipa_endpoint_resume(struct ipa *ipa)
 {
+	if (!ipa->setup_complete)
+		return;
+
 	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX]);
 	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_LAN_RX]);
 
-- 
2.20.1

