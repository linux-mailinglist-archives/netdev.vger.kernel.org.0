Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27EC3197E0
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 06:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfEJE64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 00:58:56 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:50753 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfEJE64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 00:58:56 -0400
Received: by mail-it1-f195.google.com with SMTP id i10so3529161ite.0;
        Thu, 09 May 2019 21:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=sXjcZAGx/RpTcazRtKGemnEzej0TeSnJcmicvFWVu4Q=;
        b=FEsMZqtePG1DT2N40RwQ1mJnZO/UuSWc1tDQpYSskbki6aupwm+VT7LNuFFCL191+w
         qMAjaJFhy/zUyVbRrQUaHJCt+myy3aS3maHIPx9eeJtv3DXoYZIv81CsTWEvwlOaSgpD
         4B166WhgCNhROhB9+RQQw5v/6c3YBm4Z9a7O2YST4kZ7oSd+QOKCu9qIZoX2SWpeNHkP
         AQMYRnSee/YTmL66wP/AW89QxcMATJJ2jdux8PqUuOTaEfW3pWJxiHt7SeAjI+r/Dy/f
         TCkiZ9Sd2JEXHuc5NqzfWEiIXevcVqGmT7tcpk/id7mMTUSD2vd3yF8Eb9UI3F9yD0f6
         XAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=sXjcZAGx/RpTcazRtKGemnEzej0TeSnJcmicvFWVu4Q=;
        b=Wpi9t2oWXTzWbrcu9FJxBSOonYDuDnPUsJRYgR5lolvJp7VqJCTNgxZmdDbDJrUY7I
         aB5UnWLOVHcNEHk5vlpKo/+d1cIq/AxqYXnV6rqjtBniI1xXl/TFA50jaQNo9wONv5V9
         +PwMeSP02K2g3JbOZz3q28H/MjTkHO4OcQKIE8HZl57YumQpWTjBOHxmSkJgnKbTA2hx
         KMu46dN5TGOa731p3zD6CB8cYZmiGhrjgHs7CncDuZSs7MSFQdWjmYbAbnZ/ZKNwOvMn
         RL1Tk23dhlv+Dci9ysj2IAybQSMrjJtQfa/qFSDvFHquU3mtfNzGNGtYnrQE7w5IaIvo
         PzQQ==
X-Gm-Message-State: APjAAAWwjguujpwjh5tsNwzkQfNoTOQ7O7I0SosmEazo8poLvpwn63sX
        CIKtWfSCGlrBkMG0rLGFmvYWSyNQd00=
X-Google-Smtp-Source: APXvYqySsDADTTzR8MylZnx4EpN6PW2vjAEMfnZkIYkDkNB6dBBOr0wzT+WNoscJjbpTAh1x6AS01A==
X-Received: by 2002:a24:a3c8:: with SMTP id p191mr5935756ite.149.1557464335786;
        Thu, 09 May 2019 21:58:55 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 8sm1922254itd.24.2019.05.09.21.58.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 21:58:55 -0700 (PDT)
Subject: [bpf PATCH v4 4/4] bpf: sockmap fix msg->sg.size account on ingress
 skb
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 09 May 2019 21:58:44 -0700
Message-ID: <155746432481.20677.8713455957718721777.stgit@john-XPS-13-9360>
In-Reply-To: <155746412544.20677.8888193135689886027.stgit@john-XPS-13-9360>
References: <155746412544.20677.8888193135689886027.stgit@john-XPS-13-9360>
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
 

