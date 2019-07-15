Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3BD69D11
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732579AbfGOUtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:49:45 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46340 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729505AbfGOUtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 16:49:45 -0400
Received: by mail-ot1-f67.google.com with SMTP id z23so18502901ote.13;
        Mon, 15 Jul 2019 13:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=tuW20oRn6IJ0xhfycOnDw/Ym3bbk01yn3xu2K8ZvEKA=;
        b=rHuAoW6rz7p2nDeRv0XfGUjc4uQp5JemfeAPFkJMtUaQnD5wcBfiPye1IMqk9OiJPY
         I6c2/cXrsd85CQskR03FNaGnDORbctFY7Ke2/gbAcnqnX2wtNhSOyi6Ofl4U3emr0znZ
         ootuiYWWyUodz1VezolmXG4MmchCIpJ0bvRV31qmRTow+qh1MAS7qPpM7j06MMl0ZDh7
         CiaQh/lKzHm1zfzFFLY343h66IOCN7r00vKggGl/6oMI9VWT/LLmMhBSNtduULbuBzqD
         Bs2JB2eNOp9iuy+DJfvDOVoAvfjTCIIGdg3RkJEc5lx8edw/vBEYgqEvLUiDlD+ykZgT
         0YFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tuW20oRn6IJ0xhfycOnDw/Ym3bbk01yn3xu2K8ZvEKA=;
        b=nbs1kMiAGJ+ye62FDf1k7hJkulzfM46l71fvolQp8nnckSpANYB4u3KJ1Bkc5okwaS
         fmvg92RqLMOOQTCUTAkgwNKKJyasAQaizDLD1rgG7/u957dkbxlJPIYO6SsRZZYevWxG
         gkTQT5RG+ID0EM408TyN4vpcKM/EXPmCipZiMRlW4VnPbf3FL44019ILedUX8Y3jOiEL
         j8fjOLA/JJUXPwX0mTdnwRiKfnpEgZT2CTR0GNN0yue/JndcCM8PTc7ulf8JYqAq2+0I
         8z50fTDZYX8gcLppo3Ox1JZ4UOFkGas0kL2G1NoXqto8Bk7CFwcgvIFlmxUrokNWQlYS
         41og==
X-Gm-Message-State: APjAAAXXmIPeKGAt0FtY17vKGX8d3Jv+oI++LHoGbppQqDiV2aRnSmGg
        GTLjSJGoaSP6kOmsRlXo9FM=
X-Google-Smtp-Source: APXvYqxs72/143Cs1oCHNdncKNJa58y29RlhSdtJbJKVT4e2MKR0130YylWHfpP2p9uuAHrasvWZ+g==
X-Received: by 2002:a05:6830:193:: with SMTP id q19mr22293791ota.187.1563223784174;
        Mon, 15 Jul 2019 13:49:44 -0700 (PDT)
Received: from [127.0.1.1] ([99.0.85.34])
        by smtp.gmail.com with ESMTPSA id w3sm6923532otb.55.2019.07.15.13.49.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 13:49:43 -0700 (PDT)
Subject: [bpf PATCH v3 6/8] bpf: sockmap, synchronize_rcu before free'ing map
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Date:   Mon, 15 Jul 2019 13:49:42 -0700
Message-ID: <156322378251.18678.18296242426680141239.stgit@john-XPS-13-9370>
In-Reply-To: <156322373173.18678.6003379631139659856.stgit@john-XPS-13-9370>
References: <156322373173.18678.6003379631139659856.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to have a synchronize_rcu before free'ing the sockmap because
any outstanding psock references will have a pointer to the map and
when they use this could trigger a use after free.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 28702f2e9a4a..56bcabe7c2f2 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -247,6 +247,8 @@ static void sock_map_free(struct bpf_map *map)
 	raw_spin_unlock_bh(&stab->lock);
 	rcu_read_unlock();
 
+	synchronize_rcu();
+
 	bpf_map_area_free(stab->sks);
 	kfree(stab);
 }

