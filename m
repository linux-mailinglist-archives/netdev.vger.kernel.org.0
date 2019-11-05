Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D333F0811
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729800AbfKEVRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:17:21 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44285 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729656AbfKEVRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:17:21 -0500
Received: by mail-lf1-f68.google.com with SMTP id v4so16252551lfd.11
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w99zvtEBfk2UwFy6Pj9AR451P+siF7H8CI1qbkc/BrQ=;
        b=dKw1HZlpjgFX1mNYxCkH9AcaKIFUpW/knPxJ8TeaKNi0gDhAcYuNvp/P/7FqIgB1c/
         Dm0qBhTfBPOwky8r5ngx6G/Q6QpTRum4ZWl4asEXT/3J9+3DGvCZbFNfzNskE4QJqhKC
         vlW928N9WVhXpgdJLqmUugmPNoil/ektcooRsiczbHPWzXplNwZsU9PhkPYaZeJz8RI6
         ODjg9l2HbnEyIiAhjfTnSRBU3vAo+E/9oMGjd0Y64+WVploZk2ambI7cmLYjgWJr8vjJ
         3xi0NiXL3FJBoViBkKzfV5z4DqRNxtLu+TJ7voeGdhgf4JF9jiUpYybkhtKV5gMNs42G
         F50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w99zvtEBfk2UwFy6Pj9AR451P+siF7H8CI1qbkc/BrQ=;
        b=FM3QjmSAByJMG8MKjYPHwF1Bz7uvQgWTDVa4OTVmDTaNrn2gRs5R+k1w/vOJQet1dJ
         5FQZ9njSPjm4Y+49MwKM1RNiO+Ih518+8KluwITMpjTJsrepmeY4pr0olNsajCwIYWH6
         L3Pvt6fM7NNGtprhSMtkNd+LmW1N51o3JasP3XSgXkQp1mT5q3MGoIzmDoJbmHCh5qbN
         uufIZ30U2Inpi9xYRhEzHZ2Ebl6riwmC3cutfJ0P0rl8LP8VZB6pz0IhAwp9khp+jBmb
         /VJtkvCb0LYl8cYw57oiDqg3PrOILs5LMutj9y/+XSxDp1SVoFMTzgMPk1B19dyAXj8A
         I+JQ==
X-Gm-Message-State: APjAAAVtVFWFsxWk9w1dPdt5GJ8eJo8X4hTHRSzDvP+wkMfOwi6Dk/Zh
        ciw3Anth1rdpR6+6X5P8YKEmzAuPVyc=
X-Google-Smtp-Source: APXvYqxlHFKUAppEYzkJ5x2kb/5h5VvMxdV95PIzbzZB7NB9K3wCoxP2gPJ5SGqWTIPL9hr21pTlgw==
X-Received: by 2002:a19:3fcd:: with SMTP id m196mr21929435lfa.118.1572988639600;
        Tue, 05 Nov 2019 13:17:19 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 81sm9861270lje.70.2019.11.05.13.17.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 13:17:18 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     dsahern@gmail.com
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, jiri@resnulli.us,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH iproute2-next 0/3] devlink: improve parameter checking, resources and namespaces
Date:   Tue,  5 Nov 2019 13:17:04 -0800
Message-Id: <20191105211707.10300-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set brings small fixes/improvements for devlink tool.
First the netns reference by PID is fixed (code is in -next only).
Next an extra check is added to catch bugs where new feature forgot
to add required parameters to the error string table.
Last but not least allow full range of resource sizes.

These changes are required to fix kernel's devlink.sh test.

Jakub Kicinski (3):
  devlink: fix referencing namespace by PID
  devlink: catch missing strings in dl_args_required
  devlink: allow full range of resource sizes

 devlink/devlink.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

-- 
2.23.0

