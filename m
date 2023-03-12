Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F9B6B6AA8
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 20:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjCLTcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 15:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLTcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 15:32:23 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459E33928F;
        Sun, 12 Mar 2023 12:32:22 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id s12so11218946qtq.11;
        Sun, 12 Mar 2023 12:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678649541;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D/F2xsczBx3Mz6lJbYcDdswrH+7uW2gyDmOk9WjXdoU=;
        b=RO6MA7V9WUH4SRKSrCkwh8Or1XwJeHpm9jcECgAC3VjukjGFUuLU4/qZHIuhs9Vyvd
         KXvctAucqoazv4dcQaF486/YLdZ8K/8LBHbefc0D+UunSBPyAhnwG0+31kgE6xsKAA98
         5Cze8XdXicA0M3dcrkakmETGFMiwvYZ6E7eMyrHS2CK4PzN7/Rh9GtFDpsfbMjxPEQGk
         UsPThosK6RMwxCQ/khK+CK3Kq16LAn2BnJlVKKnBv63KZpPyC/D2CLLJJinOAWn6Yc9v
         jlQD1yGksoNAFBEvLRIst6yeXRq13KB/hfSARzxgPJ54TY3vpvF71t35YZlVRJE8CWck
         oVJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678649541;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/F2xsczBx3Mz6lJbYcDdswrH+7uW2gyDmOk9WjXdoU=;
        b=UA096sjmZU8wwwMDkD+lAcLKatSzCY0xTFrBjBDgDc4lZDwlF3KTPmOK/UcpNzZgmw
         oGP4sBkCE9l8x9aKoPjTJ4sWWlIRoduVk/v9wZPpLBzfbtVKxCqNAE8stlEzjrwQ2YLJ
         5gy5OBr1m92Q0HYB7uezn3M7T+rNopYDNTQJnEQnUZFFTyYBgHfSJqBS/eCVBKBGIF7I
         dL+nUbI7xfgKFmBhN2IcLoqlFK9xMyv0c1bCX2fTTqnRbiwfmeYmwTHbDyeclniybKDk
         q4eLAk8NX2fNJPpM91Wbzz0dgWymqeRZ2Uk6G6ndn3KUO9aWD26V54eNlPuRk/vWZXYM
         n79w==
X-Gm-Message-State: AO0yUKV5g3I90BBI9EaKyUpTVSiYPo0dsJALYRc35E5yts7rNnT0vYpr
        nDFPScpTu5c0RYGl0gBwTfo=
X-Google-Smtp-Source: AK7set/ZuBIMUJX/mFp+exe1B0AR6KZfUxWkpkPX5uuvbX9rO5encbetSlF7CX+QgQupuy49Rq2sjg==
X-Received: by 2002:ac8:5bc9:0:b0:3bf:b75a:d7a7 with SMTP id b9-20020ac85bc9000000b003bfb75ad7a7mr15267929qtb.7.1678649541367;
        Sun, 12 Mar 2023 12:32:21 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:790c:770f:7bb1:6550])
        by smtp.gmail.com with ESMTPSA id f68-20020a37d247000000b0074240840c25sm3930490qkj.108.2023.03.12.12.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 12:32:20 -0700 (PDT)
Date:   Sun, 12 Mar 2023 12:32:19 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Hsin-Wei Hung <hsinweih@uci.edu>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: A potential deadlock in sockhash map
Message-ID: <ZA4owxvldelZ6x9h@pop-os.localdomain>
References: <CABcoxUayum5oOqFMMqAeWuS8+EzojquSOSyDA3J_2omY=2EeAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABcoxUayum5oOqFMMqAeWuS8+EzojquSOSyDA3J_2omY=2EeAg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 07:39:59AM -0600, Hsin-Wei Hung wrote:
> DEFINE_BPF_MAP(map_0, BPF_MAP_TYPE_SOCKHASH, 0, uint32_t, uint32_t, 1005);
> SEC("tp/sched/sched_switch")
> int func(__u64 *ctx) {
>         uint32_t v0 = 0;
>         uint64_t v1 = 0;
>         v1 = bpf_map_delete_elem(&map_0, &v0);
>         return 0;
> }

It looks like we have to disable hardirq (instead of just softirq) in order to use
sockmap safely in interrupt context like sched/sched_switch.

Thanks.
