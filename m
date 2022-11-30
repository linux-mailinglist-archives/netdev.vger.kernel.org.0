Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202EC63E30D
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiK3WGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiK3WGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:06:41 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC4D81D9B
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:06:39 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id a27so12137351qtw.10
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rX+ZUws6cl82GsAaPP4m17Ggym3SI9uqnf7uiG80fgY=;
        b=WCMLeoqQnFlJMXU7pudgE+fwSQ4QRiBt7Gr1UvzGQ8QskWOEE6ykftGZ5m6zdXNZev
         IHnNbIU6XeVA32iTx+u0mDyrVl9AB12FTz4SZ//ssi8A0w8b80f4G05nYs17S24PvgKS
         ZLexRKfUDqtL5ugIQ5izE4hM4kcp6573xGiyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rX+ZUws6cl82GsAaPP4m17Ggym3SI9uqnf7uiG80fgY=;
        b=3D5/hRUUleEsCypeQLqERpvJE2UWMQD9GiFRSuMZ+DsE5jz3vNGMe5d4CZ/IyYmWAY
         ytV+fcftNwFu670vU4EZT9axOCHb0zqbiHkX5T09GDjeJHv4WcN8moscbSOMFxisWTGO
         XXxsh4sWq0D3F7vT1nv10iai8ORdWIFlRi+axhjFVCv3Z/zh5IsGWSO1mp60o0izs8cj
         laOmTDC7b7CRJtMZi96FgGu9nlIR13YyLrXEA3oGW7SnfH/8hbcFYYPV7IA6STHTUSzx
         CdkNGnNPAt+sLD25NBb/gX6Fy97ZRSqaAyKoW5prZ2rbTwbxnJWvbByQRk0101pxzgSr
         g28Q==
X-Gm-Message-State: ANoB5pmO1GtOF2N6zjCNi2c2GhQkUoy0OZHBehhfEgBrFDTr5aWx4KUa
        v4lzkEmDZHjD7fxJOIEA8ayMlQ==
X-Google-Smtp-Source: AA0mqf6+h4d4Z8JlD8zXl8+WJRvSVupKapoVTjNQyoPHTiU8Ixz26K48qHX2+tRLqgJKOX03xjLDQg==
X-Received: by 2002:ac8:47c5:0:b0:3a5:6a0e:db3c with SMTP id d5-20020ac847c5000000b003a56a0edb3cmr59808343qtr.398.1669845998925;
        Wed, 30 Nov 2022 14:06:38 -0800 (PST)
Received: from smtpclient.apple (c-73-148-104-166.hsd1.va.comcast.net. [73.148.104.166])
        by smtp.gmail.com with ESMTPSA id v15-20020a05620a440f00b006ecfb2c86d3sm2035850qkp.130.2022.11.30.14.06.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 14:06:35 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Joel Fernandes <joel@joelfernandes.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH rcu 14/16] rxrpc: Use call_rcu_hurry() instead of call_rcu()
Date:   Wed, 30 Nov 2022 17:06:33 -0500
Message-Id: <5160D22D-1E2E-486C-BADF-CDEB752028C3@joelfernandes.org>
References: <20221130214327.GU4001@paulmck-ThinkPad-P17-Gen-1>
Cc:     David Howells <dhowells@redhat.com>, rcu@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
In-Reply-To: <20221130214327.GU4001@paulmck-ThinkPad-P17-Gen-1>
To:     paulmck@kernel.org
X-Mailer: iPhone Mail (19G82)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 30, 2022, at 4:43 PM, Paul E. McKenney <paulmck@kernel.org> wrote:
>=20
> =EF=BB=BFOn Wed, Nov 30, 2022 at 02:20:52PM -0500, Joel Fernandes wrote:
>>=20
>>=20
>>>> On Nov 30, 2022, at 2:09 PM, David Howells <dhowells@redhat.com> wrote:=

>>>=20
>>> =EF=BB=BFNote that this conflicts with my patch:
>>=20
>> Oh.  I don=E2=80=99t see any review or Ack tags on it. Is it still under r=
eview?
>=20
> So what I have done is to drop this patch from the series, but to also
> preserve it for posterity at -rcu branch lazy-obsolete.2022.11.30a.
>=20
> It looks like that wakeup is still delayed, but I could easily be
> missing something.
>=20
> Joel, could you please test the effects of having the current lazy branch,=

> but also David Howells's patch?  That way, if there is an issue, we can
> work it sooner rather than later, and if it all works fine, we can stop
> worrying about it.  ;-)

Sure, I will kick off the failing test and see if it passes with Davids patc=
h. Will let you know.

Thanks,

 - Joel


>                            Thanx, Paul
>=20
>> Thanks,
>>=20
>> - Joel
>>=20
>>=20
>>=20
>>>=20
>>>   rxrpc: Don't hold a ref for connection workqueue
>>>   https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/=
commit/?h=3Drxrpc-next&id=3D450b00011290660127c2d76f5c5ed264126eb229
>>>=20
>>> which should render it unnecessary.  It's a little ahead of yours in the=

>>> net-next queue, if that means anything.
>>>=20
>>> David
>>>=20
