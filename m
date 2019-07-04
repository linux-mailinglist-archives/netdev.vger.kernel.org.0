Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63C625FE73
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 00:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfGDW33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 18:29:29 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44560 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbfGDW33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 18:29:29 -0400
Received: by mail-lf1-f67.google.com with SMTP id r15so5047696lfm.11;
        Thu, 04 Jul 2019 15:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NyIdC58y2Ub2Y306XyljmYe4qE2X3Y8o+U7JgB/DDQc=;
        b=F5/ZEBdHLOxVJsQ9+bKnbkInjEdYaGIz+yaiNaiAv5QmMVJBD851G5G1Fevvs8znzP
         QthYpnw9sSilbWFRu5heyHg53ECaToYeiJaDKRWvFMgLTprIck1otmreLMDnYPjgBZRN
         ntcpgrWan0ltoIeFcDXPHcJuJalqnMKxFhXKQxYaH0FGIeMcLGefDfy1i4k8vzBK7DAa
         YgdbjQJMy/dxfdPYvqREvQEiIZvoV1gZlVafOL8EDuMRlYxUqp1W78WHJzNiZp/tObaX
         af0aQD6DCyBVGq97juiiGeO2wg0ty69sPTHk5C2uCqPGy8J7PS1xtvZq/Vzey96VnIw/
         q0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NyIdC58y2Ub2Y306XyljmYe4qE2X3Y8o+U7JgB/DDQc=;
        b=UVeQHYayKYwH8phdu9sbNAFBtuE2dgsYnDh3UTAIa4sYOuRxKFi/RGRu6ivM0nyLbu
         cYqeJTZSRgW2goz6/c9gQ84Rgh2h/5qQWIMgolxFkTaCp326RgXWZGro1F1z+3jy3+1W
         2qa/Eh35mCCjDfagGSukpwi8Ghxkb2KWL9SYr8zXkmvMioUUDH0ipyv+AqJ2NxNVtHXn
         DuwsRBNJXBBGgzKre9yuwUJvPFE/TcDxMfsIh1HVD0u10brUA3XJAJ6Z8C61waIsaUtI
         +1+ncnRY4fxRZM/Nq2MeFqlA/oS7MjixsML3OggPEE+jyXG0y3BJHEonezJAMC7ytNHW
         0kFQ==
X-Gm-Message-State: APjAAAXg02jOmahF1xCBFKW4DQv5YDrLEhP/hWmjTC5xXo7FufYyIijq
        kx2+brzIiaThvVSbMOpzbBo=
X-Google-Smtp-Source: APXvYqx4gOrcGT8qluv7NzLG7j6naZ3cNwx7UVq6FHjKPQiPLQyJvvqgat9DKhDmwO44EuJgUA6u1A==
X-Received: by 2002:ac2:514f:: with SMTP id q15mr357516lfd.145.1562279366617;
        Thu, 04 Jul 2019 15:29:26 -0700 (PDT)
Received: from krolik-desktop.lan ([91.238.216.6])
        by smtp.gmail.com with ESMTPSA id t25sm403645lfg.7.2019.07.04.15.29.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 15:29:25 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>, linus.walleij@linaro.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] net: dsa: Add Vitesse VSC73xx parallel mode
Date:   Fri,  5 Jul 2019 00:29:03 +0200
Message-Id: <20190704222907.2888-1-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Main goal of this patch series is to add support for CPU attached parallel
bus in Vitesse VSC73xx switches. Existing driver supports only SPI mode.

Second change is needed for devices in unmanaged state.

V3:
- fix commit messages and descriptions about memory-mapped I/O mode

V2:
- drop changes in compatible strings
- make changes less invasive
- drop mutex in platform part and move mutex from core to spi part
- fix indentation 
- fix devm_ioremap_resource result check
- add cover letter 

Pawel Dembicki (4):
  net: dsa: Change DT bindings for Vitesse VSC73xx switches
  net: dsa: vsc73xx: Split vsc73xx driver
  net: dsa: vsc73xx: add support for parallel mode
  net: dsa: vsc73xx: Assert reset if iCPU is enabled

 .../bindings/net/dsa/vitesse,vsc73xx.txt      |  58 ++++-
 drivers/net/dsa/Kconfig                       |  20 +-
 drivers/net/dsa/Makefile                      |   4 +-
 ...tesse-vsc73xx.c => vitesse-vsc73xx-core.c} | 206 +++---------------
 drivers/net/dsa/vitesse-vsc73xx-platform.c    | 164 ++++++++++++++
 drivers/net/dsa/vitesse-vsc73xx-spi.c         | 203 +++++++++++++++++
 drivers/net/dsa/vitesse-vsc73xx.h             |  29 +++
 7 files changed, 499 insertions(+), 185 deletions(-)
 rename drivers/net/dsa/{vitesse-vsc73xx.c => vitesse-vsc73xx-core.c} (90%)
 create mode 100644 drivers/net/dsa/vitesse-vsc73xx-platform.c
 create mode 100644 drivers/net/dsa/vitesse-vsc73xx-spi.c
 create mode 100644 drivers/net/dsa/vitesse-vsc73xx.h

-- 
2.20.1

