Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D77E3DF
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 15:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbfD2Njm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 09:39:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35639 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfD2Njl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 09:39:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id f7so7616377wrs.2
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 06:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+zfSuZbnivdfjhDjQJ/KcwHgOZx3IqWaZKsoZZDjCVo=;
        b=ed8rmhD139wEl8EY07dQg+QyDwhTgDN1Jg6ZtihNNTV5If1xEvEq2Ub+EXwUAfrKG0
         2YhGAIDqq495CWWxPH7TqZ4r4wOUl0JoiYjQOYy1Qy3bCiqfUSJqb67yfmsBuGk/9UMi
         MQ6NPB50Gu7PTDyGwerWscf4yH22mJE8EjkhM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+zfSuZbnivdfjhDjQJ/KcwHgOZx3IqWaZKsoZZDjCVo=;
        b=eCjtovdzSlc2GPmF+TXiof1+iLqcZl3v6TzZzxP0u5q70FkZl1xpduMzBcxPjfaW4M
         RNlaQq6mXmzLqKG5QXXgMkNc7gpVAxzy+PA28Bn2v+PU9T+P8F3ffDXrw4poHJoqiir/
         cwAavpoZjDPQtUCtVVTr6HREefiTtBNzlUyoSdqKfiDuuKnMegHpGiUkP5CWqU441ti3
         9b4VFt0CAr2jLfAfAYoLBW0lhFEbOVqmVBOqNlcNrfdjytPhTWETXQPt1U67XiLHPmba
         j9oSZ5F+enqht6SflzbXjAi3cDsc4Cm5JrBUw2hcSfxNUbGM663fewGodL+XUDryzhdu
         ETRg==
X-Gm-Message-State: APjAAAU7f1B6KA1cJxGyRGtZ9BXMC5eItPAwLMbZKgtbp2lbrmiT6UKj
        BXnETODQaRvrfjKezI8YXyCc0Q==
X-Google-Smtp-Source: APXvYqyBGW/0iVzs0xCdJUgbvIQToxSEnIk4rDf6xt0CGhIZn2Z8cTXjXoNRMQjmDLKbesUGQUFHhg==
X-Received: by 2002:adf:e8c4:: with SMTP id k4mr1730719wrn.9.1556545180012;
        Mon, 29 Apr 2019 06:39:40 -0700 (PDT)
Received: from localhost.localdomain (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id s145sm960147wme.38.2019.04.29.06.39.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 06:39:39 -0700 (PDT)
From:   Shmulik Ladkani <shmulik@metanetworks.com>
X-Google-Original-From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: [PATCH net] ipv4: ip_do_fragment: Preserve skb_iif during fragmentation
Date:   Mon, 29 Apr 2019 16:39:30 +0300
Message-Id: <20190429133930.6287-1-shmulik.ladkani@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, during fragmentation after forwarding, skb->skb_iif isn't
preserved, i.e. 'ip_copy_metadata' does not copy skb_iif from given
'from' skb.

As a result, ip_do_fragment's creates fragments with zero skb_iif,
leading to inconsistent behavior.

Assume for example an eBPF program attached at tc egress (post
forwarding) that examines __sk_buff->ingress_ifindex:
 - the correct iif is observed if forwarding path does not involve
   fragmentation/refragmentation
 - a bogus iif is observed if forwarding path involves
   fragmentation/refragmentatiom

Fix, by preserving skb_iif during 'ip_copy_metadata'.

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
 net/ipv4/ip_output.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 4e42c1974ba2..ac880beda8a7 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -516,6 +516,7 @@ static void ip_copy_metadata(struct sk_buff *to, struct sk_buff *from)
 	to->pkt_type = from->pkt_type;
 	to->priority = from->priority;
 	to->protocol = from->protocol;
+	to->skb_iif = from->skb_iif;
 	skb_dst_drop(to);
 	skb_dst_copy(to, from);
 	to->dev = from->dev;
-- 
2.19.1

