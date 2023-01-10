Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6141666366D
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 01:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbjAJAvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 19:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbjAJAu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 19:50:59 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2892B3AC
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 16:50:58 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d3so11471893plr.10
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 16:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qqc/fEon/NVSZyEEI3QwvcgxItwPRTyJjiMIEAdH9fQ=;
        b=Vym5XMju3EEseOUeZjcN6MO+uTzD7EJIqguoQGoksSmSjKSFWyJphh+Btpm6GehfHa
         wJQL7eXG6uY75vVDGp+cMiqpB3YDVW8fYXKAiWIXcmX5Z0XFQlLyXpUzdRGKmzXY5nlv
         Ayk1mnt7+6BSQTGJPYBXeu2thIBwSOME1EzBGVU/ALvtm4LXZgCnutGKrwrofq5OrJm6
         E5kz7vFSyGM9SG32FU1ovF5KCfaFxig66+J5fS+Xo3VYpAAWIZfRSghPWXrvVtu37Cfv
         +BE7zdz3iNt6TsOPMVtLPH1KVhZmBeTJ5lYsutnQ2oklR4DHPCcIkPaIsCyHI1XkCtJ+
         a8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qqc/fEon/NVSZyEEI3QwvcgxItwPRTyJjiMIEAdH9fQ=;
        b=UtQWGx9TwXzAw559nVYdxCAz+rYkwY69ADRRUhPp7OS/jYBEGjiAfB5kzdk4xHaPqX
         RsF+4n0WWDf8wN5cSUgvXQpfTuShzahTOuu0QJUv0283IgRmbRPKT1dikAx72e5clfLo
         B+CMoA8JfmJ/meohuxe9Jqm0QhjFl8tYOt3W0HTqejpGYXUWHNQ5FWYeeOYwcqEkAN/F
         aPCK4+IVL1S1yqKSYPBmpcelosDw9jZYwY4LeZLIziOhtjCR27pwwE8EIpcEt5xvOISm
         4PYCKr7wJbmIotqZRg1SqqTYEbf5eycvQOhYdo8jKUoYRBkS9CN5p5TbqbsuKGC5awnO
         32sQ==
X-Gm-Message-State: AFqh2kos9gJAAOmrwmXUeQ1jEbBXZ+QP7OEJD0ky52Qnt1HaWl9mYzO4
        J1BvTPHa96xWAXKuKSTNyZs=
X-Google-Smtp-Source: AMrXdXsyqpe6Z7M7LtDGHbzvJcJr4MOvyRplkVuBjPdBwdlrGe2elE7hEyGEWMa5vJbw/XgEa8pRJg==
X-Received: by 2002:a17:903:1358:b0:192:9c2e:b36b with SMTP id jl24-20020a170903135800b001929c2eb36bmr42364967plb.52.1673311857529;
        Mon, 09 Jan 2023 16:50:57 -0800 (PST)
Received: from [192.168.0.128] ([98.97.43.196])
        by smtp.googlemail.com with ESMTPSA id a14-20020a1709027e4e00b0019254c19697sm6563472pln.289.2023.01.09.16.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 16:50:57 -0800 (PST)
Message-ID: <be4814483f1b320eaaa49ba8d59d81b2a51f932b.camel@gmail.com>
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: get rid of queue lock
 for rx queue
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org
Date:   Mon, 09 Jan 2023 16:50:55 -0800
In-Reply-To: <bff65ff7f9a269b8a066cae0095b798ad5b37065.1673102426.git.lorenzo@kernel.org>
References: <bff65ff7f9a269b8a066cae0095b798ad5b37065.1673102426.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-01-07 at 15:41 +0100, Lorenzo Bianconi wrote:
> mtk_wed_wo_queue_rx_clean and mtk_wed_wo_queue_refill routines can't run
> concurrently so get rid of spinlock for rx queues.
>=20
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

My understanding is that mtk_wed_wo_queue_refill will only be called
during init and by the tasklet. The mtk_wed_wo_queue_rx_clean function
is only called during deinit and only after the tasklet has been
disabled. That is the reason they cannot run at the same time correct?

It would be nice if you explained why they couldn't run concurrently
rather than just stating it is so in the patch description. It makes it
easier to verify assumptions that way. Otherwise the patch itself looks
good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

