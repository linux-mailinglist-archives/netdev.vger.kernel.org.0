Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB051134EB5
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgAHVQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:16:24 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:37214 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgAHVQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:16:24 -0500
Received: by mail-il1-f193.google.com with SMTP id t8so3908506iln.4;
        Wed, 08 Jan 2020 13:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=m8Rchxp7WynrVrNQW7gz1KcCJvgeZh/2BETow1fq1Bo=;
        b=QqoQBK2bwdHuoMAaimQOxerVbNsi3Px0z5fL7uQStVjOYFThjmYpGsflbYQ8WpzBA9
         qlqk9seUe0pi1gaoOGZ921XYu6osXCCnFLeZIuEE3AeIhO+g0P7azgC67qcOsYAs4EbY
         uIshlgN+ptvIT1ZjyEreSn2LnBc0Dl1vF+kZ5NVcfhbcGx6NFN+/ECqVK/8gTOW3nmDa
         R2i56OKSSoySGNKLUK5CaByP8VRZ/akk1wmeyC7WL5GMawgew8dcIzId/A3CaOhLdUPo
         l+3nggYaJmX6zt3qaymCWhc32I/tZRnjXki49E5qwkcwsuoL8E5eX7RDNb/sAUGl3DBI
         WtYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=m8Rchxp7WynrVrNQW7gz1KcCJvgeZh/2BETow1fq1Bo=;
        b=HBbtowahChIcy9DRF7g24lErfy0+QwB+iPEdr/rzIcBGd6gD7We1pqjjK4t8NqCpS8
         SS8VozMSccZzZ7eYgj4zxdEk7eI+Y5fN/5COv9vrQEQIPF/1UqeACOW8AlaHnpf6Defi
         5BQk0MsYpRKXMTt3S487hvbz0Kg2xTDa1tFqkSuBd9mLgZkl3/n8Hp2JWUMmGl+pAgy6
         MB5JsFLjpDkrlmbk3oKWFxWaQKpvwjGmpUQ3R6c1tzGmVJuWLL3EJ9mvXmQX52nKqg2P
         kImxkxbsFhmR9kWrAYRQsRNU+5uxZV7zzeQ7KMZLHAqVs2yznjGZT5RG5vzpdvpry6aw
         ugVA==
X-Gm-Message-State: APjAAAVSZEvDkV3QdLvquZFT+ouze3VY3moXUhWwDiUqNk2n1B0KPKvS
        pS94Yi4muSwuoD1JqU1eEvjDYEp5
X-Google-Smtp-Source: APXvYqzr/9d+tadjw2nMeNKOAHWft++tJnwtK6W4m0lHXF08zQkV8JkIWyv+pnuzwuKNBpbmcl/NpA==
X-Received: by 2002:a92:d5cf:: with SMTP id d15mr5490293ilq.306.1578518183266;
        Wed, 08 Jan 2020 13:16:23 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i13sm903229ioi.67.2020.01.08.13.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 13:16:22 -0800 (PST)
Subject: [bpf PATCH 8/9] bpf: sockmap/tls,
 tls_push_record can not handle zero length skmsg
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Wed, 08 Jan 2020 21:16:11 +0000
Message-ID: <157851817088.1732.14988301389495595092.stgit@ubuntu3-kvm2>
In-Reply-To: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When passed a zero length skmsg tls_push_record() causes a NULL ptr
deref. To resolve for fixes do a simple length check at start of
routine.

To create this case a user can create a BPF program to pop all the
data off the message then return SK_PASS. Its not a very practical
or useful thing to do so we mark it unlikely.

Fixes: d3b18ad31f93d ("tls: add bpf support to sk_msg handling")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/tls/tls_sw.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 21c7725d17ca..0326e916ab01 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -680,6 +680,9 @@ static int tls_push_record(struct sock *sk, int flags,
 	msg_pl = &rec->msg_plaintext;
 	msg_en = &rec->msg_encrypted;
 
+	if (unlikely(!msg_pl->sg.size))
+		return 0;
+
 	split_point = msg_pl->apply_bytes;
 	split = split_point && split_point < msg_pl->sg.size;
 	if (unlikely((!split &&

