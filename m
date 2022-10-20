Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9B26067FA
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiJTSLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiJTSLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:11:18 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798E61F8136
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:11:08 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id y72so489412yby.13
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tBL3aRwUgQUHuZUNC4jwdua60RCbVw2xqjxs/jrsiOY=;
        b=Ozit37Lg3V8qNDWvugetwUYRsrSuzY3/T4X+wJPki5rL49iKw7VRXPMPkfVl7MLBL4
         cKnH0mQSDxAWAiibRbuL17a8xBLn4oP/qs580GwUAHJDppZRwkQu4oPsJJGIQ8pjTV7/
         gyIX+o7BAhaL5A8Y0F19j8/WvLwzK/dR1dVV/lgeM7EXY4M71VL1PJ+qrs3FyidamHDJ
         3+cNXYSnJ6kLXx7JiykwfChelyaKVzNxBl56ebTQ5KwJ/IoC5HsyKMrQ0kqUmnRDFLyb
         cbVWbLkl12SjCDahuVZ1TlyJ4jyp8MTqZ9uVowqZjtT8BkDgN98dr8mcVngc9ssV1J43
         Ecpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tBL3aRwUgQUHuZUNC4jwdua60RCbVw2xqjxs/jrsiOY=;
        b=2xvaWz15krbIu3jtWjA49sMMKNO0XqPcTsCChz4l2JAPz7k5N8QAPM5InyenD0ZXh6
         XVxFx6/ygGJ1lfFfKsBDWe6yp1EFbQhDWqCX5jJne2lYInx6LRY0vK8uWrDrVghICA2Q
         37g2SBQaikJK3u0lDlJspsncvP8nras0tICeh1ZVT/QvqCnC3QTkaJXfnwQXXPG3AgvN
         tg1RRf3tFby2XQVG8bavLnunWkN8LrAOGjcXbXd5eguYMVvXPDtLy+6oY5HJZr5TQlRO
         hLB7MnhS6NnpC7GpyopkERD2NmD+1GOSMWG6WrbExLUuC2fYr1TJsAUKdtWFzU9H7deU
         yRoQ==
X-Gm-Message-State: ACrzQf1PJCpIB0HjbkTgNdQxzVI/aj8vlB+TJghAItmKYZpm1yL93Y94
        yoC6Tw+3IFkcacQ3uRbtEzdMmBtXm+Wub8L9F/RAkg==
X-Google-Smtp-Source: AMsMyM6wiAHXJPANGgJl9CjkzhwhrSekfszm2WhY2dqHdR7RzVOaNo2QG3mCMmGpgPtExYhYBOw5u1q3kklsXZpAsbo=
X-Received: by 2002:a25:3187:0:b0:6c1:822b:eab1 with SMTP id
 x129-20020a253187000000b006c1822beab1mr11892405ybx.427.1666289466590; Thu, 20
 Oct 2022 11:11:06 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1666287924.git.pabeni@redhat.com> <2dede94e742d8096d6ac5e0f1979054ee158d9a8.1666287924.git.pabeni@redhat.com>
In-Reply-To: <2dede94e742d8096d6ac5e0f1979054ee158d9a8.1666287924.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Oct 2022 11:10:54 -0700
Message-ID: <CANn89iLSgJSqc27UYDJ26YeinSzBWtDH6sj1KAHuuAkCmxuwpg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] udp: track the forward memory release
 threshold in an hot cacheline
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.linux.dev,
        David Ahern <dsahern@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 10:49 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> When the receiver process and the BH runs on different cores,
> udp_rmem_release() experience a cache miss while accessing sk_rcvbuf,
> as the latter shares the same cacheline with sk_forward_alloc, written
> by the BH.
>
> With this patch, UDP tracks the rcvbuf value and its update via custom
> SOL_SOCKET socket options, and copies the forward memory threshold value
> used by udp_rmem_release() in a different cacheline, already accessed by
> the above function and uncontended.
>
> Since the UDP socket init operation grown a bit, factor out the common
> code between v4 and v6 in a shared helper.
>
> Overall the above give a 10% peek throughput increase under UDP flood.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>


Reviewed-by: Eric Dumazet <edumazet@google.com>
