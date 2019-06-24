Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4129950211
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 08:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfFXGTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 02:19:05 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33438 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfFXGTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 02:19:05 -0400
Received: by mail-pl1-f194.google.com with SMTP id c14so6281026plo.0
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 23:19:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:mime-version
         :content-transfer-encoding:cc:from:to;
        bh=Yk5g4E1oOOxyZWouEDSkn3wBtFgCalVkAqRyr4Twh04=;
        b=UDLRhVcsxM+kEoT+/ulpIPmBVfMqX99hEqMC989C47SzOxZBxlpcUQRiS1Gf6z+InE
         pGPtRfvLE8PXvzPSnlhU7GScHr0xkOdjC/bEYbt3MGUTsVMtfkyAEoB7sAXqGIxFjoif
         QVHxJvIEKwYvCVczmvrLQOV987zsMAqTbQf72DE6KQUGzMCiurfNoMRjAOswGlz/e9m+
         q9eu6gL5Itl2uDb2Xf7EgXJzi/IiX2lYTKg32bhTPn877zJfjBmqoFUA0GykM6oI+39g
         yHUkG+YW2fK4QZlMsJlxoLDpt6jFqT3s8ldjo9X8ddkqoJjHBf2sQRCaAaK3LzKvXQ2i
         VUig==
X-Gm-Message-State: APjAAAVn2XyOT4tkG8J5ILDz/XlA1dMM4d9m7ryblq5MdQ7UEShOvlxb
        6gGdMBhIRN3Um8AY4buKi5zPyOPBlscS1Q==
X-Google-Smtp-Source: APXvYqzwssm7ZD70bnrrYdcH/DhTHZHfURHw6XroLCE2C6HFfBMDxWngPW9zv7qCLGInB6xuxsOJDw==
X-Received: by 2002:a17:902:ba82:: with SMTP id k2mr141275004pls.323.1561357144505;
        Sun, 23 Jun 2019 23:19:04 -0700 (PDT)
Received: from localhost (220-132-236-182.HINET-IP.hinet.net. [220.132.236.182])
        by smtp.gmail.com with ESMTPSA id v9sm9874143pfm.34.2019.06.23.23.19.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 23 Jun 2019 23:19:04 -0700 (PDT)
Subject: net: macb: Fix compilation on systems without COMMON_CLK
Date:   Sun, 23 Jun 2019 23:16:01 -0700
Message-Id: <20190624061603.1704-1-palmer@sifive.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     nicolas.ferre@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Palmer Dabbelt <palmer@sifive.com>
To:     davem@davemloft.net
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our patch to add support for the FU540-C000 broke compilation on at
least powerpc allyesconfig, which was found as part of the linux-next
build regression tests.  This must have somehow slipped through the
cracks, as the patch has been reverted in linux-next for a while now.  This
patch applies on top of the offending commit, which is the only one I've even
tried it on as I'm not sure how this subsystem makes it to Linus.

This patch set fixes the issue by adding another Kconfig entry to
conditionally enable the FU540-C000 support.  It would be less code to
just make MACB depend on COMMON_CLK, but I'm not sure if that dependency
would cause trouble for anyone so I didn't do it that way.  I'm happy to
re-spin the patch to add the dependency, but as it's a very small change
I'm also happy if you do it yourself :).

I've also included a second patch to indicate this is a Cadence driver,
not an Atmel driver.  As far as I know the controller is from Cadence,
but it looks like maybe it showed up first on some Atmel chips.  I'm
fine either way, so feel free to just drop it if you think the old name
is better.  The only relation is that I stumbled across it when writing the
first patch.
