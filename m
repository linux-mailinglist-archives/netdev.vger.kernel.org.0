Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C21495270E
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbfFYIs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:48:57 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41025 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730668AbfFYIs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 04:48:57 -0400
Received: by mail-pl1-f194.google.com with SMTP id m7so8445541pls.8
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 01:48:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:date:message-id:mime-version
         :content-transfer-encoding:cc:from:to;
        bh=SbHI+2ZPe2F4trO/RmKldIi3BUNe0clBDqy+3ySKREk=;
        b=CB4KJ+QS++tScQJqOXayj3d0TZ+fWUU6S6pezTNmCUesU1UOIljkOiAkkxaU65rR4/
         bgT449jk3F7HLhR2ROlfQhKn4q2M8q5j5Ojdm/Kw3FVMY4RJWi2HBpMV9IT9wNh06G1F
         TXK4yzodVYFG1qzxZOhZ5jDAHqKOios2D7E8f6o5L6Pfqumr1aS6WyuDDy+lP8QyWfS+
         UtO24laTAwUn8khC8QSI85pS5+fQz7l0xeADXU5SzgajVR4fNdGS9wU7lRCMNPuHfqc8
         TuzmmUR1PeCo1D1P8Gjs5Bc0gJMA9l2G+VNMvlo8hXa8OSPswlHTSO0s7ftuObi6YGFi
         ZIiA==
X-Gm-Message-State: APjAAAUqW1swFf6cvomUAzxVp+5Uykk2PutcqusplmrHtFHVQKsLo3Pu
        j9/YvG0fzN4QpNWgKdeJ1H8NUA==
X-Google-Smtp-Source: APXvYqzICITq0LF39qdmLn3FbbAFe2vxOW+Jt8WI+imgxcTmTRasfjQerDzKPJEAr1yYLpBhtC6JIw==
X-Received: by 2002:a17:902:28e9:: with SMTP id f96mr103841484plb.114.1561452535820;
        Tue, 25 Jun 2019 01:48:55 -0700 (PDT)
Received: from localhost (220-132-236-182.HINET-IP.hinet.net. [220.132.236.182])
        by smtp.gmail.com with ESMTPSA id e26sm14280998pfn.94.2019.06.25.01.48.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 01:48:54 -0700 (PDT)
Subject: net: macb: Fix compilation on systems without COMMON_CLK, v2
Date:   Tue, 25 Jun 2019 01:48:26 -0700
Message-Id: <20190625084828.540-1-palmer@sifive.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Palmer Dabbelt <palmer@sifive.com>
To:     nicolas.ferre@microchip.com, harinik@xilinx.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our patch to add support for the FU540-C000 broke compilation on at
least powerpc allyesconfig, which was found as part of the linux-next
build regression tests.  This must have somehow slipped through the
cracks, as the patch has been reverted in linux-next for a while now.
This patch applies on top of the offending commit, which is the only one
I've even tried it on as I'm not sure how this subsystem makes it to
Linus.

This patch set fixes the issue by adding a dependency of COMMON_CLK to
the MACB Kconfig entry, which avoids the build failure by disabling MACB
on systems where it wouldn't compile.  All known users of MACB have
COMMON_CLK, so this shouldn't cause any issues.  This is a significantly
simpler approach than disabling just the FU540-C000 support.

I've also included a second patch to indicate this is a driver for a
Cadence device that was originally written by an engineer at Atmel.  The
only relation is that I stumbled across it when writing the first patch.

Changes since v1 <20190624061603.1704-1-palmer@sifive.com>:

* Disable MACB on systems without COMMON_CLK, instead of just disabling
  the FU540-C000 support on these systems.
* Update the commit message to reflect the driver was written by Atmel.


