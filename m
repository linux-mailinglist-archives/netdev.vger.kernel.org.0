Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23D5D1B800
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 16:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730183AbfEMOTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 10:19:50 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:51920 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728867AbfEMOTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 10:19:50 -0400
Received: by mail-it1-f195.google.com with SMTP id s3so20556399itk.1;
        Mon, 13 May 2019 07:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=mP8S+aTEH0TfrmSoHVNIm1wecVOgLyl9+6N0y5RZVwA=;
        b=sD60AhmSoRIY0JXnr0SM/7gusABIvZPmhkoRRIeGoch/0+HU4ASxY6RDI8+hzxwK69
         3u4AoX3VE8LcaOh+AyOCw10mHCY+9i44k1+eCmDpJRAdsRLFpzkfOB6mF1m6uFBGxf1S
         9kDDkDxAxmXSHW5segy2MotM1AsesCpVDqaLneOWG0hwj1I2qcG7AOkp7yDewRhXrVYI
         suvTo/OXhtaGcSlZyAvKyiFQlcL7tTvS6qVQWwqWhx4tG0K9lABKnc2RIToerBzgFevf
         WkWxy1crG8Aajt8XweJcDXDbhUguUj0tTRIxEluAhTdtqqPzxR6M+FWuds+m5FI766ND
         Ihrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mP8S+aTEH0TfrmSoHVNIm1wecVOgLyl9+6N0y5RZVwA=;
        b=OOn5NlThGbZM2tb9LbogSebpVaPEAJIfZFnl2/aBD5Jd48D2iSPR6gVlkj2JbpG1ZC
         5u5VSvh/dzwmAeY4mbn3yiL3hvf6HHLEdNN/qM+eUMGPdTPsZr+TkTpnopdfJUcBydZ0
         GV3j59ofWLFkDzNv3SXfNZMmYJtXoO6E+QjYw1vHdtV6ktnmIsvXVIoTruu7dVPJDRFS
         M9GY/jGHICG38/nbYaPd98DtjDPGux8aCYZB+WqNBlkb9S6O+rfzaaHVREiIE7hQCQC+
         h6vRm+Gxju4+JRr6F0yA8wYGObjie0V8c7m1WryCn0jWRygy3qPggArDb+6DPjZLUk8g
         NGoQ==
X-Gm-Message-State: APjAAAV4lNMLqw0E8t3X3mOb4YBLnV/3MxztEkd4ZdcUg8T9sRg9VIvQ
        HSVMAkWZF+L+mRXt4Spj5nU=
X-Google-Smtp-Source: APXvYqzcIwR2eabWCVAuF+3jNKhdqAJ0aMLvfc3Ai6vcjjGN9GxAvp8TZo3vZUoY7nYL4rMJocYMSQ==
X-Received: by 2002:a24:69c3:: with SMTP id e186mr17620837itc.37.1557757189414;
        Mon, 13 May 2019 07:19:49 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p16sm4376186ioh.6.2019.05.13.07.19.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 07:19:48 -0700 (PDT)
Subject: [bpf PATCH 2/3] bpf: sockmap remove duplicate queue free
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 13 May 2019 07:19:37 -0700
Message-ID: <155775717732.22311.13248108248808306711.stgit@john-XPS-13-9360>
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

In tcp bpf remove we free the cork list and purge the ingress msg
list. However we do this before the ref count reaches zero so it
could be possible some other access is in progress. In this case
(tcp close and/or tcp_unhash) we happen to also hold the sock
lock so no path exists but lets fix it otherwise it is extremely
fragile and breaks the reference counting rules. Also we already
check the cork list and ingress msg queue and free them once the
ref count reaches zero so its wasteful to check twice.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 1bb7321a256d..4a619c85daed 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -528,8 +528,6 @@ static void tcp_bpf_remove(struct sock *sk, struct sk_psock *psock)
 {
 	struct sk_psock_link *link;
 
-	sk_psock_cork_free(psock);
-	__sk_psock_purge_ingress_msg(psock);
 	while ((link = sk_psock_link_pop(psock))) {
 		sk_psock_unlink(sk, link);
 		sk_psock_free_link(link);

