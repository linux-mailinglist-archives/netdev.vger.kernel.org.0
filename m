Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCBB590E8A
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 11:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbiHLJ6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 05:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbiHLJ6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 05:58:30 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734EFAA4E3
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 02:58:29 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id i14so1160835ejg.6
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 02:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc;
        bh=DOY22/g3AyzMKPXN3ChxkOgWt4fev38PjKt+897Ta5g=;
        b=hc42EyAZnecfhEZ9N0pFbC/I0EmhuRfHnBTTfie2bZV5gsmZGX6OcvE822SLjD9G9s
         OdtBamYkqmnzqfQJoTPzmLTpP3hUjlcpQBhJ5scq+73/UivdS+3b/majhnv8TAuT2vXW
         M1CsRsvmVv8RJ/52iU7hduBhFIH7qv3tvjqMY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc;
        bh=DOY22/g3AyzMKPXN3ChxkOgWt4fev38PjKt+897Ta5g=;
        b=Do4pizDrSidAtv2x5uILFbf8/j+XJRFYEHl0iE+GbzvXhzFZjSPnL4bwwTuBA1dg0v
         l+5TFRLPTd3lL7gjfLAzoE9YzUP8/LdIe5xLvNgNZuSDZVBGaW5MXlNWGaFaFxAKD212
         xVfPV5jbBS00pNnz6NYbSqSyU2kz+SKA5rBG3Lu/wZKkWwPBIUdgR/9m+SkmifTKK4/u
         v5tvy/4Dni+2nll1+HBLMx5mKGUmaIYq0tVdm/gMYXzNIPhJq06WhnMLk/EhxEmkqo3L
         PxeXS67FqPfD23HOncMWtIHjlQzTMHIywUjKJtIRzR6K13QzRQL6rBheOG4kBBPMzRzK
         O+nA==
X-Gm-Message-State: ACgBeo0Hj6LckjolmifrS6+62Pq7jlF98wbToxcZaRLPMZvuAyn3CZtj
        0ffFtb4BbbJLv1/m38hsbBnwFg==
X-Google-Smtp-Source: AA6agR5zRKxMqFfggTXc7WejoHTug0CFn55A1Gmq9Nuj5E1rF2erkpAna6VGS+o6NCPL6iam0F+BzQ==
X-Received: by 2002:a17:907:7f11:b0:730:6f6f:e444 with SMTP id qf17-20020a1709077f1100b007306f6fe444mr2064993ejc.657.1660298308014;
        Fri, 12 Aug 2022 02:58:28 -0700 (PDT)
Received: from cloudflare.com (79.184.200.53.ipv4.supernova.orange.pl. [79.184.200.53])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090613c300b0073079439f27sm623415ejc.72.2022.08.12.02.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 02:58:27 -0700 (PDT)
References: <20220810102848.282778-1-jakub@cloudflare.com>
 <20220811102310.3577136d@kernel.org>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        van fantasy <g1042620637@gmail.com>
Subject: Re: [PATCH net] l2tp: Serialize access to sk_user_data with sock lock
Date:   Fri, 12 Aug 2022 11:54:43 +0200
In-reply-to: <20220811102310.3577136d@kernel.org>
Message-ID: <87edxlu6kd.fsf@cloudflare.com>
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

On Thu, Aug 11, 2022 at 10:23 AM -07, Jakub Kicinski wrote:
> On Wed, 10 Aug 2022 12:28:48 +0200 Jakub Sitnicki wrote:
>> Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")
>
> That tag immediately sets off red flags. Please find the commit where
> to code originates, not where it was last moved.

The code move happened in v2.6.35. There's no point in digging further, IMHO.

>
>> Reported-by: van fantasy <g1042620637@gmail.com>
>> Tested-by: van fantasy <g1042620637@gmail.com>
>
> Can we get real names? Otherwise let's just drop those tags.
> I know that the legal name requirement is only for S-o-b tags,
> technically, but it feels silly.

I don't make the rules. There is already a precendent in the git log:

commit 5c835bb142d4013c2ab24bff5ae9f6709a39cbcf
Author: Paolo Abeni <pabeni@redhat.com>
Date:   Fri Jul 8 16:36:09 2022 -0700

    mptcp: fix subflow traversal at disconnect time

    At disconnect time the MPTCP protocol traverse the subflows
    list closing each of them. In some circumstances - MPJ subflow,
    passive MPTCP socket, the latter operation can remove the
    subflow from the list, invalidating the current iterator.

    Address the issue using the safe list traversing helper
    variant.

    Reported-by: van fantasy <g1042620637@gmail.com>
    Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
    Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
    Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
    Signed-off-by: Paolo Abeni <pabeni@redhat.com>
    Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
