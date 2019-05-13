Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E171B804
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 16:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbfEMOUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 10:20:08 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:40452 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730152AbfEMOUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 10:20:07 -0400
Received: by mail-it1-f195.google.com with SMTP id g71so20532540ita.5;
        Mon, 13 May 2019 07:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=sXjcZAGx/RpTcazRtKGemnEzej0TeSnJcmicvFWVu4Q=;
        b=S73SiI9lAA7RrOb3X/PjH9wnihNO9U1lablWceDVIXOquRMQsGC1bO7y8yg7/PzZ/r
         VdmsdHlo4fE3IJ2trn63+Lwr6jWGNOR3iEOfetmEEpbaIkPlsFgz4Goj7sCCSNNmR0BD
         Zk7RMbm/gO1I2WWJM/vWiJP2uDPg9cbFbf9tBa/T/NvMY0xd0PgSVdBSlmrycaYJeapN
         kHJ41G3pimy0w2hieukhkFp53k+fA4Zh9kxUH8D5rshuGyS6WNembrnK0N1FGDcF8HSM
         HrGFK0HRayDMCZVvEa2hM0j3Ct9pRzLRhMBZBkQq/RXQvR7VNQc3aKqexDQb4wJA7f+T
         ppNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=sXjcZAGx/RpTcazRtKGemnEzej0TeSnJcmicvFWVu4Q=;
        b=lS+k7Io+MFsoy5FINEqYCKbg7cFVKY8vUlgKI5gDo+Gj0gF9tZE8voKriKDjPNy8Oy
         jOAd0f/dEsng9Q8TMlJsgB+W9rOAKwmHfcRrPADyAZs43h3rwMzQwBJ6hi6nzl7G6rxo
         SQMvZdEaLLlIbAVdQQP/xBYg8zZAxfMOq0qjbb07cT/VJ+i2YfWA6zpetScPY6x+dSU8
         kYx5YfHl/yd88NCLPdS5hBJreol0T/MfGvr3FzTF1wckdDL5WgLHfthc/gzjvijvQQpR
         WXXJ/MIA26pYinwYkGhGcyCPRg/+WHQtuvHFeElS0dhlSAZ0VUy2hUZC4NVBByrnPBx2
         aLMA==
X-Gm-Message-State: APjAAAU5FxN8QcgynWRQw8BLSGjlBgueFCoaiHrVR/PPs6pC5dc4rqcm
        G/msKvW6ftoi4n88LMcjTQA=
X-Google-Smtp-Source: APXvYqycSis09rSUOTEEsQy62HmByDrbwJtKdc9PC0Bz+xtKFq2/h+ZwJS7IAOCGlCfyesocY4bJUQ==
X-Received: by 2002:a05:660c:552:: with SMTP id w18mr697748itk.26.1557757206905;
        Mon, 13 May 2019 07:20:06 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i141sm6272314ite.20.2019.05.13.07.20.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 07:20:06 -0700 (PDT)
Subject: [bpf PATCH 3/3] bpf: sockmap fix msg->sg.size account on ingress skb
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 13 May 2019 07:19:55 -0700
Message-ID: <155775719541.22311.9144799183119218586.stgit@john-XPS-13-9360>
In-Reply-To: <155775710768.22311.15370233730402405518.stgit@john-XPS-13-9360>
References: <155775710768.22311.15370233730402405518.stgit@john-XPS-13-9360>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When converting a skb to msg->sg we forget to set the size after the
latest ktls/tls code conversion. This patch can be reached by doing
a redir into ingress path from BPF skb sock recv hook. Then trying to
read the size fails.

Fix this by setting the size.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 49d1efa329d7..93bffaad2135 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -411,6 +411,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	sk_mem_charge(sk, skb->len);
 	copied = skb->len;
 	msg->sg.start = 0;
+	msg->sg.size = copied;
 	msg->sg.end = num_sge == MAX_MSG_FRAGS ? 0 : num_sge;
 	msg->skb = skb;
 

