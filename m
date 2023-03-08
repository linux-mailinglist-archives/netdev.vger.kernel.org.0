Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B386B0355
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 10:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbjCHJrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 04:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjCHJqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 04:46:53 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA60B8557
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 01:45:59 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id p16so9395918wmq.5
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 01:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678268757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ty12+nLrZzZRFPyE/5xCHmQ1gSeqrVNRX0+UN6AcEvs=;
        b=Bo8R0BiS+Y8YaIo1e8mE6z62fZO2YRstGgC+BiU0UtDlAPcABLiBzqS0zpvWr5x73o
         rQTpTCzhp1w4zQaDHomzQBkHY31p4C3jxjoE9xkxBrR9RZmR/tBIRyBPhPiisfLaFfxE
         FNW7s7N4U3BM3m/hPK5f2Vq8dNx0xCVA/L2EEbKJv0DolomSQIk0m1FW0zhFP+stjXRs
         ia/YQVLcN2pINSuFZeuqUEsGLAjomKGvhuIZrIW7jhLl1TW1mS/NgEAQAUcCdp05sIQj
         ukpYpc6MJR6chPKQx6OkD0Fzv18ytjrIOIqviRaYa8g2CWPewdimxqAiWGQxlWHHuk7J
         B9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678268757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ty12+nLrZzZRFPyE/5xCHmQ1gSeqrVNRX0+UN6AcEvs=;
        b=QHnH6QEF524Mv+sO9M1PKjchz/s27ZHEDCsKO9OmKci4PjSvnXuudpHEklSuxVtDVe
         xXNdKoLekrVBAJM5OmnmNXULSv8FbdfXTLS2doenWKkz8lYE/amaASCeGXWQ+Bzp6Wrn
         Fi/1I3Zup4R1sUtnaeiMnmU0EBKGU81Nc9C7CYF4MXgvA4Lnjuv3jVuYq1LS0eVYteNF
         d6GyZ+Bt3iTlLPYii4cnYSz0KmE2wGpBxwPlFjfK+3eyjs8ywptTqqvGIQKq4UU/KBjj
         VnoGBKRmpD7F0Kq5mVp5bNLueUfKex6PYxYqksekQF7uKA/tTKzATLn74esZ/sGESpdG
         ++tQ==
X-Gm-Message-State: AO0yUKWpUOjGZLa5gLUAaTq7s9O8AqubkIs1hKwykmXTfXOlEG0bCifJ
        vNDSt2uN4PvN/GcsEN8PFjjqkpfpzavRTPSdkgtqrQ==
X-Google-Smtp-Source: AK7set+xxY1JtZ4a0+A5Ndip55cSbLE+PPFEk2K9wHakPb4oduun87X7EcgJFx0oOrF9VuSVtYF58yO02J1S9LUH8Ks=
X-Received: by 2002:a7b:c2a2:0:b0:3eb:5a1e:d52c with SMTP id
 c2-20020a7bc2a2000000b003eb5a1ed52cmr3657640wmk.2.1678268757575; Wed, 08 Mar
 2023 01:45:57 -0800 (PST)
MIME-Version: 1.0
References: <20230308021153.99777-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230308021153.99777-1-kerneljasonxing@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Mar 2023 10:45:45 +0100
Message-ID: <CANn89iJXiBvLMK7uC9MHmtt7gWd50oopqBn0dEC_Per=dFbVzg@mail.gmail.com>
Subject: Re: [PATCH v4 net-next] udp: introduce __sk_mem_schedule() usage
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     simon.horman@corigine.com, willemdebruijn.kernel@gmail.com,
        davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Mar 8, 2023 at 3:13=E2=80=AFAM Jason Xing <kerneljasonxing@gmail.co=
m> wrote:
>
> From: Jason Xing <kernelxing@tencent.com>
>
> Keep the accounting schema consistent across different protocols
> with __sk_mem_schedule(). Besides, it adjusts a little bit on how
> to calculate forward allocated memory compared to before. After
> applied this patch, we could avoid receive path scheduling extra
> amount of memory.
>
> Link: https://lore.kernel.org/lkml/20230221110344.82818-1-kerneljasonxing=
@gmail.com/
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
>

Reviewed-by: Eric Dumazet <edumazet@google.com>
