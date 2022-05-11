Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD3D523501
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244344AbiEKOIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237330AbiEKOIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:08:23 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18F56971F;
        Wed, 11 May 2022 07:08:22 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id u3so3188527wrg.3;
        Wed, 11 May 2022 07:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6jHNhIsFp4kduaT2yzDM1C+aRYIR1whbjUh2B6pI8SQ=;
        b=ki+e9B+flOmXxUYcJBP9bxaV3kq4Wac2vKzGA6BCZbEvrpMpEi5spJFrATDTNoypYu
         XQ0ZXurwdBXhjDixj/4mB7hNtsczj2m1xNSbn7UNCezVXsKdgnfWufHQx1URjr3rydhl
         iWDBn11jqQ060ydDyJBzNwKNr4fVz1SXR9cjWZewaJlZfqTmoJK9HED5nb14gd5E9i1r
         qhwTjSHri2qLkIb1zdKWK7x6y712g7XUZBJEs2S3YtSbVcNOBTF/aYYEuYPDq3eIiyCO
         togM8wU051aktMlPpcbDeXjO0SQ1INhZMjqV4XlGaktNkpUWlWiCFoQRVzgEzrg6VnMX
         03sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6jHNhIsFp4kduaT2yzDM1C+aRYIR1whbjUh2B6pI8SQ=;
        b=jbRTQdvFW/u4Bf4A8+QhiXer9oMVlMWNlD0Edg4kSqFg4mnz+6FbkD/mUa+15RKkW5
         IO39WqAI8LpwCpIEJ/3rb+9ZdUTRgZRthqyJZk33w1opsRzG3nFMEYGTFajhlZsMDyXb
         8nKE9VjeLD+D/+Y1ZUgburlAbclfU/IhEwAIFgWJuGihpu78VX6cVXMUuCElq87J1vOO
         fn0E3D4XFTS2Eoue0W66jzOTPduSxXGv4TWdM117cTvT+Ri1r1Rro1Xd3dGI/K6vXK1o
         /pXZccAyaYfbc2es0vzCBiCu0UYT/8v3ZD5Pry8muOTig9JRtUdQ3PIE/7hwbWMpTdVp
         zicw==
X-Gm-Message-State: AOAM531vlZZCg1mdcADPXcd+MlClOHTFnMy9+xDXQD0cKtU0ig2QB0eB
        kuOO/0bx/iPJznE0CjES3rVRCmnmbG4qYYz6kpw=
X-Google-Smtp-Source: ABdhPJzdUeNU3ksgOnYentscHO/iMG9lPOYZzjBIeZSgy49gmT7l/Poen8MG6Wu5mPHLrklE7pY0p5hRkRxMh5yDN/A=
X-Received: by 2002:adf:decb:0:b0:20a:c975:8eec with SMTP id
 i11-20020adfdecb000000b0020ac9758eecmr23553299wrn.438.1652278101189; Wed, 11
 May 2022 07:08:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220510115604.8717-1-magnus.karlsson@gmail.com>
In-Reply-To: <20220510115604.8717-1-magnus.karlsson@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 11 May 2022 16:08:09 +0200
Message-ID: <CAJ+HfNgfS9-rrtUoqN5LeNMdQ+h5s=8f7UWmfOUox8Y5H=3_AQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/9] selftests: xsk: add busy-poll testing plus
 various fixes
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
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

On Tue, 10 May 2022 at 13:56, Magnus Karlsson <magnus.karlsson@gmail.com> w=
rote:
>
> This patch set adds busy-poll testing to the xsk selftests. It runs
> exactly the same tests as with regular softirq processing, but with
> busy-poll enabled. I have also included a number of fixes to the
> selftests that have been bugging me for a while or was discovered
> while implementing the busy-poll support. In summary these are:
>

Nice additions, and nice cleanups. Awesome, Magnus!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
