Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A31867F0DA
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 23:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbjA0WEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 17:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbjA0WET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 17:04:19 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928697AE44
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 14:04:16 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id b1so7624000ybn.11
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 14:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5ohR+0rZmCaLAS7ieSQMPFcMY0YXXufvyIxmbzUJjpY=;
        b=QsatLhaFnWSXhPmdRslUYg6oNm7HsNFs6MeWjyLitafGucJCB84BxrprRLjnBSgA08
         9Vx/7QVTiCgz05zEtILq63eX5YLEhToFKOwhCj9fUqZ20YeK1sUe/tUZ/DIkMFmgbIj+
         mEaXlsCv5ZsMtg7XwB7Ri7a3n5ODRM/+bjA4Sr9BwI1IpDzkM2eeCxIXjipG41EmDC57
         +qDvnMtE3WCC5hiFdyuSucCOtSy2veG4b3ZWcTYJ+zATEhGtANBzW15Q3Crajm534M36
         OqIjXAEojFjJvUDEx9e31HsTOaiiMjbD3VB1lsQHFLPkrYf4XqhZlYHOio4e3IDU5jEa
         Z85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5ohR+0rZmCaLAS7ieSQMPFcMY0YXXufvyIxmbzUJjpY=;
        b=w06Dfcfh0HSyOfTqjCubRJxL0sqhapE6nSgACtp+pmbIMA2d8RINIBVuIbvHHGJoq8
         G4MzESD1488BbBYXWLwnlQtzAoke2HpWUBdJwlFESCBCV7o3M/TMPDFqJnZEYCwCgwzW
         +5pBC6XFWskz23ZXjsH7pXoaDHEdnJ90dAOnSfXOo69W67KCryucE/SNGzSvdOPjBsBq
         56XFZ8Zz1yrIiaUPz8wXPSekWLV5kZb1JGXOf+K4A2v8NPnK7ng1BNmrHEyfLKXdOmVq
         4uHDP8qGj2P44OFp95m5WxVgqG2nmXcqM+/Dm049vvlSRBkdHGLDASWU7Sw40eja21YN
         74Nw==
X-Gm-Message-State: AFqh2krEmpC/2mWxdoL3gxj+EjhyiomrCGl2TsdvXC+F1CyQzyT6UoEo
        fa7G/yRj7kugjq82JDnIWkzCVya7rKthCX3fymDRWW++9jz9e10u
X-Google-Smtp-Source: AMrXdXvOK9+ujMEgBOAsX5NGN3GRpCK9UUEcoO25Huvd8luJUDO/qifWrBXYWnRUCH8A9y4wQ+xTMmoZNBOmn+KobLM=
X-Received: by 2002:a25:750b:0:b0:7d0:f8e3:6d80 with SMTP id
 q11-20020a25750b000000b007d0f8e36d80mr3376773ybc.363.1674857055672; Fri, 27
 Jan 2023 14:04:15 -0800 (PST)
MIME-Version: 1.0
References: <20230127181625.286546-1-andrei.gherzan@canonical.com>
In-Reply-To: <20230127181625.286546-1-andrei.gherzan@canonical.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Fri, 27 Jan 2023 17:03:39 -0500
Message-ID: <CA+FuTSewU6bjYLsyLzZ1Yne=6YBPDJZ=U1mZc+6cJVdr06BhiQ@mail.gmail.com>
Subject: Re: [PATCH] selftests: net: udpgso_bench_tx: Introduce exponential
 back-off retries
To:     Andrei Gherzan <andrei.gherzan@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 1:16 PM Andrei Gherzan
<andrei.gherzan@canonical.com> wrote:
>
> The tx and rx test programs are used in a couple of test scripts including
> "udpgro_bench.sh". Taking this as an example, when the rx/tx programs
> are invoked subsequently, there is a chance that the rx one is not ready to
> accept socket connections. This racing bug could fail the test with at
> least one of the following:
>
> ./udpgso_bench_tx: connect: Connection refused
> ./udpgso_bench_tx: sendmsg: Connection refused
> ./udpgso_bench_tx: write: Connection refused
>
> This change addresses this by adding routines that retry the socket
> operations with an exponential back off algorithm from 100ms to 2s.
>
> Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>

Synchronizing the two processes is indeed tricky.

Perhaps more robust is opening an initial TCP connection, with
SO_RCVTIMEO to bound the waiting time. That covers all tests in one
go.

> ---
>  tools/testing/selftests/net/udpgso_bench_tx.c | 57 +++++++++++++------
>  1 file changed, 41 insertions(+), 16 deletions(-)
>
> diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
> index f1fdaa270291..4dea9ee7eb46 100644
> --- a/tools/testing/selftests/net/udpgso_bench_tx.c
> +++ b/tools/testing/selftests/net/udpgso_bench_tx.c
> @@ -53,6 +53,9 @@
>
>  #define NUM_PKT                100
>
> +#define MAX_DELAY      2000000
> +#define INIT_DELAY     100000
> +
>  static bool    cfg_cache_trash;
>  static int     cfg_cpu         = -1;
>  static int     cfg_connected   = true;
> @@ -257,13 +260,18 @@ static void flush_errqueue(int fd, const bool do_poll)
>  static int send_tcp(int fd, char *data)
>  {
>         int ret, done = 0, count = 0;
> +       useconds_t delay = INIT_DELAY;
>
>         while (done < cfg_payload_len) {
> -               ret = send(fd, data + done, cfg_payload_len - done,
> -                          cfg_zerocopy ? MSG_ZEROCOPY : 0);
> -               if (ret == -1)
> -                       error(1, errno, "write");
> -
> +               delay = INIT_DELAY;
> +               while ((ret = send(fd, data + done, cfg_payload_len - done,
> +                               cfg_zerocopy ? MSG_ZEROCOPY : 0)) == -1) {
> +                       usleep(delay);
> +                       if (delay < MAX_DELAY)
> +                               delay *= 2;
> +                       else
> +                               error(1, errno, "write");
> +               }
>                 done += ret;
>                 count++;
>         }

send_tcp should not be affected, as connect will by then already have
succeeded. Also, as a reliable protocol it will internally retry,
after returning with success.

> @@ -274,17 +282,23 @@ static int send_tcp(int fd, char *data)
>  static int send_udp(int fd, char *data)
>  {
>         int ret, total_len, len, count = 0;
> +       useconds_t delay = INIT_DELAY;
>
>         total_len = cfg_payload_len;
>
>         while (total_len) {
>                 len = total_len < cfg_mss ? total_len : cfg_mss;
>
> -               ret = sendto(fd, data, len, cfg_zerocopy ? MSG_ZEROCOPY : 0,
> -                            cfg_connected ? NULL : (void *)&cfg_dst_addr,
> -                            cfg_connected ? 0 : cfg_alen);
> -               if (ret == -1)
> -                       error(1, errno, "write");
> +               delay = INIT_DELAY;
> +               while ((ret = sendto(fd, data, len, cfg_zerocopy ? MSG_ZEROCOPY : 0,
> +                               cfg_connected ? NULL : (void *)&cfg_dst_addr,
> +                               cfg_connected ? 0 : cfg_alen)) == -1) {

should ideally only retry on the expected errno. Unreliable datagram
sendto will succeed and initially. It will fail with error later,
after reception of an ICMP dst unreachable response.

> +                       usleep(delay);
> +                       if (delay < MAX_DELAY)
> +                               delay *= 2;
> +                       else
> +                               error(1, errno, "write");
> +               }
>                 if (ret != len)
>                         error(1, errno, "write: %uB != %uB\n", ret, len);
>
> @@ -378,6 +392,7 @@ static int send_udp_segment(int fd, char *data)
>         struct iovec iov = {0};
>         size_t msg_controllen;
>         struct cmsghdr *cmsg;
> +       useconds_t delay = INIT_DELAY;
>         int ret;
>
>         iov.iov_base = data;
> @@ -401,9 +416,13 @@ static int send_udp_segment(int fd, char *data)
>         msg.msg_name = (void *)&cfg_dst_addr;
>         msg.msg_namelen = cfg_alen;
>
> -       ret = sendmsg(fd, &msg, cfg_zerocopy ? MSG_ZEROCOPY : 0);
> -       if (ret == -1)
> -               error(1, errno, "sendmsg");
> +       while ((ret = sendmsg(fd, &msg, cfg_zerocopy ? MSG_ZEROCOPY : 0)) == -1) {
> +               usleep(delay);
> +               if (delay < MAX_DELAY)
> +                       delay *= 2;
> +               else
> +                       error(1, errno, "sendmsg");
> +       }
>         if (ret != iov.iov_len)
>                 error(1, 0, "sendmsg: %u != %llu\n", ret,
>                         (unsigned long long)iov.iov_len);
> @@ -616,6 +635,7 @@ int main(int argc, char **argv)
>  {
>         unsigned long num_msgs, num_sends;
>         unsigned long tnow, treport, tstop;
> +       useconds_t delay = INIT_DELAY;
>         int fd, i, val, ret;
>
>         parse_opts(argc, argv);
> @@ -648,9 +668,14 @@ int main(int argc, char **argv)
>                 }
>         }
>
> -       if (cfg_connected &&
> -           connect(fd, (void *)&cfg_dst_addr, cfg_alen))
> -               error(1, errno, "connect");
> +       if (cfg_connected)
> +               while (connect(fd, (void *)&cfg_dst_addr, cfg_alen)) {
> +                       usleep(delay);
> +                       if (delay < MAX_DELAY)
> +                               delay *= 2;
> +                       else
> +                               error(1, errno, "connect");
> +               }
>
>         if (cfg_segment)
>                 set_pmtu_discover(fd, cfg_family == PF_INET);
> --
> 2.34.1
>
