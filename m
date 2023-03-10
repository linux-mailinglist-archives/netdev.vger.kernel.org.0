Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE946B4DA2
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjCJQv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjCJQuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:50:37 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D834111694
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 08:47:53 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so5718533pjg.4
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 08:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1678466873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UOq3+9hhBwKi8YAI1z5pWNSeEpaondyeR0mS3XKyWRY=;
        b=Q6rCUM9FtS9KAQBZ+MORtxJfGK7ZyAS6xKFO6c0qd8N8/MDS7S84NClUoWxENsjHlM
         musI+Zp9WmVbnuMrFYfbsgVumbO3n/MADHyKsNNZejszs++T3wknF3KjmV/R2ibTBFMO
         1koO+R9pfzVlbN1yk2jJ1TCKWlJsnuA0DaBL2eNtn8yc6VQtEkT9own78qLnO/ddBd1B
         bpUkXaE0fZzniUZBqyvTzufDCgZAhTe/+BflMKrQ0LyYvZqwg2YdZ6o/DYi4w7WxkLIx
         ysggd9pSIq+FQKguKysj0dJilwQF44aGZywPvxm1LU1ICU8WKsSX9wtsIKAMYL508ME0
         HpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678466873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UOq3+9hhBwKi8YAI1z5pWNSeEpaondyeR0mS3XKyWRY=;
        b=dFn0/RmVtQpgMyArwdBz5kw1RzGY/MXVv3/cpStgJC2GRt956jgGICf8Kimqno1cH+
         zXMSlpf/RdrSjit2vaoJUDOspHnF0aKaITo70OzaUCLlRYiPMTsbOoneUSsYzpk7Lk44
         ol2sXmV4AXgwfs9L9jA9yqt5pnht9bACaFtq7Vp8I4YdLTwIojrUa37G3uZzKe0Z+k33
         R3D1AXylb7F76iWftluKbH8bkl3+Et/FnPfZV3X43vZhmkayhuaIYTnlcu2OOGwNkIgm
         xtWuZ1iAlMQTr1rn4wONvr/sfQhc/XTOcMnKOSkd8yZq1gXRauPq+fWUzWDfcnktXnq2
         k9ow==
X-Gm-Message-State: AO0yUKXKdeXbC5AkOOh/aGlUJyyqXwZifiBdyBDzijIIW2y7ptw3Mp3N
        iPv9iBhGSdM3GbsPkmDjM9msqA==
X-Google-Smtp-Source: AK7set84KeoRRQtWag/SgYIwQfVfzAYFqVwC7ZtcpaO6AVmM4Exa37I4oTpkg7netGGhyU7YN3LG9A==
X-Received: by 2002:a05:6a20:6d04:b0:cd:929d:280a with SMTP id fv4-20020a056a206d0400b000cd929d280amr21362288pzb.18.1678466872708;
        Fri, 10 Mar 2023 08:47:52 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id j9-20020aa78d09000000b005a8c60ce93bsm42686pfe.149.2023.03.10.08.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 08:47:52 -0800 (PST)
Date:   Fri, 10 Mar 2023 08:47:50 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Kui-Feng Lee <kuifeng@meta.com>
Cc:     <bpf@vger.kernel.org>, <ast@kernel.org>, <martin.lau@linux.dev>,
        <song@kernel.org>, <kernel-team@meta.com>, <andrii@kernel.org>,
        <sdf@google.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v6 2/8] net: Update an existing TCP congestion
 control algorithm.
Message-ID: <20230310084750.482e633e@hermes.local>
In-Reply-To: <20230310043812.3087672-3-kuifeng@meta.com>
References: <20230310043812.3087672-1-kuifeng@meta.com>
        <20230310043812.3087672-3-kuifeng@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Mar 2023 20:38:07 -0800
Kui-Feng Lee <kuifeng@meta.com> wrote:

> This feature lets you immediately transition to another congestion
> control algorithm or implementation with the same name.  Once a name
> is updated, new connections will apply this new algorithm.
> 
> Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>

What is the use case and userspace API for this?
The congestion control algorithm normally doesn't allow this because
algorithm specific variables (current state of connection) may not
work with another algorithm.

Seems like you are opening Pandora's box here.
