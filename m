Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE3FA12F26D
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 02:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgACBD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 20:03:26 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38039 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbgACBDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 20:03:24 -0500
Received: by mail-pl1-f194.google.com with SMTP id f20so18462301plj.5;
        Thu, 02 Jan 2020 17:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1nu9FEZg4ORTL1XQF/9kPZRKXedL+qzG6Ic/dJ2Vuww=;
        b=KIBq/5PzM4BQ9wF31nwxIEASQY9KdGt1Q1UuBdPttFA13yCmU29BK+6cYG8kh4AJd8
         45DRAF7Zi9Fz1CTZlOOp+acjzfma5bUatKPx4tjNK1/a1SSqCop362KsnKlw8frKJgQG
         JKmu4JJFhonOdo4cPGdDCgtdjwMa9uV3dxyuZKs8Z3HUM5L8dpCDHeQPrdAsdokbl5Bt
         wMd0HTzE/+NbM1SwJ1NLqFCPy62sS4qTD+wXcEWyL4qPUTf9HhFOJdhdTJw7hFKGAt/K
         Rir1IGvbc9KmX6OpLQNZohdjoMEP+OlqkI2kiO/u9RxHrJJrMMS8MAzNa0W29oee7WNK
         J/cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1nu9FEZg4ORTL1XQF/9kPZRKXedL+qzG6Ic/dJ2Vuww=;
        b=Cgw+yRALcV5QnZs5/+3wS7ZQ4zPD1/as9s4YSSmLemRXrv31dcEwQgM6vUTfgzBJ8Z
         SbPtxT5vH1qqUcPsm9bIF1+4THB6GFatK9ygi2cKH8IUINtfvBDfjVqj1iXhgRDvaD2N
         P+FBWQS/iShDrV4ckvU53T9rnF0q01obyApn8es16MwgyBboDGdm1alxFCOnepIkv4Oe
         V7/WDrhWFgNdvV26bDqVgFMwVIgEs9brDnaYMZzDussaFoARKGEHwzq8PKxktiSmNt5o
         cGQe41IkyX0pk02air2O9v52guRdRNx+byGRiIYlgtUxHjx1P5xaJgqmplP2+3oWjHXI
         WD5w==
X-Gm-Message-State: APjAAAVboz30bZxR0Y5vJgJ1qux8PatBpFjGgYo+c95H9HAGvbtm6nGt
        gDvcWDYH8in7LqcO0eXckK4=
X-Google-Smtp-Source: APXvYqyPA0S2nhgdbv5AExMEflNvXfCrxHmY7hQsKbwgGnebEWPSq2XhfNReNkvHuGqWG9ov3Sbkeg==
X-Received: by 2002:a17:90a:a597:: with SMTP id b23mr23915052pjq.42.1578013403609;
        Thu, 02 Jan 2020 17:03:23 -0800 (PST)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id 5sm12780784pjt.28.2020.01.02.17.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 17:03:23 -0800 (PST)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v3 0/3] net: phy: switch to using fwnode_gpiod_get_index
Date:   Thu,  2 Jan 2020 17:03:17 -0800
Message-Id: <20200103010320.245675-1-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series switches phy drivers form using fwnode_get_named_gpiod() and
gpiod_get_from_of_node() that are scheduled to be removed in favor
of fwnode_gpiod_get_index() that behaves more like standard
gpiod_get_index() and will potentially handle secondary software
nodes in cases we need to augment platform firmware.

Now that the dependencies have been merged into networking tree the
patches can be applied there as well.

Thanks!

v3:
        - rebased on top of net-next

v2:
        - rebased on top of Linus' W devel branch
        - added David's ACKs



Dmitry Torokhov (3):
  net: phylink: switch to using fwnode_gpiod_get_index()
  net: phy: fixed_phy: fix use-after-free when checking link GPIO
  net: phy: fixed_phy: switch to using fwnode_gpiod_get_index

 drivers/net/phy/fixed_phy.c | 11 ++++-------
 drivers/net/phy/phylink.c   |  4 ++--
 2 files changed, 6 insertions(+), 9 deletions(-)

-- 
2.24.1.735.g03f4e72817-goog

