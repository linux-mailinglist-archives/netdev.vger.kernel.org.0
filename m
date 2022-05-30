Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414EA538645
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 18:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241380AbiE3Qmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 12:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238296AbiE3Qmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 12:42:44 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCC937BE1
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 09:42:43 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id c2so4737001edf.5
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 09:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=ZzUJSpqcxysJA0FMqtBD/l2cdeNEuDGl5om00DPjVGs=;
        b=WU1GrImStgdlVJmF7nbji+wbR3acdngO6M7rrLgUsddm67wrsaSka30vl2s2m9sgzR
         zfOubprAw+UcjEDMcR+2t70m7ZQUWZ5hBOb6MyYhNDcSgbzRKxIiw3uu53/orn6bboz8
         bX0sIcldVjjf/nct1ibe40E5EGTB+qxIsZa4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=ZzUJSpqcxysJA0FMqtBD/l2cdeNEuDGl5om00DPjVGs=;
        b=AlkjOaH4AszvCGR6nfd6ffMnseV10c68vmCd8YNnKu9ctZ0WIrFmK/4PdUQb3C+Wob
         ug0wEQ2SdDo51q0SU9gyc0FM5/vygg0vSYxrfh/Oje5lEkCavwsEfevtD7rDRl7gvB/G
         LSR0E/3TmAH32hrJkcU0fp75L8wiZexcDUt2Z8334jIdkwOpXFv5orchvd93boYf7X/K
         K92GIRDHEdayhahn/UJhvVqL6D/eMoedtFmCWKJ9rs3YUcZgEZItomXk7nY/DLe0ofLw
         5E/BTrmeYpsMlgQnYQ2tbI6SYud/T4FZpFwNkiFAUno06WtEDmmPj/ogupq8HUehhMGm
         KlAw==
X-Gm-Message-State: AOAM530tErytRDPj2JTLm8bwNfdh0njZ/Derr/+XtvfhnqT3wLPLYdW9
        oR0G5/Ajw5UR1YFoHRp36ywxgQ==
X-Google-Smtp-Source: ABdhPJzWoQbFxd5DRXeZJxWa/+gowf0V5kInJ/pSde+54jpxRkNa4ba544r/TFKCUgGi1m9ctLVi2w==
X-Received: by 2002:aa7:d806:0:b0:42d:deb4:9bb3 with SMTP id v6-20020aa7d806000000b0042ddeb49bb3mr420170edq.83.1653928961964;
        Mon, 30 May 2022 09:42:41 -0700 (PDT)
Received: from cloudflare.com (79.191.58.36.ipv4.supernova.orange.pl. [79.191.58.36])
        by smtp.gmail.com with ESMTPSA id i23-20020a508717000000b0042dc6336684sm3756869edb.73.2022.05.30.09.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 09:42:41 -0700 (PDT)
References: <20220524075311.649153-1-wangyufen@huawei.com>
 <YpFEmCp+fm1nC23U@pop-os.localdomain>
 <3d11ae70-8c2d-b021-b173-b000dce588e0@huawei.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        wangyufen <wangyufen@huawei.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        daniel@iogearbox.net, lmb@cloudflare.com, davem@davemloft.net,
        kafai@fb.com, dsahern@kernel.org, kuba@kernel.org,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] bpf,sockmap: fix sk->sk_forward_alloc warn_on
 in sk_stream_kill_queues
Date:   Mon, 30 May 2022 18:37:16 +0200
In-reply-to: <3d11ae70-8c2d-b021-b173-b000dce588e0@huawei.com>
Message-ID: <878rqjm0ov.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 28, 2022 at 09:54 AM +08, wangyufen wrote:
> =E5=9C=A8 2022/5/28 5:37, Cong Wang =E5=86=99=E9=81=93:
>> On Tue, May 24, 2022 at 03:53:11PM +0800, Wang Yufen wrote:
>>> During TCP sockmap redirect pressure test, the following warning is tri=
ggered:
>>> WARNING: CPU: 3 PID: 2145 at net/core/stream.c:205 sk_stream_kill_queue=
s+0xbc/0xd0
>>> CPU: 3 PID: 2145 Comm: iperf Kdump: loaded Tainted: G        W         =
5.10.0+ #9
>>> Call Trace:
>>>   inet_csk_destroy_sock+0x55/0x110
>>>   inet_csk_listen_stop+0xbb/0x380
>>>   tcp_close+0x41b/0x480
>>>   inet_release+0x42/0x80
>>>   __sock_release+0x3d/0xa0
>>>   sock_close+0x11/0x20
>>>   __fput+0x9d/0x240
>>>   task_work_run+0x62/0x90
>>>   exit_to_user_mode_prepare+0x110/0x120
>>>   syscall_exit_to_user_mode+0x27/0x190
>>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>
>>> The reason we observed is that:
>>> When the listener is closing, a connection may have completed the three=
-way
>>> handshake but not accepted, and the client has sent some packets. The c=
hild
>>> sks in accept queue release by inet_child_forget()->inet_csk_destroy_so=
ck(),
>>> but psocks of child sks have not released.
>>>
>> Hm, in this scenario, how does the child socket end up in the sockmap?
>> Clearly user-space does not have a chance to get an fd yet.
>>
>> And, how does your patch work? Since the child sock does not even inheirt
>> the sock proto after clone (see the comments above tcp_bpf_clone()) at
>> all?
>>
>> Thanks.
>> .
> My test cases are as follows:
>
> __section("sockops")
> int bpf_sockmap(struct bpf_sock_ops *skops)
> {
> =C2=A0=C2=A0=C2=A0 switch (skops->op) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case BPF_SOCK_OPS_PASSIVE_ESTA=
BLISHED_CB:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case BPF_SOCK_OPS_ACTIVE_ESTAB=
LISHED_CB:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bpf_so=
ck_hash_update(skops, &sock_ops_map, &key, BPF_NOEXIST);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> }

Right, when processing the final ACK in tcp_rcv_state_process(), we
invoke the BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB BPF callback.

This gives a chance to install sockmap sk_prot callbacks.

An accept() without ever calling accept() ;-)

[...]
