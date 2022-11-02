Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180C7615A11
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 04:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiKBDXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 23:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiKBDXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 23:23:51 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66F924BD8
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 20:23:50 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id j2so6516065ybb.6
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 20:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IxI3d8g5EIYxxViSqIaLNXiNEHWWL7mrFvXUt/86Kx8=;
        b=XG9p9Af6Vl9em1SnMsA7SlyJdy7fqSbP62yVwRiP91okT3gWQrMIMQdjUAP0+iWhsW
         YYwGZ4H/SBjUno+mUX7Lh0TUw4NzrVzlokLyzkO10usP7fsyg8lanE0cDBQVwN+mgf7a
         VpePWjxAHdiqjEppHvAguk71dpu39V5ZlnB/e7h5cOOFIxHIaX8HWhVfKeYjVcrLy/Gz
         C3sJdbVioY4PO8eJkbXUSPVsdMjCruJYBVUj8wF9GilS5kekdNw0nR2E/mDuYftTkiu3
         4jLh7t0wmWRknj9vURjSbfouOPyFHYd450dGYaU8pt+Wvw1O2uRmP5vkkC4V1kRHNmEJ
         7Nsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IxI3d8g5EIYxxViSqIaLNXiNEHWWL7mrFvXUt/86Kx8=;
        b=qCcaDz3BxCT5e+ZHaHcjS0s9nqdnYUpHELwNn1FTLoSonA9tHljMMVJnZzVtJTFp6e
         1gpJIBtA+nPREbnn7C3stQ/gtn0hQ69Kbyuc+8P0u+tfHePkPWZsLdWpMxOTXXwLfriA
         8f44L+SikQxD/pCtkzegzExcfHXPUypPCipjjS1olkWIQA2meS6BtY88dCeXmaoOt5CO
         s0MJGh0Mu1N26jEK8B9i2hy82y9zH7CxGq+2D1+N2NgtCl73dl+rmJZvUs38fP5NeM7B
         tGL3FajPWvWO7lfISXy5WqUB9MXntPEy8895D068BmEjq6suHGH+Oud2s3p/Q8aoajVU
         AfTg==
X-Gm-Message-State: ACrzQf0+l86YgF/K9NjiZ3bu15QgnNukA0wtubo0OEwzjBivvjO/rpze
        KLX1DAjujuU42SjHPNxpAPZo1KcmbC/ho5qSIy7CpA==
X-Google-Smtp-Source: AMsMyM71ojt98lTPLGSDcdT5RDvIOLDptD4piOMD0L900bNnUWwoDJkf65qQ8Sfp1C72pgtsDN+VaRKUaS+KBqzJQAc=
X-Received: by 2002:a25:aa2c:0:b0:6cc:16c2:5385 with SMTP id
 s41-20020a25aa2c000000b006cc16c25385mr20888713ybi.55.1667359429803; Tue, 01
 Nov 2022 20:23:49 -0700 (PDT)
MIME-Version: 1.0
References: <20221102021549.12213-1-linyunsheng@huawei.com>
In-Reply-To: <20221102021549.12213-1-linyunsheng@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 1 Nov 2022 20:23:38 -0700
Message-ID: <CANn89iJWyLQDHHJXNHb78zpX=At1oyqPaUmeQ5-GuzX2YOxGDQ@mail.gmail.com>
Subject: Re: [PATCH net-next] ipvlan: minor optimization for ipvlan outbound process
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Tue, Nov 1, 2022 at 7:15 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> Avoid some local variable initialization and remove some
> redundant assignment in ipvlan outbound process.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

Really I do not see the point of such a patch, making future backports
more difficult.

Changing old code like that should only be done if this is really necessary,
for instance before adding a new functionality.
