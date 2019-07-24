Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2456B72BF1
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 12:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfGXKBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 06:01:19 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40933 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfGXKBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 06:01:18 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so41061159wmj.5;
        Wed, 24 Jul 2019 03:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=eardGiG9sgaXsGeo8bpQv9K/DCZgdVYTWR1Pqk2OwkY=;
        b=J3q7lweoHQPYYUM83gyEYhTojQ+pKicvf6vieXh3JR9fC258Nxdem8XC48Lwpn8YxH
         GV+nBzDUZg/irSM0hGozeVSCzUZUO93CIDPFcO945U5h6VLnW4WFenswd8eFNnj7ob0D
         G+Zr2QBqKPO/PKMn6NtbWzp++U2ZKZoWzTzn4jyBpu5tF++LngjmZnetSF3wMu7idzVf
         izK69UIpmXPZ6ZDroVpWV8T4z50/t8fnc2PkwQu3Yl2I0XltVcuHWDl7kYJkpBt2tYSN
         aR0PXBvFn/dygedKsYgXqONgLLDDpmj93ZP+kdTQ8Kq0imHz3xRj6ZZHnpEy20qGulye
         5eEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eardGiG9sgaXsGeo8bpQv9K/DCZgdVYTWR1Pqk2OwkY=;
        b=TcWHcfMMuKs+4FtFF5PXBtIbCcbJS14jBeDYy1fXFc4s+lwVYGkWAVtG5Dyz0L6FFI
         JydyWLJTv3BYyhzsVd7NiROvMFi6myfMmMumaCXcGJjO2fMD1zNhCpOmbF22uk1ZjK4V
         GyJMacm5/60hE0etL10TIw/uUto+4PdEGbDJgqvnIt2jWdqSii5DLkWHxqC0HV3CKzz/
         o0UEZEZS/zq3zcHvffRUZkvIR5Afy4mF0koGPFVWs3W0+ghFuic6JS49XaoRM5AW5GJX
         rnLHDaQBgYhgcV5gY22wuu15OKlTk0VJ5msHMv0V8Z4CIOnLunkHd+6WJ9iP8I7627/2
         SkJQ==
X-Gm-Message-State: APjAAAV4M48Ug94PtNNg7hqputK3wCW3VynoT2/WJdmvYVZtTBl7CTS3
        VSFVGC4akYKR+OrwSQsHUBBPtVW4
X-Google-Smtp-Source: APXvYqw8jbpCojRMa90lBf2zLLJ/B6ocFFfKvZdX80jGWruuFFEAh4/9mfLcAatyHsXqd5BDG2h5kw==
X-Received: by 2002:a05:600c:291:: with SMTP id 17mr72160774wmk.32.1563962476284;
        Wed, 24 Jul 2019 03:01:16 -0700 (PDT)
Received: from [192.168.8.147] (200.150.22.93.rev.sfr.net. [93.22.150.200])
        by smtp.gmail.com with ESMTPSA id r123sm41660326wme.7.2019.07.24.03.01.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 03:01:15 -0700 (PDT)
Subject: Re: [PATCH 4.4 stable net] net: tcp: Fix use-after-free in
 tcp_write_xmit
To:     Mao Wenan <maowenan@huawei.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190724091715.137033-1-maowenan@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <badce2b6-b75e-db01-39c8-d68a0161c101@gmail.com>
Date:   Wed, 24 Jul 2019 12:01:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190724091715.137033-1-maowenan@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/24/19 11:17 AM, Mao Wenan wrote:
> There is one report about tcp_write_xmit use-after-free with version 4.4.136:

Current stable 4.4 is 4.4.186

Can you check the bug is still there ?

List of patches between 4.4.136 and 4.4.186 (this list is not exhaustive)

46c7b5d6f2a51c355b29118814fbfbdb79c35656 tcp: refine memory limit test in tcp_fragment()
f938ae0ce5ef7b693125b918509b941281afc957 tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()
e757d052f3b8ce739d068a1e890643376c16b7a9 tcp: add tcp_min_snd_mss sysctl
ad472d3a9483abc155e1644ad740cd8c039b5170 tcp: tcp_fragment() should apply sane memory limits
4657ee0fe05e15ab572b157f13a82e080d4b7d73 tcp: limit payload size of sacked skbs
b6d37bba0f7a7492427d7518d4be485dcdd9d5d1 tcp: tcp_grow_window() needs to respect tcp_space()
68337354043a3d5207cd4f055e5a8342ec4eec0f tcp: Ensure DCTCP reacts to losses
7ed7c0386ef2a5cbe58e15af5014c9302d3593eb tcp/dccp: drop SYN packets if accept queue is full
191aa19ab8c1459c11a5c541801f17e01dda17de tcp: handle inet_csk_reqsk_queue_add() failures
a466589807a13da2b7fbb2776e01634b38a4233b tcp: clear icsk_backoff in tcp_write_queue_purge()
122e4a30779336643614fe0f81e1f3fcbd0a371c tcp: tcp_v4_err() should be more careful
ed7748bcf290ad8f80020217d832f458ac9bae7f tcp: fix NULL ref in tail loss probe
eee1af4e268e10fecb76bce42a8d7343aeb2a5e6 tcp: add tcp_ooo_try_coalesce() helper
be288481479ca8c1beba02a7e779ffeaa11f1597 tcp: call tcp_drop() from tcp_data_queue_ofo()
352b66932a23fb11f0a7c316361220648bca3c79 tcp: free batches of packets in tcp_prune_ofo_queue()
e747775172a2d4dc4dae794f248f9687ba793f54 tcp: fix a stale ooo_last_skb after a replace
4666b6e2b27d91e05a5b8459e40e4a05dbc1c7b0 tcp: use an RB tree for ooo receive queue
ec7055c62714326c56dabcf7757069ac7f276bda tcp: increment sk_drops for dropped rx packets
86a0a00794c21b35c72d767a98fb917b5b76b513 tcp: do not restart timewait timer on rst reception
81970da69122fe4bf2af5bb1bb4c7f62d4744e79 tcp: identify cryptic messages as TCP seq # bugs
43707aa8c55fb165a1a56f590e0defb198ebdde9 tcp: remove DELAYED ACK events in DCTCP
42962538cd9fe281a6e8602f22c7b1e218ed812a tcp: Fix missing range_truesize enlargement in the backport
27a0762cb570834dc44155363c118cabdd024c3c tcp: add one more quick ack after after ECN events
cd760ab9f4e13aedccc80f19a0b7863d5c0b3c8c tcp: refactor tcp_ecn_check_ce to remove sk type cast
96b792d199d17545d6a53faf44b9c91d038f1ab3 tcp: do not aggressively quick ack after ECN events
2b30c04bc6f9e7be2d9a5e1b504faa904154c7da tcp: add max_quickacks param to tcp_incr_quickack and tcp_enter_quickack_mode
e2f337e2bd4efe32051a496a7fcdd94ea67c0cfa tcp: do not force quickack when receiving out-of-order packets
dc6ae4dffd656811dee7151b19545e4cd839d378 tcp: detect malicious patterns in tcp_collapse_ofo_queue()
5fbec4801264cb3279ef6ac9c70bcbe2aaef89d5 tcp: avoid collapses in tcp_prune_queue() if possible
255924ea891f647451af3acbc40a3730dcb3255e tcp: do not delay ACK in DCTCP upon CE status change
0b1d40e9e7738e3396ce414b1c62b911c285dfa3 tcp: do not cancel delay-AcK on DCTCP special ACK
17fea38e74ab24afb06970bbd9dc52db11a8034b tcp: helpers to send special DCTCP ack
500e03f463835e74c75890d56d9a7ab63755aa2d tcp: fix dctcp delayed ACK schedule
61c66cc52d42f78bbdd8f2e40b7c0bb9b936a12d tcp: prevent bogus FRTO undos with non-SACK flows
48ffbdea28808354b89447fac2d8524c29ce7ab4 tcp: verify the checksum of the first data segment in a new connection
4dff97920e13af3e92180eefa6b7712d4eac5e58 tcp: do not overshoot window_clamp in tcp_rcv_space_adjust()

