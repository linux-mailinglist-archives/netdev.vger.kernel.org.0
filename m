Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A846E6BF9
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 20:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbjDRSTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 14:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbjDRSTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 14:19:51 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81CCB443;
        Tue, 18 Apr 2023 11:19:39 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id c9so36703613ejz.1;
        Tue, 18 Apr 2023 11:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681841978; x=1684433978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ylPwdNK9CvTcmINrlcUSqBlr2q/Mwh4cgMQpRZCg1+M=;
        b=TUYA83PXPS4zxdr0aRRSja0YYF5axkvnmYblfPY1/xvnhmnkbRoIphKIFLha0xxcBC
         fvkS4ABVVGFsR4qjrEPOUO6I8rfOAqxNCP3b453zPcZsN61bPjFQpCVsHWKw/Es4vkSQ
         hcqVmJ1BsgCo8g9eumpfJRhhWPZJjjmkZCEs7yGaglUql5iYw/pKeOCUg+0anhv8SfNX
         8+RGHeP/syeDvpJHMHvEFagLkljHpYzMyf3tn6uD3DaopEdYvMUtM5asbJFdbMEoZWdN
         524L2yY6l9zAt8UhniUeIfrPOoRGsdNPRJmxXwTapYKDFl9hP/Nc7XVCbtv1ybZTUWYo
         g3NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681841978; x=1684433978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ylPwdNK9CvTcmINrlcUSqBlr2q/Mwh4cgMQpRZCg1+M=;
        b=BuwG6wkakdsgC7b945d9aRPBGQX93zEsGPvoasxuyoPLyBnB63ff6qVhWj4Crjp9E1
         +Q9JAHLztT5qJsgoyy764kWfzwijg9XLWqX8fv00hbLC5Wvajg8y8vaSs9TkFuehW3aq
         gajMRmnkiPC9bP1/QsAw8YNHEBDWWSYcax83FbfBt39/1UnIRt2gFjysZ1aj8bLg/MDc
         af7WqRRa1vYFkFm87mzJDkf1vBV8r2C1UIiWOOMs9J0IMmsQN1SOvcsIhevgpBTHc500
         nsdpyqaOGZfF+GfyHdXTkpoWPPFEoHXpW2nXfmriRq6I8D0ZRzbb9OFh4sFTDzUaHgHE
         NQXQ==
X-Gm-Message-State: AAQBX9chZHkajYRI7axTUhxXheR/8BiQ95ZKXAo1PRCfDNlCR5ABTFMZ
        NJrWAIeHTr+tqH537zAOyUD7zh3C6FSIQnpuVno=
X-Google-Smtp-Source: AKy350bdK9KjLnkMd+w2enZnKWXyg4i+jzJnWo/V9B/TYZz6uCow3e6JqrHd83bf8ZI3rBOweqXUQ5DcY5HUEJk0ZJE=
X-Received: by 2002:a17:907:72c2:b0:953:37d8:75e5 with SMTP id
 du2-20020a17090772c200b0095337d875e5mr642920ejc.3.1681841978207; Tue, 18 Apr
 2023 11:19:38 -0700 (PDT)
MIME-Version: 1.0
References: <4f1ca6f6f6b42ae125bfdb5c7782217c83968b2e.1681767806.git.lorenzo@kernel.org>
In-Reply-To: <4f1ca6f6f6b42ae125bfdb5c7782217c83968b2e.1681767806.git.lorenzo@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Apr 2023 11:19:26 -0700
Message-ID: <CAADnVQJEP8MeKRP+n1xMD=RiV7byvHYWTfqGL7+Y+nGbd3xYRw@mail.gmail.com>
Subject: Re: [PATCH net] veth: take into account peer device for
 NETDEV_XDP_ACT_NDO_XMIT xdp_features flag
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Jussi Maki <joamaki@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 2:54=E2=80=AFPM Lorenzo Bianconi <lorenzo@kernel.or=
g> wrote:
>
> For veth pairs, NETDEV_XDP_ACT_NDO_XMIT is supported by the current
> device if the peer one is running a XDP program or if it has GRO enabled.
> Fix the xdp_features flags reporting considering peer device and not
> current one for NETDEV_XDP_ACT_NDO_XMIT.
>
> Fixes: fccca038f300 ("veth: take into account device reconfiguration for =
xdp_features flag")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied to bpf tree.
