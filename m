Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97142E9347
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfJ2XEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:04:48 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45788 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJ2XEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 19:04:48 -0400
Received: by mail-pl1-f196.google.com with SMTP id y24so26161plr.12;
        Tue, 29 Oct 2019 16:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z94quiijBmOlndVrWv7kp6lTcJTttQzC4W5Rz0hgJvU=;
        b=F/AlGELVGzAVCG9R0R+fH4wqJwzS30vt9rJwtrAinD/2lOLue2OOJntNXCvO9nY1+B
         gi4GrTJCPdsdrxEk0eW0AwJZnJcoaaQj2xdWmq52kF8wtKpA8IwHKWGr13sepL88Ay3t
         bExuPBlb7b74UauiUigvQ9+EFrDQgGeDs554JSvFqw5tLpwcvTAqEu8t/7spQ3P8BdUs
         OfxBjlNxby2uPQ1drm8chNpqf8JE/kHFnosFji5hXGDrwkFwBndNslumLxkxyHtJ45rd
         qIh8w27yJ1VxATkzQJz3z75/IrM6z1+AItY4LfVCddd50HGnZx/JgxyNptHm+nVKkSAu
         8C3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z94quiijBmOlndVrWv7kp6lTcJTttQzC4W5Rz0hgJvU=;
        b=GrW9E+V2btJmrPACDz0EoJ1FcK+wo5lare/PXpxh7L8UM/lQvCk1fERGjP6LwBSLAz
         uEli02GjDji6cp8WO4u7sOQA+8Z/qxUgOKaE3O9ES8q0sXQP89DBZNVZKoPR8skgcNkv
         kfzKefMhyXoS3zGwVcESVkuTF3iTS4Y9guamGsbj6OrNta1tx7dYhxjNZzcRWBUXaVeR
         SXfTLamvaCZdv55nFQmkp5UeVYV+jKH6zWVfc1F7d4ifXnKM2KMeFUUbu6kdbtgHXm0O
         lxNJpslln7U/n+D2w55pGrwwCcKWTy+JRL5SfyG2P7T1nmdBRA8kgmq+8pIttBbIBBCn
         VW4w==
X-Gm-Message-State: APjAAAXdBGNLBQAsrs7o6OAzLptSc9Mv1LeBcRgErarkuAC0KDO9M0r3
        uJdzi5J8ZDEVGn4/sZLss5U08YmS
X-Google-Smtp-Source: APXvYqzRSRQOcjk4lZcZOzu/Fx8cgyFTYK/7ClJRnQW/kmP29wnKmxW+jJbL2tlXMhFCe7U5vYkuEQ==
X-Received: by 2002:a17:902:9042:: with SMTP id w2mr1198605plz.323.1572390285086;
        Tue, 29 Oct 2019 16:04:45 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id e1sm249355pgv.82.2019.10.29.16.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2019 16:04:44 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/4] bonding: balance ICMP echoes in layer3+4
 mode
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>, linux-kernel@vger.kernel.org
References: <20191029135053.10055-1-mcroce@redhat.com>
 <20191029135053.10055-5-mcroce@redhat.com>
 <5be14e4e-807f-486d-d11a-3113901e72fe@cumulusnetworks.com>
 <576a4a96-861b-6a86-b059-6621a22d191c@gmail.com>
 <afdfd237-124d-0050-606f-cb5516c9e4d8@cumulusnetworks.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <294b9604-8d43-4a31-9324-6368c584fd63@gmail.com>
Date:   Tue, 29 Oct 2019 16:04:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <afdfd237-124d-0050-606f-cb5516c9e4d8@cumulusnetworks.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/29/19 2:50 PM, Nikolay Aleksandrov wrote:

> Right, I was just giving it as an example. Your suggestion sounds much better and
> wouldn't interfere with other layers, plus we already use skb->hash in bond_xmit_hash()
> and skb_set_owner_w() sets l4_hash if txhash is present which is perfect.
> 
> One thing - how do we deal with sk_rethink_txhash() ? I guess we'll need some way to
> signal that the user specified the txhash and it is not to be recomputed ?
> That can also be used to avoid the connect txhash set as well if SO_TXHASH was set prior
> to the connect. It's quite late here, I'll look into it more tomorrow. :)

I guess that we have something similar with SO_RCVBUF/SO_SNDBUF

autotuning is disabled when/if they are used :

 SOCK_RCVBUF_LOCK & SOCK_SNDBUF_LOCK

We could add a SOCK_TXHASH_LOCK so that sk_rethink_txhash() does nothing if
user forced a TXHASH value.

Something like the following (probably not complete) patch.

diff --git a/include/net/sock.h b/include/net/sock.h
index 380312cc67a9d9ee8720eb2db82b1f7f8a5615ab..a8882738710eaa9d9d629e1207837a798401a594 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1354,6 +1354,7 @@ static inline int __sk_prot_rehash(struct sock *sk)
 #define SOCK_RCVBUF_LOCK       2
 #define SOCK_BINDADDR_LOCK     4
 #define SOCK_BINDPORT_LOCK     8
+#define SOCK_TXHASH_LOCK       16
 
 struct socket_alloc {
        struct socket socket;
@@ -1852,7 +1853,8 @@ static inline u32 net_tx_rndhash(void)
 
 static inline void sk_set_txhash(struct sock *sk)
 {
-       sk->sk_txhash = net_tx_rndhash();
+       if (!(sk->sk_userlocks & SOCK_TXHASH_LOCK))
+               sk->sk_txhash = net_tx_rndhash();
 }
 
 static inline void sk_rethink_txhash(struct sock *sk)
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 77f7c1638eb1ce7d3e143bbffd60056e472b1122..998be6ee7991de3a76d4ad33df3a38dbe791eae8 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -118,6 +118,7 @@
 #define SO_SNDTIMEO_NEW         67
 
 #define SO_DETACH_REUSEPORT_BPF 68
+#define SO_TXHASH              69
 
 #if !defined(__KERNEL__)
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 997b352c2a72ee39f00b102a553ac1191202b74f..85b85dffd462bc3b497e0432100ff24b759832e0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -770,6 +770,10 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
        case SO_BROADCAST:
                sock_valbool_flag(sk, SOCK_BROADCAST, valbool);
                break;
+       case SO_TXHASH:
+               sk->sk_txhash = val;
+               sk->sk_userlocks |= SOCK_TXHASH_LOCK;
+               break;
        case SO_SNDBUF:
                /* Don't error on this BSD doesn't and if you think
                 * about it this is right. Otherwise apps have to
@@ -1249,6 +1253,10 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
                v.val = sock_flag(sk, SOCK_BROADCAST);
                break;
 
+       case SO_TXHASH:
+               v.val = sk->sk_txhash;
+               break;
+
        case SO_SNDBUF:
                v.val = sk->sk_sndbuf;
                break;
