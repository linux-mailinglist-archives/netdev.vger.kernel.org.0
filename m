Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF3D11EC42
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 21:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLMUzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 15:55:44 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39934 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMUzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 15:55:44 -0500
Received: by mail-lf1-f67.google.com with SMTP id y1so256147lfb.6;
        Fri, 13 Dec 2019 12:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mT5HHiq1Kpb9QJuduS2jGfWmu0FgjWtC0T7uCu1E0EM=;
        b=qIM4aaidhg2lSD6OXc80DimWkhiFewGKhU6TkXE6FwRSed7xOunHDSgv0yDmFqE4j2
         g0lFDGlDgIAR0lQwYD9c3og5mgcwhmyo5bN+5jxmJS608P3qc+9ce+8XjLRYhs3KGNQ2
         Ypnb1WHF5GxRjgN7l4UVWUkBWzRwk0voMeXCTTCzKnmPGViX6fgahwO+XIKLIYK9Ztti
         ld+kYyZQrXib+kSwDjnQ6V/RNZ09MKZJmldZh00hfwl6ggK5+fNBAoQaU8YRWr+jTjh7
         2QuyS095Sj0N87JfYQ1uprpe8sQNbl9T6/oCpXfPEIRojOFi/NRx8ibHGb7HEQHVYVqg
         fzEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mT5HHiq1Kpb9QJuduS2jGfWmu0FgjWtC0T7uCu1E0EM=;
        b=aeFjV8QlMNESHFY22VE0su0OxydOzlr0CPOfl5cANu0+cMbWr67Fdt4D6DQj2HRiPQ
         1fhJpK3vzzMSLgRUFMWGB1Lmh93Fj4Tie/dIZL97EMPIPj09Rdx+mWYnbC/MHCgtQssb
         oNFAvtFP7V8I2uEfNaY/iYJj8DaNguflP8RH9+WGCdeyV3ylVPhr1V6wMb/1hnMhghIx
         +wr0Q3UvJSDqgezTGt0BM/8xB2I+KXaFC/iKtTIJjYNlpZufM05OpOCUoWu20Esqj8vH
         JboGjOZAm2fRyMVA/z4bsX6ggeQEdwUBcoflneRLB9jFz3ZZtSwuEkRXEygunYGPdKyw
         uRQA==
X-Gm-Message-State: APjAAAV0vcWon1yJyNkVr6X8WKBIdaSi0SeAwOvCE0ZJXdh0iOhQUh6V
        qpiJUnjuLBUUCGDs2MePcwNWeaKhQRpJ4RkDSlKWxcmx
X-Google-Smtp-Source: APXvYqy6mnnDnrty2BmDPBB7pTxc0PEdVbjUt0zGa1Tfx3o1qtdWVNWSVvyU5E0lVsb/wsK09GGwWObgopVEL/tv6ew=
X-Received: by 2002:ac2:52a5:: with SMTP id r5mr10200511lfm.19.1576270541569;
 Fri, 13 Dec 2019 12:55:41 -0800 (PST)
MIME-Version: 1.0
References: <20191211175349.245622-1-sdf@google.com>
In-Reply-To: <20191211175349.245622-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 13 Dec 2019 12:55:30 -0800
Message-ID: <CAADnVQLAShTWUDaMd26cCP-na=U_ZVUBuWaXR7-VGV=H6r_Qbg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: expose __sk_buff wire_len/gso_segs to BPF_PROG_TEST_RUN
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 9:53 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> wire_len should not be less than real len and is capped by GSO_MAX_SIZE.
> gso_segs is capped by GSO_MAX_SEGS.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

This change breaks tests:
./test_progs -n 16
test_kfree_skb:PASS:prog_load sched cls 0 nsec
test_kfree_skb:PASS:prog_load raw tp 0 nsec
test_kfree_skb:PASS:find_prog 0 nsec
test_kfree_skb:PASS:find_prog 0 nsec
test_kfree_skb:PASS:find_prog 0 nsec
test_kfree_skb:PASS:find global data 0 nsec
test_kfree_skb:PASS:attach_raw_tp 0 nsec
test_kfree_skb:PASS:attach fentry 0 nsec
test_kfree_skb:PASS:attach fexit 0 nsec
test_kfree_skb:PASS:find_perf_buf_map 0 nsec
test_kfree_skb:PASS:perf_buf__new 0 nsec
test_kfree_skb:FAIL:ipv6 err -1 errno 22 retval 0 duration 0
on_sample:PASS:check_size 0 nsec
on_sample:PASS:check_meta_ifindex 0 nsec
on_sample:PASS:check_cb8_0 0 nsec
on_sample:PASS:check_cb32_0 0 nsec
on_sample:PASS:check_eth 0 nsec
on_sample:PASS:check_ip 0 nsec
on_sample:PASS:check_tcp 0 nsec
test_kfree_skb:PASS:perf_buffer__poll 0 nsec
test_kfree_skb:PASS:get_result 0 nsec
#16 kfree_skb:FAIL
Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
