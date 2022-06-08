Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B765A5423DC
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbiFHFfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 01:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbiFHFe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:34:58 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08102200A7;
        Tue,  7 Jun 2022 20:39:24 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id s12so31665549ejx.3;
        Tue, 07 Jun 2022 20:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TIpn0h2PVrPJC3SI/KH0xb5zHLGy1ws/TaSSWL1fafE=;
        b=ZRJirNsPmCJEJ8/xnwMXrjipNEdCoSO+YJlycAp6wr+Y+VIu9Qm0TsQ/xbl2UkI0+L
         4WtwcGHsG9iVn4/DIpsadFXw37zZd/kzciybUhbJUVdirBgGDXwswi20O0rYsy33imxk
         WOdvvDtoGHSR0AT1DeC5aC/zJU4qRzE9WDGZg4+yARXJ4aPFocpV1utF703vXaxXkcF8
         2o99mSaoPk3pMZ0VXE1okpFArQCfwpN58epmZHq+KhOyf3XnBNjkKH9pB+rduYl6A+t1
         6st4ECCjKlV3uSgIlbdKMgdHUbMOP4lsjNhBQm4/ewYKQUkQuwVd/k1SLR7fewMpO+g/
         gsiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TIpn0h2PVrPJC3SI/KH0xb5zHLGy1ws/TaSSWL1fafE=;
        b=EEEXA3RYaiJi6o0uvuZoJi3ZUozJV1nktXisLztxtfl4J3UKIeQZQPyrxLDjGu/BRm
         SEkaS2Z31MvSOChcwrQQFFLtjdNy9agZp9QPQB4SOYDOkV1svyG6iu3BTBbupWb5zR5G
         JHlkuxUahnweg6NRS8gkjVBhTvaDs2zd0zzHiXSREsrNkjYlwZAJ5jfD48yI6U03ocQP
         Oq9iFL3lYQ6MVODW2InpIPtHSnB9Y9KICqKmP+P1l0Nl73oY9iU+I/k9dBXAYk76MS9a
         lyUu32tofN+hfGQoCxXRtfrzYqm1AdEaoqhERp9pDBCv8xcZ/czh4qivvQjcEfZRjBGK
         hCQA==
X-Gm-Message-State: AOAM532HIDNVwRxM7GaE8zyyj0JfjcSUDrVbUHbw/rSaA2IKaCK5n1Y1
        OKevs7yVBKmK4NNp4CGt1fI4IE6GWtugg89TvxXpD/LT
X-Google-Smtp-Source: ABdhPJwRFRiobbRMerKEWIQI1+TgMyhJlXgcDWNvSFn2bKG23OUrbLI/1rcC8WMLQLdj12I5e7ypkHrs+Lu0noqKSLg=
X-Received: by 2002:a17:906:c156:b0:6ff:2415:fc18 with SMTP id
 dp22-20020a170906c15600b006ff2415fc18mr29466294ejc.94.1654659563312; Tue, 07
 Jun 2022 20:39:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220608021050.47279-1-zhoufeng.zf@bytedance.com> <20220608021050.47279-2-zhoufeng.zf@bytedance.com>
In-Reply-To: <20220608021050.47279-2-zhoufeng.zf@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 7 Jun 2022 20:39:11 -0700
Message-ID: <CAADnVQ+kcONngR5mVm53KJZJOVQhR99TzZzv4KONcVY_H1rqEQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] bpf: avoid grabbing spin_locks of all cpus when no
 free elems
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 7, 2022 at 7:11 PM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>
> This patch use head->first in pcpu_freelist_head to check freelist
> having free or not. If having, grab spin_lock, or check next cpu's
> freelist.
>
> Before patch: hash_map performance
> ./map_perf_test 1
> 0:hash_map_perf pre-alloc 975345 events per sec
> 4:hash_map_perf pre-alloc 855367 events per sec
> 12:hash_map_perf pre-alloc 860862 events per sec
> 8:hash_map_perf pre-alloc 849561 events per sec
> 3:hash_map_perf pre-alloc 849074 events per sec
> 6:hash_map_perf pre-alloc 847120 events per sec
> 10:hash_map_perf pre-alloc 845047 events per sec
> 5:hash_map_perf pre-alloc 841266 events per sec
> 14:hash_map_perf pre-alloc 849740 events per sec
> 2:hash_map_perf pre-alloc 839598 events per sec
> 9:hash_map_perf pre-alloc 838695 events per sec
> 11:hash_map_perf pre-alloc 845390 events per sec
> 7:hash_map_perf pre-alloc 834865 events per sec
> 13:hash_map_perf pre-alloc 842619 events per sec
> 1:hash_map_perf pre-alloc 804231 events per sec
> 15:hash_map_perf pre-alloc 795314 events per sec
>
> hash_map the worst: no free
> ./map_perf_test 2048

The commit log talks about some private patch
you've made to map_perf_test.
Please use numbers from the bench added in the 2nd patch.
Also trim commit log to only relevant parts.
ftrace dumps and numbers from all cpus are too verbose
for commit log.
