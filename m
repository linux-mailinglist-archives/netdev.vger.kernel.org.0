Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8046547F16
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 12:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfFQKDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 06:03:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33585 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfFQKDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 06:03:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id h19so4138725wme.0
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 03:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=darbyshire-bryant.me.uk; s=google;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XSnr4K06XaXQiHBSG5XsdS31khp1+3dvwaPcAvNNqU8=;
        b=NBJe3jqCLrwaHd9uU5nWZbSuPq1B+Emtmz9e84Agb0hKsEUkA1CT1i6m9qw8MB1BSI
         uM/KO+iCFK4D0D6j3B/0B2wJq87pGBOLbBCQWCI9aqiA/ktGqKoGpuiyTGshX4aHhyV1
         5dfvX1qEfOjEY/+b/itlGOM7GvCCa2FlpVWsk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=XSnr4K06XaXQiHBSG5XsdS31khp1+3dvwaPcAvNNqU8=;
        b=l00d3+ILtdo3LCuIR8siTFhH5lwkt+132fHfrJHGVwtMzySd6hqqls/DX9TdSUllT1
         3u7H9rKskACJiB6V7zTOJw1wEG9kw7obHX5UUfJ8GomFZEYYzaatrBqUqoKxW4mcfoRS
         HyR256/jE69yUDQxWxa4X7VQuU4YaCdWL3tvUlW8DekK7zY5tAjfO5o6S+LIDcuO65cE
         mguixibd2Li7haXbBrirUck8EBw4cAJR578zqmprqo0osVYs2/AL+HF91ABJhtzDhcd3
         4z9zXUL+yfTX6ISVFW9kKI9ikhL6kpfoKS43ziDWZnvzRVVY62miHIo4MbVB2c99Hgaf
         ZG5g==
X-Gm-Message-State: APjAAAXHy9leJ5mkA/2bPguPbnbpKqAsHlq0UwllPt5X4hZavxn68ZVU
        6w7ECqopJI/S/2PH0oULdLj6+7qrtNDh7A==
X-Google-Smtp-Source: APXvYqyGbj4M19gSaNLhT8SPwwtGdksRoz7QOa2Q+F/OpvfwgZj1B3v1YNoNlPzDeg+fyJ/qmm4p+g==
X-Received: by 2002:a1c:a6d1:: with SMTP id p200mr18644743wme.169.1560765830616;
        Mon, 17 Jun 2019 03:03:50 -0700 (PDT)
Received: from Kevins-MBP.lan.darbyshire-bryant.me.uk ([2a02:c7f:1268:6500::dc83])
        by smtp.gmail.com with ESMTPSA id n1sm9791302wrx.39.2019.06.17.03.03.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 03:03:49 -0700 (PDT)
From:   Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     netdev@vger.kernel.org
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH net-next 2/2] net: sched: act_ctinfo: fix policy validation
Date:   Mon, 17 Jun 2019 11:03:27 +0100
Message-Id: <20190617100327.24796-3-ldir@darbyshire-bryant.me.uk>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190617100327.24796-1-ldir@darbyshire-bryant.me.uk>
References: <20190617100327.24796-1-ldir@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix nla_policy definition by specifying an exact length type attribute
to CTINFO action paraneter block structure.  Without this change,
netlink parsing will fail validation and the action will not be
instantiated.

8cb081746c03 ("netlink: make validation more configurable for future")
introduced much stricter checking to attributes being passed via
netlink.  Existing actions were updated to use less restrictive
deprecated versions of nla_parse_nested.

As a new module, act_ctinfo should be designed to use the strict
checking model otherwise, well, what was the point of implementing it.

Confession time: Until very recently, development of this module has
been done on 'net-next' tree to 'clean compile' level with run-time
testing on backports to 4.14 & 4.19 kernels under openwrt.  This is how
I managed to miss the run-time impacts of the new strict
nla_parse_nested function.  I hopefully have learned something from this
(glances toward laptop running a net-next kernel)

There is however a still outstanding implication on iproute2 user space
in that it needs to be told to pass nested netlink messages with the
nested attribute actually set.  So even with this kernel fix to do
things correctly you still cannot instantiate a new 'strict'
nla_parse_nested based action such as act_ctinfo with iproute2's tc.

Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
---
 net/sched/act_ctinfo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 2c17f6843107..10eb2bb99861 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -141,7 +141,8 @@ static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
 }
 
 static const struct nla_policy ctinfo_policy[TCA_CTINFO_MAX + 1] = {
-	[TCA_CTINFO_ACT]		  = { .len = sizeof(struct
+	[TCA_CTINFO_ACT]		  = { .type = NLA_EXACT_LEN,
+					      .len = sizeof(struct
 							    tc_ctinfo) },
 	[TCA_CTINFO_ZONE]		  = { .type = NLA_U16 },
 	[TCA_CTINFO_PARMS_DSCP_MASK]	  = { .type = NLA_U32 },
-- 
2.20.1 (Apple Git-117)

