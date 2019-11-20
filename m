Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A58A1042A5
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfKTR4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:56:48 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34238 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfKTR4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:56:48 -0500
Received: by mail-lf1-f66.google.com with SMTP id l28so297922lfj.1
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 09:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bl5kBgWdszXsG8N0e3S4l930mGgZvfqr7UV5sZ7mUOo=;
        b=O+cX8tWFxNysHoItpeEJNk0pNBgwNu0H7fUUicTQwdtGYsbYVhzBEplJiBfx5yAnjf
         uMHOsdwqO9t/owd0PI45okUiT43FkYQWMo7dUReZv/+nFo07r2te/xW/iv3HcMxPMVrk
         KfMlaNvwGgJruvMKemkHJzk9XcGG/qpVN0S17sfxpc9k36AL1IG3nmtNXgZZiKTyCYmn
         RJsyurEiVnp/3ZYRJ95FjnFTrNZ2807W+fBu0fSNs9bvV2/srYP35JVabA2yKwZQhF5v
         j0tOpPNNvreJK/Ct2vQO8b02Uik5NMn/Ki0W9gSXW9PcTOtiUlnzZAE8zEvBt7OB6yS/
         eIrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bl5kBgWdszXsG8N0e3S4l930mGgZvfqr7UV5sZ7mUOo=;
        b=WtM5r3OC8sErFju5TnwuId27YN0bW4y/FwO+VP8fuQsPRwTf9tFTEBw/rKL5RZpRFR
         jl/rk/LmxXk/sraTv/bXxu/76v1gNUdwuzlfGfhYKQ3peDQSyaK/yLyVsR88lMX7+tWh
         z6DS4QxrYYVSlyA4yaZyvBRc02jlPRtr0W8mcbxybyWHEYZT98zptm7ysR+BWtNsHLOw
         wAURo9Ol2qp730k0xBV1QOsY86aK/luM7NtiAa1yag35C5Mb/6sDjYUzGFzbDN9y9aIg
         f81bDZJdJHTwR/Tod5PLU46rk12JDGLuzRejSqv1mggH9fnBk95py/8q83BITV6ymsO4
         SQpg==
X-Gm-Message-State: APjAAAVYWzyNABdWQ0I6aK2eywfxJZ0l7eokNdt05Z+5iCtWtw/+BGno
        xhoHnqP9p0HkrhmZ+bxFxnBGwA==
X-Google-Smtp-Source: APXvYqxBu2/koOXhPpcBF7ELkKjKnjvTKET5ynVVYiWDoE6SOEsIzluFawS7TU5CV/e8nKyp3tVMiw==
X-Received: by 2002:a05:6512:71:: with SMTP id i17mr4045051lfo.113.1574272604473;
        Wed, 20 Nov 2019 09:56:44 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n83sm3089550lfd.70.2019.11.20.09.56.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2019 09:56:43 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     dsahern@gmail.com
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, jiri@resnulli.us,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH iproute2-next] devlink: fix requiring either handle
Date:   Wed, 20 Nov 2019 09:56:06 -0800
Message-Id: <20191120175606.13641-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink sb occupancy show requires device or port handle.
It passes both device and port handle bits as required to
dl_argv_parse() so since commit 1896b100af46 ("devlink: catch
missing strings in dl_args_required") devlink will now
complain that only one is present:

$ devlink sb occupancy show pci/0000:06:00.0/0
BUG: unknown argument required but not found

Drop the bit for the handle which was not found from required.

Reported-by: Shalom Toledo <shalomt@mellanox.com>
Fixes: 1896b100af46 ("devlink: catch missing strings in dl_args_required")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Tested-by: Shalom Toledo <shalomt@mellanox.com>
---
 devlink/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index ea3f992ee0d7..0b8985f32636 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1179,6 +1179,7 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 					  &opts->port_index, &handle_bit);
 		if (err)
 			return err;
+		o_required &= ~(DL_OPT_HANDLE | DL_OPT_HANDLEP) | handle_bit;
 		o_found |= handle_bit;
 	} else if (o_required & DL_OPT_HANDLE) {
 		err = dl_argv_handle(dl, &opts->bus_name, &opts->dev_name);
-- 
2.23.0

