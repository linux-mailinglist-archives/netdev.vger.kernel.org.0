Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84CDF52BE65
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 17:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239217AbiERPQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 11:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239190AbiERPQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:16:34 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE256A42A
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 08:16:31 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id h14so3176066wrc.6
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 08:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=i4HUA0YJMkIO+o2Vg/Sq8Fq4maURSbUg0U3Z/Q7nYmw=;
        b=mCKcHJYp2Bkepx7tlhuTqmlwG2RU5dk/pP+zG6cVSW1uHEbtHNJYikT7mZaVAiglMa
         raOMDK2+n6x1tKD0JDmDETmGusgmL7dydzBYQOv8r0HKqb4dISJlFZiqSN/Ml2p8v7J9
         VXl6YRXrCXASYkVEKjbgu6b8yOlFKEXtu07iI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=i4HUA0YJMkIO+o2Vg/Sq8Fq4maURSbUg0U3Z/Q7nYmw=;
        b=A31X7sn/Ia8f1za/KqGuFNw3aPnK1hqfJA7WiFbWYfuidBiZb0oZ7GF0v8LLp4NK+B
         fQ9dHw3JwDvEdY5BE4HbiO6pjJu8VuC+TLCnzENlw7P2rtyTjOqHkQx2oysPkcKIHdc6
         fyIPmGaXnBsQTzPX+B1rMAQSl3s4udVY4xRRgjVL1+gW7/QsYty4Nj8Yz6DnQYlo8+da
         gpkYL+0fYA07o7tD7zulb7fCOL1vE9TB0ODtLo3670bCQWVS1cbrEJLmPcXdOMhynaUK
         2/pQNxODQpLiviU3Mfr6W9ALYUj0TscxQHoTzoQkDH43sOZZZeJj7uAmqhZO6iA1cdS8
         SNLg==
X-Gm-Message-State: AOAM530umZ1QCB6yHb9lVaU8iB0x2b5twt6ubJIk77nVx/MYZQ9z4moz
        Jtdblg3JPXIcr7gPledfjf341g==
X-Google-Smtp-Source: ABdhPJzsslAUSZJ41bnZ5U6Qa3jOAILR0ulx7dyfyWKaMyd7dAnUunZ1WrgxrQa2qVyCYWM+1YhpiA==
X-Received: by 2002:adf:d090:0:b0:20d:3d4:8845 with SMTP id y16-20020adfd090000000b0020d03d48845mr192537wrh.162.1652886990119;
        Wed, 18 May 2022 08:16:30 -0700 (PDT)
Received: from cloudflare.com ([85.88.143.70])
        by smtp.gmail.com with ESMTPSA id v14-20020a056000144e00b0020cdf6ecafbsm3303773wrx.81.2022.05.18.08.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 08:16:29 -0700 (PDT)
References: <20220429211540.715151-1-sdf@google.com>
 <20220429211540.715151-3-sdf@google.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v6 02/10] bpf: convert cgroup_bpf.progs to hlist
Date:   Wed, 18 May 2022 16:16:08 +0100
In-reply-to: <20220429211540.715151-3-sdf@google.com>
Message-ID: <875ym2zx9v.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 02:15 PM -07, Stanislav Fomichev wrote:
> This lets us reclaim some space to be used by new cgroup lsm slots.
>
> Before:
> struct cgroup_bpf {
> 	struct bpf_prog_array *    effective[23];        /*     0   184 */
> 	/* --- cacheline 2 boundary (128 bytes) was 56 bytes ago --- */
> 	struct list_head           progs[23];            /*   184   368 */
> 	/* --- cacheline 8 boundary (512 bytes) was 40 bytes ago --- */
> 	u32                        flags[23];            /*   552    92 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	/* --- cacheline 10 boundary (640 bytes) was 8 bytes ago --- */
> 	struct list_head           storages;             /*   648    16 */
> 	struct bpf_prog_array *    inactive;             /*   664     8 */
> 	struct percpu_ref          refcnt;               /*   672    16 */
> 	struct work_struct         release_work;         /*   688    32 */
>
> 	/* size: 720, cachelines: 12, members: 7 */
> 	/* sum members: 716, holes: 1, sum holes: 4 */
> 	/* last cacheline: 16 bytes */
> };
>
> After:
> struct cgroup_bpf {
> 	struct bpf_prog_array *    effective[23];        /*     0   184 */
> 	/* --- cacheline 2 boundary (128 bytes) was 56 bytes ago --- */
> 	struct hlist_head          progs[23];            /*   184   184 */
> 	/* --- cacheline 5 boundary (320 bytes) was 48 bytes ago --- */
> 	u8                         flags[23];            /*   368    23 */
>
> 	/* XXX 1 byte hole, try to pack */
>
> 	/* --- cacheline 6 boundary (384 bytes) was 8 bytes ago --- */
> 	struct list_head           storages;             /*   392    16 */
> 	struct bpf_prog_array *    inactive;             /*   408     8 */
> 	struct percpu_ref          refcnt;               /*   416    16 */
> 	struct work_struct         release_work;         /*   432    72 */
>
> 	/* size: 504, cachelines: 8, members: 7 */
> 	/* sum members: 503, holes: 1, sum holes: 1 */
> 	/* last cacheline: 56 bytes */
> };
>
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
