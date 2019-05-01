Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706D7103D2
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 04:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfEACHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 22:07:05 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:45137 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfEACHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 22:07:04 -0400
Received: by mail-yw1-f65.google.com with SMTP id r139so7422358ywe.12;
        Tue, 30 Apr 2019 19:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=WzJyuh/ma1ajUJQPClMwlhf7p+o4ybJ/vyppnP30TzU=;
        b=uyUGqJvl88AlZC4coc/riLd1un44MdCbMnqcllQHNGNh65dB33xWb//pbyL+Q81Kp9
         waApGve6mi6KMspg6Tj206aMNpPlrTYNcwVoijNpQ4F2BC/+4ETlTVp37biLn+ii/4c+
         R0h6JrSlCOOOVoA7Jm7aD3qQaZbQ3lw4P/sSrvtyqUbdFRUye/m6sGCi8PrXKq01C/s9
         MUuGnPRMrPpFcwwXWRPe3Esmy8yKRcRnbvBhG00vTR3EcDvDcmwWUqQDSjaBqHxcNaAr
         5Wp2xJd8f3Z8ukmwfVizWITH0Ffcs0sxbpAdyHL11Q/HhSMjaAp1lbOIDaMNuPI2OY30
         wJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WzJyuh/ma1ajUJQPClMwlhf7p+o4ybJ/vyppnP30TzU=;
        b=PKplfMHuKaWjJ7f2/dt7DvBbWdvz50nTruDyPzhlEP9oecxmKWPMPTIT8YHioBtwp7
         nfq5fWFkn+4g5OJzlipPzuHIINI36V/oWzdv/W4Ov9TO0iZBhj9CMh6QHykZlARgCJRr
         2AXwSFbrNaiQBMl9q9m+NbI3pFWx+0iOfD7dW2aeXTGKVV/x/aOCiN2sJgrbBsqF1rin
         IlkzFdIuL+8NDuz//JU6wHRS5oHVCYW8x6MUEOXgfF+tPJimd6ezYLCbDzxXMsXvJzid
         kleY1TKiTdccPtzWzUWOKnLi4RMnlv8nia4FdqcHNXGPqT/em8R2OTDBctePWZdfYO/d
         8XNA==
X-Gm-Message-State: APjAAAW7koqTKuphHO+37qF12P6AxbkZrwU6N/I2nsQSQ/fBRXkIp5RJ
        VwWVQqxl+pDdyP1Fr42HhNA=
X-Google-Smtp-Source: APXvYqweT3Q3lfynNjFjuu/PrU/uwtmf0nVPfMs7UjlQoSpAOx40GuNdihGpKGIvSStTZA8cUA/w7A==
X-Received: by 2002:a25:3143:: with SMTP id x64mr9416168ybx.333.1556676424017;
        Tue, 30 Apr 2019 19:07:04 -0700 (PDT)
Received: from [127.0.1.1] (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id e64sm7217893ywf.63.2019.04.30.19.07.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 19:07:03 -0700 (PDT)
Subject: [bpf-next PATCH v3 3/4] bpf: sockmap fix msg->sg.size account on
 ingress skb
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 30 Apr 2019 19:07:02 -0700
Message-ID: <155667642255.4128.6629806323338519870.stgit@john-XPS-13-9360>
In-Reply-To: <155667629056.4128.14102391877350907561.stgit@john-XPS-13-9360>
References: <155667629056.4128.14102391877350907561.stgit@john-XPS-13-9360>
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
index cc94d921476c..782ae9eb4dce 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -411,6 +411,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	sk_mem_charge(sk, skb->len);
 	copied = skb->len;
 	msg->sg.start = 0;
+	msg->sg.size = copied;
 	msg->sg.end = num_sge == MAX_MSG_FRAGS ? 0 : num_sge;
 	msg->skb = skb;
 

