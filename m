Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 521BDF07EF
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbfKEVNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:13:49 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42465 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729829AbfKEVNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:13:49 -0500
Received: by mail-lj1-f193.google.com with SMTP id n5so12539091ljc.9
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sdfh2FHcS8hP4BO9rOIRSgZp+JTUGEJZxeeIzT9aXuM=;
        b=wX0tEZMWNS3B/2wx2bOiRNEhS0YGRamWUIj9HPApTWRqDv1oeyaUmlFrVRiXAedi/n
         GlVabox/aHTyLEi22HT+G5/0FnV3Lk6XMPQkiVRsJMMM4qrryxZS3AazI4jTZZdyxY59
         kwm9Pf3agaYs0MmM55V+Yag608fDXafP6rcIHnP/21SfuvGunI09gGhL+m/M5ArBWygB
         74og3xAl6Ri+tjfWwr6mCvAJ/H1Jnmpukz4uqCTu9EEU1hedl/c5a+wKifrBoHFRUojA
         uj+M4u80wQa/rMp/Gbh21uLCUCqRu+Q2Vy7APfWLfPx0KHIQf8AitxS/eOpyOnAfGwzf
         Ke+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sdfh2FHcS8hP4BO9rOIRSgZp+JTUGEJZxeeIzT9aXuM=;
        b=OVKqRDw9nVgjUDSXGX2hbSSVAGdJdXhPTYNDgVB5SvOvrhlJyp15O5RDoxXBhzoHxb
         T8fCbUj29abCHQ1yFaeiFaEU72DpMbKqKe9hwibHy8PjinKLLS5JmmHU1gq4u5rD8nrq
         6NqFCMpHhzXrPNOgqQYhjzAj0Gk0RKpjyz9WbjJKYHb8WpWco1d9vSLLG9VD4t3pGmQ2
         F7l5EBZDzSablX8L/WgNzgJ0X85z4GdpKVQwq7KsMMbrwvuw5h5M74rl/lggThkX1udI
         QU/aJTf9vWjdn1Sn5sIkk8J5VedGm9X04KTtH85ehqwCFhQJ4f87pPwWf6BR/JZnyHdg
         wsSQ==
X-Gm-Message-State: APjAAAVgGB8wp64vet+HFce2rp2WFi3jomeesx0EOhduFm3v4VVcQ6qC
        S8T6eu27gGhsnzqexF2+Isl6HA==
X-Google-Smtp-Source: APXvYqx7Z7fGUCLSFnPRckyzhmTVrWKnH+MSIiAjQPRhHuQXWlu3Nu/5hxqjie3XU8P8npL9dhGBcA==
X-Received: by 2002:a2e:970a:: with SMTP id r10mr8861078lji.142.1572988427501;
        Tue, 05 Nov 2019 13:13:47 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b23sm9216748lfj.49.2019.11.05.13.13.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 13:13:46 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     stephen@networkplumber.org
Cc:     dsahern@gmail.com, oss-drivers@netronome.com,
        netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Arkadi Sharshevsky <arkadis@mellanox.com>
Subject: [PATCH iproute2] devlink: require resource parameters
Date:   Tue,  5 Nov 2019 13:13:36 -0800
Message-Id: <20191105211336.10075-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If devlink resource set parameters are not provided it crashes:
$ devlink resource set netdevsim/netdevsim0
Segmentation fault (core dumped)

This is because even though DL_OPT_RESOURCE_PATH and
DL_OPT_RESOURCE_SIZE are passed as o_required, the validation
table doesn't contain a relevant string.

Fixes: 8cd644095842 ("devlink: Add support for devlink resource abstraction")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
--
CC: Jiri Pirko <jiri@mellanox.com>
CC: Arkadi Sharshevsky <arkadis@mellanox.com>
---
 devlink/devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 5bbe0bddd910..056ac95ee726 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1121,6 +1121,8 @@ static const struct dl_args_metadata dl_args_required[] = {
 	{DL_OPT_DPIPE_TABLE_NAME,     "Dpipe table name expected."},
 	{DL_OPT_DPIPE_TABLE_COUNTERS, "Dpipe table counter state expected."},
 	{DL_OPT_ESWITCH_ENCAP_MODE,   "E-Switch encapsulation option expected."},
+	{DL_OPT_RESOURCE_PATH,	      "Resource path expected."},
+	{DL_OPT_RESOURCE_SIZE,	      "Resource size expected."},
 	{DL_OPT_PARAM_NAME,	      "Parameter name expected."},
 	{DL_OPT_PARAM_VALUE,	      "Value to set expected."},
 	{DL_OPT_PARAM_CMODE,	      "Configuration mode expected."},
-- 
2.23.0

