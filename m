Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CB53EF0FA
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhHQRhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:37:04 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:52364
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229716AbhHQRhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 13:37:03 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 8FB333F0A5;
        Tue, 17 Aug 2021 17:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629221788;
        bh=5/x8mWEjAurOJGYA4srik4fEE501O3SjgyLXubuBBxI=;
        h=To:From:Cc:Subject:Message-ID:Date:MIME-Version:Content-Type;
        b=Feh3fG1RUxt7mF2a6BvNFOHW3mVXHGdPkHMygbo3D7kNzTd/Rro/LFFPOzf144mBW
         av1+oqazuNFxKHyFsQ6boZyaheddUh7wOhiGf33lanOwMqTA/LW1j3dY8kf/Phr8Jd
         RG5xbS/TFcNr217wboOrgDkHOMgj+AiEjPzQ5hLITddq6VE2DP4ZZgMakW9zTMXIr+
         7Clq3eaSqFm6iIdYUFNgUYVEd/LfJkypsWIZlpKi5uoqZXBBoEulgzLwzgj5Cl3TZ2
         V4RtXNo64dd2SixcKfAlXq3ImGyXar2zJtxEfHaEZyrN5vsvYMzZ/BkfXl3y+21BVK
         a/+M0DfCD/hiA==
To:     Andrii Nakryiko <andrii@kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, Yonghong Song <yhs@fb.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: re: bpf: Implement minimal BPF perf link
Message-ID: <342670fc-948a-a76e-5a47-b3d44e3e3926@canonical.com>
Date:   Tue, 17 Aug 2021 18:36:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Static analysis with Coverity on linux-next has detected a potential
issue with the following commit:

commit b89fbfbb854c9afc3047e8273cc3a694650b802e
Author: Andrii Nakryiko <andrii@kernel.org>
Date:   Sun Aug 15 00:05:57 2021 -0700

    bpf: Implement minimal BPF perf link

The analysis is as follows:

2936 static int bpf_perf_link_attach(const union bpf_attr *attr, struct
bpf_prog *prog)
2937 {

    1. var_decl: Declaring variable link_primer without initializer.

2938        struct bpf_link_primer link_primer;
2939        struct bpf_perf_link *link;
2940        struct perf_event *event;
2941        struct file *perf_file;
2942        int err;
2943

    2. Condition attr->link_create.flags, taking false branch.

2944        if (attr->link_create.flags)
2945                return -EINVAL;
2946
2947        perf_file = perf_event_get(attr->link_create.target_fd);

    3. Condition IS_ERR(perf_file), taking false branch.

2948        if (IS_ERR(perf_file))
2949                return PTR_ERR(perf_file);
2950
2951        link = kzalloc(sizeof(*link), GFP_USER);

    4. Condition !link, taking false branch.

2952        if (!link) {
2953                err = -ENOMEM;
2954                goto out_put_file;
2955        }
2956        bpf_link_init(&link->link, BPF_LINK_TYPE_PERF_EVENT,
&bpf_perf_link_lops, prog);
2957        link->perf_file = perf_file;
2958
2959        err = bpf_link_prime(&link->link, &link_primer);

    5. Condition err, taking false branch.

2960        if (err) {
2961                kfree(link);
2962                goto out_put_file;
2963        }
2964
2965        event = perf_file->private_data;
2966        err = perf_event_set_bpf_prog(event, prog,
attr->link_create.perf_event.bpf_cookie);

    6. Condition err, taking true branch.
2967        if (err) {
    7. uninit_use_in_call: Using uninitialized value link_primer.fd when
calling bpf_link_cleanup.
    8. uninit_use_in_call: Using uninitialized value link_primer.file
when calling bpf_link_cleanup.
    9. uninit_use_in_call: Using uninitialized value link_primer.id when
calling bpf_link_cleanup.

   Uninitialized pointer read (UNINIT)
   10. uninit_use_in_call: Using uninitialized value link_primer.link
when calling bpf_link_cleanup.

2968                bpf_link_cleanup(&link_primer);
2969                goto out_put_file;
2970        }
2971        /* perf_event_set_bpf_prog() doesn't take its own refcnt on
prog */
2972        bpf_prog_inc(prog);

I'm not 100% sure if these are false-positives, but I thought I should
report the issues as potentially there is a pointer access on an
uninitialized pointer on line 2968.

Colin
