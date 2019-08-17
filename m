Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC7791357
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 23:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfHQVcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 17:32:48 -0400
Received: from www62.your-server.de ([213.133.104.62]:57464 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfHQVcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 17:32:48 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hz6JW-0001mq-Hn; Sat, 17 Aug 2019 23:32:42 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hz6JW-0008JT-CL; Sat, 17 Aug 2019 23:32:42 +0200
Subject: Re: [PATCH bpf-next v4 0/4] bpf: support cloning sk storage on
 accept()
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
References: <20190814173751.31806-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <21c14e84-472b-74ec-eec6-0117d40e54d2@iogearbox.net>
Date:   Sat, 17 Aug 2019 23:32:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190814173751.31806-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25544/Sat Aug 17 10:24:01 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/19 7:37 PM, Stanislav Fomichev wrote:
> Currently there is no way to propagate sk storage from the listener
> socket to a newly accepted one. Consider the following use case:
> 
>          fd = socket();
>          setsockopt(fd, SOL_IP, IP_TOS,...);
>          /* ^^^ setsockopt BPF program triggers here and saves something
>           * into sk storage of the listener.
>           */
>          listen(fd, ...);
>          while (client = accept(fd)) {
>                  /* At this point all association between listener
>                   * socket and newly accepted one is gone. New
>                   * socket will not have any sk storage attached.
>                   */
>          }
> 
> Let's add new BPF_F_CLONE flag that can be specified when creating
> a socket storage map. This new flag indicates that map contents
> should be cloned when the socket is cloned.
> 
> v4:
> * drop 'goto err' in bpf_sk_storage_clone (Yonghong Song)
> * add comment about race with bpf_sk_storage_map_free to the
>    bpf_sk_storage_clone side as well (Daniel Borkmann)
> 
> v3:
> * make sure BPF_F_NO_PREALLOC is always present when creating
>    a map (Martin KaFai Lau)
> * don't call bpf_sk_storage_free explicitly, rely on
>    sk_free_unlock_clone to do the cleanup (Martin KaFai Lau)
> 
> v2:
> * remove spinlocks around selem_link_map/sk (Martin KaFai Lau)
> * BPF_F_CLONE on a map, not selem (Martin KaFai Lau)
> * hold a map while cloning (Martin KaFai Lau)
> * use BTF maps in selftests (Yonghong Song)
> * do proper cleanup selftests; don't call close(-1) (Yonghong Song)
> * export bpf_map_inc_not_zero
> 
> Cc: Martin KaFai Lau <kafai@fb.com>
> Cc: Yonghong Song <yhs@fb.com>
> 
> Stanislav Fomichev (4):
>    bpf: export bpf_map_inc_not_zero
>    bpf: support cloning sk storage on accept()
>    bpf: sync bpf.h to tools/
>    selftests/bpf: add sockopt clone/inheritance test
> 
>   include/linux/bpf.h                           |   2 +
>   include/net/bpf_sk_storage.h                  |  10 +
>   include/uapi/linux/bpf.h                      |   3 +
>   kernel/bpf/syscall.c                          |  16 +-
>   net/core/bpf_sk_storage.c                     | 104 ++++++-
>   net/core/sock.c                               |   9 +-
>   tools/include/uapi/linux/bpf.h                |   3 +
>   tools/testing/selftests/bpf/.gitignore        |   1 +
>   tools/testing/selftests/bpf/Makefile          |   3 +-
>   .../selftests/bpf/progs/sockopt_inherit.c     |  97 +++++++
>   .../selftests/bpf/test_sockopt_inherit.c      | 253 ++++++++++++++++++
>   11 files changed, 491 insertions(+), 10 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/sockopt_inherit.c
>   create mode 100644 tools/testing/selftests/bpf/test_sockopt_inherit.c
> 

Applied, thanks!
