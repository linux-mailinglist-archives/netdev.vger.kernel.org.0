Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B669966E395
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 17:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbjAQQbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 11:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjAQQbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 11:31:39 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B2A38E9A
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 08:31:36 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 207so7825095pfv.5
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 08:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oyAUCIpsX94vAebZ6CYfMA/w5PtIi5LXwxTkx+D0Hjk=;
        b=g1km+0+MzB3lRidvUdxHm2lg9A2jdkpH0gKE1EmBHjk5vJf2Nv+bat/A7GZ1E00ytX
         fdJ4svLC7GWQQRd2Q4tCn25vw0ktEfWvSDBnCBqv+7ZtzSuu7C9w84+vO/SEACYBRh94
         ajOXo4wUnlYiTWezVaW/tIeruYl0cA4Nr2weSd7sD97H2kM97VbMwRLwK4VHH3+erCMm
         phrLR8krqJDrjNpY6VcVJv/OEY564JLNDSgawXWy0nUjdpQpDFfx2lb5PCpaHaftZ+FA
         ViRy3VvsoxcLqbjkdDX0J3Cd8RMBh4tXu3UFC+H2LZdtQXKhfAOF0P1ZC+j1Sq92+4Ya
         NNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oyAUCIpsX94vAebZ6CYfMA/w5PtIi5LXwxTkx+D0Hjk=;
        b=J6tOjy2L/VoPuUl+BobbK/g+gn1oH5Y26+gh69JEH+TpSpb5zc6sZMqqNdBBWazg9C
         IzICOl6AIW2XMQo/81mzGxThnOPzYG/v4y+52XCJqzIUrf9HFN1npzytelQ4L0aACZHY
         Y3CPIFpHbqE5WgYAmmMi1UGABx3Emx0CdpskdDjwG0558g7dC6vFsbOmOFaUm5GHPvBE
         S1F0YeYK3j3uPkw6wdVSAHNbxeflySgypt2xhucwppzcztWigBIPWKr+3qRGwxrlOEo0
         uo4nn+0iLS+TzI0MCVKcM/g/7w/Kisi6N1YMjh2/vfOdUMZ3mtr+IDsIlVYEH1bDBccF
         AlkA==
X-Gm-Message-State: AFqh2kpYrL6ueXgnHPKpy8mVMFEB3iT8Ffq+rgamDrI+fdbOawepzttO
        HJo+VoSwk/6OzC2hGEaQtqo=
X-Google-Smtp-Source: AMrXdXubI9wZdraNMI5jqd9C9LrmrvW7xfQlhyy6EhVn4wgKVD/wRnVBGZUoCa/9IriOChnxMYohQw==
X-Received: by 2002:a62:5fc3:0:b0:580:ffa0:bfcf with SMTP id t186-20020a625fc3000000b00580ffa0bfcfmr2626684pfb.6.1673973095496;
        Tue, 17 Jan 2023 08:31:35 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id m190-20020a6258c7000000b005821c109cebsm15738694pfb.199.2023.01.17.08.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 08:31:35 -0800 (PST)
Message-ID: <95933f509d1a91eb60b3de87219aa15ac969988c.camel@gmail.com>
Subject: Re: [PATCH net] selftests/net: toeplitz: fix race on tpacket_v3
 block close
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>
Date:   Tue, 17 Jan 2023 08:31:34 -0800
In-Reply-To: <20230116174013.3272728-1-willemdebruijn.kernel@gmail.com>
References: <20230116174013.3272728-1-willemdebruijn.kernel@gmail.com>
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

On Mon, 2023-01-16 at 12:40 -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
>=20
> Avoid race between process wakeup and tpacket_v3 block timeout.
>=20
> The test waits for cfg_timeout_msec for packets to arrive. Packets
> arrive in tpacket_v3 rings, which pass packets ("frames") to the
> process in batches ("blocks"). The sk waits for req3.tp_retire_blk_tov
> msec to release a block.
>=20
> Set the block timeout lower than the process waiting time, else
> the process may find that no block has been released by the time it
> scans the socket list. Convert to a ring of more than one, smaller,
> blocks with shorter timeouts. Blocks must be page aligned, so >=3D 64KB.
>=20
> Somewhat awkward while () notation dictated by checkpatch: no empty
> braces allowed, nor statement on the same line as the condition.

You might look at using a do/while approach rather than just a straight
while. I believe that is the pattern used at various points throughout
the kernel when you do nothing between the braces. I know we have
instances of "do {} while (0)" throughout the kernel so that might be a
way to go.

