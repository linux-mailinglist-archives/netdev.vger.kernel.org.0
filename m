Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D766DE017
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjDKPzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjDKPzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:55:33 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C31AE74
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:55:32 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id bv15so6878282ybb.1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681228532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BXXNSX5ghhzT6MnaUfBRMGYusQziCghEVS+Bs5VIfQs=;
        b=YT6P7ds6alSzdGkj29iecdsWacmdeDoHBVaBkIgkWEPfXDXyrXEA3AbsGtWDZm9Ahc
         sdycnsmKdLpxoNFe6HNh+AJkcSzfGd6PwUdfEUi0BD77o1cxUVjRqVS57TR/+nZ8H715
         o/IliBqUZ4KPX5HlJC8ivd8z/QeLXeomvuqfNa5T6WexD2I0CcbjtGIPvu8dGHFKDePb
         c519+Xontj1+GYPvyw0pX6MNVkZbDuebTSYTZ4W3T53NtMLgjMkKw7jNNa406vTXWe2C
         L9mOjnqbq02Izlri3F+EMtA4shbOvALknmNu19w2puNCTw64nWC4MneDaGxsLorshgzF
         wdVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681228532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BXXNSX5ghhzT6MnaUfBRMGYusQziCghEVS+Bs5VIfQs=;
        b=tnoOjG3pGQeuoKibFbu2ZaNVpa7GfVmI/wj2DGDo2fsjhQWwHYs7pgunxqWu5W+Ynd
         5AVBj2mp0BDKzUcRu65gNd1kX2L7D3bzF4veQ9AvjRMRowFH3dIHPieL0qPRMQfBC+6F
         qAdfh6pRsGRFAaMFdklLdkaADmNA/clRz8iTWwvjLajKo6ZUeV3CmqSOJKgE+3oaFGU9
         9D6DGYUJG5j8H1H8tLN/BVo56NBgfzu8JL3IMRSJn9h6i3al6Yopi8nfwQTulBLqlcJ6
         lHP2w+Ec9oj9cKzPJVshoFn56PFVklTX33+Oh3js2ahkqcWQvBggZUmOhx43ThdLp66W
         Ts3A==
X-Gm-Message-State: AAQBX9eSB6LWXWg8PiDinVLtsnBwwgVihFuUB6RqNzgykK+VOEoEBkGX
        QNhc4114SsuBpp9ws0uiGfF4QabWyHSLXBSse734QhU6tvuY1TsD7vrXFg==
X-Google-Smtp-Source: AKy350abHQ1yw8w8bXvKfFwd/sK5aouga6u854LqOL8T5MSBQynR6puRHXVQ/33yNnI7XrPqyqZUTfLGDlBjIIrkJMo=
X-Received: by 2002:a25:cf91:0:b0:b8f:32c4:5cc4 with SMTP id
 f139-20020a25cf91000000b00b8f32c45cc4mr247759ybg.4.1681228531635; Tue, 11 Apr
 2023 08:55:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230411013323.513688-1-kuba@kernel.org>
In-Reply-To: <20230411013323.513688-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 11 Apr 2023 17:55:20 +0200
Message-ID: <CANn89iL40Jyp0MNOxY2wxPy+tduXU_688iN-diYATj5PhH24eg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] net: use READ_ONCE/WRITE_ONCE for ring index accesses
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 3:33=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> Small follow up to the lockless ring stop/start macros.
> Update the doc and the drivers suggested by Eric:
> https://lore.kernel.org/all/CANn89iJrBGSybMX1FqrhCEMWT3Nnz2=3D2+aStsbbwpW=
zKHjk51g@mail.gmail.com/
>
> Jakub Kicinski (3):
>   net: docs: update the sample code in driver.rst
>   bnxt: use READ_ONCE/WRITE_ONCE for ring indexes
>   mlx4: use READ_ONCE/WRITE_ONCE for ring indexes
>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.
