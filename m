Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3AA34F0B3D
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 18:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359409AbiDCQao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 12:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359410AbiDCQal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 12:30:41 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE10E60
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 09:28:44 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id qh7so5359441ejb.11
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 09:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DtUiWz/udmP+qktO1RORhitFU4p9rJPKhCmdA8YtM/4=;
        b=p2Y4hBhSp6psMksL4k8ooVelOnmPjbafLHH0j8dvqO293bsqjCBSnHkiblMLUy+eBm
         ghF0ZWoc8oU28KS/cDmy9rGBScJJ5IqB6N8QYz8mjpUb9cxzTwM9LLpyDChm6KMazb7B
         Q364cbARDr3z90kFqmk0UhBqZW51Sq0bP2aj0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DtUiWz/udmP+qktO1RORhitFU4p9rJPKhCmdA8YtM/4=;
        b=JpCs0U5VLF02Nk6tFnQUv9i/VfNuBoTKIOPG+hJAcQmlw7GUYrS+1yWo61nMEwHS0G
         imy0bscaedCR9+ONGOiCF4EAvUocA3qDt6JyXU5nQv6PG1VoNzleG9Gr6Xd0QeivGsGD
         lBJPq2PQN3ef2Zg1phsyDKL7Y1QlZatcQ4CB76fKPg8t64z0TKspEtlYZjTAU2KRdGah
         abALvmWFfZYtDoWTvuTYgx/GjieOzhXWo5frVA8oDpQRt6d8V6A/yPDq4jWru1j1zQ3a
         YlzgOFdfnyjOxBhIUj51m6M/nz6nn0jRgxb/uAEmp2mi+TJXX+Cn/5W1j0Uqv5Ei3RrD
         jE/g==
X-Gm-Message-State: AOAM531AXVO91YfEuEveSXPOppMzeYxabHBnNC96XnkQ337n7TdpayVA
        6Hu190K6PpcMvft0S7efKa7enWzx1lhRbfEOIMh4Pw==
X-Google-Smtp-Source: ABdhPJwSgOkF9TA5+KrakewnUhwfRl9VZLKb3tJNfkfGixXQ676ITS5hbI7IY23qMj/pwvPnpBhBOnYfHdiAjjxnabw=
X-Received: by 2002:a17:907:160b:b0:6e1:116e:7a59 with SMTP id
 hb11-20020a170907160b00b006e1116e7a59mr7432985ejc.579.1649003323297; Sun, 03
 Apr 2022 09:28:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220329133001.2283509-1-maximmi@nvidia.com>
In-Reply-To: <20220329133001.2283509-1-maximmi@nvidia.com>
From:   Arthur Fabre <afabre@cloudflare.com>
Date:   Sun, 3 Apr 2022 16:28:32 +0000
Message-ID: <CAOn4ftuxiQZh9RkBsPwUeyt+QdDafrhu_APxgETp7yzSzoukZg@mail.gmail.com>
Subject: Re: [PATCH bpf v4] bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 1:30 PM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> bpf_tcp_gen_syncookie looks at the IP version in the IP header and
> validates the address family of the socket. It supports IPv4 packets in
> AF_INET6 dual-stack sockets.
>
> On the other hand, bpf_tcp_check_syncookie looks only at the address
> family of the socket, ignoring the real IP version in headers, and
> validates only the packet size. This implementation has some drawbacks:
>
> 1. Packets are not validated properly, allowing a BPF program to trick
>    bpf_tcp_check_syncookie into handling an IPv6 packet on an IPv4
>    socket.
>
> 2. Dual-stack sockets fail the checks on IPv4 packets. IPv4 clients end
>    up receiving a SYNACK with the cookie, but the following ACK gets
>    dropped.
>
> This patch fixes these issues by changing the checks in
> bpf_tcp_check_syncookie to match the ones in bpf_tcp_gen_syncookie. IP
> version from the header is taken into account, and it is validated
> properly with address family.
>
> Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  net/core/filter.c                             | 17 +++-
>  .../bpf/test_tcp_check_syncookie_user.c       | 78 ++++++++++++++-----
>  2 files changed, 72 insertions(+), 23 deletions(-)
>
> v2 changes: moved from bpf-next to bpf.
>
> v3 changes: added a selftest.
>
> v4 changes: none, CCed Jakub and Arthur from Cloudflare.
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index a7044e98765e..64470a727ef7 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7016,24 +7016,33 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
>         if (!th->ack || th->rst || th->syn)
>                 return -ENOENT;
>
> +       if (unlikely(iph_len < sizeof(struct iphdr)))
> +               return -EINVAL;
> +
>         if (tcp_synq_no_recent_overflow(sk))
>                 return -ENOENT;
>
>         cookie = ntohl(th->ack_seq) - 1;
>
> -       switch (sk->sk_family) {
> -       case AF_INET:
> -               if (unlikely(iph_len < sizeof(struct iphdr)))
> +       /* Both struct iphdr and struct ipv6hdr have the version field at the
> +        * same offset so we can cast to the shorter header (struct iphdr).
> +        */
> +       switch (((struct iphdr *)iph)->version) {
> +       case 4:
> +               if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
>                         return -EINVAL;
>
>                 ret = __cookie_v4_check((struct iphdr *)iph, th, cookie);
>                 break;
>
>  #if IS_BUILTIN(CONFIG_IPV6)
> -       case AF_INET6:
> +       case 6:
>                 if (unlikely(iph_len < sizeof(struct ipv6hdr)))
>                         return -EINVAL;
>
> +               if (sk->sk_family != AF_INET6)
> +                       return -EINVAL;
> +
>                 ret = __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
>                 break;
>  #endif /* CONFIG_IPV6 */
> diff --git a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
> index b9e991d43155..e7775d3bbe08 100644
> --- a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
> +++ b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
> @@ -18,8 +18,9 @@
>  #include "bpf_rlimit.h"
>  #include "cgroup_helpers.h"
>
> -static int start_server(const struct sockaddr *addr, socklen_t len)
> +static int start_server(const struct sockaddr *addr, socklen_t len, bool dual)
>  {
> +       int mode = !dual;
>         int fd;
>
>         fd = socket(addr->sa_family, SOCK_STREAM, 0);
> @@ -28,6 +29,14 @@ static int start_server(const struct sockaddr *addr, socklen_t len)
>                 goto out;
>         }
>
> +       if (addr->sa_family == AF_INET6) {
> +               if (setsockopt(fd, IPPROTO_IPV6, IPV6_V6ONLY, (char *)&mode,
> +                              sizeof(mode)) == -1) {
> +                       log_err("Failed to set the dual-stack mode");
> +                       goto close_out;
> +               }
> +       }
> +
>         if (bind(fd, addr, len) == -1) {
>                 log_err("Failed to bind server socket");
>                 goto close_out;
> @@ -47,24 +56,17 @@ static int start_server(const struct sockaddr *addr, socklen_t len)
>         return fd;
>  }
>
> -static int connect_to_server(int server_fd)
> +static int connect_to_server(const struct sockaddr *addr, socklen_t len)
>  {
> -       struct sockaddr_storage addr;
> -       socklen_t len = sizeof(addr);
>         int fd = -1;
>
> -       if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
> -               log_err("Failed to get server addr");
> -               goto out;
> -       }
> -
> -       fd = socket(addr.ss_family, SOCK_STREAM, 0);
> +       fd = socket(addr->sa_family, SOCK_STREAM, 0);
>         if (fd == -1) {
>                 log_err("Failed to create client socket");
>                 goto out;
>         }
>
> -       if (connect(fd, (const struct sockaddr *)&addr, len) == -1) {
> +       if (connect(fd, (const struct sockaddr *)addr, len) == -1) {
>                 log_err("Fail to connect to server");
>                 goto close_out;
>         }
> @@ -116,7 +118,8 @@ static int get_map_fd_by_prog_id(int prog_id, bool *xdp)
>         return map_fd;
>  }
>
> -static int run_test(int server_fd, int results_fd, bool xdp)
> +static int run_test(int server_fd, int results_fd, bool xdp,
> +                   const struct sockaddr *addr, socklen_t len)
>  {
>         int client = -1, srv_client = -1;
>         int ret = 0;
> @@ -142,7 +145,7 @@ static int run_test(int server_fd, int results_fd, bool xdp)
>                 goto err;
>         }
>
> -       client = connect_to_server(server_fd);
> +       client = connect_to_server(addr, len);
>         if (client == -1)
>                 goto err;
>
> @@ -199,12 +202,30 @@ static int run_test(int server_fd, int results_fd, bool xdp)
>         return ret;
>  }
>
> +static bool get_port(int server_fd, in_port_t *port)
> +{
> +       struct sockaddr_in addr;
> +       socklen_t len = sizeof(addr);
> +
> +       if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
> +               log_err("Failed to get server addr");
> +               return false;
> +       }
> +
> +       /* sin_port and sin6_port are located at the same offset. */
> +       *port = addr.sin_port;
> +       return true;
> +}
> +
>  int main(int argc, char **argv)
>  {
>         struct sockaddr_in addr4;
>         struct sockaddr_in6 addr6;
> +       struct sockaddr_in addr4dual;
> +       struct sockaddr_in6 addr6dual;
>         int server = -1;
>         int server_v6 = -1;
> +       int server_dual = -1;
>         int results = -1;
>         int err = 0;
>         bool xdp;
> @@ -224,25 +245,43 @@ int main(int argc, char **argv)
>         addr4.sin_family = AF_INET;
>         addr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
>         addr4.sin_port = 0;
> +       memcpy(&addr4dual, &addr4, sizeof(addr4dual));
>
>         memset(&addr6, 0, sizeof(addr6));
>         addr6.sin6_family = AF_INET6;
>         addr6.sin6_addr = in6addr_loopback;
>         addr6.sin6_port = 0;
>
> -       server = start_server((const struct sockaddr *)&addr4, sizeof(addr4));
> -       if (server == -1)
> +       memset(&addr6dual, 0, sizeof(addr6dual));
> +       addr6dual.sin6_family = AF_INET6;
> +       addr6dual.sin6_addr = in6addr_any;
> +       addr6dual.sin6_port = 0;
> +
> +       server = start_server((const struct sockaddr *)&addr4, sizeof(addr4),
> +                             false);
> +       if (server == -1 || !get_port(server, &addr4.sin_port))
>                 goto err;
>
>         server_v6 = start_server((const struct sockaddr *)&addr6,
> -                                sizeof(addr6));
> -       if (server_v6 == -1)
> +                                sizeof(addr6), false);
> +       if (server_v6 == -1 || !get_port(server_v6, &addr6.sin6_port))
> +               goto err;
> +
> +       server_dual = start_server((const struct sockaddr *)&addr6dual,
> +                                  sizeof(addr6dual), true);
> +       if (server_dual == -1 || !get_port(server_dual, &addr4dual.sin_port))
> +               goto err;
> +
> +       if (run_test(server, results, xdp,
> +                    (const struct sockaddr *)&addr4, sizeof(addr4)))
>                 goto err;
>
> -       if (run_test(server, results, xdp))
> +       if (run_test(server_v6, results, xdp,
> +                    (const struct sockaddr *)&addr6, sizeof(addr6)))
>                 goto err;
>
> -       if (run_test(server_v6, results, xdp))
> +       if (run_test(server_dual, results, xdp,
> +                    (const struct sockaddr *)&addr4dual, sizeof(addr4dual)))
>                 goto err;
>
>         printf("ok\n");
> @@ -252,6 +291,7 @@ int main(int argc, char **argv)
>  out:
>         close(server);
>         close(server_v6);
> +       close(server_dual);
>         close(results);
>         return err;
>  }
> --
> 2.30.2

Thanks for the fix and the test! Looks sane to me, and it passes the
tests we have internally (but we only test IPv4 :/).

Acked-by: Arthur Fabre <afabre@cloudflare.com>
