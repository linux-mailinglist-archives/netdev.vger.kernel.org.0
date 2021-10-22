Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD2C437122
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 07:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhJVFSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 01:18:09 -0400
Received: from sender11-of-o51.zoho.eu ([31.186.226.237]:21155 "EHLO
        sender11-of-o51.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhJVFSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 01:18:06 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1634879728; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=SOqQFsoInBLCAqMgkT1CRHnU1kP0mFJ7Nftv5X22dS4MMS6v/DLTEEz2gEvPtoTC6TLjYYBDwRWGfA/lfPFczAKHkLdB20wR+jdp2LoRsgHfTf7kfjOOQml+wCzrjArfKihneouThUO/8CsOYoxuDr4Gvs9nS3SCanncAWprnQQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1634879728; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=rWjzXhTDsdsfrOukOYlP1JvzxPVzK3mbCkYG8xgK8jk=; 
        b=Ds7H05Q1cj3domzLWssc6pKASp1aeOziZ3HeR1nrwLDzCdVebbgNXdIVVuWGJlogsyLGqk4/hj3ttmdSu5Cqf12KbbBCIzrsk8br4AtcfyDCbWsdagDD7hIvJnIMx+8MDEkHTSoZmA0WKNzVC8UuwN1XRrQjAyYATydu9qfMxOk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1634879728;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Cc:Message-ID:In-Reply-To:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=rWjzXhTDsdsfrOukOYlP1JvzxPVzK3mbCkYG8xgK8jk=;
        b=Qgq/UwynQWI/3GiiZwpEqd5i1+FlqTL5GgadidUtIgcdOb9UsRrCOqqwq1Ltbunk
        vsBOTei/ePuIQG6lBMG7dejHWKOnpfZBQqCXJLZXKbeA+CfYafj2kS0OW3Q/cpTtfYo
        zzcqFCC6lbnHRIjKRn7W92yx1jsW2JX5Ih9wL5bg=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1634879722555685.0241726852904; Fri, 22 Oct 2021 07:15:22 +0200 (CEST)
Date:   Fri, 22 Oct 2021 07:15:22 +0200
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "mathewjmartineau" <mathew.j.martineau@linux.intel.com>,
        "" matthieubaerts " <" <matthieu.baerts@tessares.net>
Cc:     "Davem" <davem@davemloft.net>, "Kuba" <kuba@kernel.org>,
        "mptcp" <mptcp@lists.linux.dev>, "netdev" <netdev@vger.kernel.org>
Message-ID: <17ca66cd439.10a0a3ce11621928.1543611905599720914@shytyi.net>
In-Reply-To: 
Subject: [PATCH net-next v1] net: mptcp, Fast Open Mechanism
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set of patches will bring "Fast Open" Option support to MPTCP.
The aim of Fast Open Mechanism is to eliminate one round trip 
time from a TCP conversation by allowing data to be included as 
part of the SYN segment that initiates the connection. 

IETF RFC 8684: Appendix B.  TCP Fast Open and MPTCP.

[PATCH v1] includes "client" partial support for :
1. send request for cookie;
2. send syn+data+cookie.

Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
---
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index cd6b11c9b54d..1f9ef060e980 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1686,6 +1686,68 @@ static void mptcp_set_nospace(struct sock *sk)
        set_bit(MPTCP_NOSPACE, &mptcp_sk(sk)->flags);
 }

+static int mptcp_sendmsg_fastopen_cookie_req(struct sock *sk, struct msghdr *msg,
+                                            size_t *copied, size_t size,
+                                            struct ubuf_info *uarg)
+{
+       struct mptcp_sock *msk = mptcp_sk(sk);
+       struct socket *ssk = __mptcp_nmpc_socket(msk);
+       struct tcp_sock *tp = tcp_sk(ssk->sk);
+       struct sockaddr *uaddr = msg->msg_name;
+       struct tcp_fastopen_context *ctx;
+       const struct iphdr *iph;
+       struct sk_buff *skb;
+       int err;
+
+       skb = sk_stream_alloc_skb(ssk->sk, 0, ssk->sk->sk_allocation, true);
+       iph = ip_hdr(skb);
+       tcp_fastopen_init_key_once(sock_net(ssk->sk));
+       ctx = tcp_fastopen_get_ctx(ssk->sk);
+       tp->fastopen_req = kzalloc(sizeof(*tp->fatopen_req),
+                                  ssk->sk->sk_allocation);
+       tp->fastopen_req->data = msg;
+       tp->fastopen_req->size = size;
+       tp->fastopen_req->uarg = uarg;
+       err = mptcp_stream_connect(sk->sk_socket, uaddr, msg->msg_namelen, msg->msg_flags);
+       return err;
+}
+
+static int mptcp_sendmsg_fastopen_cookie_send(struct sock *sk, struct msghdr *msg,
+                                             size_t *copied, size_t size,
+                                             struct ubuf_info *uarg)
+{
+       struct tcp_fastopen_cookie *fastopen_cookie = kmalloc(sizeof(*fastopen_cookie),
+                                                             GFP_KERNEL);
+       struct mptcp_sock *msk = mptcp_sk(sk);
+       struct socket *ssk = __mptcp_nmpc_socket(msk);
+       struct tcp_sock *tp = tcp_sk(ssk->sk);
+       struct sockaddr *uaddr = msg->msg_name;
+       struct tcp_fastopen_context *ctx;
+       const struct iphdr *iph;
+       struct sk_buff *skb;
+       int err;
+
+       skb = sk_stream_alloc_skb(ssk->sk, 0, ssk->sk->sk_allocation, true);
+       iph = ip_hdr(skb);
+       tcp_fastopen_init_key_once(sock_net(ssk->sk));
+       ctx = tcp_fastopen_get_ctx(ssk->sk);
+
+       fastopen_cookie->val[0] = cpu_to_le64(siphash(&iph->saddr,
+                                             sizeof(iph->saddr) +
+                                             sizeof(iph->daddr),
+                                             &ctx->key[0]));
+       fastopen_cookie->len = TCP_FASTOPEN_COOKIE_SIZE;
+
+       tp->fastopen_req = kzalloc(sizeof(*tp->fastopen_req),
+                                  ssk->sk->sk_allocation);
+       tp->fastopen_req->data = msg;
+       tp->fastopen_req->size = size;
+       tp->fastopen_req->uarg = uarg;
+       memcpy(&tp->fastopen_req->cookie, fastopen_cookie, sizeof(tp->fastopen_req->cookie));
+       err = mptcp_stream_connect(sk->sk_socket, uaddr, msg->msg_namelen, msg->msg_flags);
+       return err;
+}
+
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
        struct mptcp_sock *msk = mptcp_sk(sk);
@@ -1694,9 +1756,22 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
        int ret = 0;
        long timeo;

-       /* we don't support FASTOPEN yet */
-       if (msg->msg_flags & MSG_FASTOPEN)
-               return -EOPNOTSUPP;
+       /* we don't fully support FASTOPEN yet */
+
+       if (msg->msg_flags & MSG_FASTOPEN) {
+               struct socket *ssk = __mptcp_nmpc_socket(msk);
+               struct tcp_sock *tp = tcp_sk(ssk->sk);
+
+               if (tp && tp->fastopen_req && tp->fastopen_req->cookie.len != 0) {
+                       // send cookie
+                       ret = mptcp_sendmsg_fastopen_cookie_send(sk, msg, &copied, len, uarg);
+               } else {
+                       struct tcp_fastopen_request *fastopen = tp->fastopen_req;
+                       //requests a cookie
+                       ret = mptcp_sendmsg_fastopen_cookie_req(sk, msg, &copied, len, uarg);
+               }
+       return ret;
+       }

        /* silently ignore everything else */
        msg->msg_flags &= MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL;

