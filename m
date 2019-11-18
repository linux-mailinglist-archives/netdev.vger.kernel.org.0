Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A85100186
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 10:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfKRJjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 04:39:44 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39428 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfKRJjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 04:39:43 -0500
Received: by mail-pg1-f195.google.com with SMTP id 29so9372836pgm.6
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 01:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FzpddDisy4KqozDO9Mvc6bBfY+LOoFw7zuxlIwBXhGs=;
        b=htylJM8gyZ4jXLBRDuWvnoMfLq/RpqDr8reYF+P87muZ6kj/EAFjdaRPgJkkpLeJ25
         gpnaznquubwS1jahVvznZ2opRCGroM2SnSgPshPbTLTFKBA7hPD7T+Sho23xI0zCPZ+q
         BeEIGWzSDmBs0KSJSSoQRQiukTfCBd2Y+ciw3QJ2hGGMNG+cCk5WXiJoG/Heb6/PNck6
         q0NLnYDpSj0s6IiPOFe4aj21powgfwrePynYUku9aPCX/MxFbWodrqgtg4GwhjiTpmm2
         aO5edfaaLE+IwhvXIGYD6qu9x9NyFvkM3ZO6u1miOuFUqVZc9QmvuOlvvda/Q2UAlCXF
         j37A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FzpddDisy4KqozDO9Mvc6bBfY+LOoFw7zuxlIwBXhGs=;
        b=jJ2RyOEoREW1xX5f3OZrAVQYUezPmQyWpJaxorbijqb6DqaQFN2CjV+4GPp8Y0mC7v
         kiEMoOue5i2/smlC+73djnMSJn0u57Zb5SCbTSI6wAa95aZ8hfqZgMIBK7JZu2fvKPHE
         JU/0Rak0C+uMFX8zAdzUBC2jX3qJgItiqBlxTmHC+1icwHOtWJ8xFT61V8rH0he2lYij
         bz0fKK7ab7jA5wIMuhwY4A57oplfW33W2dGnUOGlK58boVPs8ilIYByUX16fPYF0P+ac
         21v5wGxkqK4iiIIYqvA6VxRBg+1WK8dLi+PtTy2vwB0w/Gi5FvEp4ctE6NO/n31Wjno7
         0Fjg==
X-Gm-Message-State: APjAAAU95iLY3DkYL3eqP+rZyY0Mej7tXzzG6nAOQ9J0AdMyX+tD2U8r
        wM2UyBQb45JTdUKFoVrCaDTMtinI
X-Google-Smtp-Source: APXvYqwgost0uK+TZA7QaMoYXal8CFmKLsReu2bwfuH5HHTsQicuOm2o8B49GR1ysA789hves3OqhA==
X-Received: by 2002:aa7:8dd0:: with SMTP id j16mr31805827pfr.58.1574069982599;
        Mon, 18 Nov 2019 01:39:42 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w26sm22185011pfj.123.2019.11.18.01.39.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 01:39:41 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: [PATCH net] net: sched: ensure opts_len <= IP_TUNNEL_OPTS_MAX in act_tunnel_key
Date:   Mon, 18 Nov 2019 17:39:34 +0800
Message-Id: <920e2171915c7d2ba4c7ea4315e049370002afbe.1574069974.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

info->options_len is 'u8' type, and when opts_len with a value >
IP_TUNNEL_OPTS_MAX, 'info->options_len = opts_len' will cast int
to u8 and set a wrong value to info->options_len.

Kernel crashed in my test when doing:

  # opts="0102:80:00800022"
  # for i in {1..99}; do opts="$opts,0102:80:00800022"; done
  # ip link add name geneve0 type geneve dstport 0 external
  # tc qdisc add dev eth0 ingress
  # tc filter add dev eth0 protocol ip parent ffff: \
       flower indev eth0 ip_proto udp action tunnel_key \
       set src_ip 10.0.99.192 dst_ip 10.0.99.193 \
       dst_port 6081 id 11 geneve_opts $opts \
       action mirred egress redirect dev geneve0

So we should do the similar check as cls_flower does, return error
when opts_len > IP_TUNNEL_OPTS_MAX in tunnel_key_copy_opts().

Fixes: 0ed5269f9e41 ("net/sched: add tunnel option support to act_tunnel_key")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_tunnel_key.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 2f83a79..d55669e 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -135,6 +135,10 @@ static int tunnel_key_copy_opts(const struct nlattr *nla, u8 *dst,
 			if (opt_len < 0)
 				return opt_len;
 			opts_len += opt_len;
+			if (opts_len > IP_TUNNEL_OPTS_MAX) {
+				NL_SET_ERR_MSG(extack, "Tunnel options exceeds max size");
+				return -EINVAL;
+			}
 			if (dst) {
 				dst_len -= opt_len;
 				dst += opt_len;
-- 
2.1.0

