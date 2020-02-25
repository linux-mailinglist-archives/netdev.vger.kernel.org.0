Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4F716B818
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 04:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgBYDbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 22:31:13 -0500
Received: from mail-pl1-f170.google.com ([209.85.214.170]:41606 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728843AbgBYDbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 22:31:13 -0500
Received: by mail-pl1-f170.google.com with SMTP id t14so4902042plr.8;
        Mon, 24 Feb 2020 19:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SR07YcgBHjEbiX3pylMiKuRM3jiAa6Jpy3Owt8WPWkk=;
        b=nUtb/iNUfsC7e2IxqgHBkTbS6JzQp9zKUgk9Iu2U0weihcromBfUtuUTXwrKRMoPiK
         FT/VoZAWiW8RvLHTW/53dXJcn8//c87BVb57U76jwU8IYhpZIa0UeRaiqQj2ZPiouhBQ
         STHJPm3vehcJSC7XY09Oo1XJUCyTUpcZLEzgCOdg7dhm8S760HRMulwWpeZp8W0tOFl/
         GqrEDFICOa707ql8oqhjoFvjDGiCQIBZRT0TBfKFq8uTRlp6KbuVVx7QqTVi0dBQ/9uu
         A7hsqOplN5IWMIz4Q2b1qi64YHeUSQh9P4Y0nrFOwIbUUXmFAQjT+IOzNhqoJlGmWDlb
         Mz6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SR07YcgBHjEbiX3pylMiKuRM3jiAa6Jpy3Owt8WPWkk=;
        b=MBkW3fli2LbmzAa8B7fRc1nAQKwjrzuJgfEFKJMe6XPk8lSx3bPQ2Hr6UVEHXsU28A
         W/XsAMIK+vRiiHJzPRV3ovl1HpTLz/OYN2RiCsrUPsEaEXy5to/sTmWj3hbIVIyRWLMK
         5Jq+7LPiIsA4W9uJ0oJZAp3CMHGK8eRiRUrqAYj5MSeRx/pApWqrK4xpBc3z5cnZpsqw
         iFVKHTDSbol6S/27OOs9RiUU7XCTRZskt8vbvxUE+xNIjxXfIz2KI+/naKg5zdb86fJI
         iFxLxHGWbC+MFEyAVAYe18wBucaITeCgm7hnyCbi/LOTLNcWO4RPJIMo7ZdSzmF9qfVK
         1GSw==
X-Gm-Message-State: APjAAAVitAiHwtTkle6jkRsAxoqtZ0q11kD0oALyQKoIx7+SILfqfu1c
        9kqmhCZMsXN60NWfuePWHkY=
X-Google-Smtp-Source: APXvYqwuqVmqFcxcal87EhRkAwIpTgJoYOqxktRmhFm4Oj2UuRqpiq5DJJNZ1O+sf4vlPP4MbNTcFA==
X-Received: by 2002:a17:902:8308:: with SMTP id bd8mr53172354plb.210.1582601472440;
        Mon, 24 Feb 2020 19:31:12 -0800 (PST)
Received: from localhost.localdomain ([103.202.217.14])
        by smtp.gmail.com with ESMTPSA id d73sm14498160pfd.109.2020.02.24.19.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 19:31:11 -0800 (PST)
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
To:     jasowang@redhat.com
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com,
        yuya.kusakabe@gmail.com
Subject: [PATCH bpf-next v6 0/2] virtio_net: add XDP meta data support
Date:   Tue, 25 Feb 2020 12:31:03 +0900
Message-Id: <20200225033103.437305-1-yuya.kusakabe@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series has 2 patches.

Patch 1/2: keep vnet header zeroed if XDP is loaded for small buffer
With this fix, we do not need to care about vnet header in XDP meta data
support for small buffer, even though XDP meta data uses in front of
packet as same as vnet header.
It would be best if this patch goes into stable.
This patch is based on the feedback by Jason Wang and Michael S. Tsirkin.
https://lore.kernel.org/netdev/9a0a1469-c8a7-8223-a4d5-dad656a142fc@redhat.com/
https://lore.kernel.org/netdev/20200223031314-mutt-send-email-mst@kernel.org/

Patch 2/2: add XDP meta data support

Thanks to Jason Wang, Daniel Borkmann and Michael S. Tsirkin for the feedback.

Yuya Kusakabe (2):
  virtio_net: keep vnet header zeroed if XDP is loaded for small buffer
  virtio_net: add XDP meta data support

 drivers/net/virtio_net.c | 56 ++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 22 deletions(-)

-- 
2.24.1

