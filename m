Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B7C653C3E
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 07:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbiLVGox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 01:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234932AbiLVGow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 01:44:52 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657ECF5B5
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 22:44:51 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id f3so740301pgc.2
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 22:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=086dsIWiKVuDdE5qHTcupmnKCG4y2yzrnr4Huev2NRw=;
        b=UtaOxFFLchWt5Jb/3Qqzm81/vYaqvIO89JpWehCUn/CUHFGzoM5mnpGGBFlYqQAoGd
         HNaC4hz9Wsd4cdrkLx4Nc3B37RZeAXNTTbWL+/LYmA84syobG+0riP0NUwuuMOLk0vM9
         31gmckA5xEiwm+8UXywQe5qkGm3622bwgeIVe534hNeHlbnrHCysSoCqhjwrJwPlkRNH
         xmSbqkhkZGSyFCxhD8DJcIVlOqa5aOvOkcRUxPZKzzjMp46TLQ3zogc3AjHVRg2Hd/hE
         u7zVrjzMsbBqYzgul0riADWu8PTfE+0rGq7xHVnf0NatXFT2v3uTvvZPalPduYNE26Vg
         GhsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=086dsIWiKVuDdE5qHTcupmnKCG4y2yzrnr4Huev2NRw=;
        b=ryJXW6VQi/VlyY6rYSgWJCPyHx+OwKDl56Ya4rs1O7i/fYsJ4sDTBoAj/nCbUp0fOy
         7jvmtkek4lYSEkz+8VBl9ySNBWMlSEGujZLvduc5dxtZDOxkmbc6TPJUgwZa6ozTXyuZ
         RfN1K79/Wu6zmRrYj75Z1yg7P44WM2ySvltCJwPiUfgez2Wv8+Lu9Wmr4pAYTyChaX8L
         4IsNWWh6HYn9BbEVY618DlVH6UkekiMw3v01VM2+q8uLmNShFZS32iGYk7+1dJpuP4NO
         ey/evdXefKIxmTimOVxN42q+FQjt8oJTKnYpCAABoFm63USwyrz4Bo5KOspS1iO4OlSZ
         h8hg==
X-Gm-Message-State: AFqh2ko9lvupx8mXwr5aSkx8jXKdjEARHQMTZWipbKIjrOyCrHm9Gb4i
        aJWD1ETWj5dk7lVSVGB71hYM+83neRF2QZnbC+FZKg==
X-Google-Smtp-Source: AMrXdXt0UcjoP66yyusLKIKTSX4FRsTvLnD0LVdmB5/Zjm2T6SMC5OAPDw1o6lqRfglsrE+itHgRlexlQR8eCOjBmiM=
X-Received: by 2002:a65:45c8:0:b0:48c:5903:2f5b with SMTP id
 m8-20020a6545c8000000b0048c59032f5bmr224962pgr.504.1671691490591; Wed, 21 Dec
 2022 22:44:50 -0800 (PST)
MIME-Version: 1.0
References: <20221222060427.21626-1-jasowang@redhat.com> <20221222060427.21626-5-jasowang@redhat.com>
In-Reply-To: <20221222060427.21626-5-jasowang@redhat.com>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Thu, 22 Dec 2022 08:44:12 +0200
Message-ID: <CAJs=3_D6sug80Bb9tnAw5T0_NaL_b=u8ZMcwZtd-dy+AH_yqzQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] virtio-net: sleep instead of busy waiting for cvq command
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com,
        eperezma@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

Adding timeout to the cvq is a great idea IMO.

> -       /* Spin for a response, the kick causes an ioport write, trapping
> -        * into the hypervisor, so the request should be handled immediately.
> -        */
> -       while (!virtqueue_get_buf(vi->cvq, &tmp) &&
> -              !virtqueue_is_broken(vi->cvq))
> -               cpu_relax();
> +       virtqueue_wait_for_used(vi->cvq, &tmp);

Do you think that we should continue like nothing happened in case of a timeout?
Shouldn't we reset the device?
What happens if a device completes the control command after timeout?

Thanks

Alvaro
