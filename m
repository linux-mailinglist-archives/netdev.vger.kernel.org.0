Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB450451D14
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244788AbhKPAZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243745AbhKPAVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 19:21:19 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E19C0337C2
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:55:06 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id u16so12421919qvk.4
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=hHRqpbMk8KlizvRktIEx8fg9ZAb1LqAifrqvXZPACPE=;
        b=q1qjegsF+R0ppMPJrgtQfY9aatA/CGgASR/l3D+ckUcoemc7AIz2mrI3UgRgJUUMea
         9vh56QJQ/yRPQA64qNS8qtg+G5QNkV4cuXeln+xNbKGTjpwc8mu008Q062gpcunsZZq+
         cStWHJ8+EVRF4t+sQKpiWdCVdAoccEzubUfhfflQ5eBIhZe4WTr9fApShwfUl6unmIp8
         5a7GlZ0N5AowocjwgtVBWNQaT4+hOKI2lyo0KAdEIKEJdv4O7Wb5XhnIAPsGBEYxPlH7
         nUrKWQvF6HAUx6/6AIx8BkcAXOWwpeXaIeVghgnWcbVyFcYoy4b2zJ3aKOJVJmlj3JBK
         QP0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=hHRqpbMk8KlizvRktIEx8fg9ZAb1LqAifrqvXZPACPE=;
        b=0R55IL6ESQzIMe0bUfbqPNpEvSQSIc9QMC2wD73FhuJeBKJeG6P4El4jCRoB78t0wO
         zVwrrijnmTUK7PMimG6urfBBIkDufHfxPVpTl8MrFWEkTPDOnmotzVS28HvRAB4JTmSZ
         BSRkbHL53DXHLq26SMcesM/G3RnnO+HW13aF4QHorVPRLNVHS1f7lYDeW/3SQ6f0OroX
         CBl0dJvr5lwAR+rVXATgp0i3YU7xda/Stab5X7bozlTzaZN3oa1WSRM3Dg9iMmc06TIx
         G1z+IFaobwkuYayWSEzuGlZ58SkmD+p8ftd3gfVDFjjIezid3c3JpfmbWj/+ab4OWLUu
         t5bQ==
X-Gm-Message-State: AOAM530Pg1PJ3ByqRxYWn8lLT1+5j3Vch6gVTrY8Qr85rseRyF2Vi9Rb
        rSBe/nSg1ujdIYNRTKUic8ybbk33wc4=
X-Google-Smtp-Source: ABdhPJz73UnPhuBq78TSHOhDjMXZvvUFWswIRQvypfUwvbo3rDxR/800B2da3wRt4b/3C+h0TrcQYw==
X-Received: by 2002:a05:6214:18e2:: with SMTP id ep2mr40502826qvb.45.1637016905391;
        Mon, 15 Nov 2021 14:55:05 -0800 (PST)
Received: from localhost.localdomain ([50.43.104.120])
        by smtp.gmail.com with ESMTPSA id u21sm5594554qtw.29.2021.11.15.14.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 14:55:04 -0800 (PST)
Subject: [ethtool PATCH] ethtool: Set mask correctly for dumping advertised
 FEC modes
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     mkubecek@suse.cz, netdev@vger.kernel.org
Date:   Mon, 15 Nov 2021 14:52:54 -0800
Message-ID: <163701677432.25599.14085739652121434612.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Set the "mask" value to false when dumping the advertised FEC modes.
The advertised values are stored in the value field, while the supported
values are what is stored in the mask.

Without this change the supported value is displayed for both the supported
and advertised modes resulting in the advertised value being ignored.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 netlink/settings.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/netlink/settings.c b/netlink/settings.c
index c4f5d61923aa..ff1e783d099c 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -402,7 +402,7 @@ static int dump_our_modes(struct nl_context *nlctx, const struct nlattr *attr)
 		return ret;
 	printf("\tAdvertised auto-negotiation: %s\n", autoneg ? "Yes" : "No");
 
-	ret = dump_link_modes(nlctx, attr, true, LM_CLASS_FEC,
+	ret = dump_link_modes(nlctx, attr, false, LM_CLASS_FEC,
 			      "Advertised FEC modes: ", " ", "\n",
 			      "Not reported");
 	return ret;


