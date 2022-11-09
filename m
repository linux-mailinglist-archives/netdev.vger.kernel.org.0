Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BD262239F
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 06:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiKIF44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 00:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKIF4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 00:56:54 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFBB1EC5D
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 21:56:54 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-368edbc2c18so153051577b3.13
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 21:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pH5n86V2vlwlF9aXOB/jdhykuMPZm9xt1mr1n2dpOHg=;
        b=ELM5sQOhvtk7Le0mgzSHPBbF3z96SUAiq8PK0ajfCWmpIb1cdD654rA1m9qnx7RqKV
         zSFmZ/fExpnUlyO5cyzCR8zog9DOcSY/EGbTY/lFK/VP8AnviZsGFo0/lardO+V/ovjs
         lMQBPG8dYDBxfMxrtLi8c/APvSA2bzQ2/nq0jIArn/ojKNikHAMbeWVcfK/7MIyxbtoz
         f4Yq/f5dz8eQym+tIVb80tStykSnAwEIsOytmvIAMXW8XOViOv7tijopd1r8pDqbhWjZ
         p35qEjhM/aGhIVhUIf8J2yZXLxxIBbdHn8lDbS1ZEGx6DHc7MxOqsT8RpVN1S7klqbGW
         3l8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pH5n86V2vlwlF9aXOB/jdhykuMPZm9xt1mr1n2dpOHg=;
        b=d8aG4rqJeYD/1LJGaEMB0afUMHemAtLcu4GvwQhVNdA6HOTUyEAzKVKNVMgVjm+V6g
         iJW5dq3L3oTyzSlMBb2DvLpP+dp9YzPYFe3xjl1mYvo/qbFMIOxRLMvhI6XWqkXuEBIl
         Ew1+Tsjha47tXL2FlxAJtqXKLiAO8J9bo4L4uE7934bMFUWSVj1DJyNZq3qVxqR3yBwH
         voP6jaoR2moWsKJg5oiMUKokLbIjcitzCKFpHRBoZwNqcfbf9XJ1C961a4AfTYep9y1L
         2kySq1KMzkk0RN8iuoSf/9R7UY1TtK34C5vGAkpSyB3NlWHyD+Fuu78B7Naws7hWxfti
         ndmQ==
X-Gm-Message-State: ACrzQf3gsvYKid2exPwasbF9qulea0sQZ7RsAya8dD/JZa26oSIZ7sSi
        WmtxSIpL+ZYd4UzUYNV7/+zC+x8tYB54R3VG3EWhYA==
X-Google-Smtp-Source: AMsMyM7KNaOyzNcU3lNn5X4RyNarCGyEBzw/uQ6p1kFKthoIPuKaj+trVfNoLTs76ZOet1dRlhohGqfVYbabrY16D70=
X-Received: by 2002:a81:7585:0:b0:368:28bd:9932 with SMTP id
 q127-20020a817585000000b0036828bd9932mr54776947ywc.332.1667973413067; Tue, 08
 Nov 2022 21:56:53 -0800 (PST)
MIME-Version: 1.0
References: <20221108123320.GA59373@debian>
In-Reply-To: <20221108123320.GA59373@debian>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Nov 2022 21:56:42 -0800
Message-ID: <CANn89iL_0EWCW5Ks6okUKc5579eYg26Z0gffHArgj90YEMSa0A@mail.gmail.com>
Subject: Re: [PATCH net-next v2] gro: avoid checking for a failed search
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        lixiaoyan@google.com, alexanderduyck@fb.com,
        steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, Nov 8, 2022 at 4:34 AM Richard Gobert <richardbgobert@gmail.com> wrote:
>
> After searching for a protocol handler in dev_gro_receive, checking for
> failure is redundant. Skip the failure code after finding the
> corresponding handler.
>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
