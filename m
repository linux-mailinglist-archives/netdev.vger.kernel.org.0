Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E705D473D
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 20:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbfJKSLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 14:11:46 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:41964 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbfJKSLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 14:11:46 -0400
Received: by mail-pl1-f202.google.com with SMTP id q3so6511566pll.8
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 11:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=AAxSBma4MdMPcB0qmLBHWNrhw+FW6k6FbqM7M2RKeSc=;
        b=dWlEO5IqJ4SUexbN83ceTc9zvnYaW0nzUzPwbBTuj6csZKFrJrYw3jAixhNT8IJ/XZ
         pZH1gmEVQqF5wg2hDoPmy7QkSZPNqXUj0Y8zaj5mcP9PuKHNnw6VN2WDE1ljYHd7SSec
         LPN+rGbRy7zRkcqcpw3QOw5oFoTC1vxe6a4allFIlxzcbQhgjl245yNlgiKA0td6rKLT
         +I9fjmkJic3vOvG61DUHFH84T5kWvtFr79dwQKJJY4OUNn9quup21aMuTzaM0V1I/DGN
         eaEf8EcNK8mGjz+StPkpU4pMs2pB1ohXBNoQ0y1wx9aC6J/QhzXwoAnGZWy1mr93NqoV
         NedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=AAxSBma4MdMPcB0qmLBHWNrhw+FW6k6FbqM7M2RKeSc=;
        b=n8BjVdXOPFKFF7t1WYOrryEsYk4Quz/0A23DyyQ4uNqD+wbxIhGra34ZSINtqj2yB+
         FV2x71BmOi7fl58YpIBkuqMAiC343I/bJ2w5OED6y/1K8caeA0EA8x1Iro93EJhAUPLm
         spO9IvyDxeuESOqyBv78foEoSrE9HiuBZDRNZCDc8n3uJIMZexggunM65Unl7YU5KShz
         JpCSLMKWS7SArGmaoaiPJTZDhrdLE+uUshHt78OStnJN5N18Nu1NQSOBi+JI/S5tsX26
         C3wjXE1GHfEOjtYXBuEB0P4+DMO6Cct7eRDinAS7XTaIVCmKVNRZmuKTgPw0yf43ap67
         kPkA==
X-Gm-Message-State: APjAAAWokj/laoz40DRXpZmFwnPwydOhhGI+MwQLFxavC9Z2U6sFUnk6
        RrEW/QwKvwy+4mhtyBiVwoVuNZoCIJxRAg==
X-Google-Smtp-Source: APXvYqwaoNiHnegwaHhHamZSWAckcNY3WBqeqE/A9WI0uicRoCDp0Sy8GknnpGVFJGYvXPiPPuK0dPGaw2jWCQ==
X-Received: by 2002:a63:6506:: with SMTP id z6mr17840685pgb.65.1570817503445;
 Fri, 11 Oct 2019 11:11:43 -0700 (PDT)
Date:   Fri, 11 Oct 2019 11:11:40 -0700
Message-Id: <20191011181140.2898-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH bpf-next] bpf: align struct bpf_prog_stats
From:   Eric Dumazet <edumazet@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not risk spanning these small structures on two cache lines.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/bpf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5b9d2233860654512da6ff5ec8bf56f2343ed722..282e28bf41ec627cad63c6b5bc3f439dc5f58f56 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -363,7 +363,7 @@ struct bpf_prog_stats {
 	u64 cnt;
 	u64 nsecs;
 	struct u64_stats_sync syncp;
-};
+} __aligned(2 * sizeof(u64));
 
 struct bpf_prog_aux {
 	atomic_t refcnt;
-- 
2.23.0.700.g56cf767bdb-goog

