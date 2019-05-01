Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F35A103D0
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 04:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfEACG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 22:06:58 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:46093 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfEACG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 22:06:58 -0400
Received: by mail-yw1-f68.google.com with SMTP id v15so7414457ywe.13;
        Tue, 30 Apr 2019 19:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=mP8S+aTEH0TfrmSoHVNIm1wecVOgLyl9+6N0y5RZVwA=;
        b=Tj6RiLbI8BFpKjLDqseZeMe2CLCAmWn4FY0XFyw7vEVAKjrgZLbe5CCXk0WWN/x0n7
         5tbwgUp69Qq8ZeJwuxGbYv8gmiYqUUBA3Nu3VoufmbJvm/12MaxMwOnLom1IdjrerTkc
         hmtFbbEzhey2TfQIcd/XDIfyF9GqyIs2n/bXpYXxNs9yRGmeA8+2wdfnvQnOAxvwp4pT
         GyUv5mMKl39lXwbCHNuGQDVgq84OooHL9c6H0Vvw9xDCSysCDgbLY6OboYzQ46NTxw6D
         MRr+6fex0H/T7x4t43uxLcloDrqGxWu+Mtk/UojR2RyjeX9VwXPJhqOnzfWl5JBHc+nT
         vFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mP8S+aTEH0TfrmSoHVNIm1wecVOgLyl9+6N0y5RZVwA=;
        b=Z9o0ZwwIKXel/0O8v/pVNUDp0ZdLLctpZE7zRsIqIq8IfCSNFJBK9D1sJWNld5JErX
         no2zcNevW0gsz4PAIQdw1ofviiubY+r1SMq395zzLlJUf0MY1Z7j7Mkme7KLe6BcCyWq
         maLF8IsiokcjolS+z4Je9aD26o/qUu23lUMGa67em2IupAUlOi/p8vcitIrk9oIP137D
         vT0hBrnR73Sy7lIvrr2QUiGtr5LwS2dEz3t+9CWVkE+RvQ1RhM22863RxwCzCep5Vr2H
         JhL4YcL4LasTBYJFBDqHM3Q+IMCD8VoXii284wRQv/45td5u9n1+Lpf+P1NClNZ/UT2W
         V/mw==
X-Gm-Message-State: APjAAAXJ93bhPzg+AMeDQMxtqzu9s4I/a1v72hcBAYD2Z1vVZUAXxkDd
        C9sjfB/KyhwDYBOFTriTEBE=
X-Google-Smtp-Source: APXvYqx0OW9JWz5RcPk1ZiCm3VngQcRvJtWRAEuXC5YuHEy6ZOPRqGWp7jd/YKXxAI5CP0Nj0phufw==
X-Received: by 2002:a81:5501:: with SMTP id j1mr50822573ywb.341.1556676417476;
        Tue, 30 Apr 2019 19:06:57 -0700 (PDT)
Received: from [127.0.1.1] (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id b69sm6002479ywh.18.2019.04.30.19.06.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 19:06:56 -0700 (PDT)
Subject: [bpf-next PATCH v3 2/4] bpf: sockmap remove duplicate queue free
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub.kicinski@netronome.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 30 Apr 2019 19:06:55 -0700
Message-ID: <155667641591.4128.16138679120246402872.stgit@john-XPS-13-9360>
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

