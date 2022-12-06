Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD38644901
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbiLFQRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbiLFQQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:16:54 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C7F13F51
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:12:27 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-3b10392c064so157273647b3.0
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 08:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1iIwQrWAur4p2/hwirtroR9R8057HXPUqejPYkkx7/0=;
        b=OvS4gSedwX1XlVvK0DBLvAcrhWHjdBfOuozh//J9tN3k1J3EDiFiRPtTpXgnZ15oal
         8OP+IldcS3mA4NoAPjaeJMAlO0U3efOc6XGtwlcHx9cqCRIQ22ediF4DNPag4W/+38Oq
         6cf2EohgwuC7GfU6BTC9tD3v9AA4zcRQbAvhSS2G4ULBa/0pWpEzh9bYngQbVDf3Gjkl
         qFsFc9U6GpTb2resz8izf3Oy5WgXxuBU/npqJCXTjXpCei9RITmZzSF8ahHtzMij6LQU
         LoG7IK4788sZFLa6FCfC6vTJYLf7qAWZtGZQ13AhT+QJz9k0JpUpHjW1w05bptzfYak6
         HSwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1iIwQrWAur4p2/hwirtroR9R8057HXPUqejPYkkx7/0=;
        b=d9abKuowS5nfix+7GM7sHNC8Tk3Nhlmv1/qTykh+NcU9rDDai13cOcnqoNxjIDRg/d
         7oZ4gvU8nmFmX+Rfvb1X7ZfR5YkSYO8BVSzKlH+mA6wT1sUH5gz9Fl74afBQyCg8fDkd
         cHJVfLUgZmQje55sEH2DkSATr8XwKa8Bw9ZkCc1O6JIKNaqIf6nGGcxkT1pe8r9STMgE
         06UrkhiqBLMWyIfeDP5G1gnh9DXPxN9Xof7vf9h4c6O2QCrxgLVHDxXZ/m6tEqh9Bs0s
         8RSACEqKxekK3/w7LZ7fGWbOQ0Cot+PB+9j0h0aoBQ550+o3vOxUDi0c5BSBMrakcCn7
         vIjQ==
X-Gm-Message-State: ANoB5pmAM919Hq6hkoQ7FrulWLX/VV3ik47CejMu1tZUpwshx5Dl1+/7
        6wlRcsAGoJZzOxsluneLiK4awZvVea8b5KUq5M/B7w==
X-Google-Smtp-Source: AA0mqf6961I0yJ4Ffu9Hlkt0qzXw+p1usttyJkQ1PgtnR6ByNpqRcyIpEgaxVLGeqTLhiU4hNjHZ4QhxJMByoPt2E6A=
X-Received: by 2002:a81:1144:0:b0:3f2:e8b7:a6ec with SMTP id
 65-20020a811144000000b003f2e8b7a6ecmr5528447ywr.332.1670343146128; Tue, 06
 Dec 2022 08:12:26 -0800 (PST)
MIME-Version: 1.0
References: <20221206155309.2326167-1-yangyingliang@huawei.com>
In-Reply-To: <20221206155309.2326167-1-yangyingliang@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 6 Dec 2022 17:12:15 +0100
Message-ID: <CANn89i+9AZcCS-SzUxma4sk1u80TrfG4BPtg1YmiKLFrzdUzNg@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: apple: mace: don't call dev_kfree_skb()
 under spin_lock_irqsave()
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
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

On Tue, Dec 6, 2022 at 4:55 PM Yang Yingliang <yangyingliang@huawei.com> wrote:
>
> It is not allowed to call consume_skb() from hardware interrupt context
> or with interrupts being disabled. So replace dev_kfree_skb() with
> dev_consume_skb_irq() under spin_lock_irqsave().
>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

You forgot a Fixes: tag.
