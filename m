Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA6469C294
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 22:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjBSVAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 16:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbjBSVAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 16:00:39 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43D615CB1
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 13:00:38 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id 14so654794vkl.6
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 13:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QvVWqf+Mqc+cxnFuryRyphen+GwN4D9svygxjVVh4XY=;
        b=dEHbawPK+zF8eoRJDtITSFgiUaPwJv+rxvUoe25BneP8UMKSmAF1VzM33CycCp/LAX
         ANlne87VFB29VtGZQ3n5imvENFoOkKrr84NMNCblTy0VHXIiMX0TJ89vCSvefQMDNeY+
         FwS/ShEbTZNYlXIgoqjZXMvDOvURT7rVj+VaTwFrLRS4EnFocyoXBO54ytqwm6n3Ou5q
         fmtrTHLTjbJlwqs9GkrjHWnKlYsIl2im7H5eWGldakDS9LG2S51X+CTxzMzyhTgsN9sp
         GySPGpEp6HdHUJsdrm5RokBHFqbq1X5kS3FnHFA6n9LgDXPHQMr2xu7H5m5cF0jFev4i
         46rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QvVWqf+Mqc+cxnFuryRyphen+GwN4D9svygxjVVh4XY=;
        b=Ajyzdew7bzb/327oiXW+pE211rqe4Foacrxx9LaWkWkxiatzSQBpcz1rLoedurd9Cn
         iSM1O7Pokna1K1bgL4c6iW91h58q7KwO4bTTva3ajyPQ7hqcMguRw5fok3m7owpLdhcc
         IC9RbuOnRUVyoqlshU6jonOmuM4ybk+QWGfAOJlWZF2T17oHHYSXfZMg4A3lmLGZVGWt
         C5G9uCS/zIig+ERxoo3Z7rnZyBDVzViMCjYRpsx2pw+FgtHXF85GJ61c6Cngmwhtn/2b
         iTMbPTBvsa+5O4v3dLHazUBxooJv71/7xY2pSViD47k2vu9Ga7QBx066txJ4kIAwBYwR
         YEAA==
X-Gm-Message-State: AO0yUKWsVXo3yzP73i7dBG5ce64xoRGlOVLNk1d+5uFeA/6Vl0FDZt/u
        Mdnc9zSVchM6oPtiiGiM4Rlr9ljfOD0DdJcXtZ95Eg==
X-Google-Smtp-Source: AK7set+3HSV92EW6xy+IAKtrAU2Jgm/w7N3MOLyFJXMfTrPaBMTGEMYOxH2W4wpa/APaU6egPXqjHNa0MsNiVg1Mrl4=
X-Received: by 2002:a1f:1ccc:0:b0:405:cdc8:50b with SMTP id
 c195-20020a1f1ccc000000b00405cdc8050bmr413526vkc.41.1676840437656; Sun, 19
 Feb 2023 13:00:37 -0800 (PST)
MIME-Version: 1.0
References: <20230219131006.92681-1-nbd@nbd.name> <a66335ec-0911-1902-7585-827b918fe957@nbd.name>
In-Reply-To: <a66335ec-0911-1902-7585-827b918fe957@nbd.name>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 19 Feb 2023 22:00:26 +0100
Message-ID: <CANn89iLj1e5fkrPdmaBdhXXaidB6Gvmz_pUjkPiYdqMwv66tFA@mail.gmail.com>
Subject: Re: [RFC v3] net/core: add optional threading for backlog processing
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
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

On Sun, Feb 19, 2023 at 4:08 PM Felix Fietkau <nbd@nbd.name> wrote:
>
> On 19.02.23 14:10, Felix Fietkau wrote:
> > When dealing with few flows or an imbalance on CPU utilization, static RPS
> > CPU assignment can be too inflexible. Add support for enabling threaded NAPI
> > for backlog processing in order to allow the scheduler to better balance
> > processing. This helps better spread the load across idle CPUs.
> >
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>


> Sorry, the patch was missing these lines:

Also make sure the following loop won't leak kthreads.

while :
do
 echo 1 >/proc/sys/net/core/backlog_threaded
 echo 0 >/proc/sys/net/core/backlog_threaded
done

Some documentation would also be welcomed (
Documentation/admin-guide/sysctl/net.rst &
Documentation/networking/scaling.rst )
