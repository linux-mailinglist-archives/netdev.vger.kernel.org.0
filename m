Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7340E6448FB
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbiLFQQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbiLFQQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:16:22 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389C72F660
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:11:45 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id o127so19173176yba.5
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 08:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tDrifRzWdBNgisH0gpgDFlJNKYI9TCJI+hvrMMd9B8E=;
        b=ePrz3vXTgD0YoOuRCqbxmt3oD1riXRR7xyMCX4pIrH7IvS2ckjl7DAX2RH8v0pyvJR
         hmk8fnnz3QDkEBVoncTBeTDtLDJpy+AL6TtYsmaOh9AA3lZInaSlaRTIpQSS+Wp7DIX0
         XyM1URq37/6esEYzt1ToCGBNJO5PdlVCOF+duHLXvUw/l44TJSGXHG9hg3oEmQOFTh07
         v57woPwf9JT07JJmgopEhITjQsZcgVCA89ruLtWu8G5FpXpUtYHge+q3XyYpct9K5xtl
         T7bHRFNWL7YVSTHFAGXevejmIj2b8VpL1bbk82ADt9bkl4WNEp+XHRRh9UoXwSEHil81
         QXGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tDrifRzWdBNgisH0gpgDFlJNKYI9TCJI+hvrMMd9B8E=;
        b=huF2vU2pQxOpu56NJI/pWkiqLbICxO8nbv7vmfWI60LSFv2ouS35Pd7QUwbwjfwQL+
         FH1OUEKjcGjrAKQYkZX+oEp8Q3TrWenqgGY9spmhdrL9G5izexzfjPKtUJSP5ttIWCaq
         fRW7kUIyPV3Z5N1rkKnYbhFWWhuM1gMxYek6OaGvW0UWmrZqCLNXAeBBz27RJKaULcKq
         RRS7aZLO3sY9HH1LK+Wpa0mLXZjjE0mtf2e70zJKNWFmlWR9WNkg73KogtJ54iCBq3Th
         W2NBnO3NNjV3AdeOJMMwzbdos9QtKhCWVBfQvb6i7jKCyQN/HVgU1oCCHUQB5T1eKxW7
         Jx9Q==
X-Gm-Message-State: ANoB5pkt4iPR85u5DtCnj/aJzHJxklco/hM8SsMCQGmbfvpYj94icNeH
        +XNDmqMP50XWHwlZ9pyVT5G/bOIKToh4as7/DmqJiw==
X-Google-Smtp-Source: AA0mqf57V7Xpkn3dpUFvAfpcBk063X56FWZolh4G3dX9EJsnVExA55hvMZMY5MZJiq2tkCgFMfgzTYCVcJCQMSn+W4Q=
X-Received: by 2002:a05:6902:1004:b0:6fe:d784:282a with SMTP id
 w4-20020a056902100400b006fed784282amr14108258ybt.598.1670343104126; Tue, 06
 Dec 2022 08:11:44 -0800 (PST)
MIME-Version: 1.0
References: <20221206155309.2326167-1-yangyingliang@huawei.com> <20221206155309.2326167-2-yangyingliang@huawei.com>
In-Reply-To: <20221206155309.2326167-2-yangyingliang@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 6 Dec 2022 17:11:32 +0100
Message-ID: <CANn89iJQ+7gNhsSvfkm8Vq+VEEYqrFUfuH9dMY+fhuv1Ryppow@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net: apple: bmac: don't call dev_kfree_skb()
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

You forgot a FIxes: tag
