Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC68626840
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 10:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbiKLJBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 04:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKLJBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 04:01:43 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8345121E2F
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 01:01:42 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id k22so6827070pfd.3
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 01:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7y4pLrCcKIbTWqcEoSFz8FLdpOrHyw+X6OKtFEL3+7g=;
        b=EEayl8Cl5+bs7LJvxvV1PimSyGAaGZL8NK0773r/rb3nqRgf5eeMWQnSIEfKr4K+Dm
         QC0vsC9oX98xPsuyCP8e1UC/uktFx1qfdo2KJJqiPG8F8e+vqfn5Ier1DFtgbYHuM/Wf
         1GqCSJzPkYiBX4u4N/cGR5F1Tz4ILUwywYHEvhSwwzs7dv3v4cfyN6/L6w8/hiHaGZa6
         yrAEj6jVyy4hmnx0uFv7iZDrOo+tz+A0hf5fTcuYkJ+pWCPkVIZVgHxRTGLqrLpNuDA1
         fns6C8Ej5b9ALZd07IYSWPqgkMTLvQ9h/v5zNKKrronRjFrz8Bc4iPRSt/RKvVNIm1Ju
         mJdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7y4pLrCcKIbTWqcEoSFz8FLdpOrHyw+X6OKtFEL3+7g=;
        b=S7K9vzbIhfcOZ4eG31u7K69lneVTT2ZZXfeJdduwdC2BtgeHnN9xjDAHbi3o53W6f3
         pInSWSqnMNWZT+cj4JNk6vy6dOQkadCAFpBbE7WhAR806szAY5qaPBZQx64FZ33+GHXZ
         fUO/nVU1HvgDt6YV+MQk7eizFOEtV6lQ572XaSg66SpRppVqne4D0VOp3q/JSo67szCE
         ivtT9XwVchf1HL8aBqlxhh/OO7mUhesxPN8jUMYnuM3dSZ8UJMQ30YnL3Xr27CnNh1do
         7lIR2BxT1AMBZdREnU9NLbc+uF4DzYbFG/HSmQCk5/ELA2+4m9pLSiHV+/D3TP2J5Jko
         EwCQ==
X-Gm-Message-State: ANoB5plIpvGhFwlpLaaXFD8gI38SvYrwnl902CZgxtMMeMOVdTZkbirH
        j8FIrPYpWdHS2jsO+iaFeM4pZpQClhZnu/4tEJZijtgTwIY=
X-Google-Smtp-Source: AA0mqf5YKerjFeUS0Pb8AWFbY9Oi8k3ZLwXBJypjgl8zE8di0ZYXzQyew27m/w2FRpleG/4MuKVvNal5XRl1ZalGO0Q=
X-Received: by 2002:a63:181e:0:b0:470:f0c:96da with SMTP id
 y30-20020a63181e000000b004700f0c96damr4572016pgl.544.1668243701791; Sat, 12
 Nov 2022 01:01:41 -0800 (PST)
MIME-Version: 1.0
From:   mingkun bian <bianmingkun@gmail.com>
Date:   Sat, 12 Nov 2022 17:01:30 +0800
Message-ID: <CAL87dS2SS9rjLUPnwufh9a0O-Cu-hMAUU7Xa534mXTB9v=KM5g@mail.gmail.com>
Subject: [ISSUE] suspicious sock leak
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
    I found a problem that a sock whose state is ESTABLISHED is not
freed to slab cache by __sock_free.
    The test scenario is as follows=EF=BC=9A

    1. A HTTP Server=EF=BC=8CI insert a node to ebpf
map(BPF_MAP_TYPE_LRU_HASH) by BPF_MAP_UPDATE_ELEM when receiving a
"HTTP GET" request in user application.
    ebpf map is=EF=BC=9A
    key: cookie(getsockopt(fd, SOL_SOCKET, SO_COOKIE, &cookie, &optlen))
    value: saddr sport daddr dport cookie...

    2. I delete the corresponding ebpf map node by "kprobe __sk_free"
in ebpf as following, bpf_map_delete_elem keeps returning 0.

    SEC("kprobe/__sk_free")
    int bpf_prog_destroy_sock(struct pt_regs *ctx)
    {
        struct sock *sk;
        __u64 cookie;
       struct  tcp_infos *value;

       sk =3D (struct sock *) PT_REGS_PARM1(ctx);
       bpf_probe_read(&cookie, sizeof(sk->__sk_common.skc_cookie),
&sk->__sk_common.skc_cookie);
       value =3D bpf_map_lookup_elem(&bpfmap, &cookie);
       if (value) {
           if (bpf_map_delete_elem(&bpfmap, &cookie) !=3D 0) {
               debugmsg("delete failed\n");
           }
       }
    }

   3. Sending pressure "HTTP GET" requests to HTTP Server for a while,
 then stop to send and close the HTTP Server, then wait a long time,
we can not see any tcpinfo by "netstat -anp", then error occurs=EF=BC=9A
    We can see some node which is not deleted int ebpf map by "bpftool
map dump id **"=EF=BC=8C it seems like "sock leak", but the sockstat's
inuse(cat /proc/net/sockstat) does not increase quickly.

4. I did some more experiments by ebpf kprobe, I find that a
sock(state is ESTABLISHED, HTTP server recv a "HTTP GET" requset) does
not come in __sock_free, but the same sock will be reused by another
tcp connection(the most frequent is "127.0.0.1") after a while.
   What I doubt is that why a new tcp connection can resue a old sock
while the old sock does not come in __sk_free.

Thanks.
