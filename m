Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F743C3D9
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 08:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391120AbfFKGPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 02:15:16 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33541 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390485AbfFKGPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 02:15:16 -0400
Received: by mail-pf1-f194.google.com with SMTP id x15so6753105pfq.0
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 23:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=iVWj+eIgxhlyu/8/eWfjPEtUoCXArd1LAabT3mqlhDI=;
        b=jpUBHU9BwWKMou+PRRXvXOeVUvfcrK1yUYQs7owdnqHxZAP/NCo/kOspBDPwOhNQ+Q
         P4e9QHlWZNEutbbyDvGGh4rbBqYE/uO7KgoWC/rJYzprR7xhF88F1BkwbZ7yUwu8yK+1
         6HG3RM6I2YYP1t+ca3ji/fqgbUmi/AOoS/2SfMs56+X1d6b21GStsbwWFYpE2xbNww/V
         PUyK5++wOqiinahnV3dJToBBC//yQng7HOwWPLpmpDfeFSLOgyd8FLMqEPGPVKD6Hio7
         wrr+aaka9lcNE5BuQjW6c6nJg14s1mSTFHw+kNMefx2bOhw0LEjseCLLIvJs3GwuJFwt
         EoMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=iVWj+eIgxhlyu/8/eWfjPEtUoCXArd1LAabT3mqlhDI=;
        b=lTMZS8bO4qyinayhXsbfnQPKu4Qgkgk25gnwjh2D2IUxgWbzJ9uzQhi1H4JNgK5Keg
         Upf2FruTmrb/lfeYx1Xlc7lT/w7102DLjCLfk9NFmfB+aGWuZYCM6wlmiel8SBkEG2eB
         FnJH4x+M8swQslbRGhMIa4s3j1ho7z+jZNV3V5Ha56JEtHwzUvn4nLS9DY9lhdbUocmA
         9WJx+Vnjxe6BWcfxmMWR7a9OZxbn7VUm+2HGglNRacEW4YSf2K01gnu4exbAcP5XJmQT
         yAru+hip38iEpgQO58u2kQsJYEROcsUhtw5SSWXRtd8okBfS3kSevx6NBQ9njh5mwoBB
         vC0w==
X-Gm-Message-State: APjAAAUTqD6nyq8BJy+vb+18DRYM1U5MNTgSEZrjBX5ujggBC84JIjSU
        uNimPfQfiN0C9/WvUeX99a+yDy4By1g=
X-Google-Smtp-Source: APXvYqz/NAQ9lUbVhBPxR3KsrVGhAjMLnwHZehXnkNNnExwyxHGGSUiXB05tkVIl7gnK6i+pijx8Eg==
X-Received: by 2002:a62:38c6:: with SMTP id f189mr2096343pfa.157.1560233715429;
        Mon, 10 Jun 2019 23:15:15 -0700 (PDT)
Received: from [192.168.122.156] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g8sm14097961pgd.29.2019.06.10.23.15.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 23:15:14 -0700 (PDT)
Subject: [net PATCH] net: tls,
 correctly account for copied bytes with multiple sk_msgs
From:   John Fastabend <john.fastabend@gmail.com>
To:     steinar+kernel@gunderson.no, daniel@iogearbox.net, andre@tomt.net
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com,
        davem@davemloft.net, ast@kernel.org
Date:   Tue, 11 Jun 2019 06:15:03 +0000
Message-ID: <156023370286.5966.10762957456071886488.stgit@ubuntu-kvm1>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tls_sw_do_sendpage needs to return the total number of bytes sent
regardless of how many sk_msgs are allocatedt. Unfortunately, copied
(the value we return up the stack) is zero'd before each new sk_msg
is alloced so we only return the copied size of the last sk_msg used.

The application will then believe only part of its data was sent and
send the missing chunks again. However, because the data actually was
sent the receiver will get multiple copies of the same data.

To reproduce this do multiple copies close to the max record size to
force the above scenario. Andre created a C program that can easily
generate this case so we will push a similar selftest for this to
bpf-next shortly.

The fix is to _not_ zero the copied field so that the total sent
bytes is returned.

Reported-by: Steinar H. Gunderson <steinar+kernel@gunderson.no>
Reported-by: Andre Tomt <andre@tomt.net>
Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/tls/tls_sw.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d93f83f77864..5fe3dfa2c5e3 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1143,7 +1143,6 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 
 		full_record = false;
 		record_room = TLS_MAX_PAYLOAD_SIZE - msg_pl->sg.size;
-		copied = 0;
 		copy = size;
 		if (copy >= record_room) {
 			copy = record_room;

