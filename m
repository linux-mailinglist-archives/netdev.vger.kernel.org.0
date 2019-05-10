Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4AF2197DC
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 06:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbfEJE6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 00:58:39 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:55759 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfEJE6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 00:58:39 -0400
Received: by mail-it1-f193.google.com with SMTP id q132so7372770itc.5;
        Thu, 09 May 2019 21:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=mP8S+aTEH0TfrmSoHVNIm1wecVOgLyl9+6N0y5RZVwA=;
        b=lvPrLg6ipkI/ej3KnnB+gLf75D95unTUOGE/EEGwwrMA1XdAD27uOCxc7w3TcfZItz
         lx6Nczwcdm7pS2hObDxd1e3SYWFaR47+1BH8c15jxyX+T/2OtHzQQKi8+U836c8Al84B
         730dlXYyd3LE40a8M03PntWy0L/gv+5nFP6hXTlp0PB8gj3xcaN1YHuenO4NkqT/faBK
         Rpq9YR41QJITrILnih6oImoDl/9fpzS8CbXs7IWdj2/3Mr8Gl3Bu7ZoAhB0E+h8oBWW6
         ev/OKylKnJrTJTiCw95M92HXn3/Mb57p7eSxA/ZNSY7NaxEf6TYM4ppQW17yV8px0JXD
         eI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mP8S+aTEH0TfrmSoHVNIm1wecVOgLyl9+6N0y5RZVwA=;
        b=S3t/QZPsHXGRwe1YjTQaeQrxxutrTQbfC4s1bHIchKuJRlCtiijOVFBzhp5CIplSMG
         jmpqeuFS956IHGrQyhDcJ3d4JA7OsPDHbQYmJCg21dbN0iwuRYZLnw7ZyUyI/0zz1+IL
         S8oXzAxzcr+lIgtKBDeGl8QDzcO+HIV1r0KYo2oqbQVPj7ky4W9d/j4kWxNg+ioB6mwW
         aLzMRRCdAaw19kVZVBESN3s8QW0rLX8oWHnZG7Np7ZTlTXlAwpajUzUiLrFqabcVAbN9
         lpG1u2TbkLFUADUFKYh99Cf3We7Xx4VZiiJNrR4nf5UWn2+ejo675D82KQeS7Jx182pz
         Foyg==
X-Gm-Message-State: APjAAAXGn3irUX8vzQLDhTupMD5utPf5DYwNsdDJZEgFCH78ea1eIKzq
        h08nToOOj14tW4AblWDbuGA=
X-Google-Smtp-Source: APXvYqwNElPglfOCLntwbsqoOz7KzNjmOc/iB/Lux5S6uq3qVnUZAGsuwvuN6kC95LtYL/cKBHl1/A==
X-Received: by 2002:a05:6638:209:: with SMTP id e9mr6638925jaq.22.1557464318482;
        Thu, 09 May 2019 21:58:38 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e22sm1667385ioe.45.2019.05.09.21.58.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 21:58:37 -0700 (PDT)
Subject: [bpf PATCH v4 3/4] bpf: sockmap remove duplicate queue free
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 09 May 2019 21:58:25 -0700
Message-ID: <155746430557.20677.2766490776601333105.stgit@john-XPS-13-9360>
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

