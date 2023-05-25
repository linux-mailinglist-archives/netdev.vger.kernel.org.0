Return-Path: <netdev+bounces-5296-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55949710A43
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:45:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F86D2812BF
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070C8E573;
	Thu, 25 May 2023 10:45:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2FFD2EB
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 10:45:43 +0000 (UTC)
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774B6199
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:45:42 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-75ca95cd9b1so9971785a.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685011541; x=1687603541;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bKttB3WcJdaHdzy4P80YHhy+V1bvEzmZ/qzOTLgj4nw=;
        b=ZOwLs3j9Z5t4Dkel5ngICYvigbO9aXnKUuBRRFUuRNqaI5q5JhRPdFNyRpm9naWytY
         Q9zdAGAvA/AkxEg6o7Ra6kKmxK/4sBGBsduNiUAAnJ47aG3KR0bSAigHezUxbFYmrONo
         rYOYTLdiulH58TfzOX2lX9URJcPNe485SbwT0zKFfmrE5tfYKJZekBhxW1iMEeJ790oP
         wqJiUYkRT6ocXhhph1AfJd9ItTYOXW72QFbBdr6UbkHqmmNdC63dN5SmuiP2SebTffp/
         oV99cJJ5SCE78AJJD+yJRirgQBphisOokMJNwdvP/Azynjqp3nzKZpODCqTVBKwrPWt9
         k9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685011541; x=1687603541;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bKttB3WcJdaHdzy4P80YHhy+V1bvEzmZ/qzOTLgj4nw=;
        b=S4szCz4OtrP5HfvBzyQ5iWso08YoyTwqPWF9hsICtbXwDFz8D/JAZmJ8jT8FF0G/ds
         SHKNr+v5p6Jp0kNzQZLPp7DrIySIO4BynLWuuVreBemxKPU+W/pcVHpxSAy2nk1n/Ikq
         wkyUyMaLSTQAC2bppY0St4WmAkmi/tquNUTql3xB8HpC0U1H5YwVvWWutlgAXOr4ppA7
         DobEZzA40fmogWP5uBN9dP6y6RLvS3I3QQYovTur01Z+UhkSrnzoTz6LG0wAg7/+tQp5
         I1rirtt2V66m0jTx9NdsqDu2ORiYZjfyU8lf6MswmHbYWKvrVYEf/9raOLeOwEgBx7Fb
         Ceyw==
X-Gm-Message-State: AC+VfDz6TalH34gxvmDQ3wo0kLKlnpcYjkBmN14x103dZ9mZZvEM8RLh
	WGIbGQECvbdh9VN15DXNjhQ=
X-Google-Smtp-Source: ACHHUZ4QbGBBzbBBoS0rBTYdt9aOdrpmt9LtMkwPlKCTwY7U1+fhNgzafxTSohphYdnF30xrq74Hjg==
X-Received: by 2002:a05:6214:c63:b0:5ef:7e33:c6c9 with SMTP id t3-20020a0562140c6300b005ef7e33c6c9mr779899qvj.38.1685011541482;
        Thu, 25 May 2023 03:45:41 -0700 (PDT)
Received: from imac ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id mn6-20020a0562145ec600b0060530c942f4sm316820qvb.46.2023.05.25.03.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 03:45:41 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net,  netdev@vger.kernel.org,  edumazet@google.com,
  pabeni@redhat.com
Subject: Re: [PATCH net] tools: ynl: avoid dict errors on older Python versions
In-Reply-To: <20230524170712.2036128-1-kuba@kernel.org> (Jakub Kicinski's
	message of "Wed, 24 May 2023 10:07:12 -0700")
Date: Thu, 25 May 2023 11:45:28 +0100
Message-ID: <m28rdclmev.fsf@gmail.com>
References: <20230524170712.2036128-1-kuba@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jakub Kicinski <kuba@kernel.org> writes:

> Python 3.9.0 or newer supports combining dicts() with |,
> but older versions of Python are still used in the wild
> (e.g. on CentOS 8, which goes EoL May 31, 2024).
> With Python 3.6.8 we get:
>
>   TypeError: unsupported operand type(s) for |: 'dict' and 'dict'
>
> Use older syntax. Tested with non-legacy families only.
>
> Fixes: f036d936ca57 ("tools: ynl: Add fixed-header support to ynl")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: donald.hunter@gmail.com
>
> This is arguably not a fix, but those trying YNL on 6.4 will likely
> appreciate not running into the problem.

I just hit the issue on Ubuntu on a BF2 so thank you for getting a fix
out before me! Tested with ovs_datapath.

Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Tested-by: Donald Hunter <donald.hunter@gmail.com>

