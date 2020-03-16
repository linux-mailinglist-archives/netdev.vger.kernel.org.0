Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4A5187588
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 23:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732739AbgCPW27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 18:28:59 -0400
Received: from mail-qv1-f49.google.com ([209.85.219.49]:46418 "EHLO
        mail-qv1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732652AbgCPW27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 18:28:59 -0400
Received: by mail-qv1-f49.google.com with SMTP id m2so9806042qvu.13
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 15:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=74WFqqU8UvNSiPHo/92yGfDiCTDjTz6Bkk/bwSwNsVk=;
        b=xwT/Jf0k9rLNKVBxgCugI7IPnT9ir8UWZBnqTSy6MkRviKmNrRijLPFwKkaUjprAkY
         4AEZAReipahFck33hAag2JBi+4L1b4tChIuFY1Kb8SA9eXWDcPH8hpSOnFIF2k1hoflG
         pr/EHJysC47s3vrd+hvX0gEcP5UD+9ucwIdP29CJ99HvvWh3lxmUMcGZoweLKJ0aKqd/
         tLa3q7pt6q8sM8SZg+2jr+ePJhz65Xm+CABUEV2+dnG8iB3flHSDvfjlO1Pwp3SYVKez
         ExlAq7sw4mxqEBYxm/PwGQnRYXrWD8R2or+Y4SaPB+rsxUF2LrBLG1MowBWMlvfG2bpU
         X1Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=74WFqqU8UvNSiPHo/92yGfDiCTDjTz6Bkk/bwSwNsVk=;
        b=uk1sccBAo7VpvnA6qqrS8kyiYM7pC67G1vFb311QbZlHP2W2BpDdvC6n6oaVuh671H
         2rOBTaQ26XEN6ilYFtKrgUCjeZrvzJ8Iydw3sWJhyO1g1szWTKSeiD5GELEo0O2O/m4Z
         oygjbxkPGvUNKahIuiDI3Msj2S62bSxvPwvztUxIUK3gYneZeqDG5WR3ghUqUmrTvSgp
         k7wLwoA4TAUXxMdAKjqhAksIZfFm435nKPlS6E2VG0iNDd5cj05c6eTum2OJDZzReI7j
         pGtoB+iQgTkfQPqV2mqCyrmX3SKxwJd75PHzkkAlgsRR1Q7bInR0+4UXf2UYIOzLHTMl
         FwSg==
X-Gm-Message-State: ANhLgQ3PYRi5j41mbAnINksH6SYiZ6Q/ae4r0iKCO+HalUnfNzJckxup
        H9+wy/XK5roIAcrPqrSctV3Zy7kFhcc=
X-Google-Smtp-Source: ADFU+vvG9KXCD/lBD8mOCSsdqdFWA3+XJ3l4bj66JvKUSZCGk3NDf9aluedyAAyPpw88ZfFq/TSzmw==
X-Received: by 2002:a0c:e912:: with SMTP id a18mr2135938qvo.101.1584397737943;
        Mon, 16 Mar 2020 15:28:57 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y127sm715118qkb.76.2020.03.16.15.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 15:28:57 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-remoteproc@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Subject: [PATCH] remoteproc: clean up notification config
Date:   Mon, 16 Mar 2020 17:28:53 -0500
Message-Id: <20200316222853.14744-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rearrange the config files for remoteproc and IPA to fix their
interdependencies.

First, have CONFIG_QCOM_Q6V5_MSS select QCOM_Q6V5_IPA_NOTIFY so the
notification code is built regardless of whether IPA needs it.

Next, represent QCOM_IPA as being dependent on QCOM_Q6V5_MSS rather
than setting its value to match QCOM_Q6V5_COMMON (which is selected
by QCOM_Q6V5_MSS).

Drop all dependencies from QCOM_Q6V5_IPA_NOTIFY.  The notification
code will be built whenever QCOM_Q6V5_MSS is set, and it has no other
dependencies.

Signed-off-by: Alex Elder <elder@linaro.org>
---

Dave,
    I noticed some problems with the interaction between the IPA and
    remoteproc configs, and after some discussion with Bjorn we came
    up with this, which simplifies things a bit.  Both Kconfig files
    are in net-next now, so I'm sending this to you.

    Two other things:
    - I will *not* be implementing the COMPILE_TEST suggestion until
      after the next merge window.
    - I learned of another issue that arises when ARM64 is built
      with PAGE_SIZE > 4096.  I intend to fix that in the next day
      or so.

      					-Alex

 drivers/net/ipa/Kconfig    | 2 +-
 drivers/remoteproc/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
index b8cb7cadbf75..9f0d2a93379c 100644
--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -1,9 +1,9 @@
 config QCOM_IPA
 	tristate "Qualcomm IPA support"
 	depends on ARCH_QCOM && 64BIT && NET
+	depends on QCOM_Q6V5_MSS
 	select QCOM_QMI_HELPERS
 	select QCOM_MDT_LOADER
-	default QCOM_Q6V5_COMMON
 	help
 	  Choose Y or M here to include support for the Qualcomm
 	  IP Accelerator (IPA), a hardware block present in some
diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index ba318289df64..ffdb5bc25d6d 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -128,6 +128,7 @@ config QCOM_Q6V5_MSS
 	select MFD_SYSCON
 	select QCOM_MDT_LOADER
 	select QCOM_Q6V5_COMMON
+	select QCOM_Q6V5_IPA_NOTIFY
 	select QCOM_RPROC_COMMON
 	select QCOM_SCM
 	help
@@ -169,7 +170,6 @@ config QCOM_Q6V5_WCSS
 
 config QCOM_Q6V5_IPA_NOTIFY
 	tristate
-	depends on QCOM_Q6V5_MSS && QCOM_IPA
 
 config QCOM_SYSMON
 	tristate "Qualcomm sysmon driver"
-- 
2.20.1

